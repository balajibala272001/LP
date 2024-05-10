//
//  ViewController.h
//  ocr
//
//  Created by mac on 27/10/2563 BE.
//  Copyright © 2563 BE smartgladiator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TesseractOCR.h"
#import "SCLAlertView.h"
#import "ImageCropView.h"
@protocol ScannedDelegateView <NSObject>
-(void)sendStringViewController:(NSString *) string withTag :(NSInteger) tagNumber;
@end
@interface ViewController : UIViewController<G8TesseractDelegate,UIImagePickerControllerDelegate,ScannedDelegateView,UIGestureRecognizerDelegate,ImageCropViewControllerDelegate> {
    ImageCropView* imageCropView;
    UIImage* image;
    IBOutlet UIImageView *imageView;

}

- (IBAction)takeBarButtonClick:(id)sender;
- (IBAction)cropBarButtonClick:(id)sender;
- (IBAction)saveBarButtonClick:(id)sender;
@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;


@property(nonatomic,strong) SCLAlertView *alertbox ;
@property(nonatomic,weak)id<ScannedDelegateView>delegate;
@property (weak,nonatomic) NSString * img,*text;
@property (nonatomic,strong) UIImage * imager;
@property (nonatomic,assign) int tag;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

