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
<<<<<<< HEAD

=======
#import "NotesViewController.h"
>>>>>>> main

@interface PreviewViewController ()
{
    AZCAppDelegate *delegateVC;
    NSObject * periodicPlayerTimeObserverHandle;
    BOOL isVideoCompleted;
    BOOL isPaused;
    CMTime t2;
<<<<<<< HEAD
  
=======
    UIView *notespopupView;
    UITextView * note_txt;
>>>>>>> main
}
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    
=======
>>>>>>> main
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    if([self.extention isEqualToString:@"movie"])
    {
        isVideoCompleted = false;
        self.progressview.hidden = NO;
        self.playBtn.hidden = NO;
        self.gobackward.hidden = NO;
        self.goForward.hidden = NO;
        NSURL *vedioURL = [NSURL fileURLWithPath:self.videopath];
        AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:vedioURL];
        self.playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = self.playVideo;
        playerViewController.player.volume = 10;
//        playerViewController.wantsFullScreenLayout = NO;
        self.imgview.userInteractionEnabled = NO;
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
//        int x = self.imgview.bounds.origin.x;
        playerViewController.view.frame = CGRectMake(0,0, self.imgview.frame.size.width, self.imgview.frame.size.height);
        [self.imgview addSubview:playerViewController.view];
        UILabel *secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 30)]; // Set the frame as per your layout
        secondsLabel.textColor = UIColor.whiteColor;
        [self.imgview addSubview:secondsLabel];
        __weak typeof(self) weakSelf = self;
        periodicPlayerTimeObserverHandle = [self.playVideo addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC)
                                                                                    queue:NULL
                                                                               usingBlock:^(CMTime time){
            [weakSelf updateProgressBar];
            NSUInteger dTotalSeconds = CMTimeGetSeconds(time);
            NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
            NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);

            NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
            weakSelf.lefttimer.text = videoDurationText;
        }];
        t2 = self.playVideo.currentItem.asset.duration;
        NSUInteger dTotalSeconds = CMTimeGetSeconds(t2);
        NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
        NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
        NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
        weakSelf.righttimer.text = videoDurationText;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playVideo.currentItem];

        //[self.playVideo play];
        if (@available(iOS 13.0, *)) {
            self.playBtn.image = [UIImage systemImageNamed:@"pause.circle"];
        }
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopVideo)];
        recognizer.numberOfTapsRequired = 1;
        [self.playBtn setUserInteractionEnabled:YES];
        [self.playBtn addGestureRecognizer:recognizer];
        UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnBackwardClicked)];
        recognizer1.numberOfTapsRequired = 1;
        [self.gobackward setUserInteractionEnabled:YES];
        [self.gobackward addGestureRecognizer:recognizer1];
        UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnForwardClicked)];
        recognizer2.numberOfTapsRequired = 1;
        [self.goForward setUserInteractionEnabled:YES];
        [self.goForward addGestureRecognizer:recognizer2];
        
    }
    else if([self.extention isEqualToString:@"image"])
    {
        self.progressview.hidden = YES;
        self.playBtn.hidden = YES;
        self.gobackward.hidden = YES;
        self.goForward.hidden = YES;
        image = [UIImage imageWithData:[NSData dataWithContentsOfFile:self.videopath]];
        self.imgview.image = image;
    }else{
        self.progressview.hidden = YES;
        self.playBtn.hidden = YES;
        self.gobackward.hidden = YES;
        self.goForward.hidden = YES;
        self.imgview.backgroundColor = [UIColor whiteColor];
        self.imgview.image = [UIImage imageNamed:@"missing_img.png"];
    }
//        for(int i=0; i<self.array.count; i++){
//            NSDictionary*dict = [self.array objectAtIndex:i];
//            if([[dict valueForKey: @"imageName"] isEqual: @""]){
//                self.imgview.image = [UIImage imageNamed:@"Placeholder.png"];
//            }else{
//                image = [UIImage imageWithData:[NSData dataWithContentsOfFile:self.videopath]];
//                self.imgview.image = image;
//            }
//        }
    //}
    
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
        self.textField.text = str;
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
<<<<<<< HEAD
  //  self.imgview.image = self.Image;
=======
>>>>>>> main
}

- (void)btnBackwardClicked {
    // Seek backward by a specific time interval (e.g., 5 seconds).
    CMTime currentTime = self.playVideo.currentTime;
    CMTime backwardTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(5, 1));
    [self.playVideo seekToTime:backwardTime];
   //update progress view
    NSUInteger ct = CMTimeGetSeconds(backwardTime);
    float maxValue = CMTimeGetSeconds(self.playVideo.currentItem.asset.duration);
    [self.progressview  setProgress:(float)(ct/maxValue) animated:YES];
    
    //update timer text
    NSUInteger dMinutes = floor(ct % 3600 / 60);
    NSUInteger dSeconds = floor(ct % 3600 % 60);
    NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    self.lefttimer.text = videoDurationText;
 }

 - (void)btnForwardClicked {
     // Seek forward by a specific time interval (e.g., 5 seconds).
    CMTime currentTime = self.playVideo.currentTime;
    CMTime forwardTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(5, 1));
    [self.playVideo seekToTime:forwardTime];
     //update progress view
    NSUInteger ct = CMTimeGetSeconds(forwardTime);
    float maxValue = CMTimeGetSeconds(self.playVideo.currentItem.asset.duration);
    [self.progressview  setProgress:(float)(ct/maxValue) animated:YES];
      
    //update timer text
    NSUInteger dMinutes = floor(ct % 3600 / 60);
    NSUInteger dSeconds = floor(ct % 3600 % 60);
    NSUInteger dTotalSeconds = CMTimeGetSeconds(t2);
    NSUInteger dSeconds2 = floor(dTotalSeconds % 3600 % 60);
    if(dSeconds > dSeconds2){
        dSeconds = dSeconds2;
        isVideoCompleted = true;
    }
    NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
    self.lefttimer.text = videoDurationText;
 }

- (void)updateProgressBar{
    double currentTime = CMTimeGetSeconds(self.playVideo.currentTime);
    if(currentTime <= 0.05){
        [self.progressview setProgress:(float)(0.0) animated:NO];
        return;
    }

    if (isfinite(currentTime) && (currentTime > 0))
    {
        float maxValue = CMTimeGetSeconds(self.playVideo.currentItem.asset.duration);
        [self.progressview  setProgress:(float)(currentTime/maxValue) animated:YES];
    }
}

- (void)movieFinishedCallback:(NSNotification*)aNotification{
    if (@available(iOS 13.0, *)) {
        self.playBtn.image = [UIImage systemImageNamed:@"play.circle"];
    }
    isVideoCompleted = true;
}

- (void)stopVideo{
    @try {
        if(periodicPlayerTimeObserverHandle != nil)
        {
            [self.playVideo removeTimeObserver:periodicPlayerTimeObserverHandle];
            periodicPlayerTimeObserverHandle = nil;
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        if(self.playVideo.timeControlStatus == AVPlayerTimeControlStatusPaused){
            isPaused = false;
            __weak typeof(self) weakSelf = self;
            periodicPlayerTimeObserverHandle = [self.playVideo addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC)
                                                                                        queue:NULL
                                                                                   usingBlock:^(CMTime time){
                [weakSelf updateProgressBar];
                NSUInteger dTotalSeconds = CMTimeGetSeconds(time);
                NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
                NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);

                NSString *videoDurationText = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)dMinutes, (unsigned long)dSeconds];
                weakSelf.lefttimer.text = videoDurationText;
            }];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playVideo.currentItem];
            if(isVideoCompleted){
                isVideoCompleted = false;
                [self.playVideo seekToTime:kCMTimeZero];
            }
            [self.playVideo play];
            if (@available(iOS 13.0, *)) {
                self.playBtn.image = [UIImage systemImageNamed:@"pause.circle"];
            } else {
                // Fallback on earlier versions
            }
        }else {
            isPaused = true;
            [self.playVideo pause];
            if (@available(iOS 13.0, *)) {
                self.playBtn.image = [UIImage systemImageNamed:@"play.circle"];
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @catch (NSException * __unused exception) {}
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

<<<<<<< HEAD
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

=======
    NSMutableDictionary *dic = [self.array objectAtIndex:self.current_index];
    NSString *str=[dic objectForKey:@"string"];

    self.textField.text = str;
//
//    //UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10,10,10,10)];
//    //lbl.text = @"Tap Button to Scan Values";
//    //[self.alertbox addSubview:lbl];
//    [self.alertbox setHorizontalButtons:YES];
//    [self.alertbox addButton:NSLocalizedString(@"Cancel",@"") target:self selector:@selector(dummy:) backgroundColor:Red];
//    [self.alertbox addButton:NSLocalizedString(@"SCAN",@"") target:self selector:@selector(scan:) backgroundColor:Blue];
//    [self.alertbox addButton:NSLocalizedString(@"SAVE",@"") target:self selector:@selector(save:) backgroundColor:Green];
//    NSLog(@"Text value: %@", self.textField.text);
//
//    [self.alertbox showSuccess:NSLocalizedString(@"Enter Notes",@"") subTitle:NSLocalizedString(@"Tap SCAN button to Scan Values",@"") subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:0.0f ];

    [self docTypePopup: str];
>>>>>>> main
    NSLog(@"Click Dummy");
    
}

<<<<<<< HEAD
=======
-(void) docTypePopup:(NSString *)str{
    if(notespopupView ==nil){
        notespopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        notespopupView.backgroundColor = [UIColor whiteColor];
        notespopupView.layer.cornerRadius = 10;
        notespopupView.layer.masksToBounds = YES;
        notespopupView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];


        // Create a UIView for the popup content
        UIView *notesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 280)];
        notesView.backgroundColor = [UIColor whiteColor];
        notesView.layer.cornerRadius = 10;
        notesView.layer.masksToBounds = YES;
        
        
        // Add any other content to the popup view
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        label.text = NSLocalizedString(@"Enter Notes",@"");
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = Blue;
        label.textColor = UIColor.blackColor;
        [notesView addSubview:label];
        
        // Add any other content to the popup view
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 300, 50)];
        label2.text = NSLocalizedString(@"Tap SCAN button to Scan Values",@"");
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = Red;
        [notesView addSubview:label2];
        
        // Add a text field to the popup view
        note_txt = [[UITextView alloc]  initWithFrame:CGRectMake(20, 105, 260, 100)];
        note_txt.layer.cornerRadius = 5;
        note_txt.layer.borderWidth = 1;
        note_txt.textContainer.maximumNumberOfLines = 5;
        note_txt.textContainerInset = UIEdgeInsetsMake(2.5, 0.0, 2.5,0.0);
        [note_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        note_txt.textColor = Blue;
        [note_txt setDelegate:self];
        note_txt.text = str;
        [note_txt setReturnKeyType: UIReturnKeyDone];
        note_txt.layer.backgroundColor = [UIColor whiteColor].CGColor;
        note_txt.layer.borderColor = [UIColor blackColor].CGColor;
        [notesView addSubview:note_txt];
        
        // Create a stack view for the action buttons
        UIStackView *buttonStackView = [[UIStackView alloc] initWithFrame:CGRectMake(20, 220, 260, 40)];
        buttonStackView.axis = UILayoutConstraintAxisHorizontal;
        buttonStackView.distribution = UIStackViewDistributionFillEqually;
        buttonStackView.spacing = 10;
        
        // Add three action buttons to the stack view
        UIButton *save = [UIButton buttonWithType:UIButtonTypeSystem];
        [save setTitle:NSLocalizedString(@"SAVE",@"") forState:UIControlStateNormal];
        [save addTarget:self action:@selector(saveNoteTapped:) forControlEvents:UIControlEventTouchUpInside];
        save.backgroundColor = Green; // Set the background color
        save.layer.cornerRadius = 10;
        [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonStackView addArrangedSubview:save];
        UIButton *scan = [UIButton buttonWithType:UIButtonTypeSystem];
        [scan setTitle:NSLocalizedString(@"SCAN",@"") forState:UIControlStateNormal];
        [scan addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
        scan.backgroundColor = Blue; // Set the background color
        scan.layer.cornerRadius = 10;
        [scan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonStackView addArrangedSubview:scan];
        UIButton *cancelPopup = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelPopup setTitle:NSLocalizedString(@"Cancel",@"") forState:UIControlStateNormal];
        [cancelPopup addTarget:self action:@selector(cancelNoteTapped:) forControlEvents:UIControlEventTouchUpInside];
        cancelPopup.backgroundColor = Red; // Set the background color
        cancelPopup.layer.cornerRadius = 10;
        [cancelPopup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonStackView addArrangedSubview:cancelPopup];
        
        // Add the stack view to the popup view
        [notesView addSubview:buttonStackView];
        notesView.center = notespopupView.center;
        // Add the stack view to the popup view
        [notespopupView addSubview:notesView];
        // Add the popup view to the main view
        notespopupView.center = self.view.center;
        [self.view addSubview:notespopupView];
    }else {
        note_txt.text = str;
        [notespopupView setHidden:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextView *)textField {
    // This method is called when the return button is pressed
    [note_txt resignFirstResponder]; // Hide the keyboard
    return YES;
}

- (void)saveNoteTapped:(UIButton *)button {
    self.dictionaries= [[self.array objectAtIndex:self.current_index] mutableCopy];
    if(note_txt != nil){
        if (note_txt.text.length == 0)
        {
            note_txt.text = nil;
            [self.dictionaries setObject:@"" forKey:@"string"];
            [self.array replaceObjectAtIndex:self.current_index withObject:self.dictionaries];
            [self.note setBackgroundImage:[UIImage imageNamed:@"emptynote.png"] forState:UIControlStateNormal];
        }
        else if (note_txt.text.length> 50){
            [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter];
            note_txt.text = nil;
        }
        else
        {
            NSString *string = note_txt.text;
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
            if(notespopupView != nil){
                [notespopupView setHidden:YES];
                [self.view endEditing:YES];
            }
        }
    }
}

- (void)cancelNoteTapped:(UIButton *)button {
    note_txt.text = nil;
    // Remove the popup view from the main view
    [notespopupView setHidden:YES];
    [self.view endEditing:YES];
}

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
        if(note_txt != nil){
            if(![note_txt.text isEqual:@""]){
                if(_textView.text.length >= 50){
                    [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                    return NO;
                }
            }
        }
    }
    return YES;
}


>>>>>>> main
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
    IGVC.txtTag = self.senderTag - 100;
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
    if(self.playVideo != nil){
        [self.playVideo pause];
    }
<<<<<<< HEAD
=======
    if(notespopupView != nil){
        //[notespopupView setHidden:YES];
        [self.view endEditing:YES];
    }
>>>>>>> main
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
    if(self.playVideo != nil && isPaused == false){
        [self stopVideo];
    }
}


-(void)sendStringViewController:(NSString *)string withTag:(NSInteger)tagNumber
{
<<<<<<< HEAD
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
=======
    if(notespopupView != nil){
        [notespopupView setHidden:NO];
    }
    if (string.length > 50){
        [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter];
    }else {
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
            self.textField.text = nil;
            [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter];
        }
        else
        {
            //        //[self.textField replaceRange:self.textField.selectedTextRange withText:trimmedString];
            long a = string.length;
            long b = note_txt.text.length;
            if(a + b >= 50){
                string = [note_txt.text stringByAppendingString:string];
                string = (string.length > 50) ? [string substringToIndex:50] : string;
                note_txt.text = string;
                [self.view makeToast:NSLocalizedString(@"Enter 50 characters only",@"") duration:2.0 position:CSToastPositionCenter];
            }else {
                [note_txt replaceRange:note_txt.selectedTextRange withText:string];
            }
            //        self.textField.text = trimmedString;
            //        NSString*strr=self.textField.text;
            //        NSLog(@"strr%@:",strr);
            //        [self.dictionaries setObject:strr forKey:@"string"];
            //        NSLog(@"dictionaries in preview :%@",self.dictionaries);
            //        [self.array replaceObjectAtIndex:self.current_index withObject:self.dictionaries];
            //        [self.note setBackgroundImage:[UIImage imageNamed:@"notesicon.png"] forState:UIControlStateNormal];
            //        NSMutableDictionary * load=[[NSMutableDictionary alloc] init];
            //        NSMutableArray * array=[[NSMutableArray alloc]init];
            //
            //        array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
            //        int i=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
            //        load= [[array objectAtIndex:i]mutableCopy];
            //        NSLog(@"load1%@",load);
            //        [load setObject:self.array forKey:@"img"];
            //        NSLog(@"load2%@",load);
            //        [array replaceObjectAtIndex:i withObject:load];
            //        [[NSUserDefaults standardUserDefaults] setValue:array forKey: @"ParkLoadArray"];
            //        [[NSUserDefaults standardUserDefaults] synchronize];
        }
>>>>>>> main
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"scanData"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"scanDataTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
<<<<<<< HEAD
=======
    
>>>>>>> main
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
<<<<<<< HEAD
=======
        if(notespopupView != nil){
            [notespopupView setHidden:YES];
        }
>>>>>>> main
    }
}


@end
