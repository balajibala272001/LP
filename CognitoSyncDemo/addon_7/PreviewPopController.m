//
//  PreviewPopController.m
//  CognitoSyncDemo
//
//  Created by SG's Mac on 10/04/24.
//  Copyright © 2024 Behroozi, David. All rights reserved.
//

#import "PreviewPopController.h"
#import "CaptureScreenViewController.h"
#import "AVFoundation/AVFoundation.h"
#import <AVKit/AVKit.h>
#import "Reachability.h"
#import "UIView+Toast.h"


@interface PreviewPopController ()
{
    
    CMTime backwardTime;
    CMTime forwardTime;
    AVPlayerViewController *playerViewController;
    CGFloat angle;
    CGFloat sw, sh;
}
@end

@implementation PreviewPopController

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imagePreview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // Center the image view within the scroll view as it zooms
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    self.imagePreview.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                         scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.PreviewView.image = self.Image;
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    CGFloat screenHeight = CGRectGetHeight(self.view.frame);
    
    angle = 0.0;
    // Pass the size to the capture screen
    CaptureScreenViewController *captureScreenVC = [[CaptureScreenViewController alloc] init];
    captureScreenVC.previewScreensize = CGSizeMake(screenWidth, screenHeight);

    // Present the capture screen
    [self presentViewController:captureScreenVC animated:YES completion:nil];

    NSLog(@"Screen Width: %.0f, Screen Height: %.0f", screenWidth, screenHeight);
    
    self.isPlaying = YES;

    // Set up timer for updating progress and time labels
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updatePlaybackTime) userInfo:nil repeats:YES];
    NSArray *extentionArray = [self.videourl componentsSeparatedByString:@"."];
    if (![extentionArray[extentionArray.count - 1] isEqualToString:@"mp4"]) {
           // Image is available, display the image
       //self.PreviewView.image = self.Image;
       self.PreviewView.hidden = YES;
       self.ProgView.hidden = YES;
       self.GoPlayBtn.hidden = YES;
       self.GobackwardBtn.hidden = YES;
       self.GoFrwdBtn.hidden = YES;
       self.Lefttimer.hidden = YES;
       self.Righttimer.hidden = YES;
     self.subView.hidden = YES;
     self.fullScreenBtn.hidden = YES;
     self.DeleteBtn.hidden = YES;
       // Set the image view's frame to match the size of the view
       
      // self.PreviewView.frame = self.view.bounds;
       self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.delegate = self;
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 4.0;
     [self.view addSubview:self.scrollView];
        
        self.imagePreview = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        self.imagePreview.contentMode = UIViewContentModeScaleAspectFit;
       //self.imagePreview.image = self.Image;
       //NSURL *url = [NSURL URLWithString: self.videourl];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.videourl]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                self.imagePreview.image = [UIImage imageWithData: data];
            });
            //[data release];
        });
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:data];
//        if (image) {
//            self.imagePreview.image = image;
//        } else {
//            NSLog(@"Failed to load image from URL: %@", self.Image);
//        }
     [self.scrollView addSubview:self.imagePreview];
        
        self.scrollView.contentSize = self.imagePreview.frame.size;

       UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [closeButton setImage:[UIImage imageNamed:@"cancel_new.png"] forState:UIControlStateNormal];
       [closeButton addTarget:self action:@selector(CancelTapped:) forControlEvents:UIControlEventTouchUpInside];
       CGFloat sw = [UIScreen mainScreen].bounds.size.width;
       [closeButton setFrame:CGRectMake(sw - 50, 50, 40, 40)]; // Set the frame as per your requirement
       [self.view addSubview:closeButton];

       } else {
           
           // Video is available, display the video
           sw = self.view.bounds.size.width;
           sh = self.view.bounds.size.height;
           // Set the new width, height
//           self.subView.frame = CGRectMake(50, 50, (self.view.frame.size.height*0.90),(self.view.frame.size.width*0.90));
           @try {
               NSURL *url = [NSURL fileURLWithPath:self.videourl];
               if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
                   AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url];
                   self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
                   playerViewController = [[AVPlayerViewController alloc] init];
                   playerViewController.player = self.player;
                   playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
                   playerViewController.view.frame = CGRectMake(0,0, self.PreviewView.frame.size.width, self.PreviewView.frame.size.height);
                   [self.PreviewView addSubview:playerViewController.view];
                   
                   [playerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
                   
                   // Add observer for time updates
                   [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
                   [self presentViewController:playerViewController animated:YES completion:^{
                       [self.player play];
                   }];
               }else {
                   [self.view makeToast:NSLocalizedString(@"No Internet!",@"") duration:2.0 position:CSToastPositionCenter];
               }
           } @catch (NSException *exception) {
               NSLog(@"error");
           }
           
        self.PreviewView.hidden = NO;
        self.ProgView.hidden = NO;
        self.GoPlayBtn.hidden = NO;
        self.GobackwardBtn.hidden = NO;
        self.GoFrwdBtn.hidden = NO;
        self.Lefttimer.hidden = NO;
        self.Righttimer.hidden = NO;
          // [player play];

       }
    self.view.backgroundColor = UIColor.clearColor;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
   // self.subView.backgroundColor = UIColor.whiteColor;

}

// Observer callback method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.player.currentItem && [keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            // Video is ready to play, start playback
            [self.player play];
            [self.GoPlayBtn setImage:[UIImage imageNamed:@"pause_new.png"] forState:UIControlStateNormal];
            // Add periodic time observer to update progress bar
            __weak typeof(self) weakSelf = self;
            [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                CGFloat duration = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
                CGFloat currentTime = CMTimeGetSeconds(weakSelf.player.currentTime);
                if (!isnan(duration) && !isnan(currentTime) && duration > 0) {
                    // Update progress bar
                    weakSelf.ProgView.progress = currentTime / duration;
                    if(currentTime == duration){
                        // Reset player to beginning
                        [self.player seekToTime:kCMTimeZero];
                        [self.player pause];
                        // Set the pause image
                        [self.GoPlayBtn setImage:[UIImage imageNamed:@"play_new.png"] forState:UIControlStateNormal];
                        self.isPlaying = false;
                    }
                }
            }];
        }
    }
}

- (IBAction)screenRotation:(id)sender {
    // Calculate the rotation angle
    if(angle == 0.0){
        angle = M_PI_2;
//
//        self.subviewWidthConst.constant = 100;
//        self.subviewHeightConst.constant  = 20;
//        [self.subView layoutIfNeeded];
//        self.subView.frame = CGRectMake(50, 50, 200,200);
    }else {
        angle = 0.0;
        //        self.subviewWidthConst.constant = 10;
//        self.subviewHeightConst.constant  = 10;
//        [self.subView layoutIfNeeded];
//        self.subView.frame = CGRectMake(50, 50, (self.view.frame.size.height*0.90),(self.view.frame.size.width*0.90));
    }
    
    // Rotate the view
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    self.subView.transform = transform;

}

-(void)viewWillDisappear:(BOOL)animated{
    if(self.player != nil){
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        
        // Pause the video
           [self.player pause];
           
           [self.player seekToTime:kCMTimeZero];
    }
}


- (void)updatePlaybackTime {
    CMTime duration = self.player.currentItem.duration;
    if (CMTIME_IS_VALID(duration)) {
        float currentTime = CMTimeGetSeconds(self.player.currentTime);
        float totalDuration = CMTimeGetSeconds(duration);
        
        self.ProgView.progress = currentTime / totalDuration;
        
        self.Lefttimer.text = [self formattedTime:currentTime];
        self.Righttimer.text = [self formattedTime:totalDuration];
    }
}

- (NSString *)formattedTime:(NSTimeInterval)timeInterval {
    NSInteger totalSeconds = (NSInteger)round(timeInterval);
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    }
}


- (IBAction)playButtonTapped:(id)sender {
    
    if (self.isPlaying) {
        // Pause the video
        [self.player pause];
        // Set the pause image
        [self.GoPlayBtn setImage:[UIImage imageNamed:@"play_new.png"] forState:UIControlStateNormal];

    } else {
        // Play the video
        [self.player play];
        
        // Set the play image
        [self.GoPlayBtn setImage:[UIImage imageNamed:@"pause_new.png"] forState:UIControlStateNormal];
    }
    
    self.isPlaying = !self.isPlaying;
    
}


- (IBAction)backwardTapped:(id)sender {
    
    // Get the current time of the player
       CMTime currentTime = self.player.currentTime;
       // Subtract a desired time interval from the current time (e.g., 5 seconds)
       CMTime newTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(5, 1));
       // Seek to the new time
       [self.player seekToTime:newTime];
    
}

- (IBAction)CancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)forwardTapped:(id)sender {
    
    // Get the current time of the player
       CMTime currentTime = self.player.currentTime;
       // Add a desired time interval to the current time (e.g., 5 seconds)
       CMTime newTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(5, 1));
       // Seek to the new time
       [self.player seekToTime:newTime];
}



@end
