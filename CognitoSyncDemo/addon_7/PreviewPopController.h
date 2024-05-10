//
//  PreviewPopController.h
//  CognitoSyncDemo
//
//  Created by SG's Mac on 10/04/24.
//  Copyright © 2024 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@interface PreviewPopController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *PreviewView;
@property (weak, nonatomic) IBOutlet UILabel *Lefttimer;
@property (weak, nonatomic) IBOutlet UILabel *Righttimer;
@property (weak, nonatomic) IBOutlet UIButton *GoFrwdBtn;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imagePreview;

@property (weak, nonatomic) IBOutlet UIButton *GoPlayBtn;

@property (weak, nonatomic) IBOutlet UIButton *GobackwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *DeleteBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *ProgView;

@property(nonatomic,strong) UIImage *Image;
@property(nonatomic,weak) NSString * videourl;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

- (IBAction)screenRotation:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subviewWidthConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subviewHeightConst;


@end


