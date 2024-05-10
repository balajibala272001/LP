//
//  CapturePreviewScreenController.m
//  CognitoSyncDemo
//
//  Created by SG's Mac on 02/04/24.
//  Copyright © 2024 Behroozi, David. All rights reserved.
//

#import "CapturePreviewScreenController.h"
#import "CaptureScreenViewController.h"


@interface CapturePreviewScreenController ()
{
    AVPlayer *player;
    CMTime backwardTime;
    CMTime forwardTime;
}
@end

@implementation CapturePreviewScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPlaying = YES;

    // Set up timer for updating progress and time labels
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updatePlaybackTime) userInfo:nil repeats:YES];
   
    if (self.Image && self.videoURL) {
           // Both image and video are available,display the video
           AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.videoURL];
           player = [AVPlayer playerWithPlayerItem:item];
           AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
           layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
           layer.frame = self.PreviewImage.layer.bounds;
           [self.PreviewImage.layer addSublayer:layer];
           
           self.PreviewImage.hidden = NO;
           self.progressView.hidden = NO;
           self.PlayBtn.hidden = NO;
           self.GoBackward.hidden = NO;
           self.GoForward.hidden = NO;
           self.leftTimeLabel.hidden = NO;
           self.rightTimeLabel.hidden = NO;
           
           [player play];
       }
  
   else if (self.Image) {
           // Image is available, display the image
           self.PreviewImage.image = self.Image;
           self.PreviewImage.hidden = NO;
           self.progressView.hidden = YES;
           self.PlayBtn.hidden = YES;
           self.GoBackward.hidden = YES;
           self.GoForward.hidden = YES;
           self.leftTimeLabel.hidden = YES;
           self.rightTimeLabel.hidden = YES;
       } 
    
    else if (self.videoURL) {
           // Video is available, display the video
           AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.videoURL];
           player = [AVPlayer playerWithPlayerItem:item];
           AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
           layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
           layer.frame = self.PreviewImage.layer.bounds;
           [self.PreviewImage.layer addSublayer: layer];
           
           self.PreviewImage.hidden = NO;
           self.progressView.hidden = NO;
           self.PlayBtn.hidden = NO;
           self.GoBackward.hidden = NO;
           self.GoForward.hidden = NO;
           self.leftTimeLabel.hidden = NO;
           self.rightTimeLabel.hidden = NO;
           
           [player play];
       }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    // Pause the video
       [player pause];
       
       [player seekToTime:kCMTimeZero];
}

- (void)updatePlaybackTime {
    CMTime duration = player.currentItem.duration;
    if (CMTIME_IS_VALID(duration)) {
        float currentTime = CMTimeGetSeconds(player.currentTime);
        float totalDuration = CMTimeGetSeconds(duration);
        
        self.progressView.progress = currentTime / totalDuration;
        
        self.leftTimeLabel.text = [self formattedTime:currentTime];
        self.rightTimeLabel.text = [self formattedTime:totalDuration];
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
        [player pause];
        
        // Set the pause image
        [self.PlayBtn setImage:[UIImage imageNamed:@"play_resume"]forState:UIControlStateNormal];

    } else {
        // Play the video
        [player play];
        
        // Set the play image
        [self.PlayBtn setImage:[UIImage imageNamed:@"pause"]forState:UIControlStateNormal];
    }
    
    self.isPlaying = !self.isPlaying;
    
}


- (IBAction)backwardTapped:(id)sender {
    
    // Get the current time of the player
       CMTime currentTime = player.currentTime;
       // Subtract a desired time interval from the current time (e.g., 5 seconds)
       CMTime newTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(5, 1));
       // Seek to the new time
       [player seekToTime:newTime];
    
}

- (IBAction)CancelTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)forwardTapped:(id)sender {
    
    // Get the current time of the player
       CMTime currentTime = player.currentTime;
       // Add a desired time interval to the current time (e.g., 5 seconds)
       CMTime newTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(5, 1));
       // Seek to the new time
       [player seekToTime:newTime];
}

@end
