//
//  SlidingView.m
//  Logger
//
//  Created by XOR Geek 03 on 8/23/15.
//  Copyright (c) 2015 XOR Geek 03. All rights reserved.
//

#import "SlidingViewController.h"

@implementation SlidingViewController

@synthesize cancel,howToUse;

- (void)viewDidLoad {
    
    howToUse.text = NSLocalizedString(@"How_To_Use_Text", nil);
    [cancel setTitle:NSLocalizedString(@"Cancel_Text", nil) forState:UIControlStateNormal];

    _pageImages = @[@"image1.png",@"image2.png",@"image3.png",@"image4.png"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    HowToUseViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
//    UIPageControl *pageControl = [UIPageControl appearance];
//    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
//    pageControl.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (HowToUseViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    HowToUseViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HowToUseView"];
    
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((HowToUseViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((HowToUseViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


//hide the Status Bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)cancelpopupview:(id)sender{
    
    NSLog(@" Code here.");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
