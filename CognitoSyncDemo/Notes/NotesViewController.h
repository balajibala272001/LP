    //
    //  NotesViewController.h
    //  CognitoSyncDemo
    //
    //  Created by mac on 9/14/16.
    //  Copyright © 2016 Behroozi, David. All rights reserved.
    //

#import <UIKit/UIKit.h>
#import "SCLAlertView.h"
#import "igViewController.h"
#import "ViewController.h"

@protocol sendNotesDataProtocol <NSObject>
-(void)notesData:(NSInteger *)indexPathRow changedData:(NSMutableDictionary *)dic;
@end
@interface NotesViewController : UIViewController<ScannedDelegateIGView,UIImagePickerControllerDelegate,ScannedDelegateView>{
    igViewController *IGVC;
}

@property(nonatomic,strong) SCLAlertView *alertbox ;
@property (weak, nonatomic) IBOutlet UITextView *txtview_Notes;


@property(nonatomic,weak)id<sendNotesDataProtocol>delegate;

@property (assign,nonatomic) int indexPathRow;
@property (strong,nonatomic)NSMutableDictionary *dictionaries;
@property (weak, nonatomic) IBOutlet UIView *sub_View;

- (IBAction)back_action_btn:(id)sender;
- (IBAction)scan:(id)sender;

@end
