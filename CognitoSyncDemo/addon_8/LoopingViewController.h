//suganya

#import <UIKit/UIKit.h>
#import "igViewController.h"
#import "SiteData.h"
#import "SCLAlertView.h"
#import "ViewController.h"

//saving old data values of meta data

@interface LoopingViewController : UIViewController<ScannedDelegateIGView,UIImagePickerControllerDelegate,ScannedDelegateView,UITextFieldDelegate>{
igViewController *IGVC;
    
}

@property (weak, nonatomic) IBOutlet UIView *subVieww;
@property (weak, nonatomic) IBOutlet UIView *sub_Vieww;

@property (strong,nonatomic) SiteData *siteData;
@property(nonatomic,strong) SCLAlertView *alertbox ;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_Vieww;
@property (weak, nonatomic) IBOutlet UILabel *topLbl;

@property (nonatomic,assign) int senderTag;
@property (nonatomic,assign) int sub_View_Height;
@property (nonatomic,assign) int fieldId;
@property (nonatomic,assign) int c_fieldId;

@property (weak,nonatomic) NSString *sitename;
@property (weak,nonatomic) NSString *image_quality;

@property (nonatomic,strong) NSMutableArray *arrayOfImagesWithNotes;
@property (nonatomic,strong) NSMutableArray *oldValuesReturn;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSMutableArray *metaDataArray;
@property (nonatomic,strong) NSMutableArray *sitesNameArr;

@property  BOOL isEdit;
@property  BOOL isRadio;
@property NSDictionary *oldDict;

@property (nonatomic,strong) UIButton *yourButton;
@property (nonatomic,strong) UIButton *checkBoxButton;


//Addon8
@property (nonatomic,assign) int tappi_count;
@property (nonatomic,assign) int currentTappiCount;
@property (nonatomic,assign) int instruction_number;
@property (nonatomic, strong) NSMutableArray *loopImagearray;

@end
