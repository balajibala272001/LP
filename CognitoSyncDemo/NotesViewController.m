//
//  NotesViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/14/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "NotesViewController.h"
#import "StaticHelper.h"
#import "PicViewController.h"
#import "UIView+Toast.h"
@interface NotesViewController ()

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.dictionaries);
    
    self.txtview_Notes.text = @"Enter 50 Characters Only...";
    //self.txtview_Notes.text.textColor = [UIColor lightGrayColor];
    //self.txtview_Notes.text.delegate = self;
    [self.txtview_Notes setTextColor:[UIColor lightGrayColor]];
    
    [self.txtview_Notes setDelegate:self];
    
    
//    self.txtview_Notes.text
    self.sub_View.layer.cornerRadius = 10;
    self.sub_View.layer.borderWidth =1;
    
    
    self.txtview_Notes.layer.cornerRadius =10;
    self.txtview_Notes.layer.borderWidth =1;
   
    
    self.txtview_Notes.textAlignment = NSTextAlignmentLeft;

      self.txtview_Notes.scrollEnabled = YES;
    self.txtview_Notes.showsHorizontalScrollIndicator = NO;
    self.txtview_Notes.showsVerticalScrollIndicator = YES;
    
    
    self.txtview_Notes.contentSize = CGSizeMake(self.txtview_Notes.frame.size.width,399);
    
    
    
    self.sub_View.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    

    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(next:)];
    self.navigationItem.rightBarButtonItem = NextButton;
    self.txtview_Notes.contentInset = UIEdgeInsetsMake(1.0,1.0,0,0.0); // set value as per your requirement.
 self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
      self.automaticallyAdjustsScrollViewInsets = NO;
      self.navigationItem.title = @"Notes";
    
      NSString *notes = [self.dictionaries objectForKey:@"string"];
    if (notes.length ==0) {
        
        self.txtview_Notes.text = nil;
    }
    else
    {
        self.txtview_Notes.text =notes;
    }
     
    // Do any additional setup after loading the view.
}



-(IBAction)next:(id)sender {

    if (self.txtview_Notes.text.length == 0) {
        NSString *notes = [self.dictionaries objectForKey:@"string"];
        self.txtview_Notes.text = nil;
        [self.dictionaries setObject:@"" forKey:@"string"];
        [self.delegate notesData:_indexPathRow changedData:self.dictionaries];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.txtview_Notes.text.length> 50){
        [self.view makeToast:@"Enter 50 Characters Only" duration:1.0 position:CSToastPositionCenter];
        self.txtview_Notes.text = nil;
    }
    else
    {
        NSString *string = self.txtview_Notes.text;
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];

        [self.dictionaries setObject:trimmedString forKey:@"string"];
        NSLog(@"%@",self.dictionaries);
        
        [self.delegate notesData:_indexPathRow changedData:self.dictionaries];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    //self.txtview_Notes.text = @"";
   // commentTxtView.textColor = [UIColor blackColor];
    self.txtview_Notes.textColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];

    return YES;
}
- (IBAction)back_action_btn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
