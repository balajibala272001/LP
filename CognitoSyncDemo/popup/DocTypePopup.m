//
//  DocTypePopup.m
//  CognitoSyncDemo
//
//  Created by smartgladiator on 04/09/23.
//  Copyright © 2023 Behroozi, David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocTypePopup.h"
#import "CognitoHomeViewController.h"
#import "Constants.h"
#import "AZCAppDelegate.h"
#import "SCLAlertView.h"
#import "SCLTextView.h"
#import "UIView+Toast.h"
#import "ServerUtility.h"
#import "DocTypeCell.h"

@interface DocTypePopup ()<UIPopoverPresentationControllerDelegate> {
    NSString * pass;
}

@end

@implementation DocTypePopup

- (void)viewDidLoad {
    pass = @"Smart";

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    self.docTypeCollectionView.frame = CGRectMake(0, 50, 320, 250);
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelToggle)];

    recognizer.numberOfTapsRequired = 1;
    [self.cancel setUserInteractionEnabled:YES];
    [self.cancel addGestureRecognizer:recognizer];
    
}


//doc type select button click
- (void)cancelToggle{
//    [self.view makeToast:NSLocalizedString(@"Recording Video, Kindly Wait.",@"") duration:2.0 position:CSToastPositionCenter];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.docTypeCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


//****************************************************
#pragma mark - Collection View Delegate  Methods
//****************************************************
//
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  15;
}

//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 2;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSDictionary *dict= [self.imageArray objectAtIndex:indexPath.row];
    NSLog(@"%ld", (long)indexPath.row);
    [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row).stringValue forKey:@"SelectedDocTypePos"];
    [[NSUserDefaults standardUserDefaults] setObject:[@(indexPath.row).stringValue stringByAppendingString:@"pos"] forKey:@"SelectedDocTypeName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doctypSelector"  object:self];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DocTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellDoc" forIndexPath:indexPath];
    NSString *t = @(indexPath.row).stringValue;

    cell.label.text = [t stringByAppendingString:@" position"];
    if (@available(iOS 13.0, *)) {
        UIImage *image1 = [UIImage systemImageNamed:@"dot.circle"];
        cell.icon.image = image1;
    } else {
        UIImage *image1 = [UIImage imageNamed:@"dot.circle"];
        cell.icon.image = image1;
    }
    cell.icon.tintColor = UIColor.blueColor;
//    cell.frame = CGRectMake(0, 0, 320, 40);
    return cell;
}




@end
