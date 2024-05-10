//
//  ProjectDetailsViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 8/17/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "ProjectDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "StaticHelper.h"
#import "UIView+Toast.h"
#import "Reachability.h"
#import "AZCAppDelegate.h"
#import "SCLAlertView.h"
#import "Constants.h"
#import "ViewController.h"
#import "Add_on.h"
#import "Add_on_8.h"
#import "UploadViewController.h"
#import "LoopingViewController.h"
#import "CategoryViewController.h"

@interface ProjectDetailsViewController ()<UIPopoverControllerDelegate,UITextViewDelegate>{
    AZCAppDelegate *delegateVC;
}
@end

@implementation ProjectDetailsViewController
{
    NSMutableArray *savingArray;
    bool hasCustomCategory;
    bool hasAddon7;
    bool hasAddon8;
    //UIButton *meta_btn_datePicker;
    UIDatePicker *picker;
    Add_on *add_on;
    Add_on_8 *add_on_8;
}

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************

-(void)viewWillAppear:(BOOL)animated

{
    self.subView.layer.cornerRadius = 10;
    self.subView.layer.borderWidth = 1;
    self.subView.layer.borderColor = Blue.CGColor;
    [super viewWillAppear:animated];
        
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"MetaDataVC";
        
    [self handleTimer];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //BarCode
    NSString *text=[[NSUserDefaults standardUserDefaults] objectForKey:@"scanData"];
    NSInteger tag=[[NSUserDefaults standardUserDefaults] integerForKey:@"scanDataTag"];
    if (text!=nil && tag>0) {
        NSString *str=TRIM(text);
        if (str.length>0) {
            [self sendStringViewController:text withTag:tag];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"scanData"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"scanDataTag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
    //DatePicker
    NSString *label=[[NSUserDefaults standardUserDefaults] objectForKey:@"datePicker"];
    NSInteger labeltag=[[NSUserDefaults standardUserDefaults] integerForKey:@"datePickerTag"];
    if (label!=nil && labeltag>0) {
        NSString *str=TRIM(label);
        if (str.length>0) {
            [self sendStringViewController:label withTag:labeltag];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"datePicker"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"datePickerTag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.alertbox!=nil){
        [self.alertbox hideView];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topLbl.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    savingArray = [[NSMutableArray alloc]init];
    self.arr = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshing:) name:@"refreshing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    //Checking_add0n5
    SiteData *sites = self.siteData;
    hasCustomCategory = false;
    for (int index=0; index<sites.categoryAddon.count; index++) {
        Add_on *add_on=[sites.categoryAddon objectAtIndex:index];
        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
            hasCustomCategory=true;
            break;
        }
    }
    
    //Checking_add0n7
    hasAddon7 = false;
    for (int index=0; index<sites.categoryAddon.count; index++) {
        Add_on *add_on=[sites.categoryAddon objectAtIndex:index];
        if ([add_on.addonName isEqual:@"addon_7"] && add_on.addonStatus.boolValue) {
            hasAddon7=true;
            break;
        }
    }
    
    //Checking_add0n8
    hasAddon8 = FALSE;
    for (int index=0; index<sites.categoryAddon.count; index++) {
        Add_on * dict = [sites.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_8"] && dict.addonStatus.boolValue){
            hasAddon8 = TRUE;
        }
    }
    if (hasAddon8 == TRUE && hasCustomCategory == FALSE && hasAddon7== FALSE) {
        
        [self baseMetaData];
    }else{
        [self createMetaData];
    }
    // self.navigationItem.title = @"Data Fields";
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [back setBackgroundImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back_button:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem =leftBarButtonItem;

        //NSLog(@" the code is :%@",self.text);
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc] initWithCustomView:next];

    self.navigationItem.rightBarButtonItem = NextButton;
    self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
        // Do any additional setup after loading the view.
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)refreshing:(NSNotification *)notification
{
    if (hasAddon8 && !hasCustomCategory && !hasAddon7) {
        [self baseMetaData];
    }else{
        [self createMetaData];
    }
}



//****************************************************
#pragma mark - Private Methods
//****************************************************
-(void)back_button:(id)sender
{
    if(hasAddon8 && !hasCustomCategory && !hasAddon7){
        CategoryViewController *Category = [self.storyboard instantiateViewControllerWithIdentifier:@"Category_Screen"];
        Category.siteData = self.siteData;
        Category.arrayOfImagesWithNotes = self.arrayOfImagesWithNotes;
        Category.sitename = self.sitename;
        Category.image_quality = self.siteData.image_quality;
        Category.isEdit = self.isEdit;
        
        [self.navigationController pushViewController:Category animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//BaseMetaData-Addon8
-(void)baseMetaData
{
    NSMutableArray *parkloadarray=[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload=[parkloadarray objectAtIndex:currentloadnumber];
    hasAddon8 = FALSE;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_8"] && dict.addonStatus.boolValue){
            add_on =[self.siteData.categoryAddon objectAtIndex:index];
            add_on_8 =[self.siteData.looping_data objectAtIndex:0];
            hasAddon8 = TRUE;
        }
    }
    if (hasAddon8 && !hasCustomCategory && !hasAddon7) {
        for (int i=0; i<self.siteData.looping_data.count; i++) {
            Add_on_8 *dict = self.siteData.looping_data[i];
                self.metaDataArray =  dict.baseMetaData;
                NSLog(@"dict.base_meta[i]:%@",dict.baseMetaData);
        }
    }
    //button
    int verticalPadding = 3;
    int horizontalPadding  = 3;
    int heightOfBtn = 60;
    int widthOfBtn = self.scroll_View.frame.size.width/2 ;
    int xPosOfBtn = 10;
    int y =verticalPadding;
    int yPosOfBtn;
    int heightOfTxt = 60;
    int xPosOfTxt =horizontalPadding + widthOfBtn +15;
    int widthOfTxt= self.scroll_View.frame.size.width-(xPosOfTxt+horizontalPadding+horizontalPadding);

    yPosOfBtn = verticalPadding;

    int btnTagBaseValue = 200;
    int lblTagBaseValue = 400;
    int txtTagBaseVaue = 100;
    int baseDateTag = 400;
    int basecheckboxTag = 300;
    int tappitxtTagBaseVaue = 0;
    int tappibutTagBaseVaue = 0;
    int baseradioTag = 300;

    int radioViewheight ;
    int checkBoxViewheight;
    NSMutableArray *fields=[parkload objectForKey:@"basefields"];
    self.tappi_txt.text = [parkload objectForKey:@"tappi_count"];
        //iterating the fieldata array
    
    int yPosOfTxt = yPosOfBtn;
    //Tappi_field---tappi_Button
    UIButton *tappi_btn = [[UIButton alloc]init];
    tappi_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn, widthOfBtn,heightOfBtn);
    yPosOfBtn =yPosOfBtn + (verticalPadding + heightOfBtn);
    tappi_btn.backgroundColor = Blue;
    tappi_btn.tag = 0;
    NSLog(@"tag:%ld",(long)tappi_btn.tag);
    [tappi_btn setTitle:NSLocalizedString(@"Number Of Tappi",@"") forState:UIControlStateNormal];
    NSString *model=[UIDevice currentDevice].model;
    if ([model isEqualToString:@"iPad"]) {
        tappi_btn.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:21];
    }else{
        tappi_btn.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15];
    }

    tappi_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    tappi_btn.layer.cornerRadius = 5;
    tappi_btn.layer.borderWidth = 1;
    tappi_btn.layer.borderColor = [UIColor blackColor].CGColor;
    tappi_btn.titleLabel.numberOfLines = 3;
    [tappi_btn setTitleEdgeInsets:UIEdgeInsetsMake(2.5, 0.0, 2.5, 0.0)];
    UILabel *assSymbolLbl = [[UILabel alloc]init];
    assSymbolLbl.frame = CGRectMake((tappi_btn.frame.size.width-25),5, 20,20);
    assSymbolLbl.textColor = [UIColor redColor];
    [assSymbolLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    assSymbolLbl.textAlignment = NSTextAlignmentRight;
    assSymbolLbl.text = @"*";
    [tappi_btn addSubview:assSymbolLbl];
    [self.sub_View addSubview:tappi_btn];
    
    self.tappi_txt = [[UITextView alloc]init];
    self.tappi_txt.layer.cornerRadius = 5;
    self.tappi_txt.layer.borderWidth = 1;
    self.tappi_txt.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.tappi_txt.layer.borderColor = [UIColor blackColor].CGColor;
    self.tappi_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
    self.tappi_txt.tag = 0;
    yPosOfTxt =yPosOfTxt + heightOfTxt;
    self.tappi_txt.textColor = Blue;
    [self.tappi_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    self.tappi_txt.textAlignment =  NSTextAlignmentCenter;
    [self.tappi_txt setReturnKeyType: UIReturnKeyDone];
    self.tappi_txt.keyboardType = UIKeyboardTypeNumberPad;
    [self.tappi_txt setDelegate:self];
    [self.sub_View addSubview:self.tappi_txt];
    //[self textFieldShouldReturn:metaData_txt];
    
    
    
    for (int i =0;i<self.metaDataArray.count; i++) {
        int radioButton_y =2.5;
        int radioVutton_Vertical_Padding = 6.5;
        
        int checkboxButton_y = 2.5;
        int checkbox_Vertical_padding = 8;
        
        int yPosOfTxt = yPosOfBtn;
        NSLog(@"fiels:%@",self.metaDataArray [i]);
        FieldData *fieldData = self.metaDataArray [i];
        
       // BOOL display = fieldData.shouldDisplay;
        BOOL active = fieldData.shouldActive;
        
        BOOL Mandatary = fieldData.isMandatory;
     
        if (active == YES) {
            
            //Creating Button
            UIButton *metaData_btn = [[UIButton alloc]init];
            metaData_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn+1, widthOfBtn,heightOfBtn);
            NSLog(@"widthOfBtn%d",widthOfBtn);
            if((fieldData.fieldAttribute == FieldAttributeRadio)|| (fieldData.fieldAttribute == FieldAttributeCheckbox))
            {
                yPosOfBtn =yPosOfBtn + (verticalPadding +7);
            }else if(fieldData.fieldAttribute == FieldAttributeDatePicker){
                yPosOfBtn =yPosOfBtn + (verticalPadding +60);
                [metaData_btn addTarget:self action:@selector(datePicker_button:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                yPosOfBtn =yPosOfBtn + (verticalPadding +60);
                [metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
            }
            metaData_btn.backgroundColor = Blue;
            metaData_btn.tag = (btnTagBaseValue + i );
            tappibutTagBaseVaue = (int)metaData_btn.tag;
            NSLog(@"tag:%ld",(long)metaData_btn.tag);
            FieldData *fieldData = self.metaDataArray [i];
            NSString *Label = fieldData.strFieldLabel;
            [metaData_btn setTitle:Label forState:UIControlStateNormal];
            NSString *model=[UIDevice currentDevice].model;
            if ([model isEqualToString:@"iPad"]) {
                metaData_btn.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:21];
            }else{
                metaData_btn.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15];
            }
            metaData_btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            metaData_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            metaData_btn.layer.cornerRadius = 5;
            metaData_btn.layer.borderWidth = 1;
            metaData_btn.layer.borderColor = [UIColor blackColor].CGColor;
            metaData_btn.titleLabel.numberOfLines = 3;
            [metaData_btn setTitleEdgeInsets:UIEdgeInsetsMake(2.5, 0.0, 2.5, 0.0)];
            UILabel *assSymbolLbl = [[UILabel alloc]init];
            assSymbolLbl.frame = CGRectMake((metaData_btn.frame.size.width-25),5, 20,20);
            assSymbolLbl.textColor = [UIColor redColor];
            [assSymbolLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
            assSymbolLbl.textAlignment = NSTextAlignmentRight;

            if(Mandatary){
                assSymbolLbl.text = @"*";
                [metaData_btn addSubview:assSymbolLbl];
            }else{
                assSymbolLbl.text = @" ";
                [metaData_btn removeFromSuperview];
            }
            [self.sub_View addSubview:metaData_btn];
            
            if (fieldData.fieldAttribute == FieldAttributeNumeric || fieldData.fieldAttribute == FieldAttributeAlpha || fieldData.fieldAttribute == FieldAttributeAlphaNumeric) {
                
                    //Creating TextField
                UITextView *metaData_txt = [[UITextView alloc]init];
                metaData_txt.layer.cornerRadius = 5;
                metaData_txt.layer.borderWidth = 1;
                metaData_txt.layer.backgroundColor = [UIColor whiteColor].CGColor;
                metaData_txt.layer.borderColor = [UIColor blackColor].CGColor;
                metaData_txt.textContainer.maximumNumberOfLines = 3;
                metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                metaData_txt.textContainerInset = UIEdgeInsetsMake(2.5, 0.0, 2.5,0.0);
                metaData_txt.textColor = Blue;
                [metaData_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
                metaData_txt.textAlignment =  NSTextAlignmentLeft;
                metaData_txt.textContainer.lineBreakMode= NSLineBreakByWordWrapping;
                metaData_txt.tag = (txtTagBaseVaue +i);
                tappitxtTagBaseVaue =(int)metaData_txt.tag;
                NSLog(@"tag:%ld",(long)metaData_txt.tag);
                [metaData_txt setReturnKeyType: UIReturnKeyDone];

                if (fieldData.fieldAttribute == FieldAttributeNumeric) {
                    metaData_txt.keyboardType = UIKeyboardTypeNumberPad;
                }
                [metaData_txt setDelegate:self];
                
                [self.sub_View addSubview:metaData_txt];
                [self textFieldShouldReturn:metaData_txt];
                
                if (fields.count >0)
                {
                    [self DisplayOldValues];
                }
                else if (self.oldValuesReturn.count) {
                    [self DislpayPreviousValues];
                }
            }
            
                //if field attribute is radio
            else if (fieldData.fieldAttribute == FieldAttributeRadio)
            {
                NSLog(@"Radio");
                
                self.arr= fieldData.fieldOptions;
                
                
                UIView *RadioView = [[UIView alloc]init];
                int  count =0;
                if (self.arr.count>0) {
                    count =(int)self.arr.count;
                }
                
                radioViewheight = 30.5 *count;
                
                RadioView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt, radioViewheight);

                yPosOfBtn = yPosOfBtn +radioViewheight;
      
                RadioView.tag = (txtTagBaseVaue +i);
                NSLog(@"tag:%ld",(long)RadioView.tag);

                [self.sub_View addSubview:RadioView];
                for (int f = 0;f<self.arr.count; f++) {
                    
                    UILabel *lbl = [[UILabel alloc]init];
                    lbl.frame = CGRectMake(30,radioButton_y, widthOfTxt-30, 20);
                        //  lbl.frame = CGRectMake(40, radiobox_y, 100, 20);
                    lbl.numberOfLines = 2;
                    lbl.adjustsFontSizeToFitWidth = YES;
                    lbl.text =self.arr[f];
                        // @"01234567891011121314151617181920212223242526272829";
                    if (@available(iOS 11.0, *)) {
                        [lbl setInsetsLayoutMarginsFromSafeArea:YES];
                    } else {
                            // Fallback on earlier versions
                    }
                    lbl.textColor = [UIColor blackColor];
                    [lbl setFont: [lbl.font fontWithSize: 20]];
                    [lbl setTag:baseradioTag+f];
                    [RadioView addSubview:lbl];
                    
                    self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(0-12.5,radioButton_y-12, 50, 50)];
                    radioButton_y = radioButton_y+(radioVutton_Vertical_Padding+25);
                    [self.yourButton setImage: [UIImage imageNamed:@"radioChecked.png"]forState:UIControlStateSelected];
                    [self.yourButton setImage: [UIImage imageNamed:@"radioUnchecked.png"]forState: UIControlStateNormal];
                    self.yourButton.selected = NO;
                    
                    [self.yourButton addTarget:self action:@selector(radioSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [self.yourButton setTag:baseradioTag+f];
                    NSLog(@"%ld",(long)self.yourButton.tag);
                    [RadioView addSubview:self.yourButton];
                        //                radio_y = radio_y +(verticalPadding+5);
                        //   yPosOfBtn =radiobox_y+250;
                        //radioButton_y =radioButton_y+20;
                    
                        // radio_y = radio_y +(verticalPadding+20);
                    if (fields.count >0)
                    {
                        [self DisplayOldValues];
                    }
                    else if (self.oldValuesReturn.count) {
                        [self DislpayPreviousValues];
                        
                    }
                }
               // yPosOfBtn=yPosOfBtn-4;
               // yPosOfTxt=yPosOfTxt-4;
            }
            else if (fieldData.fieldAttribute == FieldAttributeCheckbox)
            {
                NSLog(@"checkbox");
                self.arr= fieldData.fieldOptions;
                UIView *CheckboxView = [[UIView alloc]init];
                int count = self.arr.count;
                checkBoxViewheight = 32 *count;
                CheckboxView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt,checkBoxViewheight );
                yPosOfBtn = yPosOfBtn+checkBoxViewheight;
                CheckboxView.tag = (txtTagBaseVaue +i);
                NSLog(@"tag:%ld",(long)CheckboxView.tag);
                [self.sub_View addSubview:CheckboxView];
                
                int checkbox_y=yPosOfTxt;
                for (int f = 0; f<self.arr.count; f++) {
                    
                    UILabel *lbl = [[UILabel alloc]init];
                    lbl.frame = CGRectMake(30,checkboxButton_y+2,widthOfTxt-30,20);
                    lbl.numberOfLines = 2;
                    lbl.adjustsFontSizeToFitWidth = YES;
                    lbl.text=self.arr[f];
                        //@"01234567891011121314151617181920212223242526272829";
                    if (@available(iOS 11.0, *)) {
                        [lbl setInsetsLayoutMarginsFromSafeArea:YES];
                    } else {
                            // Fallback on earlier versions
                    }
                    [lbl setFont: [lbl.font fontWithSize: 20]];
                        //  label.font = [UIFont fontWithName:gMainFont size:label.height];
                        // lbl.minimumScaleFactor = 0.1;
                    lbl.textColor = [UIColor blackColor];
                    [lbl setTag:basecheckboxTag+f];
                    [CheckboxView addSubview:lbl];
                    
                    self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(0,checkboxButton_y,25,25)];
                    
                    checkboxButton_y = checkboxButton_y+(checkbox_Vertical_padding+24);
                    [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"uncheckclicked.png"] forState:UIControlStateNormal];
                    [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkclick.png"] forState:UIControlStateSelected];
                    [self.checkBoxButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [self.checkBoxButton setTag:basecheckboxTag+f];
                    
                    [CheckboxView addSubview:self.checkBoxButton];
                    
                    if (fields.count >0)
                    {
                        [self DisplayOldValues];
                    }
                    else if (self.oldValuesReturn.count) {
                        [self DislpayPreviousValues];
                    }
                }
                //yPosOfBtn=yPosOfBtn-3;
                //yPosOfTxt=yPosOfTxt-3;
            } else if (fieldData.fieldAttribute == FieldAttributeBarcode){
                
                UIButton *meta_label = [[UIButton alloc] init] ;
                meta_label.frame =  CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                meta_label.layer.cornerRadius = 5;
                meta_label.layer.borderWidth = 1;
                meta_label.layer.backgroundColor = [UIColor whiteColor].CGColor;
                meta_label.layer.borderColor = [UIColor blackColor].CGColor;
                    //meta_label.tintColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
                meta_label.titleLabel.textColor=Blue;
                [meta_label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                
                meta_label.tag = (lblTagBaseValue + i );
                NSLog(@"tag:%ld",(long)meta_label.tag);
                [meta_label addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
                [self.sub_View addSubview:meta_label];
                if (fields.count >0)
                {
                    [self DisplayOldValues];
                }
                else if (self.oldValuesReturn.count) {
                    [self DislpayPreviousValues];
                    
                }
                
            }else if (fieldData.fieldAttribute == FieldAttributeDatePicker){
                //button_datepicker
                UIButton* meta_btn_datePicker = [[UIButton alloc] init] ;
                meta_btn_datePicker.frame =  CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                [meta_btn_datePicker setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                meta_btn_datePicker.layer.cornerRadius = 5;
                meta_btn_datePicker.layer.borderWidth = 1;
                meta_btn_datePicker.layer.borderColor = [UIColor blackColor].CGColor;
              
                meta_btn_datePicker.userInteractionEnabled = YES;
                meta_btn_datePicker.tag = (baseDateTag + i );
                NSLog(@"tag:%ld",(long)meta_btn_datePicker.tag);

                [meta_btn_datePicker addTarget:self action:@selector(datePicker_button:)forControlEvents:UIControlEventTouchUpInside];
                [self.sub_View addSubview:meta_btn_datePicker];
            }
            
        }
    }
    

    self.sub_View_Height = yPosOfBtn+heightOfBtn+verticalPadding;

    CGRect newFrame = CGRectMake( 0, 0, self.view.frame.size.width-10, self.sub_View_Height);
    self.sub_View.frame = newFrame;
    //NSString *model=[UIDevice currentDevice].model;
    if ([model isEqualToString:@"iPad"]) {
        self.scroll_View.frame =  CGRectMake( 5, 30, self.sub_View.frame.size.width,self.view.frame.size.height - 70) ;
    }else{
        self.scroll_View.frame =  CGRectMake( 5, 30, self.sub_View.frame.size.width,self.view.frame.size.height -50) ;
    }
       // self.scroll_View.backgroundColor = [UIColor redColor];
       // self.subView.backgroundColor =[UIColor blueColor];
    [self.scroll_View setContentSize:CGSizeMake(self.sub_View.frame.size.width, self.sub_View_Height)];
    self.scroll_View.delegate = self;
}



//NormalFlow-MetaData
-(void)createMetaData
{
    NSMutableArray *parkloadarray=[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload=[parkloadarray objectAtIndex:currentloadnumber];
    SiteData *sites = self.siteData;
    hasCustomCategory = false;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on *add_on=[self.siteData.categoryAddon objectAtIndex:index];
        if ([add_on.addonName isEqual:@"addon_5"] && add_on.addonStatus.boolValue) {
            hasCustomCategory=true;
            break;
        }
    }

    if (hasCustomCategory) {
        
        for (int i=0; i<self.siteData.customCategory.count; i++) {
            CategoryData *dict = self.siteData.customCategory[i];
            if ([[parkload objectForKey:@"category"] isEqual:dict.categoryName]) {
                self.metaDataArray = dict.categoryMetaArray;
                NSLog(@"dict.categoryMetaArray:%@",dict.categoryMetaArray);
            }
        }
        
    }else{
        self.metaDataArray = sites.arrFieldData;
        NSLog(@"sites.arrFieldData:%@",sites.arrFieldData);
    }
        //button
    int verticalPadding = 3;
    int horizontalPadding  = 3;
    int heightOfBtn = 60;
    int widthOfBtn = self.scroll_View.frame.size.width/2 ;
    int xPosOfBtn = 10;
    int y =verticalPadding;
    int yPosOfBtn;
        //text field Values
    int heightOfTxt = 60;
    int xPosOfTxt =horizontalPadding + widthOfBtn +15;
    int widthOfTxt= self.scroll_View.frame.size.width-(xPosOfTxt+horizontalPadding+horizontalPadding);

    yPosOfBtn = verticalPadding;

    int btnTagBaseValue = 200;
    int lblTagBaseValue = 400;
    int txtTagBaseVaue = 100;
    int baseDateTag = 400;
    int basecheckboxTag = 300;

    int baseradioTag = 300;

    int radioViewheight ;
    int checkBoxViewheight;

    NSMutableArray *fields=[parkload objectForKey:@"fields"];
        //iterating the fieldata array
    for (int i =0;i<self.metaDataArray.count; i++) {
        int radioButton_y =2.5;
        int radioVutton_Vertical_Padding = 6.5;
        
        int checkboxButton_y = 2.5;
        int checkbox_Vertical_padding = 8;
        
        int yPosOfTxt = yPosOfBtn;
        FieldData *fieldData = self.metaDataArray [i];
        NSLog(@"fiels:%@",self.metaDataArray [i]);

        BOOL display = fieldData.shouldDisplay;
        BOOL active = fieldData.shouldActive;
        
        BOOL Mandatary = fieldData.isMandatory;
     
        if (active == YES) {
            
            //Creating Button
            UIButton *metaData_btn = [[UIButton alloc]init];
            metaData_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn, widthOfBtn,heightOfBtn);
            NSLog(@"widthOfBtn%d",widthOfBtn);
            if((fieldData.fieldAttribute == FieldAttributeRadio)|| (fieldData.fieldAttribute == FieldAttributeCheckbox))
            {
                yPosOfBtn =yPosOfBtn + (verticalPadding +7);
            }else if(fieldData.fieldAttribute == FieldAttributeDatePicker){
                yPosOfBtn =yPosOfBtn + (verticalPadding +60);
                [metaData_btn addTarget:self action:@selector(datePicker_button:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                yPosOfBtn =yPosOfBtn + (verticalPadding +60);
                [metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
            }
            metaData_btn.backgroundColor = Blue;
            metaData_btn.tag = (btnTagBaseValue + i );
            NSLog(@"metaDataArray:%@",self.metaDataArray);
            FieldData *fieldData =self.metaDataArray [i];
            NSString *Label = fieldData.strFieldLabel;
            [metaData_btn setTitle:Label forState:UIControlStateNormal];
            NSString *model=[UIDevice currentDevice].model;
            if ([model isEqualToString:@"iPad"]) {
                metaData_btn.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:21];
            }else{
                metaData_btn.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15];
            }
            metaData_btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            metaData_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            metaData_btn.layer.cornerRadius = 5;
            metaData_btn.layer.borderWidth = 1;
            metaData_btn.layer.borderColor = [UIColor blackColor].CGColor;
            metaData_btn.titleLabel.numberOfLines = 3;
            [metaData_btn setTitleEdgeInsets:UIEdgeInsetsMake(2.5, 0.0, 2.5, 0.0)];
            UILabel *assSymbolLbl = [[UILabel alloc]init];
            assSymbolLbl.frame = CGRectMake((metaData_btn.frame.size.width-25),5, 20,20);
            assSymbolLbl.textColor = [UIColor redColor];
            [assSymbolLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
            assSymbolLbl.textAlignment = NSTextAlignmentRight;

            if(Mandatary){
                assSymbolLbl.text = @"*";
                [metaData_btn addSubview:assSymbolLbl];
            }else{
                assSymbolLbl.text = @" ";
                [metaData_btn removeFromSuperview];
            }
            [self.sub_View addSubview:metaData_btn];
            
            if (fieldData.fieldAttribute == FieldAttributeNumeric || fieldData.fieldAttribute == FieldAttributeAlpha || fieldData.fieldAttribute == FieldAttributeAlphaNumeric) {
                
                    //Creating TextField
                UITextView *metaData_txt = [[UITextView alloc]init];
                [metaData_txt setDelegate:self];
                metaData_txt.layer.cornerRadius = 5;
                metaData_txt.layer.borderWidth = 1;
                metaData_txt.layer.backgroundColor = [UIColor whiteColor].CGColor;
                metaData_txt.layer.borderColor = [UIColor blackColor].CGColor;
                metaData_txt.textContainer.maximumNumberOfLines = 3;
                metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                metaData_txt.textContainerInset = UIEdgeInsetsMake(2.5, 0.0, 2.5,0.0);
                metaData_txt.textColor = Blue;
                [metaData_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
                metaData_txt.textAlignment =  NSTextAlignmentLeft;
                metaData_txt.textContainer.lineBreakMode= NSLineBreakByWordWrapping;
                metaData_txt.tag = (txtTagBaseVaue +i);
                NSLog(@"metaData_txt:%ld",(long)metaData_txt.tag);
                [metaData_txt setReturnKeyType: UIReturnKeyDone];

                if (fieldData.fieldAttribute == FieldAttributeNumeric) {
                    metaData_txt.keyboardType = UIKeyboardTypeNumberPad;
                }
                [metaData_txt setDelegate:self];
                
                [self.sub_View addSubview:metaData_txt];
                [self textFieldShouldReturn:metaData_txt];
                
                if (fields.count >0)
                {
                    [self DisplayOldValues];
                }
                else if (self.oldValuesReturn.count) {
                    [self DislpayPreviousValues];
                    
                }
            }
            
                //if field attribute is radio
            else if (fieldData.fieldAttribute == FieldAttributeRadio)
            {
                NSLog(@"Radio");
                
                self.arr= fieldData.fieldOptions;
                
                
                UIView *RadioView = [[UIView alloc]init];
                int  count =0;
                if (self.arr.count>0) {
                    count =(int)self.arr.count;
                }
                
                radioViewheight = 30.5 *count;
                
                RadioView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt, radioViewheight);

                yPosOfBtn = yPosOfBtn +radioViewheight;
      
                RadioView.tag = (txtTagBaseVaue +i);
                
                [self.sub_View addSubview:RadioView];
                for (int f = 0;f<self.arr.count; f++) {
                    
                    UILabel *lbl = [[UILabel alloc]init];
                    lbl.frame = CGRectMake(30,radioButton_y, widthOfTxt-30, 20);
                        //  lbl.frame = CGRectMake(40, radiobox_y, 100, 20);
                    lbl.numberOfLines = 2;
                    lbl.adjustsFontSizeToFitWidth = YES;
                    lbl.text =self.arr[f];
                        // @"01234567891011121314151617181920212223242526272829";
                    if (@available(iOS 11.0, *)) {
                        [lbl setInsetsLayoutMarginsFromSafeArea:YES];
                    } else {
                            // Fallback on earlier versions
                    }
                    lbl.textColor = [UIColor blackColor];
                    [lbl setFont: [lbl.font fontWithSize: 20]];
                    [lbl setTag:baseradioTag+f];
                    [RadioView addSubview:lbl];
                    
                    self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(0-12.5,radioButton_y-12, 50, 50)];
                    radioButton_y = radioButton_y+(radioVutton_Vertical_Padding+25);
                    [self.yourButton setImage: [UIImage imageNamed:@"radioChecked.png"]forState:UIControlStateSelected];
                    [self.yourButton setImage: [UIImage imageNamed:@"radioUnchecked.png"]forState: UIControlStateNormal];
                    self.yourButton.selected = NO;
                    
                    [self.yourButton addTarget:self action:@selector(radioSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [self.yourButton setTag:baseradioTag+f];
                    NSLog(@"%ld",(long)self.yourButton.tag);
                    [RadioView addSubview:self.yourButton];
                        //                radio_y = radio_y +(verticalPadding+5);
                        //   yPosOfBtn =radiobox_y+250;
                        //radioButton_y =radioButton_y+20;
                    
                        // radio_y = radio_y +(verticalPadding+20);
                    if (fields.count >0)
                    {
                        [self DisplayOldValues];
                    }
                    else if (self.oldValuesReturn.count) {
                        [self DislpayPreviousValues];
                        
                    }
                }
               // yPosOfBtn=yPosOfBtn-4;
               // yPosOfTxt=yPosOfTxt-4;
            }
            else if (fieldData.fieldAttribute == FieldAttributeCheckbox)
            {
                NSLog(@"checkbox");
                self.arr= fieldData.fieldOptions;
                UIView *CheckboxView = [[UIView alloc]init];
                int count = self.arr.count;
                checkBoxViewheight = 32 *count;
                CheckboxView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt,checkBoxViewheight );
                yPosOfBtn = yPosOfBtn+checkBoxViewheight;
                CheckboxView.tag = (txtTagBaseVaue +i);
                [self.sub_View addSubview:CheckboxView];
                
                int checkbox_y=yPosOfTxt;
                for (int f = 0; f<self.arr.count; f++) {
                    
                    UILabel *lbl = [[UILabel alloc]init];
                    lbl.frame = CGRectMake(30,checkboxButton_y+2,widthOfTxt-30,20);
                    lbl.numberOfLines = 2;
                    lbl.adjustsFontSizeToFitWidth = YES;
                    lbl.text=self.arr[f];
                        //@"01234567891011121314151617181920212223242526272829";
                    if (@available(iOS 11.0, *)) {
                        [lbl setInsetsLayoutMarginsFromSafeArea:YES];
                    } else {
                            // Fallback on earlier versions
                    }
                    [lbl setFont: [lbl.font fontWithSize: 20]];
                        //  label.font = [UIFont fontWithName:gMainFont size:label.height];
                        // lbl.minimumScaleFactor = 0.1;
                    lbl.textColor = [UIColor blackColor];
                    [lbl setTag:basecheckboxTag+f];
                    [CheckboxView addSubview:lbl];
                    
                    self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(0,checkboxButton_y,25,25)];
                    
                    checkboxButton_y = checkboxButton_y+(checkbox_Vertical_padding+24);
                    [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"uncheckclicked.png"] forState:UIControlStateNormal];
                    [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkclick.png"] forState:UIControlStateSelected];
                    [self.checkBoxButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [self.checkBoxButton setTag:basecheckboxTag+f];
                    
                    [CheckboxView addSubview:self.checkBoxButton];
                    
                    if (fields.count >0)
                    {
                        [self DisplayOldValues];
                    }
                    else if (self.oldValuesReturn.count) {
                        [self DislpayPreviousValues];
                    }
                }
                //yPosOfBtn=yPosOfBtn-3;
                //yPosOfTxt=yPosOfTxt-3;
            } else if (fieldData.fieldAttribute == FieldAttributeBarcode){
                
                UIButton *meta_label = [[UIButton alloc] init] ;
                meta_label.frame =  CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                meta_label.layer.cornerRadius = 5;
                meta_label.layer.borderWidth = 1;
                meta_label.layer.backgroundColor = [UIColor whiteColor].CGColor;
                meta_label.layer.borderColor = [UIColor blackColor].CGColor;
                    //meta_label.tintColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
                meta_label.titleLabel.textColor=Blue;
                [meta_label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                
                meta_label.tag = (lblTagBaseValue + i );
                
                [meta_label addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
                [self.sub_View addSubview:meta_label];
                if (fields.count >0)
                {
                    [self DisplayOldValues];
                }
                else if (self.oldValuesReturn.count) {
                    [self DislpayPreviousValues];
                    
                }
                
            }else if (fieldData.fieldAttribute == FieldAttributeDatePicker){
                //button_datepicker
                UIButton* meta_btn_datePicker = [[UIButton alloc] init] ;
                meta_btn_datePicker.frame =  CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                [meta_btn_datePicker setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                meta_btn_datePicker.layer.cornerRadius = 5;
                meta_btn_datePicker.layer.borderWidth = 1;
                meta_btn_datePicker.layer.borderColor = [UIColor blackColor].CGColor;
              
                meta_btn_datePicker.userInteractionEnabled = YES;
                meta_btn_datePicker.tag = (baseDateTag + i );
                [meta_btn_datePicker addTarget:self action:@selector(datePicker_button:)forControlEvents:UIControlEventTouchUpInside];
                [self.sub_View addSubview:meta_btn_datePicker];
                
                if (fields.count >0)
                {
                    [self DisplayOldValues];
                }else if (self.oldValuesReturn.count) {
                    [self DislpayPreviousValues];
                    
                }
            }
        }
       
    }

    self.sub_View_Height = yPosOfBtn+heightOfBtn+verticalPadding;

    CGRect newFrame = CGRectMake( 0, 0, self.view.frame.size.width-10, self.sub_View_Height);
    self.sub_View.frame = newFrame;
    NSString *model=[UIDevice currentDevice].model;
    if ([model isEqualToString:@"iPad"]) {
        self.scroll_View.frame =  CGRectMake( 5, 30, self.sub_View.frame.size.width,self.view.frame.size.height - 70) ;
    }else{
        self.scroll_View.frame =  CGRectMake( 5, 30, self.sub_View.frame.size.width,self.view.frame.size.height -50) ;
    }
       // self.scroll_View.backgroundColor = [UIColor redColor];
       // self.subView.backgroundColor =[UIColor blueColor];
    [self.scroll_View setContentSize:CGSizeMake(self.sub_View.frame.size.width, self.sub_View_Height)];
    self.scroll_View.delegate = self;
}


-(void) datePicker_button:(UIButton *)sender
{
    self.senderTag=(int)sender.tag;
    FieldData *fieldData= [self.metaDataArray objectAtIndex:(self.senderTag % 100)];
    
    //alertview_for_datepicker
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Select Date",@"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") otherButtonTitles:@"OK" ,nil];

    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 750, 616)];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [picker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    [picker setTintColor:[UIColor blackColor] ];
    picker.backgroundColor = [UIColor colorWithRed: 0.11 green: 0.65 blue: 0.71 alpha: 0.5f ] ;
    [picker setTimeZone:[NSTimeZone systemTimeZone]];
    [picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    [alert addSubview:picker];
    //alert.bounds = CGRectMake(0, 0, 360, alert.bounds.size.height + 216 + 20);
    [alert setValue:picker forKey:@"accessoryView"];
    [alert setCancelButtonIndex:0];
    [alert show];
    
    //datePicker_formate
    
    NSDateFormatter *fromatter = [[NSDateFormatter alloc]init];
    [fromatter setDateFormat:@"MM-dd-yyyy"];
    
    //set_value_for_labelf
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@" %@",[fromatter stringFromDate:picker.date]] forKey:@"datePicker"];
    [[NSUserDefaults standardUserDefaults]setInteger:self.senderTag forKey:@"datePickerTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *label=[[NSUserDefaults standardUserDefaults] objectForKey:@"datePicker"];
    NSInteger labeltag=[[NSUserDefaults standardUserDefaults] integerForKey:@"datePickerTag"];
    [self sendStringViewController:label withTag:labeltag];
}

- (void)alertView:(UIAlertView *)alertView
                   clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        
        //setValueToUserDefault
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"datePicker"];
        [[NSUserDefaults standardUserDefaults] setInteger:self.senderTag forKey:@"datePickerTag"];
        
        //SetValueToLabel
        NSString *label = [[NSUserDefaults standardUserDefaults] objectForKey:@"datePicker"];
        NSInteger labeltag = [[NSUserDefaults standardUserDefaults] integerForKey :@"datePickerTag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self sendStringViewController:label withTag:labeltag];
    }
}

-(IBAction)pickerChanged:(id)sender{
    //self.senderTag = (int)sender;
    //datePicker
    NSDateFormatter *fromatter=[[NSDateFormatter alloc]init];
    [fromatter setDateFormat:@"MM-dd-yyyy"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@" %@",[fromatter stringFromDate:picker.date]] forKey:@"datePicker"];
    [[NSUserDefaults standardUserDefaults]setInteger:self.senderTag forKey:@"datePickerTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //DatePicker
    NSString *label=[[NSUserDefaults standardUserDefaults] objectForKey:@"datePicker"];
    NSInteger labeltag=[[NSUserDefaults standardUserDefaults] integerForKey:@"datePickerTag"];
    if (label!=nil && labeltag>0) {
        NSString *str=TRIM(label);
        if (str.length>0) {
            [self sendStringViewController:label withTag:labeltag];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"datePicker"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"datePickerTag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
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
    //[self adjustFrames:_textView];
    return YES;
}

-(void) adjustFrames:(UITextView *) metaData_txt
{
    CGRect textFrame = metaData_txt.frame;
    //textFrame.size.height = metaData_txt.contentSize.height;
    if (metaData_txt.text.length >0) {
        NSLog(@"metaData_txt adj:%@",metaData_txt);
    while (metaData_txt.contentSize.height
           < textFrame.size.height) {
        metaData_txt.font = [metaData_txt.font fontWithSize:metaData_txt.font.pointSize+1];
        //NSLog(@"Font size :%@",metaData_txt.font);
        if (metaData_txt.contentSize.height==textFrame.size.height) {
            break;
        }
    }
        while (metaData_txt.contentSize.height
               > textFrame.size.height) {
            metaData_txt.font = [metaData_txt.font fontWithSize:metaData_txt.font.pointSize-1];
            //NSLog(@"Font size :%@",metaData_txt.font);
            if (metaData_txt.contentSize.height==textFrame.size.height) {
                break;
            }
        }
    }
    //metaData_txt.frame = textFrame;
}



//new editing
-(void)checkboxSelected:(UIButton*)sender  {
    sender.selected = !sender.selected;
}

-(void)radioSelected:(UIButton*)sender {
    UIButton *currentButton = (UIButton *)sender;
    for(UIView *view in self.sub_View.subviews){
        
        if([view isKindOfClass:[UIButton class]]){        }
        else if ([view isKindOfClass:[UIView class]])
        {
            for(UIView *CustomView in currentButton.superview.subviews)
            {
                if([CustomView isKindOfClass:[currentButton class]]){
                    UIButton *btn = (UIButton *)CustomView;
                    [btn setSelected:NO];
                }
            }
        }
    }
    [currentButton setSelected:YES];
}

-(void)removesubview
{
    NSArray *subviews = [self.sub_View subviews];
    for (UIView *newView in subviews) {
        [newView removeFromSuperview];
    }
}

-(void)DislpayPreviousValues
{
    NSArray *subviews = [self.sub_View subviews];
    for (UIView *newView in subviews) {
        if ([newView isKindOfClass:[UITextView class]]) {
            UITextView *textField = (UITextView *) newView;
            NSInteger tag = newView.tag;
            int index = (int)tag -100;
            NSLog(@" index:%d",index);
            NSDictionary *field = [[NSDictionary alloc]init];
            [self.view makeToast:NSLocalizedString(@"Data Fetch Error",@"")];
            FieldData *newFields=[self.metaDataArray objectAtIndex:(index)];
            
            if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                NSString *sstring  =[self.oldValuesReturn objectAtIndex:index];
                [textField setText:sstring];
            }else{
                NSLog(@"Data Not Displayed:\nIndex: %d,\tOld: %@,\tNew: %d",index,[field objectForKey:@"field_id"],newFields.fieldId);
                for (int iterator=index+1; iterator<self.metaDataArray.count; iterator++) {
                    FieldData *newFields=[self.metaDataArray objectAtIndex:(iterator)];
                    if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                        NSString *sstring  =[field objectForKey:@"field_value"];
                        [textField setText:sstring];
                    }
                }
            }
        }
    }
}

-(void)DisplayOldValues
{
    NSArray *subviews = [self.sub_View subviews];
    NSString *stored_lbl ;
    int buttonIndex = 500;
    BOOL isTheObjectThere;
    NSMutableArray *parkloadarray=[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload=[parkloadarray objectAtIndex:currentloadnumber];
    for (UIView *newView in subviews) {
        
        if ([newView isKindOfClass:[UITextView class]]) {
            UITextView *textField = (UITextView *) newView;
            NSString *str = textField.text;
            NSLog(@"%@",str);
            NSInteger tag = newView.tag;
            
            int index = (int)tag - 100;
                //  NSLog(@" index:%d",index);
            
            NSMutableArray *OldLoadFieldsfields = [[NSMutableArray alloc]init];
            if(hasAddon8 && !hasCustomCategory && !hasAddon7){
                OldLoadFieldsfields = [parkload objectForKey:@"basefields"];
                self.tappi_txt.text = [parkload objectForKey:@"tappi_count"];

            }else{
                OldLoadFieldsfields = [parkload objectForKey:@"fields"];
            }
            NSDictionary *field = [[NSDictionary alloc]init];
            if (OldLoadFieldsfields != nil && index < OldLoadFieldsfields.count) {
                field = [OldLoadFieldsfields objectAtIndex:index];
                FieldData *newFields=[self.metaDataArray objectAtIndex:(index)];
                
                
                if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                    NSString *sstring  =[field objectForKey:@"field_value"];
                    [textField setText:sstring];
                }else{
                    NSLog(@"Data not displayed:\nIndex: %d,\tOld: %@,\tNew: %d",index,[field objectForKey:@"field_id"],newFields.fieldId);
                    for (int iterator=0; iterator<OldLoadFieldsfields.count; iterator++) {
                        field=[OldLoadFieldsfields objectAtIndex:(iterator)];
                        if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                            NSString *sstring  =[field objectForKey:@"field_value"];
                            [textField setText:sstring];
                        }
                    }
                    
                }
            }
        }else if ([newView  isKindOfClass:[UILabel class ]])
        {
            NSLog(@"Label");
            UILabel *labField = (UILabel *) newView;
            NSString *str = labField.text;
            NSLog(@"%@",str);
            NSInteger tag = newView.tag;
            if (tag>=400) {
                labField.textColor = Blue;
                int index = (int)tag - 400;
                NSMutableArray *OldLoadFieldsfields = [[NSMutableArray alloc]init];
                if(hasAddon8 && !hasCustomCategory && !hasAddon7){
                    OldLoadFieldsfields = [parkload objectForKey:@"basefields"];
                    self.tappi_txt.text = [parkload objectForKey:@"tappi_count"];
                }else{
                    OldLoadFieldsfields = [parkload objectForKey:@"fields"];
                }
                NSDictionary *field = [[NSDictionary alloc]init];
                if (OldLoadFieldsfields != nil && index < OldLoadFieldsfields.count) {
                    field = [OldLoadFieldsfields objectAtIndex:index];
                    FieldData *newFields=[self.metaDataArray objectAtIndex:(index)];
                    
                    if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                        NSString *sstring  =[field objectForKey:@"field_value"];
                        labField.text = sstring;
                    }else{
                        NSLog(@"Data not displayed:\nIndex: %d,\tOld: %@,\tNew: %d",index,[field objectForKey:@"field_id"],newFields.fieldId);
                        for (int iterator=0; iterator<OldLoadFieldsfields.count; iterator++) {
                            field=[OldLoadFieldsfields objectAtIndex:(iterator)];
                            if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                                NSString *sstring  =[field objectForKey:@"field_value"];
                                labField.text = sstring;
                            }
                        }
                    }
                }
            }
        }
        else if ([newView  isKindOfClass:[UIButton class]])
        {
            NSLog(@"button");
            UIButton *butField = (UIButton *) newView;
            NSString *str = butField.currentTitle;
            NSLog(@"%@",str);
            NSInteger tag = newView.tag;
            if (tag>=400) {
                
                [butField setTitleColor:Blue forState:UIControlStateNormal];
                
                int index = (int)tag - 400;
                
                NSMutableArray *OldLoadFieldsfields = [[NSMutableArray alloc]init];
                if(hasAddon8 && !hasCustomCategory && !hasAddon7){
                    OldLoadFieldsfields = [parkload objectForKey:@"basefields"];
                    self.tappi_txt.text = [parkload objectForKey:@"tappi_count"];
                }else{
                    OldLoadFieldsfields = [parkload objectForKey:@"fields"];
                }
                NSDictionary *field = [[NSDictionary alloc]init];
                if (OldLoadFieldsfields != nil && index < OldLoadFieldsfields.count) {
                    field = [OldLoadFieldsfields objectAtIndex:index];
                    FieldData *newFields=[self.metaDataArray objectAtIndex:(index)];
                    
                    if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                        
                        NSString *sstring  =[field objectForKey:@"field_value"];
                        [butField setTitle:sstring forState:UIControlStateNormal];
                    }else{
                        NSLog(@"Data not displayed:\nIndex: %d,\tOld: %@,\tNew: %d",index,[field objectForKey:@"field_id"],newFields.fieldId);
                        for (int iterator=0; iterator<OldLoadFieldsfields.count; iterator++) {
                            field=[OldLoadFieldsfields objectAtIndex:(iterator)];
                            if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                                
                                NSString *sstring  =[field objectForKey:@"field_value"];
                                [butField setTitle:sstring forState:UIControlStateNormal];
                            }
                        }
                    }
                }
            }
        }
            //    check view is  a view or not
        else if ([newView  isKindOfClass:[UIView class]])
        {
            
            int tag = newView.tag;
            int index;
            
            index = (int)tag - 100;
            NSLog(@"UIVIEW");
            NSMutableArray *OldLoadFieldsfields = [[NSMutableArray alloc]init];
            if(hasAddon8 && !hasCustomCategory && !hasAddon7){
                OldLoadFieldsfields = [parkload objectForKey:@"basefields"];
                self.tappi_txt.text = [parkload objectForKey:@"tappi_count"];
            }else{
                OldLoadFieldsfields = [parkload objectForKey:@"fields"];
            }
                if(OldLoadFieldsfields !=nil&& index < OldLoadFieldsfields.count){
                NSDictionary *field = [[NSDictionary alloc]init];
                field = [OldLoadFieldsfields objectAtIndex:index];
                FieldData *newFields=[self.metaDataArray objectAtIndex:(index)];
                
                if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                    NSMutableArray *storedValue = [[NSMutableArray alloc]init];
                    
                    storedValue =[field objectForKey:@"field_value"];
                    NSArray *buttonViews = [newView subviews];
                    for (UIView *buttonView in buttonViews) {
                        
                        if ([buttonView isKindOfClass:[UILabel class]]) {
                            int tag = buttonView.tag;
                            tag = tag - 300;
                                // buttonIndex = tag;
                            
                            UILabel *label = (UILabel *) buttonView;
                            stored_lbl   = label.text;
                            isTheObjectThere = [storedValue containsObject:stored_lbl];
                            if (isTheObjectThere) {
                                buttonIndex = tag;
                                NSLog(@"Yes Object there ");
                                    // int iindexOfButton =
                            }
                            else
                                buttonIndex = -1;
                        }
                        if ([buttonView isKindOfClass:[UIButton class]]) {
                            int tag = buttonView.tag;
                            tag = tag - 300;
                            if (tag == buttonIndex) {
                                UIButton *SelectedButton = (UIButton *) buttonView;
                                SelectedButton.selected = YES;
                            }
                        }
                    }
                }else{
                    NSLog(@"Data not displayed:\nIndex: %d,\tOld: %@,\tNew: %d",index,[field objectForKey:@"field_id"],newFields.fieldId);
                    for (int iterator=0; iterator<OldLoadFieldsfields.count; iterator++) {
                        field=[OldLoadFieldsfields objectAtIndex:(iterator)];
                        if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                            NSMutableArray *storedValue = [[NSMutableArray alloc]init];
                            
                            storedValue =[field objectForKey:@"field_value"];
                            NSArray *buttonViews = [newView subviews];
                            for (UIView *buttonView in buttonViews) {
                                
                                if ([buttonView isKindOfClass:[UILabel class]]) {
                                    int tag = buttonView.tag;
                                    tag = tag - 300;
                                        // buttonIndex = tag;
                                    
                                    UILabel *label = (UILabel *) buttonView;
                                    stored_lbl   = label.text;
                                    isTheObjectThere = [storedValue containsObject:stored_lbl];
                                    if (isTheObjectThere) {
                                        buttonIndex = tag;
                                        NSLog(@"Yes Object there ");
                                            // int iindexOfButton =
                                    }
                                    else
                                        buttonIndex = -1;
                                }
                                if ([buttonView isKindOfClass:[UIButton class]]) {
                                    int tag = buttonView.tag;
                                    tag = tag - 300;
                                    if (tag == buttonIndex) {
                                        UIButton *SelectedButton = (UIButton *) buttonView;
                                        SelectedButton.selected = YES;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


#pragma mark - Text Field Delegate Methods


-(BOOL)textFieldShouldBeginEditing:(UITextView *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextView *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Other methods  Methods

#pragma mark - IBAction Methods


-(IBAction)next:(id)sender {
    NSMutableArray *subviews = [self.sub_View subviews];
    NSLog(@"subviews:%@",[self.sub_View subviews]);

    NSMutableArray *arrFieldValues = [NSMutableArray array];
    BOOL isSucceeded = YES;
    BOOL ischeckBox = YES;

    for (UIView *newView in subviews) {
        if([newView isKindOfClass:[UITextView class]])
        {
            //if sub-view is a textfield
            int tag = newView.tag;
            int index;
            if(tag > 0){
                if (tag > 0) {
                    index = (int)tag - 100;
                }
                else
                {
                    index = tag +1;
                }
                NSLog(@"index:%d",index);
                
                FieldData *fieldData = [self.metaDataArray objectAtIndex:index];
                BOOL mandatary = fieldData.isMandatory;
                NSString *label = fieldData.strFieldLabel;
                int  length = fieldData.fieldLength;
                UITextView *textField = (UITextView *) newView;
                NSString *inputString = textField.text;
                inputString=[inputString stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
                if (mandatary == YES) {
                    
                    if (inputString.length == 0) {
                        
                        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@" Enter %@",@""),label];
                        
                        [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                        isSucceeded = NO;
                        break;
                    }
                }
                
                NSMutableDictionary *dictFieldValue = [NSMutableDictionary dictionary];
                if (inputString.length > 0)
                {
                    if (fieldData.fieldAttribute == FieldAttributeNumeric) {
                        
                        BOOL matches = [self isNumeric:inputString];
                        if (!matches) {
                            
                            NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Enter Numeric Characters in %@",@""),label];
                            
                            [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                            isSucceeded = NO;
                            break;
                        }
                    }
                    else if (fieldData.fieldAttribute == FieldAttributeAlpha)
                    {
                        BOOL matches = [self isAlpha:inputString];
                        if (!matches) {
                            
                            NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Enter Alpha Characters in %@",@""),label];
                            [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                            isSucceeded = NO;
                            break;
                        }
                    }
                    if (inputString.length > length) {
                        
                        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@" Enter %d Characters in %@",@""),length,label];
                        
                        [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                        isSucceeded = NO;
                        break;}
                }
                if (isSucceeded)
                {
                    [dictFieldValue setObject:@(fieldData.fieldId) forKey:@"field_id"];
                    [dictFieldValue setObject:inputString forKey:@"field_value"];
                    [dictFieldValue setObject:fieldData.isMandatory?@"1":@"0"
                                       forKey:@"field_mandatory"];
                    switch (fieldData.fieldAttribute)
                    {
                        case FieldAttributeAlpha:
                            [dictFieldValue setObject:@"Alpha" forKey:@"field_attribute"];
                            break;
                        case FieldAttributeNumeric:
                            [dictFieldValue setObject:@"Numeric" forKey:@"field_attribute"];
                            break;
                        case FieldAttributeAlphaNumeric:
                            [dictFieldValue setObject:@"Alpha/Numeric" forKey:@"field_attribute"];
                            break;
                    }
                    [arrFieldValues addObject:dictFieldValue];
                }
                    
            }
        }
        else if ([newView  isKindOfClass:[UIButton class]])
        {
            if(newView.tag >0){
            if(newView.tag >= 400){
                int tag = newView.tag;
                int index;
                if (tag > 0) {
                    index = (int)tag - 400;
                }
                NSLog(@"index:%d",index);
                FieldData *fieldData = [self.metaDataArray objectAtIndex:index];
                BOOL mandatary = fieldData.isMandatory;
                NSString *label = fieldData.strFieldLabel;
                int  length = fieldData.fieldLength;
                UIButton *butField = (UIButton *) newView;
                NSString *inputString =@"";
                if (butField.currentTitle!=nil) {
                    inputString=butField.currentTitle;
                }
                if (mandatary == YES) {
                    if (inputString.length == 0) {
                        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@" Enter %@",@""),label];
                        [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                        isSucceeded = NO;
                        break;
                        NSLog(@"enter characters");
                    }
                }
                NSMutableDictionary *dictFieldValue = [NSMutableDictionary dictionary];
                if (inputString.length > 0)
                {
                    BOOL matches = inputString; //[self isBarcode:inputString];
                    if (!matches) {
                        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Scan Using Barcode",@"")];
                        [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                        isSucceeded = NO;
                        break;
                    }
                }
                if (isSucceeded) {
                    
                    [dictFieldValue setObject:@(fieldData.fieldId) forKey:@"field_id"];
                    [dictFieldValue setObject:inputString forKey:@"field_value"];
                    [dictFieldValue setObject:fieldData.isMandatory?@"1":@"0"
                                       forKey:@"field_mandatory"];
                    if (fieldData.fieldAttribute == FieldAttributeBarcode)
                    {
                        [dictFieldValue setObject:@"Force Barcode" forKey:@"field_attribute"];
                    }
                }
                [arrFieldValues addObject:dictFieldValue];
                NSLog(@"button");
            }
            }
        }//Date_picker
        else if([newView  isKindOfClass:[UILabel class]]){
            if(newView.tag >= 300){
                int tag = newView.tag;
                int index = 0;
                if (tag > 0) {
                    index = (int)tag - 300;
                }
                NSLog(@"index:%d",index);
                FieldData *fieldData = [self.metaDataArray objectAtIndex:index];
                BOOL mandatary = fieldData.isMandatory;
                NSString *label = fieldData.strFieldLabel;
                int  length = fieldData.fieldLength;
                UILabel *labField = (UILabel *) newView;
                NSString *inputString =@"";
                if (labField.text!=nil) {
                    inputString=labField.text;
                }
                if (mandatary == YES) {
                    if (inputString.length == 0) {
                        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@" Enter %@",@""),label];
                        [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                        isSucceeded = NO;
                        break;
                    }
                }
                NSMutableDictionary *dictFieldValue = [NSMutableDictionary dictionary];
                if (inputString.length > 0)
                {
                    BOOL matches = inputString; //[self isBarcode:inputString];
                    if (!matches) {
                        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Pick Date Using DatePicker",@"")];
                        [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
                        isSucceeded = NO;
                        break;
                    }
                }
                if (isSucceeded) {
                    
                    [dictFieldValue setObject:@(fieldData.fieldId) forKey:@"field_id"];
                    [dictFieldValue setObject:inputString forKey:@"field_value"];
                    [dictFieldValue setObject:fieldData.isMandatory?@"1":@"0"
                                       forKey:@"field_mandatory"];
                    if (fieldData.fieldAttribute == FieldAttributeDatePicker)
                    {
                        [dictFieldValue setObject:@"Date" forKey:@"field_attribute"];
                    }
                }
                [arrFieldValues addObject:dictFieldValue];
            }
        }
            //    check view is  a view or not
        else if ([newView  isKindOfClass:[UIView class]])
        {
                //if check
            int tag = newView.tag;
            int index;
            index = (int)tag - 100;
            FieldData *fieldData = [self.metaDataArray objectAtIndex:index];
            NSMutableDictionary *dictFieldValue = [NSMutableDictionary dictionary];
            NSMutableArray *fieldSelectedOptions = [[NSMutableArray alloc]init];
            NSArray *subviews = [newView subviews];
            NSMutableArray *checkbox_radio_group = [[NSMutableArray alloc]init];
            NSMutableArray *SelectedArray = [[NSMutableArray alloc]init];
            for (UIView *checkboxView in subviews) {
                
                    //NSMutableArray *SelectedArray = [[NSMutableArray alloc]init];
                if ([checkboxView isKindOfClass:[UIButton class]]) {
                    UIButton *checkbox_Button = (UIButton *) checkboxView;
                    
                    [checkbox_radio_group addObject:checkbox_Button];
                }
            }
            NSLog(@"checkbox_radio_group:%@",checkbox_radio_group);
            
            if (checkbox_radio_group.count > 0) {
                for (int k =0; k<checkbox_radio_group.count; k++) {
                    
                    UIButton *buttonType = (UIButton *) checkbox_radio_group[k] ;
                    
                    if (buttonType.selected == true) {
                        NSLog(@"god is great ");
                        
                        [SelectedArray addObject:buttonType];
                        
                        int checkboxtag = buttonType.tag;
                        int checkboxindex;
                        
                        
                        checkboxindex = (int)checkboxtag - 300;
                        NSLog(@"checkboxindex:%d",checkboxindex);
                        
                        NSString *str ;
                        
                        str =[fieldData.fieldOptions objectAtIndex:checkboxindex];
                        NSLog(@"checkbox_str:%@",str);
                        
                        if (isSucceeded) {
                            
                            [fieldSelectedOptions addObject:str];
                        }
                    }
                }
            }
            
            if (checkbox_radio_group.count > 0) {
                if (SelectedArray.count > 0) {
                    
                }
                
                else
                {
                    BOOL mandatary =false;
                    mandatary=fieldData.isMandatory;
                    
                    NSString  *str2 =fieldData.strFieldLabel;
                    
                    NSLog(@"checkbox_str2:%@",str2);
                    if (mandatary == YES) {
                        NSString *msg1 = [NSString stringWithFormat:NSLocalizedString(@" Enter %@",@""),str2];
                        [self.view makeToast:msg1 duration:2.0 position:CSToastPositionCenter];
                        isSucceeded = NO;
                        break;
                    }
                    
                }
                
            }
            
                //new working
            [dictFieldValue setObject:@(fieldData.fieldId) forKey:@"field_id"];
            [dictFieldValue setObject:fieldSelectedOptions forKey:@"field_value"];
            [dictFieldValue setObject:fieldData.isMandatory?@"1":@"0"
                               forKey:@"field_mandatory"];
            switch (fieldData.fieldAttribute) {
                case FieldAttributeRadio:
                    [dictFieldValue setObject:@"Radio" forKey:@"field_attribute"];
                    break;
                case FieldAttributeCheckbox:
                    [dictFieldValue setObject:@"Checkbox" forKey:@"field_attribute"];
                    break;
            }
            [arrFieldValues addObject:dictFieldValue];
            NSLog(@"arrFieldValues:%@",arrFieldValues);
        }
        
    }


    if (isSucceeded) {
        if (hasAddon8 && !hasCustomCategory && !hasAddon7) {
            self.tappi_count = [self.tappi_txt.text intValue];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",self.tappi_count] forKey:@"tappi_count"];
            NSLog(@"self.tappi_count:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"tappi_count"]);
            if(self.tappi_count > 0){
               LoopingViewController *loopingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loopingVC"];
                NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
                parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
                NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
                NSMutableDictionary * parkload=[[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
                [parkload setObject:arrFieldValues forKey:@"basefields"];
                [parkload setObject:[NSString stringWithFormat:@"%d", self.tappi_count] forKey:@"tappi_count"];
                NSLog(@"Load: %@",parkload);
                [parkloadarray replaceObjectAtIndex:currentloadnumber withObject:parkload];
                [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                loopingVC.tappi_count = self.tappi_count;
                loopingVC.sitename = self.sitename;
                loopingVC.siteData = self.siteData;
                loopingVC.image_quality = self.image_quality;
                loopingVC.isEdit = self.isEdit;
                loopingVC.arrayOfImagesWithNotes = self.arrayOfImagesWithNotes;

               [self.navigationController pushViewController:loopingVC animated:YES];
           }else if(!hasCustomCategory){
               [self.view makeToast:NSLocalizedString(@"Enter Valid Tappi No.",@"") duration:2.0 position:CSToastPositionCenter];
           }
        }else{
            UploadViewController *UploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadVC"];
            
            NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
            parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
            NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
            NSMutableDictionary * parkload=[[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
            if(hasAddon8 && !hasCustomCategory && !hasAddon7){
                [parkload setObject:arrFieldValues forKey:@"basefields"];
                [parkload setObject:[NSString stringWithFormat:@"%d", self.tappi_count] forKey:@"tappi_count"];
            }else{
                [parkload setObject:arrFieldValues forKey:@"fields"];
            }
            NSLog(@"LOad: %@",parkload);
            [parkloadarray replaceObjectAtIndex:currentloadnumber withObject:parkload];
            [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UploadVC.sitename = self.sitename;
            UploadVC.siteData=self.siteData;
            UploadVC.image_quality=self.image_quality;
            UploadVC.isEdit =self.isEdit;
            UploadVC.UserCategory = [parkload objectForKey:@"category"];
            
            [self.navigationController pushViewController:UploadVC animated:YES];
        }
        
    }

}



-(BOOL)isNumeric:(NSString *)strtext
{
    NSString *numericValidationRegex = @"[0-9]*";
    NSPredicate *numericPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numericValidationRegex];
    BOOL isValidNumber = [numericPredicate evaluateWithObject:strtext];
    return isValidNumber;
}




-(BOOL)isAlpha:(NSString *)strtext
{
    NSString *numericValidationRegex = @"[a-z,A-Z,' ']*";
    NSPredicate *numericPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numericValidationRegex];
    BOOL isValidNumber = [numericPredicate evaluateWithObject:strtext];
    return isValidNumber;
}



-(BOOL)isAlphaNumeric:(NSString *)strtext
{
    NSString *numericValidationRegex = @"[a-z][A-Z][0-9]*[@#]";
    NSPredicate *numericPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numericValidationRegex];
    BOOL isValidNumber = [numericPredicate evaluateWithObject:strtext];
    return isValidNumber;
}


-(BOOL)isBarcode:(NSString *)strtext
{
    NSString *numericValidationRegex = @"[a-z][A-Z][0-9]*[@#]";
    NSPredicate *numericPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numericValidationRegex];
    BOOL isValidNumber = [numericPredicate evaluateWithObject:strtext];
    return isValidNumber;
}

-(BOOL)isDate:(NSString *)strtext
{
    NSString *numericValidationRegex = @"[0-9]*[@#]";
    NSPredicate *numericPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numericValidationRegex];
    BOOL isValidNumber = [numericPredicate evaluateWithObject:strtext];
    return isValidNumber;
}

//****************************************************
#pragma mark - Notification Methods
//****************************************************

- (void)keyboardDidShow:(NSNotification *)notification
{
    int keyboardheight=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.scroll_View setContentSize:CGSizeMake(self.scroll_View.contentSize.width, self.sub_View_Height+keyboardheight)];
    self.scroll_View.delegate = self;
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.scroll_View setContentSize:CGSizeMake(self.scroll_View.contentSize.width, self.sub_View_Height)];
    self.scroll_View.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendStringViewController:(NSString *) string withTag :(NSInteger) tagNumber
{
    NSLog(@"TAgNumber: %ld",(long)tagNumber);
    if (tagNumber >= 400) {
        
        UIButton *butField = (UIButton *)[self.view viewWithTag:tagNumber];
        [butField setTitle:string forState:UIControlStateNormal];
        [butField setTitleColor:Blue forState:UIControlStateNormal];
    }else{
        FieldData *fieldData= [self.metaDataArray objectAtIndex:(tagNumber % 100)];
        
            //UIView *newView= [self.view viewWithTag:tagNumber];
        if( fieldData.fieldAttribute == FieldAttributeBarcode )
        {
            UIButton *butField = (UIButton *)[self.view viewWithTag:tagNumber+300];
            [butField setTitle:string  forState:UIControlStateNormal];
            [butField setTitleColor:Blue forState:UIControlStateNormal];
        }else if( fieldData.fieldAttribute == FieldAttributeDatePicker )
        {
            UIButton *butField = (UIButton *)[self.view viewWithTag:tagNumber+200];
            [butField setTitle:string  forState:UIControlStateNormal];
            [butField setTitleColor:Blue forState:UIControlStateNormal];
            
        }else{
            UITextView *textField = (UITextView *)[self.view viewWithTag:tagNumber];
            textField.text = string;
        }
    }
    //datepicker
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"datePicker"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"datePickerTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //barcode&ocr
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"scanData"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"scanDataTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(BOOL)textFieldShouldReturn:(UITextView *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


-(void)handleTimer{

    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    UIButton *networkStater = [[UIButton alloc] initWithFrame:CGRectMake(160,12,16,16)];
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Meta Data",@"");
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
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.835 green: 0.749 blue: 0.00 alpha: 1.00].CGColor;
        
        NSLog(@"Server Under maintenance");
        
    }else if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"green_nw.png"]  forState:UIControlStateNormal];
        
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.898 blue: 0.031 alpha: 1.00].CGColor;
            
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.00 green: 0.682 blue: 0.027 alpha: 1.00].CGColor;
        
        NSLog(@"Network Connection available");
    } else {
        NSLog(@"Network Connection not available");
        [networkStater
         setBackgroundImage:[UIImage imageNamed:@"orange_nw.png"]  forState:UIControlStateNormal];
        networkStater.layer.backgroundColor = [UIColor colorWithRed: 0.972 green: 0.709 blue: 0.321 alpha: 0.80].CGColor;
        networkStater.layer.borderColor = [UIColor colorWithRed: 0.992 green: 0.521 blue: 0.031 alpha: 1.00].CGColor;
        
    }
    networkStater.layer.borderWidth = 1.0;
    [networkStater addTarget:self action:@selector(poper:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:networkStater];
    self.navigationItem.titleView = view;
}

-(IBAction)poper:(id)sender {
    [self handleTimer];
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];

    NSString *stat=NSLocalizedString(@"Network Not Connected",@"");;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        stat=NSLocalizedString(@"Network Connected",@"");
    }
    [self.alertbox addButton:@"OK" target:self selector:@selector(dummy:) backgroundColor:Green];
    [self.alertbox showSuccess:NSLocalizedString(@"Status",@"") subTitle:stat closeButtonTitle:nil duration:1.0f ];
}


-(IBAction)dummy:(id)sender{
    [self.alertbox hideView];
}



-(void) scan:(UIButton *)sender
{
    self.senderTag=(int)sender.tag;
    self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
    [self.alertbox setHorizontalButtons:YES];
    [self.alertbox addButton:NSLocalizedString(@"Barcode",@"") target:self selector:@selector(bc:) backgroundColor:Blue];
    FieldData *fieldData= [self.metaDataArray objectAtIndex:(self.senderTag % 100)];
        bool boolToRestrict = [[NSUserDefaults standardUserDefaults] boolForKey:@"boolToRestrict"];
        NSLog(@"Meta boolToRestrict:%d",boolToRestrict);
        
    if((fieldData.fieldAttribute != FieldAttributeBarcode) && boolToRestrict == FALSE){
        [self.alertbox addButton:@"O.C.R" target:self selector:@selector(ocr:) backgroundColor:Blue];
    }
    [self.alertbox showSuccess:NSLocalizedString(@"Data Scanner",@"") subTitle:NSLocalizedString(@"Select scanning mode",@"") closeButtonTitle:NSLocalizedString(@"Close",@"") duration:1.0f ];
}



- (IBAction)bc:(id *)sender
{
    IGVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IGVC"];
    IGVC.btnTag = self.senderTag;
    NSLog(@"tag: %d",self.senderTag);
    if(self.senderTag >= 400)
    {
        IGVC.txtTag = self.senderTag;
    }
    else
    {
        IGVC.txtTag = self.senderTag-100;
    }
    [IGVC setDelegate:self];
    [self.navigationController pushViewController:IGVC animated:YES];
}



-(void) back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *imag = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *path = [[self getUserDocumentDir] stringByAppendingPathComponent:@"ScanData"];
    NSString* imagePath = [path stringByAppendingPathComponent:@"scanner.jpg"];
    [UIImageJPEGRepresentation(imag,1) writeToFile:imagePath atomically:true];
    ViewController *viewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"vc"];

    viewController.img = imagePath;
    viewController.imager=imag;

    if(self.senderTag >= 400)
    {
        viewController.tag=(int)self.senderTag;
    }
    else
    {
        viewController.tag=(int)self.senderTag-100;
    }
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

@end
