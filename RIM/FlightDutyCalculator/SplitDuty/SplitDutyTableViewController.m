//
//  SplitDutyTableViewController.m
//  RIM
//
//  Created by Michael Gehringer on 9/1/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import "SplitDutyTableViewController.h"

@interface SplitDutyTableViewController ()
@property (nonatomic, retain) IBOutlet UISwitch *swcSplitDuty;
@property (nonatomic, retain) IBOutlet UILabel *lblSplitDuty;
@property (nonatomic, retain) IBOutlet UILabel *lblSplitDutyTime;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcSplitRest;
@property (nonatomic, retain) IBOutlet UITextField *txtSplitDutyTime;
@property (nonatomic, retain) NSNumber *totalDays;
@property (nonatomic, retain) NSNumber *totalHours;
@property (nonatomic, retain) NSNumber *totalMinutes;
@property (nonatomic, retain) NSNumber *totalSeconds;
@property (nonatomic, strong) NSMutableArray *arrayHours;
@property (nonatomic, strong) NSMutableArray *arrayMinutes;

@end

@implementation SplitDutyTableViewController
@synthesize btnReportTime,btnReportTimetxt,popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 70;
//    btnReportTimetxt = [[UIBarButtonItem alloc] initWithTitle:@"Rest Time:" style:UIBarButtonItemStylePlain target:self action:@selector(setReporttimetxt:)];
//    btnReportTime = [[UIBarButtonItem alloc] initWithTitle:@"00:00" style:UIBarButtonItemStylePlain target:self action:@selector(showPicker:)];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnReportTime,btnReportTimetxt, nil]];
//    btnReportTime.title = [[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursUTC,(long)intMinutesUTC]stringByAppendingString:@""];
//    self.txtSplitDutyTime.text =
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
    self.arrayHours = [[NSMutableArray alloc] init];
    NSInteger intHour = 3;
    do {
        
        NSString *strHours = [NSString stringWithFormat:@"%li", (long)intHour];
        [self.arrayHours addObject:strHours];
        intHour = intHour + 1;
        
    } while (intHour <= 10);
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
    [User sharedUser].IntSplitDuty  = [User sharedUser].IntSplitDuty*2;
    NSNumber *totalDaysRest = [NSNumber numberWithDouble:
                               ([User sharedUser].IntSplitDuty / 86400)];
    NSNumber *totalHoursRest = [NSNumber numberWithDouble:
                                (([User sharedUser].IntSplitDuty / 3600) -
                                 ([totalDaysRest intValue] * 24))];
    NSNumber *totalMinutesRest = [NSNumber numberWithDouble:
                                  (([User sharedUser].IntSplitDuty / 60) -
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
    CGRect myFrame =self.txtSplitDutyTime.frame;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 244) animated:NO];
    [popoverController presentPopoverFromRect:myFrame inView:self.tblvcSplitRest permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)changeDateFromLabel:(id)sender
{
    [self.txtSplitDutyTime resignFirstResponder];
    [popoverController dismissPopoverAnimated:YES];
    [self result];
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
    [User sharedUser].IntSplitDutyPicker = [[self.arrayHours objectAtIndex:[_datePicker selectedRowInComponent:0]]intValue]*60*60;
    [User sharedUser].IntSplitDutyPicker = [User sharedUser].IntSplitDutyPicker + [[self.arrayMinutes objectAtIndex:[_datePicker selectedRowInComponent:2]] intValue]*60;
    self.totalDays = [NSNumber numberWithDouble:
                      ([User sharedUser].IntSplitDutyPicker / 86400)];
    self.totalHours = [NSNumber numberWithDouble:
                       (([User sharedUser].IntSplitDutyPicker / 3600) -
                        ([self.totalDays intValue] * 24))];
    self.totalMinutes = [NSNumber numberWithDouble:
                         (([User sharedUser].IntSplitDutyPicker / 60) -
                          ([self.totalDays intValue] * 24 * 60) -
                          ([self.totalHours intValue] * 60))];
    self.totalSeconds = [NSNumber numberWithInt:
                         ([User sharedUser].IntSplitDutyPicker % 60)];
    NSInteger intHours;
    intHours = [self.totalHours intValue];
    NSInteger intMinutes;
    intMinutes = [self.totalMinutes intValue];
    self.txtSplitDutyTime.text = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"];
    [User sharedUser].IntSplitDuty = [User sharedUser].IntSplitDutyPicker / 2;
    [StartFDPTableViewController calcLimitingFDP];
//    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
    
}
- (IBAction)setReporttimetxt:(id)sender
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)infoSplitDuty:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Split Duty"
                          message:@"When an FDP consists of two or more sectors/duties, of which one can be a positioning journey counted as a sector, but separated by less than a minimum rest period, then the FDP may be extended beyond that permitted."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //	[alert release];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.txtSplitDutyTime)
    {
        [self showPicker:self];
        return NO;
    }
    return NO;
}


- (IBAction)EnableSplitDuty:(id)sender
{
    if (self.swcSplitDuty.on == YES) {
        self.lblSplitDuty.enabled = YES;
        self.lblSplitDutyTime.enabled = YES;
        self.txtSplitDutyTime.textColor = [UIColor darkGrayColor];
       // [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:@"ON"];
        self.tblvcSplitRest.userInteractionEnabled = YES;
        self.txtSplitDutyTime.enabled = YES;
//        self.tblvcSplitRest.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [User sharedUser].BolswcSplitDuty = YES;
        [self UpdateSplitDuty];
    }
    else {
        self.lblSplitDuty.enabled = NO;
        self.lblSplitDutyTime.enabled = NO;
        self.tblvcSplitRest.userInteractionEnabled = NO;
        self.txtSplitDutyTime.enabled = NO;
        self.txtSplitDutyTime.textColor = [UIColor lightGrayColor];
//        self.tblvcSplitRest.accessoryType = UITableViewCellAccessoryNone;
        [User sharedUser].IntSplitDutyPicker = 0;
        [User sharedUser].BolswcSplitDuty = NO;
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:NO];
        self.txtSplitDutyTime.text = [@"00:00" stringByAppendingString:@" hrs"];
        [User sharedUser].IntSplitDuty = 0;
        [StartFDPTableViewController calcLimitingFDP];
//        NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//        //		[strMaxFDP release];
//        NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
        
    }
    
}


- (void)UpdateSplitDuty
{
    //	if (self.myRestTimePicker.countDownDuration >= 10800 && self.myRestTimePicker.countDownDuration <= 36000 ) {
    //		[User sharedUser].IntSplitDuty = (self.myRestTimePicker.countDownDuration/2);
    //	}
    //	else {
    //		[User sharedUser].IntSplitDuty = 0;
    //	}
    [User sharedUser].IntSplitDuty = [User sharedUser].IntSplitDutyPicker / 2;
    [StartFDPTableViewController calcLimitingFDP];
//    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
//    //	[strMaxFDP release];
//    NSString *strMaxFDPEND = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPENDHours, (long)[User sharedUser].IntMaxFDPENDMinutes] stringByAppendingString:@"Z"];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:strMaxFDPEND];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.totalDays = [NSNumber numberWithDouble:
                      ([User sharedUser].IntSplitDutyPicker / 86400)];
    self.totalHours = [NSNumber numberWithDouble:
                       (([User sharedUser].IntSplitDutyPicker / 3600) -
                        ([self.totalDays intValue] * 24))];
    self.totalMinutes = [NSNumber numberWithDouble:
                         (([User sharedUser].IntSplitDutyPicker / 60) -
                          ([self.totalDays intValue] * 24 * 60) -
                          ([self.totalHours intValue] * 60))];
    self.totalSeconds = [NSNumber numberWithInt:
                         ([User sharedUser].IntSplitDutyPicker % 60)];
    NSInteger intHours;
    intHours = [self.totalHours intValue];
    NSInteger intMinutes;
    intMinutes = [self.totalMinutes intValue];
    self.txtSplitDutyTime.text = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"];
    [User sharedUser].IntSplitDuty = [User sharedUser].IntSplitDutyPicker / 2;
    [StartFDPTableViewController calcLimitingFDP];
//    NSString *strMaxFDP = [[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)[User sharedUser].IntMaxFDPHours, (long)[User sharedUser].IntMaxFDPMinutes];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:strMaxFDP];
}
@end
