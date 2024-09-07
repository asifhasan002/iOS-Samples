//
//  CheckinHistoryViewController.h
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/9/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Default.h"
#import "DBManager.h"

@interface CheckinHistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *queryResultArray;

@property (nonatomic, retain) IBOutlet UITableView *historyTableView;

@end
