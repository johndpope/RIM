//
//  LongRangeTableViewController.m
//  RIM
//
//  Created by Michael Gehringer on 9/1/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import "LongRangeTableViewController.h"

@interface LongRangeTableViewController ()
@property (nonatomic, retain) IBOutlet UIButton *RestTime;
@property (nonatomic, retain) IBOutlet UITextField *txtRestTime;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segPilots;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segBlockHours;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segRestTakenIn;
@property (nonatomic, retain) IBOutlet UISwitch *swcInFlightRelief;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcresttime;
@property (nonatomic, retain) NSNumber *totalDays;
@property (nonatomic, retain) NSNumber *totalHours;
@property (nonatomic, retain) NSNumber *totalMinutes;
@property (nonatomic, retain) NSNumber *totalSeconds;
@property (nonatomic, retain) IBOutlet UITabBarItem *tabLongRange;
@property(nonatomic, retain) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) NSMutableArray *arrayHours;
@property (nonatomic, strong) NSMutableArray *arrayMinutes;

- (IBAction)enableRestTaken:(id)sender;
- (IBAction)enable3pilots:(id)sender;
- (IBAction)setBlockhours:(id)sender;
- (IBAction)setRestTakenIn:(id)sender;
- (IBAction)info2PilotsLongRange:(id)sender;
- (IBAction)infoinflightRelief:(id)sender;
- (IBAction)infoBunkOrBed:(id)sender;
- (IBAction)info2Pilots:(id)sender;


@end

@implementation LongRangeTableViewController
@synthesize btnReportTime,btnReportTimetxt,popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 70;
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (void)viewWillAppear:(BOOL)animated
{
    self.segPilots.selectedSegmentIndex = [User sharedUser].IntsegPilots;
    if (self.segPilots.selectedSegmentIndex == 0) {
        self.swcInFlightRelief.enabled = NO;
        [User sharedUser].BolswcInFlightRelief = NO;
        self.swcInFlightRelief.on = NO;
        self.segRestTakenIn.enabled = NO;
        self.segBlockHours.selectedSegmentIndex = [User sharedUser].IntsegBlockhours;
        self.RestTime.enabled = NO;
        self.txtRestTime.textColor = [UIColor lightGrayColor];
        
        self.tblvcresttime.userInteractionEnabled = NO;
        self.tblvcresttime.accessoryType = UITableViewCellAccessoryNone;
    }else{
        //	self.segBlockHours.selectedSegmentIndex = [User sharedUser].IntsegBlockhours;
        self.swcInFlightRelief.on = [User sharedUser].BolswcInFlightRelief;
        self.segBlockHours.enabled = NO;
        
        if ([User sharedUser].BolswcInFlightRelief == YES) {
            self.segRestTakenIn.enabled = YES;
            self.RestTime.enabled = YES;
            self.txtRestTime.textColor = [UIColor darkGrayColor];
            
            self.segRestTakenIn.selectedSegmentIndex = [User sharedUser].IntsegRestTakenIn;
            self.tblvcresttime.userInteractionEnabled = YES;
            self.tblvcresttime.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            self.segRestTakenIn.enabled = NO;
            self.RestTime.enabled = NO;
            self.txtRestTime.textColor = [UIColor lightGrayColor];
            
            self.tblvcresttime.userInteractionEnabled = NO;
            self.tblvcresttime.accessoryType = UITableViewCellAccessoryNone;
            //        self.segRestTakenIn.selectedSegmentIndex = [User sharedUser].IntsegRestTakenIn;
        }
    }
    
    if ([User sharedUser].BolSectorLess7hrs == NO) {
        self.tabLongRange.badgeValue = @"ON";
        //lblRestTime.text = @"00:00";
    }
    else {
        self.tabLongRange.badgeValue = nil;
        self.txtRestTime.text = [@"00:00" stringByAppendingString:@" hrs"];
    }
    
    self.totalDays = [NSNumber numberWithDouble:
                      ([User sharedUser].ReliefRestTime / 86400)];
    self.totalHours = [NSNumber numberWithDouble:
                       (([User sharedUser].ReliefRestTime / 3600) -
                        ([self.totalDays intValue] * 24))];
    self.totalMinutes = [NSNumber numberWithDouble:
                         (([User sharedUser].ReliefRestTime / 60) -
                          ([self.totalDays intValue] * 24 * 60) -
                          ([self.totalHours intValue] * 60))];
    self.totalSeconds = [NSNumber numberWithInt:
                         ([User sharedUser].ReliefRestTime % 60)];
    NSInteger intHours;
    intHours = [self.totalHours intValue];
    NSInteger intMinutes;
    intMinutes = [self.totalMinutes intValue];
    self.txtRestTime.text = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"];
    [StartFDPTableViewController calcLimitingFDP];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)info2PilotsLongRange:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"2 Pilots Long Range Ops"
                          message:@"When an airplane flight crew is only two pilots, the allowable FDP shall be calculated as follows. A sector scheduled for more than 7 hours is considered as a multi-sector flight."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
}


- (IBAction)infoinflightRelief:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Inflight Relief"
                          message:@"When any additional crew member is carried to provide in-flight relief with the intent of extending a FDP, that individual shall hold qualifications, which are equal or superior to those held by the crew member who is to be rested."
                          @"To take advantage of this facility, the division of duty and rest between crew members must be kept in balance."
                          @"Time available for rest is planned flight time minus 1 hour — (30 mins for take off and climb, and 30 mins for descent and landing). A total in-flight rest of less than three hours will not allow for the extension of an FDP, but where the total in-flight rest, which need not be consecutive, is three hours or more, then the permitted FDP may be extended beyond that permitted."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
}

- (IBAction)infoBunkOrBed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Bunk or Seat"
                          message:@"If rest is taken in a bunk or flat-bed first or business class seat: A period equal to one half of the total rest taken, provided that the maximum FDP permissible shall be 18 hours (or 19 hours in the case of Cabin Crew)."
                          @"If rest is taken in a seat: A period equal to one third of the total rest taken, provided that the maximum FDP permissible shall be 15 hours (or 16 hours in the case of Cabin Crew)."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
}

- (IBAction)info2Pilots:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"3 Pilots"
                          message:@"When an additional, current, type rated pilot is carried as a crew member, then the modified numbers of sectors for 2 pilots long range operations do not apply and the admissible FDP is determined by entering the applicable Table A or B above with time of start and actual sectors planned."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
}
- (IBAction)enableRestTaken:(id)sender
{
    if (self.swcInFlightRelief.on) {
        self.segRestTakenIn.enabled = YES;
        self.RestTime.enabled = YES;
        self.txtRestTime.textColor = [UIColor darkGrayColor];
        self.tblvcresttime.userInteractionEnabled = YES;
//        self.tblvcresttime.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [User sharedUser].BolswcInFlightRelief = YES;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
//        
//        
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
        //		[strMaxFDP release];
        
    }
    else {
        self.segRestTakenIn.enabled = NO;
        self.RestTime.enabled = NO;
        self.txtRestTime.textColor = [UIColor lightGrayColor];
        
        self.tblvcresttime.userInteractionEnabled = NO;
//        self.tblvcresttime.accessoryType = UITableViewCellAccessoryNone;
        [User sharedUser].BolswcInFlightRelief = NO;
        [User sharedUser].IntInflightRestTime = 0;
        [User sharedUser].ReliefRestTime = 0;
        self.txtRestTime.text = [@"00:00" stringByAppendingString:@" hrs"];
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
//        
//        
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
        //		[strMaxFDP release];
    }
    
}


- (IBAction)enable3pilots:(id)sender
{
    if (self.segPilots.selectedSegmentIndex == 1) {
        self.swcInFlightRelief.enabled = YES;
        [User sharedUser].BolSectorSelected = NO;
        self.swcInFlightRelief.on = [User sharedUser].BolswcInFlightRelief;
        self.segBlockHours.enabled = NO;
        //	    self.segBlockHours.tintColor = nil;
        
        
        //[User sharedUser].IntsegBlockhours = segBlockHours.selectedSegmentIndex;
        
        [User sharedUser].IntsegPilots = 1;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
//        
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
        //		[strMaxFDP release];
        
    }
    else {
        if ([User sharedUser].BolSectorLess7hrs == NO && [User sharedUser].IntsegBlockhours == 2 && [User sharedUser].IntSegBodyClock == 1) {
            self.segBlockHours.tintColor = [UIColor colorWithRed:0.70 green:0.171 blue:0.1 alpha:1.0];
        }
        else {
            //			self.segBlockHours.tintColor = nil;
        }
        
        self.swcInFlightRelief.on = NO;
        [User sharedUser].BolswcInFlightRelief = NO;
        [User sharedUser].IntInflightRestTime = 0;
        [User sharedUser].ReliefRestTime = 0;
        self.tblvcresttime.userInteractionEnabled = NO;
        self.tblvcresttime.accessoryType = UITableViewCellAccessoryNone;
        self.txtRestTime.text = [@"00:00" stringByAppendingString:@" hrs"];
        
        self.swcInFlightRelief.enabled = NO;
        self.segBlockHours.enabled = YES;
        [User sharedUser].IntsegBlockhours = self.segBlockHours.selectedSegmentIndex;
        [User sharedUser].IntsegPilots = 0;
        
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
//        
//        
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
    }
}



- (IBAction)setRestTakenIn:(id)sender
{
    if (self.segRestTakenIn.selectedSegmentIndex == 0) {
        [User sharedUser].IntsegRestTakenIn = 0;
        [User sharedUser].BolsegBunk = YES;
        [User sharedUser].BolsegSeat = NO;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
//        
//        
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
        
    }
    else {
        [User sharedUser].IntsegRestTakenIn = 1;
        [User sharedUser].BolsegSeat = YES;
        [User sharedUser].BolsegBunk = NO;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
        
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
        //		[strMaxFDP release];
    }
    
}
- (IBAction)setBlockhours:(id)sender
{
    
    [User sharedUser].IntsegBlockhours = self.segBlockHours.selectedSegmentIndex;
    if (self.segBlockHours.selectedSegmentIndex == 2 && [User sharedUser].BolAcclimatized == NO)  {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Long Range - Non Acclimatised"
                              message:@"Over 11 hours = NOT APPLICABLE!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        //		[alert release];
        //segBlockHours.selectedSegmentIndex = 1;
        //		self.segBlockHours.tintColor = [UIColor colorWithRed:0.70 green:0.171 blue:0.1 alpha:1.0];
    }
    else {
        //		self.segBlockHours.tintColor = nil;
        [StartFDPTableViewController  calcLimitingFDP];
    }
    
    
//    NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
//    
//    
//    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//    //	[strMaxFDP release];
    
}
- (IBAction)showPicker:(id)sender
{
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    UIView *popoverView = [[UIView alloc] init];   //view
    self.arrayHours = [[NSMutableArray alloc] init];
    NSInteger intHour = 3;
    do {
        
        NSString *strHours = [NSString stringWithFormat:@"%li", (long)intHour];
        [self.arrayHours addObject:strHours];
        intHour = intHour + 1;
        
    } while (intHour <= 22);
    self.arrayMinutes = [[NSMutableArray alloc] init];
    NSInteger intMinute = 0;
    do {
        
        NSString *strMinutes = [NSString stringWithFormat:@"%li", (long)intMinute];
        [self.arrayMinutes addObject:strMinutes];
        intMinute = intMinute + 1;
        
    } while (intMinute <= 59);
    _datePicker=[[UIPickerView alloc]init];//Date picker
    _datePicker.delegate = self;
    [_datePicker selectRow:0 inComponent:0 animated:NO]; //Hours
    [_datePicker selectRow:0 inComponent:2 animated:NO]; //Minutes
    popoverView.backgroundColor = [UIColor clearColor];
    _datePicker.frame=CGRectMake(0,44,320, 200);
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(changeDateFromLabel:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    [popoverView addSubview:toolBar];
    NSNumber *totalDaysRest = [NSNumber numberWithDouble:
                               ([User sharedUser].ReliefRestTime / 86400)];
    NSNumber *totalHoursRest = [NSNumber numberWithDouble:
                                (([User sharedUser].ReliefRestTime / 3600) -
                                 ([totalDaysRest intValue] * 24))];
    NSNumber *totalMinutesRest = [NSNumber numberWithDouble:
                                  (([User sharedUser].ReliefRestTime / 60) -
                                   ([totalDaysRest intValue] * 24 * 60) -
                                   ([totalHoursRest intValue] * 60))];
    NSInteger intHoursRest;
    intHoursRest = [totalHoursRest intValue];
    NSInteger intMinutesRest;
    intMinutesRest = [totalMinutesRest intValue];
    if (intHoursRest < 3) {
        intHoursRest = 0;
    } else {
        intHoursRest = intHoursRest- 3;
    }
    [_datePicker selectRow:intHoursRest inComponent:0 animated:NO];
    [_datePicker selectRow:intMinutesRest inComponent:2 animated:NO];
    [popoverView addSubview:_datePicker];
    popoverContent.view = popoverView;
    CGRect myFrame =self.txtRestTime.frame;
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 244) animated:NO];
    [popoverController presentPopoverFromRect:myFrame inView:self.tblvcresttime permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)changeDateFromLabel:(id)sender
{
    [self.txtRestTime resignFirstResponder];
    [popoverController dismissPopoverAnimated:YES];
    [self result];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.txtRestTime)
    {
        [self showPicker:self];
        return NO;
    }
    return NO;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    
    // note: custom picker doesn't care about titles, it uses custom views
    if (pickerView == _datePicker)
    {
        if (component == 0)
        {
            returnStr = [self.arrayHours objectAtIndex:row];
        }
        if (component == 1)
        {
            returnStr = @"hours";
        }
        if (component == 2)
        {
            returnStr = [self.arrayMinutes objectAtIndex:row];
            //            if ([[self.arrayHours objectAtIndex:row] isEqualToString:@"10"]){
            //                returnStr = @"0";
            //            }
            
        }
        if (component == 3)
        {
            returnStr = @"min";
        }
        //		else
        //		{
        //			returnStr = @"Hours";
        //		}
    }
    
    return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = 0.0;
    
    if (component == 1)
        componentWidth = 80.0;	// first column size is wider to hold names
    else
        componentWidth = 50.0;	// second column is narrower to show numbers
    
    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.arrayHours count];
    }
    if (component == 2) {
        return [self.arrayMinutes count];
    }else{
        return  1;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [User sharedUser].IntSplitDuty = ([thePickerView selectedRowInComponent:0]*60*60 + [thePickerView selectedRowInComponent:0]*60)/2;
    [StartFDPTableViewController calcLimitingFDP];
//    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
    //    //    [strMaxFDP release];
    //    NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
    //    [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
    
    
    //    intFlightLevelpicker = [[arrayFlightLevel objectAtIndex:row] intValue];
    
}

-(void) result

{
    [User sharedUser].ReliefRestTime = [[self.arrayHours objectAtIndex:[_datePicker selectedRowInComponent:0]]intValue]*60*60;
    [User sharedUser].ReliefRestTime = [User sharedUser].ReliefRestTime + [[self.arrayMinutes objectAtIndex:[_datePicker selectedRowInComponent:2]] intValue]*60;
    
    self.totalDays = [NSNumber numberWithDouble:
                      ([User sharedUser].ReliefRestTime / 86400)];
    self.totalHours = [NSNumber numberWithDouble:
                       (([User sharedUser].ReliefRestTime / 3600) -
                        ([self.totalDays intValue] * 24))];
    self.totalMinutes = [NSNumber numberWithDouble:
                         (([User sharedUser].ReliefRestTime / 60) -
                          ([self.totalDays intValue] * 24 * 60) -
                          ([self.totalHours intValue] * 60))];
    self.totalSeconds = [NSNumber numberWithInt:
                         ([User sharedUser].ReliefRestTime % 60)];
    NSInteger intHours;
    intHours = [self.totalHours intValue];
    NSInteger intMinutes;
    intMinutes = [self.totalMinutes intValue];
    self.txtRestTime.text = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"];
    [StartFDPTableViewController calcLimitingFDP];
//    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
    
}

@end
