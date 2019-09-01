//
//  igViewController.h
//  ScanBarCodes
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol senddataProtocol <NSObject>
//-(void)sendDataToA:(NSString *) string;
//@end
@protocol ScannedDelegateIGView <NSObject>



-(void)sendStringViewController:(NSString *) string withTag :(NSInteger) tagNumber;

@end





@interface igViewController : UIViewController

@property(nonatomic,weak)id<ScannedDelegateIGView>delegate;

//@property(nonatomic,assign)id delegate;

@property (weak,nonatomic)NSString *string;

//@property (nonatomic ,assign)int btntag;

@property (nonatomic,assign) int btnTag;

@property (nonatomic,assign) NSInteger txtTag;
@property (weak, nonatomic) IBOutlet UIView *highlight_View;

- (IBAction)back_action_btn:(id)sender;





@end
