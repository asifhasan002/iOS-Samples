//
//  QuizViewController.h
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/9/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizSelectionViewController.h"

@interface QuizViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
