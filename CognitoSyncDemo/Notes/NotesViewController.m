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
    
    
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [next setBackgroundImage:[UIImage imageNamed:@"tick_save.png"] forState:UIControlStateNormal];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc]
                                   initWithCustomView:next ];
    
    
    self.navigationItem.rightBarButtonItem = NextButton;
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem =leftBarButtonItem;
    self.txtview_Notes.contentInset = UIEdgeInsetsMake(1.0,1.0,0,0.0); // set value as per your requirement.
    self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
        //self.navigationItem.title = @"Notes";
    
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


-(void )handleTimer {
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIButton *networkStater = [[UIButton alloc] initWithFrame:CGRectMake(140,12,16,16)];
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Notes",@"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 220, 40)];
    [view addSubview:titleLabel];
    
    view.center = self.view.center;
    
    
    if (delegate.isMaintenance) {
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"yellow_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 1.00 green: 0.921 blue: 0.243 alpha: 1.00].CGColor;
        
            //RGBA ( 255 , 235 , 62 , 100 )
        
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.835 green: 0.749 blue: 0.00 alpha: 1.00].CGColor;
        
            //RGBA ( 213 , 191 , 0 , 100 )
        
        NSLog(@"Server Under maintenance");
        
    }else if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [networkStater setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
        
            //RGBA ( 0 , 229 , 8 , 100)
        
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
        
            //RGBA ( 0 , 174 , 7 , 100 )
        
        NSLog(@"Network Connection available");
    } else {
        NSLog(@"Network Connection not available");
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
            //RGBA ( 248 , 181 , 82 , 80 )
        
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
            //RGBA ( 253 , 133 , 8 , 100 )
    }
    networkStater.layer.borderWidth = 1.0;
    [networkStater addTarget:self action:@selector(poper:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:networkStater];
    self.navigationItem.titleView = view;
    
}
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
    [self.txtview_Notes replaceRange:self.txtview_Notes.selectedTextRange withText:string];
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
    
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    NSString *stat=NSLocalizedString(@"Network Not Connected",@"");;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat=NSLocalizedString(@"Network Connected",@"");
    }
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Blue];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}

-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}

-(void)back_button:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)next:(id)sender {
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    self.txtview_Notes.textColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
    
    return YES;
}

- (IBAction)back_action_btn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
