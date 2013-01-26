//
//  BaseViewController.m
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "XMLReader.h"
#import <objc/runtime.h>
#import "Shop.h"
#import "GDataXMLNode.h"

#define MaxConcurrentOperationCount 3


@interface BaseViewController ()
@property (nonatomic, strong) ASINetworkQueue  *networkQueue;

@end

@implementation BaseViewController

- (void)dealloc
{
    if (self.networkQueue) {
        [self.networkQueue cancelAllOperations];
        [self.networkQueue release];
    }
    
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark- custom methods
- (void)changeTitleView
{
    UIView *titleView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    if (_titleImage) {
        [_titleImage setFrame:CGRectMake(0, 0, 320, 44)];
        [titleView addSubview:_titleImage];
    } else {
        UILabel *lblView = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)] autorelease];
        //        [lblView setBackgroundColor:[UIColor colorWithRed:1 green:0.95 blue:0.93 alpha:1.0]];
        [lblView setBackgroundColor:[UIColor clearColor]];
        [lblView setTextColor:[UIColor redColor]];
        [lblView setTextAlignment:UITextAlignmentCenter];
        [lblView setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        [lblView setText:[self title]];
        [titleView addSubview:lblView];
        [lblView setCenter:[titleView center]];
    }
    
    [[self navigationItem] setTitleView:titleView];
}

- (void)loadHttpURL:(NSString *)urlString withParams:(NSMutableDictionary *)dic withCompletionBlock:(void (^)(id data))completionHandler withErrorBlock:(void (^)(NSError *error))errorHandler
{
    if (!self.networkQueue) {
        self.networkQueue = [[ASINetworkQueue alloc] init];
        [self.networkQueue setMaxConcurrentOperationCount:MaxConcurrentOperationCount];
        [self.networkQueue setShouldCancelAllRequestsOnFailure:NO];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIHTTPRequest *request;
    if (dic && [dic.allKeys count]>0) {
        request = [ASIFormDataRequest requestWithURL:url];
        for (NSString *key in dic.allKeys) {
            [request setValue:[dic objectForKey:key] forKey:key];
        }
    }else{
        request = [ASIHTTPRequest requestWithURL:url];
    }
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        DLog(@"%d",[self.networkQueue operationCount]);
        completionHandler(responseString);
    }];

    [request setFailedBlock:^{
        NSError *error = [request error];
        errorHandler(error);
    }];
    [self.networkQueue addOperation:request];
    DLog(@"%d",[self.networkQueue operationCount]);
    
    if ([self.networkQueue isSuspended]) {
        [self.networkQueue go];
    }
}

- (NSMutableArray *)getPropertyList:(Class)clazz
{
    NSMutableArray *propertyArray = [[[NSMutableArray alloc] init] autorelease];
    unsigned int nCount;
    objc_property_t *properties = class_copyPropertyList(clazz, &nCount);
    for (int i = 0; i < nCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",property_getName(property)];
        [propertyArray addObject:propertyName];
        DLog(@"class name is = %s && attr = %s", property_getName(property), property_getAttributes(property));
    }
    return propertyArray;
}


- (NSMutableArray *)convertXml2Obj:(NSString *)xmlString withClass:(Class)clazz
{
    NSMutableArray *objectArray = [[[NSMutableArray alloc] init] autorelease];
    NSError *error;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:1 error:&error];
    GDataXMLElement *rootElement = [document rootElement];
    DLog(@"rootElement name = %@ , childrenCount = %d", [rootElement name], [rootElement childCount]);

    NSArray *childrenArray = [rootElement children];
    for (GDataXMLElement *childElement in childrenArray) {
        id obj = [[clazz alloc] init];
        NSMutableArray *propertyList = [self getPropertyList:clazz];
        for (NSString *propertyName in propertyList) {
            id propertyValue = [[[childElement elementsForName:propertyName] objectAtIndex:0]stringValue];
            [obj setValue:propertyValue forKey:propertyName];
        }
        [objectArray addObject:obj];
        [obj release];
    }
    return objectArray;
}



@end
