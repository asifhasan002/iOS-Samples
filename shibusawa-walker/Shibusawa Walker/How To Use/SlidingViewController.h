//
//  SlidingView.h
//  Logger
//
//  Created by XOR Geek 03 on 8/23/15.
//  Copyright (c) 2015 XOR Geek 03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HowToUseViewController.h"
#import "ViewController.h"

@interface SlidingViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;

@property (weak, nonatomic) IBOutlet UILabel *howToUse;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@end
