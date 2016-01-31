
//  AirportDetailTableViewController.m
//  RIM
//
//  Created by Mikel on 03.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.


#import "AirportDetailTableViewController.h"
#import "AirportCategorieTableViewController.h"
#import "AirportImportantLinksTableViewController.h"
#import "AirportLibraryTableViewController.h"
#import "Fiddler.h"
#import "Airports.h"
#import "User.h"
#import "SDCoreDataController.h"
#import "Airport.h"
#import "ReaderViewController.h"
#import "PrayerTimesTableViewController.h"
#import "AirportBriefingViewController.h"
#import "AirportbriefingTableViewController.h"

@interface AirportDetailTableViewController () < QLPreviewControllerDataSource, QLPreviewControllerDelegate>
{
    NSURL *fileURL;
}
@property(nonatomic,retain) NSURL *fileURL;

@end

@implementation AirportDetailTableViewController
{
    ReaderViewController *readerViewController;
}
@synthesize fileURL;


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = self.airport.icaoidentifier;
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
}

- (void)setAirport:(Airports *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segShowCategory"])
    {
        AirportCategorieTableViewController *controller = (AirportCategorieTableViewController *)[segue destinationViewController];
        [controller setAirport:_airport];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if ([segue.identifier isEqualToString:@"segShowImportantLinks"])
    {
        AirportLibraryTableViewController *controller = (AirportLibraryTableViewController *)[segue destinationViewController];
//        [controller setAirport:_airport];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if ([segue.identifier isEqualToString:@"segPrayerTimes"])
    {
        PrayerTimesTableViewController *controller = (PrayerTimesTableViewController *)[segue destinationViewController];
        [controller setAirport:_airport];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if ([segue.identifier isEqualToString:@"segAirport"])
    {
        AirportbriefingTableViewController *controller = (AirportbriefingTableViewController *)[segue destinationViewController];
        [controller setAirport:_airport];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }

    
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellName.detailTextLabel.text = [self.airport.name length] ? self.airport.name : @"";
    self.cellIATA.detailTextLabel.text   = [self.airport.iataidentifier length] ? self.airport.iataidentifier : @"N/A";
    self.cellICAO.detailTextLabel.text = [self.airport.icaoidentifier length] ? self.airport.icaoidentifier : @"N/A";
    self.cellCity.detailTextLabel.text = [self.airport.city length] ? self.airport.city : @"";
    self.cellCountry.detailTextLabel.text =[self.airport.country length] ? self.airport.country : @"";
    self.cellElevation.detailTextLabel.text = [[[NSString alloc]initWithFormat:@"%.0f",self.airport.elevation] stringByAppendingString:@" ft"];
    self.cellRFF.detailTextLabel.text = [self.airport.rff length] ? self.airport.rff : @"TBA";
    if ([self.airport.rffnotes isEqualToString:@""]) {
        self.cellRFF.accessoryType = UITableViewCellAccessoryNone;
    }
    [self calcTimeZone];
    [self calcCoordinates];
    [self calcAirportSunriseSunset];
//    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
    [cell setBackgroundColor:[UIColor clearColor]];
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
- (IBAction)addToTripkit:(id)sender {
{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:[@"Airport " stringByAppendingString:self.airport.icaoidentifier]
                                              message:[[@"Do you want to add " stringByAppendingString:self.airport.icaoidentifier] stringByAppendingString:@" to your enroute Airport list ?"]
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"NO", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                           //                                       [self.parentViewController.navigationController popViewControllerAnimated:YES];
                                       }];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"YES", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       Airport *EnrAirport = [[Airport alloc] init];
                                       EnrAirport.iataidentifier = self.airport.iataidentifier;
                                       EnrAirport.icaoidentifier = self.airport.icaoidentifier;
                                       EnrAirport.name = self.airport.name;
                                       EnrAirport.city = self.airport.city;
                                       EnrAirport.updatedAt = self.airport.updatedAt;
                                       EnrAirport.createdAt = self.airport.createdAt;
                                       EnrAirport.chart = self.airport.chart;
                                       EnrAirport.adequate = self.airport.adequate;
                                       EnrAirport.escaperoute = self.airport.escaperoute;
                                       EnrAirport.cat32x = self.airport.cat32x;
                                       EnrAirport.cat332 = self.airport.cat332;
                                       EnrAirport.cat333 = self.airport.cat333;
                                       EnrAirport.cat345 = self.airport.cat345;
                                       EnrAirport.cat346 = self.airport.cat346;
                                       EnrAirport.cat350 = self.airport.cat350;
                                       EnrAirport.cat380 = self.airport.cat380;
                                       EnrAirport.cat777 = self.airport.cat777;
                                       EnrAirport.cat787 = self.airport.cat787;
                                       EnrAirport.note32x = self.airport.note32x;
                                       EnrAirport.note332 = self.airport.note332;
                                       EnrAirport.note333 = self.airport.note333;
                                       EnrAirport.note345 = self.airport.note345;
                                       EnrAirport.note346 = self.airport.note346;
                                       EnrAirport.note350 = self.airport.note350;
                                       EnrAirport.note380 = self.airport.note380;
                                       EnrAirport.note777 = self.airport.note777;
                                       EnrAirport.note787 = self.airport.note787;
                                       EnrAirport.rffnotes = self.airport.rffnotes;
                                       EnrAirport.rff = self.airport.rff;
                                       EnrAirport.rffnotes = self.airport.rffnotes;
                                       EnrAirport.peg = self.airport.peg;
                                       EnrAirport.pegnotes = self.airport.pegnotes;
                                       EnrAirport.cpldg = self.airport.cpldg;
                                       EnrAirport.elevation = self.airport.elevation;
                                       EnrAirport.latitude = self.airport.latitude;
                                       EnrAirport.longitude = self.airport.longitude;
                                       EnrAirport.timezone = self.airport.timezone;
                                       EnrAirport.alternates = self.airport.alternates;
                                       EnrAirport.cpldgnote = self.airport.cpldgnote;
                                       EnrAirport.country = self.airport.country;
                                       [[User sharedUser].arrayEnrouteAirports addObject:EnrAirport];
                                       NSString *identifier = [NSString stringWithFormat:@"%@", EnrAirport.icaoidentifier];
    
                                       // this is very fast constant time lookup in a hash table
                                       if ([[User sharedUser].lookupAirport containsObject:identifier])
                                       {
                                           NSLog(@"item already exists.  removing: %@ at index %lu", identifier, [[User sharedUser].arrayEnrouteAirports count]-1);
                                           [[User sharedUser].arrayEnrouteAirports removeObjectAtIndex:[[User sharedUser].arrayEnrouteAirports count]-1];
                                       }
                                       else
                                       {
                                           NSLog(@"distinct item.  keeping %@ at index %lu", identifier, [[User sharedUser].arrayEnrouteAirports count]-1);
                                           [[User sharedUser].lookupAirport addObject:identifier];
                                       }
    
                                       NSInteger intEnrBatchNumber = [[User sharedUser].arrayEscapeRoutes count] + [[User sharedUser].arrayEnrouteAirports count];
                                       [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (long)intEnrBatchNumber]];
                                        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];

}
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
        case 2:
            switch (intRow){
                case 2:
                    arrAlternates = [[NSArray alloc] init];
                    NSString* string = self.airport.alternates;
                    arrAlternates = [string componentsSeparatedByString:@", "];
                    [User sharedUser].arrayAlternates = [[NSMutableArray alloc] init];
                    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
                    for (int i=0; i < [arrAlternates count]; i++)
                    {
                        NSString *strIcaoIdentifier = [arrAlternates objectAtIndex:i];  //find object with this id in core data
                        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
                        [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
                        
                        NSFetchRequest *request = [[NSFetchRequest alloc] init];
                        NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                  inManagedObjectContext:context];
                        [request setEntity:entity];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                        [request setPredicate:predicate];
                        NSArray *results = [context executeFetchRequest:request error:NULL];
                        Airports *managedairport = [[Airports alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
                        managedairport = [results objectAtIndex:0];
                        Airport *detairport = [[Airport alloc] init];
                        detairport.cat32x = managedairport.cat32x;
                        detairport.cat332 = managedairport.cat332;
                        detairport.cat333 = managedairport.cat333;
                        detairport.cat345 = managedairport.cat345;
                        detairport.cat346 = managedairport.cat346;
                        detairport.cat350 = managedairport.cat350;
                        detairport.cat380 = managedairport.cat380;
                        detairport.cat777 = managedairport.cat777;
                        detairport.cat787 = managedairport.cat787;
                        detairport.note32x = managedairport.note32x;
                        detairport.note332 = managedairport.note332;
                        detairport.note333 = managedairport.note333;
                        detairport.note345 = managedairport.note345;
                        detairport.note346 = managedairport.note346;
                        detairport.note350 = managedairport.note350;
                        detairport.note380 = managedairport.note380;
                        detairport.note777 = managedairport.note777;
                        detairport.note787 = managedairport.note787;
                        detairport.rffnotes = managedairport.rffnotes;
                        detairport.rff = managedairport.rff;
                        detairport.rffnotes = managedairport.rffnotes;
                        detairport.peg = managedairport.peg;
                        detairport.pegnotes = managedairport.pegnotes;
                        detairport.iataidentifier = managedairport.iataidentifier;
                        detairport.icaoidentifier = managedairport.icaoidentifier;
                        detairport.name = managedairport.name;
                        detairport.chart = managedairport.chart;
                        detairport.adequate = managedairport.adequate;
                        detairport.escaperoute = managedairport.escaperoute;
                        detairport.updatedAt = managedairport.updatedAt;
                        detairport.city = managedairport.city;
                        detairport.cpldg = managedairport.cpldg;
                        detairport.elevation = managedairport.elevation;
                        detairport.latitude = managedairport.latitude;
                        detairport.longitude = managedairport.longitude;
                        detairport.timezone = managedairport.timezone;
                        [[User sharedUser].arrayAlternates addObject:detairport];
                    }
            break;
            }
            break;
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
                }
                break;
                    
                case 1:
                {
                    [self performSegueWithIdentifier:@"segShowImportantLinks" sender:self];
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
