//
//  CustomTabBarController.m
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CustomTabBarController.h"
#import "AppDelegate.h"


#define BUTTON_COUNT        4

#define YOFFSET IS_IPHONE_5 ? 518 : 430

@interface CustomTabBarController () {
    UIImageView     *tabbarBg;
    UIImageView     *slideBg;
    UIImageView     *selectedTab;
    NSUInteger      currentSelectedIndex;
    
    NSInteger       lastLocatIndex;
}

@property (nonatomic, strong) NSMutableArray *tabButtons;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, strong) NSCountedSet *tabClickCountSet;
@property (nonatomic, strong) NSArray  *newTagIndexArray;

@end

@implementation CustomTabBarController

- (void)dealloc
{
    [_newTagIndexArray release];
    [tabbarBg release];
    [slideBg release];
    [selectedTab release];
    
    [_tabButtons release], _tabButtons = nil;
    [_imageViewArray release], _imageViewArray = nil;
    [_tabClickCountSet release], _tabClickCountSet = nil;
    
    [super dealloc];
}

- (void)initImageViewArray
{
    NSUInteger viewCount = MIN([self.viewControllers count], BUTTON_COUNT);
    self.imageViewArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<viewCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 32, 0, 34, 25)];
        
        [imageView setImage:[UIImage imageNamed:@"icon_new"]];
        [imageView setHidden:YES];
        [[self imageViewArray] addObject:imageView];
        [imageView release];
    }
}

- (void)showNewIconByIndexArray:(NSArray *)indexArray
{
    for(NSString *index in indexArray)
    {
        [[[self imageViewArray] objectAtIndex:[index integerValue]] setHidden:NO];
    }
}

- (void)hideBtnWhenBeTapped:(NSUInteger)index{
    [[[self imageViewArray] objectAtIndex:index] setHidden:YES];
}



- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults boolForKey:NotRecallTabbar]) {
        [userDefaults setBool:NO forKey:NotRecallTabbar];
    } else {
        slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_bg"]];
//        tabbarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_bar_bg"]];
        tabbarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [tabbarBg setBackgroundColor:[UIColor blackColor]];
        selectedTab = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        
        [self setTabClickCountSet:[[[NSCountedSet alloc] init] autorelease]];
        [self initImageViewArray];
        [self hideRealTabBar];
        [self customTabBar];
    }
    [self resumeState];
}

- (void)hideRealTabBar
{
    [self.tabBar setHidden:YES];
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            view.hidden = YES;
            break;
        }
    }
}

- (void)customTabBar
{
    [slideBg addSubview:selectedTab];
    [tabbarBg setFrame:CGRectMake(0, YOFFSET, 320, 50 )];
    [slideBg setFrame:CGRectMake(0, YOFFSET, 80, 50)];
    [self.view addSubview:tabbarBg];
    
    //创建按钮
    NSUInteger viewCount = MIN([self.viewControllers count], BUTTON_COUNT);
    self.tabButtons = [[NSMutableArray alloc] initWithCapacity:viewCount];
    double _width = viewCount == 0 ? 0 : 320 / viewCount;
    double _height = self.tabBar.frame.size.height;
    for (NSUInteger index = 0; index < viewCount; index++) {
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect rect = CGRectMake(index*_width,self.tabBar.frame.origin.y, _width, _height);
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tab_button%d_normal", index + 1]];
        [tabButton setFrame:rect];
        [tabButton setBackgroundImage:image forState:UIControlStateNormal];
        [tabButton setBackgroundImage:image forState:UIControlStateHighlighted];
        [tabButton addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [tabButton setTag:index];
        [tabButton addSubview:[[self imageViewArray] objectAtIndex:index]];
        [self.view addSubview:tabButton];
        [_tabButtons addObject:tabButton];
    }
    [self.view addSubview:slideBg];
    UIImageView *imgFront = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabitem.png"]];
    imgFront.frame = tabbarBg.frame;
    [self.view addSubview:imgFront];
    [imgFront release];
    [self selectedTab:[_tabButtons objectAtIndex:0]];
}

- (void)addTabClickCount:(NSUInteger)index
{
    id object = [[self tabButtons] objectAtIndex:index];
    [[self tabClickCountSet] addObject:object];
}

- (NSUInteger)getTabClickCount:(NSUInteger)index
{
    id object = [[self tabButtons] objectAtIndex:index];
    return [[self tabClickCountSet] countForObject:object];
}

- (void)selectedTab:(UIButton *)button
{
    if (currentSelectedIndex == button.tag) {
    }
    currentSelectedIndex = button.tag;
    self.selectedIndex = currentSelectedIndex;
    [self hideBtnWhenBeTapped:currentSelectedIndex];
    [self performSelector:@selector(slideTabBg:) withObject:button];
    [self.selectedViewController.navigationController popToRootViewControllerAnimated:NO];
}

- (void)setSelectedTab:(NSUInteger)index
{
    currentSelectedIndex = index;
    self.selectedIndex = currentSelectedIndex;
    [self slideTabBgAnimation:index];
}

- (void)setSelectedTabWithoutAnimation:(NSUInteger)index
{
    currentSelectedIndex = index;
    self.selectedIndex = currentSelectedIndex;
    slideBg.frame = CGRectMake(self.selectedIndex * 80, YOFFSET, 80, 50);
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tab_button%d_selected", index + 1]];
    [selectedTab setImage:image];
    [self addTabClickCount:index];
}

- (void)slideTabBg:(UIButton *)btn
{
    [self slideTabBgAnimation:[btn tag]];
}


- (void)slideTabBgAnimation:(NSUInteger)index
{
    [UIView animateWithDuration:.2
                     animations:^{
                         slideBg.frame = CGRectMake(self.selectedIndex * 80, YOFFSET, 80, 50);
                         UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tab_button%d_selected", index + 1]];
                         [selectedTab setImage:image];
                     } completion:^(BOOL finished) {
                         [self addTabClickCount:index];
                     }];
    
}



- (UIViewController *)currentViewController
{
    return [[self viewControllers] objectAtIndex:currentSelectedIndex];
}

- (void) saveState:(NSInteger)locatIndex withNewTagIndexArray:(NSArray *)indexArray
{
    lastLocatIndex = locatIndex;
    
    self.newTagIndexArray = indexArray;
}

- (void)resumeState
{
    if (_newTagIndexArray && [_newTagIndexArray count]>0) {
        [self showNewIconByIndexArray:_newTagIndexArray];
        self.newTagIndexArray = nil;
    }
    if (lastLocatIndex != -1) {
        [self setSelectedTabWithoutAnimation:lastLocatIndex];
        lastLocatIndex = -1;
    }
}


@end
