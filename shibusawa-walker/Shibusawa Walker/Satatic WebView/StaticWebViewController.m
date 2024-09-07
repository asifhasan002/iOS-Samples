//
//  StaticWebViewController.m
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/4/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "StaticWebViewController.h"

@interface StaticWebViewController ()

@end

@implementation StaticWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set title navigation controller title
    [self.navigationItem setTitle:self.pageTitle];
    //add close button as left bar button
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissViewController)];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView{
    
    
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //configure webview
    self.staticWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.height))];
    //load static page
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:self.htmlFileName ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.staticWebView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    [self.view addSubview:self.staticWebView];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}

-(void)dismissViewController{
    
    //dismiss current view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
