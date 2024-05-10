//
//  DocTypePopup.h
//  CognitoSyncDemo
//
//  Created by smartgladiator on 04/09/23.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//


#import "SCLAlertView.h"
#import <UIKit/UIKit.h>
#import "SCLSwitchView.h"
#import "SiteData.h"

@interface DocTypePopup  :UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>



@property (weak, nonatomic) IBOutlet UIImageView *cancel;

@property (weak, nonatomic) IBOutlet UICollectionView *docTypeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *docTypeTitle;

@property (strong, nonatomic) SiteData *siteData;
@property (strong, nonatomic) NSString *selectedDocTypeId;


@end
