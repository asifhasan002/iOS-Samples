//
//  AboutAppViewController.m
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/3/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()

@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //configure navigation bar
    [self configureNavigationBar];
    
    //textview visible from top not middle
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureNavigationBar{
    
    //set title navigation controller title
    [self.navigationItem setTitle: NSLocalizedString(@"feature_&_uses", nil)];
    
    //add close button as left bar button
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissViewController)];
    self.navigationItem.leftBarButtonItem=leftBarButton;
}

-(void)dismissViewController{
    
    //dismiss current view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
