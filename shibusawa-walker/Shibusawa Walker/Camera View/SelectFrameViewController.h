//
//  SelectFrameViewController.h
//  LLSimpleCameraExample
//
//  Created by XORGEEK3 on 1/3/17.
//  Copyright © 2017 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Default.h"
#import "DBManager.h"

@interface SelectFrameViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIImageView *currentFrameImageView;

@property (strong, nonatomic) IBOutlet UILabel *currentFrameDescTextView;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) UIView *bannerView;
@property (strong,nonatomic) NSMutableArray *frameFileNameArray;
@property UIImageView *cameraImgView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSString *text;

@property NSMutableArray* rowTitleArray;
@property NSMutableArray* rowSubTitleArray;
@property NSMutableArray* rowDescArray;

@property UIImageView *rowImageView;
@property UILabel *rowTitle;
@property UILabel *rowSubTitle;
@property UILabel *rowDesc;


- (IBAction)nextButtonPressed:(id)sender;

@end
