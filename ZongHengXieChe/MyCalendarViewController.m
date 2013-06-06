//
//  MyCalendarViewController.m
//  MyCalendar
//
//  Created by Shaokun Wu on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyCalendarViewController.h"
#import "InfoViewController.h"
#import "CarDetailsViewController.h"
#import "CoreService.h"
#import "Ordering.h"
#import "TimeSale.h"

@interface MyCalendarViewController ()
{
    IBOutlet    UIPickerView    *_picker;
    IBOutlet    UIView          *_pickerView;
    
    IBOutlet    UIView          *_tipView;
}

@property (nonatomic, strong) NSMutableArray *hoursArray;
@property (nonatomic, strong) NSMutableArray *minutesArray;
@property (nonatomic, strong) NSString       *dateString;
@property (nonatomic, strong) NSString       *hour;
@property (nonatomic, strong) NSString       *minute;

@end
@implementation MyCalendarViewController

- (BOOL)isBeforeToday:(NSDate *)date
{
    NSDate *now = [NSDate date];
    return [now timeIntervalSinceDate:date]>0;
}

- (BOOL)isAfter4
{
    NSDate *now = [NSDate date];
    return [self getHour:now]>16;
}

- (BOOL)isTomorrow:(NSDate *)date
{
    NSInteger today = [self getDay:[NSDate date]];
    NSInteger selectedDay = [self getDay:date];
    
    return (selectedDay-today)==1;
}

- (void)calendarViewDateSelected:(CalendarView *)calendarView date:(NSDate *)date {
    
    Ordering *myOrdering = [[CoreService sharedCoreService] myOrdering];
    TimeSale *timesale = myOrdering.selectedTimeSale;

    NSInteger week = [self getWeekday:date];
    if (week -1 >=0) {
        week -=1;
    }else{
        week = 6; 
    }
    
    
    if ([self isBeforeToday:date]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"不能选择过去的时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    if ([self getTimeInterval:date]>15*24*3600) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"该店只接受15天之内的预约" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    if ([timesale.week rangeOfString:[NSString stringWithFormat:@"%d",week]].location == NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"当天该店不接受预约" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    if ([self isAfter4]) {
        if([self isTomorrow:date]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"4点之后需要隔天预约" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    [formatter release];
    
    [_pickerView setHidden:NO];
    

    
//    NSLog(@"%@", date);
}

- (NSInteger)getTimeInterval:(NSDate *)date
{
    NSDate *now = [NSDate date];
    NSInteger interval = [date timeIntervalSinceDate:now ];
    return interval;
    
}


- (NSInteger)getWeekday:(NSDate *)date
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *weekDayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
	NSInteger weekday = [weekDayComponents weekday];
    
    
//    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
//    NSInteger weekday = [componets weekday];
    return weekday;
}

- (NSInteger)getHour:(NSDate *)date
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *weekDayComponents = [gregorian components:NSHourCalendarUnit fromDate:date];
	NSInteger hour = [weekDayComponents hour];
    return hour;
}

- (NSInteger)getDay:(NSDate *)date
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *weekDayComponents = [gregorian components:NSDayCalendarUnit fromDate:date];
	NSInteger day = [weekDayComponents day];
    return day;
}


- (void)dealloc
{
//    [calendarView release];
    [_dateString release];
    [_hoursArray release];
    [_minutesArray release];
    [_hour release];
    [_minute release];
//    [selectedDateLabel release];
//    [selectedYearLabel release];
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
    
    [self.view insertSubview:calendarView belowSubview:_pickerView];
    
    selectedYearLabel.text = [NSString stringWithFormat:@"%d年%d月", calendarView.selectedYear, calendarView.selectedMonth];
    [self prepareData];
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
//    NSLog(@"%@", keyPath);
    selectedYearLabel.text = [NSString stringWithFormat:@"%d年 %d月", calendarView.selectedYear, calendarView.selectedMonth];
}

#pragma mark- picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.hoursArray.count;
    }
    if (component == 1){
        return  self.minutesArray.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.hoursArray objectAtIndex:row];
    }
    if (component == 1){
        return  [self.minutesArray objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.hour = [self.hoursArray objectAtIndex:row];
        [self refreshMinutesArray:[self.hour integerValue]];
    }
    if (component == 1) {
        self.minute = [self.minutesArray objectAtIndex:row];
        selectedDateLabel.text = [NSString stringWithFormat:@"%@ %@:%@", self.dateString, self.hour, self.minute];
    }
    
}

- (void)refreshMinutesArray:(NSInteger)selectedhour
{
    self.minutesArray = [[[NSMutableArray alloc] init] autorelease];
    Ordering *ordering = [[CoreService sharedCoreService] myOrdering];
    TimeSale *timesale = ordering.selectedTimeSale;
    NSString *beginTime = timesale.begin_time;
    NSString *endTime = timesale.end_time;
    NSInteger beginHour = [[[beginTime componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
    NSInteger endHour = [[[endTime componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
    NSInteger beginMinutes = [[[beginTime componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
    NSInteger endMinutes = [[[endTime componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
    
    NSInteger minMinutes = 00;
    NSInteger maxMinutes = 50;
    if (selectedhour == beginHour) {
        minMinutes = beginMinutes;
    }
    if (selectedhour == endHour) {
        maxMinutes = endMinutes;
    }
    
    if (selectedhour != endHour && maxMinutes !=00) {
        if (minMinutes == maxMinutes) {
            [self.minutesArray addObject:[NSString stringWithFormat:@"%02d",0]];
        }
    }
    
    
    
    for (int minutes = minMinutes; minutes<=maxMinutes; minutes+=10) {
        [self.minutesArray addObject:[NSString stringWithFormat:@"%02d",minutes]];
    }
    [_picker reloadComponent:1];
    self.minute = [self.minutesArray objectAtIndex:0];
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
    
    if (IS_IPHONE_5) {
        CGRect  frame = _tipView.frame;
        frame.origin.y += 88;
        _tipView.frame = frame;
    }
}

- (void)prepareData
{
    self.hoursArray = [[[NSMutableArray alloc] init] autorelease];
    self.minutesArray = [[[NSMutableArray alloc] init] autorelease];
    
    Ordering *ordering = [[CoreService sharedCoreService] myOrdering];
    TimeSale *timesale = ordering.selectedTimeSale;
    NSString *beginTime = timesale.begin_time;
    NSString *endTime = timesale.end_time;
    NSInteger beginHour = [[[beginTime componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
    NSInteger endHour = [[[endTime componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
    
    NSInteger minInitMinites = [[[beginTime componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];

    
    for (int hour = beginHour; hour <= endHour;  hour++ ) {
        [self.hoursArray addObject:[NSString stringWithFormat:@"%2d",hour]];
    }
    self.hour = [NSString stringWithFormat:@"%2d",beginHour];
    for (int minutes = minInitMinites; minutes<60; minutes+=10) {
        [self.minutesArray addObject:[NSString stringWithFormat:@"%02d",minutes]];
    }
    self.minute = [NSString stringWithFormat:@"%02d",minInitMinites];
}

- (IBAction)next
{
    if (!self.dateString) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"请选择预约时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    Ordering *myOrdering = [[CoreService sharedCoreService] myOrdering];
    [myOrdering setOrder_date:self.dateString];
    [myOrdering setOrder_hours:self.hour];
    [myOrdering setOrder_minute:self.minute];
    
    InfoViewController *vc = [[[InfoViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)timeSelected:(UIButton *)sender {
    [_pickerView setHidden:YES];
    selectedDateLabel.text = [NSString stringWithFormat:@"%@ %@:%@", self.dateString, self.hour, self.minute];
}
@end
