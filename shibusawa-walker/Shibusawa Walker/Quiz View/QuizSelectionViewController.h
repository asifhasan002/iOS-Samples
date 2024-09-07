//
//  QuizSelectionViewController.h
//  Shibusawa Walker
//
//  Created by XOR Geek 03 on 1/15/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizDetailViewController.h"

@interface QuizSelectionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSString *text;

@end
