//
//  PopOverAirportTableViewController.m
//  RIM
//
//  Created by Mikel on 29.07.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "PopOverAirportTableViewController.h"

@interface PopOverAirportTableViewController ()
{
    Airport *airport;
    objLog *objLogWpt;

}
@end

@implementation PopOverAirportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    NSString *strICAO = [User sharedUser].strAnnAirport;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
    NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
    airport = [[Airport alloc] init];
    if ([result count] != 0) {
//        NSUInteger indexOfTheObject = [[User sharedUser].arrayAlternates indexOfObject:result.firstObject];
        
        airport = [result objectAtIndex:0];
        self.txtViewMETAR.text = airport.strMETAR;
        self.txtViewNOTAMS.text = airport.strNOTAMS;
    }else{
        self.txtViewMETAR.text = @"NO DATA";
        self.txtViewNOTAMS.text = @"NO DATA";
    }
    self.txtViewNOTAMS.backgroundColor = [UIColor clearColor];
    self.txtViewMETAR.backgroundColor = [UIColor clearColor];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        if ([airport.strFunction length] == 0) {
            airport.strFunction = @"";
        }
        if ([airport.city length] == 0) {
            airport.city = @"";
        }
        return [[[[[User sharedUser].strAnnAirport stringByAppendingString:@" / "]stringByAppendingString:airport.city]stringByAppendingString:@" / "]stringByAppendingString:airport.strFunction];
    }
    if (section == 1){
        return @"METAR / TAF";
    }
    if (section == 2){
        return @"NOTAMS";
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        if (row == 0) {
//            AirportAlternatesBriefingTableViewController *navController = [[AirportAlternatesBriefingTableViewController alloc] initWithRootViewController:AirportAlternatesBriefingTableViewController];
//            [self presentModalViewController:navController animated:YES];
                    [self performSegueWithIdentifier: @"segShowEnrouteAirport" sender: self];
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    AirportbriefingTableViewController *Airportcontroller = (AirportbriefingTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Airportbriefing"];
//                    [self.navigationController pushViewController:Airportcontroller animated:YES];
                }
}
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"segShowEnrouteAirport"])
//    {
//        AirportbriefingTableViewController *controller = (AirportbriefingTableViewController *)[segue destinationViewController];
//        
//        [controller setAirport:airport];
//        
////        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
////        controller.navigationItem.leftItemsSupplementBackButton = YES;
//    }
    if ([segue.identifier isEqualToString:@"segShowEnrouteAirport"])
    {
        airport = [[Airport alloc] init];
        self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
        NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
        objLogWpt.strType = @"";
        int i;
        for (i = 0; i < [arrMasterEntity count]; i++) {
            NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
            [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
            [request setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",[User sharedUser].strAnnAirport];
            [request setPredicate:predicate];
            NSArray *results = [context executeFetchRequest:request error:NULL];
            if ([results count] != 0) {
                Airports *managedairport = [[Airports alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
                managedairport = [results objectAtIndex:0];
                airport.cat32x = managedairport.cat32x;
                airport.cat332 = managedairport.cat332;
                airport.cat333 = managedairport.cat333;
                airport.cat345 = managedairport.cat345;
                airport.cat346 = managedairport.cat346;
                airport.cat350 = managedairport.cat350;
                airport.cat380 = managedairport.cat380;
                airport.cat777 = managedairport.cat777;
                airport.cat787 = managedairport.cat787;
                airport.note32x = managedairport.note32x;
                airport.note332 = managedairport.note332;
                airport.note333 = managedairport.note333;
                airport.note345 = managedairport.note345;
                airport.note346 = managedairport.note346;
                airport.note350 = managedairport.note350;
                airport.note380 = managedairport.note380;
                airport.note777 = managedairport.note777;
                airport.note787 = managedairport.note787;
                airport.rffnotes = managedairport.rffnotes;
                airport.rff = managedairport.rff;
                airport.rffnotes = managedairport.rffnotes;
                airport.peg = managedairport.peg;
                airport.pegnotes = managedairport.pegnotes;
                airport.iataidentifier = managedairport.iataidentifier;
                airport.icaoidentifier = managedairport.icaoidentifier;
                airport.name = managedairport.name;
                airport.chart = managedairport.chart;
                airport.adequate = managedairport.adequate;
                airport.escaperoute = managedairport.escaperoute;
                airport.updatedAt = managedairport.updatedAt;
                airport.city = managedairport.city;
                airport.cpldg = managedairport.cpldg;
                airport.elevation = managedairport.elevation;
                airport.latitude = managedairport.latitude;
                airport.longitude = managedairport.longitude;
                airport.timezone = managedairport.timezone;
                //                [self performSegueWithIdentifier: @"segShowEnrouteAirport" sender: self];
                AirportAlternatesBriefingTableViewController *controller = (AirportAlternatesBriefingTableViewController *)[[segue destinationViewController]topViewController];
                [controller setAirport:airport];
                controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
                controller.navigationItem.leftItemsSupplementBackButton = YES;
            }
        }
    }
}
    


@end
