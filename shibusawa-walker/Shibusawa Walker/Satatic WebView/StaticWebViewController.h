//
//  StaticWebViewController.h
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/4/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticWebViewController : UIViewController

@property(nonatomic, retain) UIWebView *staticWebView;

@property (nonatomic) NSString *pageTitle;

@property (nonatomic) NSString *htmlFileName;

@end
