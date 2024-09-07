//
//  PointDetailsViewController.m
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/11/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "PointDetailsViewController.h"

@interface PointDetailsViewController ()

@end

@implementation PointDetailsViewController{
    NSString *pointTitle,*pointImage,*pointDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //configure navigation bar
    [self configureNavigationBar];
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:DATABASE_NAME];
    
    //clear all previous data
    if (self.queryResultArray != nil) {
        self.queryResultArray = nil;
    }
    //load guide point info from database
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", GUIDE_POINT_TABLE, ID, self.pointID];
    self.queryResultArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryString]];
    
    //NSLog(@"Query: %@  \n Rwsult: %@",queryString, self.queryResultArray);
    if (self.queryResultArray.count>0) {
        self.imageView.image          = [UIImage imageNamed:[[self.queryResultArray objectAtIndex:0] objectAtIndex:2]];
        self.titleLabel.text          = [[self.queryResultArray objectAtIndex:0] objectAtIndex:1];
        self.descriptionTextView.text = [[self.queryResultArray objectAtIndex:0] objectAtIndex:5];
    }else{
        self.imageView.image          = nil;
        self.titleLabel.text          = @"";
        self.descriptionTextView.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureNavigationBar{
    
    //set title navigation controller title
    [self.navigationItem setTitle: NSLocalizedString(@"building_details", "")];
    
    //add close button as left bar button
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissViewController)];
    self.navigationItem.leftBarButtonItem=leftBarButton;
}

-(void)dismissViewController{
    
    //dismiss current view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
