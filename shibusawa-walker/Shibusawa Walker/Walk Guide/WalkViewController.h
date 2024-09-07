//
//  WalkViewController.h
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/9/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DBManager.h"
#import "Default.h"
#import "PointDetailsViewController.h"


@interface WalkViewController : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate>

@property(nonatomic, retain) IBOutlet GMSMapView *mapView;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *queryResultArray;

@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation *location;

@end
