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
#import "BMapKit.h"
#import "BaiduShopAnnotation.h"
#import "CalloutMapAnnotationView.h"
#import "CalloutMapAnnotation.h"

#define Discrepancy 0.05
#define RegionWidth  10000
#define RegionHeight 10000

@interface LocationViewController ()
{
    IBOutlet    UILabel     *_cityLabel;
    IBOutlet    MKMapView   *_mapView;
    NSMutableArray          *_shopAnnotationArray;
//    MKReverseGeocoder       *_geocoder;
    BMKMapView  *_baiduMapView;
    CalloutMapAnnotation *_calloutMapAnnotation;
}
@property (strong, nonatomic)CalloutMapAnnotation *calloutMapAnnotation;

@end

@implementation LocationViewController

- (void)dealloc
{
    
//    [_geocoder setDelegate:nil];
//    [_geocoder release];
    [_baiduMapView release];
    [self.shopArray release];
    [_shopAnnotationArray release];
    [_cityLabel release];
    [_mapView release];
    [_calloutMapAnnotation release];
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
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    ShopAnnotation *shopAnnotation = (ShopAnnotation *)annotation;
//
//    MKAnnotationView *annotationView;
//    NSString *annotationIndentifier;
//    if (annotation == mapView.userLocation) {
//        return  nil;
//    }else{
//        annotationIndentifier = @"shopIdentifier";
//        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIndentifier];
//        if (!annotationView) {
//            annotationView = [[[MKAnnotationView alloc] init] autorelease];
//            [annotationView setAnnotation:annotation];
//            
//            CGRect frame = annotationView.frame;
//            frame.size = CGSizeMake(20, 32);
//            annotationView.frame = frame;
//            
//            
//            [annotationView setImage:[UIImage imageNamed:@"pin"]];
//            [annotationView setCanShowCallout:YES];
//            
//            UIImageView *leftCalloutAccessoryView = [[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 30, 30)] autorelease];
//            [leftCalloutAccessoryView setImage: shopAnnotation.shop.logoImage];
//            [annotationView setLeftCalloutAccessoryView:leftCalloutAccessoryView];
//            
//            
//            UIButton *rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [rightCalloutAccessoryView addTarget:self action:@selector(goIntoShopDetail:) forControlEvents:UIControlEventTouchUpInside];
//            [annotationView setRightCalloutAccessoryView:rightCalloutAccessoryView];
//            
//        }
//        return annotationView;
//    }
//}

//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{   
//    NSString *annotationIndentifier;
//    if ([annotation isKindOfClass:[BaiduShopAnnotation class]]) {
//        annotationIndentifier = @"shopIdentifier";
//        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIndentifier];
//        
//        NSString *annotationIndentifier;
//        if (annotation == mapView.userLocation) {
//            return  nil;
//        }else{
//            annotationIndentifier = @"shopIdentifier";
//            
//            if (!annotationView) {
//                annotationView = [[CalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIndentifier];
//                annotationView.enabled = TRUE;
//                [annotationView setAnnotation:annotation];
//                
//                CGRect frame = annotationView.frame;
//                frame.size = CGSizeMake(20, 32);
//                annotationView.frame = frame;
//                
//
//                [annotationView setImage:[UIImage imageNamed:@"pin"]];
//                [annotationView setCanShowCallout:NO];
//                
//            return annotationView;
//            }
//        
//        }
//    }
//    return nil;
//}

        
//        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"shopIdentifier"];
//
//        [newAnnotation setImage:[UIImage imageNamed:@"pin"]];
//        return newAnnotation;
//    }
//    BMKPinAnnotationView *annotationView;
//    NSString *annotationIndentifier;
//    if (annotation == mapView.userLocation) {
//        return  nil;
//    }else{
//        annotationIndentifier = @"shopIdentifier";
//        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIndentifier];
//
//        if (!annotationView) {
//            annotationView = [[[BMKPinAnnotationView alloc] init] autorelease];
//            [annotationView setAnnotation:annotation];
//
//            CGRect frame = annotationView.frame;
//            frame.size = CGSizeMake(20, 32);
//            annotationView.frame = frame;
//            
//            
//            [annotationView setImage:[UIImage imageNamed:@"pin"]];
//            [annotationView setCanShowCallout:YES];
        
//            UIImageView *leftCalloutAccessoryView = [[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 30, 30)] autorelease];
//            [leftCalloutAccessoryView setImage: annotation.shop.logoImage];
//            [annotationView setLeftCalloutAccessoryView:leftCalloutAccessoryView];
            
            
//            UIButton *rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [rightCalloutAccessoryView addTarget:self action:@selector(goIntoShopDetail:) forControlEvents:UIControlEventTouchUpInside];
//            [annotationView setRightCalloutAccessoryView:rightCalloutAccessoryView];
            
//        }
//        return annotationView;
    
//    }
//    return nil;
//}

//#pragma mark- MKReverseGeocoderDelegate
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
//{
//    [_cityLabel setText:[NSString stringWithFormat:@"当前位置 %@%@", placemark.thoroughfare, placemark.subThoroughfare]];
//    [self setTitle:[NSString stringWithFormat:@"%@ %@", placemark.locality, placemark.subLocality]];
//    [self initUI];
//}
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
//{
//    DLog(@"%@",[error description]);
//}


#pragma mark- custom methods
- (void)prepareData
{
    [self addAnnotation];
}

- (void)addAnnotation
{
    _shopAnnotationArray = [[NSMutableArray alloc] init];
    for (Shop *shop in self.shopArray) {
        BaiduShopAnnotation *shopAnnotation = [[BaiduShopAnnotation alloc]initWithShopInfo:shop];
//        CLLocationCoordinate2D coor1;
//        coor1.latitude = shop.latitude;
//        coor1.longitude = shop.longitude;
//        shopAnnotation.coordinate = coor1;
//        ShopAnnotation *shopAnnotation = [[ShopAnnotation alloc] initWithShopInfo:shop];
//        [shopAnnotation setTitle:shop.shop_name];
//        [shopAnnotation setSubtitle:shop.shop_address];
        [_shopAnnotationArray addObject: shopAnnotation];
//        [shopAnnotation release];
    }
}


- (void)initUI
{
    [self setTitle:@"地图"];
    [super changeTitleView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    [_cityLabel setText:[[CoreService sharedCoreService] getCurrentAddress]];
    [_cityLabel setBackgroundColor:[UIColor blackColor]];
    

    
//    [_mapView setRegion:MKCoordinateRegionMake(myCurrentLocation.coordinate, MKCoordinateSpanMake(Discrepancy, Discrepancy)) animated:YES];
//    [_mapView setShowsUserLocation:YES];
//    [_mapView.userLocation setTitle:@"当前位置"];
    
//    [_mapView addAnnotations:_shopAnnotationArray];

    
    _baiduMapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [_baiduMapView setDelegate:self];
    [_baiduMapView setMapType:BMKMapTypeStandard];
    [_baiduMapView setShowsUserLocation:YES];
    [_baiduMapView.userLocation setTitle:@"当前位置"];
    
    if (IS_IPHONE_5) {
        CGRect frame = _baiduMapView.frame;
        frame.size.height+=88;
        [_baiduMapView setFrame: frame];
    }
    [self.view addSubview:_baiduMapView];
    [_baiduMapView addAnnotations:_shopAnnotationArray];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goIntoShopDetail:(UIButton *)sender
{
    for (Shop *shop in self.shopArray) {
        if ([shop.shop_id isEqualToString:[NSString stringWithFormat:@"%d", sender.tag]]) {
            ShopDetailsViewController *vc = [[[ShopDetailsViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [vc setShop:shop];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

- (void)setMapCenter:(CLLocationCoordinate2D)centerCoordinate
{
//    MKCoordinateRegion centerRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, RegionWidth, RegionHeight);
//    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:centerRegion];
    
    BMKCoordinateRegion centerRegion= BMKCoordinateRegionMakeWithDistance(centerCoordinate, RegionWidth, RegionHeight);
    [_baiduMapView setRegion:centerRegion animated:YES];
    [_baiduMapView setCenterCoordinate:centerCoordinate];
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view isKindOfClass:[CalloutMapAnnotationView class]]) {
//        CalloutMapAnnotation *calloutMapAnnotation = (CalloutMapAnnotation *)view.annotation;
        ShopDetailsViewController *vc = [[[ShopDetailsViewController alloc] init] autorelease];
        [vc.navigationItem setHidesBackButton:YES];
        [vc setShop:_calloutMapAnnotation.shop];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([view.annotation isKindOfClass:[BaiduShopAnnotation class]]){
        BaiduShopAnnotation *annn = (BaiduShopAnnotation *)view.annotation;

        if (_calloutMapAnnotation) {
            [mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation=nil;
        }
        _calloutMapAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude];
        _calloutMapAnnotation.shop = annn.shop;
        [mapView addAnnotation:_calloutMapAnnotation];
        [mapView setCenterCoordinate:annn.coordinate];
    }
    
    
}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    DLog(@"annotationViewForBubble");
}

-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    DLog(@"didDeselectAnnotationView");
    [mapView removeAnnotation:_calloutMapAnnotation];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *annotationIndentifier;
    if ([annotation isKindOfClass:[BaiduShopAnnotation class]]) {
        annotationIndentifier = @"shopIdentifier";
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIndentifier];
        
        NSString *annotationIndentifier;
        if (annotation == mapView.userLocation) {
            return  nil;
        }else{
            annotationIndentifier = @"shopIdentifier";
            
            if (!annotationView) {
                annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIndentifier];
                annotationView.enabled = TRUE;
                [annotationView setAnnotation:annotation];
                CGRect frame = annotationView.frame;
                frame.size = CGSizeMake(20, 32);
                annotationView.frame = frame;
                [annotationView setImage:[UIImage imageNamed:@"pin"]];
                [annotationView setCanShowCallout:NO];
                return annotationView;
            }
            
        }
    }else if ([annotation isKindOfClass:[CalloutMapAnnotation class]]){
        annotationIndentifier = @"CallOutAnnotationIdentifier";
        CalloutMapAnnotation *ann = (CalloutMapAnnotation *)annotation;
        CalloutMapAnnotationView *calloutAnnotationView = (CalloutMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIndentifier];
        
        if(!calloutAnnotationView){
            calloutAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIndentifier] autorelease];
        }
        [calloutAnnotationView applyWithShop:ann.shop];
        return calloutAnnotationView;
    }
    return nil;
}

@end
