//
//  StandByTableViewController.m
//  RIM
//
//  Created by Michael Gehringer on 9/1/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import "StandByTableViewController.h"

@interface StandByTableViewController ()

@end

@implementation StandByTableViewController

@synthesize btnReportTime,btnReportTimetxt,popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 70;
    if ([User sharedUser].BolswcStandby == NO) {
        [User sharedUser].SBYBegin = [User sharedUser].ReportTime;
    }
    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"HH:mm"];
//    btnReportTimetxt = [[UIBarButtonItem alloc] initWithTitle:@"StandBy Begin [LCL]:" style:UIBarButtonItemStylePlain target:self action:@selector(setReporttimetxt:)];
//    btnReportTime = [[UIBarButtonItem alloc] initWithTitle:@"00:00" style:UIBarButtonItemStylePlain target:self action:@selector(showPicker:)];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnReportTime,btnReportTimetxt, nil]];
//    btnReportTime.title = [[dateFormat stringFromDate:[User sharedUser].SBYBegin]stringByAppendingString:@""];
//    btnReportTime.title = [[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursUTC,(long)intMinutesUTC]stringByAppendingString:@""];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.swcStandby.on = [User sharedUser].BolswcStandby;
    if (self.swcStandby.on == YES) {
        self.txtSBYTime.textColor = [UIColor darkGrayColor];
        
    }else{
        self.txtSBYTime.textColor = [UIColor lightGrayColor];
        
    }
    self.swcSBYRest.on = [User sharedUser].BolswcSBYRest;
    [self switchStandby];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    self.txtSBYTime.text = [[dateFormat stringFromDate:[User sharedUser].SBYBegin]stringByAppendingString:@""];
    [StartFDPTableViewController calcLimitingFDP];
//    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//    //	[strMaxFDP release];
//    NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
    
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.txtSBYTime)
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
    [_datePicker setDate:[User sharedUser].SBYBegin];
    [popoverView addSubview:_datePicker];
    popoverContent.view = popoverView;
    CGRect myFrame =self.txtSBYTime.frame;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 200) animated:NO];
    [popoverController presentPopoverFromRect:myFrame inView:self.tblvcStandBy permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
-(void)changeDateFromLabel:(id)sender
{
    [popoverController dismissPopoverAnimated:YES];
    [self result];
}
-(void) result

{
    [User sharedUser].SBYBegin = _datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    self.txtSBYTime.text = [[dateFormat stringFromDate:[User sharedUser].SBYBegin]stringByAppendingString:@""];
    [StartFDPTableViewController calcLimitingFDP];
//    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
////    tabMaxFDP.badgeValue = strMaxFDP;
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
- (void)switchStandby
{
    if (self.swcStandby.on == YES) {
        self.swcSBYRest.enabled = YES;
        self.swcSBYRest.on = NO;
//		self.btnSBYTime.enabled = YES;
//        self.lblStandby.enabled = YES;
//        self.lblSuitableRest.enabled = YES;
//        self.lblNotice.enabled = YES;
        self.txtSBYTime.textColor = [UIColor darkGrayColor];
        
//        self.tabStandby.badgeValue = @"ON";
        [User sharedUser].BolswcStandby = YES;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
    }
    else {
        self.swcSBYRest.on = NO;
        self.swcSBYRest.enabled = NO;
        //		self.btnSBYTime.enabled = NO;
//        self.lblStandby.enabled = NO;
//        self.lblSuitableRest.enabled = NO;
//        self.lblNotice.enabled = NO;
        self.txtSBYTime.textColor = [UIColor lightGrayColor];
        
//        self.tabStandby.badgeValue = nil;
        [User sharedUser].BolswcStandby = NO;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
    }
    
}


- (IBAction)switchStandby:(id)sender
{
    if (self.swcStandby.on == YES) {
        self.swcSBYRest.enabled = YES;
        self.swcSBYRest.on = NO;
        //		self.btnSBYTime.enabled = YES;
        self.txtSBYTime.textColor = [UIColor darkGrayColor];
//        self.lblStandby.enabled = YES;
//        self.lblSuitableRest.enabled = YES;
//        self.lblNotice.enabled = YES;
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 1] tabBarItem] setBadgeValue:@"ON"];
        self.tblvcStandBy.userInteractionEnabled = YES;
//        self.tblvcStandBy.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [User sharedUser].BolswcStandby = YES;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        //		UITableView *tableView = [[UITableView alloc] init];
        //        [[tableView allowsSelectionDuringEditing] = YES;
    }
    else {
        self.swcSBYRest.on = NO;
        self.swcSBYRest.enabled = NO;
        //		self.btnSBYTime.enabled = NO;
//        self.lblStandby.enabled = NO;
//        self.lblSuitableRest.enabled = NO;
        self.txtSBYTime.textColor = [UIColor lightGrayColor];
        
//        self.lblNotice.enabled = NO;
        //		self.tabStandby.badgeValue = nil;
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 1] tabBarItem] setBadgeValue:NO];
        self.tblvcStandBy.userInteractionEnabled = NO;
//        self.tblvcStandBy.accessoryType = UITableViewCellAccessoryNone;
        
        [User sharedUser].BolswcStandby = NO;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
    }
    
}

- (IBAction)setStandbyRest:(id)sender
{
    if (self.swcSBYRest.on) {
        [User sharedUser].BolswcSBYRest = YES;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
    }
    else {
        [User sharedUser].BolswcSBYRest = NO;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
    }
    
}

@end
