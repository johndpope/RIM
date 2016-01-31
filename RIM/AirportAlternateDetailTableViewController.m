//
//  AirportDetailTableViewController.m
//  RIM
//
//  Created by Mikel on 03.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "AirportAlternateDetailTableViewController.h"
#import "AirportAlternateCategorieTableViewController.h"
#import "PopOverAirportTableViewController.h"
#import "Fiddler.h"
#import "Airports.h"
#import "User.h"
#import "SDCoreDataController.h"
#import "Airport.h"
#import "PrayerTimesTableViewController.h"
#import "ReaderViewController.h"

@interface AirportAlternateDetailTableViewController () < QLPreviewControllerDataSource, QLPreviewControllerDelegate>
{
    NSURL *fileURL;
    ReaderViewController *readerViewController;

}
@property(nonatomic,retain) NSURL *fileURL;

@end

@implementation AirportAlternateDetailTableViewController
@synthesize fileURL;



- (void)viewDidLoad {
    [super viewDidLoad];
//    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.navigationItem.title = self.airport.icaoidentifier;
//    [self configureView];
    UIBarButtonItem *myBarButtonItem = [[UIBarButtonItem alloc] init];
    myBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(myBarButtonItemPressed)];
    self.navigationItem.leftBarButtonItem = myBarButtonItem;
   
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    [self.tableView reloadData];
}

- (void)setAirport:(Airport *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;

    }
}
- (void)myBarButtonItemPressed
{
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureView
{
    
    self.navigationItem.title = @"";
    _cellName.detailTextLabel.text = [self.airport.name length] ? self.airport.name : @"";
    _cellIATA.detailTextLabel.text   = [self.airport.iataidentifier length] ? self.airport.iataidentifier : @"N/A";
    self.cellICAO.detailTextLabel.text = [self.airport.icaoidentifier length] ? self.airport.icaoidentifier : @"N/A";
    self.cellCity.detailTextLabel.text = [self.airport.city length] ? self.airport.city : @"";
    
    //    self.timezone.text = [self.airport.timezone length] ? self.airport.timezone : @"None";
    //    self.atis.text = [self.airport.atis length] ? self.airport.atis : @"None";
    //    [self.swcEnrouteAlternate setOn:([self.airport.adequate boolValue])];
    //    self.region.text = [self.airport.region length] ? self.airport.region : @"None";
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segShowCategory"])
    {
//        Airports *airport = nil;
//        airport = [[User sharedUser].arrAirport objectAtIndex:0];
        AirportAlternateCategorieTableViewController *controller = (AirportAlternateCategorieTableViewController *)[segue destinationViewController];
        [controller setAirport:_airport];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if ([segue.identifier isEqualToString:@"segPrayerTimes"])
    {
        PrayerTimesTableViewController *controller = (PrayerTimesTableViewController *)[segue destinationViewController];
        [controller setAirport:_airports];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
//    Airport *airport = [[User sharedUser].arrAirport objectAtIndex:0];
    self.cellName.detailTextLabel.text = [_airport.name length] ? self.airport.name : @"";
    self.cellIATA.detailTextLabel.text   = [_airport.iataidentifier length] ? self.airport.iataidentifier : @"N/A";
    self.cellICAO.detailTextLabel.text = [self.airport.icaoidentifier length] ? self.airport.icaoidentifier : @"N/A";
    self.cellCity.detailTextLabel.text = [self.airport.city length] ? self.airport.city : @"";
    self.cellElevation.detailTextLabel.text = [[[NSString alloc]initWithFormat:@"%.0f",self.airport.elevation] stringByAppendingString:@" ft"];
    self.cellRFF.detailTextLabel.text = [self.airport.rff length] ? self.airport.rff : @"TBA";
    if ([self.airport.rffnotes isEqualToString:@""]) {
        self.cellRFF.accessoryType = UITableViewCellAccessoryNone;
    }
    [self calcTimeZone];
    [self calcCoordinates];
    [self calcAirportSunriseSunset];
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]];
    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];

}



-(void) calcCoordinates
{
    double dblLatitude;
    dblLatitude = self.airport.latitude;
    if (dblLatitude >= 0) {
        self.cellLatitude.detailTextLabel.text = [[NSString alloc]initWithFormat:@"%02.0f°%02.1f N", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    } else {
        dblLatitude = dblLatitude*-1;
        self.cellLatitude.detailTextLabel.text = [[NSString alloc]initWithFormat:@"%02.0f°%02.1f S", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    }
    double dblLongitude;
    dblLongitude = self.airport.longitude;
    if (dblLongitude >= 0) {
       
        self.cellLongitude.detailTextLabel.text = [[NSString alloc]initWithFormat:@"%03.0f°%02.1f E", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60];
    } else {
         dblLongitude = dblLongitude*-1;
        self.cellLongitude.detailTextLabel.text = [[NSString alloc]initWithFormat:@"%03.0f°%02.1f W", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60];
    }

}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(void) calcTimeZone
{
    
    NSTimeZone *currentTimeZone =
    [NSTimeZone timeZoneWithName:self.airport.timezone];
    NSInteger GMTOffset;
    GMTOffset = [currentTimeZone secondsFromGMT];
    
    NSNumber *totalDays = [NSNumber numberWithDouble:
                           (GMTOffset / 86400)];
    NSNumber *totalHours = [NSNumber numberWithDouble:
                            ((GMTOffset / 3600) -
                             ([totalDays intValue] * 24))];
    NSNumber *totalMinutes = [NSNumber numberWithDouble:
                              ((GMTOffset / 60) -
                               ([totalDays intValue] * 24 * 60) -
                               ([totalHours intValue] * 60))];
    NSInteger intHours;
    intHours = [totalHours intValue];
    NSInteger intMinutes;
    intMinutes = [totalMinutes intValue];
    
    
    
    if (intHours < 0) {
        if (intMinutes < 15)
        {
//            self.cellTimezone.textLabel.text = @"Timezone:";
            self.cellTimezone.detailTextLabel.text = [[[NSString alloc] initWithFormat:@"%-.2li:00", (long)intHours]stringByAppendingString:@" hrs"];
//            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
//            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
//            cell.textLabel.textColor = [UIColor darkGrayColor];
//            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
        else {
//            cell.textLabel.text = @"Timezone:";
            self.cellTimezone.detailTextLabel.text = [[[NSString alloc] initWithFormat:@"%-.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"];
//            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
//            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
//            cell.textLabel.textColor = [UIColor darkGrayColor];
//            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
    }
    else {
        if (intMinutes < 15)
        {
//            cell.textLabel.text = @"Timezone:";
            self.cellTimezone.detailTextLabel.text = [[[NSString alloc] initWithFormat:@"%+.2li:00", (long)intHours]stringByAppendingString:@" hrs"];
//            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
//            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
//            cell.textLabel.textColor = [UIColor darkGrayColor];
//            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
        else {
//            cell.textLabel.text = @"Timezone:";
            self.cellTimezone.detailTextLabel.text = [[[NSString alloc] initWithFormat:@"%+.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"];
//            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
//            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
//            cell.textLabel.textColor = [UIColor darkGrayColor];
//            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
    }
}



-(void) calcAirportSunriseSunset
{
    //    NSInteger GMTOffset;
    //    GMTOffset = intTimedifference;
    NSDate* date = [NSDate date];
    NSTimeZone* tz =  [NSTimeZone timeZoneForSecondsFromGMT:(0 * 3600)];
    double dblLongitude = self.airport.longitude;
    dblLongitude = -dblLongitude;
    
    Fiddler* fiddlerAirport = [[Fiddler alloc] initWithDate:date timeZone:tz latitude:self.airport.latitude longitude:dblLongitude];
    [fiddlerAirport reload];
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsSR = [gregorian components:unitFlags fromDate:fiddlerAirport.sunrise];
    // Now extract the hour:mins from today's date
    NSInteger hourSR = [compsSR hour];
    NSInteger minSR = [compsSR minute];
    NSInteger intSunriseUTC = ((hourSR*60)+minSR)*60;
    NSTimeZone *currentTimeZone =
    [NSTimeZone timeZoneWithName:self.airport.timezone];
    NSInteger GMTOffset;
    GMTOffset = [currentTimeZone secondsFromGMT];
    intSunriseUTC = intSunriseUTC + GMTOffset;
    if (intSunriseUTC < 0) {
        intSunriseUTC = 86400 + intSunriseUTC;
    }
    NSNumber *totalDaysSR = [NSNumber numberWithDouble:
                             (intSunriseUTC / 86400)];
    NSNumber *totalHoursSR = [NSNumber numberWithDouble:
                              ((intSunriseUTC / 3600) -
                               ([totalDaysSR intValue] * 24))];
    NSNumber *totalMinutesSR = [NSNumber numberWithDouble:
                                ((intSunriseUTC / 60) -
                                 ([totalDaysSR intValue] * 24 * 60) -
                                 ([totalHoursSR intValue] * 60))];
    NSInteger intHoursSR;
    intHoursSR = [totalHoursSR intValue];
    NSInteger intMinutesSR;
    intMinutesSR = [totalMinutesSR intValue];
    [compsSR setHour:intHoursSR];
    [compsSR setMinute:intMinutesSR];
    
    self.cellSunrise.detailTextLabel.text = [[[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSR,(long)minSR] stringByAppendingString:@" UTC / "] stringByAppendingString:[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursSR,(long)intMinutesSR]]stringByAppendingString:@" LCL"];
    //
    NSDateComponents *compsSS = [gregorian components:unitFlags fromDate:fiddlerAirport.sunset];
    NSInteger hourSS = [compsSS hour];
    NSInteger minSS = [compsSS minute];
    NSInteger intSunsetUTC = ((hourSS*60)+minSS)*60;
    
    intSunsetUTC = intSunsetUTC + GMTOffset;
    if (intSunsetUTC < 0) {
        intSunsetUTC = 86400 + intSunsetUTC;
    }
    NSNumber *totalDaysSS = [NSNumber numberWithDouble:
                             (intSunsetUTC / 86400)];
    NSNumber *totalHoursSS = [NSNumber numberWithDouble:
                              ((intSunsetUTC / 3600) -
                               ([totalDaysSS intValue] * 24))];
    NSNumber *totalMinutesSS = [NSNumber numberWithDouble:
                                ((intSunsetUTC / 60) -
                                 ([totalDaysSS intValue] * 24 * 60) -
                                 ([totalHoursSS intValue] * 60))];
    NSInteger intHoursSS;
    intHoursSS = [totalHoursSS intValue];
    NSInteger intMinutesSS;
    intMinutesSS = [totalMinutesSS intValue];
    [compsSS setHour:intHoursSS];
    [compsSS setMinute:intMinutesSS];
   
    
    
    self.cellSunset.detailTextLabel.text = [[[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSS,(long)minSS] stringByAppendingString:@" UTC / "] stringByAppendingString:[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursSS,(long)intMinutesSS]]stringByAppendingString:@" LCL"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger intRow = indexPath.row;
    NSInteger intSection = indexPath.section;
    switch (intSection) {
        case 1:
            switch (intRow) {
                case 6:
                    [self performSegueWithIdentifier:@"segPrayerTimes" sender:self];
                    break;
                    
                default:
                    break;
            }
        case 3:
                switch (intRow) {
                        case 0:
                        {
                            NSString *strPathDir = [@"/Airportbriefing/" stringByAppendingString:self.airport.icaoidentifier];
                            NSString *strPath = [[NSBundle mainBundle] pathForResource:[[strPathDir stringByAppendingString:@"/"]stringByAppendingString:self.airport.icaoidentifier] ofType:@"pdf"];
                            if (strPath == nil ) {
                                UIAlertController *alertController = [UIAlertController
                                                                      alertControllerWithTitle:@"Alert"
                                                                      message:@"No File found!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction
                                                           actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action)
                                                           {
                                                               NSLog(@"OK action");
                                                           }];
                                [alertController addAction:okAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                                
                            } else {
                                [User sharedUser].strPathDocuments = strPath;
                                readerViewController = [[ReaderViewController alloc] initWithNibName:nil bundle:nil]; // Demo controller
                                [[self navigationController] pushViewController:readerViewController animated:NO];
                            }
                            break;
                        }
                        case 1:
                        {
                            NSString *path = [[NSBundle mainBundle] pathForResource:[self.airport.icaoidentifier stringByAppendingString:@"Layoverinfo"] ofType:@"pdf"];
                            if (path == nil ) {
                                UIAlertController *alertController = [UIAlertController
                                                                      alertControllerWithTitle:@"Alert"
                                                                      message:@"No File found!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction
                                                           actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action)
                                                           {
                                                               NSLog(@"OK action");
                                                           }];
                                [alertController addAction:okAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                                
                            } else {
                            fileURL = [NSURL fileURLWithPath:path];
                            QLPreviewController *previewController = [[QLPreviewController alloc] init];
                            previewController.dataSource = self;
                            [[self navigationController] pushViewController:previewController animated:YES];
                                
                            }
                        }
                            break;
                    }
                    break;
                default:
                    break;
            }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark QLPreviewControllerDataSource
    
    // Returns the number of items that the preview controller should preview
    - (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
    {
        return 1; //you can increase the this
    }
    
    // returns the item that the preview controller should preview
    - (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
    {
        return fileURL;
    }
    

@end
