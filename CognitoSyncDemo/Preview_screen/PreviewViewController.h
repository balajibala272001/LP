//
//  PreviewViewController.h
//  CognitoSyncDemo
//
//  Created by suganthi on 15/11/1941 Saka.
//  Copyright © 1941 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "SCLTextView.h"
#import "igViewController.h"
#import "SCLAlertView.h"


NS_ASSUME_NONNULL_BEGIN

@interface PreviewViewController : UIViewController<ScannedDelegateIGView,UIImagePickerControllerDelegate>
{
    UIImage* image;
    AVPlayerViewController *playerViewController;
    igViewController *IGVC;
    
}
@property (weak, nonatomic) IBOutlet UILabel *counter;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UIButton *note;
@property(strong, nonatomic) NSString *videopath;
@property(strong, nonatomic) NSString *extention;
@property NSMutableArray *array;
@property NSInteger current_index;
- (IBAction)notes:(id)sender;
@property (strong,nonatomic)NSMutableDictionary *dictionaries;
@property(nonatomic,strong) SCLTextView *textField ;
@property(nonatomic,strong) SCLAlertView *alertbox ;
@property (nonatomic,assign) int senderTag;

@end

NS_ASSUME_NONNULL_END
