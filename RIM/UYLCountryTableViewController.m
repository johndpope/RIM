//
//  UYLCountryTableViewController.m
//  WorldFacts
//
//  Created by Keith Harrison http://useyourloaf.com
//  Copyright (c) 2012-2014 Keith Harrison. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  Neither the name of Keith Harrison nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ''AS IS'' AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 


#import "UYLCountryViewController.h"
#import "UYLCountryTableViewController.h"
#import "AppDelegate.h"
#import "CountryCell.h"
#import "Country+Extensions.h"
#import "Airports.h"
#import "Airport.h"
#import "SDCoreDataController.h"
#import "SDAddDateViewController.h"
#import "SDSyncEngine.h"
#import "User.h"
@interface UYLCountryTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, QLPreviewControllerDataSource, QLPreviewControllerDelegate>
{
    NSURL *fileURL;

}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSNumberFormatter *decimalFormatter;
@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) UISearchController *searchController;

typedef NS_ENUM(NSInteger, UYLWorldFactsSearchScope)
{
    searchScopeCountry = 0,
    searchScopeCapital = 1
};

@end

@implementation UYLCountryTableViewController

static NSString *UYLCountryCellIdentifier = @"UYLCountryCellIdentifier";
static NSString *SegueShowAirport = @"SegueShowAirport";

#pragma mark -
#pragma mark === View Life Cycle Management ===
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Airports", @"World");
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    [User sharedUser].strEntityAirports = @"AirportsMiddleEast"; // default

//    MyDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
//    [self loadRecordsFromCoreData];

//    [Airports importDataToMoc:MyDelegate.managedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
//    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = 55;
    
    // No search results controller to display the search results in the current view
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Configure the search bar with scope buttons and add it to the table view header
    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ICAO",@"icaoidentifier"),
                                                          NSLocalizedString(@"IATA",@"iataidentifier")];
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
}



- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.decimalFormatter = nil;
    self.searchFetchRequest = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SegueShowAirport])
    {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [User sharedUser].arrAirport = [[NSMutableArray alloc] init];
//        [User sharedUser].arrAirport = nil;
        NSIndexPath *indexPath = sender;
        Airports *airport = nil;
        if (self.searchController.isActive)
        {
            airport = [self.filteredList objectAtIndex:indexPath.row];
        }
        else
        {
            airport = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        UYLCountryViewController *controller = (UYLCountryViewController *)[segue destinationViewController];
        [controller setAirport:airport];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
    
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
 [self performSegueWithIdentifier: @"SegueShowAirport" sender:indexPath];
//    Airports *airport = nil;
//    if (self.searchController.active)
//    {
//        airport = [self.filteredList objectAtIndex:indexPath.row];
//    }
//    else
//    {
//        airport = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    }
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chart.pdf"];
//    //    NSURL *fileURL = [NSURLRequest requestWithURL:appFile];
////    [airport.chart writeToFile:appFile atomically:YES];
//    NSString* imageName = appFile;
//    fileURL = [NSURL fileURLWithPath:imageName];
//    NSLog(@"index: %@i", indexPath);
//    NSLog(@"wpt name: %@", airport.iataidentifier);
//    //    creating the object of the QLPreviewController
//    QLPreviewController *previewController = [[QLPreviewController alloc] init];
//    
//    //    settnig the datasource property to self
//    previewController.dataSource = self;
//    
//    //    pusing the QLPreviewController to the navigation stack
//    [[self navigationController] pushViewController:previewController animated:YES];
//    //    [[NSFileManager defaultManager] removeItemAtPath:appFile error:nil];
//    
   }

-(UITableViewCell*)GetCellFromTableView:(UITableView*)tableView Sender:(id)sender {
    CGPoint pos = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:pos];
    return [tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark === Accessors ===
#pragma mark -

- (NSNumberFormatter *)decimalFormatter
{
    if (!_decimalFormatter)
    {
        _decimalFormatter = [[NSNumberFormatter alloc] init];
        [_decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];        
    }
    return _decimalFormatter;
}

- (NSFetchRequest *)searchFetchRequest
{
    if (_searchFetchRequest != nil)
    {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports inManagedObjectContext:self.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"icaoidentifier" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
}

#pragma mark -
#pragma mark === UITableViewDataSource Delegate Methods ===
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active)
    {
        return 1;
    }
    else
    {
        return [[self.fetchedResultsController sections] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return [self.filteredList count];
    }
    else
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier: @"SegueShowAirport" sender:indexPath];
//    Airports *airport = nil;
//    if (self.searchController.active)
//    {
//        airport = [self.filteredList objectAtIndex:indexPath.row];
//    }
//    else
//    {
//        airport = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    }
//    
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:[@"Airport " stringByAppendingString:airport.icaoidentifier]
//                                          message:[[@"Do you want to add " stringByAppendingString:airport.icaoidentifier] stringByAppendingString:@" to your enroute Airport list ?"]
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction
//                                   actionWithTitle:NSLocalizedString(@"NO", @"Cancel action")
//                                   style:UIAlertActionStyleCancel
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       NSLog(@"Cancel action");
//                                       //                                       [self.parentViewController.navigationController popViewControllerAnimated:YES];
//                                   }];
//    UIAlertAction *okAction = [UIAlertAction
//                               actionWithTitle:NSLocalizedString(@"YES", @"OK action")
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction *action)
//                               {
//                                   Airport *EnrAirport = [[Airport alloc] init];
//                                   EnrAirport.iataidentifier = airport.iataidentifier;
//                                   EnrAirport.icaoidentifier = airport.icaoidentifier;
//                                   EnrAirport.name = airport.name;
//                                   EnrAirport.city = airport.city;
//                                   EnrAirport.updatedAt = airport.updatedAt;
//                                   EnrAirport.createdAt = airport.createdAt;
//                                   EnrAirport.chart = airport.chart;
//                                   EnrAirport.adequate = airport.adequate;
//                                   EnrAirport.escaperoute = airport.escaperoute;
//                                   EnrAirport.cat32x = airport.cat32x;
//                                   EnrAirport.cat332 = airport.cat332;
//                                   EnrAirport.cat333 = airport.cat333;
//                                   EnrAirport.cat345 = airport.cat345;
//                                   EnrAirport.cat346 = airport.cat346;
//                                   EnrAirport.cat350 = airport.cat350;
//                                   EnrAirport.cat380 = airport.cat380;
//                                   EnrAirport.cat777 = airport.cat777;
//                                   EnrAirport.cat787 = airport.cat787;
//                                   EnrAirport.note32x = airport.note32x;
//                                   EnrAirport.note332 = airport.note332;
//                                   EnrAirport.note333 = airport.note333;
//                                   EnrAirport.note345 = airport.note345;
//                                   EnrAirport.note346 = airport.note346;
//                                   EnrAirport.note350 = airport.note350;
//                                   EnrAirport.note380 = airport.note380;
//                                   EnrAirport.note777 = airport.note777;
//                                   EnrAirport.note787 = airport.note787;
//                                   EnrAirport.rffnotes = airport.rffnotes;
//                                   EnrAirport.rff = airport.rff;
//                                   EnrAirport.rffnotes = airport.rffnotes;
//                                   EnrAirport.peg = airport.peg;
//                                   EnrAirport.pegnotes = airport.pegnotes;
//                                   EnrAirport.cpldg = airport.cpldg;
//                                   EnrAirport.elevation = airport.elevation;
//                                   EnrAirport.latitude = airport.latitude;
//                                   EnrAirport.longitude = airport.longitude;
//                                   EnrAirport.timezone = airport.timezone;
//                                   EnrAirport.alternates = airport.alternates;
//                                   EnrAirport.cpldgnote = airport.cpldgnote;
//                                   EnrAirport.country = airport.country;
//                                   [[User sharedUser].arrayEnrouteAirports addObject:EnrAirport];
//                                   NSString *identifier = [NSString stringWithFormat:@"%@", EnrAirport.icaoidentifier];
//                                   
//                                   // this is very fast constant time lookup in a hash table
//                                   if ([[User sharedUser].lookupAirport containsObject:identifier])
//                                   {
//                                       NSLog(@"item already exists.  removing: %@ at index %lu", identifier, [[User sharedUser].arrayEnrouteAirports count]-1);
//                                       [[User sharedUser].arrayEnrouteAirports removeObjectAtIndex:[[User sharedUser].arrayEnrouteAirports count]-1];
//                                   }
//                                   else
//                                   {
//                                       NSLog(@"distinct item.  keeping %@ at index %lu", identifier, [[User sharedUser].arrayEnrouteAirports count]-1);
//                                       [[User sharedUser].lookupAirport addObject:identifier];
//                                   }
//
//                                   NSInteger intEnrBatchNumber = [[User sharedUser].arrayEscapeRoutes count] + [[User sharedUser].arrayEnrouteAirports count];
//                                   [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", intEnrBatchNumber]];
//                                   //                                   [self.parentViewController.navigationController popViewControllerAnimated:YES];
//                                   
//                               }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:UYLCountryCellIdentifier forIndexPath:indexPath];
    
    Airports *airport = nil;
    
    if (self.searchController.active)
    {
        airport = [self.filteredList objectAtIndex:indexPath.row];
    }
    else
    {
        airport = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    cell.lblIATA.text = airport.iataidentifier;
    cell.lblICAO.text = [[[[airport.icaoidentifier stringByAppendingString:@" / "] stringByAppendingString:airport.iataidentifier] stringByAppendingString:@" / "] stringByAppendingString:airport.city];
    cell.lblName.text = airport.name;
    
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
//    NSString *dateString = [format stringFromDate:airport.updatedAt];

//    cell.lblLastUpdated.text = [@"Last updated on " stringByAppendingString:dateString];
//    NSString *population = [self.decimalFormatter stringFromNumber:country.population];
//    cell.populationLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"PopulationShortLabel", @"Pop:"), population];
    
//    cell.lblICAO.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//    cell.lblIATA.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//    cell.lblName.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
//    cell.lblLastUpdated.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
//    // set accessory view
////    UIButton *oValidHomeAccessryBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
//    
//    // set target of accessory view button
//    [cell.btnInfo addTarget:self action:@selector(AccessoryAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    // set tag of accessory view button to the row of table
//    cell.btnInfo.tag =indexPath.row;
//    
//    // set button to accessory view
////    cell.accessoryView = oValidHomeAccessryBtn ;
    return cell;
}
- (void)AccessoryAction:(id)sender{
    
    NSLog(@"%ld",(long)[sender tag]);
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!self.searchController.active)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        NSArray *initials = [self.fetchedResultsController sectionIndexTitles];
//        [index addObjectsFromArray: [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]];
        [index addObjectsFromArray:initials];
        return index;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (!self.searchController.active)
    {
        if (index > 0)
        {
            // The index is offset by one to allow for the extra search icon inserted at the front
            // of the index
            
            return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index-1];
        }
        else
        {
            // The first entry in the index is for the search icon so we return section not found
            // and force the table to scroll to the top.
            
            CGRect searchBarFrame = self.searchController.searchBar.frame;
            [self.tableView scrollRectToVisible:searchBarFrame animated:NO];
            return NSNotFound;
        }
    }
    return 0;
}

#pragma mark -
#pragma mark === Fetched Results Controller ===
#pragma mark -

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    if (self.managedObjectContext)
    {
        //    [self.managedObjectContext performBlockAndWait:^{
        //        [self.managedObjectContext reset];
        //        NSError *error = nil;
        //        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        //        [request setSortDescriptors:[NSArray arrayWithObject:
        //                                     [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
        //        self.dates = [self.managedObjectContext executeFetchRequest:request error:&error];
        //    }];
        [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [NSFetchedResultsController deleteCacheWithName:@"Airports"];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
//        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"country" ascending:YES];
//        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"country"
                                                                             ascending:YES],
                                               [NSSortDescriptor sortDescriptorWithKey:@"icaoidentifier"
                                                                             ascending:YES]]];
//        [fetchRequest setSortDescriptors:sortDescriptors];
            NSInteger intRecordsCount;
            NSError *error = nil;
            intRecordsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
            self.navigationItem.title = [[[User sharedUser].strAptRegion stringByAppendingString:@" / "] stringByAppendingString:[NSString stringWithFormat:@"%li", (long)intRecordsCount]];
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                              managedObjectContext:self.managedObjectContext
                                                                                sectionNameKeyPath:@"country"
                                                                                         cacheName:@"Airports"];
        frc.delegate = self;
        self.fetchedResultsController = frc;
        
//        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        }];
    }
    
    return _fetchedResultsController;
}    

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark === UISearchBarDelegate ===
#pragma mark -

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark -
#pragma mark === UISearchResultsUpdating ===
#pragma mark -

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString *)searchText scope:(UYLWorldFactsSearchScope)scopeOption
{
    if (self.managedObjectContext)
    {
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"icaoidentifier";
        
        if (scopeOption == searchScopeCapital)
        {
            searchAttribute = @"iataidentifier";
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
    }
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
