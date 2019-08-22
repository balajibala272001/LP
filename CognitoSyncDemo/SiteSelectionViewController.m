//
//  SiteSelectionViewController.m
//  CognitoSyncDemo
//
//  Created by mac on 9/16/16.
//  Copyright © 2016 Behroozi, David. All rights reserved.
//

#import "SiteSelectionViewController.h"
#import "TableViewCell.h"
#import "CameraViewController.h"

@interface SiteSelectionViewController ()

@end
//@implementation ViewController
//@synthesize btn_Click;
//@synthesize tblSimpleTable;
//@synthesize i;
//@synthesize arryData;


@implementation SiteSelectionViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button.hidden = YES;
    // [self.button setHidden:YES];
    
    self.tblSimpleTable.layer.cornerRadius =10;
    self.tblSimpleTable.layer.borderWidth =1;
    
    self.tblSimpleTable.layer.borderColor = [UIColor blackColor].CGColor;
    self.sub_View.layer.cornerRadius =10;
    self.sub_View.layer.borderWidth =1;
    self.sub_View.layer.borderColor = [UIColor blackColor].CGColor;
    self.a = [[NSMutableArray alloc]init];
    
    [self.a addObject:@"iPhone"];
    [self.a addObject:@"IPod"];
    [self.a addObject:@"One"];
    [self.a addObject:@"Two"];
    [self.a addObject:@"Three"];
    [self.a addObject:@"four"];
    [self.a addObject:@"Five"];
    [self.a addObject:@"Six"];
    [self.a addObject:@"Seven"];
    [self.a addObject:@"Eight"];
    [self.a addObject:@"Nine"];
    
    
    arryData = [[NSArray alloc] initWithObjects:@"",@"iPhone",@"iPod",@"MacBook",@"MacBook Pro",nil];
    flag=1;
    tblSimpleTable.hidden=YES;
    self.btn_Click.layer.cornerRadius=8;
    tblSimpleTable.layer.cornerRadius=8;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Click:(id)sender {
    
    if (flag==1) {
        flag=0;
        tblSimpleTable.hidden=NO;
        [i setImage:[UIImage imageNamed:@"up.png"]];
        
        self.button.hidden = YES;
        
        
    }
    else{
        flag=1;
        tblSimpleTable.hidden=YES;
        
        [i setImage:[UIImage imageNamed:@"down.png"]];
        
        ;
        self.button.hidden = NO;
        self.button.layer.cornerRadius =10;
        self.button.layer.borderWidth =1;
        self.button.layer.borderColor = [UIColor blackColor].CGColor;
        
    }
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [arryData count];
    return [self.a count];
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Site";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
    }
    
    // Set up the cell...
    cell.textLabel.font=[UIFont fontWithName:@"Arial" size:16];
    
    cell.textLabel.text = [self.a objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *text = [self.a objectAtIndex:indexPath.row];
    if (flag==1) {
        
        flag=0;
        tblSimpleTable.hidden=NO;
        
        
        [i setImage:[UIImage imageNamed:@"up.png"]];
        
        self.button.hidden = YES;
        
        
    }
    else{
        flag=1;
        [self.btn_Click setTitle:text forState:UIControlStateNormal];
        tblSimpleTable.hidden=YES;
        
        [i setImage:[UIImage imageNamed:@"down.png"]];
        self.button.layer.cornerRadius =10;
        self.button.layer.borderWidth =1;
        self.button.layer.borderColor = [UIColor blackColor].CGColor;
        self.button.hidden = NO;
        
        
        
    }
    
    //tblSimpleTable.hidden=YES;
    
}

- (void)viewDidUnload {
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.btn_Click=nil;
    self.tblSimpleTable=nil;
    self.i=nil;
    self.arryData=nil;
    
    [super viewDidUnload];
    
}


@end
