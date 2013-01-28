//
//  LocationViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreService.h"

#define Discrepancy 0.05

@interface LocationViewController ()
{
    IBOutlet    UILabel     *_cityLabel;
    IBOutlet    MKMapView   *_mapView;

}
@end

@implementation LocationViewController

- (void)dealloc
{
    [_cityLabel release];
    [_mapView release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 
#pragma mark custom methods
- (void)initUI
{
    [_cityLabel setBackgroundColor:[UIColor blackColor]];
    CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];

    [_mapView setRegion:MKCoordinateRegionMake(myCurrentLocation.coordinate, MKCoordinateSpanMake(Discrepancy, Discrepancy)) animated:YES];
    [_mapView setShowsUserLocation:YES];
    [_mapView.userLocation setTitle:@"当前位置"];
}



@end
