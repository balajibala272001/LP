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
#import "SiteData.h"

@interface DocTypePopup ()<UIPopoverPresentationControllerDelegate> {
    NSString * pass;
}

@end

@implementation DocTypePopup

- (void)viewDidLoad {
    pass = @"Smart";

    [super viewDidLoad];
   
    // Register for the notification
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(appDidEnterBackground)
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    self.docTypeCollectionView.frame = CGRectMake(0, 50, 320, 250);
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelToggle)];

    recognizer.numberOfTapsRequired = 1;
    [self.cancel setUserInteractionEnabled:YES];
    [self.cancel addGestureRecognizer:recognizer];
    self.docTypeTitle.text = NSLocalizedString(@"Document Type",@"");
//    NSLog(@"%@", self.siteData.docTypes.count);
    
}

-(void)dealloc {
   // Unregister the observer when the view controller is deallocated
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appDidEnterBackground {
    // This method will be called when the app enters the background
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PasscodePinViewController *PasscodePinViewController = [storyboard instantiateViewControllerWithIdentifier:@"PasscodePinViewController"];
    if (@available(iOS 13.0, *)) {
        [PasscodePinViewController setModalPresentationStyle:UIModalPresentationFullScreen];// = YES
    }
    [self presentViewController:PasscodePinViewController animated:NO completion:nil];
}


- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // You can put your custom logic here to determine when the popover should be dismissed.
    // Return YES to allow dismissal, or NO to prevent it.
    return NO; // For example, always prevent dismissal
}

//doc type select button click
- (void)cancelToggle{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doctypSelectorCancel"  object:self];
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
    return  self.siteData.docTypes.count;
}

//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 2;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSDictionary *dict= [self.imageArray objectAtIndex:indexPath.row];
    NSLog(@"%ld", (long)indexPath.row);
    NSDictionary *dict = [self.siteData.docTypes objectAtIndex:indexPath.row];
    NSString *type = [dict valueForKey:@"docTypeName"];
    NSString *typeId = [dict valueForKey:@"doc_type_id"];
    if([type containsString:@"amp;"]){
        [[NSUserDefaults standardUserDefaults] setObject:typeId forKey:@"SelectedDocTypeId"];
        [[NSUserDefaults standardUserDefaults] setObject:[type stringByReplacingOccurrencesOfString:@"amp;" withString:@""] forKey:@"SelectedDocTypeName"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:typeId forKey:@"SelectedDocTypeId"];
        [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"SelectedDocTypeName"];
    }
   
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doctypSelector"  object:self];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DocTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellDoc" forIndexPath:indexPath];
    NSString *t = @(indexPath.row).stringValue;
    NSDictionary *dict = [self.siteData.docTypes objectAtIndex:indexPath.row];
    NSString *type = [dict valueForKey:@"docTypeName"];
    cell.label.text = type;
    if (@available(iOS 13.0, *)) {
        if(self.selectedDocTypeId != nil && [self.selectedDocTypeId isEqual:[dict valueForKey:@"doc_type_id"]]){
            UIImage *image1 = [UIImage systemImageNamed:@"dot.circle"];
            cell.icon.image = image1;
        }else {
            UIImage *image1 = [UIImage systemImageNamed:@"circle"];
            cell.icon.image = image1;
        }
    } else {
        if(self.selectedDocTypeId != nil && [self.selectedDocTypeId isEqual:[dict valueForKey:@"doc_type_id"]]){
            UIImage *image1 = [UIImage imageNamed:@"dot.circle"];
            cell.icon.image = image1;
        }else {
            UIImage *image1 = [UIImage imageNamed:@"circle"];
            cell.icon.image = image1;
        }
    }
    cell.icon.tintColor = UIColor.blueColor;
//    cell.frame = CGRectMake(0, 0, 320, 40);
    return cell;
}




@end
