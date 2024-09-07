//
//  ViewController.m
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/2/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    
    UIView* drawerView, *drawerBackView;
    
    bool openDrawer;
    
    CGFloat widthRatio;
}

@synthesize drawerTable,drawerButtonItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //configure navigation back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", "") style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    widthRatio = [[UIScreen mainScreen]bounds].size.width/320;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:DATABASE_NAME];
    
    //check by this bool if drawer open or close
    openDrawer = false;
    //create the drawer view
    [self CreateDrawerView];
    
    //check tutorial view status
    if(![[NSUserDefaults standardUserDefaults] boolForKey:TUTORIAL_STATUS_KEY]){
        
        //update status
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:TUTORIAL_STATUS_KEY];
        
        //launch tutorial view controller
        HowToUseViewController *howToUseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HowToUseViewControllerID"];
        //[self.presentedViewController:howToUseVC animated:YES];
        howToUseVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:howToUseVC animated:YES completion: nil];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //here check user's "check-in" status
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CHECKIN_STATUS_KEY]) {
        //show checkin content
        [self.checkinView setHidden:FALSE];
        [self.uncheckView setHidden:TRUE];
    }else{
        //Hide checkin content
        [self.checkinView setHidden:TRUE];
        [self.uncheckView setHidden:FALSE];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//open website link in safar
-(void)openExternalBrowserWithUrl:(NSString *) urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO}
           completionHandler:^(BOOL success) {
               NSLog(@"Open Using: openURL:options:completionHandler: success:%d",success);
           }];
    } else {
        [application openURL:url];
        NSLog(@"Open using: application openURL:URL");
    }
}

#pragma mark - NavgationDrawer Configuration
//create the drawer view
-(void)CreateDrawerView{
    
    drawerView = [[UIView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width), 0.0, ([[UIScreen mainScreen] bounds].size.width/1.7), [[UIScreen mainScreen] bounds].size.height)];
    
    [drawerView setBackgroundColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:drawerView];
    //add drawer closing button
    UIButton *closingButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 24.0f, 40.0f, 40.0f)];
    [closingButton setBackgroundImage:[UIImage imageNamed:@"icon_menu_gray.png"] forState:UIControlStateNormal];
    [closingButton addTarget:self action:@selector(hideDrawer) forControlEvents:UIControlEventTouchUpInside];
    [drawerView addSubview:closingButton];
    
    [self DrawerTableView];
    
    //add a Gesture to the self view for opening the drawer by sliding
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDrawer)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGesture];
    
}

//open drawer menu when drawer icon clicked
-(IBAction)drawerMenuPressed:(id)sender{
    
    [self openDrawer];
    
}   

//show drawer menu
-(void)openDrawer{
    
    if(!openDrawer){
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            [drawerView setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-drawerView.frame.size.width), 0.0, drawerView.frame.size.width, drawerView.frame.size.height)];   // last position
            
        } completion:nil];
        
        
        drawerBackView = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
        
        [drawerBackView setBackgroundColor:[UIColor blackColor]];
        
        [drawerBackView setAlpha:0.3];
        
        [[UIApplication sharedApplication].keyWindow addSubview:drawerBackView];
        
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:drawerView];
        
        //add tap and swipe gesture for closing the drawer
        [drawerBackView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDrawer)];
        [singleTap setNumberOfTapsRequired:1];
        [drawerBackView addGestureRecognizer:singleTap];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideDrawer)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [drawerBackView addGestureRecognizer:swipeGesture];
        
        openDrawer = true;
        
    }
}


//hide drawer menu
-(void)hideDrawer{
    
    if(openDrawer){
        
        [drawerBackView setUserInteractionEnabled:NO];
        
        [drawerBackView removeFromSuperview];
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            [drawerView setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width, 0.0, drawerView.frame.size.width, drawerView.frame.size.height)];
            
        } completion:nil];
        
        openDrawer = false;
        
    }
    
}

//create the drawer menu table
-(void)DrawerTableView{
    
    drawerTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,64.0f,drawerView.frame.size.width,drawerView.frame.size.height) style:UITableViewStylePlain];
    drawerTable.dataSource = self;
    drawerTable.delegate = self;
    
    drawerTable.backgroundColor =[UIColor clearColor];
    [drawerTable setSeparatorColor:[UIColor clearColor]];
    [drawerView addSubview:drawerTable];
}

#pragma mark - UIButton TouchUpInside event implementation

-(IBAction)checkInButtonPressed:(id)sender{
    
    //chek for already check in
    if(![[NSUserDefaults standardUserDefaults] boolForKey:CHECKIN_STATUS_KEY]){
        
        //update check in status
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:CHECKIN_STATUS_KEY];
        
        //insert into database
        [self.dbManager executeQuery:[NSString stringWithFormat:@"INSERT INTO %@ ( %@, %@) VALUES ( 'checkin_poinr_1',datetime())", CHECKIN_TABLE, CHECKIN_POINT_NAME, CHECKIN_TIME]];
        //check for inser success
        if(self.dbManager.lastInsertedRowID!=DEFAULT_ZERO){
    
            //update checkin id
            [[NSUserDefaults standardUserDefaults] setInteger:self.dbManager.lastInsertedRowID forKey:CHECKIN_ID_KEY];
        }
        
        //setup local notification
        [self setupLocalNotification];
        
        //call for uiupdate
        [self viewWillAppear:YES];
        
    }else{
        //show alert as already check in
//        [[[UIAlertView alloc] initWithTitle:@"Error"
//                                    message:@"You are already check in "
//                                   delegate:nil
//                          cancelButtonTitle:@"Ok"
//                          otherButtonTitles:nil] show];
    }
    
    
}
-(IBAction)checkOutButtonPressed:(id)sender{
    
    //chek for not check in yet
    if([[NSUserDefaults standardUserDefaults] boolForKey:CHECKIN_STATUS_KEY]){
        
        //update check in status
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:CHECKIN_STATUS_KEY];
        
        //update check in database
        [self.dbManager executeQuery:[NSString stringWithFormat:@"UPDATE %@ SET %@ = datetime() WHERE %@ = %ld", CHECKIN_TABLE,CHECKOUT_TIME, ID, [[NSUserDefaults standardUserDefaults] integerForKey:CHECKIN_ID_KEY]]];
        
        //check for update success
        if(self.dbManager.affectedRows!=DEFAULT_ZERO){
            
            //update checkin id
            [[NSUserDefaults standardUserDefaults] setInteger:DEFAULT_ZERO forKey:CHECKIN_ID_KEY];
        }
        
        //setup local notification
        [self setupLocalNotification];
        
        //call for uiupdate
        [self viewWillAppear:YES];
        
    }else{
//        //show alert not check in
//        [[[UIAlertView alloc] initWithTitle:@"Error"
//                                    message:@"You are not check in yet "
//                                   delegate:nil
//                          cancelButtonTitle:@"Ok"
//                          otherButtonTitles:nil] show];
    }
    
}

-(IBAction)contentIntroductionButtonPressed:(id)sender{

    //launch checkin content introduction view controller
    CheckinIntroductionViewController *checkInIntroductoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinIntroductionViewControllerID"];
    [self.navigationController pushViewController:checkInIntroductoryVC animated:YES];
}

-(IBAction)shibusawaEiichiButtonPressed:(id)sender{
    
    //launch shibusawa eiichi biography view controller
    ShibusawaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shibusawaHistoryID"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)quizButtonPressed:(id)sender{
    
    //launch quiz view controller
    QuizViewController *quizVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewControllerID"];
    [self.navigationController pushViewController:quizVC animated:YES];
    //[self  presentViewController:quizVC animated:YES completion:nil];
}

-(IBAction)walkGuideButtonPressed:(id)sender{
    
    //launch shibusawa walk guide view controller
//    WalkGuideViewController *walkGuideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WalkGuideViewControllerID"];
//    [self.navigationController pushViewController:walkGuideVC animated:YES];
 
    WalkGuideViewController *walkGuideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WalkGuideViewControllerID"];
    UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:walkGuideVC];
    [self presentViewController:navcont animated:YES completion:nil];
    
    
//    WalkViewController *walkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WalkViewControllerID"];
//    UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:walkVC];
//    [self presentViewController:navcont animated:YES completion:nil];
}

-(IBAction)cameraButtonPressed:(id)sender{
    
    //launch cameraframe select view controller
    SelectFrameViewController *selectFrameVC = [[SelectFrameViewController alloc] initWithNibName:@"SelectFrame" bundle:nil];
    [self.navigationController pushViewController:selectFrameVC animated:YES];
}

-(IBAction)puzzleButtonPressed:(id)sender{
    
    //launch image collection view controller
    ImageCollectionViewController *imageCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageCollectionViewControllerID"];
    [self.navigationController pushViewController:imageCollectionVC animated:YES];
}

-(IBAction)shibusawaUseButtonPressed:(id)sender{
    
    //launch static webview page shower
    StaticWebViewController *staticwebVC = [[StaticWebViewController alloc] init];
    staticwebVC.pageTitle = NSLocalizedString(@"shibusawa_use", "");
    staticwebVC.htmlFileName = SHIBUSAWA_USE_PAGE;
    UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:staticwebVC];
    [self presentViewController:navcont animated:YES completion:nil];
}

-(IBAction)threeBuildingButtonPressed:(id)sender{
    
    //launch static webview page shower
    StaticWebViewController *staticwebVC = [[StaticWebViewController alloc] init];
    staticwebVC.pageTitle = NSLocalizedString(@"story_three_building", "");
    staticwebVC.htmlFileName = THREE_BUILDING_PAGE;
    UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:staticwebVC];
    [self presentViewController:navcont animated:YES completion:nil];
}

-(IBAction)knowMakerButtonPressed:(id)sender{
    
    //launch static webview page shower
    StaticWebViewController *staticwebVC = [[StaticWebViewController alloc] init];
    staticwebVC.pageTitle = NSLocalizedString(@"know_maker", "");
    staticwebVC.htmlFileName = KNOW_MAKER_PAGE;
    UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:staticwebVC];
    [self presentViewController:navcont animated:YES completion:nil];
    
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == drawerTable){
        return 12;
    }
    return 1;
}

//set the cell height of the table
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == drawerTable){
        
        return widthRatio*35.0f;
        //return ([[UIScreen mainScreen]bounds].size.height/16);
    }
    
    return widthRatio*44.0f;
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.drawerTable && indexPath.row == 2) {
        return nil;
    }else if (tableView == self.drawerTable && indexPath.row == 7) {
        return nil;
    }if (tableView == self.drawerTable && indexPath.row == 10) {
        return nil;
    }if (tableView == self.drawerTable && indexPath.row == 11) {
        return nil;
    }
    
    return indexPath;
}

//pass the suitable data to corresponding view controller when a cell clicked
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
    //for Drawer table
    if(tableView == drawerTable){
        
        [self hideDrawer];
        
        if(indexPath.row == 0){
            
            //launch about/ feature&use view controller
            AboutAppViewController *aboutAppVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutAppViewControllerID"];
            UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:aboutAppVC];
            [self presentViewController:navcont animated:YES completion:nil];
            
        }else if(indexPath.row == 1){
            
            //open check in history view controller
            CheckinHistoryViewController *checkinHistoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinHistoryViewControllerID"];
            UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:checkinHistoryVC];
            [self presentViewController:navcont animated:YES completion:nil];
            
        }else if(indexPath.row == 3){
            
            //open announcement url
            [self openExternalBrowserWithUrl:ANNOUNCEMENT_URL];
            
        }else if(indexPath.row == 4){
            
            //open museum url
            [self openExternalBrowserWithUrl:MUSEUM_URL];
            
        }else if(indexPath.row == 5){
            
            //open event info url
            [self openExternalBrowserWithUrl:EVENT_INFO_URL];
            
        }else if(indexPath.row == 6){
            
            //open facebook page url
            [self openExternalBrowserWithUrl:FACEBOOK_PAGE_URL];
            
        }else if(indexPath.row == 8){
            
            //open terms of use url
            [self openExternalBrowserWithUrl:TERMS_OF_USE_URL];
            
        }else if(indexPath.row == 9){
            
            //open frequently ask question url
            [self openExternalBrowserWithUrl:FAQ_URL];
            
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    //for Drawer table
    if(tableView == drawerTable){
        
        static NSString *CellIdentifier = @"listCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = NSLocalizedString(@"feature_&_uses", nil);
            
        }else if(indexPath.row == 1){
            
            cell.textLabel.text = NSLocalizedString(@"checkin_history", nil);
        
        }else if(indexPath.row == 2){
            
            //cell.textLabel.text = NSLocalizedString(@"", nil);
            
        }else if(indexPath.row == 3){
            
            cell.textLabel.text = NSLocalizedString(@"announcement", nil);
            
        }else if(indexPath.row == 4){
            
            cell.textLabel.text = NSLocalizedString(@"museum_site", nil);
            
        }else if(indexPath.row == 5){
            
            cell.textLabel.text = NSLocalizedString(@"event_info", nil);
            
        }else if(indexPath.row == 6){
            
            cell.textLabel.text = NSLocalizedString(@"facebook", nil);
            
        }else if(indexPath.row == 7){
            
//            cell.textLabel.text = NSLocalizedString(@"", nil);
            
        }else if(indexPath.row == 8){
            
            cell.textLabel.text = NSLocalizedString(@"terms_of_use", nil);
            
        }else if(indexPath.row == 9){
            
            cell.textLabel.text = NSLocalizedString(@"faq", nil);
            
        }else if(indexPath.row == 10){
            
//            cell.textLabel.text = NSLocalizedString(@"", nil);
            
        }else if(indexPath.row == 11){
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"version", nil), [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
            
        }
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

#pragma mark - UILocalNotification
-(void)setupLocalNotification{
    //cancel all local notification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //check checkin status
    if([[NSUserDefaults standardUserDefaults] boolForKey:CHECKIN_STATUS_KEY]){
        
        //set up closing notification
        // Schedule the notification
        UILocalNotification* closingNotification = [[UILocalNotification alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDate *closingDate = [calendar dateBySettingHour:CLOSING_TIME_HOURS minute:CLOSING_TIME_MINUTES second:DEFAULT_ZERO ofDate:[NSDate date] options:0];
        closingNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:CLOSING_TEST_TIME];
        closingNotification.alertBody = NSLocalizedString(@"closing_message", "");
        //localNotification.alertAction = @"Show me the item";
        //localNotification.timeZone = [NSTimeZone defaultTimeZone];
        closingNotification.soundName = UILocalNotificationDefaultSoundName;
        NSLog(@"Closing time: %@, Date:%@",closingDate, [NSDate date]);
        
        [[UIApplication sharedApplication] scheduleLocalNotification:closingNotification];
        
    }else{
        
        //set up checkout notification
        // Schedule the notification
        UILocalNotification* checkOutNotification = [[UILocalNotification alloc] init];
        checkOutNotification.fireDate = [NSDate date];
        checkOutNotification.alertBody = NSLocalizedString(@"checkout_message", "");
        //localNotification.alertAction = @"Show me the item";
        checkOutNotification.timeZone = [NSTimeZone defaultTimeZone];
        //localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        checkOutNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:checkOutNotification];
    }
}
@end
