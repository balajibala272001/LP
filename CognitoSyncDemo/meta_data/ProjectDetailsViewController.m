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
#import "ServerUtility.h"
#import <MBProgressHUD/MBProgressHUD.h>


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
    int customer_id_true_count;
    int forecbarCodeTag;
    int forcebarcodeClearTag;
<<<<<<< HEAD
=======
    UIAlertView *alert;
>>>>>>> main
}

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************

-(void)viewWillAppear:(BOOL)animated{
    
    self.subView.layer.cornerRadius = 10;
    self.subView.layer.borderWidth = 1;
    self.subView.layer.borderColor = Blue.CGColor;
    [super viewWillAppear:animated];
        
    delegateVC = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateVC.CurrentVC = @"MetaDataVC";
        
    //if([maintenance_stage isEqualToString:@"False"] || ([maintenance_stage isEqualToString:@"True2"] && internal_test_mode == TRUE)){
        [self handleTimer];
    //}
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
<<<<<<< HEAD
=======
    if(alert != nil && !picker.isHidden){
        [alert setCancelButtonIndex:0];
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];

    }
>>>>>>> main
}


- (void)viewDidLoad {
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [[UIView appearance] setSemanticContentAttribute: UISemanticContentAttributeForceRightToLeft];
    }
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
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
<<<<<<< HEAD
=======
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
>>>>>>> main
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
-(void)back_button:(id)sender{
    
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
-(void)baseMetaData{
    
    NSMutableArray *parkloadarray=[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload = [parkloadarray objectAtIndex:currentloadnumber];
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
    int radioViewheight;
    forcebarcodeClearTag = 600;
    int checkBoxViewheight;
    NSMutableArray *fields=[parkload objectForKey:@"basefields"];
    int yPosOfTxt = yPosOfBtn;
    
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    for (int i =0;i<self.metaDataArray.count; i++) {
        int radioButton_y =2.5;
        int radioVutton_Vertical_Padding = 6.5;
        int checkboxButton_y = 2.5;
        int checkbox_Vertical_padding = 8;
        int yPosOfTxt = yPosOfBtn;
        NSLog(@"fiels:%@",self.metaDataArray [i]);
        FieldData *fieldData = self.metaDataArray [i];
        BOOL active = fieldData.shouldActive;
        BOOL Mandatary = fieldData.isMandatory;
        if (active == YES) {
            //Creating Button
            UIButton *metaData_btn = [[UIButton alloc]init];
            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                metaData_btn.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
            }else{
                metaData_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn, widthOfBtn,heightOfBtn);
            }
            NSLog(@"widthOfBtn%d",widthOfBtn);
            if((fieldData.fieldAttribute == FieldAttributeRadio)|| (fieldData.fieldAttribute == FieldAttributeCheckbox)){
                yPosOfBtn =yPosOfBtn + (verticalPadding +7);
            }else if(fieldData.fieldAttribute == FieldAttributeDatePicker){
                yPosOfBtn =yPosOfBtn + (verticalPadding +60);
                [metaData_btn addTarget:self action:@selector(datePicker_button:) forControlEvents:UIControlEventTouchUpInside];
            }else if(fieldData.fieldAttribute == FieldAttributeComments || fieldData.fieldAttribute == FieldAttributeBarcode) {
                if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
                    yPosOfBtn =yPosOfBtn + (verticalPadding + 100);
                }else {
                    yPosOfBtn =yPosOfBtn + (verticalPadding + 180);
                }
                [metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
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
            
            if (fieldData.fieldAttribute == FieldAttributeNumeric || fieldData.fieldAttribute == FieldAttributeAlpha || fieldData.fieldAttribute == FieldAttributeAlphaNumeric  || fieldData.fieldAttribute == FieldAttributeComments) {
                
                    //Creating TextField
                UITextView *metaData_txt = [[UITextView alloc]init];
                metaData_txt.layer.cornerRadius = 5;
                metaData_txt.layer.borderWidth = 1;
                metaData_txt.layer.backgroundColor = [UIColor whiteColor].CGColor;
                metaData_txt.layer.borderColor = [UIColor blackColor].CGColor;
                if (fieldData.fieldAttribute == FieldAttributeComments) {
                    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
                        metaData_txt.textContainer.maximumNumberOfLines = 5;
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            metaData_txt.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,100);
                            metaData_txt.textAlignment =  NSTextAlignmentRight;
                        }else{
                            metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, 100);
                            metaData_txt.textAlignment =  NSTextAlignmentLeft;
                        }
                    }else {
                        metaData_txt.textContainer.maximumNumberOfLines = 10;
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            metaData_txt.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,180);
                            metaData_txt.textAlignment =  NSTextAlignmentRight;
                        }else{
                            metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, 180);
                            metaData_txt.textAlignment =  NSTextAlignmentLeft;
                        }
                    }
                }else {
                    metaData_txt.textContainer.maximumNumberOfLines = 3;
                    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                        metaData_txt.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,heightOfBtn);
                        metaData_txt.textAlignment =  NSTextAlignmentRight;
                    }else{
                        metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                        metaData_txt.textAlignment =  NSTextAlignmentLeft;
                    }
                }
                metaData_txt.textContainerInset = UIEdgeInsetsMake(2.5, 0.0, 2.5,0.0);
                metaData_txt.textColor = Blue;
                [metaData_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
                //metaData_txt.textAlignment =  NSTextAlignmentLeft;
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
            }else if (fieldData.fieldAttribute == FieldAttributeRadio){
                NSLog(@"Radio");
                self.arr= fieldData.fieldOptions;
                UIView *RadioView = [[UIView alloc]init];
                int  count =0;
                if (self.arr.count>0) {
                    count =(int)self.arr.count;
                }
                radioViewheight = 30.7 *count;
                if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                    RadioView.frame = CGRectMake(xPosOfBtn,yPosOfBtn,widthOfBtn, radioViewheight);
                }else{
                    RadioView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt, radioViewheight);
                }
                if (self.arr.count==1) {
                    yPosOfBtn = yPosOfBtn +radioViewheight+25;
                }else{
                    yPosOfBtn = yPosOfBtn +radioViewheight;
                }
                RadioView.tag = (txtTagBaseVaue +i);
                NSLog(@"tag:%ld",(long)RadioView.tag);
                [self.sub_View addSubview:RadioView];
                for (int f = 0;f<self.arr.count; f++) {
                    UILabel *lbl = [[UILabel alloc]init];
                    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                        lbl.frame = CGRectMake(0,radioButton_y,widthOfTxt-10,20);
                        lbl.textAlignment = NSTextAlignmentRight;
                    }else{
                        lbl.frame = CGRectMake(30,radioButton_y, widthOfTxt-30, 20);
                    }
                    //  lbl.frame = CGRectMake(40, radiobox_y, 100, 20);
                    lbl.numberOfLines = 2;
                    lbl.adjustsFontSizeToFitWidth = YES;
                    lbl.text =self.arr[f];
                    if (@available(iOS 11.0, *)) {
                        [lbl setInsetsLayoutMarginsFromSafeArea:YES];
                    }else{
                        // Fallback on earlier versions
                    }
                    lbl.textColor = [UIColor blackColor];
                    [lbl setFont: [lbl.font fontWithSize: 20]];
                    [lbl setTag:baseradioTag+f];
                    [RadioView addSubview:lbl];
                    
                    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                        self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(xPosOfTxt- 55,radioButton_y-12,50,50)];
                    }else{
                        self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(0-12.5,radioButton_y-12, 50, 50)];
                    }
                    radioButton_y = radioButton_y+(radioVutton_Vertical_Padding+25);
                    [self.yourButton setImage: [UIImage imageNamed:@"radioChecked.png"]forState:UIControlStateSelected];
                    [self.yourButton setImage: [UIImage imageNamed:@"radioUnchecked.png"]forState: UIControlStateNormal];
                    self.yourButton.selected = NO;
                    [self.yourButton addTarget:self action:@selector(radioSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [self.yourButton setTag:baseradioTag+f];
                    NSLog(@"%ld",(long)self.yourButton.tag);
                    [RadioView addSubview:self.yourButton];
                    if (fields.count >0){
                        [self DisplayOldValues];
                    }else if (self.oldValuesReturn.count) {
                        [self DislpayPreviousValues];
                    }
                }
            }else if (fieldData.fieldAttribute == FieldAttributeCheckbox){
                NSLog(@"checkbox");
                self.arr= fieldData.fieldOptions;
                UIView *CheckboxView = [[UIView alloc]init];
                int count = self.arr.count;
                checkBoxViewheight = 32 *count;
                if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                    CheckboxView.frame = CGRectMake(xPosOfBtn,yPosOfBtn,widthOfBtn, checkBoxViewheight);
                }else{
                    CheckboxView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt,checkBoxViewheight );
                }
                if (self.arr.count==1) {
                    yPosOfBtn = yPosOfBtn +checkBoxViewheight+25;
                }else{
                    yPosOfBtn = yPosOfBtn +checkBoxViewheight;
                }
                CheckboxView.tag = (txtTagBaseVaue +i);
                NSLog(@"tag:%ld",(long)CheckboxView.tag);
                [self.sub_View addSubview:CheckboxView];
                
                int checkbox_y=yPosOfTxt;
                for (int f = 0; f<self.arr.count; f++) {
                    
                    UILabel *lbl = [[UILabel alloc]init];
                    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                        lbl.frame = CGRectMake(0,checkboxButton_y+2,widthOfTxt-10,20);
                        lbl.textAlignment = NSTextAlignmentRight;
                    }else{
                        lbl.frame = CGRectMake( 30,checkboxButton_y+2,widthOfTxt-30,20);
                    }                     lbl.numberOfLines = 2;
                    lbl.adjustsFontSizeToFitWidth = YES;
                    lbl.text=self.arr[f];
                    //@"01234567891011121314151617181920212223242526272829";
                    if (@available(iOS 11.0, *)) {
                        [lbl setInsetsLayoutMarginsFromSafeArea:YES];
                    } else {
                        // Fallback on earlier versions
                    }
                    [lbl setFont: [lbl.font fontWithSize: 20]];
                    lbl.textColor = [UIColor blackColor];
                    [lbl setTag:basecheckboxTag+f];
                    [CheckboxView addSubview:lbl];
                    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                        self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(xPosOfTxt- 45,checkboxButton_y,25,25)];
                    }else{
                        self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(0,checkboxButton_y,25,25)];
                    }
                    checkboxButton_y = checkboxButton_y+(checkbox_Vertical_padding+24);
                    [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"uncheckclicked.png"] forState:UIControlStateNormal];
                    [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkclick.png"] forState:UIControlStateSelected];
                    [self.checkBoxButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [self.checkBoxButton setTag:basecheckboxTag+f];
                    
                    [CheckboxView addSubview:self.checkBoxButton];
                    
                    if (fields.count >0){
                        [self DisplayOldValues];
                    }else if (self.oldValuesReturn.count) {
                        [self DislpayPreviousValues];
                    }
                }
            } else if (fieldData.fieldAttribute == FieldAttributeBarcode){
                UIButton *meta_label = [[UIButton alloc] init];
                UIButton *clearForceField = [[UIButton alloc] init];
                if (@available(iOS 13.0, *)) {
                    [clearForceField setBackgroundImage: [UIImage systemImageNamed:@"clear"] forState:UIControlStateNormal];
                } else {
                    // Fallback on earlier versions
                    [clearForceField setBackgroundImage: [UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
                }
                clearForceField.tintColor = UIColor.redColor;
                if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
                        meta_label.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,100);
                    }else {
                        meta_label.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,180);
                    }
                    //meta_label.frame = CGRectMake(xPosOfBtn,yPosOfTxt,widthOfBtn, heightOfTxt);
                    clearForceField.frame = CGRectMake(widthOfBtn - 31, 1,30, 28);
                    self.tappi_txt.textAlignment =  NSTextAlignmentRight;
                }else{
                    //meta_label.frame =  CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
                        meta_label.frame = CGRectMake(xPosOfTxt,yPosOfTxt, widthOfTxt,100);
                    }else {
                        meta_label.frame = CGRectMake(xPosOfTxt,yPosOfTxt, widthOfTxt,180);
                    }
                    clearForceField.frame =  CGRectMake(widthOfTxt - 31, 1 , 30, 28);
                    self.tappi_txt.textAlignment =  NSTextAlignmentCenter;
                }
                meta_label.titleLabel.numberOfLines = 4;
                meta_label.layer.cornerRadius = 5;
                meta_label.layer.borderWidth = 1;
                meta_label.layer.backgroundColor = [UIColor whiteColor].CGColor;
                meta_label.layer.borderColor = [UIColor blackColor].CGColor;
                meta_label.titleLabel.textColor=Blue;
                [meta_label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                meta_label.tag = (lblTagBaseValue + i );
                NSLog(@"tag:%ld",(long)meta_label.tag);
                clearForceField.tag = (lblTagBaseValue + i + forcebarcodeClearTag);
                clearForceField.hidden = YES;
                [meta_label addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
                [clearForceField addTarget:self action:@selector(clearForceFieldData:) forControlEvents:UIControlEventTouchUpInside];
                [meta_label addSubview:clearForceField];
                [self.sub_View addSubview:meta_label];
                if (fields.count >0){
                    [self DisplayOldValues];
                }else if (self.oldValuesReturn.count) {
                    [self DislpayPreviousValues];
                }
            }else if (fieldData.fieldAttribute == FieldAttributeDatePicker){
                //button_datepicker
                UIButton* meta_btn_datePicker = [[UIButton alloc] init] ;
                if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                    meta_btn_datePicker.frame = CGRectMake(xPosOfBtn,yPosOfTxt,widthOfBtn, heightOfTxt);
                }else{
                    meta_btn_datePicker.frame =  CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                }
                [meta_btn_datePicker setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                meta_btn_datePicker.layer.cornerRadius = 5;
                meta_btn_datePicker.layer.borderWidth = 1;
                meta_btn_datePicker.layer.borderColor = [UIColor blackColor].CGColor;
                meta_btn_datePicker.userInteractionEnabled = YES;
                meta_btn_datePicker.tag = (baseDateTag + i );
                NSLog(@"tag:%ld",(long)meta_btn_datePicker.tag);

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
    yPosOfTxt = yPosOfBtn;
    
    //Tappi_field---tappi_Button
    UIButton *tappi_btn = [[UIButton alloc]init];
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        tappi_btn.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
    }else{
        tappi_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn, widthOfBtn,heightOfBtn);
    }
    yPosOfBtn =yPosOfBtn + (verticalPadding + heightOfBtn);
    tappi_btn.backgroundColor = Blue;
    tappi_btn.tag = 0;
    NSLog(@"tag:%ld",(long)tappi_btn.tag);
    NSString *noOfTappi = @"Number Of ";
    if(self.siteData.tappi_name != nil){
        noOfTappi = [noOfTappi stringByAppendingString:self.siteData.tappi_name];
    }else {
        noOfTappi = NSLocalizedString(@"Number Of Tappi",@"");
    }
    [tappi_btn setTitle:noOfTappi forState:UIControlStateNormal];
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
    
    //tappi_txt
    self.tappi_txt = [[UITextView alloc]init];
    self.tappi_txt.layer.cornerRadius = 5;
    self.tappi_txt.layer.borderWidth = 1;
    self.tappi_txt.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.tappi_txt.layer.borderColor = [UIColor blackColor].CGColor;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        self.tappi_txt.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,heightOfBtn);
        self.tappi_txt.textAlignment =  NSTextAlignmentCenter;
    }else{
        self.tappi_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
        self.tappi_txt.textAlignment =  NSTextAlignmentCenter;
    }
    self.tappi_txt.tag = 0;
    yPosOfTxt =yPosOfTxt + heightOfTxt;
    self.tappi_txt.textColor = Blue;
    [self.tappi_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    self.tappi_txt.textAlignment =  NSTextAlignmentCenter;
    [self.tappi_txt setReturnKeyType: UIReturnKeyDone];
    self.tappi_txt.keyboardType = UIKeyboardTypeNumberPad;
    //self.tappi_txt.backgroundColor =[UIColor redColor];
    [self.tappi_txt setDelegate:self];
    [self.sub_View addSubview:self.tappi_txt];

    if([parkload valueForKey:@"tappi_count"] != nil && [parkload valueForKey:@"tappi_count"] != 0){
        self.tappi_txt.text = [parkload objectForKey:@"tappi_count"];
    }
<<<<<<< HEAD
    self.sub_View_Height = yPosOfBtn+heightOfBtn+verticalPadding;
=======
    self.sub_View_Height = yPosOfBtn + heightOfBtn + verticalPadding;
>>>>>>> main
    CGRect newFrame = CGRectMake( 0, 0, self.view.frame.size.width-10, self.sub_View_Height);
    self.sub_View.frame = newFrame;
    
    if ([model isEqualToString:@"iPad"]) {
        self.scroll_View.frame =  CGRectMake( 5, 30, self.sub_View.frame.size.width,self.view.frame.size.height - 70) ;
    }else{
        self.scroll_View.frame =  CGRectMake( 5, 30, self.sub_View.frame.size.width,self.view.frame.size.height -50) ;
    }
    [self.scroll_View setContentSize:CGSizeMake(self.sub_View.frame.size.width, self.sub_View_Height)];
    self.scroll_View.delegate = self;
}

<<<<<<< HEAD

=======
>>>>>>> main
//NormalFlow-MetaData
-(void)createMetaData{
    
    NSMutableArray *parkloadarray=[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload=[parkloadarray objectAtIndex:currentloadnumber];
//    self.qrArrMetaData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"qrScannedMetafields"]mutableCopy];\
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"qrScannedMetafields"];
  
    SiteData *sites = self.siteData;
    //checking for addon8
    hasAddon8 = FALSE;
    for (int index=0; index<self.siteData.categoryAddon.count; index++) {
        Add_on * dict = [self.siteData.categoryAddon objectAtIndex:index];
        if([dict.addonName isEqual:@"addon_8"] && dict.addonStatus.boolValue){
            add_on =[self.siteData.categoryAddon objectAtIndex:index];
            add_on_8 =[self.siteData.looping_data objectAtIndex:0];
            hasAddon8 = TRUE;
        }
    }
    //checking for addon5
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
                //FieldData *field = self.siteData.customerDictSetup[i];
                self.metaDataArray = dict.categoryMetaArray;
                //field.customer_id = false;
                NSLog(@"dict.categoryMetaArray:%@",dict.categoryMetaArray);
            }
        }
<<<<<<< HEAD
=======
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for(int j = 0; j<self.metaDataArray.count;j++){
            FieldData *field = self.metaDataArray[j];
            if(field.fieldAttribute == FieldAttributeRadio || field.fieldAttribute == FieldAttributeCheckbox){
                if(field.fieldOptions.count > 0){
                    [arr addObject:field];
                }
            }else {
                [arr addObject:field];
            }
        }
        self.metaDataArray = arr;
>>>>>>> main
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        for(int j = 0; j<self.metaDataArray.count;j++){
//            FieldData *field = self.metaDataArray[j];
//            field.customer_id = false;
//            if(![field.fieldOptions  isEqual: @""]){
//                [arr addObject:field];
//            }
//        }
//        if(arr.count >0){
//            //[self.metaDataArray removeAllObjects];
//            self.metaDataArray = arr;
//            NSLog(@"self.metaDataArray:%@",self.metaDataArray);
//        }

    }else if(hasAddon8){
        self.metaDataArray = sites.arrFieldData;
        NSLog(@"sites.arrFieldData:%@",sites.arrFieldData);
    }else{
<<<<<<< HEAD
        self.metaDataArray = sites.arrFieldData;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
=======
        NSMutableArray *arr1 = [[NSMutableArray alloc]init];
        for(int j = 0; j< sites.arrFieldData.count;j++){
            FieldData *field = sites.arrFieldData[j];
            if(field.customer_id == false){
                if(field.fieldAttribute == FieldAttributeRadio || field.fieldAttribute == FieldAttributeCheckbox){
                    if(field.fieldOptions.count > 0){
                        [arr1 addObject:field];
                    }
                }else {
                    [arr1 addObject:field];
                }
            }
        }
        self.metaDataArray = arr1;
        NSMutableArray *arr2 = [[NSMutableArray alloc]init];
>>>>>>> main
        for(int j = 0; j<self.siteData.customerDictSetup.count;j++){
            FieldData *field = self.siteData.customerDictSetup[j];
            field.customer_id = false;
            if(![field.fieldOptions isEqual: @""]){
<<<<<<< HEAD
                [arr addObject:field];
            }
        }
        self.metaDataArray = [self.metaDataArray arrayByAddingObjectsFromArray:arr];
=======
                if(field.fieldAttribute == FieldAttributeRadio || field.fieldAttribute == FieldAttributeCheckbox){
                    if(field.fieldOptions.count > 0){
                        [arr2 addObject:field];
                    }
                }else {
                    [arr2 addObject:field];
                }
            }
        }
        self.metaDataArray = [self.metaDataArray arrayByAddingObjectsFromArray:arr2];
>>>>>>> main
        NSLog(@"sites.arrFieldData:%@",sites.arrFieldData);
        NSLog(@"self.metaDataArray:%@",self.metaDataArray);
        NSLog(@"sites.customerDictSetup:%@",sites.customerDictSetup);
    }
    //BOOL customer_id = field.isCustomerId;
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
    forcebarcodeClearTag = 600;
    
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    NSMutableArray *fields=[parkload objectForKey:@"fields"];
    @try {
        customer_id_true_count = 0;
        //iterating the fieldata array
    for (int i =0;i<self.metaDataArray.count; i++) {
        int radioButton_y =2.5;
        int radioVutton_Vertical_Padding = 6.5;
        int checkboxButton_y = 2.5;
        int checkbox_Vertical_padding = 8;
        int yPosOfTxt = yPosOfBtn;
        FieldData *fieldData = self.metaDataArray [i];
        NSLog(@"fiels:%@",self.metaDataArray [i]);
        BOOL isTrue = false;
        BOOL display = fieldData.shouldDisplay;
        BOOL active = fieldData.shouldActive;
        BOOL Mandatary = fieldData.isMandatory;
        BOOL customer_id = fieldData.isCustomerId;
        NSMutableArray *site_list_id = fieldData.siteListId;
        if (active == YES) {
            if(customer_id == false || hasCustomCategory){
                if((fieldData.fieldAttribute == FieldAttributeRadio)|| (fieldData.fieldAttribute == FieldAttributeCheckbox)){
                    if(fieldData.fieldOptions.count != 0){
                        //Creating Button
                        UIButton *metaData_btn = [[UIButton alloc]init];
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            metaData_btn.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                        }else{
                            metaData_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn, widthOfBtn,heightOfBtn);
                        }
                        NSLog(@"widthOfBtn%d",widthOfBtn);
                        if((fieldData.fieldAttribute == FieldAttributeRadio)|| (fieldData.fieldAttribute == FieldAttributeCheckbox)){
                            yPosOfBtn =yPosOfBtn + (verticalPadding +7);
                        }else if(fieldData.fieldAttribute == FieldAttributeDatePicker){
                            yPosOfBtn =yPosOfBtn + (verticalPadding +60);
                            [metaData_btn addTarget:self action:@selector(datePicker_button:) forControlEvents:UIControlEventTouchUpInside];
                        }else {
                            yPosOfBtn =yPosOfBtn + (verticalPadding +60);
                            [metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        metaData_btn.backgroundColor = Blue;
                        metaData_btn.tag = (btnTagBaseValue + i);
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
                    }
                }else{
                    //Creating Button
                    UIButton *metaData_btn = [[UIButton alloc]init];
//                    if (fieldData.fieldAttribute == FieldAttributeComments) {
//                        if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
//                            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
//                                metaData_btn.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, 100);
//                            }else{
//                                metaData_btn.frame = CGRectMake(xPosOfBtn,100, widthOfBtn,100);
//                            }
//                        }else {
//                            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
//                                metaData_btn.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, 180);
//                            }else{
//                                metaData_btn.frame = CGRectMake(xPosOfBtn,180, widthOfBtn,180);
//                            }
//                        }
//                    }else {
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            metaData_btn.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                        }else{
                            metaData_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn, widthOfBtn,heightOfBtn);
                        }
//                    }
                    NSLog(@"widthOfBtn%d",widthOfBtn);
                    if((fieldData.fieldAttribute == FieldAttributeRadio)|| (fieldData.fieldAttribute == FieldAttributeCheckbox)){
                        yPosOfBtn =yPosOfBtn + (verticalPadding +7);
                    }else if(fieldData.fieldAttribute == FieldAttributeDatePicker){
                        yPosOfBtn =yPosOfBtn + (verticalPadding +60);
                        [metaData_btn addTarget:self action:@selector(datePicker_button:) forControlEvents:UIControlEventTouchUpInside];
                    }else if(fieldData.fieldAttribute == FieldAttributeComments || fieldData.fieldAttribute == FieldAttributeBarcode) {
                        if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
                            yPosOfBtn =yPosOfBtn + (verticalPadding + 100);
                        }else {
                            yPosOfBtn =yPosOfBtn + (verticalPadding + 180);
                        }
                        [metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
                    } else{
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
//                    CGRect frame = metaData_btn.frame;
//                    frame.size.height = 100;
//                    if(i == 0){
<<<<<<< HEAD
//                        metaData_btn.backgroundColor = UIColor.blueColor;
//                    }else if(i == 1){
//                        metaData_btn.backgroundColor = UIColor.redColor;
//                    }else {
//                        metaData_btn.backgroundColor = UIColor.yellowColor;
=======
//                        metaData_btn.backgroundColor = UIColor.blueColor; inbound stepcheck alpha1 outbound QAID dateof loadView
//                    }else if(i == 1){
//                        metaData_btn.backgroundColor = UIColor.redColor;   checkCUS CheckboxSW SWdate SWComment Sw=Num Sw=Num2 barcode 1
//                    }else {
//                        metaData_btn.backgroundColor = UIColor.yellowColor; barcode 2
>>>>>>> main
//                    }
//                    metaData_btn.frame = frame;
                    
                    [self.sub_View addSubview:metaData_btn];
                }
            }
            if (fieldData.fieldAttribute == FieldAttributeNumeric || fieldData.fieldAttribute == FieldAttributeAlpha || fieldData.fieldAttribute == FieldAttributeAlphaNumeric || fieldData.fieldAttribute == FieldAttributeComments) {
                
                    //Creating TextField
                UITextView *metaData_txt = [[UITextView alloc]init];
                [metaData_txt setDelegate:self];
                metaData_txt.layer.cornerRadius = 5;
                metaData_txt.layer.borderWidth = 1;
                metaData_txt.layer.backgroundColor = [UIColor whiteColor].CGColor;
                metaData_txt.layer.borderColor = [UIColor blackColor].CGColor;
                if (fieldData.fieldAttribute == FieldAttributeComments) {
                    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
                        metaData_txt.textContainer.maximumNumberOfLines = 5;
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            metaData_txt.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,100);
                            metaData_txt.textAlignment =  NSTextAlignmentRight;
                        }else{
                            metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, 100);
                            metaData_txt.textAlignment =  NSTextAlignmentLeft;
                        }
                    }else {
                        metaData_txt.textContainer.maximumNumberOfLines = 10;
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            metaData_txt.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,180);
                            metaData_txt.textAlignment =  NSTextAlignmentRight;
                        }else{
                            metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, 180);
                            metaData_txt.textAlignment =  NSTextAlignmentLeft;
                        }
                    }
                }else {
                    metaData_txt.textContainer.maximumNumberOfLines = 3;
                    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                        metaData_txt.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,heightOfBtn);
                        metaData_txt.textAlignment =  NSTextAlignmentRight;
                    }else{
                        metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                        metaData_txt.textAlignment =  NSTextAlignmentLeft;
                    }
                }
                metaData_txt.textContainerInset = UIEdgeInsetsMake(2.5, 0.0, 2.5,0.0);
                metaData_txt.textColor = Blue;
                [metaData_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
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
//                if (fields.count >0){
//                    [self DisplayOldValues];
//                }else if (self.oldValuesReturn.count) {
//                    [self DislpayPreviousValues];
//                }
            }else if (fieldData.fieldAttribute == FieldAttributeRadio){
<<<<<<< HEAD
                if(customer_id == false || hasCustomCategory){
                    NSLog(@"Radio");
                    self.arr= fieldData.fieldOptions;
                    UIView *RadioView = [[UIView alloc]init];
                    int  count =0;
                    if (self.arr.count>0) {
                        count =(int)self.arr.count;
                    }
                    radioViewheight = 30.7 *count;
                    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                        RadioView.frame = CGRectMake(xPosOfBtn,yPosOfBtn,widthOfBtn, radioViewheight);
                    }else{
                        RadioView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt, radioViewheight);
                    }
                    if (self.arr.count==1) {
                        yPosOfBtn = yPosOfBtn +radioViewheight+25;
                    }else{
                        yPosOfBtn = yPosOfBtn +radioViewheight;
                    }
                    RadioView.tag = (txtTagBaseVaue +i);
                    
                    [self.sub_View addSubview:RadioView];
                    for (int f = 0;f<self.arr.count; f++) {
                        UILabel *lbl = [[UILabel alloc]init];
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            lbl.frame = CGRectMake(0,radioButton_y,widthOfTxt-10,20);
                            lbl.textAlignment = NSTextAlignmentRight;
                        }else{
                            lbl.frame = CGRectMake(30,radioButton_y, widthOfTxt-30, 20);
                        }
                        //lbl.backgroundColor = [UIColor redColor];
                        lbl.numberOfLines = 2;
                        lbl.adjustsFontSizeToFitWidth = YES;
                        lbl.text =self.arr[f];
                        if (@available(iOS 11.0, *)) {
                            [lbl setInsetsLayoutMarginsFromSafeArea:YES];
                        }
                        lbl.textColor = [UIColor blackColor];
                        [lbl setFont: [lbl.font fontWithSize: 20]];
                        [lbl setTag:baseradioTag+f];
                        [RadioView addSubview:lbl];
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(xPosOfTxt- 55,radioButton_y-12,50,50)];
                        }else{
                            self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(0-12.5,radioButton_y-12, 50, 50)];
                        }
                        radioButton_y = radioButton_y+(radioVutton_Vertical_Padding+25);
                        [self.yourButton setImage: [UIImage imageNamed:@"radioChecked.png"]forState:UIControlStateSelected];
                        [self.yourButton setImage: [UIImage imageNamed:@"radioUnchecked.png"]forState: UIControlStateNormal];
                        self.yourButton.selected = NO;
                        [self.yourButton addTarget:self action:@selector(radioSelected:) forControlEvents:UIControlEventTouchUpInside];
                        [self.yourButton setTag:baseradioTag+f];
                        NSLog(@"%ld",(long)self.yourButton.tag);
                        [RadioView addSubview:self.yourButton];
//                        if (fields.count >0){
//                            [self DisplayOldValues];
//                        }else if (self.oldValuesReturn.count) {
//                            [self DislpayPreviousValues];
//                        }
                    }
                }else {
                    customer_id_true_count++;
                }
            }else if (fieldData.fieldAttribute == FieldAttributeCheckbox){

                if(customer_id == false || hasCustomCategory){
                    NSLog(@"checkbox");
                    self.arr= fieldData.fieldOptions;
                    UIView *CheckboxView = [[UIView alloc]init];
                    int count = self.arr.count;
                    checkBoxViewheight = 32 *count;
                    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                        CheckboxView.frame = CGRectMake(xPosOfBtn,yPosOfBtn,widthOfBtn, checkBoxViewheight);
                    }else{
                        CheckboxView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt,checkBoxViewheight );
                    }
                    if (self.arr.count==1) {
                        yPosOfBtn = yPosOfBtn +checkBoxViewheight+25;
                    }else{
                        yPosOfBtn = yPosOfBtn +checkBoxViewheight;
                    }
                    CheckboxView.tag = (txtTagBaseVaue +i );
                    [self.sub_View addSubview:CheckboxView];
                    
                    int checkbox_y=yPosOfTxt;
                    for (int f = 0; f<self.arr.count; f++) {
                        
                        UILabel *lbl = [[UILabel alloc]init];
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            lbl.frame = CGRectMake(0,checkboxButton_y+2,widthOfTxt-10,20);
                            lbl.textAlignment = NSTextAlignmentRight;
                        }else{
                            lbl.frame = CGRectMake( 30,checkboxButton_y+2,widthOfTxt-30,20);
                        }
                        //lbl.backgroundColor = [UIColor redColor];
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

                        lbl.textColor = [UIColor blackColor];
                        [lbl setTag:basecheckboxTag+f];
                        [CheckboxView addSubview:lbl];
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(xPosOfTxt- 45,checkboxButton_y,25,25)];
                        }else{
                            self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(0,checkboxButton_y,25,25)];
                        }
                        checkboxButton_y = checkboxButton_y+(checkbox_Vertical_padding+24);
                        [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"uncheckclicked.png"] forState:UIControlStateNormal];
                        [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkclick.png"] forState:UIControlStateSelected];
                        [self.checkBoxButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
                        [self.checkBoxButton setTag:basecheckboxTag+f];
                        
                        [CheckboxView addSubview:self.checkBoxButton];
                        
//                        if (fields.count >0){
//                            [self DisplayOldValues];
//                        }else if (self.oldValuesReturn.count) {
//                            [self DislpayPreviousValues];
//                        }
                    }
                }else {
                    customer_id_true_count++;
                }
=======
                    if(customer_id == false || hasCustomCategory){
                        NSLog(@"Radio");
                        self.arr= fieldData.fieldOptions;
                        UIView *RadioView = [[UIView alloc]init];
                        int  count =0;
                        if (self.arr.count>0) {
                            count =(int)self.arr.count;
                        }
                        radioViewheight = 30.7 *count;
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            RadioView.frame = CGRectMake(xPosOfBtn,yPosOfBtn,widthOfBtn, radioViewheight);
                        }else{
                            RadioView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt, radioViewheight);
                        }
                        if (self.arr.count==1) {
                            yPosOfBtn = yPosOfBtn +radioViewheight+25;
                        }else{
                            yPosOfBtn = yPosOfBtn +radioViewheight;
                        }
                        RadioView.tag = (txtTagBaseVaue +i);
                        
                        [self.sub_View addSubview:RadioView];
                        for (int f = 0;f<self.arr.count; f++) {
                            UILabel *lbl = [[UILabel alloc]init];
                            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                                lbl.frame = CGRectMake(0,radioButton_y,widthOfTxt-10,20);
                                lbl.textAlignment = NSTextAlignmentRight;
                            }else{
                                lbl.frame = CGRectMake(30,radioButton_y, widthOfTxt-30, 20);
                            }
                            //lbl.backgroundColor = [UIColor redColor];
                            lbl.numberOfLines = 2;
                            lbl.adjustsFontSizeToFitWidth = YES;
                            lbl.text =self.arr[f];
                            if (@available(iOS 11.0, *)) {
                                [lbl setInsetsLayoutMarginsFromSafeArea:YES];
                            }
                            lbl.textColor = [UIColor blackColor];
                            [lbl setFont: [lbl.font fontWithSize: 20]];
                            [lbl setTag:baseradioTag+f];
                            [RadioView addSubview:lbl];
                            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                                self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(xPosOfTxt- 55,radioButton_y-12,50,50)];
                            }else{
                                self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(0-12.5,radioButton_y-12, 50, 50)];
                            }
                            radioButton_y = radioButton_y+(radioVutton_Vertical_Padding+25);
                            [self.yourButton setImage: [UIImage imageNamed:@"radioChecked.png"]forState:UIControlStateSelected];
                            [self.yourButton setImage: [UIImage imageNamed:@"radioUnchecked.png"]forState: UIControlStateNormal];
                            self.yourButton.selected = NO;
                            [self.yourButton addTarget:self action:@selector(radioSelected:) forControlEvents:UIControlEventTouchUpInside];
                            [self.yourButton setTag:baseradioTag+f];
                            NSLog(@"%ld",(long)self.yourButton.tag);
                            [RadioView addSubview:self.yourButton];
                            //                        if (fields.count >0){
                            //                            [self DisplayOldValues];
                            //                        }else if (self.oldValuesReturn.count) {
                            //                            [self DislpayPreviousValues];
                            //                        }
                        }
                    }else {
                        customer_id_true_count++;
                    }
            }else if (fieldData.fieldAttribute == FieldAttributeCheckbox){
                    if(customer_id == false || hasCustomCategory){
                        NSLog(@"checkbox");
                        self.arr= fieldData.fieldOptions;
                        UIView *CheckboxView = [[UIView alloc]init];
                        int count = self.arr.count;
                        checkBoxViewheight = 32 *count;
                        if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                            CheckboxView.frame = CGRectMake(xPosOfBtn,yPosOfBtn,widthOfBtn, checkBoxViewheight);
                        }else{
                            CheckboxView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt,checkBoxViewheight );
                        }
                        if (self.arr.count==1) {
                            yPosOfBtn = yPosOfBtn +checkBoxViewheight+25;
                        }else{
                            yPosOfBtn = yPosOfBtn +checkBoxViewheight;
                        }
                        CheckboxView.tag = (txtTagBaseVaue +i );
                        [self.sub_View addSubview:CheckboxView];
                        
                        int checkbox_y=yPosOfTxt;
                        for (int f = 0; f<self.arr.count; f++) {
                            
                            UILabel *lbl = [[UILabel alloc]init];
                            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                                lbl.frame = CGRectMake(0,checkboxButton_y+2,widthOfTxt-10,20);
                                lbl.textAlignment = NSTextAlignmentRight;
                            }else{
                                lbl.frame = CGRectMake( 30,checkboxButton_y+2,widthOfTxt-30,20);
                            }
                            //lbl.backgroundColor = [UIColor redColor];
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
                            
                            lbl.textColor = [UIColor blackColor];
                            [lbl setTag:basecheckboxTag+f];
                            [CheckboxView addSubview:lbl];
                            if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                                self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(xPosOfTxt- 45,checkboxButton_y,25,25)];
                            }else{
                                self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(0,checkboxButton_y,25,25)];
                            }
                            checkboxButton_y = checkboxButton_y+(checkbox_Vertical_padding+24);
                            [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"uncheckclicked.png"] forState:UIControlStateNormal];
                            [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkclick.png"] forState:UIControlStateSelected];
                            [self.checkBoxButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
                            [self.checkBoxButton setTag:basecheckboxTag+f];
                            
                            [CheckboxView addSubview:self.checkBoxButton];
                            
                            //                        if (fields.count >0){
                            //                            [self DisplayOldValues];
                            //                        }else if (self.oldValuesReturn.count) {
                            //                            [self DislpayPreviousValues];
                            //                        }
                        }
                    }else {
                        customer_id_true_count++;
                    }
>>>>>>> main
            } else if (fieldData.fieldAttribute == FieldAttributeBarcode){
                
                UIButton *meta_label = [[UIButton alloc] init];
                UIButton *clearForceField = [[UIButton alloc] init];
                if (@available(iOS 13.0, *)) {
                    [clearForceField setBackgroundImage: [UIImage systemImageNamed:@"clear"] forState:UIControlStateNormal];
                } else {
                    // Fallback on earlier versions
                    [clearForceField setBackgroundImage: [UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
                }
                clearForceField.tintColor = UIColor.redColor;
                   
                if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                    //meta_label.frame = CGRectMake(xPosOfBtn,yPosOfTxt,widthOfBtn, heightOfTxt);
                    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
                        meta_label.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,100);
                    }else {
                        meta_label.frame = CGRectMake(xPosOfBtn,yPosOfTxt, widthOfBtn,180);
                    }
                    clearForceField.frame = CGRectMake(widthOfBtn - 31, 1,30, 28);
                }else{
                    //meta_label.frame =  CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
                        meta_label.frame = CGRectMake(xPosOfTxt,yPosOfTxt, widthOfTxt,100);
                    }else {
                        meta_label.frame = CGRectMake(xPosOfTxt,yPosOfTxt, widthOfTxt,180);
                    }
                    clearForceField.frame =  CGRectMake(widthOfTxt - 31, 1, 30, 28);
                }
                meta_label.titleLabel.numberOfLines = 4;
                meta_label.layer.cornerRadius = 5;
                meta_label.layer.borderWidth = 1;
                meta_label.layer.backgroundColor = [UIColor whiteColor].CGColor;
                meta_label.layer.borderColor = [UIColor blackColor].CGColor;
                meta_label.titleLabel.textColor=Blue;
                [meta_label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                
                meta_label.tag = (lblTagBaseValue + i);
                clearForceField.tag = (lblTagBaseValue + i + forcebarcodeClearTag);
                clearForceField.hidden = YES;
                [meta_label addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
                [clearForceField addTarget:self action:@selector(clearForceFieldData:) forControlEvents:UIControlEventTouchUpInside];
                [meta_label addSubview:clearForceField];
                [self.sub_View addSubview:meta_label];
//                if (fields.count >0){
//                    [self DisplayOldValues];
//                }else if (self.oldValuesReturn.count) {
//                    [self DislpayPreviousValues];
//                }
            }else if (fieldData.fieldAttribute == FieldAttributeDatePicker){
                //button_datepicker
                UIButton* meta_btn_datePicker = [[UIButton alloc] init] ;
                if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
                    meta_btn_datePicker.frame = CGRectMake(xPosOfBtn,yPosOfTxt,widthOfBtn, heightOfTxt);
                }else{
                    meta_btn_datePicker.frame =  CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                }
                [meta_btn_datePicker setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                meta_btn_datePicker.layer.cornerRadius = 5;
                meta_btn_datePicker.layer.borderWidth = 1;
                meta_btn_datePicker.layer.borderColor = [UIColor blackColor].CGColor;
              
                meta_btn_datePicker.userInteractionEnabled = YES;
                meta_btn_datePicker.tag = (baseDateTag + i );
                [meta_btn_datePicker addTarget:self action:@selector(datePicker_button:)forControlEvents:UIControlEventTouchUpInside];
                [self.sub_View addSubview:meta_btn_datePicker];
               
            }
        }
    }
        if (fields.count >0){
            [self DisplayOldValues];
        }else if (self.oldValuesReturn.count) {
            [self DislpayPreviousValues];
        }
    } @catch (NSException *exception) {
        NSLog(@"ggg");
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

- (IBAction)clearForceFieldData:(id)sender {
        UIButton *currentButton = (UIButton *)sender;
        forecbarCodeTag = (int)currentButton.tag - forcebarcodeClearTag;
        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
        [self.alertbox setHorizontalButtons:YES];
        [self.alertbox addButton:NSLocalizedString(@"NO",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
        [self.alertbox addButton: NSLocalizedString(@"YES",@"") target:self selector:@selector(clearForceFieldConfirm:) backgroundColor:Red];
        [self.alertbox showSuccess: NSLocalizedString(@"Alert !",@"") subTitle: NSLocalizedString(@"Are You Sure To Clear The Field?",@"") closeButtonTitle:nil duration:1.0f ];

}

-(IBAction)clearForceFieldConfirm:(id)sender
{
    @try {
    NSArray *subviews = [self.sub_View subviews];
        for (UIView *newView in subviews) {
            if ([newView  isKindOfClass:[UIButton class]]){
                UIButton *butField = (UIButton *) newView;
                NSInteger tag = newView.tag;
                if(tag == forecbarCodeTag){
                    [butField setTitleColor:Blue forState:UIControlStateNormal];
                    [butField setTitle:@"" forState:UIControlStateNormal];
                    butField.titleLabel.text = @"";
                    UIButton *clickedButton = (UIButton *)[butField.superview viewWithTag:tag + forcebarcodeClearTag];
                    clickedButton.hidden = YES;
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"text changed: %@", textField.text);
}

-(void) datePicker_button:(UIButton *)sender
{
    self.senderTag=(int)sender.tag;
    FieldData *fieldData= [self.metaDataArray objectAtIndex:(self.senderTag % 100)];
    
    //alertview_for_datepicker
<<<<<<< HEAD
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Select Date",@"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") otherButtonTitles:NSLocalizedString(@"OK",@""),nil];

    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 750, 616)];
=======
    if(alert != nil){
        alert = nil;
    }
    alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Select Date",@"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") otherButtonTitles:NSLocalizedString(@"OK",@""),nil];

    if(picker == nil){
        picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 750, 616)];
    }
>>>>>>> main
    [picker setDatePickerMode:UIDatePickerModeDate];
    [picker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    [picker setTintColor:[UIColor blackColor] ];
    picker.backgroundColor = [UIColor colorWithRed: 0.11 green: 0.65 blue: 0.71 alpha: 0.5f ] ;
<<<<<<< HEAD
    [picker setTimeZone:[NSTimeZone systemTimeZone]];
=======
   // [picker setTimeZone:[NSTimeZone systemTimeZone]]; //set current date
>>>>>>> main
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
    
<<<<<<< HEAD
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@" %@",[fromatter stringFromDate:picker.date]] forKey:@"datePicker"];
=======
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[fromatter stringFromDate:picker.date]] forKey:@"datePicker"];
>>>>>>> main
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
<<<<<<< HEAD
        [self sendStringViewController:label withTag:labeltag];
=======
        [self sendStringViewController:label withTag:labeltag]; // cancel to clear date field
>>>>>>> main
    }
}

-(IBAction)pickerChanged:(id)sender{
    //self.senderTag = (int)sender;
    //datePicker
    NSDateFormatter *fromatter=[[NSDateFormatter alloc]init];
    [fromatter setDateFormat:@"MM-dd-yyyy"];
<<<<<<< HEAD
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@" %@",[fromatter stringFromDate:picker.date]] forKey:@"datePicker"];
=======
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[fromatter stringFromDate:picker.date]] forKey:@"datePicker"];
>>>>>>> main
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
<<<<<<< HEAD
    if(![text isEqual:@""]){
=======
    
    if(![text isEqual:@""]){
        long tag = _textView.tag;
        int index = (int)tag % 100;
        FieldData *fieldData = [self.metaDataArray objectAtIndex:index];
        if (fieldData.fieldAttribute == FieldAttributeAlpha || fieldData.fieldAttribute == FieldAttributeNumeric
                              || fieldData.fieldAttribute == FieldAttributeAlphaNumeric || fieldData.fieldAttribute == FieldAttributeComments) {
            int  length = fieldData.fieldLength;
            if(text.length > 1 && _textView.text.length + text.length >= length){
                [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                return NO;
            }else if (_textView.text.length >= length)
            {
                [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                return NO;
            }
        }
        
>>>>>>> main
        if(_textView.frame.size.height < 100){
            if(_textView.text.length >= 50){
                [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                return NO;
            }
        } else {
            if(_textView.text.length >= 150){
                [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                return NO;
            }
        }
<<<<<<< HEAD
=======
        //check tappi number count
        if (_textView == self.tappi_txt) {
            if(_textView.text.length >= 3){
                [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                return NO;
            }
        }
>>>>>>> main
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
    NSMutableArray *parkloadarray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"];
    NSInteger currentloadnumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload = [parkloadarray objectAtIndex:currentloadnumber];
    for (UIView *newView in subviews) {
        NSLog(@"%d", customer_id_true_count);
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
                FieldData *newFields = [self.metaDataArray objectAtIndex:(index)];
                
                if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){//2154 3975 3976
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
            }else if(index < self.metaDataArray.count && OldLoadFieldsfields.count > 0){
                FieldData *newFields = [self.metaDataArray objectAtIndex:(index)];
                for(int j = 0; j < OldLoadFieldsfields.count; j++){
                    NSDictionary *f = [OldLoadFieldsfields objectAtIndex:j];
                    if(newFields.fieldId == [[f objectForKey:@"field_id"]intValue]){
                        NSString *sstring  =[f objectForKey:@"field_value"];
                        [textField setText:sstring];
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
                    FieldData *newFields = [self.metaDataArray objectAtIndex:(index)];
                    if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                        
                        NSString *sstring  =[field objectForKey:@"field_value"];
                        [butField setTitle:sstring forState:UIControlStateNormal];
                        if(newFields.fieldAttribute == FieldAttributeBarcode){
                            UIButton *clickedButton = (UIButton *)[butField.superview viewWithTag:tag + forcebarcodeClearTag];
                            if([sstring isEqual:@""]){
                                clickedButton.hidden = YES;
                            }else {
                                clickedButton.hidden = NO;
                            }
                        }
                    }else{
                        NSLog(@"Data not displayed:\nIndex: %d,\tOld: %@,\tNew: %d",index,[field objectForKey:@"field_id"],newFields.fieldId);
                        for (int iterator=0; iterator<OldLoadFieldsfields.count; iterator++) {
                            field=[OldLoadFieldsfields objectAtIndex:(iterator)];
                            if ([[field objectForKey:@"field_id"]intValue] == newFields.fieldId){
                                
                                NSString *sstring  = [field objectForKey:@"field_value"];
                                [butField setTitle:sstring forState:UIControlStateNormal];
                                if(newFields.fieldAttribute == FieldAttributeBarcode){
                                    UIButton *clickedButton = (UIButton *)[butField.superview viewWithTag:tag + forcebarcodeClearTag];
                                    if([sstring isEqual:@""]){
                                        clickedButton.hidden = YES;
                                    }else {
                                        clickedButton.hidden = NO;
                                    }
                                }
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
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                }else if(index < self.metaDataArray.count && OldLoadFieldsfields.count > 0){
                    FieldData *newFields = [self.metaDataArray objectAtIndex:(index)];
                    for(int j = 0; j < OldLoadFieldsfields.count; j++){
                        NSDictionary *f = [OldLoadFieldsfields objectAtIndex:j];
                        if(newFields.fieldId == [[f objectForKey:@"field_id"]intValue]){
                            NSMutableArray *storedValue = [[NSMutableArray alloc]init];
                            
                            storedValue =[f objectForKey:@"field_value"];
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
                                        break;
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
                        break;
                    }
                }
                if (isSucceeded){
                    
                    [dictFieldValue setObject:@(fieldData.fieldId) forKey:@"field_id"];
                    [dictFieldValue setObject:inputString forKey:@"field_value"];
                    [dictFieldValue setObject:fieldData.isMandatory?@"1":@"0"
                                       forKey:@"field_mandatory"];
                    switch (fieldData.fieldAttribute){
                        case FieldAttributeAlpha:
                            [dictFieldValue setObject:@"Alpha" forKey:@"field_attribute"];
                            break;
                        case FieldAttributeNumeric:
                            [dictFieldValue setObject:@"Numeric" forKey:@"field_attribute"];
                            break;
                        case FieldAttributeAlphaNumeric:
                            [dictFieldValue setObject:@"Alpha/Numeric" forKey:@"field_attribute"];
                            break;
                        case FieldAttributeComments:
                            [dictFieldValue setObject:@"Comments" forKey:@"field_attribute"];
                            break;
                    }
                    if(fieldData.load_centric){
                        [dictFieldValue setObject:@"1" forKey:@"f_load_centric"];
                    }else {
                        [dictFieldValue setObject:@"0" forKey:@"f_load_centric"];
                    }
                    [arrFieldValues addObject:dictFieldValue];
                }
            }
        }else if ([newView  isKindOfClass:[UIButton class]]){
            
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
                        if(fieldData.load_centric){
                            [dictFieldValue setObject:@"1" forKey:@"f_load_centric"];
                        }else {
                            [dictFieldValue setObject:@"0" forKey:@"f_load_centric"];
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
                    if(fieldData.load_centric){
                        [dictFieldValue setObject:@"1" forKey:@"f_load_centric"];
                    }else {
                        [dictFieldValue setObject:@"0" forKey:@"f_load_centric"];
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
            NSArray *field_oopions_arr = fieldData.fieldOptions;
            if(field_oopions_arr.count > 0){
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
                if(fieldData.load_centric){
                    [dictFieldValue setObject:@"1" forKey:@"f_load_centric"];
                }else {
                    [dictFieldValue setObject:@"0" forKey:@"f_load_centric"];
                }
                [arrFieldValues addObject:dictFieldValue];
                NSLog(@"arrFieldValues:%@",arrFieldValues);
            }
        }
        
    }

<<<<<<< HEAD
=======
    if(!hasAddon8){
        @try {
            NSMutableArray *allMetaDatas = [NSMutableArray array];
            for (int i =0;i<arrFieldValues.count; i++) {
                NSMutableDictionary *dictFieldValue = [arrFieldValues objectAtIndex:i];
                for (int j =0; j<self.metaDataArray.count; j++) {
                    FieldData *fieldData = [self.metaDataArray objectAtIndex:j];
                    int fieldId = (int) [[dictFieldValue objectForKey:@"field_id"]integerValue];
                    if(fieldId == fieldData.fieldId){
                        [allMetaDatas addObject:fieldData];
                    }
                }
            }
            for (int i =0;i<allMetaDatas.count; i++) {
                FieldData *dictMetaData = [allMetaDatas objectAtIndex:i];
                NSString *lable = dictMetaData.strFieldLabel;
                NSMutableArray *matched_ids = dictMetaData.matched_f_id;
                NSMutableDictionary *dictFieldValue = [arrFieldValues objectAtIndex:i];
                NSString *fieldValue = [dictFieldValue objectForKey:@"field_value"];
                if(matched_ids != nil && matched_ids.count > 0){
                    for (int j =0; j< allMetaDatas.count; j++) {
                        FieldData *dictMetaDataJ = [allMetaDatas objectAtIndex:j];
                        if(dictMetaData.fieldId != dictMetaDataJ.fieldId){
                            BOOL isSame = false;
                            for(int k =0; k < matched_ids.count; k++){
                                NSString *a = matched_ids[k];
                                if([a integerValue] == dictMetaDataJ.fieldId){
                                    isSame = true;
                                    break;
                                }
                            }
                            if(isSame == true){
                                NSMutableDictionary *dictFieldValue2 = [arrFieldValues objectAtIndex:j];
                                NSString *fieldValue2 = [dictFieldValue2 objectForKey:@"field_value"];
                                NSString *fieldLabel2 = dictMetaDataJ.strFieldLabel;
                                if(dictMetaDataJ.fieldAttribute == FieldAttributeRadio || dictMetaDataJ.fieldAttribute == FieldAttributeCheckbox){
                                    if(![fieldValue isEqual:fieldValue2]){
                                        NSString *msg = @"Please enter the same value in ";
                                        msg = [msg stringByAppendingString:lable];
                                        msg = [msg stringByAppendingString:@" and "];
                                        msg = [msg stringByAppendingString:fieldLabel2];
                                        msg = [msg stringByAppendingString:@" to proceed upload"];
                                        [self servicewire_poper:msg];
                                        return;
                                    }
                                }else {
                                    if(![[fieldValue lowercaseString] isEqual:[fieldValue2 lowercaseString]]){
                                        NSString *msg = @"Please enter the same value in ";
                                        msg = [msg stringByAppendingString:lable];
                                        msg = [msg stringByAppendingString:@" and "];
                                        msg = [msg stringByAppendingString:fieldLabel2];
                                        msg = [msg stringByAppendingString:@" to proceed upload"];
                                        [self servicewire_poper:msg];
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"Error");
        }
    }
>>>>>>> main

    if (isSucceeded) {
        if (hasAddon8 && !hasCustomCategory && !hasAddon7) {
            if([self.tappi_txt.text intValue] > 350){
                NSString *noOfTappi = @"Enter ";
                if(self.siteData.tappi_name != nil){
                    noOfTappi = [noOfTappi stringByAppendingString:self.siteData.tappi_name];
                    noOfTappi = [noOfTappi stringByAppendingString:@" No. Max 350"];
                }else {
                    noOfTappi = NSLocalizedString(@"Enter Tappi No. Max 350",@"");
                }
                [self.view makeToast:noOfTappi duration:2.0 position:CSToastPositionCenter];
                return;
            }
<<<<<<< HEAD
=======

            BOOL matches = [self isNumeric:self.tappi_txt.text];
            if (!matches) {
                NSString *noOfTappi = @" ";
                if(self.siteData.tappi_name != nil){
                    noOfTappi = [noOfTappi stringByAppendingString:@" Enter Valid "];
                    noOfTappi = [noOfTappi stringByAppendingString:self.siteData.tappi_name];
                }else {
                    noOfTappi = NSLocalizedString(@"Enter Valid Tappi No.",@"");
                }
                [self.view makeToast:noOfTappi duration:2.0 position:CSToastPositionCenter];
                isSucceeded = NO;
                return;
            }
            
>>>>>>> main
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
                NSMutableArray* looping_fields =[[parkload valueForKey:@"loopingfields"]mutableCopy];
                NSMutableArray* img =[[parkload valueForKey:@"img"]mutableCopy];
                int tappi_oldCount = [[parkload valueForKey:@"tappi_count"]intValue];
                if(self.tappi_count < tappi_oldCount){
                    NSMutableArray *looping_fieldsCopy = [[parkload valueForKey:@"loopingfields"]mutableCopy];
                    
                    for(int x = 0; x<looping_fieldsCopy.count;x++){
                        if((self.tappi_count-1)<x && looping_fields != nil){
                            [looping_fields removeLastObject];
                        }
                    }
                    NSMutableArray *imgCopy = [[parkload valueForKey:@"img"]mutableCopy];
                    int imgcount= (int)imgCopy.count-1;
                    for(int y= imgcount; y>=0;y--){
                        NSMutableDictionary * dic =[imgCopy objectAtIndex:y];
                        int inst = [[dic valueForKey:@"img_numb"]intValue];
                        if(inst > (self.tappi_count - 1)){
                            [img removeObjectAtIndex:y];
                        }
                    }
                    [parkload setObject:img forKey:@"img"];
                    if(looping_fields != nil){
                        [parkload setObject:looping_fields forKey:@"loopingfields"];
                    }
                }
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
               NSString *noOfTappi = @"Enter Valid ";
               if(self.siteData.tappi_name != nil){
                   noOfTappi = [noOfTappi stringByAppendingString:self.siteData.tappi_name];
                   noOfTappi = [noOfTappi stringByAppendingString:@" No."];
               }else {
                   noOfTappi = NSLocalizedString(@"Enter Valid Tappi No.",@"");
               }
               [self.view makeToast:noOfTappi duration:2.0 position:CSToastPositionCenter];
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
            NSString * orgin_sid = [parkload objectForKey:@"origin_site_id"];
            NSString * orgin_lid = [parkload objectForKey:@"origin_load_id"];
            bool isMatchWithCentric = false;
            if(orgin_sid != nil && orgin_lid != nil){
                if(![orgin_sid isEqual:@""] && ![orgin_sid isEqual:@""]){
                    if(self.qrArrMetaData != nil && self.qrArrMetaData.count > 0){
                        for(int i = 0; i < self.qrArrMetaData.count; i++){
                            FieldData *qrFieldData = self.qrArrMetaData[i];
                            for(int j = 0; j < arrFieldValues.count; j++){
                                NSMutableDictionary *dictFieldValue = arrFieldValues[j];
                                BOOL LoadCentric = [[dictFieldValue objectForKey:@"f_load_centric"]boolValue];
                                if(LoadCentric){
                                    int fid = (int) [[dictFieldValue objectForKey:@"field_id"]integerValue];
                                    if(fid == qrFieldData.fieldId){
                                        if(qrFieldData.fieldAttribute == FieldAttributeRadio ||
                                           qrFieldData.fieldAttribute == FieldAttributeCheckbox){
                                            if([qrFieldData.qrMetaData isEqual:[dictFieldValue objectForKey:@"field_value"]]){
                                                isMatchWithCentric = true;
                                                break;
                                            }
                                        }else {
                                            if([qrFieldData.qrMetaData[0] isEqual:[dictFieldValue objectForKey:@"field_value"]]){
                                                isMatchWithCentric = true;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }else {
                        isMatchWithCentric = true;
                    }
                }
            }
            if(isMatchWithCentric == false){
                [parkload setObject:@"" forKey:@"origin_site_id"];
                [parkload setObject:@"" forKey:@"origin_load_id"];
            }
            
            
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

<<<<<<< HEAD
=======
-(void) servicewire_poper:(NSString *)strtext{

     self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
     [self.alertbox setHorizontalButtons:YES];
     [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
    NSString *str = NSLocalizedString(@"Alert !",@"");
    if([str containsString:@" !"]){
        str = [str stringByReplacingOccurrencesOfString:@" !" withString:@""];
    }
     [self.alertbox showSuccess:str subTitle:strtext closeButtonTitle:nil duration:1.0f ];
 }
>>>>>>> main


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
    FieldData *fieldData = [self.metaDataArray objectAtIndex:(tagNumber % 100)];
    BOOL LoadCentric = fieldData.load_centric;
    if(LoadCentric){
        if ([string rangeOfString:@"sitedata="].location == NSNotFound) {
            [self displayScanData:string withTag:tagNumber];
        }else {
            NSArray *items = [string componentsSeparatedByString:@"sitedata="];
            if(items.count > 1){
                NSArray *ids = [items[1] componentsSeparatedByString:@"LP"];
                if(ids.count > 1){
                        NSMutableArray *parkloadarray = [[NSMutableArray alloc] init];
                        parkloadarray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
                        NSInteger currentloadnumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
                        NSMutableDictionary * parkload = [[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
                    BOOL isaddon7 = [[parkload objectForKey:@"isAddon7CustomGpcc"] boolValue];
                    BOOL isaddon5 = [[parkload objectForKey:@"isAddon7Custom"] boolValue];
                    BOOL isOnlyAddon7 = false;
                    NSMutableArray *instData =  [parkload objectForKey:@"instructData"];
                    if(instData != nil && instData.count > 0){
                        isOnlyAddon7 = true;
                    }
                    if(!isaddon7 && !isaddon5 && !isOnlyAddon7 && !hasAddon8){
                        if(![@(self.siteData.siteId).stringValue isEqual:ids[0]]){
                            [self getCntricApiCall:ids[0] withTag:ids[1]];
                        }else {
                            [self.view makeToast:@"Scanned Site and Current Site both are same" duration:2.0 position:CSToastPositionCenter];
                        }
                    }else {
                        [self.view makeToast:@"Load centric will not support for Addon-07/Addon-08" duration:2.0 position:CSToastPositionCenter];
                    }
                }else {
                    [self displayScanData:string withTag:tagNumber];
                }
            }else {
                [self displayScanData:string withTag:tagNumber];
            }
        }
    }else {
        if ([string rangeOfString:@"sitedata="].location == NSNotFound) {
            [self displayScanData:string withTag:tagNumber];
        }else {
            NSArray *items = [string componentsSeparatedByString:@"sitedata="];
            if(items.count > 1){
                NSArray *ids = [items[1] componentsSeparatedByString:@"LP"];
                if(ids.count > 1){
                    NSMutableArray *parkloadarray = [[NSMutableArray alloc] init];
                    parkloadarray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
                    NSInteger currentloadnumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
                    NSMutableDictionary * parkload = [[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
                    BOOL isOnlyAddon7 = false;
                    NSMutableArray *instData =  [parkload objectForKey:@"instructData"];
                    if(instData != nil && instData.count > 0){
                        isOnlyAddon7 = true;
                    }
                     if([[parkload objectForKey:@"isAddon7CustomGpcc"] boolValue] == true || [[parkload objectForKey:@"isAddon7Custom"] boolValue] == true  || isOnlyAddon7 == true
                        || hasAddon8 == true){
                         [self.view makeToast:@"Load centric will not support for Addon-07/Addon-08" duration:2.0 position:CSToastPositionCenter];
                     }else {
                         [self.view makeToast:@"Either Selected site or QR code site doesn't have Extend option." duration:2.0 position:CSToastPositionCenter];
                     }
                }else {
                    [self displayScanData:string withTag:tagNumber];
                }
            }else {
                [self displayScanData:string withTag:tagNumber];
            }
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


-(void)displayScanData:(NSString *) string withTag :(NSInteger) tagNumber {
    FieldData *fieldData = [self.metaDataArray objectAtIndex:(tagNumber % 100)];
    if (tagNumber >= 400) {
        if( fieldData.fieldAttribute == FieldAttributeBarcode )
        {
            UIButton *butField = (UIButton *)[self.view viewWithTag:tagNumber];
            NSString * val = butField.titleLabel.text;
            NSString *append = @"";
            
            if(val != nil && ![val isEqual:@""]){
                append = [val stringByAppendingString:@", "];
                NSString *finalStr = [append stringByAppendingString:string];
<<<<<<< HEAD
                if(finalStr.length > 50){
                    [self.view makeToast:@"Field value reached to max value" duration:2.0 position:CSToastPositionCenter];
                }
                finalStr = (finalStr.length > 50) ? [finalStr substringToIndex:50] : finalStr;
                [butField setTitle:finalStr forState:UIControlStateNormal];
            }else {
                string = (string.length > 50) ? [string substringToIndex:50] : string;
                [butField setTitle:string forState:UIControlStateNormal];
=======
//                if(finalStr.length > 50){
//                    NSString * newString = [finalStr substringWithRange:NSMakeRange(0, finalStr.length)];
//                    [butField setTitle:newString forState:UIControlStateNormal];
//                    [self.view makeToast:@"Field value reached to max value" duration:2.0 position:CSToastPositionCenter];
//                }
                if (finalStr.length > fieldData.fieldLength)
                {
                    finalStr = (finalStr.length > fieldData.fieldLength) ? [finalStr substringToIndex:fieldData.fieldLength] : finalStr;
                    [butField setTitle:finalStr forState:UIControlStateNormal];
                    [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                    //return;
                }else {
                    [butField setTitle:finalStr forState:UIControlStateNormal];
                }
            }else {
                if (string.length > fieldData.fieldLength)
                {
                    string = (string.length > fieldData.fieldLength) ? [string substringToIndex:fieldData.fieldLength] : string;
                    [butField setTitle:string forState:UIControlStateNormal];
                    [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                    //return;
                }else {
                    [butField setTitle:string forState:UIControlStateNormal];
                }
>>>>>>> main
            }
            
            [butField setTitleColor:Blue forState:UIControlStateNormal];
            if(fieldData.fieldAttribute == FieldAttributeBarcode){
                UIButton *clickedButton = (UIButton *)[butField.superview viewWithTag:tagNumber + forcebarcodeClearTag];
                clickedButton.hidden = NO;
            }
        }else {
<<<<<<< HEAD
            UIButton *butField = (UIButton *)[self.view viewWithTag:tagNumber];
            [butField setTitle:string forState:UIControlStateNormal];
            [butField setTitleColor:Blue forState:UIControlStateNormal];
=======
            if (string.length > fieldData.fieldLength)
            {
                string = (string.length > fieldData.fieldLength) ? [string substringToIndex:fieldData.fieldLength] : string;
                UIButton *butField = (UIButton *)[self.view viewWithTag:tagNumber];
                [butField setTitle:string forState:UIControlStateNormal];
                [butField setTitleColor:Blue forState:UIControlStateNormal];
                [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                //return;
            }else {
                UIButton *butField = (UIButton *)[self.view viewWithTag:tagNumber];
                [butField setTitle:string forState:UIControlStateNormal];
                [butField setTitleColor:Blue forState:UIControlStateNormal];
            }
>>>>>>> main
        }
    }else{
        //FieldData *fieldData= [self.metaDataArray objectAtIndex:(tagNumber % 100)];
        
        //UIView *newView= [self.view viewWithTag:tagNumber];
        if( fieldData.fieldAttribute == FieldAttributeBarcode )
        {
<<<<<<< HEAD
            int ind = tagNumber + 300;
=======
            long ind = tagNumber + 300;
>>>>>>> main
            if(tagNumber > 400){
                ind = ind - 300;
            }
            UIButton *butField = (UIButton *)[self.view viewWithTag:ind];
            NSString * val = butField.titleLabel.text;
            NSString *append = @"";
            if(val != nil && ![val isEqual:@""]){
                append = [val stringByAppendingString:@", "];
                NSString *finalStr = [append stringByAppendingString:string];
<<<<<<< HEAD
                if(finalStr.length > 50){
                    [self.view makeToast:@"Field value reached to max limit" duration:2.0 position:CSToastPositionCenter];
                }
                finalStr = (finalStr.length > 50) ? [finalStr substringToIndex:50] : finalStr;
                [butField setTitle:finalStr forState:UIControlStateNormal];
            }else {
                [butField setTitle:string forState:UIControlStateNormal];
=======
//                if(finalStr.length > 50){
//                    NSString * newString = [finalStr substringWithRange:NSMakeRange(0, finalStr.length)];
//                    [butField setTitle:newString forState:UIControlStateNormal];
//                    [self.view makeToast:@"Field value reached to max limit" duration:2.0 position:CSToastPositionCenter];
//                }
                if (finalStr.length > fieldData.fieldLength)
                {
                    finalStr = (finalStr.length > fieldData.fieldLength) ? [finalStr substringToIndex:fieldData.fieldLength] : finalStr;
                    [butField setTitle:finalStr forState:UIControlStateNormal];
                    [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                    //return;
                }else {
                    [butField setTitle:finalStr forState:UIControlStateNormal];
                }
            }else {
                if (string.length > fieldData.fieldLength)
                {
                    string = (string.length > fieldData.fieldLength) ? [string substringToIndex:fieldData.fieldLength] : string;
                    [butField setTitle:string forState:UIControlStateNormal];
                    [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                    //return;
                }else {
                    [butField setTitle:string forState:UIControlStateNormal];
                }
>>>>>>> main
            }
            UIButton *clickedButton = (UIButton *)[butField.superview viewWithTag:ind + forcebarcodeClearTag];
            clickedButton.hidden = NO;
            [butField setTitleColor:Blue forState:UIControlStateNormal];
        }else if( fieldData.fieldAttribute == FieldAttributeDatePicker )
        {
            UIButton *butField = (UIButton *)[self.view viewWithTag:tagNumber+200];
<<<<<<< HEAD
            [butField setTitle:string  forState:UIControlStateNormal];
            [butField setTitleColor:Blue forState:UIControlStateNormal];
            
        }else{
            UITextView *textField = (UITextView *)[self.view viewWithTag:tagNumber];
            textField.text = string;
=======
            if (string.length > fieldData.fieldLength)
            {
                string = (string.length > fieldData.fieldLength) ? [string substringToIndex:fieldData.fieldLength] : string;
                [butField setTitle:string  forState:UIControlStateNormal];
                [butField setTitleColor:Blue forState:UIControlStateNormal];
                [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                //return;
            }else {
                [butField setTitle:string  forState:UIControlStateNormal];
                [butField setTitleColor:Blue forState:UIControlStateNormal];
            }
            
        }else{
            if (string.length > fieldData.fieldLength)
            {
                string = (string.length > fieldData.fieldLength) ? [string substringToIndex:fieldData.fieldLength] : string;
                UITextView *textField = (UITextView *)[self.view viewWithTag:tagNumber];
                textField.text = string;
                [self.view makeToast:NSLocalizedString(@"Max Limit Reached ",@"") duration:2.0 position:CSToastPositionCenter style:nil];
                //return;
            }else {
                UITextView *textField = (UITextView *)[self.view viewWithTag:tagNumber];
                textField.text = string;
            }
>>>>>>> main
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextView *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


-(void)handleTimer {
    
    //internet_indicator
    NSString *langStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_language"];
    UIButton *networkStater;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(35,12,16,16)];
    }else{
        networkStater = [[UIButton alloc] initWithFrame:CGRectMake(195,12,16,16)];
    }
    networkStater.layer.masksToBounds = YES;
    networkStater.layer.cornerRadius = 8.0;
    
    //parkload button
    UIButton *parkloadIcon;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(0,8,25,25)];
    }else{
        parkloadIcon = [[UIButton alloc] initWithFrame:CGRectMake(220,8,25,25)];
    }
    [parkloadIcon setBackgroundImage:[UIImage imageNamed:@"parkload_icon.png"]  forState:UIControlStateNormal];
    parkloadIcon.layer.masksToBounds = YES;
    
    //cloud_indicator
    UIButton *cloud_indicator;
    if([langStr isEqualToString:@"Arabic"] || [langStr isEqualToString:@"Urdu"]){
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(195,3,35,32)];
    }else{
        cloud_indicator = [[UIButton alloc] initWithFrame:CGRectMake(0,3,35,32)];
    }
    cloud_indicator.layer.masksToBounds = YES;
    cloud_indicator.layer.cornerRadius = 10.0;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0, 200, 40)];
    titleLabel.text = NSLocalizedString(@"Meta Data",@"");
    //titleLabel.minimumFontSize = 18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.highlighted=YES;
    titleLabel.textColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(3,0, 245, 40)];
    [view addSubview:titleLabel];
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
    //parkload icon
    NSMutableArray *parkloadarray= [[NSMutableArray alloc] init];
    parkloadarray=[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
    NSInteger currentloadnumber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
    NSMutableDictionary * parkload = [[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
    
    [parkloadIcon addTarget:self action:@selector(parkload_poper) forControlEvents:UIControlEventTouchUpInside];
    [parkloadIcon setExclusiveTouch:YES];
    
    [view addSubview:parkloadIcon];
    self.navigationItem.titleView = view;
    
    if(![[parkload objectForKey:@"isParked"] isEqual:@"1"] && parkloadarray.count == 1){
        parkloadIcon.hidden = YES;
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
    [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Green];
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

-(void)getCntricApiCall: (NSString *) s_id withTag :(NSString *) loadId{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        NSMutableArray *parkloadarray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverParkLoadArray"] mutableCopy];
        [[NSUserDefaults standardUserDefaults] setInteger: -1 forKey:@"DriverCurrentLoadNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"DriverParkLoadArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf =self;
        NSString * accessVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppAccessVersion"];
        NSString *currentSite = @(self.siteData.siteId).stringValue;
        [ServerUtility getLoadCentricDataCid:s_id withLoadid:loadId withsid:currentSite andCompletion:^(NSError * error ,id data,float dummy){
            AZCAppDelegate *delegate = [AZCAppDelegate sharedInstance];
            delegate.isMaintenance=NO;
            if (!error)
            {
                NSLog(@"App delegate data:%@",data);
                NSString *strResType = [data objectForKey:@"res_type"];
                if ([strResType.lowercaseString isEqualToString:@"success"] )
                {
                    NSMutableDictionary *DictData = [[NSMutableDictionary alloc]init];
                    [DictData addEntriesFromDictionary:data];
                    
                    NSLog(@"currentVC:%@",delegate.CurrentVC);
                    [self getCentricProfile: (DictData) withsecond: s_id  withthird: loadId];
                    //                [self driverValidate: cid];
                }else{
                    if([data valueForKey:@"multi_device"]){
                        self.alertbox = [[SCLAlertView alloc] initWithNewWindow];
                        [self.alertbox addButton:NSLocalizedString(@"OK",@"") target:self selector:@selector(dummy:) backgroundColor:Blue];
                        [self.alertbox showSuccess:NSLocalizedString(@"Alert !",@"") subTitle:[data objectForKey:@"msg"] subTitleColor:[UIColor redColor] closeButtonTitle:nil duration:-100 ];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    }else{
                        NSLog(@"Error:%@",error);
                        [self.view makeToast:[data objectForKey:@"msg"] duration:2.0 position:CSToastPositionCenter];
                    }
                }
            }else {
                [self.view makeToast:@"Invalid QR" duration:2.0 position:CSToastPositionCenter];
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    } else {
        [self.view makeToast:NSLocalizedString(@"No Internet!",@"") duration:2.0 position:CSToastPositionCenter];
    }
}

-(void) getCentricProfile:(NSMutableDictionary *) DictData withsecond:(NSString*) sid withthird:(NSString*) load_id{
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        //getting the user profile data
    NSMutableArray*userProfile = [DictData objectForKey:@"user_profile"];
    NSString * cid = [DictData objectForKey:@"c_id"];
//    NSString * tappiid = [DictData objectForKey:@"tappi_id"];
    NSString * tappiid = @"";
    NSString * pic_count = [DictData objectForKey:@"pic_count"];
    NSString * video_count = [DictData objectForKey:@"video_count"];
    NSString * plan_count = [DictData objectForKey:@"plancount"];
        //iterating user profile data
    NSMutableDictionary *userProfileData = [userProfile objectAtIndex:0];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:userProfileData options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    NSLog(@"%@",myString);
        //changes
    //getting new data
    NSMutableArray *newnetwork = [userProfileData objectForKey:@"network-data"];
        //declaring variables for new data
//    int newfieldlength = 0;
//    int newfieldid = 0;
//    NSString *newfieldlabel;
//    int newcount = 0 ;
    
    //getting old data from app delegate
//    NSMutableArray *arr = delegate.userProfiels.arrSites;
    //self.sites = delegate.userProfiels.arrSites;
    //SiteData *sites = delegate.siteDatas;
    //NSArray *oldArray = sites.arrFieldData;

    if(userProfileData != nil){
        //array is null
        //NSLog(@"networkid is null while killing the app");
        //DriverData *userData = [[DriverData alloc]initWithDictionary:userProfileData];
        //AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
        //delegate.driverSiteProfiles = userData;
        //self.sites = delegate.userProfiels.arrSites;
        //SiteData *siteData;
        NSMutableArray *qrArrFieldsData = nil;
        for (NSDictionary *dictNetworkData  in newnetwork) {
            int NetworkId =[[dictNetworkData objectForKey:@"n_id"]intValue];
                //create the array of field data
            NSArray *arrRawFieldData = [dictNetworkData objectForKey:@"field_data"];
                //iterate the array and create field data objects array
            NSMutableArray *arrFieldsData = nil;
            for (NSDictionary *dictFieldData in arrRawFieldData) {
                if (!arrFieldsData) {
                    arrFieldsData = [NSMutableArray array];
                }
                FieldData *fieldData = [[FieldData alloc]initWithDictionary:dictFieldData];
                if (fieldData.active) {
                    [arrFieldsData addObject:fieldData];
                }
            }
           
            if ([dictNetworkData objectForKey:@"qr_field_data"]) {
                NSArray *qrarrRawFieldData = [dictNetworkData objectForKey:@"qr_field_data"];
                for (NSDictionary *dictFieldData in qrarrRawFieldData) {
                    if (!qrArrFieldsData) {
                        qrArrFieldsData = [NSMutableArray array];
                    }
                    FieldData *fieldData = [[FieldData alloc]initWithDictionary:dictFieldData];
                    if(fieldData.fieldOptions == nil){
//                        fieldData.fieldOptions = [@[] mutableCopy];
                        fieldData.fieldOptions = @"";
                    }
                    if(fieldData.dummyFieldOptions == nil){
//                        fieldData.dummyFieldOptions = [@[] mutableCopy];
                        fieldData.dummyFieldOptions = @"";
                    }
                    if(fieldData.siteListId == nil){
//                        fieldData.siteListId = [@[] mutableCopy];
                        fieldData.siteListId = @"";
                    }
                    if (fieldData.active) {
                        [qrArrFieldsData addObject:fieldData];
                    }
                }
            }
        }
        @try{
        if(qrArrFieldsData != nil && qrArrFieldsData.count > 0 && self.metaDataArray != nil && self.metaDataArray.count > 0){
            bool isSelectedfieldAvailableinarray = false;
            if (!self.qrArrMetaData) {
                self.qrArrMetaData = [NSMutableArray array];
            }
            if(self.qrArrMetaData != nil && self.qrArrMetaData.count > 0){
                self.qrArrMetaData = [@[] mutableCopy];
            }
            for (int i = 0; i < qrArrFieldsData.count; i++) {
                FieldData *qrFieldData = qrArrFieldsData[i];
                [self.qrArrMetaData addObject:qrFieldData];
                for (int j = 0; j < self.metaDataArray.count; j++) {
                    FieldData *fieldData = self.metaDataArray[j];
                    if(fieldData.load_centric){
                        if(qrFieldData.fieldId == fieldData.fieldId){
                            isSelectedfieldAvailableinarray = true;
                        }
                    }
                }
            }
            NSMutableArray *parkloadarray = [[NSMutableArray alloc] init];
            parkloadarray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ParkLoadArray"]mutableCopy];
            NSInteger currentloadnumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLoadNumber"] intValue];
            NSMutableDictionary * parkload = [[parkloadarray objectAtIndex:currentloadnumber]mutableCopy];
            //save api data in load to use for parked load edit
            //[parkload setObject:qrArrFieldsData forKey:@"qr_field_data"];
            NSString *stored_lbl;
            int buttonIndex = 500;
            //int index = 0;
            //BOOL isTheObjectThere;
          
                for (int i = 0; i < self.metaDataArray.count; i++) {
                    FieldData *fieldData = self.metaDataArray[i];
                    for (int k = 0; k < qrArrFieldsData.count; k++) {
                        FieldData *qrFieldData = qrArrFieldsData[k];
                        if(qrFieldData.fieldId == fieldData.fieldId){
                            if(fieldData.fieldAttribute == FieldAttributeRadio){
                                if(qrFieldData.qrMetaData != nil && qrFieldData.qrMetaData.count > 0){
                                    //for(UIView *view in self.sub_View.subviews){
                                        
                                        NSArray *subviews = [self.sub_View subviews];
                                    
                                        for (UIView *newView in subviews) {
//                                                int tag = newView.tag;
//                                                index = (int)tag - 100;
                                            FieldData *newFields = [self.metaDataArray objectAtIndex:(i)];
                                            if(newFields.fieldId == qrFieldData.fieldId){
                                                if ([newView  isKindOfClass:[UIView class]]){
                                                    for(int j = 0; j < qrFieldData.qrMetaData.count; j++){
                                                        NSString *storedValue = qrFieldData.qrMetaData[j];
                                                        
                                                        NSArray *buttonViews = [newView subviews];
                                                        for (UIView *buttonView in buttonViews) {
                                                            
                                                            if ([buttonView isKindOfClass:[UILabel class]]) {
                                                                int tag = buttonView.tag;
                                                                tag = tag - 300;
                                                                // buttonIndex = tag;
                                                                
                                                                UILabel *label = (UILabel *) buttonView;
                                                                stored_lbl = label.text;
                                                                if ([TRIM(stored_lbl) isEqual:TRIM(storedValue)]) {
                                                                    buttonIndex = tag;
                                                                    NSLog(@"Yes Object there ");
                                                                }
                                                                else
                                                                    buttonIndex = -1;
                                                            }
                                                            if ([buttonView isKindOfClass:[UIButton class]]) {
                                                                int tag = buttonView.tag;
                                                                tag = tag - 300;
                                                                if (tag == buttonIndex) {
                                                                    UIButton *SelectedButton = (UIButton *) buttonView;
                                                                    if(newFields){
                                                                        SelectedButton.selected = YES;
                                                                        if(isSelectedfieldAvailableinarray == true){
                                                                            [parkload setObject:load_id forKey:@"origin_load_id"];
                                                                            [parkload setObject:sid forKey:@"origin_site_id"];
                                                                        }
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    //}
                                }
                            }else if(fieldData.fieldAttribute == FieldAttributeCheckbox){
                                if(qrFieldData.qrMetaData != nil && qrFieldData.qrMetaData.count > 0){
                                    //for(UIView *view in self.sub_View.subviews){
                                        
                                        NSArray *subviews = [self.sub_View subviews];
                                    
                                        for (UIView *newView in subviews) {
                                            int tag = newView.tag;
                                            //index = (int)tag - 100;
                                            FieldData *newFields = [self.metaDataArray objectAtIndex:(i)];
                                            if(newFields.fieldId == qrFieldData.fieldId){
                                                if ([newView  isKindOfClass:[UIView class]]){
                                                    for(int j = 0; j < qrFieldData.qrMetaData.count; j++){
                                                        NSString *storedValue = qrFieldData.qrMetaData[j];
                                                        
                                                        NSArray *buttonViews = [newView subviews];
                                                        for (UIView *buttonView in buttonViews) {
                                                            
                                                            if ([buttonView isKindOfClass:[UILabel class]]) {
                                                                int tag = buttonView.tag;
                                                                tag = tag - 300;
                                                                // buttonIndex = tag;
                                                                
                                                                UILabel *label = (UILabel *) buttonView;
                                                                stored_lbl = label.text;
                                                                if ([TRIM(stored_lbl) isEqual:TRIM(storedValue)]) {
                                                                    buttonIndex = tag;
                                                                    NSLog(@"Yes Object there ");
                                                                }
                                                                else
                                                                    buttonIndex = -1;
                                                            }
                                                            if ([buttonView isKindOfClass:[UIButton class]]) {
                                                                int tag = buttonView.tag;
                                                                tag = tag - 300;
                                                                if (tag == buttonIndex) {
                                                                    UIButton *SelectedButton = (UIButton *) buttonView;
                                                                    if(newFields){
                                                                        SelectedButton.selected = YES;
                                                                        if(isSelectedfieldAvailableinarray == true){
                                                                            [parkload setObject:load_id forKey:@"origin_load_id"];
                                                                            [parkload setObject:sid forKey:@"origin_site_id"];
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    //}
                                }
                            }else if(fieldData.fieldAttribute == FieldAttributeNumeric || fieldData.fieldAttribute == FieldAttributeAlpha || fieldData.fieldAttribute == FieldAttributeAlphaNumeric  || fieldData.fieldAttribute == FieldAttributeComments){
                                if(qrFieldData.qrMetaData != nil && qrFieldData.qrMetaData.count > 0){
                                    //for(UIView *view in self.sub_View.subviews){
                                        NSArray *subviews = [self.sub_View subviews];
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
                                                FieldData *newFields = [self.metaDataArray objectAtIndex:(index)];
                                                if(newFields.fieldId == qrFieldData.fieldId){
                                                    [textField setText:qrFieldData.qrMetaData[0]];
                                                    if(isSelectedfieldAvailableinarray == true){
                                                        [parkload setObject:load_id forKey:@"origin_load_id"];
                                                        [parkload setObject:sid forKey:@"origin_site_id"];
                                                    }
                                                }
                                                
                                            }
                                        }
                                    //}
                                }
                            }else if(fieldData.fieldAttribute == FieldAttributeBarcode){
                                if(qrFieldData.qrMetaData != nil && qrFieldData.qrMetaData.count > 0){
                                        NSArray *subviews = [self.sub_View subviews];
                                        for (UIView *newView in subviews) {
                                            if ([newView isKindOfClass:[UIButton class]]) {
                                                UIButton *butField = (UIButton *) newView;
                                                NSString *str = butField.currentTitle;
                                                NSLog(@"%@",str);
                                                NSInteger tag = newView.tag;
                                                if (tag>=400) {
                                                    
                                                    [butField setTitleColor:Blue forState:UIControlStateNormal];
                                                    
                                                    int index = (int)tag - 400;
                                                        FieldData *newFields=[self.metaDataArray objectAtIndex:(index)];
                                                        
                                                        if (qrFieldData.fieldId == newFields.fieldId){
                                                            
                                                            NSString *sstring  = qrFieldData.qrMetaData[0];
                                                            [butField setTitle:sstring forState:UIControlStateNormal];
                                                            if(newFields.fieldAttribute == FieldAttributeBarcode){
                                                                UIButton *clickedButton = (UIButton *)[butField.superview viewWithTag:tag + forcebarcodeClearTag];
                                                                clickedButton.hidden = NO;
                                                            }
                                                            if(isSelectedfieldAvailableinarray == true){
                                                                [parkload setObject:load_id forKey:@"origin_load_id"];
                                                                [parkload setObject:sid forKey:@"origin_site_id"];
                                                            }
                                                        }
                                                    }
                                            
                                                
                                            }
                                    }
                                }
                            }else if(fieldData.fieldAttribute == FieldAttributeDatePicker){
                                if(qrFieldData.qrMetaData != nil && qrFieldData.qrMetaData.count > 0){
                                        NSArray *subviews = [self.sub_View subviews];
                                        for (UIView *newView in subviews) {
                                            if ([newView isKindOfClass:[UIButton class]]) {
                                                UIButton *butField = (UIButton *) newView;
                                                NSString *str = butField.currentTitle;
                                                NSLog(@"%@",str);
                                                NSInteger tag = newView.tag;
                                                if (tag>=400) {
                                                    
                                                    [butField setTitleColor:Blue forState:UIControlStateNormal];
                                                    
                                                    int index = (int)tag - 400;
                                                        FieldData *newFields=[self.metaDataArray objectAtIndex:(index)];
                                                        
                                                        if (qrFieldData.fieldId == newFields.fieldId){
                                                            
                                                            NSString *sstring  = qrFieldData.qrMetaData[0];
                                                            [butField setTitle:sstring forState:UIControlStateNormal];
                                                            if(isSelectedfieldAvailableinarray == true){
                                                                [parkload setObject:load_id forKey:@"origin_load_id"];
                                                                [parkload setObject:sid forKey:@"origin_site_id"];
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
            
            [parkloadarray replaceObjectAtIndex:currentloadnumber withObject:parkload];
            [[NSUserDefaults standardUserDefaults] setObject:parkloadarray forKey:@"ParkLoadArray"];
//            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:qrArrFieldsData requiringSecureCoding:NO error:nil];
//            [[NSUserDefaults standardUserDefaults]setValue: data forKey:@"qrScannedMetafields"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        }@catch(NSException *ex){
            NSLog(@"aaaaa%@", ex);
        }
    }else {
        [self.view makeToast:@"Invalid" duration:2.0 position:CSToastPositionCenter];
    }
}


@end
