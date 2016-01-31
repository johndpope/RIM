//
//  EnrouteAirportsTableViewController.m
//  RIM
//
//  Created by Mikel on 22.04.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "EnrouteAirportsTableViewController.h"

#import "AirportDetailTableViewController.h"
#import "EscapeWPTDetailViewController.h"
#import "User.h"
#import "Airports.h"
#import "Airport.h"

#import "CountryCell.h"

@interface EnrouteAirportsTableViewController ()
{
    
    NSURL *fileURL;
}

@end

@implementation EnrouteAirportsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    //    UIBarButtonItem * Flightplanbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"waypoint_map-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(ShowFlightPlan)];
    //    NSArray *actionButtonItems = @[Flightplanbutton];
    //    self.navigationItem.rightBarButtonItems = actionButtonItems;
    self.myTableview.rowHeight = 70;
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myTableview reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    //    self.tableView.estimatedRowHeight = 90;
    
    
    // Release any retained subviews of the main view.
    //    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[User sharedUser].arrayEnrouteAirports count];
}
- (void)ShowFlightPlan
{
    //execute segue programmatically
    [self performSegueWithIdentifier: @"segShowFltPlan" sender: self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segShowDetailEscape"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Escape *escapewpt = [[User sharedUser].arrayEnrouteAirports objectAtIndex:indexPath.row];
        
        
        EscapeWPTDetailViewController *controller = (EscapeWPTDetailViewController *)[segue destinationViewController];
        [controller setEscapewpt:escapewpt];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if ([segue.identifier isEqualToString:@"SegueShowAirport"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Airports *airport = [[User sharedUser].arrayEnrouteAirports objectAtIndex:indexPath.row];
        AirportDetailTableViewController *controller = (AirportDetailTableViewController *)[segue destinationViewController];
        [controller setAirport:airport];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AirportCell";
    CountryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    NSInteger row = indexPath.row;
    Airport *airport = [[Airport alloc] init];
    NSLog(@"the cell is %@", cell);
    airport = [[User sharedUser].arrayEnrouteAirports objectAtIndex:indexPath.row];
    cell.lblICAO.text = [[[[airport.icaoidentifier stringByAppendingString:@" / "] stringByAppendingString:airport.iataidentifier] stringByAppendingString:@" / "] stringByAppendingString:airport.city];
    cell.lblName.text = airport.name;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *dateString = [format stringFromDate:airport.updatedAt];
    cell.lblLastUpdated.text = [@"Last updated on " stringByAppendingString:dateString];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self performSegueWithIdentifier: @"SegueShowAirport" sender:indexPath];
////    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//    Airports *airport = [[User sharedUser].arrayEnrouteAirports objectAtIndex:indexPath.row];
////    UIViewController *tblvc = [self.storyboard instantiateViewControllerWithIdentifier:@"tblid"];
//    AirportDetailTableViewController *controller = (AirportDetailTableViewController *)[[segue destinationViewController] topViewController];
////    [[self navigationController] pushViewController:AirportDetailTableViewController animated:NO];
//    [controller setAirport:airport];
//    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//    controller.navigationItem.leftItemsSupplementBackButton = YES;
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [[User sharedUser].arrayEnrouteAirports exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}
- (void)setTableEditing {
    
    if (self.myTableview.editing){
        
        [self.myTableview setEditing:NO animated:YES];
        //        day_view-25
        UIBarButtonItem * Sortbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"generic_sorting-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setTableEditing)];
        UIBarButtonItem * Flightplanbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"waypoint_map-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(ShowFlightPlan)];
        NSArray *actionButtonItems = @[Sortbutton,Flightplanbutton];
        self.navigationItem.rightBarButtonItems = actionButtonItems;
        //		UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrangetable.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setTableEditing)];
        //		[self.navigationItem setRightBarButtonItem:button];
    }
    else
    {
        [self.myTableview setEditing:YES animated:YES];
        //        UIBarButtonItem * Sortbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(setTableEditing)];
        UIBarButtonItem * Sortbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"generic_sorting-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setTableEditing)];
        UIBarButtonItem * Flightplanbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"waypoint_map-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(ShowFlightPlan)];
        NSArray *actionButtonItems = @[Sortbutton,Flightplanbutton];
        self.navigationItem.rightBarButtonItems = actionButtonItems;
        //		UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(setTableEditing)];
        //		[self.navigationItem setRightBarButtonItem:button];
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Airports *EnrAirport = [[User sharedUser].arrayEnrouteAirports objectAtIndex:indexPath.row];
        [[User sharedUser].arrayEnrouteAirports removeObjectAtIndex:indexPath.row];
        NSMutableSet *mutableSet = [NSMutableSet setWithSet:[User sharedUser].lookupAirport];
        [mutableSet removeObject:EnrAirport.icaoidentifier];
        [User sharedUser].lookupAirport = mutableSet;

        
        NSInteger intEnrBatchNumber = [[User sharedUser].arrayEscapeRoutes count] + [[User sharedUser].arrayEnrouteAirports count];
        [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (long)intEnrBatchNumber]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (intEnrBatchNumber == 0) {
            [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:nil];
        }
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //     if (segFunction.selectedSegmentIndex == 0) {
    Airports  *movedEscapeRouteItem = [[User sharedUser].arrayEnrouteAirports objectAtIndex:fromIndexPath.row];
    [[User sharedUser].arrayEnrouteAirports removeObjectAtIndex:fromIndexPath.row];
    [[User sharedUser].arrayEnrouteAirports insertObject:movedEscapeRouteItem atIndex:toIndexPath.row];
    //     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:fromIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

#pragma mark -
#pragma mark QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
//- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
//{
//    return 1; //you can increase the this
//}

// returns the item that the preview controller should preview
//- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
//{
//    return fileURL;
//}


@end
