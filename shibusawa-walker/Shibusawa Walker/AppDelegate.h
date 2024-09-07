//
//  AppDelegate.h
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/2/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import SystemConfiguration;
@import AVFoundation;
@import ImageIO;

#import <Pushwoosh/PushNotificationManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, PushNotificationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

