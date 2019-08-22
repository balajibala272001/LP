//
//  UploadViewController.m
//  sgpcapp
//
//  Created by SmartGladiator on 13/04/16.
//  Copyright © 2016 Smart Gladiator. All rights reserved.
//

#import "PictureViewController.h"

#import "PicturesCollectionViewCell.h"
#import "ProjectDetailsViewController.h"
#import "NotesViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
   //
    
//    NSUserDefaults *Notes = [NSUserDefaults standardUserDefaults];
//    // getting an NSString
//    NSString *text= [Notes stringForKey:@"notes"];
    
   
    
   // app.navigationController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add:)] autorelease];
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Next"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(next:)];
    self.navigationItem.rightBarButtonItem = NextButton;
    //[NextButton release];
    
    //[StaticHelper setLocalizedBackButtonForViewController:self];

    
    if (self.imageArray.count > 1) {
        
        self.selected_CollectionView.hidden = NO;
        self.imageViewToUpload.hidden =YES;
        
        [self.selected_CollectionView reloadData];
        
        
        
    }
    
    else{
        
        self.imageViewToUpload.hidden = NO;
        self.selected_CollectionView.hidden = YES;
        
        self.imageViewToUpload.image = [self.imageArray objectAtIndex:0];
        
        
        
    }
    
    
    
    // Do any additional setup after loading the view.
}



-(IBAction)next:(id)sender {
    
    
    ProjectDetailsViewController *ProjectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectVC"];
    //PictureVC.imageArray = self.imageArray;
    
    [self.navigationController pushViewController:ProjectVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//data source and delegates method


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageArray count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PicturesCollectionViewCell *Cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    
    NSLog(@"%@",self.imageArray);
    
    Cell1.self.imageView.image=[self.imageArray objectAtIndex:indexPath.row];
    
    Cell1.layer.borderWidth = 2.0f;
    Cell1.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    //If User tap on image
    //Tap button
//    UIButton *TapButton = [[UIButton alloc]init];
//    TapButton.frame = CGRectMake(0, 0, 96, 82);
//    
//   // [TapButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
//    [TapButton setTag:indexPath.row];
//    
//    [TapButton addTarget:self action:@selector(Tap:) forControlEvents:UIControlEventTouchUpInside];
//    [Cell1.contentView addSubview:TapButton];
//    
//    NSUserDefaults *Notes = [NSUserDefaults standardUserDefaults];
//    // getting an NSString
//    NSString *text= [Notes stringForKey:@"notes"];
//
//    if (text.length > 0) {
//        
//        UIView *lbl = [[UIView alloc]init];
//        lbl.frame = CGRectMake(0, 10, 50, 20);
//        
//        lbl.backgroundColor = [UIColor redColor];
//        [Cell1.imageView addSubview:lbl];
//        [self.selected_CollectionView reloadData];
//
//        
    
        
   // }
    
    return Cell1;
    
    
}

-(IBAction)Tap:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NotesViewController *NotesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesVC"];
    //PictureVC.imageArray = self.imageArray;
    
    [self.navigationController pushViewController:NotesVC animated:YES];
   // [self.imageArray removeObjectAtIndex:btn.tag];
   // [self.collection_View reloadData];
    
}
/*
 
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
