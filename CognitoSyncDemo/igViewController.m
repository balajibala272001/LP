    //
    //  igViewController.m
    //  ScanBarCodes
    //
    //  Created by Torrey Betts on 10/10/13.
    //  Copyright (c) 2013 Infragistics. All rights reserved.
    //

#import <AVFoundation/AVFoundation.h>
#import "igViewController.h"
#import "ProjectDetailsViewController.h"
#import "AZCAppDelegate.h"

@interface igViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    UIView *_highlightView;
    UIView *_redLightView;
    UILabel *flashButton, *flashLabel;
    AZCAppDelegate *delegateVC;
    bool boolToRestrict;
    NSString *detectionString;
    bool popUpControl;
}
@end

@implementation igViewController

-(void)back_button:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    detectionString = nil;
    popUpControl = TRUE;
    boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem =leftBarButtonItem;
    self.navigationItem.title = NSLocalizedString(@"Data Scan",@"");
    _highlightView = [[UIView alloc] init];
    _highlightView.layer.borderColor = [UIColor redColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    _highlightView.frame  = CGRectMake((self.view.frame.size.width - 200)/2, (self.view.frame.size.height - 75)/2, 200, 75);
    
    [self.view addSubview:_highlightView];
    
    //flashmode
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    _output.rectOfInterest = _highlightView.bounds;
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer .videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
        //[_prevLayer addSublayer:_highlightView];
    
    [_session startRunning];
    
        // [self.view bringSubviewToFront:_label];
    [self.view bringSubviewToFront:_highlightView];
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![flashLight isTorchAvailable]){
        flashButton.hidden = true;
    }
    if ([flashLight isFlashAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOff]){
        flashButton = [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)+22, self.view.frame.size.height*0.10, 300, 30)];
        flashButton.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
        //flashButton.backgroundColor = [UIColor redColor];
        flashButton.textColor = [UIColor whiteColor];
        flashButton.textAlignment = NSTextAlignmentLeft;
        flashButton.text = NSLocalizedString(@"OFF",@"");
        flashButton.tag=1;
        flashButton.userInteractionEnabled=TRUE;
        [self.view addSubview:flashButton];
        
        flashLabel= [[UILabel alloc ]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, flashButton.frame.origin.y, 120, 30)];
        flashLabel.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:0];
        //flashLabel.backgroundColor = [UIColor blueColor];
        flashLabel.textColor = [UIColor whiteColor];
        flashLabel.textAlignment = NSTextAlignmentCenter;
        flashLabel.text = NSLocalizedString(@"Flash Mode:",@"");
        
        [self.view addSubview:flashLabel];
        [self.view bringSubviewToFront:flashButton];
        [self.view bringSubviewToFront:flashLabel];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flashToggle:)];
        [flashButton addGestureRecognizer:recognizer];
    }
    // Register for the notification
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(appDidEnterBackground)
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
}

- (void)appDidEnterBackground {
    // This method will be called when the app enters the background
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)flashToggle:(id)sender{
    [self flash];
}

-(void) flash{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
            if (flashButton.tag == 1) {
                flashButton.tag=0;
                flashButton.text = NSLocalizedString(@"ON",@"");
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }else if(flashButton.tag == 0){
                flashButton.tag=1;
                flashButton.text = NSLocalizedString(@"OFF",@"");
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
            [flashLight unlockForConfiguration];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"BarcodeVC";
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    if (_session != nil) {
        [_session startRunning];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [_session stopRunning];
    }
    [super viewWillDisappear:animated];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if(popUpControl== TRUE){
        if(detectionString == nil){
            AVMetadataMachineReadableCodeObject *barCodeObject;
            NSString *detectionString = nil;
            NSArray *barCodeTypes;
            if (@available(iOS 15.4, *)) {
                barCodeTypes = @[AVMetadataObjectTypeUPCECode,
                                 AVMetadataObjectTypeCode39Code,
                                 AVMetadataObjectTypeCode39Mod43Code,
                                 AVMetadataObjectTypeEAN13Code,
                                 AVMetadataObjectTypeEAN8Code,
                                 AVMetadataObjectTypeCode93Code,
                                 AVMetadataObjectTypeCode128Code,
                                 AVMetadataObjectTypePDF417Code,
                                 AVMetadataObjectTypeQRCode,
                                 AVMetadataObjectTypeAztecCode,
                                 AVMetadataObjectTypeITF14Code,
                                 AVMetadataObjectTypeDataMatrixCode,
                                 AVMetadataObjectTypeCodabarCode,
                                 AVMetadataObjectTypeInterleaved2of5Code,
                                 AVMetadataObjectTypeMicroPDF417Code,
                                 AVMetadataObjectTypeMicroQRCode,
                                 AVMetadataObjectTypeGS1DataBarCode,
                                 AVMetadataObjectTypeGS1DataBarExpandedCode,
                                 AVMetadataObjectTypeGS1DataBarLimitedCode];
            }else {
                barCodeTypes = @[AVMetadataObjectTypeUPCECode,
                                 AVMetadataObjectTypeCode39Code,
                                 AVMetadataObjectTypeCode39Mod43Code,
                                 AVMetadataObjectTypeEAN13Code,
                                 AVMetadataObjectTypeEAN8Code,
                                 AVMetadataObjectTypeCode93Code,
                                 AVMetadataObjectTypeCode128Code,
                                 AVMetadataObjectTypePDF417Code,
                                 AVMetadataObjectTypeQRCode,
                                 AVMetadataObjectTypeAztecCode,
                                 AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeInterleaved2of5Code ];
            }
            
            for (AVMetadataObject *metadata in metadataObjects) {
                for (NSString *type in barCodeTypes) {
                    if ([metadata.type isEqualToString:type]){
                        barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                        
                        detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                        break;
                    }
                    //break;
                }
                if (detectionString != nil){
                    NSLog(@"%ld",(long)self.txtTag);
                    //  [_delegate sendStringViewController:detectionString withTag:self.txtTag];
                    [[NSUserDefaults standardUserDefaults] setObject:detectionString forKey:@"scanData"];
                    [[NSUserDefaults standardUserDefaults] setInteger:self.txtTag forKey:@"scanDataTag"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.navigationController popViewControllerAnimated:YES];
                    popUpControl = FALSE;
                    NSLog(@"popUpControl");
                    break;
                }
                break;
            }
        }
    }
    NSLog(@"My view's frame is: %@", NSStringFromCGRect(_highlightView.frame));
    _highlightView.layer.borderColor = [UIColor redColor].CGColor;
}

- (IBAction)back_action_btn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
