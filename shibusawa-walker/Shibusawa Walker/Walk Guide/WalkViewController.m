//
//  WalkViewController.m
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/9/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "WalkViewController.h"

@interface WalkViewController ()

@end

@implementation WalkViewController{
    
    GMSCameraPosition *camera;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //configure navigation bar
    [self configureNavigationBar];
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:DATABASE_NAME];
    
    
    //load all guide point info from database
    [self loadGuidePoint];
    
    
    //configure google map
    [self configureGoogleMap];
    
    //configure CLLocation
    [self configureLocation];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //configure CLLocation
    [self configureLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureNavigationBar{
    
    //set title navigation controller title
    [self.navigationItem setTitle: NSLocalizedString(@"shibusawa_walker", "")];
    
    //add close button as left bar button
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissViewController)];
    self.navigationItem.leftBarButtonItem=leftBarButton;
}

-(void)dismissViewController{
    
    //dismiss current view controller
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:NO completion:NULL];

}

-(void)loadGuidePoint{
    
    //clear all previous data
    if (self.queryResultArray != nil) {
        self.queryResultArray = nil;
    }
    //load all guide point info from database
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@", GUIDE_POINT_TABLE];
    self.queryResultArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryString]];
}

-(void)configureGoogleMap{
    
    camera = [GMSCameraPosition cameraWithLatitude:DEFAULT_LATITUDE
                                         longitude:DEFAULT_LONGITUDE
                                              zoom:DEFAULT_ZOOM_LEVEL];
    self.mapView.delegate = self;
    [self.mapView setCamera:camera];
    self.mapView.myLocationEnabled = YES;
    
    //create guide point marker
    GMSMarker *marker;
    for (int i = 0; i < self.queryResultArray.count; i++) {
        marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([[[self.queryResultArray objectAtIndex:i] objectAtIndex:3] doubleValue], [[[self.queryResultArray objectAtIndex:i] objectAtIndex:4] doubleValue]);
        marker.userData = [[self.queryResultArray objectAtIndex:i] objectAtIndex:0];
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        //marker.snippet = @"Australia";
        marker.map = self.mapView;
    }
}

-(void)configureLocation{
    
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager){
        self.locationManager =[[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = DISTANCE_FILTER;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        //requestAlwaysAuthorization
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

-(void)showAlertWithTitle:(NSString *) title andMessage:(NSString *) message{
    
    //show alert view controller with ok button
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle: title
                                          message: message
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Ok", nil)
                                style:UIAlertActionStyleCancel
                                handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark GMSMapViewDelegate

-(BOOL) mapView:(GMSMapView *) mapView didTapMarker:(GMSMarker *)marker{

    //check for current location not nill
    if (self.location ==nil) {
        return YES;
    }
    
    //check current location & marker position distance
    //check ditance from location
    CLLocationDistance distance = [self.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude]];
    //NSLog(@"Pressed MArker Distance From Current Location: %f",distance);
    if (distance<=POINT_DISTANCE) {
        
        //launch guide point detaild view controller
        PointDetailsViewController *pointDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PointDetailsViewControllerID"];
        pointDetailsVC.pointID = [NSString stringWithFormat:@"%@",marker.userData];
        UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:pointDetailsVC];
        [self presentViewController:navcont animated:YES completion:nil];
    }
    return YES;
}

#pragma -mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.location = [locations lastObject];
    if (self.location != nil) {
        
        camera = [GMSCameraPosition cameraWithLatitude:self.location.coordinate.latitude
                                             longitude:self.location.coordinate.longitude
                                                  zoom:self.mapView.camera.zoom];
        [self.mapView animateToCameraPosition:camera];
        //clear all object from map
        [self.mapView clear];
        
        for(int i=0; i< self.queryResultArray.count; i++){
            
            CLLocationCoordinate2D markerPosition = CLLocationCoordinate2DMake([[[self.queryResultArray objectAtIndex:i] objectAtIndex:3] doubleValue], [[[self.queryResultArray objectAtIndex:i] objectAtIndex:4] doubleValue]);
            GMSMarker *marker = [GMSMarker markerWithPosition:markerPosition];
            //check ditance from location
            CLLocationDistance distance = [self.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:[[[self.queryResultArray objectAtIndex:i] objectAtIndex:3] doubleValue] longitude:[[[self.queryResultArray objectAtIndex:i] objectAtIndex:4] doubleValue]]];
            
            //NSLog(@"Distance From Current Location: %f",distance);
            
            //check current location & marker position distance
            if (distance<=POINT_DISTANCE) {
                
                //change marker icon type
                marker.icon = [GMSMarker markerImageWithColor:[UIColor clearColor]];
                //enlarge the marker size
                marker.icon = [self image:marker.icon scaledToSize:CGSizeMake(MARKER_ENLARGE_WIDTH, MARKER_ENLARGE_HEIGHT)];
            }else{
                
                //change marker icon type
                marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
                //enlarge the marker size
                marker.icon = [self image:marker.icon scaledToSize:CGSizeMake(MARKER_DEFAULT_WIDTH, MARKER_DEFAULT_HEIGHT)];
            }
            
            marker.userData = [[self.queryResultArray objectAtIndex:i] objectAtIndex:0];
            //add marker on map
            marker.map = self.mapView;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
            
        case kCLAuthorizationStatusDenied:
            NSLog(@"User has desnied");
            //show alert to enable location
            [self showAlertWithTitle:NSLocalizedString(@"Access Required" , "") andMessage:NSLocalizedString(@"location_access_msg", "")];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            
            //start update location
            [self.locationManager startUpdatingLocation];
            NSLog(@"User has grant  to use always");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            
            //start update location
            [self.locationManager startUpdatingLocation];
            NSLog(@"User has grant  to use for forground");
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region{
    
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region{
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
}

@end
