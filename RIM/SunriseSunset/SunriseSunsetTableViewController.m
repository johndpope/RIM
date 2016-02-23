//
//  SunriseSunsetTableViewController.m
//  RIM
//
//  Created by Michael Gehringer on 8/11/15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "SunriseSunsetTableViewController.h"
#import "StartTableViewController.h"
#import "SunFlightresults.h"
#import "User.h"
#import "objLog.h"

@interface SunriseSunsetTableViewController () <MBProgressHUDDelegate>
{
MBProgressHUD *HUD;
}
@end
BOOL bolSunrise;

@implementation SunriseSunsetTableViewController
@synthesize btnTakeOffTime,btnUpdate;
//NSString * const DateFormat = @"dd/MMM/yyyy";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 55;
    bolSunrise = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ReadSunrise"] boolValue];
    if ([[User sharedUser].arrayLog count] != 0) {
        btnUpdate = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(showWithLabel)];
        btnTakeOffTime = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(showPicker:)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnTakeOffTime,btnUpdate, nil]];
        NSNumber *totalDaysUTC = [NSNumber numberWithDouble:
                                  ([User sharedUser].intTimeOvhdFROM / 86400)];
        NSNumber *totalHoursUTC = [NSNumber numberWithDouble:
                                   (([User sharedUser].intTimeOvhdFROM / 3600) -
                                    ([totalDaysUTC intValue] * 24))];
        NSNumber *totalMinutesUTC = [NSNumber numberWithDouble:
                                     (([User sharedUser].intTimeOvhdFROM / 60) -
                                      ([totalDaysUTC intValue] * 24 * 60) -
                                      ([totalHoursUTC intValue] * 60))];
        NSInteger intHoursUTC;
        intHoursUTC = [totalHoursUTC intValue];
        NSInteger intMinutesUTC;
        intMinutesUTC = [totalMinutesUTC intValue];
        btnTakeOffTime.title = [[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursUTC,(long)intMinutesUTC]stringByAppendingString:@" UTC"];

    }else{
        
    }
    
    }

- (IBAction)updateSunriseCalc:(id)sender
{
    NSMutableIndexSet *matchingIndexes = [NSMutableIndexSet indexSet];
    for (NSUInteger n = [User sharedUser].arrayLog.count, i = 0; i < n; ++i) {
        
        objLog *result = [User sharedUser].arrayLog[i];
        if ([result.strType isEqualToString:@"Prayer"] || [result.strType isEqualToString:@"SSSR"])
            [matchingIndexes addIndex:i];
    }
    [[User sharedUser].arrayLog removeObjectsAtIndexes:matchingIndexes];

    [StartTableViewController calculateSunriseSunset];
    [self.tblResults reloadData];
}
- (void)showWithLabel {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Calculating ...";
    
    [HUD showWhileExecuting:@selector(updateSunriseCalc:) onTarget:self withObject:nil animated:YES];
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
    NSNumber *totalDays = [NSNumber numberWithDouble:
                 ([User sharedUser].intTimeOvhdFROM / 86400)];
    NSNumber *totalHours = [NSNumber numberWithDouble:
                  (([User sharedUser].intTimeOvhdFROM / 3600) -
                   ([totalDays intValue] * 24))];
    NSNumber *totalMinutes = [NSNumber numberWithDouble:
                    (([User sharedUser].intTimeOvhdFROM / 60) -
                     ([totalDays intValue] * 24 * 60) -
                     ([totalHours intValue] * 60))];
    NSInteger hour;
    hour = [totalHours intValue];
    NSInteger min;
    min = [totalMinutes intValue];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hour];
    [components setMinute:min];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [_datePicker setDate:[gregorian dateFromComponents:components]];
    [popoverView addSubview:_datePicker];
    popoverContent.view = popoverView;
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void) result

{
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:_datePicker.date];
    // Now extract the hour:mins from today's date
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    
    [User sharedUser].intTimeOvhdFROM = ((hour*60)+min)*60;
        if ([User sharedUser].intTimeOvhdFROM < 0) {
        [User sharedUser].intTimeOvhdFROM = 86400 + [User sharedUser].intTimeOvhdFROM;
    }
    NSLog(@"%ld", (long)[User sharedUser].intTimeOvhdFROM);
    NSNumber *totalDaysUTC = [NSNumber numberWithDouble:
                              ([User sharedUser].intTimeOvhdFROM / 86400)];
    NSNumber *totalHoursUTC = [NSNumber numberWithDouble:
                               (([User sharedUser].intTimeOvhdFROM / 3600) -
                                ([totalDaysUTC intValue] * 24))];
    NSNumber *totalMinutesUTC = [NSNumber numberWithDouble:
                                 (([User sharedUser].intTimeOvhdFROM / 60) -
                                  ([totalDaysUTC intValue] * 24 * 60) -
                                  ([totalHoursUTC intValue] * 60))];
    NSInteger intHoursUTC;
    intHoursUTC = [totalHoursUTC intValue];
    NSInteger intMinutesUTC;
    intMinutesUTC = [totalMinutesUTC intValue];
    btnTakeOffTime.title = [[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursUTC,(long)intMinutesUTC]stringByAppendingString:@" UTC"];
    
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strType == %@", @"SSSR"];
        NSArray *result = [[User sharedUser].arrayResults filteredArrayUsingPredicate: predicate];
        return [result count];
    }
    if (section == 3) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strType == %@", @"Prayer"];
        NSArray *result = [[User sharedUser].arrayResults filteredArrayUsingPredicate: predicate];
        return [result count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *cellIdentifier = @"cellOFPImport";
        SunriseOfpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        if (cell == nil) {
            cell = [[SunriseOfpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.swcFltPln.on = bolSunrise;
        return cell;
    }
    
    if (indexPath.section == 1) {
        NSString *cellIdentifier = @"cellFLIGHTPLAN";
        SunriseFlightplanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[SunriseFlightplanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if ([[User sharedUser].arrayLog count] != 0) {
            cell.lblFlightPlan.text = [User sharedUser].strFlightPlanTitle;
            cell.imgViewLog.image = [UIImage imageNamed:@"waypoint_map-32.png"];
        } else {
        cell.lblFlightPlan.text = @"No FlightPlan loaded";
        cell.imgViewLog.image = [UIImage imageNamed:@"high_priority-32.png"];
        }
        return cell;
    }
    if (indexPath.section == 2) {
        NSString *cellIdentifier = @"cellSUNRISE";
        SunriseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[SunriseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        SunFlightresults *Result = [[SunFlightresults alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strType == %@", @"SSSR"];
        NSArray *result = [[User sharedUser].arrayResults filteredArrayUsingPredicate: predicate];
        if (indexPath.row < [result count]) {
            Result = [result objectAtIndex:indexPath.row];
            cell.lblnamewpt.text = Result.strWptName;
            if ([Result.strWptName isEqualToString:@"Sunrise"] || [Result.strWptName isEqualToString:@"Sunrise (2)"]) {
                cell.imgViewLog.image = [UIImage imageNamed:@"sunrise-32.png"];
            }else{
            cell.imgViewLog.image = [UIImage imageNamed:@"sunset-32.png"];
            }
            cell.lblLat.text = @"";
            cell.lblLon.text = @"";
            cell.lblAirways.text = Result.strTime;
            cell.lblEET.text = Result.strCET;
            cell.lblFlightlevel.text = [@"FL" stringByAppendingString:Result.strFlightLevel];
        }
        return cell;
    }
    if (indexPath.section == 3) {
        NSString *cellIdentifier = @"cellPRAYER";
        SunrisePrayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[SunrisePrayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        SunFlightresults *Result = [[SunFlightresults alloc] init];
        Result = [[User sharedUser].arrayResults objectAtIndex:indexPath.row];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strType == %@", @"Prayer"];
        NSArray *result = [[User sharedUser].arrayResults filteredArrayUsingPredicate: predicate];
        if (indexPath.row < [result count]) {
            Result = [result objectAtIndex:indexPath.row];
            cell.lblnamewpt.text = Result.strWptName;
            cell.lblLat.text = @"";
            cell.lblLon.text = @"";
            cell.lblAirways.text = Result.strTime;
            cell.lblEET.text = Result.strCET;
            cell.lblFlightlevel.text = [@"FL" stringByAppendingString:Result.strFlightLevel];
        }
        return cell;
    }

    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger Section = indexPath.section;
    NSInteger Row   = indexPath.row;
    
    if (Section == 1)
    {
        if (Row == 0) {

        }
    }
}

- (IBAction)switchAction:(id)sender {
    
    bolSunrise =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"ReadSunrise"] boolValue];
    
    if(bolSunrise == NO)
        
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ReadSunrise"];
        [User sharedUser].bolCalcSSSR = YES;
        
    }
    
    else
        
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ReadSunrise"];
        [User sharedUser].bolCalcSSSR = NO;
    }
    
}


@end
