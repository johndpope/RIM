//
//  EnrouteInfoTableViewController.m
//  RIM
//
//  Created by Mikel on 28.04.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//
#import "User.h"
#import "EnrouteInfoTableViewController.h"
#import "RouteInfoTableViewCell.h"

@interface EnrouteInfoTableViewController ()

@end

@implementation EnrouteInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger intSection = indexPath.section;
    NSInteger intRow = indexPath.row;
    if (intSection == 0) {
        if (intRow == 0) {
                if ([[User sharedUser].arrayEscapeRoutes count] == 0) {
                self.tvcEscapes.accessoryType = UITableViewCellAccessoryNone;
                self.tvcEscapes.userInteractionEnabled = NO;
                self.lblcountEscape.text = @"";
            }else {
                self.tvcEscapes.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if ([[User sharedUser].arrayEscapeRoutes count] == 1) {
               // self.lblcountEscape.text = [[NSString stringWithFormat:@"%li", [[User sharedUser].arrayEscapeRoutes count]] stringByAppendingString:@" Waypoint"];
                }else{
               // self.lblcountEscape.text = [[NSString stringWithFormat:@"%li", [[User sharedUser].arrayEscapeRoutes count]] stringByAppendingString:@" Waypoints"];
                }
                self.tvcEscapes.userInteractionEnabled = YES;
            }
        }
    }
    if (intSection == 1) {
        if (intRow == 0) {
                if ([[User sharedUser].arrayEnrouteAirports count] == 0) {
                self.tvcAirports.accessoryType = UITableViewCellAccessoryNone;
                self.tvcAirports.userInteractionEnabled = NO;
                self.lblcountAirport.text = @"";
            }else {
                self.tvcAirports.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if ([[User sharedUser].arrayEnrouteAirports count] == 1) {
              //  self.lblcountAirport.text = [[NSString stringWithFormat:@"%li", [[User sharedUser].arrayEnrouteAirports count]] stringByAppendingString:@" Airport"];
                }else{
              //  self.lblcountAirport.text = [[NSString stringWithFormat:@"%li", [[User sharedUser].arrayEnrouteAirports count]] stringByAppendingString:@" Airports"];
                }
                self.tvcAirports.userInteractionEnabled = YES;
            }
        }
    }
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (void) viewWillAppear:(BOOL)animated
{
//    self.lblcountEscape.text = [NSString stringWithFormat:@"%li", [[User sharedUser].arrayEscapeRoutes count]];
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 3] tabBarItem] setBadgeValue:self.lblcountEscape.text];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    RouteInfoTableViewCell *cell = (RouteInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    if (cell == nil) {
//        cell = [[RouteInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell" ];
//    }
//    NSInteger intSection = indexPath.section;
//    NSInteger intRow = indexPath.row;
//    if (intSection == 0) {
//        if (intRow == 0) {
////        cell.textLabel.text = @"Escape Routes";
////            cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:22];
////            // cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1] /*#007aff*/;
////            [cell.textLabel setTextColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]];
////            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
//            
//           if ([[User sharedUser].arrayEscapeRoutes count] == 0) {
//            self.tvcEscapes.accessoryType = UITableViewCellAccessoryNone;
//            self.tvcEscapes.userInteractionEnabled = NO;
//            self.lblcountEscape.text = @"";
//        }else {
//            self.tvcEscapes.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            self.lblcountEscape.text = [[NSString stringWithFormat:@"%li", [[User sharedUser].arrayEscapeRoutes count]] stringByAppendingString:@" Waypoints"];
//            self.tvcEscapes.userInteractionEnabled = YES;
//        }
//    }
//    }
//    if (intSection == 1) {
//        if (intRow == 0) {
////        cell.textLabel.text = @"Enroute Airports";
////        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:22];
////        // cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1] /*#007aff*/;
////            [cell.textLabel setTextColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]];
////            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
//        if ([[User sharedUser].arrayEnrouteAirports count] == 0) {
//            self.tvcAirports.accessoryType = UITableViewCellAccessoryNone;
//            self.tvcAirports.userInteractionEnabled = NO;
//            self.tvcAirports.detailTextLabel.text = @"";
//        }else {
//            self.tvcAirports.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            self.tvcAirports.detailTextLabel.text = [[NSString stringWithFormat:@"%li", [[User sharedUser].arrayEnrouteAirports count]] stringByAppendingString:@" Airports"];
//            self.tvcAirports.userInteractionEnabled = YES;
//        }
//    }
//    }
//
//    // Configure the cell...
//    
//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger intSection = indexPath.section;
    NSInteger intRow = indexPath.row;
    if (intSection == 0) {
        if (intRow == 0) {
            [self performSegueWithIdentifier:@"segEscapeList" sender:self];
        }
    }
    if (intSection == 1) {
        if (intRow == 0) {
            [self performSegueWithIdentifier:@"segAirportList" sender:self];
        }
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"segEscapeList"])
    {
    }
}


@end
