//
//  ProjectDetailsViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 8/17/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "ProjectDetailsViewController.h"
#import "UserCategoryViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "StaticHelper.h"
#import "UIView+Toast.h"
#import "AZCAppDelegate.h"
@interface ProjectDetailsViewController ()<UITextFieldDelegate>

@end

@implementation ProjectDetailsViewController


{
    NSMutableArray *savingArray;
    
}

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    savingArray = [[NSMutableArray alloc]init];
    self.arr = [[NSMutableArray alloc]init];


    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshing:) name:@"refreshing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];


    
    [self createMetaData];
    
    
    
   
    
    self.navigationItem.title = @"Data Fields";

    [StaticHelper setLocalizedBackButtonForViewController:self];

 
    //NSLog(@" the code is :%@",self.text);
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Next "
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(next:)];
    self.navigationItem.rightBarButtonItem = NextButton;

    self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];

   

    // Do any additional setup after loading the view.
    
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)refreshing:(NSNotification *)notification
{
     [self createMetaData2];
}



//****************************************************
#pragma mark - Private Methods
//****************************************************

-(void)createMetaData2
{
    
    
    NSArray *subviews = [self.sub_View subviews];
    for (UIView *newView in subviews) {
        if([newView isKindOfClass:[UITextField class]]||[newView isKindOfClass:[UIButton class]])
        {
            
            UITextField *textField = (UITextField *) newView;
            [textField removeFromSuperview];
            
            UIButton *button = (UIButton *) newView;
            [button removeFromSuperview];
            
            
        }
        
    }
    
    
    AZCAppDelegate *delegate = (AZCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSMutableArray *array = delegate.userProfiels.arrSites;
   
    
    
       SiteData *sites = [array objectAtIndex:0];
         self.metaDataArray = sites.arrFieldData;
    
   
    
    
    int verticalPadding = 20;
    int horizontalPadding  = 20;
    int heightOfBtn = 44;
    int widthOfBtn = 120;
    int xPosOfBtn = 20;
    int y =verticalPadding;
    int yPosOfBtn;
    
    
    
    
    //text field Values
    int heightOfTxt = 44;
    int xPosOfTxt =horizontalPadding + widthOfBtn +horizontalPadding;
    int widthOfTxt= self.sub_View.frame.size.width-(xPosOfTxt+horizontalPadding);
    
    
    yPosOfBtn = verticalPadding;
    
    int btnTagBaseValue = 200;
    int txtTagBaseVaue = 100;
     int basecheckboxTag = 300;
    //iterating the fieldata array
    for (int i =0; i<self.metaDataArray.count; i++) {
        int yPosOfTxt = yPosOfBtn;
        FieldData *fieldData = self.metaDataArray [i];
        BOOL display = fieldData.shouldDisplay;
        BOOL active = fieldData.shouldActive;
        
        BOOL Mandatary = fieldData.isMandatory;
        
        //check field should display or not
        //if display create the button
        if (active == YES) {
            
            //Creating Button
            UIButton *metaData_btn = [[UIButton alloc]init];
            metaData_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn , widthOfBtn,heightOfBtn);
            yPosOfBtn =yPosOfBtn + (verticalPadding +heightOfBtn);
            [metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];

            metaData_btn.backgroundColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0] ;
            

            
            metaData_btn.tag = (btnTagBaseValue + i );
            
            //NSLog(@"%ld",(long)metaData_btn.tag);
            
            
            FieldData *fieldData = self.metaDataArray [i];
            NSLog(@"metaDataArray:%@",self.metaDataArray);
            
            NSString *Label = fieldData.strFieldLabel;
            [metaData_btn setTitle:Label forState:UIControlStateNormal];
            
            metaData_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            
            
            
            
            metaData_btn.layer.cornerRadius = 5;
            
            metaData_btn.titleLabel.numberOfLines = 2;
            
            
            [self.sub_View addSubview:metaData_btn];
            
            //Creating TextField
            UITextField *metaData_txt = [[UITextField alloc]init];
            metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
            metaData_txt.layer.cornerRadius = 5;
            metaData_txt.layer.borderWidth =1.0;
            metaData_txt.layer.borderColor = [UIColor blackColor].CGColor;
           // metaData_txt.textColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
             metaData_txt.textColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
            [metaData_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            
            metaData_txt.tag = (txtTagBaseVaue +i);
            
            if (fieldData.fieldAttribute == FieldAttributeNumeric) {
                
                metaData_txt.keyboardType = UIKeyboardTypeNumberPad;
                
            }
            
            
            [metaData_txt setDelegate:self];
            metaData_txt.textAlignment =  NSTextAlignmentCenter;
            
            
            [self.sub_View addSubview:metaData_txt];
            [self textFieldShouldReturn:metaData_txt];
            
            
            
        }
        
        
    }
    
    self.sub_View_Height = yPosOfBtn+heightOfBtn+verticalPadding;
    CGRect newFrame = CGRectMake( 0, 0, 320, self.sub_View_Height);
    self.sub_View.frame = newFrame;
    
    [self.scroll_View setContentSize:CGSizeMake(self.view.frame.size.width, self.sub_View.frame.size.height)];
    
    
    
    self.scroll_View.delegate = self;
    
    
    
    
    
}

//new editing
-(void)createMetaData
{
    
    SiteData *sites = self.siteData;
    self.metaDataArray = sites.arrFieldData;
    //button
    int verticalPadding = 20;
    int horizontalPadding  = 20;
    int heightOfBtn = 44;
    int widthOfBtn = 120;
    int xPosOfBtn = 20;
    int y =verticalPadding;
    int yPosOfBtn;
    //text field Values
    int heightOfTxt = 44;
    int xPosOfTxt =horizontalPadding + widthOfBtn +horizontalPadding;
    int widthOfTxt= self.sub_View.frame.size.width-(xPosOfTxt+horizontalPadding);
    
    yPosOfBtn = verticalPadding;
    
    int btnTagBaseValue = 200;
    int txtTagBaseVaue = 100;
    
    int basecheckboxTag = 300;
    
    int baseradioTag = 300;
    
    int radioViewheight ;
    int checkBoxViewheight;
    //iterating the fieldata array
    for (int i =0;i<self.metaDataArray.count; i++) {
        int radioButton_y = 5;
        int radioVutton_Vertical_Padding = 10;
        
        int checkboxButton_y = 5;
        int checkbox_Vertical_padding = 5;

        int yPosOfTxt = yPosOfBtn;
        FieldData *fieldData = self.metaDataArray [i];
        
        BOOL display = fieldData.shouldDisplay;
        BOOL active = fieldData.shouldActive;
        
        BOOL Mandatary = fieldData.isMandatory;
        
        //check field should display or not
        //if display create the button
        if (active == YES) {
            
            //Creating Button
            
            UIButton *metaData_btn = [[UIButton alloc]init];
            
            metaData_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn, widthOfBtn,heightOfBtn);
            
            
            yPosOfBtn =yPosOfBtn + (verticalPadding +heightOfBtn+20);
            if((fieldData.fieldAttribute == FieldAttributeRadio)|| (fieldData.fieldAttribute == FieldAttributeCheckbox))
            {
                 //[metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                 [metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
            }
           
            
            metaData_btn.backgroundColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0] ;
            
            
            
            metaData_btn.tag = (btnTagBaseValue + i );
            
            
            NSLog(@"metaDataArray:%@",self.metaDataArray);
            
            FieldData *fieldData =self.metaDataArray [i];
            
            
            NSString *Label = fieldData.strFieldLabel;
            
            [metaData_btn setTitle:Label forState:UIControlStateNormal];
            
            metaData_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            
            metaData_btn.layer.cornerRadius = 5;
            
            metaData_btn.titleLabel.numberOfLines = 2;
            
            [self.sub_View addSubview:metaData_btn];
            if (fieldData.fieldAttribute == FieldAttributeNumeric || fieldData.fieldAttribute == FieldAttributeAlpha || fieldData.fieldAttribute == FieldAttributeAlphaNumeric) {
                //Creating TextField
                UITextField *metaData_txt = [[UITextField alloc]init];
                metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                metaData_txt.layer.cornerRadius = 5;
                metaData_txt.layer.borderWidth =1.0;
                metaData_txt.layer.borderColor = [UIColor blackColor].CGColor;
                metaData_txt.textColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
                [metaData_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                
                
                NSLog(@"x:%f",metaData_txt.frame.origin.x);
                NSLog(@"y:%f",metaData_txt.frame.origin.y);
                NSLog(@"w:%f",metaData_txt.frame.size.width);
                NSLog(@"h:%f",metaData_txt.frame.size.height);
                
                
                metaData_txt.tag = (txtTagBaseVaue +i);
                
                NSLog(@"metaData_txt:%ld",(long)metaData_txt.tag);
                
                if (fieldData.fieldAttribute == FieldAttributeNumeric) {
                    
                    metaData_txt.keyboardType = UIKeyboardTypeNumberPad;
                    
                }
                
                
                [metaData_txt setDelegate:self];
                metaData_txt.textAlignment =  NSTextAlignmentCenter;
                
                
                [self.sub_View addSubview:metaData_txt];
                [self textFieldShouldReturn:metaData_txt];
                if (self.wholeDictionary.count >0)
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
              
                
                radioViewheight = heightOfTxt *count;
            
                  RadioView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt, radioViewheight);
                //new code
                yPosOfBtn = yPosOfBtn +radioViewheight-50;
                //new code
                
               // yPosOfBtn = yPosOfBtn+30;
                
//                RadioView.layer.cornerRadius = 5;
//                RadioView.layer.borderWidth = 1.0;
//                RadioView.layer.borderColor = [UIColor blackColor].CGColor;
                RadioView.tag = (txtTagBaseVaue +i);
                
                [self.sub_View addSubview:RadioView];
                
                
                
                int radio_y=5;
                //int radio_w=widthOfTxt;
                //int radio_h= 10;
                
                int radiobox_y =yPosOfTxt;
                
                for (int f = 0;f<self.arr.count; f++) {
                    
                    UILabel *lbl = [[UILabel alloc]init];
                   lbl.frame = CGRectMake(37,radioButton_y, 100, 20);
                    //  lbl.frame = CGRectMake(40, radiobox_y, 100, 20);
                    
                    lbl.text = self.arr[f];
                    lbl.textColor = [UIColor blackColor];
                      [lbl setFont: [lbl.font fontWithSize: 14]];
                    [lbl setTag:baseradioTag+f];
                    [RadioView addSubview:lbl];
                    
                    self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(0,radioButton_y-10, 40, 40)];
                    radioButton_y = radioButton_y+(radioVutton_Vertical_Padding+40);
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
                    if (self.wholeDictionary.count >0)
                    {
                        [self DisplayOldValues];
                    }
                    else if (self.oldValuesReturn.count) {
                        [self DislpayPreviousValues];
                        
                    }

                    
                    
                }
            }
            else if (fieldData.fieldAttribute == FieldAttributeCheckbox)
            {
                NSLog(@"checkbox");
                self.arr= fieldData.fieldOptions;
                UIView *CheckboxView = [[UIView alloc]init];
                int count = self.arr.count;
                 checkBoxViewheight = heightOfTxt *count;
                CheckboxView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt,checkBoxViewheight );
                 yPosOfBtn = yPosOfBtn+checkBoxViewheight-50;
                //editing
//                                CheckboxView.layer.cornerRadius = 5;
//                                CheckboxView.layer.borderWidth = 1.0;
//                                CheckboxView.layer.borderColor = [UIColor blackColor].CGColor;
                CheckboxView.tag = (txtTagBaseVaue +i);
                [self.sub_View addSubview:CheckboxView];
                
                int checkbox_y=yPosOfTxt;
                for (int f = 0; f<self.arr.count; f++) {
                    
                    UILabel *lbl = [[UILabel alloc]init];
                   lbl.frame = CGRectMake(37,checkboxButton_y,200,20);
                    lbl.text = self.arr[f];
                    //[[lbl] setFont:[UIFont systemFontOfSize:20]];
                [lbl setFont: [lbl.font fontWithSize: 14]];
                  //  label.font = [UIFont fontWithName:gMainFont size:label.height];
                   // lbl.minimumScaleFactor = 0.1;
//                    lbl.numberOfLines = 1;
//                    lbl.minimumFontSize = 8;
//                    lbl.adjustsFontSizeToFitWidth = YES;
                    lbl.textColor = [UIColor blackColor];
                    [lbl setTag:basecheckboxTag+f];
                    [CheckboxView addSubview:lbl];

                    
                    self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(0,checkboxButton_y,25,20)];
                    
                    checkboxButton_y = checkboxButton_y+(checkbox_Vertical_padding+40);
                    [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"uncheckclicked.png"] forState:UIControlStateNormal];
                    [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkclick.png"] forState:UIControlStateSelected];
                    [self.checkBoxButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [self.checkBoxButton setTag:basecheckboxTag+f];
                    
                    [CheckboxView addSubview:self.checkBoxButton];
                 
                    if (self.wholeDictionary.count >0)
                    {
                        [self DisplayOldValues];
                    }
                    else if (self.oldValuesReturn.count) {
                        [self DislpayPreviousValues];
                        
                    }

                    
                }
                
                
            }
            
        }
        
        
        
    }
    
    self.sub_View_Height = yPosOfBtn+heightOfBtn+verticalPadding;

    CGRect newFrame = CGRectMake( 0, 0, 320, self.sub_View_Height);
    self.sub_View.frame = newFrame;
    
    [self.scroll_View setContentSize:CGSizeMake(self.view.frame.size.width, self.sub_View.frame.size.height)];
    
    
    self.scroll_View.delegate = self;
    
    
}



//new editing



/*-(void)createMetaData
{
 
    SiteData *sites = self.siteData;
    self.metaDataArray = sites.arrFieldData;
    //button
    int verticalPadding = 20;
    int horizontalPadding  = 20;
    int heightOfBtn = 44;
    int widthOfBtn = 120;
    int xPosOfBtn = 20;
    int y =verticalPadding;
    int yPosOfBtn;
    //text field Values
    int heightOfTxt = 44;
    int xPosOfTxt =horizontalPadding + widthOfBtn +horizontalPadding;
    int widthOfTxt= self.sub_View.frame.size.width-(xPosOfTxt+horizontalPadding);
    
   yPosOfBtn = verticalPadding;
    
       int btnTagBaseValue = 200;
       int txtTagBaseVaue = 100;
    
       int basecheckboxTag = 300;
    
        int baseradioTag = 300;

    
    //checkbox button value
    int checkBox_y = 5;
    int radioBox_y =5;
    
    int checkBoxButton_x= 5;
    int checkBoxButton_y = 5;
    int checkBoxButton_width =25;
    int checkBoxButton_height =20;
    int checkBoxLabel_x = 30;
    
    int radioButton_x= 5;
    int radioButton_y = 5;
    int radioButton_width = 25;
    int radioButton_height = 20;
    int radioBoxLabel_x =30;

    //iterating the fieldata array
    for (int i =0;i<self.metaDataArray.count; i++) {
        int yPosOfTxt = yPosOfBtn;
        FieldData *fieldData = self.metaDataArray [i];
        
        BOOL display = fieldData.shouldDisplay;
        BOOL active = fieldData.shouldActive;
        
        BOOL Mandatary = fieldData.isMandatory;
        
        //check field should display or not
        //if display create the button
        if (active == YES) {
            
            //Creating Button
            
             UIButton *metaData_btn = [[UIButton alloc]init];
            
            metaData_btn.frame = CGRectMake(xPosOfBtn,yPosOfBtn, widthOfBtn,heightOfBtn);
           

           yPosOfBtn =yPosOfBtn + (verticalPadding +heightOfBtn+20);
            [metaData_btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
         
            metaData_btn.backgroundColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0] ;
            
         
            
            metaData_btn.tag = (btnTagBaseValue + i );

            
            NSLog(@"metaDataArray:%@",self.metaDataArray);
            
            FieldData *fieldData =self.metaDataArray [i];
            
          
            NSString *Label = fieldData.strFieldLabel;
   
            [metaData_btn setTitle:Label forState:UIControlStateNormal];
        
            metaData_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            
            metaData_btn.layer.cornerRadius = 5;
            
            metaData_btn.titleLabel.numberOfLines = 2;
            
            [self.sub_View addSubview:metaData_btn];
            if (fieldData.fieldAttribute == FieldAttributeNumeric || fieldData.fieldAttribute == FieldAttributeAlpha || fieldData.fieldAttribute == FieldAttributeAlphaNumeric) {
                //Creating TextField
                UITextField *metaData_txt = [[UITextField alloc]init];
                metaData_txt.frame = CGRectMake(xPosOfTxt,yPosOfTxt , widthOfTxt, heightOfTxt);
                metaData_txt.layer.cornerRadius = 5;
                metaData_txt.layer.borderWidth =1.0;
                metaData_txt.layer.borderColor = [UIColor blackColor].CGColor;
                metaData_txt.textColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:180.0/255.0 alpha:1.0];
                [metaData_txt setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                
                
                NSLog(@"x:%f",metaData_txt.frame.origin.x);
                NSLog(@"y:%f",metaData_txt.frame.origin.y);
                NSLog(@"w:%f",metaData_txt.frame.size.width);
                NSLog(@"h:%f",metaData_txt.frame.size.height);
                
                
                metaData_txt.tag = (txtTagBaseVaue +i);
                
                NSLog(@"metaData_txt:%ld",(long)metaData_txt.tag);
                
                if (fieldData.fieldAttribute == FieldAttributeNumeric) {
                    
                    metaData_txt.keyboardType = UIKeyboardTypeNumberPad;
                    
                }
                
                
                [metaData_txt setDelegate:self];
                metaData_txt.textAlignment =  NSTextAlignmentCenter;
                
                
                [self.sub_View addSubview:metaData_txt];
                [self textFieldShouldReturn:metaData_txt];
                if (self.wholeDictionary.count >0)
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
           int  count =(int)self.arr.count;
                
        RadioView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt, heightOfTxt +(count *25));
//                RadioView.layer.cornerRadius = 5;
//                RadioView.layer.borderWidth = 1.0;
//                RadioView.layer.borderColor = [UIColor blackColor].CGColor;
        RadioView.tag = (txtTagBaseVaue +i);
                
        [self.sub_View addSubview:RadioView];
                
                
            
              //  int radio_x = xPosOfBtn +150;
                int radio_y=5;
                //int radio_w=widthOfTxt;
                //int radio_h= 10;
                
                    int radiobox_y =yPosOfTxt;
                
             for (int f = 0;f<self.arr.count; f++) {
                
                 UILabel *lbl = [[UILabel alloc]init];
                lbl.frame = CGRectMake(40,radioButton_y+15, 100, 20);
               //  lbl.frame = CGRectMake(40, radiobox_y, 100, 20);
                 
                 lbl.text = self.arr[f];
                 lbl.textColor = [UIColor blackColor];
                 [RadioView addSubview:lbl];

                 self.yourButton = [[UIButton alloc] initWithFrame:CGRectMake(0,radioButton_y+5, 40, 40)];
                 [self.yourButton setImage: [UIImage imageNamed:@"radioChecked.png"]forState:UIControlStateSelected];
                 [self.yourButton setImage: [UIImage imageNamed:@"radioUnchecked.png"]forState: UIControlStateNormal];
                 self.yourButton.selected = NO;
                 
                [self.yourButton addTarget:self action:@selector(radioSelected:) forControlEvents:UIControlEventTouchUpInside];
                [self.yourButton setTag:baseradioTag+f];
                NSLog(@"%ld",(long)self.yourButton.tag);
                [RadioView addSubview:self.yourButton];
//                radio_y = radio_y +(verticalPadding+5);
//                 yPosOfBtn =radiobox_y+15;
               radioButton_y =radioButton_y+20;
                 
                 radio_y = radio_y +(verticalPadding+20);
             

                
            }
                }
       else if (fieldData.fieldAttribute == FieldAttributeCheckbox)
            {
                NSLog(@"checkbox");
                self.arr= fieldData.fieldOptions;
                UIView *CheckboxView = [[UIView alloc]init];
                int count = self.arr.count;
               CheckboxView.frame = CGRectMake(xPosOfTxt,yPosOfTxt,widthOfTxt,count * 25 );
                //editing
//                CheckboxView.layer.cornerRadius = 5;
//                CheckboxView.layer.borderWidth = 1.0;
//                CheckboxView.layer.borderColor = [UIColor blackColor].CGColor;
                CheckboxView.tag = (txtTagBaseVaue +i);
                [self.sub_View addSubview:CheckboxView];
                
                int checkbox_y=yPosOfTxt;
                for (int f = 0; f<self.arr.count; f++) {
                    
                    UILabel *lbl = [[UILabel alloc]init];
                    lbl.frame = CGRectMake(40,checkBoxButton_y+10,100,20);
                    lbl.text = self.arr[f];
                    lbl.textColor = [UIColor blackColor];
                    [CheckboxView addSubview:lbl];
                    
                   self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(5,checkBoxButton_y+10,25,20)];
                  [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"uncheckclicked.png"] forState:UIControlStateNormal];
                  [self.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkclick.png"] forState:UIControlStateSelected];
                  [self.checkBoxButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
                  [self.checkBoxButton setTag:basecheckboxTag+f];

                  [CheckboxView addSubview:self.checkBoxButton];
                  checkbox_y =checkbox_y + (verticalPadding + 10);
                  yPosOfBtn = checkbox_y;
                    
                    checkBox_y = checkBox_y+50;
                    
                    checkBoxButton_y = checkBoxButton_y+25;
                    
                    //second
//                    checkbox_y =checkbox_y + (verticalPadding + 20);
//                    
//                    
//                    yPosOfBtn = checkbox_y+20;
//                    
//                    checkBox_y = checkBox_y+50;
                    
                    
                }

                
            }
            
        }
        
        

    }
    
  self.sub_View_Height = yPosOfBtn+heightOfBtn+verticalPadding+checkBoxButton_y;
    CGRect newFrame = CGRectMake( 0, 0, 320, self.sub_View_Height);
    self.sub_View.frame = newFrame;
    
    [self.scroll_View setContentSize:CGSizeMake(self.view.frame.size.width, self.sub_View.frame.size.height)];
    
    
    self.scroll_View.delegate = self;
    
    
}*/

-(void)checkboxSelected:(UIButton*)sender  {
    sender.selected = !sender.selected;
   
}



    

-(void)radioSelected:(UIButton*)sender {
    
    
    
    UIButton *currentButton = (UIButton *)sender;
    for(UIView *view in self.sub_View.subviews){
        
        if([view isKindOfClass:[UIButton class]]){
            
                    }
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


-(void)DislpayPreviousValues
{
    NSArray *subviews = [self.sub_View subviews];
    
    for (UIView *newView in subviews) {
        
        if ([newView isKindOfClass:[UITextField class]]) {
            
            
            UITextField *textField = (UITextField *) newView;
            NSInteger tag = newView.tag;
            int index = (int)tag -100;
            NSLog(@" index:%d",index);
            NSDictionary *field = [[NSDictionary alloc]init];
            NSString *sstring  =[self.oldValuesReturn objectAtIndex:index];
            [textField setText:sstring];
            
            
    }
    }

}

-(void)DisplayOldValues
{
    NSArray *subviews = [self.sub_View subviews];
    
    NSString *stored_lbl ;
    int buttonIndex = 500;
    BOOL isTheObjectThere;

    for (UIView *newView in subviews) {
        
        if ([newView isKindOfClass:[UITextField class]]) {
            
            
            UITextField *textField = (UITextField *) newView;
            NSString *str = textField.text;
            
            NSLog(@"%@",str);
            
            
            
            NSInteger tag = newView.tag;
            
            int index = (int)tag - 100;
          //  NSLog(@" index:%d",index);
            
        NSMutableArray *OldLoadFieldsfields = [[NSMutableArray alloc]init];

          
            
            OldLoadFieldsfields = [self.wholeDictionary objectForKey:@"fields"];
            
            NSDictionary *field = [[NSDictionary alloc]init];
            
            
            field = [OldLoadFieldsfields objectAtIndex:index];
            
            NSString *sstring  =[field objectForKey:@"field_value"];
            
            
            
            [textField setText:sstring];
            

            
        }
        
        else if ([newView  isKindOfClass:[UIButton class]])
        {
            
            
            NSLog(@"button");
        }
        
        //    check view is  a view or not
        else if ([newView  isKindOfClass:[UIView class]])
        {

            int tag = newView.tag;
            int index;
        
            index = (int)tag - 100;
            NSLog(@"UIVIEW");
            NSMutableArray *OldLoadFieldsfields = [[NSMutableArray alloc]init];
            
            OldLoadFieldsfields = [self.wholeDictionary objectForKey:@"fields"];
            
            NSDictionary *field = [[NSDictionary alloc]init];
            field = [OldLoadFieldsfields objectAtIndex:index];
            NSMutableArray *storedValue = [[NSMutableArray alloc]init];
            storedValue =[field objectForKey:@"field_value"];
             NSArray *buttonViews = [newView subviews];
            for (UIView *buttonView in buttonViews) {
                
                if ([buttonView isKindOfClass:[UILabel class]]) {
                    int tag = buttonView.tag;
                    tag = tag - 300;
                   // buttonIndex = tag;
                    
                    UILabel *label = (UILabel *) buttonView;
                    stored_lbl   =label.text;
                    isTheObjectThere = [storedValue containsObject:stored_lbl];
                    if (isTheObjectThere) {
                        buttonIndex = tag;

                        NSLog(@"Yes Object there ");
                       // int iindexOfButton =
                        
                    }
                
                
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


//****************************************************
#pragma mark - Text Field Delegate Methods
//****************************************************

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}

//****************************************************
#pragma mark - Other methods  Methods
//****************************************************




//****************************************************
#pragma mark - IBAction Methods
//****************************************************


-(IBAction)next:(id)sender {
    NSArray *subviews = [self.sub_View subviews];
    
    NSMutableArray *arrFieldValues = [NSMutableArray array];
        BOOL isSucceeded = YES;
      BOOL ischeckBox = YES;

    for (UIView *newView in subviews) {
        if([newView isKindOfClass:[UITextField class]])
        {
            //if sub-view is a textfield
            int tag = newView.tag;
            int index;
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
            UITextField *textField = (UITextField *) newView;
            NSString *inputString = textField.text;
            if (mandatary == YES) {
                
                if (inputString.length == 0) {
                    
                    NSString *msg = [NSString stringWithFormat:@" Enter %@",label];
                    
                     [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
                    isSucceeded = NO;
                    
                    break;
                    NSLog(@"enter characters");
                    
                }
                
                }
            
            
                       if (inputString.length > 0)
                {
                   
                    
                if (fieldData.fieldAttribute == FieldAttributeNumeric) {
                    
                    
                    BOOL matches = [self isNumeric:inputString];
                    if (!matches) {
                        
                        NSString *msg = [NSString stringWithFormat:@"Enter Numeric Characters in %@",label];
                        
                        [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
                        
                        isSucceeded = NO;
                        
                        
                        break;
                        
                        
                    }
                    
                    
                
                    
                }
                    else if (fieldData.fieldAttribute == FieldAttributeAlpha)
                    {
                        
                        
                        

                    }
                    else if (fieldData.fieldAttribute == FieldAttributeAlphaNumeric)
                    {
                        
  
                    }
                    
            if (inputString.length > length) {
                        
                        NSString *msg = [NSString stringWithFormat:@" Enter %d Characters in %@",length,label];
                        
                        [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
                        isSucceeded = NO;
                        break;}
                }
                
        if (isSucceeded) {
                
                NSMutableDictionary *dictFieldValue = [NSMutableDictionary dictionary];
                
                
                
                [dictFieldValue setObject:@(fieldData.fieldId) forKey:@"field_id"];
                [dictFieldValue setObject:inputString forKey:@"field_value"];
                
                [arrFieldValues addObject:dictFieldValue];
                           }


            }
     
        else if ([newView  isKindOfClass:[UIButton class]])
        {
            
            
            NSLog(@"button");
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
           
//           NSMutableArray *SelectedArray = [[NSMutableArray alloc]init];
           
           
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
           
           
           
}}
                      }
           
        if (checkbox_radio_group.count > 0) {
                           if (SelectedArray.count > 0) {
        
            }
           
                           else
                           {
                                BOOL mandatary = fieldData.isMandatory;
                               
                               NSString  *str2 =fieldData.strFieldLabel;
                               
                               NSLog(@"checkbox_str2:%@",str2);
                               if (mandatary == YES) {
                                   NSString *msg1 = [NSString stringWithFormat:@" Enter %@",str2];
                                   [self.view makeToast:msg1 duration:1.0 position:CSToastPositionCenter];
                                   isSucceeded = NO;
                                   break;
                               }
                              
                           }
           
                       }

//new working
      [dictFieldValue setObject:@(fieldData.fieldId) forKey:@"field_id"];
       [dictFieldValue setObject:fieldSelectedOptions forKey:@"field_value"];
       [arrFieldValues addObject:dictFieldValue];
       NSLog(@"arrFieldValues:%@",arrFieldValues);
    }}
       
    
    if (isSucceeded) {
        ///Create the dictionary for one image upload
        
        NSMutableDictionary *dictMetaData = [NSMutableDictionary dictionary];
        AZCAppDelegate *appDelegate = [AZCAppDelegate sharedInstance];
        [dictMetaData setObject:@(appDelegate.userProfiels.cId) forKey:@"c_id"];
        [dictMetaData setObject:@(self.siteData.networkId) forKey:@"n_id"];
        [dictMetaData setObject:@(self.siteData.siteId) forKey:@"s_id"];
        
        [dictMetaData setObject:@(appDelegate.userProfiels.userId) forKey:@"u_id"];
        
        [dictMetaData setObject:arrFieldValues forKey:@"fields"];
        
       
        
        UserCategoryViewController *UserCategoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserCategoryVC"];
        
        UserCategoryVC.arrayOfImagesWithNotes = self.arrayOfImagesWithNotes
        ;
        UserCategoryVC.dictMetaData = dictMetaData;
        UserCategoryVC.oldDict = self.oldDict;
        UserCategoryVC.sitename = self.sitename;
        UserCategoryVC.isEdit = self.isEdit;
        NSLog(@"wholeDictionary:%@",self.wholeDictionary);
        
        UserCategoryVC.wholeDictionar =self.wholeDictionary;
        
        [self.navigationController pushViewController:UserCategoryVC animated:YES];
    }}

-(BOOL)isNumeric:(NSString *)strtext
{
    NSString *numericValidationRegex = @"[0-9]*";
    NSPredicate *numericPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numericValidationRegex];
    BOOL isValidNumber = [numericPredicate evaluateWithObject:strtext];
    return isValidNumber;
    
}
-(BOOL)isAlpha:(NSString *)strtext
{
    NSString *numericValidationRegex = @"^(?!.*(.)\\1{3})((?=.*[\\d])(?=.*[A-Za-z])|(?=.*[^\\w\\d\\s])(?=.*[A-Za-z])).{8,20}$";
   // NSString *numericValidationRegex = @"[a-z,A-Z,' ']*";
    NSPredicate *numericPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numericValidationRegex];
    BOOL isValidNumber = [numericPredicate evaluateWithObject:strtext];
    return isValidNumber;
    
}

-(BOOL)isAlphaNumeric:(NSString *)strtext
{

    
//NSString *numericValidationRegex = @"[a-z][A-Z][0-9][!~`@#$%^&*-+();:={}[],.<>?\\/\"\']";    //NSString *numericValidationRegex = @"^(?!.*(.)\\1{3})((?=.*[\\d])(?=.*[A-Za-z])|(?=.*[^\\w\\d\\s])(?=.*[A-Za-z])).{8,20}$";
    
    
    NSString *numericValidationRegex = @"[a-z][A-Z][0-9]*[@#]";
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
    

          UITextField *textField = (UITextField *)[self.view viewWithTag:tagNumber];
    
        textField.text = string;
        
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation



-(void) scan:(UIButton *)sender
{
    igViewController *IGVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IGVC"];
    
  
    
    
    IGVC.btnTag = (int)sender.tag;
   
    IGVC.txtTag = sender.tag -100;
    
  
    [IGVC setDelegate:self];
    
    [self.navigationController pushViewController:IGVC animated:YES];
    

}






- (IBAction)back_btn_action:(id)sender {
    
    //set delegate self in previous controller
   
//    NSArray *subviews = [self.sub_View subviews];
//    
//     for (UIView *newView in subviews) {
//        
//        if ([newView isKindOfClass:[UITextField class]]) {
//            UITextField *textField = (UITextField *) newView;
//            NSString *str = textField.text;
//            NSInteger tag = newView.tag;
//            int index = (int)tag -100;
//            FieldData *fieldData =[self.metaDataArray objectAtIndex:index];
//            //NSString *str = fieldData.strFieldLabel;
//            [savingArray addObject:str];
//            }
//       else if ([newView isKindOfClass:[UIButton class]])
//           
//       {
//           
//       }
//         
//        else if ([newView isKindOfClass:[UIView class]])
//            
//        {
//          
//            NSArray *subviews = [newView subviews];
//            for (UIView *checkboxView in subviews) {
//                
//                int tag = checkboxView.tag;
//                
//                if ([checkboxView isKindOfClass:[UIButton class]]) {
//                 
//                    
//                    
//                    
//                }
//                
//            }
//            
//        }
//
//        
//    }
    
    
   // [_delegate sendDataToPictureConfirmation:savingArray];

    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
}

//                     

@end
