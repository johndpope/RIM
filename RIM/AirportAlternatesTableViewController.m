//
//  AirportAlternatesTableViewController.m
//  RIM
//
//  Created by Mikel on 12.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "AirportAlternatesTableViewController.h"
#import "AirportAlternateDetailTableViewController.h"
#import "User.h"
#import "CountryCell.h"
#import "Airport.h"
#import "Airports.h"
#import "SDCoreDataController.h"

@interface AirportAlternatesTableViewController ()
@property (strong, nonatomic) NSArray *filteredList;
@end

@implementation AirportAlternatesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 55;
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (void)setAirport:(Airport *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[User sharedUser].arrayAlternates count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellAlternate" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    Airport *airport = [[Airport alloc] init];
    airport = [[User sharedUser].arrayAlternates objectAtIndex:row];
    cell.lblICAO.text = [[[[airport.icaoidentifier stringByAppendingString:@" / "] stringByAppendingString:airport.iataidentifier] stringByAppendingString:@" / "] stringByAppendingString:airport.city];
    cell.lblName.text = airport.name;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *dateString = [format stringFromDate:airport.updatedAt];
    cell.lblLastUpdated.text = [@"Last updated on " stringByAppendingString:dateString];
    if ([airport.strFunction isEqualToString:@"Destination Alternate"]) {
        cell.imgAirport.image = [UIImage imageNamed:@"AirportB_25.png"];
    } else
    if ([airport.strFunction isEqualToString:@"Destination Airport"] || [airport.strFunction isEqualToString:@"Departure Airport"]) {
        cell.imgAirport.image = [UIImage imageNamed:@"AirportG_25.png"];
    } else {
        cell.imgAirport.image = [UIImage imageNamed:@"AirportA_25.png"];
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segShowDetailsAlternate"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Airport *airport = [[Airport alloc] init];
        airport = [[User sharedUser].arrayAlternates objectAtIndex:indexPath.row];

        AirportAlternateDetailTableViewController *controller = (AirportAlternateDetailTableViewController *)[segue destinationViewController];
        
        [controller setAirport:airport];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

@end
