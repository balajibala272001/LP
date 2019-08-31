//
//  ProjectDetailsViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 8/17/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "igViewController.h"
#import "SiteData.h"

//saving old data values of meta data
@protocol senddataProtocol  <NSObject>

-(void)sendDataToPictureConfirmation:(NSArray *)array;


@end

@interface ProjectDetailsViewController : UIViewController<NSCacheDelegate>


@property(nonatomic,assign)id<senddataProtocol> delegate;





@property (weak, nonatomic) IBOutlet UIView *sub_View;


@property (strong,nonatomic) SiteData *siteData;
//@property (strong,nonatomic) FieldData *fieldData;
@property (nonatomic,assign)int c_fieldId;


@property (weak,nonatomic) NSArray *metaDataArray;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_View;



@property (nonatomic,assign)  int sub_View_Height;

@property (nonatomic,strong) NSMutableArray *arrayOfImagesWithNotes;

- (IBAction)back_btn_action:(id)sender;



@property (weak,nonatomic) NSString *sitename;


@property (weak,nonatomic) NSMutableArray *oldValuesReturn;

@property (weak,nonatomic)  NSDictionary *wholeDictionary;



@property  BOOL isEdit;
@property  BOOL isRadio;
@property NSDictionary *oldDict;
@property (nonatomic,strong)NSMutableArray *arr;

@property (nonatomic,strong)UIButton *yourButton;
@property (nonatomic,strong)UIButton *checkBoxButton;





@property(nonatomic,assign)int fieldId;



@end
