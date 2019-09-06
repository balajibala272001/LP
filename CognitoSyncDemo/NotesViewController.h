//
//  NotesViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/14/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol sendNotesDataProtocol <NSObject>
-(void)notesData:(NSInteger *)indexPathRow changedData:(NSMutableDictionary *)dic;
@end

@interface NotesViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *txtview_Notes;


@property(nonatomic,weak)id<sendNotesDataProtocol>delegate;

@property (nonatomic) NSInteger *indexPathRow;
@property (strong,nonatomic)NSMutableDictionary *dictionaries;
@property (weak, nonatomic) IBOutlet UIView *sub_View;

- (IBAction)back_action_btn:(id)sender;

@end
