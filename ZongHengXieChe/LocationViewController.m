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
#import "Shop.h"
#import "ShopAnnotation.h"
#import "ShopAnnotationView.h"
#import "ShopDetailsViewController.h"

#define Discrepancy 0.05
#define RegionWidth  3000
#define RegionHeight 3000

@interface LocationViewController ()
{
    IBOutlet    UILabel     *_cityLabel;
    IBOutlet    MKMapView   *_mapView;
    NSMutableArray          *_shopAnnotationArray;
    MKReverseGeocoder       *_geocoder;
}
@end

@implementation LocationViewController

- (void)dealloc
{
    
    [_geocoder setDelegate:nil];
    [_geocoder release];
    [self.shopArray release];
    [_shopAnnotationArray release];
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
    [self prepareData];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.coordinate.latitude && self.coordinate.latitude != 0) {
        [self setMapCenter:self.coordinate];
    }else{
        CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];
        [self setMapCenter:myCurrentLocation.coordinate];
    }

}

#pragma mark- mapkit delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    ShopAnnotation *shopAnnotation = (ShopAnnotation *)annotation;

    MKAnnotationView *annotationView;
    NSString *annotationIndentifier;
    if (annotation == mapView.userLocation) {
        return  nil;
    }else{
        annotationIndentifier = @"shopIdentifier";
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIndentifier];
        if (!annotationView) {
            annotationView = [[[MKAnnotationView alloc] init] autorelease];
            [annotationView setAnnotation:annotation];
            [annotationView setImage:[UIImage imageNamed:@"pin"]];
            [annotationView setCanShowCallout:YES];
            
            UIImageView *leftCalloutAccessoryView = [[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 30, 30)] autorelease];
            [leftCalloutAccessoryView setImage: shopAnnotation.shop.logoImage];
            [annotationView setLeftCalloutAccessoryView:leftCalloutAccessoryView];
            
            
            UIButton *rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightCalloutAccessoryView addTarget:self action:@selector(goIntoShopDetail:) forControlEvents:UIControlEventTouchUpInside];
            [annotationView setRightCalloutAccessoryView:rightCalloutAccessoryView];
            
        }
        return annotationView;
    }
}

#pragma mark- MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    [_cityLabel setText:[NSString stringWithFormat:@"当前位置 %@%@", placemark.thoroughfare, placemark.subThoroughfare]];
    [self setTitle:[NSString stringWithFormat:@"%@ %@", placemark.locality, placemark.subLocality]];
    [self initUI];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    DLog(@"%@",[error description]);
}


#pragma mark- custom methods
- (void)prepareData
{
    _geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:[[[CoreService sharedCoreService] getMyCurrentLocation] coordinate]];
    [_geocoder setDelegate:self];
    [_geocoder start];
    
    _shopAnnotationArray = [[NSMutableArray alloc] init];
    for (Shop *shop in self.shopArray) {
        ShopAnnotation *shopAnnotation = [[ShopAnnotation alloc] initWithShopInfo:shop];
        [_shopAnnotationArray addObject: shopAnnotation];
        [shopAnnotation release];
    }
}

- (void)initUI
{
    [super changeTitleView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    
    [_cityLabel setBackgroundColor:[UIColor blackColor]];
    

    
//    [_mapView setRegion:MKCoordinateRegionMake(myCurrentLocation.coordinate, MKCoordinateSpanMake(Discrepancy, Discrepancy)) animated:YES];
    [_mapView setShowsUserLocation:YES];
    [_mapView.userLocation setTitle:@"当前位置"];
    
    [_mapView addAnnotations:_shopAnnotationArray];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goIntoShopDetail:(UIButton *)sender
{
    MKAnnotationView *annotationView = (MKAnnotationView *)[[sender superview] superview];
    ShopAnnotation *shopAnnotation = (ShopAnnotation *)annotationView.annotation;
    Shop *shop = shopAnnotation.shop;
    
    ShopDetailsViewController *vc = [[[ShopDetailsViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [vc setShop:shop];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setMapCenter:(CLLocationCoordinate2D)centerCoordinate
{
    MKCoordinateRegion centerRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, RegionWidth, RegionHeight);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:centerRegion];
    
    [_mapView setRegion:adjustedRegion animated:YES];
    [_mapView setCenterCoordinate:centerCoordinate];
}

@end
