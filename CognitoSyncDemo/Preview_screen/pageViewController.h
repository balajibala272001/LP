    //
    //  pageViewController.h
    //  coredata
    //
    //  Created by mac on 28/09/2563 BE.
    //  Copyright © 2563 BE smartgladiator. All rights reserved.
    //

#import <UIKit/UIKit.h>

@interface pageViewController : UIPageViewController<UIPageViewControllerDataSource>
@property NSString *str;
@property NSMutableArray *array;
@property (strong,nonatomic) NSString* pathToImageFolder;
@property (assign ,nonatomic) int indexPath;
    //@property (strong ,retain) NSInteger *iindex;

@end
