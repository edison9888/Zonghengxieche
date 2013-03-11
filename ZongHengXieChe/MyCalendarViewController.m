//
//  MyCalendarViewController.m
//  MyCalendar
//
//  Created by Shaokun Wu on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyCalendarViewController.h"
#import "InfoViewController.h"
@implementation MyCalendarViewController

- (void)calendarViewDateSelected:(CalendarView *)calendarView date:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-M-DD"];
    
    selectedDateLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    [formatter release];
//    NSLog(@"%@", date);
}

- (void)dealloc
{
    [calendarView release];
    [selectedDateLabel release];
    [selectedYearLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CalendarView" owner:nil options:nil];

    for (id currentObject in objects) {
        if ([currentObject isKindOfClass:[CalendarView class]]) {
            calendarView = (CalendarView *)currentObject;
            CGRect frame = calendarView.frame;
            frame.origin.y = 53;
            calendarView.frame = frame;
            calendarView.delegate = self;
            
            [calendarView addObserver:self forKeyPath:@"selectedMonth" options:NSKeyValueObservingOptionNew context:nil];

            [calendarView addObserver:self forKeyPath:@"selectedYear" options:NSKeyValueObservingOptionNew context:nil];
            break;
        }
    }

    [self.view addSubview:calendarView];
    
    selectedYearLabel.text = [NSString stringWithFormat:@"%d年", calendarView.selectedYear];

    [self initUI];
}

- (void)viewDidUnload
{
    [selectedDateLabel release];
    selectedDateLabel = nil;
    [selectedYearLabel release];
    selectedYearLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@", keyPath);
    selectedYearLabel.text = [NSString stringWithFormat:@"Year of %d", calendarView.selectedYear];
}

#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"2/3 时间选择"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
}

- (IBAction)next
{
    InfoViewController *vc = [[[InfoViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
