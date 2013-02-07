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

@interface LocationViewController ()
{
    IBOutlet    UILabel     *_cityLabel;
    IBOutlet    MKMapView   *_mapView;
    NSMutableArray          *_shopAnnotationArray;
}
@end

@implementation LocationViewController

- (void)dealloc
{
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

#pragma mark- custom methods
- (void)prepareData
{
    _shopAnnotationArray = [[NSMutableArray alloc] init];
    for (Shop *shop in self.shopArray) {
        ShopAnnotation *shopAnnotation = [[ShopAnnotation alloc] initWithShopInfo:shop];
        [_shopAnnotationArray addObject: shopAnnotation];
        [shopAnnotation release];
    }
}

- (void)initUI
{
    [_cityLabel setBackgroundColor:[UIColor blackColor]];
    CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];

    [_mapView setRegion:MKCoordinateRegionMake(myCurrentLocation.coordinate, MKCoordinateSpanMake(Discrepancy, Discrepancy)) animated:YES];
    [_mapView setShowsUserLocation:YES];
    [_mapView.userLocation setTitle:@"当前位置"];
    
    [_mapView addAnnotations:_shopAnnotationArray];
}

- (void)goIntoShopDetail:(UIButton *)sender
{
    MKAnnotationView *annotationView = (MKAnnotationView *)[[sender superview] superview];
    ShopAnnotation *shopAnnotation = (ShopAnnotation *)annotationView.annotation;
    Shop *shop = shopAnnotation.shop;
    
    ShopDetailsViewController *vc = [[ShopDetailsViewController alloc] init];
    [vc setShop:shop];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
