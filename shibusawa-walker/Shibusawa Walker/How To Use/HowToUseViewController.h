//
//  FirstLaunchScreen.h
//  Logger
//
//  Created by XOR Geek 03 on 8/20/15.
//  Copyright (c) 2015 XOR Geek 03. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HowToUseViewController : UIViewController{

}

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
