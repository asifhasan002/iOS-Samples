//
//  ViewController.h
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/2/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutAppViewController.h"
#import "ShibusawaViewController.h"
#import "CheckinIntroductionViewController.h"
#import "PuzzleViewController.h"
#import "StaticWebViewController.h"
#import "SelectFrameViewController.h"
#import "Default.h"
#import "CheckinHistoryViewController.h"
#import "QuizViewController.h"
#import "WalkGuideViewController.h"
#import "WalkViewController.h"
#import "HowToUseViewController.h"
#import "ImageCollectionViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//drawer
@property (nonatomic, retain) IBOutlet UITableView *drawerTable;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *drawerButtonItem;


@property(nonatomic, retain) IBOutlet UIView *uncheckView, *checkinView;
//@property (nonatomic, retain) IBOutlet UITableView *uncheckTableView, *checkinTableView;

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *queryResultArray;

-(IBAction)contentIntroductionButtonPressed:(id)sender;
-(IBAction)shibusawaEiichiButtonPressed:(id)sender;
-(IBAction)quizButtonPressed:(id)sender;

-(IBAction)walkGuideButtonPressed:(id)sender;
-(IBAction)cameraButtonPressed:(id)sender;
-(IBAction)puzzleButtonPressed:(id)sender;
-(IBAction)shibusawaUseButtonPressed:(id)sender;
-(IBAction)threeBuildingButtonPressed:(id)sender;
-(IBAction)knowMakerButtonPressed:(id)sender;
@end

