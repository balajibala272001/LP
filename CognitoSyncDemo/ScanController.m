//
//  ScanController.m
//  BarcodeScanner
//
//  Created by Vijay Subrahmanian on 09/05/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import "ScanController.h"
#import "ProjectDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UITextView *scannedBarcode;
@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;

@end

@implementation ScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupScanningSession];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Start the camera capture session as soon as the view appears completely.
    [self.captureSession startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rescanButtonPressed:(id)sender {
    // Start scanning again.
    self.scannedBarcode.text = @"";
    [self.captureSession startRunning];
}

- (IBAction)copyButtonPressed:(id)sender {
    // Copy the barcode text to the clipboard.
    [UIPasteboard generalPasteboard].string = self.scannedBarcode.text;
    //characterLabel.text = [NSString stringWithFormat:@"%u", length];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.captureSession stopRunning];
    if (self.scannedBarcode.text.length >0) {
        [self.delegate sentTextViewController:self.scannedBarcode.text];
//        NSString *ScannedText = [[NSMutableString alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }
   // [self dismissViewControllerAnimated:YES completion:nil];
}

// Local method to setup camera scanning session.
- (void)setupScanningSession {
    // Initalising hte Capture session before doing any video capture/scanning.
    self.captureSession = [[AVCaptureSession alloc] init];
    
    NSError *error;
    // Set camera capture device to default and the media type to video.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Set video capture input: If there a problem initialising the camera, it will give am error.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    
    if (!input) {
        NSLog(@"Error Getting Camera Input");
        return;
    }
    // Adding input souce for capture session. i.e., Camera
    [self.captureSession addInput:input];
    
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // Set output to capture session. Initalising an output object we will use later.
    [self.captureSession addOutput:captureMetadataOutput];
    
    // Create a new queue and set delegate for metadata objects scanned.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("scanQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // Delegate should implement captureOutput:didOutputMetadataObjects:fromConnection: to get callbacks on detected metadata.
    [captureMetadataOutput setMetadataObjectTypes:[captureMetadataOutput availableMetadataObjectTypes]];
    
    // Layer that will display what the camera is capturing.
    self.captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.captureLayer setFrame:self.cameraPreviewView.layer.bounds];
    // Adding the camera AVCaptureVideoPreviewLayer to our view's layer.
    [self.cameraPreviewView.layer addSublayer:self.captureLayer];
}

// AVCaptureMetadataOutputObjectsDelegate method
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // Do your action on barcode capture here:
    NSString *capturedBarcode = nil;
    NSArray *supportedBarcodeTypes;
    // Specify the barcodes you want to read here:
    if (@available(iOS 15.4, *)) {
        supportedBarcodeTypes = @[AVMetadataObjectTypeUPCECode,                                                 AVMetadataObjectTypeCode39Code,
                                           AVMetadataObjectTypeCode39Mod43Code,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeCode93Code,
                                           AVMetadataObjectTypeCode128Code,
                                           AVMetadataObjectTypePDF417Code,
                                           AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeAztecCode,
                                           AVMetadataObjectTypeITF14Code,
                                           AVMetadataObjectTypeCodabarCode,
                                           AVMetadataObjectTypeMicroPDF417Code,
                                           AVMetadataObjectTypeMicroQRCode,
                                           AVMetadataObjectTypeGS1DataBarCode,
                                           AVMetadataObjectTypeGS1DataBarExpandedCode,
                                           AVMetadataObjectTypeDataMatrixCode,
                                           AVMetadataObjectTypeGS1DataBarLimitedCode,AVMetadataObjectTypeInterleaved2of5Code];
    } else {
        supportedBarcodeTypes =  @[AVMetadataObjectTypeUPCECode,                                                    AVMetadataObjectTypeCode39Code,
                                            AVMetadataObjectTypeCode39Mod43Code,
                                            AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode93Code,
                                            AVMetadataObjectTypeCode128Code,
                                            AVMetadataObjectTypePDF417Code,
                                            AVMetadataObjectTypeQRCode,
                                            AVMetadataObjectTypeAztecCode,
                                            AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeInterleaved2of5Code];
    }
        
    // In all scanned values..
    for (AVMetadataObject *barcodeMetadata in metadataObjects) {
        // ..check if it is a suported barcode
        for (NSString *supportedBarcode in supportedBarcodeTypes) {
            
            if ([supportedBarcode isEqualToString:barcodeMetadata.type]) {
                // This is a supported barcode
                // Note barcodeMetadata is of type AVMetadataObject
                // AND barcodeObject is of type AVMetadataMachineReadableCodeObject
                AVMetadataMachineReadableCodeObject *barcodeObject = (AVMetadataMachineReadableCodeObject *)[self.captureLayer transformedMetadataObjectForMetadataObject:barcodeMetadata];
                capturedBarcode = [barcodeObject stringValue];
                // Got the barcode. Set the text in the UI and break out of the loop.
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.captureSession stopRunning];
                    self.scannedBarcode.text = capturedBarcode;
                });
                return;
            }
        }
    }
}

@end
