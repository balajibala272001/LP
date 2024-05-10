    //
    //  pageViewController.m
    //  coredata
    //
    //  Created by mac on 28/09/2563 BE.
    //  Copyright © 2563 BE smartgladiator. All rights reserved.
    //

#import "pageViewController.h"
#import "PreviewViewController.h"
#import "UIView+Toast.h"
#import "AZCAppDelegate.h"


@interface pageViewController ()

@end

@implementation pageViewController
@synthesize pathToImageFolder;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource =self;
    AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
    pathToImageFolder = [[delegate getUserDocumentDir]stringByAppendingPathComponent:LoadImagesFolder];
    PreviewViewController *initialVC =(PreviewViewController *) [self viewControllerAtIndex:self.indexPath];
    NSArray *viewControllers =[NSArray arrayWithObject:initialVC];
    NSLog(@"arrinpage:%@",viewControllers);
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem =leftBarButtonItem;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Preview Screen",@"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];
    //[view addSubview:networkStater];
    self.navigationItem.titleView = titleLabel;
}


-(void)back_button:(id)sender{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

-(UIViewController *) viewControllerAtIndex:(NSInteger)index{
    
    PreviewViewController *preview =[self.storyboard instantiateViewControllerWithIdentifier:@"PreviewViewController"];
    NSMutableDictionary *dic=[self.array objectAtIndex:index];
    if (self.array.count>index) {
        preview.current_index=index;
        NSString* imageName = [dic valueForKey:@"imageName"];
        if([[dic valueForKey: @"imageName"] isEqual: @""]){
            preview.extention = @"";
        }else{
            NSArray *extentionArray = [imageName componentsSeparatedByString:@"."];
            if([extentionArray[1] isEqualToString:@"mp4"])
            {
                preview.extention = @"movie";
            }
            else{
                preview.extention = @"image";
            }
            NSString *path = [pathToImageFolder stringByAppendingPathComponent:imageName];
            preview.videopath = path ;
        }
    }else{
        [self.view makeToast:NSLocalizedString(@"File Not Found",@"") duration:2.0 position:CSToastPositionCenter];
    }
    preview.array = self.array;
    return preview;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index =(((PreviewViewController *)viewController).current_index);
    if (index==0|| index ==NSNotFound)
    {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index =(((PreviewViewController *)viewController).current_index);
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    if (index == _array.count)
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


@end
