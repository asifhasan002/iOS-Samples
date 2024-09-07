//
//  HomeViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FastttFilterCamera.h>
#import <UIImage+FastttFilters.h>

@interface SnapViewController : UIViewController<FastttCameraDelegate>
@property UIImageView *frameImageView;
@property (strong,nonatomic) NSString *frameFileName;

@end
