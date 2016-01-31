//
//  StartFDPTableViewController.m
//  RIM
//
//  Created by Michael Gehringer on 8/31/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import "StartFDPTableViewController.h"
#import "User.h"

@interface StartFDPTableViewController ()
@end

@implementation StartFDPTableViewController
@synthesize btnReportTime,btnReportTimetxt;
@synthesize ReportButton, lblReportLCL, dateFormatter, lblTimeZone, btnLongRange, txtReportLCL, txtTimeZone;
@synthesize totalDays, totalHours, totalMinutes, totalSeconds;
@synthesize timeZone;
@synthesize segCrew, segBodyClock, segPrecRest, segLongRange, segSectors, tblvcLongRange;
@synthesize tabMaxFDP;
@synthesize starttime, endtime;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 70;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSDate *today = [NSDate date];
    User *user = [User sharedUser];
    user.ReportTime = today;
    [User sharedUser].OriginalReportTime = [User sharedUser].ReportTime;
    [User sharedUser].BolPilots = YES;
    NSTimeZone* currentTimeZone = [NSTimeZone defaultTimeZone];
    NSInteger GMTOffset;
    GMTOffset = [currentTimeZone secondsFromGMT];
    [User sharedUser].IntTimeDifference = GMTOffset;
    segPrecRest.enabled = NO;
    tblvcLongRange.accessoryType = UITableViewCellAccessoryNone;
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
    // Now extract the hour:mins from today's date
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger intReportTime = ((hour*60)+min)*60;
    NSNumber *totalDaysUTC = [NSNumber numberWithDouble:
                              (intReportTime / 86400)];
    NSNumber *totalHoursUTC = [NSNumber numberWithDouble:
                               ((intReportTime / 3600) -
                                ([totalDaysUTC intValue] * 24))];
    NSNumber *totalMinutesUTC = [NSNumber numberWithDouble:
                                 ((intReportTime / 60) -
                                  ([totalDaysUTC intValue] * 24 * 60) -
                                  ([totalHoursUTC intValue] * 60))];
    NSInteger intHoursUTC;
    intHoursUTC = [totalHoursUTC intValue];
    NSInteger intMinutesUTC;
    intMinutesUTC = [totalMinutesUTC intValue];

    btnReportTimetxt = [[UIBarButtonItem alloc] initWithTitle:@"Report Time [LCL]:" style:UIBarButtonItemStylePlain target:self action:@selector(setReporttimetxt:)];
    btnReportTime = [[UIBarButtonItem alloc] initWithTitle:@"00:00" style:UIBarButtonItemStylePlain target:self action:@selector(showPicker:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnReportTime,btnReportTimetxt, nil]];
    btnReportTime.title = [[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursUTC,(long)intMinutesUTC]stringByAppendingString:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [User sharedUser].OriginalReportTime = [User sharedUser].ReportTime;
    txtReportLCL.text = [[dateFormat stringFromDate:[User sharedUser].ReportTime]stringByAppendingString:@" LCL"];
    btnReportTime.title = [[dateFormat stringFromDate:[User sharedUser].ReportTime]stringByAppendingString:@""];
    totalDays = [NSNumber numberWithDouble:
                 ([User sharedUser].IntTimeDifference / 86400)];
    totalHours = [NSNumber numberWithDouble:
                  (([User sharedUser].IntTimeDifference / 3600) -
                   ([totalDays intValue] * 24))];
    totalMinutes = [NSNumber numberWithDouble:
                    (([User sharedUser].IntTimeDifference / 60) -
                     ([totalDays intValue] * 24 * 60) -
                     ([totalHours intValue] * 60))];
    totalSeconds = [NSNumber numberWithInt:
                    ([User sharedUser].IntTimeDifference % 60)];
    NSInteger intHours;
    intHours = [totalHours intValue];
    NSInteger intMinutes;
    intMinutes = [totalMinutes intValue];
    if (intMinutes <0) {
        intMinutes=-intMinutes;
    }
    
    if (intHours < 0) {
        if (intMinutes < 15)
        {
            txtTimeZone.text = [[[NSString alloc] initWithFormat:@"%-.2li:00", (long)intHours] stringByAppendingString:@" hrs"];
        }
        else {
            txtTimeZone.text = [[[NSString alloc] initWithFormat:@"%-.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"];
        }
    }
    else {
        if (intMinutes < 15)
        {
            txtTimeZone.text = [[[NSString alloc] initWithFormat:@"%+.2li:00", (long)intHours]stringByAppendingString:@" hrs"];
        }
        
        else {
            txtTimeZone.text = [[[NSString alloc] initWithFormat:@"%+.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"];
        }
    }
    if ([User sharedUser].BolSectorLess7hrs == NO && [User sharedUser].IntsegBlockhours == 2 && segBodyClock.selectedSegmentIndex == 1) {
        //		segBodyClock.tintColor = [UIColor colorWithRed:0.70 green:0.171 blue:0.1 alpha:1.0];
    }
    else {
        //		segBodyClock.tintColor = nil;
    }
    //    txtTimeZone.text = @"";
    //    txtReportLCL.text = @"";
    if (self.segLongRange.selectedSegmentIndex == 1 && [User sharedUser].IntsegPilots == 0) {
        segSectors.enabled = NO;
    }else{
        segSectors.enabled = YES;
    }
    segSectors.selectedSegmentIndex = [User sharedUser].IntSectorNumbers;
    [StartFDPTableViewController calcLimitingFDP];


    [self displayMaxFDPBatchvalue];
    [StartFDPTableViewController displayResults];
    [self updateFields];
    
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (IBAction)showPicker:(id)sender
{
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor clearColor];
    _datePicker=[[UIDatePicker alloc]init];//Date picker
    _datePicker.frame=CGRectMake(0,44,320, 216);
    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_datePicker setMinuteInterval:1];
    [_datePicker setTag:10];
    [_datePicker addTarget:self action:@selector(result) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [_datePicker setDate:[User sharedUser].ReportTime];
    [popoverView addSubview:_datePicker];
    popoverContent.view = popoverView;
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void) result
{
    [User sharedUser].ReportTime = _datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    btnReportTime.title = [[dateFormat stringFromDate:[User sharedUser].ReportTime]stringByAppendingString:@""];
    [StartFDPTableViewController calcLimitingFDP];
    [self displayMaxFDPBatchvalue];
    [StartFDPTableViewController displayResults];
    [self updateFields];

}

- (IBAction)setReporttimetxt:(id)sender
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - FDP Calculation

+ (void) calculateMaxFDP
{
    
    
    
    switch ([User sharedUser].IntSegBodyClock) {
        case 0: //ACCLIMATISED
            [User sharedUser].BolAcclimatized = YES;
            switch ([User sharedUser].IntSegLongRange) {
                case 0:
                    [self TableAacclimatised];
                    break;
                case 1:
                    [self TableLongRange];
                    if ([User sharedUser].BolswcInFlightRelief == YES) {
                        [User sharedUser].IntMaxFDP = [User sharedUser].IntMaxFDP + [User sharedUser].IntInflightRestTime;
                    }
                    break;
                default:
                    break;
            }
            break;
        case 1: //NONACCLIMATISED
            [User sharedUser].BolAcclimatized = NO;
            switch ([User sharedUser].IntSegLongRange) {
                case 0:
                    [self TableBnonacclimatised];
                    break;
                case 1:
                    [self TableLongRange];
                    if ([User sharedUser].BolswcInFlightRelief == YES) {
                        [User sharedUser].IntMaxFDP = [User sharedUser].IntMaxFDP + [User sharedUser].IntInflightRestTime;
                    }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    // CHECK FOR SBYCORRECTION
    
    if ([User sharedUser].BolswcStandby == YES) {
        if ([User sharedUser].IntMaxFDPCorrectionSBY <= 21600) {
            [User sharedUser].IntMaxFDP = [User sharedUser].IntMaxFDP - [User sharedUser].IntMaxFDPCorrectionSBY;
        }
        else {
            [User sharedUser].IntMaxFDPCorrectionSBY = 0;
        }
    }
    
    // CHECK FOR SPLITDUTYCORRECTION
    
    if ([User sharedUser].BolswcSplitDuty == YES) {
        [User sharedUser].IntMaxFDP = [User sharedUser].IntMaxFDP + [User sharedUser].IntSplitDuty;
    }
    else {
        [User sharedUser].IntSplitDuty = 0;
    }
    
    
    
    // Check Inflight Rest Limits
    
    if ([User sharedUser].BolswcInFlightRelief == YES) {
        
        if ([User sharedUser].IntsegRestTakenIn == 0) { //BUNK 18hours limit
            if ([User sharedUser].IntMaxFDP >= 64800){
                [User sharedUser].IntMaxFDP = 64800;
            }
        }else{
            if ([User sharedUser].IntMaxFDP >= 54000){ //SEAT 15hours limit
                [User sharedUser].IntMaxFDP = 54000;
            }
        }
    }
    
    // CHECK FOR CABINCREW
    
    if ([User sharedUser].BolPilots == NO) {
        [User sharedUser].IntMaxFDP = [User sharedUser].IntMaxFDP + 3600;
    }
    [self displayMaxFDP];
    
    
    
}
+ (void) displayMaxFDP
{
    NSNumber *totalDays;
    NSNumber *totalHours;
    NSNumber *totalMinutes;
    //	NSNumber *totalSeconds;
    
    totalDays = [NSNumber numberWithDouble:
                 ([User sharedUser].IntMaxFDP / 86400)];
    totalHours = [NSNumber numberWithDouble:
                  (([User sharedUser].IntMaxFDP / 3600) -
                   ([totalDays intValue] * 24))];
    totalMinutes = [NSNumber numberWithDouble:
                    (([User sharedUser].IntMaxFDP / 60) -
                     ([totalDays intValue] * 24 * 60) -
                     ([totalHours intValue] * 60))];
    //	totalSeconds = [NSNumber numberWithInt:
    //					([User sharedUser].IntMaxFDP % 60)];
    NSInteger intHours;
    intHours = [totalHours intValue];
    NSInteger intMinutes;
    
    intMinutes = [totalMinutes intValue];
    
    [User sharedUser].IntMaxFDPHours = intHours;
    [User sharedUser].IntMaxFDPMinutes = intMinutes;
    
    
    
}

+ (void) displayMaxFDPEND
{
    //NSNumber *totalDays;
    //	NSNumber *totalHours;
    //	NSNumber *totalMinutes;
    //	NSNumber *totalSeconds;
    if ([User sharedUser].BolswcDelay == YES && [User sharedUser].BolswcStandby == NO) {
        NSInteger intReportTime;
        if ([User sharedUser].BolDelayMore4 == YES) {
            // REPORTTIME PLUS 4 HOURS INCLUDED ALREADY IN STARTFDP...
            NSInteger hour = [User sharedUser].IntSTARTFDPHours;
            NSInteger min = [User sharedUser].IntSTARTFDPMinutes;
            NSInteger intReportTime = ((hour*60)+min)*60;
            NSNumber *totalDays = [NSNumber numberWithDouble:
                                   ((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 86400)];
            NSNumber *totalHours = [NSNumber numberWithDouble:
                                    (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 3600) -
                                     ([totalDays intValue] * 24))];
            NSNumber *totalMinutes = [NSNumber numberWithDouble:
                                      (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 60) -
                                       ([totalDays intValue] * 24 * 60) -
                                       ([totalHours intValue] * 60))];
            NSInteger intHours;
            intHours = [totalHours intValue];
            NSInteger intMinutes;
            intMinutes = [totalMinutes intValue];
            [User sharedUser].IntMaxFDPENDHours = intHours;
            [User sharedUser].IntMaxFDPENDMinutes = intMinutes;
            
        }
        
        else {
            
            unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].DelayActReport];
            
            // Now extract the hour:mins from today's date
            NSInteger hour = [comps hour];
            NSInteger min = [comps minute];
            intReportTime = ((hour*60)+min)*60;
            NSNumber *totalDays = [NSNumber numberWithDouble:
                                   ((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 86400)];
            NSNumber *totalHours = [NSNumber numberWithDouble:
                                    (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 3600) -
                                     ([totalDays intValue] * 24))];
            NSNumber *totalMinutes = [NSNumber numberWithDouble:
                                      (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 60) -
                                       ([totalDays intValue] * 24 * 60) -
                                       ([totalHours intValue] * 60))];
            NSInteger intHours;
            intHours = [totalHours intValue];
            NSInteger intMinutes;
            intMinutes = [totalMinutes intValue];
            [User sharedUser].IntMaxFDPENDHours = intHours;
            [User sharedUser].IntMaxFDPENDMinutes = intMinutes;
        }
        
        
    }
    
    else {
        
        unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
        
        // Now extract the hour:mins from today's date
        NSInteger hour = [comps hour];
        NSInteger min = [comps minute];
        NSInteger intReportTime = ((hour*60)+min)*60;
        NSNumber *totalDays = [NSNumber numberWithDouble:
                               ((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 86400)];
        NSNumber *totalHours = [NSNumber numberWithDouble:
                                (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 3600) -
                                 ([totalDays intValue] * 24))];
        NSNumber *totalMinutes = [NSNumber numberWithDouble:
                                  (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 60) -
                                   ([totalDays intValue] * 24 * 60) -
                                   ([totalHours intValue] * 60))];
        NSInteger intHours;
        intHours = [totalHours intValue];
        NSInteger intMinutes;
        intMinutes = [totalMinutes intValue];
        [User sharedUser].IntMaxFDPENDHours = intHours;
        [User sharedUser].IntMaxFDPENDMinutes = intMinutes;
    }
    
    
}


- (IBAction)infoCrew:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Definition Cabin Crew"
                          message:@"Cabin Crew: A crew member, other than a flight crew member, assigned to duty in a passenger carrying aircraft during flight time."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
}


- (IBAction)infoAcclimatised:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Acclimatised - Non Acclimatised"
                          message:@"When a crew member has spent 3 consecutive local nights on the ground within a local time zone band, which is 2 hours wide, and is able to take uninterrupted nights sleep the crew member will remain acclimatized thereafter until a duty period finishes at a place where local time differs by more than 2 hours from that at the point of departure."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
    
}

- (IBAction)infoRestNonAcclimatised:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"NOTE for Rest NOT Acclimatised"
                          message:@"The practice of inserting a short duty into a rest period of between 18 and 30 hours in order to produce a rest period of less than 18 hours, thereby taking advantage of the longer FDP contained in Table B, is not permitted."
                          @"Report times must not be reduced below minimum report time in order for crew members to achieve their required rest prior to an FDP. (When part of the minimum required crew compliment)"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
    
}
- (IBAction)segPilotsCabinCrew:(id)sender
{
    if (segCrew.selectedSegmentIndex == 0) {
        [User sharedUser].BolPilots = YES;
        segLongRange.enabled = YES;
    }
    else {
        [User sharedUser].BolPilots = NO;
        segLongRange.selectedSegmentIndex = 0;
        segLongRange.enabled = NO;
        //segSectors.selectedSegmentIndex = 0;
    }
    
    [StartFDPTableViewController calcLimitingFDP];
    
//    [self displayMaxFDPBatchvalue];
    [StartFDPTableViewController displayResults];
    [self updateFields];
}
- (void) displayMaxFDPBatchvalue
{
//    NSString *strMaxFDP = [@"FDP" stringByAppendingString:[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes]];
//    tabMaxFDP.badgeValue = strMaxFDP;
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:[[self tabBarController] viewControllers]];
    [[self tabBarController] setViewControllers:controllers animated:YES];
    //	[strMaxFDP release];
//    NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
    
    //        NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    //        [controllers removeObjectAtIndex:3];
    
    
    //[[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] select:4];
    //[strMaxFDPEND release];
    
}

- (IBAction)enablePrecRest:(id)sender
{
    if (segBodyClock.selectedSegmentIndex == 1) {
        [User sharedUser].IntSegBodyClock = 1;
        [User sharedUser].BolAcclimatized = NO;
        if ([User sharedUser].BolSectorLess7hrs == NO && [User sharedUser].IntsegBlockhours == 2) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Long Range - Non Acclimatised"
                                  message:@"Over 11 hours = NOT APPLICABLE!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            //			[alert release];
            //			segBodyClock.tintColor = [UIColor colorWithRed:0.70 green:0.171 blue:0.1 alpha:1.0];
        }
        else {
            //			segBodyClock.tintColor = nil;
            segPrecRest.enabled = YES;
            [StartFDPTableViewController calcLimitingFDP];
            [self displayMaxFDPBatchvalue];
            [StartFDPTableViewController displayResults];
            [self updateFields];
        }
        
        
        if (segPrecRest.selectedSegmentIndex == 0) {
            
            [User sharedUser].BolPreceedingRestless18 = YES;
            [StartFDPTableViewController calcLimitingFDP];
            [self displayMaxFDPBatchvalue];
            [StartFDPTableViewController displayResults];
            [self updateFields];
            
            
        }
        else {
            [User sharedUser].BolPreceedingRestless18 = NO;
            [StartFDPTableViewController calcLimitingFDP];
            [self displayMaxFDPBatchvalue];
            [StartFDPTableViewController displayResults];
            [self updateFields];
            
        }
    }
    else {
        //		segBodyClock.tintColor = nil;
        [User sharedUser].IntSegBodyClock = 0;
        [User sharedUser].BolAcclimatized = YES;
        segPrecRest.enabled = NO;
        [StartFDPTableViewController calcLimitingFDP];
        [self displayMaxFDPBatchvalue];
        [StartFDPTableViewController displayResults];
        [self updateFields];
    }
    
}

- (IBAction)segPreceedingRest:(id)sender
{
    if (segPrecRest.selectedSegmentIndex == 0) {
        [User sharedUser].BolPreceedingRestless18 = YES;
        
    }
    else {
        [User sharedUser].BolPreceedingRestless18 = NO;
        
    }
    
    [StartFDPTableViewController calcLimitingFDP];
    [self displayMaxFDPBatchvalue];
    [StartFDPTableViewController displayResults];
    [self updateFields];
    
}

- (IBAction)enableSectors:(id)sender
{
    if (segLongRange.selectedSegmentIndex == 0) {
        [User sharedUser].IntSegLongRange = 0;
        [User sharedUser].BolswcInFlightRelief = NO;
        [User sharedUser].IntsegPilots = 0;
        segSectors.enabled = YES;
        [User sharedUser].BolSectorLess7hrs = YES;
        btnLongRange.enabled = NO;
        //        tblvcLongRange.userInteractionEnabled = NO;
        tblvcLongRange.accessoryType = UITableViewCellAccessoryNone;
        [StartFDPTableViewController calcLimitingFDP];
        [self displayMaxFDPBatchvalue];
        [StartFDPTableViewController displayResults];
        [self updateFields];
    }
    else {
        segSectors.enabled = YES;
        [User sharedUser].IntSegLongRange = 1;
        [User sharedUser].BolSectorLess7hrs = NO;
        btnLongRange.enabled = YES;
        tblvcLongRange.userInteractionEnabled = YES;
        tblvcLongRange.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [StartFDPTableViewController calcLimitingFDP];
        [self displayMaxFDPBatchvalue];
        [StartFDPTableViewController displayResults];
        [self updateFields];
        
    }
}

- (IBAction)chooseSectorNumbers:(id)sender
{
    [User sharedUser].BolSectorSelected = YES;
    [User sharedUser].IntSectorNumbers = segSectors.selectedSegmentIndex;
    if (segBodyClock.selectedSegmentIndex == 0) {
        [User sharedUser].BolAcclimatized = YES;
        [StartFDPTableViewController TableAacclimatised];
    }
    else {
        [User sharedUser].BolAcclimatized = NO;
        [StartFDPTableViewController TableBnonacclimatised];
    }
    
    [StartFDPTableViewController calcLimitingFDP];
    
    
    [self displayMaxFDPBatchvalue];
    [StartFDPTableViewController displayResults];
    [self updateFields];
}


- (IBAction)showLongRange:(id)sender
{
//    segLongRange.selectedSegmentIndex = segLongRange.selectedSegmentIndex;
    if (segLongRange.selectedSegmentIndex == 1) {
        [User sharedUser].BolSectorLess7hrs = NO;
//        segLongRange.selectedSegmentIndex = 1;
        [User sharedUser].IntSegLongRange = 1;
        btnLongRange.enabled = YES;
        tblvcLongRange.userInteractionEnabled = YES;
        tblvcLongRange.accessoryType = UITableViewCellAccessoryNone;
        [self performSegueWithIdentifier:@"segLongRange" sender:self];
    }
    else {
        [User sharedUser].BolSectorLess7hrs = YES;
//        segLongRange.selectedSegmentIndex = 0;
//        [User sharedUser].IntSegLongRange = 0;
        btnLongRange.enabled = YES;
        //        tblvcLongRange.userInteractionEnabled = NO;
        tblvcLongRange.accessoryType = UITableViewCellAccessoryNone;
        [StartFDPTableViewController calcLimitingFDP];
        [self displayMaxFDPBatchvalue];
        [StartFDPTableViewController displayResults];
        [self updateFields];
        
    }
    if (1 == [segLongRange selectedSegmentIndex]) {
        
    }
    
}
+ (void) TableBnonacclimatised
{
    if ([User sharedUser].BolPreceedingRestless18 == YES)
    {
        switch ([User sharedUser].IntSectorNumbers)
        {
            case 0:
                [User sharedUser].IntMaxFDP = (13 * 3600);
                break;
            case 1:
                [User sharedUser].IntMaxFDP = (12.25 * 3600);
                break;
            case 2:
                [User sharedUser].IntMaxFDP = (11.5 * 3600);
                break;
            case 3:
                [User sharedUser].IntMaxFDP = (10.75 * 3600);
                break;
            case 4:
                [User sharedUser].IntMaxFDP = (10 * 3600);
                break;
            case 5:
                [User sharedUser].IntMaxFDP = (9.25 * 3600);
                break;
            case 6:
                [User sharedUser].IntMaxFDP = (9 * 3600);
                break;
            case 7:
                [User sharedUser].IntMaxFDP = (9 * 3600);
                break;
        }
    }
    else {
        switch ([User sharedUser].IntSectorNumbers)
        {
            case 0:
                [User sharedUser].IntMaxFDP = (11.5 * 3600);
                break;
            case 1:
                [User sharedUser].IntMaxFDP = (11 * 3600);
                break;
            case 2:
                [User sharedUser].IntMaxFDP = (10.5 * 3600);
                break;
            case 3:
                [User sharedUser].IntMaxFDP = (9.75 * 3600);
                break;
            case 4:
                [User sharedUser].IntMaxFDP = (9 * 3600);
                break;
            case 5:
                [User sharedUser].IntMaxFDP = (9 * 3600);
                break;
            case 6:
                [User sharedUser].IntMaxFDP = (9 * 3600);
                break;
            case 7:
                [User sharedUser].IntMaxFDP = (9 * 3600);
                break;
                
        }
    }
    [self displayMaxFDP];
    [StartFDPTableViewController displayResults];
}


+ (void) calcLimitingFDP
{
    //[User sharedUser].ReportTime = [User sharedUser].OriginalReportTime;
    [User sharedUser].OriginalReportTime = [User sharedUser].ReportTime;
    [User sharedUser].FDPStartTime = [User sharedUser].ReportTime;
    [User sharedUser].OriginalStandbyTime = [User sharedUser].SBYBegin;
    [User sharedUser].OriginalActualReportTime = [User sharedUser].DelayActReport;
    [User sharedUser].IntMaxFDPCorrectionSBY = 0;
    if ([User sharedUser].BolswcStandby == YES) {
        unsigned unitFlagsSBY = NSCalendarUnitHour | NSCalendarUnitMinute;
        NSCalendar *gregorianSBY = [[NSCalendar alloc]
                                    initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *compsSBY = [gregorianSBY components:unitFlagsSBY fromDate:[User sharedUser].OriginalStandbyTime];
        // Now extract the hour:mins from today's date
        NSInteger hourSBY = [compsSBY hour];
        NSInteger minSBY = [compsSBY minute];
        NSInteger intSBYBegin = ((hourSBY*60)+minSBY)*60;
        unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
        // Now extract the hour:mins from today's date
        NSInteger hour = [comps hour];
        NSInteger min = [comps minute];
        NSInteger intReportTime = ((hour*60)+min)*60;
        //CHECK THE MORE LIMITING TIME BAND
        if (intReportTime >= intSBYBegin) {
            if (intReportTime - intSBYBegin > 21600) {
                [User sharedUser].IntMaxFDPCorrectionSBY = ((intReportTime - intSBYBegin)-21600);
            }
        }
        else {
            [User sharedUser].IntMaxFDPCorrectionSBY = (((intReportTime+86400) - intSBYBegin)-21600);
        }
        if ([User sharedUser].BolswcSBYRest == NO) {
            [User sharedUser].ReportTime = [User sharedUser].OriginalReportTime;
            [self calculateMaxFDP];
            NSInteger intOriginalFDP = [User sharedUser].IntMaxFDP;
            [User sharedUser].ReportTime = [User sharedUser].SBYBegin;
            [self calculateMaxFDP];
            NSInteger intStandbyFDP = [User sharedUser].IntMaxFDP;
            if (intOriginalFDP < intStandbyFDP) {
                [User sharedUser].ReportTime = [User sharedUser].OriginalReportTime;
            }
            else {
                [User sharedUser].ReportTime = [User sharedUser].SBYBegin;
            }
        }
    }
    
    if ([User sharedUser].BolswcDelay == YES) {
        if ([User sharedUser].BolDelayMore4 == NO && [User sharedUser].BolswcStandby == NO) {
            [User sharedUser].ReportTime = [User sharedUser].OriginalReportTime;
            [User sharedUser].FDPStartTime = [User sharedUser].DelayActReport;
            [self calculateMaxFDP];
        }
        else if ([User sharedUser].BolDelayMore4 == YES && [User sharedUser].BolswcStandby == NO)
        {
            [self CalculateACTUALPlus4];
            //CALCULATE TIMEBAND REPORTTIME
            [User sharedUser].ReportTime = [User sharedUser].OriginalReportTime;
            
            
            [self calculateMaxFDP];
            NSInteger intOriginalFDP = [User sharedUser].IntMaxFDP;
            
            
            
            //CALCULATE TIMEBAND ACTUALREPORT
            [User sharedUser].ReportTime = [User sharedUser].DelayActReport;
            [self calculateMaxFDP];
            NSInteger intActualReportFDP = [User sharedUser].IntMaxFDP;
            
            //CHECK THE MORE LIMITING TIME BAND
            if (intOriginalFDP < intActualReportFDP) {
                if ([User sharedUser].BolswcStandby == YES) {
                    //CALCULATE TIMEBAND STANDBYBEGIN
                    [User sharedUser].ReportTime = [User sharedUser].SBYBegin;
                    [self calculateMaxFDP];
                    NSInteger intStandbyFDP = [User sharedUser].IntMaxFDP;
                    
                    if (intStandbyFDP < intOriginalFDP) {
                        [User sharedUser].ReportTime = [User sharedUser].SBYBegin;
                    }
                    else {
                        [User sharedUser].ReportTime = [User sharedUser].OriginalReportTime;
                    }
                    
                }
                else {
                    [User sharedUser].ReportTime = [User sharedUser].OriginalReportTime;
                }
                
            }
            else {
                
                if ([User sharedUser].BolswcStandby == YES) {
                    //CALCULATE TIMEBAND STANDBYBEGIN
                    [User sharedUser].ReportTime = [User sharedUser].SBYBegin;
                    [self calculateMaxFDP];
                    NSInteger intStandbyFDP = [User sharedUser].IntMaxFDP;
                    
                    if (intStandbyFDP < intActualReportFDP) {
                        [User sharedUser].ReportTime = [User sharedUser].SBYBegin;
                    }
                    else {
                        [User sharedUser].ReportTime = [User sharedUser].DelayActReport;
                    }
                    
                }
                else {
                    [User sharedUser].ReportTime = [User sharedUser].DelayActReport;
                }
            }
        }
        
    }
    
    [self calculateMaxFDP];
    [User sharedUser].LimitingReportTime = [User sharedUser].ReportTime;
    [User sharedUser].ReportTime = [User sharedUser].OriginalReportTime;
    [self displayMaxFDPEND];
    [self displayResults];
    
}

+ (void) CalculateACTUALPlus4
{
    
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
    
    // Now extract the hour:mins from today's date
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    
    NSInteger intReportActReportTime = ((hour*60)+min)*60;
    NSInteger intFDPStartTime = intReportActReportTime + 14400;
    NSNumber *totalDays = [NSNumber numberWithDouble:
                           (intFDPStartTime / 86400)];
    NSNumber *totalHours = [NSNumber numberWithDouble:
                            ((intFDPStartTime / 3600) -
                             ([totalDays intValue] * 24))];
    NSNumber *totalMinutes = [NSNumber numberWithDouble:
                              ((intFDPStartTime / 60) -
                               ([totalDays intValue] * 24 * 60) -
                               ([totalHours intValue] * 60))];
    //NSNumber *totalSeconds = [NSNumber numberWithInt:
    //					(intFDPStartTime % 60)];
    NSInteger intHours;
    intHours = [totalHours intValue];
    NSInteger intMinutes;
    intMinutes = [totalMinutes intValue];
    //	[User sharedUser].FDPStartTime = [[NSString alloc] initWithFormat:@"%.2i:%.2i", intHours, intMinutes];
    [User sharedUser].IntSTARTFDPHours = intHours;
    [User sharedUser].IntSTARTFDPMinutes = intMinutes;
}


+ (void) TableAacclimatised
{
    NSInteger intStart0600 = 360*60;
    NSInteger intEnd0759 = ((420+59)*60);
    NSInteger intStart0800 = (480*60);
    NSInteger intEnd1259 = ((720+59)*60);
    NSInteger intStart1300 = (780*60);
    NSInteger intEnd1759 = ((1020+59)*60);
    NSInteger intStart1800 = (1080*60);
    NSInteger intEnd2159 = ((1260+59)*60);
    NSInteger intStart2200 = (1320*60);
    NSInteger intEnd2359 = ((23*60)+59)*60;
    NSInteger intStart0000 = 0;
    NSInteger intEnd0559 = ((300+59)*60);
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
    
    // Now extract the hour:mins from today's date
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    
    NSInteger intReportTime = ((hour*60)+min)*60;
    
    if (intReportTime>= intStart0600 && intReportTime <= intEnd0759) {
        switch ([User sharedUser].IntSectorNumbers) {
            case 0:
                [User sharedUser].IntMaxFDP = 13*3600;
                break;
            case 1:
                [User sharedUser].IntMaxFDP = 12.25*3600;
                break;
            case 2:
                [User sharedUser].IntMaxFDP = 11.5*3600;
                break;
            case 3:
                [User sharedUser].IntMaxFDP = 10.75*3600;
                break;
            case 4:
                [User sharedUser].IntMaxFDP = 10*3600;
                break;
            case 5:
                [User sharedUser].IntMaxFDP = 9.5*3600;
                break;
            case 6:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            case 7:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            default:
                break;
        }
        
    }
    else if (intReportTime>= intStart0800 && intReportTime <= intEnd1259) {
        switch ([User sharedUser].IntSectorNumbers) {
            case 0:
                [User sharedUser].IntMaxFDP = 14*3600;
                break;
            case 1:
                [User sharedUser].IntMaxFDP = 13.25*3600;
                break;
            case 2:
                [User sharedUser].IntMaxFDP = 12.5*3600;
                break;
            case 3:
                [User sharedUser].IntMaxFDP = 11.75*3600;
                break;
            case 4:
                [User sharedUser].IntMaxFDP = 11*3600;
                break;
            case 5:
                [User sharedUser].IntMaxFDP = 10.5*3600;
                break;
            case 6:
                [User sharedUser].IntMaxFDP = 10*3600;
                break;
            case 7:
                [User sharedUser].IntMaxFDP = 9.5*3600;
                break;
            default:
                break;
        }
        
    }
    else if (intReportTime>= intStart1300 && intReportTime <= intEnd1759) {
        switch ([User sharedUser].IntSectorNumbers) {
            case 0:
                [User sharedUser].IntMaxFDP = 13*3600;
                break;
            case 1:
                [User sharedUser].IntMaxFDP = 12.25*3600;
                break;
            case 2:
                [User sharedUser].IntMaxFDP = 11.5*3600;
                break;
            case 3:
                [User sharedUser].IntMaxFDP = 10.75*3600;
                break;
            case 4:
                [User sharedUser].IntMaxFDP = 10*3600;
                break;
            case 5:
                [User sharedUser].IntMaxFDP = 9.5*3600;
                break;
            case 6:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            case 7:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            default:
                break;
        }
        
    }
    else if (intReportTime>= intStart1800 && intReportTime <= intEnd2159) {
        switch ([User sharedUser].IntSectorNumbers) {
            case 0:
                [User sharedUser].IntMaxFDP = 12*3600;
                break;
            case 1:
                [User sharedUser].IntMaxFDP = 11.25*3600;
                break;
            case 2:
                [User sharedUser].IntMaxFDP = 10.5*3600;
                break;
            case 3:
                [User sharedUser].IntMaxFDP = 9.75*3600;
                break;
            case 4:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            case 5:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            case 6:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            case 7:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            default:
                break;
        }
        
    }
    else if ((intReportTime>= intStart2200 && intReportTime <= intEnd2359) || (intReportTime>= intStart0000 && intReportTime <= intEnd0559)){
        switch ([User sharedUser].IntSectorNumbers) {
            case 0:
                [User sharedUser].IntMaxFDP = 11*3600;
                break;
            case 1:
                [User sharedUser].IntMaxFDP = 10.25*3600;
                break;
            case 2:
                [User sharedUser].IntMaxFDP = 9.5*3600;
                break;
            case 3:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            case 4:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            case 5:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            case 6:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            case 7:
                [User sharedUser].IntMaxFDP = 9*3600;
                break;
            default:
                break;
        }
        
    }
}

+ (void) TableLongRange
{
    if ([User sharedUser].IntsegPilots == 0) { // 2 PILOTS NO REST
        switch ([User sharedUser].IntsegBlockhours) {
            case 0:
                if ([User sharedUser].BolAcclimatized == YES) {
                    [User sharedUser].IntSectorNumbers = 1; //ACCLIMATISED
                    [self TableAacclimatised];
                }
                else {
                    [User sharedUser].IntSectorNumbers = 3; //NONACCLIMATISED
                    [self TableBnonacclimatised];
                }
                break;
            case 1:
                if ([User sharedUser].BolAcclimatized == YES) {
                    [User sharedUser].IntSectorNumbers = 2; //ACCLIMATISED
                    [self TableAacclimatised];
                }
                else {
                    [User sharedUser].IntSectorNumbers = 3; //NONACCLIMATISED
                    [self TableBnonacclimatised];
                }
                break;
            case 2:
                if ([User sharedUser].BolAcclimatized == YES) {
                    [User sharedUser].IntSectorNumbers = 3; //ACCLIMATISED
                    [self TableAacclimatised];
                }
                else {
                    [User sharedUser].IntSectorNumbers = 3; //NONACCLIMATISED
                    //[self TableBnonacclimatised];
                    // NOT APPLICABLE!!!!!
                    
                }
                break;
            default:
                break;
        }
    }
    else { // 3 PILOTS REST IN BUNK OR BED
        if ([User sharedUser].BolswcInFlightRelief == YES) {
            switch ([User sharedUser].IntsegRestTakenIn) {
                case 0:
                    [User sharedUser].IntSectorNumbers = 0;
                    [User sharedUser].IntInflightRestTime = [User sharedUser].ReliefRestTime/2;
                    if ([User sharedUser].BolAcclimatized == YES) {
                        [self TableAacclimatised];
                    }
                    else {
                        [self TableBnonacclimatised];
                    }
                    break;
                case 1:
                    [User sharedUser].IntSectorNumbers = 0;
                    [User sharedUser].IntInflightRestTime = [User sharedUser].ReliefRestTime/3;
                    if ([User sharedUser].BolAcclimatized == YES) {
                        [self TableAacclimatised];
                    }
                    else {
                        [self TableBnonacclimatised];
                    }
                    
                    break;
                    
                default:
                    break;
            }
        }
        else { // 3PILOTS NO REST
            if ([User sharedUser].BolSectorSelected == NO) {
                [User sharedUser].IntSectorNumbers = 0;
            }
            //[User sharedUser].ReliefRestTime = 0;
            [User sharedUser].IntInflightRestTime = 0;
            if ([User sharedUser].BolAcclimatized == YES) {
                [self TableAacclimatised];
            }
            else {
                [self TableBnonacclimatised];
            }
        }
        
        
    }
    
}

+ (void) displayResults
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [User sharedUser].txtTimeBand = [[dateFormat stringFromDate:[User sharedUser].LimitingReportTime] stringByAppendingString:@""];
    
    if ([User sharedUser].BolswcDelay == YES  && [User sharedUser].BolswcStandby == NO) {
        NSInteger intReportTime;
        if ([User sharedUser].BolDelayMore4 == YES) {
            NSInteger hour = [User sharedUser].IntSTARTFDPHours;
            NSInteger min = [User sharedUser].IntSTARTFDPMinutes;
            intReportTime = ((hour*60)+min)*60;
            [User sharedUser].txtStartFDP = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)hour, (long)min] stringByAppendingString:@""];
        }
        else {
            
            [User sharedUser].txtStartFDP = [[dateFormat stringFromDate:[User sharedUser].DelayActReport] stringByAppendingString:@""];
            unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].DelayActReport];
            
            // Now extract the hour:mins from today's date
            NSInteger hour = [comps hour];
            NSInteger min = [comps minute];
            intReportTime = ((hour*60)+min)*60;
            
        }
        
        
        NSNumber *totalDays = [NSNumber numberWithDouble:
                     ((intReportTime + [User sharedUser].IntMaxFDP) / 86400)];
        NSNumber *totalHours = [NSNumber numberWithDouble:
                      (((intReportTime + [User sharedUser].IntMaxFDP) / 3600) -
                       ([totalDays intValue] * 24))];
        NSNumber *totalMinutes = [NSNumber numberWithDouble:
                        (((intReportTime + [User sharedUser].IntMaxFDP) / 60) -
                         ([totalDays intValue] * 24 * 60) -
                         ([totalHours intValue] * 60))];
        NSNumber *totalSeconds = [NSNumber numberWithInt:
                        ((intReportTime + [User sharedUser].IntMaxFDP) % 60)];
        NSInteger intHours;
        intHours = [totalHours intValue];
        NSInteger intMinutes;
        intMinutes = [totalMinutes intValue];
        [User sharedUser].txtEndTimeLCL = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes] stringByAppendingString:@""];
        
        
        totalDays = [NSNumber numberWithDouble:
                     ((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 86400)];
        totalHours = [NSNumber numberWithDouble:
                      (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 3600) -
                       ([totalDays intValue] * 24))];
        totalMinutes = [NSNumber numberWithDouble:
                        (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 60) -
                         ([totalDays intValue] * 24 * 60) -
                         ([totalHours intValue] * 60))];
        totalSeconds = [NSNumber numberWithInt:
                        ((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) % 60)];
        //NSInteger intHours;
        intHours = [totalHours intValue];
        //NSInteger intMinutes;
        intMinutes = [totalMinutes intValue];
        [User sharedUser].txtEndTimeUTC  = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes] stringByAppendingString:@""];
        
        
        
    }
    //if (([User sharedUser].BolswcDelay == YES || [User sharedUser].BolswcStandby == YES)) {
    //		//
    //	}
    else {
        
        [User sharedUser].txtStartFDP = [[dateFormat stringFromDate:[User sharedUser].ReportTime] stringByAppendingString:@""];
        unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:[User sharedUser].ReportTime];
        
        // Now extract the hour:mins from today's date
        NSInteger hour = [comps hour];
        NSInteger min = [comps minute];
        
        NSInteger intReportTime = ((hour*60)+min)*60;
        
        NSNumber *totalDays = [NSNumber numberWithDouble:
                     ((intReportTime + [User sharedUser].IntMaxFDP) / 86400)];
        NSNumber *totalHours = [NSNumber numberWithDouble:
                      (((intReportTime + [User sharedUser].IntMaxFDP) / 3600) -
                       ([totalDays intValue] * 24))];
        NSNumber *totalMinutes = [NSNumber numberWithDouble:
                        (((intReportTime + [User sharedUser].IntMaxFDP) / 60) -
                         ([totalDays intValue] * 24 * 60) -
                         ([totalHours intValue] * 60))];
        NSNumber *totalSeconds = [NSNumber numberWithInt:
                        ((intReportTime + [User sharedUser].IntMaxFDP) % 60)];
        NSInteger intHours;
        intHours = [totalHours intValue];
        NSInteger intMinutes;
        intMinutes = [totalMinutes intValue];
        [User sharedUser].txtEndTimeLCL = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes] stringByAppendingString:@""];
        
        
        totalDays = [NSNumber numberWithDouble:
                     ((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 86400)];
        totalHours = [NSNumber numberWithDouble:
                      (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 3600) -
                       ([totalDays intValue] * 24))];
        totalMinutes = [NSNumber numberWithDouble:
                        (((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) / 60) -
                         ([totalDays intValue] * 24 * 60) -
                         ([totalHours intValue] * 60))];
        totalSeconds = [NSNumber numberWithInt:
                        ((intReportTime + [User sharedUser].IntMaxFDP - [User sharedUser].IntTimeDifference) % 60)];
        //NSInteger intHours;
        intHours = [totalHours intValue];
        //NSInteger intMinutes;
        intMinutes = [totalMinutes intValue];
        [User sharedUser].txtEndTimeUTC  = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes] stringByAppendingString:@""];
    }
    
    
    NSNumber *totalDays = [NSNumber numberWithDouble:
                 ([User sharedUser].IntMaxFDP / 86400)];
    NSNumber *totalHours = [NSNumber numberWithDouble:
                  (([User sharedUser].IntMaxFDP / 3600) -
                   ([totalDays intValue] * 24))];
    NSNumber *totalMinutes = [NSNumber numberWithDouble:
                    (([User sharedUser].IntMaxFDP / 60) -
                     ([totalDays intValue] * 24 * 60) -
                     ([totalHours intValue] * 60))];
    NSNumber *totalSeconds = [NSNumber numberWithInt:
                    ([User sharedUser].IntMaxFDP % 60)];
    NSInteger intHours;
    intHours = [totalHours intValue];
    NSInteger intMinutes;
    intMinutes = [totalMinutes intValue];
    [User sharedUser].txtNewCorrFDP = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes] stringByAppendingString:@" hrs"];
    
    
    if ([User sharedUser].IntMaxFDPCorrectionSBY > 0 || [User sharedUser].IntSplitDuty > 0 || [User sharedUser].IntInflightRestTime > 0) {
        
        
        if ([User sharedUser].BolswcStandby == YES && [User sharedUser].IntMaxFDPCorrectionSBY > 0) {
            [User sharedUser].txtCorrectionDiscr = @"Standby in excess of 6 hrs.";
        }
        
        
        
        
        if ([User sharedUser].BolswcSplitDuty == YES && [User sharedUser].IntSplitDuty > 0) {
            [User sharedUser].txtCorrectionDiscr = @"Split Duty";
        }
        
        if ([User sharedUser].BolswcInFlightRelief == YES && [User sharedUser].IntInflightRestTime > 0) {
            [User sharedUser].txtCorrectionDiscr = @"Inflight Relief";
        }
        
    }
    else {
        [User sharedUser].txtCorrectionDiscr = @"NO Corrections applied!";
    }
    
    // ADDING ALL CORRECTIONS
    NSInteger intCorr = [User sharedUser].IntInflightRestTime + [User sharedUser].IntSplitDuty + [User sharedUser].IntMaxFDPCorrectionSBY;
    totalDays = [NSNumber numberWithDouble:
                 (intCorr / 86400)];
    totalHours = [NSNumber numberWithDouble:
                  ((intCorr / 3600) -
                   ([totalDays intValue] * 24))];
    totalMinutes = [NSNumber numberWithDouble:
                    ((intCorr / 60) -
                     ([totalDays intValue] * 24 * 60) -
                     ([totalHours intValue] * 60))];
    totalSeconds = [NSNumber numberWithInt:
                    (intCorr % 60)];
    //NSInteger intHours;
    intHours = [totalHours intValue];
    //NSInteger intMinutes;
    intMinutes = [totalMinutes intValue];
    [User sharedUser].txtCorrections = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes] stringByAppendingString:@" hrs"];
    
    // CALCULATING NEW FDP
    NSInteger intNewFDP;
    intNewFDP = 0;
    //intNewFDP = [User sharedUser].IntMaxFDP;
    if ([User sharedUser].IntMaxFDPCorrectionSBY > 0) {
        intNewFDP = intNewFDP + [User sharedUser].IntMaxFDPCorrectionSBY;
    }
    if ([User sharedUser].IntInflightRestTime > 0) {
        intNewFDP = intNewFDP - [User sharedUser].IntInflightRestTime;
    }
    if ([User sharedUser].IntSplitDuty > 0) {
        intNewFDP = intNewFDP - [User sharedUser].IntSplitDuty;
    }
    intNewFDP = intNewFDP + [User sharedUser].IntMaxFDP;
    
    
    totalDays = [NSNumber numberWithDouble:
                 (intNewFDP / 86400)];
    totalHours = [NSNumber numberWithDouble:
                  ((intNewFDP / 3600) -
                   ([totalDays intValue] * 24))];
    totalMinutes = [NSNumber numberWithDouble:
                    ((intNewFDP / 60) -
                     ([totalDays intValue] * 24 * 60) -
                     ([totalHours intValue] * 60))];
    totalSeconds = [NSNumber numberWithInt:
                    (intNewFDP % 60)];
    //NSInteger intHours;
    intHours = [totalHours intValue];
    //NSInteger intMinutes;
    intMinutes = [totalMinutes intValue];
    [User sharedUser].txtMaxFDP = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes] stringByAppendingString:@" hrs"];
    
    NSString *strAddInfo;
    //	strAddInfo = @"";
    if ([User sharedUser].BolPilots == YES) {
        strAddInfo = @"2 Pilots, ";
        if ([User sharedUser].IntsegPilots == 1) {
            strAddInfo = @"3 Pilots, ";
        }
    }
    else {
        strAddInfo = @"Cabin Crew, ";
    }
    
    if ([User sharedUser].BolAcclimatized == YES) {
        strAddInfo = [strAddInfo stringByAppendingString:@"Acclimatised"];
    }
    else {
        strAddInfo = [strAddInfo stringByAppendingString:@"NON Acclimatised"];
    }
    [User sharedUser].txtReducedDiscr = strAddInfo;
    }

- (void) updateFields {
    self.txtBasedON.text = [User sharedUser].txtTimeBand;
    self.txtStartsAt.text = [User sharedUser].txtStartFDP;
    self.txtMaxFDP.text = [User sharedUser].txtMaxFDP;
    self.txtCorrectedBy.text = [User sharedUser].txtCorrections;
    self.txtCorrections.text = [User sharedUser].txtCorrectionDiscr;
    self.txtMaxPermittedFDP.text = [User sharedUser].txtNewCorrFDP;
    self.txtFDPEndUTC.text = [User sharedUser].txtEndTimeUTC;
}


@end
