//
//  PicViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/14/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesViewController.h"
#import "SiteData.h"
#import "ProjectDetailsViewController.h"



@interface PicViewController : UIViewController<sendNotesDataProtocol,senddataProtocol>{
    NotesViewController *notesVC;
  //  BOOL isEdit;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewToUpload;
@property (strong,nonatomic)NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *selected_CollectionView;
@property (weak, nonatomic) IBOutlet UIButton *single_btn;
- (IBAction)btn_single:(id)sender;
//image
@property (strong,nonatomic)NSMutableDictionary *oneImageDict;
@property (strong, nonatomic) IBOutlet UIView *sub_View;

@property (weak, nonatomic) IBOutlet UIImageView *notes_image_view;
@property (strong,nonatomic) SiteData *siteData;
@property (strong,nonatomic) NSString* pathToImageFolder;


- (IBAction)back_btn:(id)sender;

@property (weak,nonatomic) NSString *sitename;
@property NSMutableArray *oldValues;
@property NSDictionary *wholeLoadDict;
@property NSDictionary *oldDict;
@property  BOOL isEdit;

@end
