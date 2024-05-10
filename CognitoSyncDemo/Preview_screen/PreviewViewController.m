//
//  PreviewViewController.m
//  CognitoSyncDemo
//
//  Created by suganthi on 15/11/1941 Saka.
//  Copyright © 1941 Behroozi, David. All rights reserved.
//

#import "PreviewViewController.h"
#import "UIView+Toast.h"
#import "SCLAlertView.h"
#import "Constants.h"
#import "AZCAppDelegate.h"
#import "ViewController.h"

@interface PreviewViewController ()
{
    AZCAppDelegate *delegateVC;
}
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    if([self.extention isEqualToString:@"movie"])
    {
        NSURL *vedioURL = [NSURL fileURLWithPath:self.videopath];
        AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:vedioURL];
        AVPlayer* playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = playVideo;
        playerViewController.player.volume = 10;
        playerViewController.wantsFullScreenLayout = NO;
        self.imgview.userInteractionEnabled = YES;
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
        int x = self.imgview.bounds.origin.x;
        playerViewController.view.frame=CGRectMake(0,0, self.imgview.frame.size.width, self.imgview.frame.size.height);
        [self.imgview addSubview:playerViewController.view];
        [playVideo play];
    }
    else
    {
        for(int i=0; i<self.array.count; i++){
            NSDictionary*dict = [self.array objectAtIndex:i];
            if([[dict valueForKey: @"imageName"] isEqual: @""]){
                self.imgview.image = [UIImage imageNamed:@"Placeholder.png"];
            }else{
                image = [UIImage imageWithData:[NSData dataWithContentsOfFile:self.videopath]];
                self.imgview.image = image;
            }
        }
    }
    
    CGFloat x,y;
    x=self.view.frame.size.width/2;
    y=self.note.frame.origin.y-10;
    
    //self.counter.layer.cornerRadius =10;
   // self.counter.layer.borderWidth =1;
   // self.counter.layer.backgroundColor=[UIColor colorWithRed:27/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0].CGColor;
    //self.counter.layer.borderColor = [UIColor whiteColor].CGColor;
    self.counter.textColor=[UIColor whiteColor];
    self.counter.textAlignment= NSTextAlignmentCenter;
    self.counter.text=[NSString stringWithFormat: @"%ld / %ld",(long)self.current_index+ 1,(long)self.array.count];
    
    [self.view addSubview:self.counter];
    NSMutableDictionary *dic= [self.array objectAtIndex:self.current_index];
    NSString *str=[dic objectForKey:@"string"];
    if (str.length ==0) {
        
        self.textField.text = nil;
    }
    else
    {
        self.textField.text =str;
    }
    if (str.length>0) {
        [self.note setBackgroundImage:[UIImage imageNamed:@"notesicon.png"] forState:UIControlStateNormal];
    }else{
        if([self.extention isEqual: @""]){
            self.note.hidden = TRUE;
        }else{
            [self.note setBackgroundImage:[UIImage imageNamed:@"emptynote.png"] forState:UIControlStateNormal];
        }
    }
    [self.view bringSubviewToFront:self.note];
    // Do any additional setup after loading the view.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITextPosition *beginning = [textField beginningOfDocument];
    NSLog(@"beginning:%@",beginning);
    [textField setSelectedTextRange:[textField textRangeFromPosition:beginning toPosition:beginning]];
}

-(IBAction)notes:(id)sender{
    
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    self.textField = [self.alertbox addTextField:nil];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"Enter 50 characters only",@"")] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

    NSMutableDictionary *dic= [self.array objectAtIndex:self.current_index];
    NSString *str=[dic objectForKey:@"string"];
   
    self.textField.text = str;

    //UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10,10,10,10)];
    //lbl.text = @"Tap Button to Scan Values";
    //[self.alertbox addSubview:lbl];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
    [self.alertbox addButton:NSLocalizedString(@"SCAN",@"") target:self selector:@selector(scan:) backgroundColor:Blue];
    [self.alertbox addButton:NSLocalizedString(@"SAVE",@"") target:self selector:@selector(save:) backgroundColor:Green];
    NSLog(@"Text value: %@", self.textField.text);
    
    [self.alertbox showSuccess:NSLocalizedString(@"Enter Notes",@"") subTitle:NSLocalizedString(@"Tap SCAN button to Scan Values",@"") subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:0.0f ];

    NSLog(@"Click Dummy");
    
}

-(void) scan:(UIButton *)sender
{
    bool boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];

    self.senderTag=(int)sender.tag;
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"Barcode",@"") target:self selector:@selector(bc:) backgroundColor:Blue];
    if(boolToRestrict  == FALSE){
    [self.alertbox addButton:@"O.C.R" target:self selector:@selector(ocr:) backgroundColor:Blue];
    }
    [self.alertbox showSuccess:NSLocalizedString(@"Data Scanner",@"") subTitle:NSLocalizedString(@"Select scanning mode",@"") closeButtonTitle:NSLocalizedString(@"Close",@"") duration:1.0f ];
    
}

- (IBAction)bc:(id *)sender {
    IGVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IGVC"];
    IGVC.btnTag = self.senderTag;
    IGVC.txtTag = self.senderTag -100;
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
        viewController.tag=(int)self.senderTag-100;
    [self.navigationController pushViewController:viewController animated:YES];
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

- (void)viewWillDisappear:(BOOL)animated{
    if (self.alertbox!=nil){
        [self.alertbox hideView];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"PreviewVC";
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


-(void)sendStringViewController:(NSString *)string withTag:(NSInteger)tagNumber
{
    self.dictionaries= [[self.array objectAtIndex:self.current_index] mutableCopy];
    NSString * str = [self.dictionaries objectForKey: @"string"];
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"trimmedString:%@",trimmedString);
    if (trimmedString == 0) {
        [self.dictionaries setObject:@"" forKey:@"string"];
        [self.array replaceObjectAtIndex:self.current_index withObject:self.dictionaries];
        [self.note setBackgroundImage:[UIImage imageNamed:@"emptynote.png"] forState:UIControlStateNormal];
        NSMutableDictionary * load=[[NSMutableDictionary alloc] init];
        NSMutableArray * array=[[NSMutableArray alloc]init];
        
        array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        int i=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
        load= [[array objectAtIndex:i]mutableCopy];
        NSLog(@"load1%@",load);
        [load setObject:self.array forKey:@"img"];
        NSLog(@"load2%@",load);
        [array replaceObjectAtIndex:i withObject:load];
        [[NSUserDefaults standardUserDefaults] setValue:array forKey: @"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (str.length + trimmedString.length> 50)
    {
        [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter];
        self.textField.text = nil;
    }
    else
    {
        [self.textField replaceRange:self.textField.selectedTextRange withText:trimmedString];
        NSString*strr=self.textField.text;
        NSLog(@"strr%@:",strr);
        [self.dictionaries setObject:strr forKey:@"string"];
        NSLog(@"dictionaries in preview :%@",self.dictionaries);
        [self.array replaceObjectAtIndex:self.current_index withObject:self.dictionaries];
        [self.note setBackgroundImage:[UIImage imageNamed:@"notesicon.png"] forState:UIControlStateNormal];
        NSMutableDictionary * load=[[NSMutableDictionary alloc] init];
        NSMutableArray * array=[[NSMutableArray alloc]init];
        
        array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        int i=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
        load= [[array objectAtIndex:i]mutableCopy];
        NSLog(@"load1%@",load);
        [load setObject:self.array forKey:@"img"];
        NSLog(@"load2%@",load);
        [array replaceObjectAtIndex:i withObject:load];
        [[NSUserDefaults standardUserDefaults] setValue:array forKey: @"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"scanData"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"scanDataTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
    

-(IBAction)dummy:(id)sender
{
    [self.alertbox hideView];
}


-(IBAction)save:(id)sender
{
    self.dictionaries= [[self.array objectAtIndex:self.current_index] mutableCopy];

    if (self.textField.text.length == 0)
    {
        self.textField.text = nil;
        [self.dictionaries setObject:@"" forKey:@"string"];
        [self.array replaceObjectAtIndex:self.current_index withObject:self.dictionaries];
        [self.note setBackgroundImage:[UIImage imageNamed:@"emptynote.png"] forState:UIControlStateNormal];
    }
    else if (self.textField.text.length> 50){
        [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter];
        self.textField.text = nil;
    }
    else
    {
        NSString *string = self.textField.text;
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [self.dictionaries setObject:trimmedString forKey:@"string"];
        NSLog(@"dictionaries:%@",self.dictionaries);
        [self.array replaceObjectAtIndex:self.current_index withObject:self.dictionaries];
        [self.note setBackgroundImage:[UIImage imageNamed:@"notesicon.png"] forState:UIControlStateNormal];
        
        NSMutableDictionary * load=[[NSMutableDictionary alloc] init];
        NSMutableArray * array=[[NSMutableArray alloc]init];
        array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
        int i=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
        load= [[array objectAtIndex:i]mutableCopy];
        [load setObject:self.array forKey:@"img"];
        [array replaceObjectAtIndex:i withObject:load];
        [[NSUserDefaults standardUserDefaults] setValue:array forKey: @"ParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
