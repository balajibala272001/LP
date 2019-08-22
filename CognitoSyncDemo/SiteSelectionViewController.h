//
//  SiteSelectionViewController.h
//  CognitoSyncDemo
//
//  Created by mac on 9/16/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiteSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet UITableView *tblSimpleTable;
    //IBOutlet UIButton *btn_Click;
    IBOutlet UIImageView *i;
    BOOL flag;
    BOOL flagg;
    
    NSArray *arryData;
}

//@property(nonatomic,retain)IBOutlet UIButton *btn;
@property(nonatomic,retain)IBOutlet UITableView *tblSimpleTable;
@property(nonatomic,retain)IBOutlet UIImageView *i;
@property(nonatomic,retain)NSArray *arryData;

@property(nonatomic,strong)NSMutableArray *a;
//@property (weak, nonatomic) IBOutlet UIButton *btn_Go;

@property (weak, nonatomic) IBOutlet UIView *sub_View;

@property (weak, nonatomic) IBOutlet UIButton *btn_Click;
//@property (weak,nonatomic) IBOutlet UIButton *Go;
@property (nonatomic,strong) UIButton *Go;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end
