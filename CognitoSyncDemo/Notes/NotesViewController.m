    //
    //  NotesViewController.m
    //  CognitoSyncDemo
    //
    //  Created by mac on 9/14/16.
    //  Copyright © 2016 Behroozi, David. All rights reserved.
    //

#import "NotesViewController.h"
#import "StaticHelper.h"
//#import "PicViewController.h"
#import "UIView+Toast.h"
#import "Reachability.h"
#import "AZCAppDelegate.h"
#import "Constants.h"
#import "SCLAlertView.h"
@interface NotesViewController ()<UIPopoverControllerDelegate>{
    AZCAppDelegate *delegateVC;
}

@end

@implementation NotesViewController


- (void)viewDidLoad {
    @try{
        NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
        }
        [super viewDidLoad];
        
        NSLog(@"%@",self.dictionaries);
        self.txtview_Notes.text = NSLocalizedString(@"Enter 50 characters only",@"");
        [self.txtview_Notes setTextColor:[UIColor lightGrayColor]];
        [self.txtview_Notes setDelegate:self];
        self.sub_View.layer.cornerRadius = 10;
        self.txtview_Notes.layer.cornerRadius =10;
        self.txtview_Notes.layer.borderWidth =1;
        self.txtview_Notes.textAlignment = NSTextAlignmentLeft;
        self.txtview_Notes.scrollEnabled = YES;
        self.txtview_Notes.showsHorizontalScrollIndicator = NO;
        self.txtview_Notes.showsVerticalScrollIndicator = YES;
        self.txtview_Notes.contentSize = CGSizeMake(self.txtview_Notes.frame.size.width,399);
        //self.sub_View.layer.borderColor= Blue.CGColor;
        self.txtview_Notes.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [self.scanhint addConstraint:[NSLayoutConstraint constraintWithItem:self.scanhint
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute: NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:width]];
        
        UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [next setBackgroundImage:[UIImage imageNamed:@"tick_save.png"] forState:UIControlStateNormal];
        [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *NextButton = [[UIBarButtonItem alloc]initWithCustomView:next ];
        self.navigationItem.rightBarButtonItem = NextButton;
        self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
        UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
        self.navigationItem.leftBarButtonItem =leftBarButtonItem;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
        self.txtview_Notes.contentInset = UIEdgeInsetsMake(1.0,1.0,0,0.0); // set value as per your requirement.
        self.automaticallyAdjustsScrollViewInsets = NO;
        //self.navigationItem.title = @"Notes";
        
        NSString *notes = [self.dictionaries objectForKey:@"string"];
        if (notes.length ==0) {
            self.txtview_Notes.text = nil;
        }else{
            self.txtview_Notes.text =notes;
        }
    }@catch(NSException *ex){
        NSLog(@"ee", @"aa");
    }
}

-(void)viewWillAppear:(BOOL)animated {
   // self.txtview_Notes.text = NSLocalizedString(@"Enter 50 Characters Only...",@"");
    [super viewWillAppear:animated];
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"NotesVC";
    [self handleTimer];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    NSString *text=[[NSUserDefaults standardUserDefaults] objectForKey:@"scanData"];
    
    if (text!=nil ) {
        NSString *str=TRIM(text);
        if (str.length>0) {
            [self sendStringViewController:text withTag:0];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"scanData"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"scanDataTag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.alertbox!=nil){
        [self.alertbox hideView];
    }
}


-(void)handleTimer {
    @try{
        AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
        
        //internet_indicator
        UIButton *networkStater;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
<<<<<<< HEAD
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(0,12,16,16)];
        }else{
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(160,12,16,16)];
=======
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(30,12,16,16)];
        }else{
            networkStater = [[UIButton alloc] initWithFrame:CGRectMake(195,12,16,16)];
>>>>>>> main
        }
        networkStater.layer.masksToBounds = YES;
        networkStater.layer.cornerRadius = 8.0;
        //cloud_indicator
        UIButton *cloud_indicator;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
<<<<<<< HEAD
            cloud_indicator= [[UIButton alloc] initWithFrame:CGRectMake(170,3,35,32)];
=======
            cloud_indicator= [[UIButton alloc] initWithFrame:CGRectMake(220,3,35,32)];
>>>>>>> main
        }else{
            cloud_indicator= [[UIButton alloc] initWithFrame:CGRectMake(10,3,35,32)];
        }
        cloud_indicator.layer.masksToBounds = YES;
        cloud_indicator.layer.cornerRadius = 10.0;
<<<<<<< HEAD
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0, 200, 40)];
=======
        
        //parkload button
        UIButton *parkloadIcon;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(0,8,25,25)];
        }else{
            parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(220,8,25,25)];
        }
        [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_icon.png"]  forState:UIControlStateNormal];
        parkloadIcon.layer.masksToBounds = YES;
        
        UILabel* titleLabel;
        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 0, 169, 40)];
        }else {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 170, 40)];
        }
>>>>>>> main
        titleLabel.text = NSLocalizedString(@"Notes",@"");
        //titleLabel.minimumFontSize = 18;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.highlighted=YES;
        titleLabel.textColor = [UIColor blackColor];
<<<<<<< HEAD
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 220, 40)];
        [view addSubview:titleLabel];
=======
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 255, 40)];
        [view addSubview:titleLabel];
        //parkload icon
        [parkloadIcon addTarget:self action:@selector(parkload_poper) forControlEvents:UIControlEventTouchUpInside];
        [parkloadIcon setExclusiveTouch:YES];
        [view addSubview:parkloadIcon];
>>>>>>> main
        view.center = self.view.center;
        
        //internet_indicator
        bool isOrange = false;
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            isOrange = false;
            [networkStater setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
            networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
            //RGBA ( 0 , 229 , 8 , 100)
            networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
            //RGBA ( 0 , 174 , 7 , 100 )
            NSLog(@"Network Connection available");
        }else{
            isOrange = true;
            NSLog(@"Network Connection not available");
            [networkStater
             setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
            networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
            //RGBA ( 248 , 181 , 82 , 80 )
            networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
        }
        //cloud_indicator
        NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] valueForKey:@"maintenance_stage"];
        bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
        
        if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
            [cloud_indicator setBackgroundImage: [UIImage imageNamed:@"orangecloud.png"] forState:UIControlStateNormal];
        }else if([maintenance_stage isEqualToString:@"False"] && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable && !isOrange){
            [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"greencloud.png"]  forState:UIControlStateNormal];
        }else if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
            [cloud_indicator setBackgroundImage:[UIImage imageNamed:@"greycloud.png"]  forState:UIControlStateNormal];
        }
        
        //cloud_indicator
        [cloud_indicator addTarget:self action:@selector(cloud_poper:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cloud_indicator];
        
        //internet_indicator
        networkStater.layer.borderWidth = 1.0;
        [networkStater addTarget:self action:@selector(poper:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:networkStater];
        self.navigationItem.titleView = view;
<<<<<<< HEAD
    }@catch(NSException *ex){
        NSLog(@"ee", @"ww");
=======
        
        NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
        parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
        NSMutableDictionary * parkload = [[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
        BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"];
        if((![[parkload objectForKey:@"isParked"] isEqual:@"1"] && parkloadarray.count == 1) || !isLoggedIn){
            parkloadIcon.hidden = YES;
        }
    }@catch(NSException *ex){
        NSLog(@"ww");
>>>>>>> main
    }
}

-(IBAction)cloud_poper:(id)sender {
    
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    //cloud_indicator
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    NSString *stat= @"";
    if(([maintenance_stage isEqualToString:@"True1"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == FALSE))&& [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"LoadProof Cloud is Offline, proceed with Parkloads.",@"");
    }else if ([maintenance_stage isEqualToString:@"False"] && [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat= NSLocalizedString(@"LoadProof Cloud is Online, proceed with the uploads.",@"");
    }else{
        stat= NSLocalizedString(@"Network Not Connected",@"");
    }
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

<<<<<<< HEAD
=======
-(void) parkload_poper{

    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
   NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
   parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
   NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
   NSMutableDictionary * parkload = [[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
   long a = parkloadarray.count;
   if(![[parkload objectForKey:@"isParked"] isEqual:@"1"]){
       a--;
   }
    
    NSString *stat = @(a).stringValue;
    NSString *mesg = [stat stringByAppendingString:@" Load are Parkload. Please Upload before logging out."];
    
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox setHideTitle:YES];
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:mesg closeButtonTitle:nil duration:1.0f ];
 }

>>>>>>> main
-(IBAction)scan:(id)sender {
    
    bool NotesboolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
    [self.view makeToast:NSLocalizedString(@"scanner",@"") duration:2.0 position:CSToastPositionCenter];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"Barcode",@"") target:self selector:@selector(bc:) backgroundColor:Blue];
    if(NotesboolToRestrict == FALSE){
        [self.alertbox addButton:@"O.C.R" target:self selector:@selector(ocr:) backgroundColor:Blue];
    }
    [self.alertbox showSuccess:NSLocalizedString(@"Data Scanner",@"") subTitle:NSLocalizedString(@"Select scanning mode",@"") closeButtonTitle:NSLocalizedString(@"Close",@"") duration:2.0f];
}

- (IBAction)bc:(id *)sender {
    IGVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IGVC"];
    [IGVC setDelegate:self];
    [self.navigationController pushViewController:IGVC animated:YES];
}

- (IBAction)ocr:(id)sender {
    
    UIImagePickerController *imgPicker=[UIImagePickerController new];
    imgPicker.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *imag = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *path = [[self getUserDocumentDir] stringByAppendingPathComponent:@"ScanData"];
    NSString* imagePath = [path stringByAppendingPathComponent:@"scanner.jpg"];
    
        //    CGSize size= CGSizeMake(360, 480);
        //    UIImage *finalimage=[self imageWithImage:imag convertToSize:size];
        //
    [UIImageJPEGRepresentation(imag,1) writeToFile:imagePath atomically:true];
    ViewController *viewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"vc"];
    
    viewController.img = imagePath;
    viewController.imager=imag;
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void)sendStringViewController:(NSString *) string withTag :(NSInteger) tagNumber
{
<<<<<<< HEAD
    [self.txtview_Notes replaceRange:self.txtview_Notes.selectedTextRange withText:string];
=======
    if (string.length > 50){
        [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter];
    }else {
        long a = string.length;
        long b = self.txtview_Notes.text.length;
        if(a + b >= 50){
            string = [self.txtview_Notes.text stringByAppendingString:string];
            string = (string.length > 50) ? [string substringToIndex:50] : string;
            self.txtview_Notes.text = string;
            [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter];
        }else {
            [self.txtview_Notes replaceRange:self.txtview_Notes.selectedTextRange withText:string];
        }
    }
>>>>>>> main
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"scanData"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"scanDataTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
   

- (NSMutableString*)getUserDocumentDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [[paths objectAtIndex:0] mutableCopy];
    return path;
}

-(IBAction)poper:(id)sender {
    
    NSString* maintenance_stage=[[NSUserDefaults standardUserDefaults] objectForKey:@"maintenance_stage"];
    bool internal_test_mode =[[NSUserDefaults standardUserDefaults] boolForKey:@"internal_test_mode"];
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
        [self handleTimer];
    //}
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    NSString *stat=NSLocalizedString(@"Network Not Connected",@"");;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat=NSLocalizedString(@"Network Connected",@"");
    }
    [self.alertbox setHorizontalButtons:YES];
<<<<<<< HEAD
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Blue];
=======
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
>>>>>>> main
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

-(void)back_button:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)next:(id)sender {
    @try{
        if (self.txtview_Notes.text.length == 0) {
            //NSString *notes = [self.dictionaries objectForKey:@"string"];
            self.txtview_Notes.text = nil;
            [self.dictionaries setObject:@"" forKey:@"string"];
            [self.delegate notesData:_indexPathRow changedData:self.dictionaries];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.txtview_Notes.text.length> 50){
            [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter];
            //self.txtview_Notes.text = nil;
        }
        else
        {
            NSString *string = self.txtview_Notes.text;
            NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [self.dictionaries setObject:trimmedString forKey:@"string"];
            NSLog(@"dictionaries in notes :%@",self.dictionaries);
            
            [self.delegate notesData:_indexPathRow changedData:self.dictionaries];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }@catch(NSException *ex){
        NSLog(@"aa", @"aaa");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    self.txtview_Notes.textColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
    
    return YES;
}

<<<<<<< HEAD
=======
//height of textfield
-(BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text
{
    NSLog(@"height:%f",_textView.frame.size.height);
    NSLog(@"text:%@", text);
    if ([text containsString:@"\n"]){
        [_textView resignFirstResponder];
        return NO;
    }
    if(![text isEqual:@""]){
        if(_textView.text.length >= 50){
            [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter style:nil];
            return NO;
        }
    }
    return YES;
}


>>>>>>> main
- (IBAction)back_action_btn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
