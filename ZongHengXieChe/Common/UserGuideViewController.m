//
//  UserGuideViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "UserGuideViewController.h"

@interface UserGuideViewController ()
{
    IBOutlet    UIScrollView    *_scrollView;
    NSMutableArray  *_imageNameArray;
}

@end

@implementation UserGuideViewController

- (void)dealloc
{
    [_imageNameArray release];
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

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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

- (void)prepareData
{
    _imageNameArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i=0; i<3; i++) {
        NSString *imageName = @"";
        if(IS_IPHONE_5){
            imageName = [NSString stringWithFormat:@"guide_%d_i5",i];
        }else{
            imageName = [NSString stringWithFormat:@"guide_%d",i];        
        }
        [_imageNameArray addObject:imageName];
    }
}


- (void)initUI
{
    if(IS_IPHONE_5){
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height += 88;
        [self.view setFrame: viewFrame];
    }
    CGRect frame = self.view.frame;
    _scrollView.frame = frame;
    [_scrollView setContentSize:CGSizeMake(320*_imageNameArray.count, frame.size.height)];
    for ( NSInteger i=0; i<_imageNameArray.count; i++) {
        NSString *imageName = [_imageNameArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, 320, frame.size.height)];
        [imageView setImage:[UIImage imageNamed:imageName]];
        [_scrollView addSubview:imageView];
        [imageView release];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((_imageNameArray.count-1)*320+85, frame.size.height-60, 150, 44)];
    if (IS_IPHONE_5) {
        [btn setFrame:CGRectMake((_imageNameArray.count-1)*320+85, frame.size.height-95, 150, 44)];
    }
    [btn setImage:[UIImage imageNamed:@"guide_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
}

- (void)start
{
    
    [self dismissModalViewControllerAnimated:NO];
//    [self.view removeFromSuperview];
}
@end
