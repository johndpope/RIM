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


#import "EscapeWPTViewController.h"
#import "EscapeRouteTableViewController.h"
#import "SearchWaypointTableViewController.h"
//#import "EscapeWPTDetailViewController.h"
#import "AppDelegate.h"
#import "EscapeCell.h"
#import "User.h"
#import "Escape.h"
#import "EscapeWaypoint.h"
//#import "EscapeWideOutbound.h"
//#import "EscapeWideInbound.h"
#import "EscapeNarrowInbound.h"
#import "EscapeNarrowOutbound.h"
#import "SDCoreDataController.h"
#import "SDAddDateViewController.h"
#import "SDSyncEngine.h"
#import "EscapeWideInboundEurope.h"
#import "EscapeWideInboundMiddleEast.h"
#import "EscapeWideInboundIran.h"
#import "EscapeWideOutboundEurope.h"
#import "EscapeWideOutboundMiddleEast.h"
#import "EscapeWideOutboundIran.h"
#import "EscapeNarrowInbound.h"
#import "EscapeNarrowOutbound.h"
#import "EscapeWideInboundAfricaUSA.h"
#import "EscapeWideOutboundAfricaUSA.h"
#import "EscapeWideInboundSEAsia.h"
#import "EscapeWideOutboundSEAsia.h"
#import "EscapeWideInboundChina.h"
#import "EscapeWideOutboundChina.h"
#import "EscapeNarrowInboundEurope.h"
#import "EscapeNarrowInboundMiddleEast.h"
#import "EscapeNarrowInboundIran.h"
#import "EscapeNarrowOutboundEurope.h"
#import "EscapeNarrowOutboundMiddleEast.h"
#import "EscapeNarrowOutboundIran.h"
#import "EscapeNarrowInboundAfricaUSA.h"
#import "EscapeNarrowOutboundAfricaUSA.h"
#import "EscapeNarrowInboundChina.h"
#import "EscapeNarrowOutboundChina.h"
#import "ReaderViewController.h"
#import "Airports.h"
#import "Airport.h"

@interface SearchWaypointTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, QLPreviewControllerDataSource, QLPreviewControllerDelegate>
{
    NSURL *fileURL;
    EscapeWaypoint *WPTescape;
}
@property(nonatomic,retain) NSURL *fileURL;
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

@implementation SearchWaypointTableViewController

{
    ReaderViewController *readerViewController;

}
@synthesize fileURL;

static NSString *EscapeCellIdentifier = @"EscapeCellIdentifier";
static NSString *SegueShowEscape = @"segShowDetailEscape";

#pragma mark -
#pragma mark === View Life Cycle Management ===
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Waypoints", @"World");

    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
//    [Escape importDataToMoc:MyDelegate.managedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    //    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = 55   ;
    
    // No search results controller to display the search results in the current view
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Configure the search bar with scope buttons and add it to the table view header
    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"Waypoint",@"Waypoint"),
                                                          NSLocalizedString(@"Airway",@"Airway")];
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityName inManagedObjectContext:self.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wptname" ascending:YES];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EscapeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:EscapeCellIdentifier forIndexPath:indexPath];
    
    Escape *escapewpt = nil;
    if (self.searchController.active)
    {
        escapewpt = [self.filteredList objectAtIndex:indexPath.row];
    }
    else
    {
        escapewpt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    cell.lblnamewpt.text = escapewpt.wptname;
    cell.lblChapter.text = [[escapewpt.chapter stringByAppendingString:@" / "] stringByAppendingString:escapewpt.page];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *dateString = [format stringFromDate:escapewpt.updatedAt];
    cell.lblupdatedAt.text = [@"Last updated on " stringByAppendingString:dateString];
    cell.lblPage.text = escapewpt.page;
    cell.lblAlternates.text = escapewpt.alternates;
    cell.lblAirways.text = escapewpt.airways;
    cell.lblaircraft.text = escapewpt.aircraft;
   
    return cell;
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chart.pdf"];
    [[NSFileManager defaultManager] removeItemAtPath:appFile error:nil];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        NSArray *initials = [self.fetchedResultsController sectionIndexTitles];

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
        [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [NSFetchedResultsController deleteCacheWithName:@"Escape"];

        
            if ([[User sharedUser].strEntityName isEqualToString:@"EscapeWideOutboundUSA"]) {
                [User sharedUser].strEntityName = @"EscapeWideOutboundAfricaUSA";
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region == %@",@"NORTH AMERICA"];
                [fetchRequest setPredicate:predicate];
            }
                else if ([[User sharedUser].strEntityName isEqualToString:@"EscapeWideInboundUSA"])
                {
                    [User sharedUser].strEntityName = @"EscapeWideInboundAfricaUSA";
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region == %@",@"NORTH AMERICA"];
                    [fetchRequest setPredicate:predicate];
                }
            if ([[User sharedUser].strEntityName isEqualToString:@"EscapeWideOutboundAfrica"]) {
                [User sharedUser].strEntityName = @"EscapeWideOutboundAfricaUSA";
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region != %@",@"NORTH AMERICA"];
                [fetchRequest setPredicate:predicate];
            }
            else if ([[User sharedUser].strEntityName isEqualToString:@"EscapeWideInboundAfrica"])
            {
                [User sharedUser].strEntityName = @"EscapeWideInboundAfricaUSA";
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region != %@",@"NORTH AMERICA"];
                [fetchRequest setPredicate:predicate];
            }
            NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityName inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"region"
                                                                             ascending:YES],
                                               [NSSortDescriptor sortDescriptorWithKey:@"wptname"
                                                                             ascending:YES]]];

            NSInteger intRecordsCount;
            NSError *error = nil;
            [fetchRequest setFetchLimit:1000];
        intRecordsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
        self.navigationItem.title = [[[User sharedUser].strWptRegion stringByAppendingString:@" / " ] stringByAppendingString:[NSString stringWithFormat:@"%li", (long)intRecordsCount]];
            
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                              managedObjectContext:self.managedObjectContext
                                                                                sectionNameKeyPath:@"region"
                                                                                         cacheName:@"Escape"];
            
        
        frc.delegate = self;
        self.fetchedResultsController = frc;
//            NSArray *arrObjects = [[NSArray alloc]init];
          
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

+ (void)deleteCacheWithName:(NSString *)name
{
    
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
//        NSString *attributeName  = @"direction";
//        NSString *attributeValue = [User sharedUser].strDirection;
//        NSString *attributeName2  = @"aircraft";
//        NSString *attributeValue2 = [User sharedUser].strAircraft;
        
        
        
//        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"wptname";
        
        if (scopeOption == searchScopeCapital)
        {
            searchAttribute = @"airways";
        }
//        NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@ AND %K like %@ AND %K like %@",
//                                    searchAttribute, searchText, attributeName, attributeValue, attributeName2, attributeValue2];
//        NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@",
//                                    searchAttribute, searchText];
        NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K contains[c] %@",
                                    searchAttribute, searchText];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
    }
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Escape *escapewpt = nil;
    if (self.searchController.active)
    {
        escapewpt = [self.filteredList objectAtIndex:indexPath.row];
    }
    else
    {
        escapewpt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
//    NSString *path = [[NSBundle mainBundle] pathForResource:[escapewpt.chapter stringByAppendingString:escapewpt.page] ofType:@"pdf"];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chart.pdf"];
////    NSURL *fileURL = [NSURLRequest requestWithURL:appFile];
//    [escapewpt.chart writeToFile:appFile atomically:YES];
//    NSString* imageName = appFile;
//    fileURL = [NSURL fileURLWithPath:imageName];
//       NSLog(@"index: %@i", indexPath);
//    NSLog(@"wpt name: %@", escapewpt.wptname);
//    creating the object of the QLPreviewController
    
    NSString *strPathDir = [[[@"/EscapeRoutes/" stringByAppendingString:[User sharedUser].strAircraft] stringByAppendingString:@"/"]stringByAppendingString:escapewpt.chapter];
    strPathDir = [[strPathDir stringByAppendingString:@"/"] stringByAppendingString:[User sharedUser].strDirection];
    NSString *strPath = [[NSBundle mainBundle] pathForResource:[[[strPathDir stringByAppendingString:@"/"]stringByAppendingString:escapewpt.chapter] stringByAppendingString:escapewpt.page] ofType:@"pdf"];
    fileURL = [NSURL fileURLWithPath:strPath];

    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    
//    settnig the datasource property to self
    previewController.dataSource = self;
    [previewController setTitle:escapewpt.wptname];
//    pusing the QLPreviewController to the navigation stack
    [[self navigationController] pushViewController:previewController animated:YES];
    UINavigationItem *previewnavigationItem = [previewController navigationItem];
//    UIBarButtonItem * Addbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus-32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addtoTripkit)];
    [previewnavigationItem setTitle:escapewpt.wptname];


//    [previewnavigationItem setRightBarButtonItem:Addbutton animated:YES];
}

-(void)addtoTripkit
{
 
 UIAlertController *alertController = [UIAlertController
                                       alertControllerWithTitle:[@"Escape Route Waypoint " stringByAppendingString:WPTescape.wptname]
                                       message:[[@"Do you want to add " stringByAppendingString:WPTescape.wptname] stringByAppendingString:@" to your enroute escaperoute list ?"]
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
                                [[User sharedUser].arrayEscapeRoutes addObject:WPTescape];
                                NSString *identifier = [NSString stringWithFormat:@"%@", WPTescape.wptname];
                                
                                // this is very fast constant time lookup in a hash table
                                if ([[User sharedUser].lookup containsObject:identifier])
                                {
                                    NSLog(@"item already exists.  removing: %@ at index %lu", identifier, [[User sharedUser].arrayEscapeRoutes count]-1);
                                    [[User sharedUser].arrayEscapeRoutes removeObjectAtIndex:[[User sharedUser].arrayEscapeRoutes count]-1];
                                }
                                else
                                {
                                    NSLog(@"distinct item.  keeping %@ at index %lu", identifier, [[User sharedUser].arrayEscapeRoutes count]-1);
                                    [[User sharedUser].lookup addObject:identifier];
                                }
                                
//                                NSInteger intEnrBatchNumber = [[User sharedUser].arrayEscapeRoutes count] + [[User sharedUser].arrayEnrouteAirports count];
//                                [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (long)intEnrBatchNumber]];
                                ////////////////////////////////// handling alternates for escape waypoint
                                
                                arrAlternates = [[NSArray alloc] init];
                                NSString* string = WPTescape.alternates;
                                arrAlternates = [string componentsSeparatedByString:@", "];
//                                [User sharedUser].arrayEnrouteAirports = [[NSMutableArray alloc] init];
                                self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
                                for (int i=0; i < [arrAlternates count]; i++)
                                {
                                    
                                    NSString *strIcaoIdentifier = [arrAlternates objectAtIndex:i];  //find object with this id in core data
                                    
                                    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
                                    [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
                                    
                                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                                    
                                    if ([[User sharedUser].strEntityName containsString: @"Iran"]) {
                                        [User sharedUser].strEntityAirports = @"AirportsMiddleEast";
                                    }
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
                                    [[User sharedUser].arrayEnrouteAirports addObject:detairport];
                                    NSString *identifier = [NSString stringWithFormat:@"%@", detairport.icaoidentifier];
                                    
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

                                }
                                NSInteger intEnrBatchNumber = [[User sharedUser].arrayEscapeRoutes count] + [[User sharedUser].arrayEnrouteAirports count];
                                [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (long)intEnrBatchNumber]];
////////////////////////////////////////////////////////////////
                                
                            }];
 [alertController addAction:cancelAction];
 [alertController addAction:okAction];
 [self presentViewController:alertController animated:YES completion:nil];
 }


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:SegueShowEscape])
    {
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Escape *escapewpt = nil;
    if (self.searchController.active)
    {
        escapewpt = [self.filteredList objectAtIndex:indexPath.row];
    }
    else
    {
        escapewpt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
                                   WPTescape = [[EscapeWaypoint alloc] init];
                                   WPTescape.wptname = escapewpt.wptname;
                                   WPTescape.airways = escapewpt.airways;
                                   WPTescape.aircraft = escapewpt.aircraft;
                                   WPTescape.chart = escapewpt.chart;
                                   WPTescape.page = escapewpt.page;
                                   WPTescape.chapter = escapewpt.chapter;
                                   WPTescape.region= escapewpt.region;
                                   WPTescape.direction = escapewpt.direction;
                                   WPTescape.alternates = escapewpt.alternates;
                                   WPTescape.updatedAt = escapewpt.updatedAt;
    
    NSString *strPathDir = [[[@"/EscapeRoutes/" stringByAppendingString:[User sharedUser].strAircraft] stringByAppendingString:@"/"]stringByAppendingString:escapewpt.chapter];
    strPathDir = [[strPathDir stringByAppendingString:@"/"] stringByAppendingString:[User sharedUser].strDirection];
    NSString *strPath = [[NSBundle mainBundle] pathForResource:[[[strPathDir stringByAppendingString:@"/"]stringByAppendingString:escapewpt.chapter] stringByAppendingString:escapewpt.page] ofType:@"pdf"];
    [User sharedUser].bolWPT = NO;
    [User sharedUser].strWptTitle = escapewpt.wptname;
    [User sharedUser].strPathDocuments = strPath;
    readerViewController = [[ReaderViewController alloc] initWithNibName:nil bundle:nil]; // Demo controller
    [readerViewController setEscape:escapewpt];
    [self performSegueWithIdentifier:@"segShowPdf" sender:self];
    
//    fileURL = [NSURL fileURLWithPath:strPath];
//    
//    QLPreviewController *previewController = [[QLPreviewController alloc] init];
//    
//    //    setting the datasource property to self
//    previewController.dataSource = self;
//    previewController.title = escapewpt.wptname;
//    //    pusing the QLPreviewController to the navigation stack
//    [[self navigationController] pushViewController:previewController animated:YES];
//    UINavigationItem *previewnavigationItem = [previewController navigationItem];
//    UIBarButtonItem * Addbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus-32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addtoTripkit)];
    
    
//    [previewnavigationItem setRightBarButtonItem:Addbutton animated:YES];
//    [previewnavigationItem setTitle:escapewpt.wptname];
    
//    NSString *strPathDir = [@"/Airportbriefing/" stringByAppendingString:self.airport.icaoidentifier];
//    NSString *strPath = [[NSBundle mainBundle] pathForResource:[[strPathDir stringByAppendingString:@"/"]stringByAppendingString:self.airport.icaoidentifier] ofType:@"pdf"];
    
    /////////////////////////
//    [User sharedUser].bolWPT = YES;
//    [User sharedUser].strWptTitle = escapewpt.wptname;
//    [User sharedUser].strPathDocuments = strPath;
//
//    readerViewController = [[ReaderViewController alloc] initWithNibName:nil bundle:nil]; // Demo controller
//    [readerViewController setEscape:escapewpt];

//    [[self navigationController] pushViewController:readerViewController animated:YES];
    /////////////////////////
    
//                                   [[User sharedUser].arrayEscapeRoutes addObject:WPTescape];
//                                       NSString *identifier = [NSString stringWithFormat:@"%@", WPTescape.wptname];
//                                       
//                                       // this is very fast constant time lookup in a hash table
//                                       if ([[User sharedUser].lookup containsObject:identifier])
//                                       {
//                                           NSLog(@"item already exists.  removing: %@ at index %lu", identifier, [[User sharedUser].arrayEscapeRoutes count]-1);
//                                           [[User sharedUser].arrayEscapeRoutes removeObjectAtIndex:[[User sharedUser].arrayEscapeRoutes count]-1];
//                                       }
//                                       else
//                                       {
//                                           NSLog(@"distinct item.  keeping %@ at index %lu", identifier, [[User sharedUser].arrayEscapeRoutes count]-1);
//                                           [[User sharedUser].lookup addObject:identifier];
//                                       }
//
//                                   NSInteger intEnrBatchNumber = [[User sharedUser].arrayEscapeRoutes count] + [[User sharedUser].arrayEnrouteAirports count];
//                                   [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (long)intEnrBatchNumber]];
    
//                               }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
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
