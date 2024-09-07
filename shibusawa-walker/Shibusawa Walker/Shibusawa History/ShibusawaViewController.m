//
//  ShibusawaViewController.m
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/3/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "ShibusawaViewController.h"

@interface ShibusawaViewController ()

@end

@implementation ShibusawaViewController{
    
    ViewController *viewController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureNavigationDrawer];
    
    //textview visible from top not middle
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//for open the drawer
-(void)configureNavigationDrawer{
    
    //set title navigation controller title
    [self.navigationItem setTitle:NSLocalizedString(@"who_shibusawa_eiichi", @"")];
    
    //configure navigation back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", "") style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    viewController = [[ViewController alloc]init];
    
    NSArray *stack = self.navigationController.viewControllers;
    viewController = stack[0];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_menu.png"] style:UIBarButtonItemStylePlain target:viewController action:@selector(openDrawer)];
    self.navigationItem.rightBarButtonItem=rightBarButton;
    
    //add a Gesture to the self view for opening the drawer by sliding
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:viewController action:@selector(openDrawer)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGesture];
    
}
@end
