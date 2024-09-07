//
//  AppDelegate.m
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/2/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //configure google map
    [GMSServices provideAPIKey:@"AIzaSyBjG_WEhgJd4pQKVGCZO_ny1yb4EH7m2cQ"];
    
    //Register for notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

    //Handle app launch from local notifcation
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
        
    }
    
    
    //-----------PUSHWOOSH PART-----------
    // set custom delegate for push handling, in our case - view controller
    PushNotificationManager * pushManager = [PushNotificationManager pushManager];
    pushManager.delegate = self;
    
    // handling push on app start
    [[PushNotificationManager pushManager] handlePushReceived:launchOptions];
    
    // make sure we count app open in Pushwoosh stats
    [[PushNotificationManager pushManager] sendAppOpen];
    
    // register for push notifications!
    [[PushNotificationManager pushManager] registerForPushNotifications];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //Called while app receive local notification from forground or backfound state
    
    //check app state
    if ([application applicationState] == UIApplicationStateActive) {
        
        //show alert
        [self showAlertWithTitle:NSLocalizedString(@"shibusawa_walker", "") andMessage:notification.alertBody];
    }
}

-(void)showAlertWithTitle:(NSString *) title andMessage:(NSString *) message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}


// system push notification registration success callback, delegate to pushManager
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[PushNotificationManager pushManager] handlePushRegistration:deviceToken];
}

// system push notification registration error callback, delegate to pushManager
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[PushNotificationManager pushManager] handlePushRegistrationFailure:error];
}

// system push notifications callback, delegate to pushManager
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[PushNotificationManager pushManager] handlePushReceived:userInfo];
}

- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification onStart:(BOOL)onStart {
    NSLog(@"Push notification received");
}

@end
