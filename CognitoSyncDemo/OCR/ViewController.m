#import "ViewController.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIView+Toast.h"

@interface ViewController ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    
   
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem =leftBarButtonItem;
    

}

#pragma mark - UIImagePickerController Delegate

-(void)recognizeImageWithTesseract:(UIImage *)image
{
   
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];
    
        
    operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    
        
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
    
        
    operation.tesseract.maximumRecognitionTime = 2.0;
    
       
    operation.delegate = self;
    
       
    operation.tesseract.image = image;
    
        
    operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
            // Fetch the recognized text
        NSString *recognizedText = tesseract.recognizedText;
        
        NSLog(@"TEXT %@", recognizedText);
        
        
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"OCR Result" message:recognizedText preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            
            self.text=recognizedText;
            
            
            [ _delegate sendStringViewController:self.text withTag:self.tag];
            [[NSUserDefaults standardUserDefaults] setObject:self.text forKey:@"scanData"];
            [[NSUserDefaults standardUserDefaults] setInteger:self.tag forKey:@"scanDataTag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
          
        }];
        
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            imageView.image=self.imager;
            
            
        }];
        
       
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self presentViewController:alertController animated:true completion:nil];
        
        
        
       
    };
    
       
    [self.operationQueue addOperation:operation];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
   // NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to cancel recognition prematurely
}



- (void)viewWillAppear:(BOOL)animated{
    imageView.image=self.imager;
    image=self.imager;
    
    imageView.userInteractionEnabled = YES;
}


- (IBAction)clearCache:(id)sender
{
    [G8Tesseract clearCache];
}

- (IBAction)cropBarButtonClick:(id)sender {
    if(image != nil){
        ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
        controller.delegate = self;
        controller.blurredBackground = YES;
            // set the cropped area
            // controller.cropArea = CGRectMake(0, 0, 100, 200);
        [[self navigationController] pushViewController:controller animated:YES];
    }
}

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    image = croppedImage;
    imageView.image = croppedImage;
    CGRect cropArea = controller.cropArea;
    if (image != nil){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES ];
        
        imageView.image=image;
        
        [self recognizeImageWithTesseract:image];
        
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    imageView.image = image;
    
    [[self navigationController] popViewControllerAnimated:YES];
}


- (IBAction)saveBarButtonClick:(id)sender {
    if (image != nil){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES ];

        imageView.image=image;

        [self recognizeImageWithTesseract:image];

    }
}

- (IBAction)takeBarButtonClick:(id)sender {
//    imageView.image = image;
//    [[self navigationController] popViewControllerAnimated:YES];
    UIImagePickerController *imgPicker=[UIImagePickerController new];
    
    imgPicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *imag = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *path = [[self getUserDocumentDir] stringByAppendingPathComponent:@"ScanData"];
    NSString* imagePath = [path stringByAppendingPathComponent:@"scanner.jpg"];
    
        //    CGSize size= CGSizeMake(360, 480);
        //    UIImage *finalimage=[self imageWithImage:imag convertToSize:size];
        //
    [UIImageJPEGRepresentation(imag,1) writeToFile:imagePath atomically:true];
    self.img = imagePath;
    self.imager=imag;
    imageView.image=self.imager;
    image=self.imager;
    
    imageView.userInteractionEnabled = YES;
}

- (NSMutableString*)getUserDocumentDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [[paths objectAtIndex:0] mutableCopy];
    return path;
}

- (IBAction)cancel:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}
@end