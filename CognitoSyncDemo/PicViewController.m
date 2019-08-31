//
//  PicViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/14/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "PicViewController.h"
#import "NotesViewController.h"
#import "PicturesCollectionViewCell.h"
#import "ProjectDetailsViewController.h"
#import "StaticHelper.h"
#import "SingletonImage.h"

@interface PicViewController ()

@end

@implementation PicViewController
@synthesize pathToImageFolder;

//****************************************************
#pragma mark - Life Cycle Methods
//****************************************************
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"wholeDict:%@",_wholeLoadDict);
    self.oldValues = [[NSMutableArray alloc]init];
    
    //Intializing array and Dictionary
    self.oneImageDict = [[NSMutableDictionary alloc]init];
    
    //Navigation Title
    self.navigationItem.title = @"Picture Confirmation";
    //Makiking Cornerner Radius for sub-view
    self.sub_View.layer.cornerRadius = 10;
    self.sub_View.layer.borderWidth =1;
    self.sub_View.layer.borderColor = [UIColor colorWithRed:27/255.0 green:165/255.0 blue:180/255.0 alpha:1.0].CGColor;
    //For back button
    [StaticHelper setLocalizedBackButtonForViewController:self];
    //Navigation controller next button
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *NextButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Next"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(next:) ];
    self.navigationItem.rightBarButtonItem = NextButton;
    self.navigationItem.rightBarButtonItem.tintColor =[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0];
    
    //    [self.navigationController.navigationBar setTitleTextAttributes:
    //     @{NSForegroundColorAttributeName:[UIColor colorWithRed:27/255.00 green:165/255.0 blue:180/255.0 alpha:1.0]}];
    //
    
    //checking array count, if it is >1 show the images in collection view else one image
    if (self.imageArray.count > 1) {
        self.selected_CollectionView.hidden = NO;
        self.imageViewToUpload.hidden =YES;
        [self.selected_CollectionView reloadData];
    }
    else{
        self.imageViewToUpload.hidden = NO;
        self.selected_CollectionView.hidden = YES;
        self.oneImageDict = [self.imageArray objectAtIndex:0];
        NSString* imageName = [self.oneImageDict valueForKey:@"imageName"];
        
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];
        self.imageViewToUpload.image = image;
        NSDictionary *dict= [self.imageArray objectAtIndex:0];
        NSString *text = [dict objectForKey:@"string"];
        if (text.length > 0) {
            self.notes_image_view.image = [UIImage imageNamed:@"sticky.png"];
        }
        else
        {
            self.notes_image_view.image = nil;
        }
    }// Do any additional setup after loading the vi
}


- (void)didReceiveMemoryWarning {
    [[SingletonImage singletonImage]nilTheDictionary];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//****************************************************
#pragma mark - Collection View Delegate  Methods
//****************************************************
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.imageArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NotesViewController *NotesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesVC"];
    
    NSMutableDictionary *dict= [self.imageArray objectAtIndex:indexPath.row];
    NotesVC.self.dictionaries = dict;
    NotesVC.delegate = self;
    [self.navigationController pushViewController:NotesVC animated:YES];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PicturesCollectionViewCell *Cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    
    //Printing the array  of dictionaries
    NSLog(@" the array has:%@",self.imageArray);
    
    //Getting the dictionary from the array of dictionaries
    NSDictionary *dict= [self.imageArray objectAtIndex:indexPath.row];
    
    //printing the taken dictionary
    NSLog(@"%@",dict);
    
    //reading the image and text from the dictionary
    NSString* imageName = [dict valueForKey:@"imageName"];
    
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[pathToImageFolder stringByAppendingPathComponent:imageName]]];

    
    //Assigning the taken image from the dictionary
    Cell1.imageView.image = image;
    NSString *text = [dict objectForKey:@"string"];
    NSString *the_index_path = [NSString stringWithFormat:@"%li", (long)indexPath.row+1];
    Cell1.number_lbl.text = the_index_path;

    if (text.length == 0) {
        Cell1.notesImageView.image = nil;
    }
    else{
        Cell1.notesImageView.image =[UIImage imageNamed:@"sticky.png"];
    }
    return Cell1;
}
//****************************************************
#pragma mark - IBAction Methods
//****************************************************

-(IBAction)next:(id)sender {
    ProjectDetailsViewController *ProjectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectVC"];
    ProjectVC.siteData = self.siteData;
    ProjectVC.arrayOfImagesWithNotes = self.imageArray;
    ProjectVC.sitename = self.sitename;
    ProjectVC.isEdit = self.isEdit;
    ProjectVC.oldDict = self.oldDict;
    ProjectVC.delegate = self;
    ProjectVC.wholeDictionary = self.wholeLoadDict;
    if (self.oldValues.count >0) {
        NSLog(@"yes");
        ProjectVC.oldValuesReturn = self.oldValues;
    }
    [self.navigationController pushViewController:ProjectVC animated:YES];
}

- (IBAction)btn_single:(id)sender {
    NotesViewController *NotesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesVC"];
    NSMutableDictionary *dictOneImage= [self.imageArray objectAtIndex:0];
    NotesVC.self.dictionaries = dictOneImage;
    NotesVC.delegate = self;
    [self.navigationController pushViewController:NotesVC animated:YES];
}

-(void)notesData
{
    NSLog(@" after delegates:%@",self.imageArray);
    if (!(self.imageArray.count ==1)) {
        [self.selected_CollectionView reloadData];
    }
    else{
        NSDictionary *dict= [self.imageArray objectAtIndex:0];
        NSString *text = [dict objectForKey:@"string"];
        if (text.length > 0) {
            self.notes_image_view.image = [UIImage imageNamed:@"sticky.png"];
        }
        else
        {
            self.notes_image_view.image = nil;
        }
    }
}

-(void)sendDataToPictureConfirmation:(NSMutableArray *)array{
    self.oldValues = array;
    NSLog(@"%@",self.oldValues);
}


- (IBAction)back_btn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
