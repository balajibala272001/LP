/*
 * Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "PPPinPadViewController.h"
#import "User.h"
#define LoadImagesFolder               @"LoadImages"
//#define CurrentLoadFolderName           @"CurrentLoad"
//#define ParkLoadFolderName              @"ParkLoadDir"

@interface AZCAppDelegate : UIResponder <UIApplicationDelegate,PinPadPasswordProtocol>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) PPPinPadViewController *PPPinPadViewController;


@property (strong,nonatomic) User *userProfiels;
@property (strong,nonatomic) SiteData *siteDatas;

+(instancetype)sharedInstance;


@property (weak,nonatomic)NSMutableArray *displayData;

@property(nonatomic, assign) int count;


@property (strong,nonatomic)NSMutableArray *DisplayOldValues;




@property (assign,nonatomic) int LoadNumber;

@property (assign ,nonatomic) int ImageTapcount;
@property  BOOL isEdit;

@property BOOL isNoEdit;

- (NSMutableString*) getUserDocumentDir;



- (BOOL) createImageDirectory;

- (void) clearCurrentLoad; // should clear images in current load only
- (void) clearAllLoads; // should clear all images

- (BOOL) hasCurrentLoad; // [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLotRelatedData"]
- (BOOL) hasParkedLoad; // [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]

@end
