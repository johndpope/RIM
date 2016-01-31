//
//  AirportRegionsTableViewController.m
//  RIM
//
//  Created by Mikel on 20.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "AirportRegionsTableViewController.h"
#import "User.h"
@interface AirportRegionsTableViewController ()

@end

@implementation AirportRegionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.TableView setBackgroundView:nil];
    [self.TableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger intRow = indexPath.row;
    NSInteger intSection = indexPath.section;
    switch (intSection) {
        case 0:
            switch (intRow){
                    
                case 0:
                    [User sharedUser].strAptRegion = @"Africa";
                    [User sharedUser].strEntityAirports = @"AirportsAfrica";
                    [self performSegueWithIdentifier:@"segShowAirports" sender:self];
                    break;
            }
            break;
        case   2:
            switch (intRow){
                case 0:
                    [User sharedUser].strAptRegion = @"Asia";
                    [User sharedUser].strEntityAirports = @"AirportsAsia";
                    [self performSegueWithIdentifier:@"segShowAirports" sender:self];
                    break;
            }
            break;
        case 3:
            switch (intRow){
                    
                case 0:
                    [User sharedUser].strAptRegion = @"Australia";
                    [User sharedUser].strEntityAirports = @"AirportsAustralia";
                    [self performSegueWithIdentifier:@"segShowAirports" sender:self];
                    break;
            }
            break;
        case   4:
            switch (intRow){
                case 0:
                    [User sharedUser].strAptRegion = @"Eurasia";
                    [User sharedUser].strEntityAirports = @"AirportsEurasia";
                    [self performSegueWithIdentifier:@"segShowAirports" sender:self];
                    break;
            }
            break;
        case 5:
            switch (intRow){
                    
                case 0:
                    [User sharedUser].strAptRegion = @"Europe";
                    [User sharedUser].strEntityAirports = @"AirportsEurope";
                    [self performSegueWithIdentifier:@"segShowAirports" sender:self];
                    break;
            }
            break;
        case  6:
            switch (intRow){
                case 0:
                    [User sharedUser].strAptRegion = @"Middle East";
                    [User sharedUser].strEntityAirports = @"AirportsMiddleEast";
                    [self performSegueWithIdentifier:@"segShowAirports" sender:self];
                    break;
            }
            break;
        case  7:
            switch (intRow){
                case 0:
                    [User sharedUser].strAptRegion = @"Recently Imported";
                    [User sharedUser].strEntityAirports = @"AirportsImported";
                    [self performSegueWithIdentifier:@"segShowAirports" sender:self];
                    break;
            }
            break;
        case 1:
            switch (intRow){
                    
                case 0:
                    [User sharedUser].strAptRegion = @"Americas";
                    [User sharedUser].strEntityAirports = @"AirportsAmericas";
                    [self performSegueWithIdentifier:@"segShowAirports" sender:self];
                    break;
            }
            break;
        default:
            break;
    }
}



@end
