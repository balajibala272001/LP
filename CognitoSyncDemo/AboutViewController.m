//
//  AboutViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 10/8/18.
//  Copyright © 2018 Behroozi, David. All rights reserved.
//

#import "AboutViewController.h"
#import "StaticHelper.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0,320, 70)];

    UINavigationItem *item = [[UINavigationItem alloc]init];

    
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked:)];

    
    item.leftBarButtonItem.tintColor = [UIColor brownColor];
   // item.leftBarButtonItem.tintColor = [UIColor colorWithRed:25.0 green:165.0 blue:180.0 alpha:0.1];

    // UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(saveButtonClicked:)];
    //item.rightBarButtonItem=add;
    item.leftBarButtonItem = add;
    navbar.items = [NSArray arrayWithObjects:item, nil];
    [self.view addSubview:navbar];
    
    UIColor *color = [UIColor colorWithRed:25 green:165 blue:180 alpha:1.0];
 // select needed color

    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@"GDPR Privacy Policy"] ;
     NSDictionary *attrs = @{ NSForegroundColorAttributeName : color };
    [attributedString addAttribute: NSLinkAttributeName value: @"https://privacypolicies.com/privacy/view/f5904d8b8bf9b0064592688552be71bc" range: NSMakeRange(0, attributedString.length) ];
    self.lbl.attributedText = attributedString;
    //self.lbl.font = [UIFont systemFontS]
    [self.lbl setFont:[UIFont boldSystemFontOfSize:17]];
   // self.lbl.tintColor = [UIColor brownColor];
    
    
    
    //self.lbl.tintColor =[UIColor colorWithRed:25 green:165 blue:180 alpha:1.0];
    
//    self.Background_View.layer.cornerRadius = 10;
//    self.Background_View.layer.borderWidth = 1;
//    self.Background_View.layer.borderColor = [UIColor blackColor].CGColor;
//    
   
//    UIColor *color = [UIColor redColor]; // select needed color
//    NSString *string = ... // the string to colorize
//    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color };
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrs];
//    self.scanLabel.attributedText = attrStr;

    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back_action_btn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)saveButtonClicked:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];

    
}





// [self.navigationController popViewControllerAnimated:YES];

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
