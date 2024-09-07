//
//  PointDetailsViewController.h
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/11/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "Default.h"

@interface PointDetailsViewController : UIViewController

@property(nonatomic, strong) NSString *pointID;

@property(nonatomic, retain) IBOutlet UIImageView *imageView;

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

@property(nonatomic, retain) IBOutlet UITextView *descriptionTextView;


@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *queryResultArray;

@end
