//
//  CapturePreviewScreenController.h
//  CognitoSyncDemo
//
//  Created by SG's Mac on 02/04/24.
//  Copyright © 2024 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "AVFoundation/AVFoundation.h"
#import "SCLAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapturePreviewScreenController : UIViewController

@property (nonatomic, strong) UIImage *Image;

@property (weak, nonatomic) IBOutlet UIImageView *PreviewImage;


@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *GoBackward;
@property (weak, nonatomic) IBOutlet UIButton *GoForward;
@property (weak, nonatomic) IBOutlet UIButton *PlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;

- (IBAction)playButtonTapped:(id)sender;
- (IBAction)backwardTapped:(id)sender;
- (IBAction)forwardTapped:(id)sender;
- (IBAction)CancelTapped:(id)sender;

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic, assign) BOOL isPlaying;



@end



NS_ASSUME_NONNULL_END
