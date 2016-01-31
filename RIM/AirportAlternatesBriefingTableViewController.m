//
//  AirportbriefingTableViewController.m
//  RIM
//
//  Created by Michael Gehringer on 9/15/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import "AirportAlternatesBriefingTableViewController.h"
#import "User.h"
#import "SDCoreDataController.h"
#import "ReaderViewController.h"

@interface AirportAlternatesBriefingTableViewController ()
{
//    Airport *airportWX;
    NSURL *fileURL;

}
@property (strong, nonatomic) BAPrayerTimes *prayerTimes;
@end

@implementation AirportAlternatesBriefingTableViewController
{
    ReaderViewController *readerViewController;

}
@synthesize btnAircraft,btnBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    btnAircraft = [[UIBarButtonItem alloc]initWithTitle:@"| Aircraft |" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAircraftButtonTapped:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnAircraft, nil]];
    btnBack = [[UIBarButtonItem alloc]initWithTitle:@"| OK |" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnBack, nil]];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnAircraft, nil]];
    btnAircraft.title = [User sharedUser].strAircraftType;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    [self calcTimeZone];
    [self calcCoordinates];
    [self calcAirportSunriseSunset];
    self.navigationItem.title = self.airport.icaoidentifier;
    self.lblName.text = [self.airport.name length] ? self.airport.name : @"";
    self.lblICAOIATA.text = [self.airport.icaoidentifier length] ? self.airport.icaoidentifier : @"N/A";
    self.lblICAOIATA.text = [[self.lblICAOIATA.text stringByAppendingString:@" / "] stringByAppendingString:[self.airport.iataidentifier length] ? self.airport.iataidentifier :@"N/A"];
    self.lblCity.text = [self.airport.city length] ? self.airport.city : @"";
    self.lblCountry.text =[self.airport.country length] ? self.airport.country : @"";
    self.lblElevation.text = [[[NSString alloc]initWithFormat:@"%.0f",self.airport.elevation] stringByAppendingString:@" ft"];
    
    if ([btnAircraft.title isEqualToString:@"A320/A321"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat32x length] ? self.airport.cat32x :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A332/A33F"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat332 length] ? self.airport.cat332 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A333"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat333 length] ? self.airport.cat333 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A345"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat345 length] ? self.airport.cat345 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A346"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat346 length] ? self.airport.cat346 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A350"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat350 length] ? self.airport.cat350 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A380"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat380 length] ? self.airport.cat380 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"B777/B77F"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat777 length] ? self.airport.cat777 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"B787"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat787 length] ? self.airport.cat787 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
//    self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
//    self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat32x length] ? self.airport.cat32x :@"TBA" ];
//    self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    
    NSString *strICAO = self.airport.icaoidentifier;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
    NSArray *result = [[User sharedUser].arrayAlternates filteredArrayUsingPredicate: predicate];
    
    if ([result count] != 0) {
        NSUInteger indexOfTheObject = [[User sharedUser].arrayAlternates indexOfObject:result.firstObject];
        self.airportWX = [[Airport alloc] init];
        self.airportWX = [[User sharedUser].arrayAlternates objectAtIndex:indexOfTheObject];
        self.txtViewMETAR.text = self.airportWX.strMETAR;
        self.txtViewNOTAMS.text = self.airportWX.strNOTAMS;
    } else {
        self.txtViewMETAR.text = @"NO DATA";
//        self.tblvcMETAR.hidden = YES;
        self.txtViewNOTAMS.text = @"NO DATA";
//        self.tblvcNOTAMS.hidden = YES;
    }
    self.prayerTimes = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                  latitude:self.airport.latitude
                                                 longitude:self.airport.longitude
                                                  timeZone:[NSTimeZone timeZoneWithName:self.airport.timezone]
                                                    method:BAPrayerMethodMWL
                                                    madhab:BAPrayerMadhabShafi];
    
    self.lblFajr.text = [@"Fajr: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.fajrTime]];
    self.lblSunrise.text = [@"Sunrise: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.sunriseTime]];
    self.lblDhur.text = [@"Dhuhr: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.dhuhrTime]];
    self.lblAsr.text = [@"Asr: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.asrTime]];
    self.lblMaghrib.text = [@"Maghrib: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.maghribTime]];
    self.lblIsha.text = [@"Isha: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.ishaTime]];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView  {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if(cell == self.tblvcMETAR)
        return 30; //set the hidden cell's height to 0
    if(cell == self.tblvcNOTAMS)
        return 30; //set the hidden cell's height to 0

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)setAirport:(Airport *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;
        
    }
}

#pragma mark - IBActions

-(IBAction)chooseAircraftButtonTapped:(id)sender

{
    if (_aircraftPicker == nil) {
        //Create the DensityPickerViewController.
        _aircraftPicker = [[AircraftPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //Set this VC as the delegate.
        _aircraftPicker.delegate = self;
    }
    
    if (_aircraftPickerPopover == nil) {
        //The color picker popover is not showing. Show it.
        _aircraftPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_aircraftPicker];
        [_aircraftPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [_aircraftPickerPopover dismissPopoverAnimated:YES];
        _aircraftPickerPopover = nil;
    }
}

-(void)selectedAircraft:(NSString *)newAircraft
{
    if (_aircraftPickerPopover) {
        [_aircraftPickerPopover dismissPopoverAnimated:YES];
        _aircraftPickerPopover = nil;
    }
    btnAircraft.title = newAircraft;
    if ([btnAircraft.title isEqualToString:@"A320/A321"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat32x length] ? self.airport.cat32x :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A332/A33F"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat332 length] ? self.airport.cat332 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A333"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat333 length] ? self.airport.cat333 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A345"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat345 length] ? self.airport.cat345 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A346"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat346 length] ? self.airport.cat346 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A350"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat350 length] ? self.airport.cat350 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"A380"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat380 length] ? self.airport.cat380 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"B777/B77F"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat777 length] ? self.airport.cat777 :@"TBA" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
    if ([btnAircraft.title isEqualToString:@"B787"]) {
        self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
        self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat787 length] ? self.airport.cat787 :@"XXX" ];
        self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger intRow = indexPath.row;
    NSInteger intSection = indexPath.section;
    switch (intSection) {
        case 5:
            switch (intRow){
                case 1:
                {
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
                }
                    break;
                    
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
                    
                case 2:
                
                    [self performSegueWithIdentifier:@"segShowImportantLinks" sender:self];
                
                    break;
            }
            break;
    
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if ([segue.identifier isEqualToString:@"segShowImportantLinks"])
    {
        AirportLibraryTableViewController *controller = (AirportLibraryTableViewController *)[segue destinationViewController];
//        [controller setAirport:_airport];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    
}

-(void) calcCoordinates
{
    double dblLatitude;
    dblLatitude = self.airport.latitude;
    if (dblLatitude >= 0) {
        self.lblCoordinates.text = [[NSString alloc]initWithFormat:@"%02.0f°%02.1f N", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    } else {
        dblLatitude = dblLatitude*-1;
        self.lblCoordinates.text = [[NSString alloc]initWithFormat:@"%02.0f°%02.1f S", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    }
    double dblLongitude;
    dblLongitude = self.airport.longitude;
    if (dblLongitude >= 0) {
        
        self.lblCoordinates.text = [[self.lblCoordinates.text stringByAppendingString:@" / "] stringByAppendingString:[[NSString alloc]initWithFormat:@"%03.0f°%02.1f E", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60]];
    } else {
        dblLongitude = dblLongitude*-1;
        self.lblCoordinates.text = [[self.lblCoordinates.text stringByAppendingString:@" / "] stringByAppendingString:[[NSString alloc]initWithFormat:@"%03.0f°%02.1f W", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60]];
    }
    
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
            self.lblTimeZone.text = [@"UTC " stringByAppendingString:[[[NSString alloc] initWithFormat:@"%-.2li:00", (long)intHours]stringByAppendingString:@" hrs"]];
            //            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.textColor = [UIColor darkGrayColor];
            //            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
        else {
            //            cell.textLabel.text = @"Timezone:";
            self.lblTimeZone.text = [@"UTC " stringByAppendingString:[[[NSString alloc] initWithFormat:@"%-.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"]];
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
            self.lblTimeZone.text = [@"UTC " stringByAppendingString:[[[NSString alloc] initWithFormat:@"%+.2li:00", (long)intHours]stringByAppendingString:@" hrs"]];
            //            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.textColor = [UIColor darkGrayColor];
            //            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
        else {
            //            cell.textLabel.text = @"Timezone:";
            self.lblTimeZone.text = [@"UTC " stringByAppendingString:[[[NSString alloc] initWithFormat:@"%+.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"]];
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
    
    //    self.lblSRSS.text = [@"SR:" stringByAppendingString:[[[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSR,(long)minSR] stringByAppendingString:@" UTC / "] stringByAppendingString:[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursSR,(long)intMinutesSR]]stringByAppendingString:@" LCL"]];
    
    self.lblSRSS.text = [@"SR:" stringByAppendingString:[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSR,(long)minSR] stringByAppendingString:@" UTC / "]];
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
    
    
    //    self.lblSRSS.text = [[self.lblSRSS.text stringByAppendingString:@" / "]stringByAppendingString:[@"SS:" stringByAppendingString:[[[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSS,(long)minSS] stringByAppendingString:@" UTC / "] stringByAppendingString:[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursSS,(long)intMinutesSS]]stringByAppendingString:@" LCL"]]];
    
    self.lblSRSS.text = [self.lblSRSS.text stringByAppendingString:[@"SS:" stringByAppendingString:[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSS,(long)minSS] stringByAppendingString:@" UTC"]]];
}

@end
