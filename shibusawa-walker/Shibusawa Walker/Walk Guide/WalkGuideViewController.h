//
//  WalkGuideViewController.h
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/4/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalkViewController.h"

@interface WalkGuideViewController : UIViewController

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)  UIImageView *contentImageView;
@property (strong,nonatomic)   UILabel *contentTitleLabel;
@property (strong,nonatomic)   UILabel *contentDescLabel;
@property (strong,nonatomic)   UIButton *lastPageDismissButton;

@property (strong,nonatomic)   UIView *pagerView;
@property (strong,nonatomic)   UIButton *gotoSecondPageButton;
@property (strong,nonatomic)   UIButton *gotoPrevPageButton;
@property (strong,nonatomic)   UIButton *gotoNextPageButton;

@property NSUInteger pageIndex;
@property NSString *imageFile;
@property (weak, nonatomic) IBOutlet UIButton *dismissViewControllerButton;
@property UIScrollView *contentScrollView;

@property NSMutableArray *contentImageFileNamesArray;
@property NSMutableArray *contentTitleArray;
@property NSMutableArray *contentDescArray;

- (IBAction)dismissViewControllerButtonPressed:(id)sender;

@end
