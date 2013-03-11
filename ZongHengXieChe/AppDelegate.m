//
//  AppDelegate.m
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNavigationBar.h"
#import "CustomTabBarController.h"
#import "MyAccountViewController.h"
#import "BookingViewController.h"
#import "SettingViewController.h"
#import "MoreViewController.h"
#import "CoreService.h"

@interface AppDelegate()
@property (nonatomic, strong) CustomNavigationBar *customNavigationBar;
@property (nonatomic, strong) CustomTabBarController  *tabbarController;

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.autoresizesSubviews = YES;
    
    self.tabbarController = [[[CustomTabBarController alloc] init] autorelease];
    self.tabbarController.viewControllers = [self prepareViewControllers];
    
    self.window.rootViewController = self.tabbarController;

    [[CoreService sharedCoreService] startLocationManger];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark- custom methods
- (void)initNavigationBar
{
    

}

- (UINavigationController *)customizedNavigationController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithNibName:nil bundle:nil];
    
    // Ensure the UINavigationBar is created so that it can be archived. If we do not access the
    // navigation bar then it will not be allocated, and thus, it will not be archived by the
    // NSKeyedArchvier.
    [navController navigationBar];
    
    // Archive the navigation controller.
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:navController forKey:@"root"];
    [archiver finishEncoding];
    [archiver release];
    [navController release];
    
    // Unarchive the navigation controller and ensure that our UINavigationBar subclass is used.
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [unarchiver setClass:[CustomNavigationBar class] forClassName:@"UINavigationBar"];
    UINavigationController *customizedNavController = [unarchiver decodeObjectForKey:@"root"];
    [unarchiver finishDecoding];
    [unarchiver release];
    
    // Modify the navigation bar to have a background image.
    CustomNavigationBar *navBar = (CustomNavigationBar *)[customizedNavController navigationBar];
    
    [navBar setTintColor:[UIColor colorWithRed:1 green:0.95 blue:0.93 alpha:1.0]];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //    [navBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-bg-landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
    
    return customizedNavController;
}


- (NSArray *)prepareViewControllers
{
    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
    
    MyAccountViewController *viewController1 = [[[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil] autorelease];
    viewController1.view.frame = viewBounds;
    
    BookingViewController *viewController2 = [[[BookingViewController alloc] initWithNibName:@"BookingViewController" bundle:nil] autorelease];
    SettingViewController *viewController3 = [[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil] autorelease];
    MoreViewController    *viewController4 = [[[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil] autorelease];
    
    NSArray *viewControllerArray = [NSArray arrayWithObjects:viewController1, viewController2, viewController3, viewController4, nil];
    NSMutableArray *navControllerArray = [NSMutableArray array];
    
    for (UIViewController *viewController in viewControllerArray) {
        [viewController setHidesBottomBarWhenPushed:YES];
        
        UILabel *titleView = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)] autorelease];
        [titleView setTextColor:[UIColor whiteColor]];
        
//        UINavigationController *navController = [self customizedNavigationController];
        UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
        CustomNavigationBar *navBar = (CustomNavigationBar *)[navController navigationBar];
        [navBar setFrame:CGRectMake(0, 0, 320, 40)];
        [navBar setTintColor:[UIColor colorWithRed:1 green:0.95 blue:0.93 alpha:1.0]];
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
        
        [[navController navigationItem] setTitleView:titleView];
        [navController setViewControllers:[NSArray arrayWithObject:viewController]];
        
        [navControllerArray addObject:navController];
    }
    return [NSArray arrayWithArray:navControllerArray];
}


@end
