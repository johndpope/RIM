//
//  DelayTableViewController.m
//  RIM
//
//  Created by Michael Gehringer on 9/1/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import "DelayTableViewController.h"

@interface DelayTableViewController ()
@property (nonatomic, retain) IBOutlet UIButton *btnDelay;
@property (nonatomic, retain) IBOutlet UISwitch *swcDelay;
@property (nonatomic, retain) IBOutlet UILabel *lblDelay;
@property (nonatomic, retain) IBOutlet UILabel *lblDelayTime;
@property (nonatomic, retain) IBOutlet UITextField *txtActReportTime;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segDelayHours;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcDelay;
@end
@implementation DelayTableViewController



@synthesize btnReportTime,btnReportTimetxt,popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 70;
    if ([User sharedUser].BolswcDelay == NO) {
        [User sharedUser].DelayActReport = [User sharedUser].ReportTime;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    self.txtActReportTime.text = [dateFormat stringFromDate:[User sharedUser].DelayActReport];
//    btnReportTimetxt = [[UIBarButtonItem alloc] initWithTitle:@"Actual Report Time [LCL]:" style:UIBarButtonItemStylePlain target:self action:@selector(setReporttimetxt:)];
//    btnReportTime = [[UIBarButtonItem alloc] initWithTitle:@"00:00" style:UIBarButtonItemStylePlain target:self action:@selector(showPicker:)];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnReportTime,btnReportTimetxt, nil]];
////    btnReportTime.title = [[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursUTC,(long)intMinutesUTC]stringByAppendingString:@""];
//    btnReportTime.title = [dateFormat stringFromDate:[User sharedUser].DelayActReport];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.txtActReportTime)
    {
        [self showPicker:self];
        return NO;
    }
    return NO;
}

- (IBAction)showPicker:(id)sender
{
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor clearColor];
    _datePicker=[[UIDatePicker alloc]init];//Date picker
    _datePicker.frame=CGRectMake(0,44,320, 200);
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(changeDateFromLabel:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    [popoverView addSubview:toolBar];

    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_datePicker setMinuteInterval:1];
    [_datePicker setTag:10];
    [_datePicker addTarget:self action:@selector(result) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [_datePicker setDate:[User sharedUser].DelayActReport];
    [popoverView addSubview:_datePicker];
    popoverContent.view = popoverView;
    CGRect myFrame =self.txtActReportTime.frame;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 200) animated:NO];
    [popoverController presentPopoverFromRect:myFrame inView:self.tblvcDelay permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
-(void)changeDateFromLabel:(id)sender
{
    [popoverController dismissPopoverAnimated:YES];
    [self result];
}
-(void) result

{
    [User sharedUser].DelayActReport = _datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    self.txtActReportTime.text = [[dateFormat stringFromDate:[User sharedUser].DelayActReport]stringByAppendingString:@""];
    [StartFDPTableViewController calcLimitingFDP];
    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsDelay = [gregorian components:unitFlags fromDate:[User sharedUser].DelayActReport];
    NSInteger hourDelay = [compsDelay hour];
    NSInteger minDelay = [compsDelay minute];
    NSInteger intDelayActReportTime = ((hourDelay*60)+minDelay)*60;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger intReportTime = ((hour*60)+min)*60;
    if (intDelayActReportTime - intReportTime >= 14400) {
        self.segDelayHours.selectedSegmentIndex = 1;
        [self enableActDelay];
    }
    else {
        self.segDelayHours.selectedSegmentIndex = 0;
        [self enableActDelay];
    }
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:[[self tabBarController] viewControllers]];
    [[self tabBarController] setViewControllers:controllers animated:YES];
    //    [self displayMaxFDPBatchvalue];
    //    [StartFDPTableViewController displayResults];
    //    [self updateFields];
    
}
- (IBAction)setReporttimetxt:(id)sender
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)infoDelay:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Delayed Reporting"
                          message:@"When a crew member is informed of a delay to reporting time due to a changed schedule, before leaving the place of rest, the FDP shall be calculated as follows:"
                          @"a. When the delay is less than 4 hours, the maximum FDP shall be based on the original report time and the FDP shall start at the actual report time."
                          @"b. When the delay is 4 hours or more, the maximum FDP shall be based on the more limiting time band of the planned and the actual report time and the FDP starts 4 hours after the original report time."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
}
- (IBAction)switchDelay:(id)sender
{
    if (self.swcDelay.on == YES) {
        //segDelayHours.enabled = YES;
        self.btnDelay.enabled = YES;
        self.lblDelay.enabled = YES;
        self.segDelayHours.enabled = YES;
        self.txtActReportTime.textColor = [UIColor darkGrayColor];
        self.txtActReportTime.enabled = YES;
        //		self.tabDelay.badgeValue = @"ON";
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 2] tabBarItem] setBadgeValue:@"ON"];
        self.tblvcDelay.userInteractionEnabled = YES;
//        self.tblvcDelay.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.segDelayHours.selectedSegmentIndex = 0;
        //		self.tabDelay.title = @"Delay <4hrs";
        [User sharedUser].BolswcDelay = YES;
        [StartFDPTableViewController calcLimitingFDP];
        
        unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *compsDelay = [gregorian components:unitFlags fromDate:[User sharedUser].DelayActReport];
        NSInteger hourDelay = [compsDelay hour];
        NSInteger minDelay = [compsDelay minute];
        NSInteger intDelayActReportTime = ((hourDelay*60)+minDelay)*60;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
        NSInteger hour = [comps hour];
        NSInteger min = [comps minute];
        NSInteger intReportTime = ((hour*60)+min)*60;
        if (intDelayActReportTime - intReportTime >= 14400) {
            self.segDelayHours.selectedSegmentIndex = 1;
            [self enableActDelay];
        }
        else {
            self.segDelayHours.selectedSegmentIndex = 0;
            [self enableActDelay];
        }

//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
        
    }
    else {
        //segDelayHours.enabled = NO;
        self.btnDelay.enabled = NO;
        self.lblDelay.enabled = NO;
        self.segDelayHours.enabled = NO;
        self.txtActReportTime.textColor = [UIColor lightGrayColor];
        self.txtActReportTime.enabled = NO;
        //		self.tabDelay.badgeValue = nil;
        //		self.tabDelay.title = @"Delay";
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 2] tabBarItem] setBadgeValue:NO];
        self.tblvcDelay.userInteractionEnabled = NO;
//        self.tblvcDelay.accessoryType = UITableViewCellAccessoryNone;
        [User sharedUser].BolswcDelay = NO;
        self.segDelayHours.selectedSegmentIndex = 0;
        [User sharedUser].BolDelayMore4 = NO;
        [StartFDPTableViewController calcLimitingFDP];
        
        unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *compsDelay = [gregorian components:unitFlags fromDate:[User sharedUser].DelayActReport];
        NSInteger hourDelay = [compsDelay hour];
        NSInteger minDelay = [compsDelay minute];
        NSInteger intDelayActReportTime = ((hourDelay*60)+minDelay)*60;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
        NSInteger hour = [comps hour];
        NSInteger min = [comps minute];
        NSInteger intReportTime = ((hour*60)+min)*60;
        if (intDelayActReportTime - intReportTime >= 14400) {
            self.segDelayHours.selectedSegmentIndex = 1;
            [self enableActDelay];
        }
        else {
            self.segDelayHours.selectedSegmentIndex = 0;
            [self enableActDelay];
        }

//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
    }
    
}

- (void)enableActDelay
{
    if (self.segDelayHours.selectedSegmentIndex == 0) {
        self.btnDelay.enabled = YES;
        self.lblDelay.enabled = YES;
        self.txtActReportTime.textColor = [UIColor darkGrayColor];
        
        //txtActReportTime.enabled = YES;
        //		self.tabDelay.title = @"Delay <4hrs";
        [User sharedUser].BolDelayMore4 = NO;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
    }
    else {
        self.btnDelay.enabled = YES;
        self.lblDelay.enabled = YES;
        self.txtActReportTime.textColor = [UIColor darkGrayColor];
        
        //txtActReportTime.enabled = YES;
        //		self.tabDelay.title = @"Delay >=4hrs";
        [User sharedUser].BolDelayMore4 = YES;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    self.swcDelay.on = [User sharedUser].BolswcDelay;
    if (self.swcDelay.on == YES) {
        self.txtActReportTime.textColor = [UIColor darkGrayColor];
        self.txtActReportTime.enabled = YES;
        
    }else {
        self.txtActReportTime.textColor = [UIColor lightGrayColor];
        self.txtActReportTime.enabled = NO;
    }
    self.segDelayHours.selectedSegmentIndex = [User sharedUser].IntsegDelayHours;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    self.txtActReportTime.text = [[dateFormat stringFromDate:[User sharedUser].DelayActReport] stringByAppendingString:@""];
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsDelay = [gregorian components:unitFlags fromDate:[User sharedUser].DelayActReport];
    NSInteger hourDelay = [compsDelay hour];
    NSInteger minDelay = [compsDelay minute];
    NSInteger intDelayActReportTime = ((hourDelay*60)+minDelay)*60;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger intReportTime = ((hour*60)+min)*60;
    if (intDelayActReportTime - intReportTime >= 14400) {
        self.segDelayHours.selectedSegmentIndex = 1;
        [self enableActDelay];
    }
    else {
        self.segDelayHours.selectedSegmentIndex = 0;
        [self enableActDelay];
    }
//    	[StartFDPTableViewController calcLimitingFDP];
//    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//    //	[strMaxFDP release];
//    NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
//    
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    //	self.tabDelay = nil;
    self.btnDelay = nil;
    self.lblDelay = nil;
    self.swcDelay = nil;
    self.txtActReportTime = nil;
    self.segDelayHours = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
