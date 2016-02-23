//
//  os4MapsViewController.m
//  os4Maps
//
//  Created by Craig Spitzkoff on 7/4/10.
//  Copyright Craig Spitzkoff 2010. All rights reserved.
//

#import "os4MapsViewController.h"
#import "AirportAlternateDetailTableViewController.h"
#import "MBProgressHUD.h"
#import "SDSyncEngine.h"
#import "User.h"
#import <tgmath.h>
#import "Fiddler.h"
#import "EDSunriseSet.h"
#import "SunFlightresults.h"
#import <SVProgressHUD.h>

@interface os4MapsViewController() <MBProgressHUDDelegate>
{
    NSURL *fileURL;
    BOOL fltpln;
    BOOL bolWeather;
    BOOL bolWpt;
    BOOL bolLog;
    BOOL bolAlt;
    BOOL bolEnrAlt;
    BOOL bolAirportNOTAMS;
    BOOL bolAirportExists;
    BOOL bolETOPS;
    BOOL bolTimes;
    BOOL bolreadHeader;
    NSMutableString *strFltpln;
    NSMutableString *strInfoMessage;
    NSMutableString *strAlternates;
    NSMutableString *strWeather;
    NSMutableString *strExportWeather;
    NSMutableString *strNOTAMS;
    NSMutableString *strExportNOTAMS;
    Country *airportLog;
    NSString *btnFltplanTitle;
//    MKNumberBadgeView *numberBadge;
    NSMutableArray *_waypoints;
    NSMutableArray *_waypointsHigh;
    NSMutableArray *_enrAirports;
    NSMutableArray *_destaltAirport;
    NSMutableArray *_depdestAirport;
    NSMutableArray *_emerAirport;
    NSMutableArray *_CompanyAirports;
    NSMutableArray *_circles60;
    NSMutableArray *_circles120;
    NSMutableArray *_circles180;
    NSMutableArray *_circles207;
    MKCircle *circle;
    objWPT *objEnRouteWpt;
    objLog *objLogWpt;
    CLLocationManager *_locationManager;
    NSString *strWptName;
    NSString *strAptName;
    BOOL bolAirports;
    BOOL bolCompanyAirports;
    BOOL bolCircles60;
    BOOL bolCircles120;
    BOOL bolCircles180;
    BOOL bolCircles207;
    MKPolyline *lineGreatCircle;
    MKPolyline *lineGreatCircle2;
    MKPolyline *lineFlight;
    MBProgressHUD *HUD;

}
@end
@implementation os4MapsViewController
{
    ReaderViewController *readerViewController;
    AirportAlternateDetailTableViewController *alternatecontroller;
    UITableViewController *tblviewPopover;
    UIPopoverController *annotationPopoverController;
}
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeGreatCircle = _routeGreatCircle;
@synthesize routeLineInFlight = _routeLineInFlight;
@synthesize routeLineView = _routeLineView;
@synthesize routeLineViewInFlight = _routeLineViewInFlight;
@synthesize mapAnnotations;
@synthesize mapAnnotationsInFlight,arrSunRiseSet;
@synthesize btnAirports,btnCircles60,btnCircles120,btnCircles180,btnCircles207,tblviewPopover,btnAirportsAll,btnLoadPDF,btnShowList,btnRefresh,btnSearch;
@synthesize customHeader;

enum
{
    kDepIndex = 0, kDestIndex = 1
};

# pragma mark -

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 20.0f;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        if (lineGreatCircle != nil || lineGreatCircle2 != nil) {
            MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:lineGreatCircle];
//            routeRenderer.strokeColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1]; /*#ff00ff magenta */
            routeRenderer.strokeColor = [UIColor blackColor];
            routeRenderer.lineDashPattern =  [NSArray arrayWithObjects:[NSNumber numberWithFloat:12],[NSNumber numberWithFloat:8], nil];
            if (lineGreatCircle2 != nil){
                MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:lineGreatCircle2];
                routeRenderer.strokeColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1]; /*#ff00ff*/
                routeRenderer.lineDashPattern =  [NSArray arrayWithObjects:[NSNumber numberWithFloat:12],[NSNumber numberWithFloat:8], nil];
                return routeRenderer;

            }
            return routeRenderer;

        }else
        if (lineFlight != nil) {
//            MKPolyline *route = overlay;
            MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:lineFlight];
            routeRenderer.strokeColor = [UIColor blueColor];
            return routeRenderer;
        }
    }
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
        circleView.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:1];
        circleView.lineWidth = 1;
        return circleView;
    }
    
    else return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AnnotationWaypoints class] ]) {
        static NSString* WaypointAnnotationIdentifier = @"Waypoint";
        MKAnnotationView *pinView = nil;
        pinView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:WaypointAnnotationIdentifier];
        if (!pinView) {
            MKAnnotationView* customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:WaypointAnnotationIdentifier];
            customPinView.canShowCallout = YES;
            customPinView.image = [UIImage imageNamed:@"WaypointLT.png"];
            customPinView.centerOffset = CGPointMake(0,0);
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
        
    }
    if ([annotation isKindOfClass:[AnnotationsHighTerrain class] ]) {
        static NSString* HightTerrainAnnotationIdentifier = @"High Terrain";
        MKAnnotationView *pinView = nil;
        pinView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:HightTerrainAnnotationIdentifier];
        if (!pinView) {
            MKAnnotationView* customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:HightTerrainAnnotationIdentifier];
            //            customPinView.pinColor = MKPinAnnotationColorGreen;
//            customPinView.animatesDrop = NO;
            customPinView.canShowCallout = YES;
            customPinView.image = [UIImage imageNamed:@"WaypointHT.png"];
            customPinView.centerOffset = CGPointMake(0,0);
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
        
    }
    
    
    if ([annotation isKindOfClass:[AnnotationEscapeWaypoints class] ]) {
        static NSString* EscapeAnnotationIdentifier = @"Escape";
        MKAnnotationView *pinView = nil;
        pinView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:EscapeAnnotationIdentifier];
        if (!pinView) {
            MKAnnotationView* customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:EscapeAnnotationIdentifier];
            //    customPinView.pinColor = MKPinAnnotationColorRed;
//            customPinView.animatesDrop = NO;
            customPinView.canShowCallout = YES;
            customPinView.image = [UIImage imageNamed:@"WaypointHT.png"];
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [rightButton addTarget:Nil
//                            action:Nil
//                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
        
    }
    if ([annotation isKindOfClass:[AnnotationEnrouteAirports class] ]) {
        static NSString* AirportAnnotationIdentifier = @"EnrouteAirport";
        MKAnnotationView *pinView = nil;
        pinView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:AirportAnnotationIdentifier];
        if (!pinView) {
            MKAnnotationView* customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AirportAnnotationIdentifier];
            customPinView.canShowCallout = YES;
            customPinView.image = [UIImage imageNamed:@"AirportA_25.png"];
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
            customPinView.centerOffset = CGPointMake(0,0);
            return customPinView;
        }
        else
        {
        }
        return pinView;
        
    }
    if ([annotation isKindOfClass:[AnnotationDepDestAirport class] ]) {
        static NSString* AirportAnnotationIdentifier = @"DepDestAirport";
        MKAnnotationView *pinView = nil;
        pinView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:AirportAnnotationIdentifier];
        if (!pinView) {
            MKAnnotationView* customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AirportAnnotationIdentifier];
            customPinView.canShowCallout = YES;
            customPinView.image = [UIImage imageNamed:@"AirportG_25.png"];
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
            customPinView.centerOffset = CGPointMake(0,0);
            return customPinView;
        }
        else
        {
        }
        return pinView;
        
    }
    if ([annotation isKindOfClass:[AnnotationDestinationAlternate class] ]) {
        static NSString* AirportAnnotationIdentifier = @"DestAltAirport";
        MKAnnotationView *pinView = nil;
        pinView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:AirportAnnotationIdentifier];
        if (!pinView) {
            MKAnnotationView* customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AirportAnnotationIdentifier];
            customPinView.canShowCallout = YES;
            customPinView.image = [UIImage imageNamed:@"AirportB_25.png"];
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
            customPinView.centerOffset = CGPointMake(0,0);
            return customPinView;
        }
        else
        {
        }
        return pinView;
        
    }


    if ([annotation isKindOfClass:[AnnotationAllCompanyAirports class] ]) {
        static NSString* AirportAnnotationIdentifier = @"CompanyAirport";
        MKAnnotationView *pinView = nil;
        pinView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:AirportAnnotationIdentifier];
        if (!pinView) {
            MKAnnotationView* customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AirportAnnotationIdentifier];
            //            customPinView.pinColor = MKPinAnnotationColorPurple;
            //            customPinView.animatesDrop = NO;
            customPinView.canShowCallout = YES;
            customPinView.image = [UIImage imageNamed:@"airport_magenta_20.png"];
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //            [rightButton addTarget:self
            //                            action:Nil
            //                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            customPinView.centerOffset = CGPointMake(0,0);
            return customPinView;
        }
        else
        {
            //            pinView.annotation = annotation;
        }
        return pinView;
        
    }

    return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    [_mapView deselectAnnotation:view.annotation animated:YES];
    
    AnnotationEnrouteAirports *annViewAirport = view.annotation;
    if ([annViewAirport.strType isEqualToString:@"Airport"]) {
        [User sharedUser].strAnnAirport = annViewAirport.title;
//        [self performSegueWithIdentifier:@"segShowAirportBriefing" sender:self];
        UIViewController* controller = (UIViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"popoverViewAirport"];
        
        UIPopoverController *poc = [[UIPopoverController alloc] initWithContentViewController:controller];
        [User sharedUser].strAnnAirport = annViewAirport.title;
        //hold ref to popover in an ivar
        annotationPopoverController = poc;
        //size as needed
        poc.popoverContentSize = CGSizeMake(500, 500);
        
        //show the popover next to the annotation view (pin)
        [poc presentPopoverFromRect:view.bounds inView:view
        permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    AnnotationEscapeWaypoints *annView = view.annotation;
    if ([annView.strType isEqualToString:@"Escape"]) {
        strWptName = annView.title;
        objLogWpt = [[objLog alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", strWptName];
        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
        objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexOfTheObject];
        Escape *escapewpt = [[User sharedUser].arrayLog objectAtIndex:indexOfTheObject];
        if ([objLogWpt.strType isEqualToString:@"Escape"]) {
            NSString *strPathDir = [[[@"/EscapeRoutes/" stringByAppendingString:[User sharedUser].strAircraftLog] stringByAppendingString:@"/"]stringByAppendingString:objLogWpt.strChapter];
            strPathDir = [[strPathDir stringByAppendingString:@"/"] stringByAppendingString:[User sharedUser].strDirectionLog];
            NSString *strPath = [[NSBundle mainBundle] pathForResource:[[[strPathDir stringByAppendingString:@"/"]stringByAppendingString:objLogWpt.strChapter] stringByAppendingString:objLogWpt.strPage] ofType:@"pdf"];
            [User sharedUser].bolPreviewWPT = YES;
            [User sharedUser].bolWPT = YES;
            [User sharedUser].strWptTitle = objLogWpt.strWptName;
            [User sharedUser].strPathDocuments = strPath;
            if ([objLogWpt.strAlternates length] != 0) {
                [[User sharedUser].arrayAlternates removeAllObjects];
                NSArray *arrAlternates = [[NSArray alloc] init];
                NSString* string = objLogWpt.strAlternates;
                NSString *strEscapeAlternates = [string stringByReplacingOccurrencesOfString:@", "
                                                                                  withString:@" "];
                arrAlternates = [strEscapeAlternates componentsSeparatedByString:@" "];
                [User sharedUser].arrayAlternates = [[NSMutableArray alloc] init];
                for (int i=0; i < [arrAlternates count]; i++)
                {
                    NSString *strIcaoIdentifier = [arrAlternates objectAtIndex:i];  //find object with this id in core data
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strIcaoIdentifier];
                    NSArray *result = [[User sharedUser].arrayEnrouteAirports filteredArrayUsingPredicate: predicate];
                    if ([result count] != 0) {
                        [[User sharedUser].arrayAlternates addObject:result.firstObject];
                    }
                }
            }
            readerViewController = [[ReaderViewController alloc] initWithNibName:nil bundle:nil]; // Demo controller
            [readerViewController setEscape:escapewpt];
            [[self navigationController] pushViewController:readerViewController animated:NO];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segShowAirportBriefing"])
    {
        Airport *airport = [[Airport alloc] init];
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
                AirportAlternatesBriefingTableViewController *controller = (AirportAlternatesBriefingTableViewController *)[segue destinationViewController];
                [controller setAirport:airport];
                controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
                controller.navigationItem.leftItemsSupplementBackButton = YES;
            }
            
            
            
        }
        
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

//    _locationManager = [[CLLocationManager alloc]init];
//    [_locationManager requestWhenInUseAuthorization];
//    _mapView.showsUserLocation = YES;
    bolAirports = NO;
    bolCircles60 = NO;
    bolCircles120 = NO;
    bolCircles180 = NO;
    bolCircles207 = NO;
    [self loadAllAirports];
    [_mapView addAnnotations:_CompanyAirports];
    bolCompanyAirports = YES;
//    numberBadge = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(5, 2, 35,22)];
//    [self loadDocuments];
//    numberBadge.value = [documents count];
    btnAirports = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"AirportG_25.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(removeAirports)];
    btnAirportsAll = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"AirportO_25.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(removeCompanyAirports)];
    btnCircles60 = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"60_circle32.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(removeCircles60)];
    btnCircles120 = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"120_circle32.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(removeCompanyAirports)];
    btnCircles180 = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"180_circle32.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(removeCircles180)];
    btnCircles207 = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"207_circle32.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(removeCircles207)];
    btnLoadPDF = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"pdf.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(chooseFlightPlanButtonTapped:)];
    btnShowList = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"list.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(chooseWaypointButtonTapped:)];
    btnSearch = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(chooseAirportButtonTapped:)];

    _mapView.delegate = self;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnLoadPDF,btnAirportsAll, nil]];
//    [self.navigationController.navigationBar addSubview:numberBadge];
}
- (void)loadDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/Inbox", documentsDirectory ];
    NSString *documentDirectoryPath = path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:documentDirectoryPath error:NULL];
    documents = [NSMutableArray arrayWithArray:files];
    NSLog(@"directories %@", files);
    [[[[[self tabBarController] viewControllers] objectAtIndex: 0] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (unsigned long)[documents count]]];
    if ([documents count] == 0) {
        [[[[[self tabBarController] viewControllers] objectAtIndex: 0] tabBarItem] setBadgeValue:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_locationManager requestWhenInUseAuthorization];
    if ([User sharedUser].bolCenterMap == YES) {
        [self zoomInOnWaypoint];
        [User sharedUser].bolCenterMap = NO;
    }else{
    }
    [self createHeader];
    [self checkSyncStatus];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
    }];
    [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}




#pragma mark - Syncing with parse


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
    [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}
- (void)applicationEnteredForeground:(NSNotification *)notification {
    NSLog(@"Application Entered Foreground");
//    [self loadDocuments];
}
- (void)checkSyncStatus {
    if ([[SDSyncEngine sharedEngine] syncInProgress]) {
        [self replaceRefreshButtonWithActivityIndicator];
    } else {
        [self removeActivityIndicatorFromRefreshButton];
    }
}

- (void)replaceRefreshButtonWithActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)removeActivityIndicatorFromRefreshButton {
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnSearch, nil]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}

- (void)appplicationIsActive:(NSNotification *)notification {
    NSLog(@"Application Did Become Active");
//    [self loadDocuments];
}

-(void) showRouteonMap
{
    if ([[User sharedUser].arrayLog count]!= 0) {
        [_mapView removeOverlays:_mapView.overlays];
        [_mapView removeAnnotations:_mapView.annotations];
        [self loadGreatCircle];
        [self loadRoute];
        [self loadEnrouteAirports];
        [self loadCircles60];
        [self loadCircles120];
        [self loadCircles180];
        [self loadCircles207];
        [_mapView addOverlay:self.routeLine];
        [_mapView addAnnotations:_waypoints];
        [_mapView addAnnotations:_waypointsHigh];
        [_mapView removeAnnotations:_enrAirports];
        [_mapView addAnnotations:_enrAirports];
        [_mapView removeAnnotations:_depdestAirport];
        [_mapView addAnnotations:_depdestAirport];
        [_mapView removeAnnotations:_destaltAirport];
        [_mapView addAnnotations:_destaltAirport];
        if (bolCircles60 == NO) {
            [_mapView removeAnnotations:_circles60];
        } else {
            [_mapView addAnnotations:_circles60];
        }
        if (bolCircles120 == NO) {
            [self.mapView removeAnnotations:_circles120];
        } else {
            [self.mapView addAnnotations:_circles120];
        }
        if (bolCircles180 == NO) {
            [self.mapView removeAnnotations:_circles180];
        } else {
            [self.mapView addAnnotations:_circles180];
        }
        if (bolCircles207 == NO) {
            [self.mapView removeAnnotations:_circles207];
        } else {
            [self.mapView addAnnotations:_circles207];
        }
        [self zoomInOnRoute];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self createHeader];
}
-(void)createHeader
{
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 102)
        {
            [subView removeFromSuperview];
        }
    }
    CGFloat yPosition = 44;
    if ([[User sharedUser].strFlightIdentifier length] != 0) {
    customHeader = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition,self.view.frame.size.width,20 )];
    customHeader.backgroundColor = [UIColor colorWithRed:0.216 green:0.2 blue:0.204 alpha:0.8]; /*#373334*/
    customHeader.tag = 102;
    [self.view addSubview:customHeader];
    UIButton *btnHeader1 = [[UIButton alloc]init];
    btnHeader1 = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [btnHeader1.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    [btnHeader1 setTitleColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1] forState:UIControlStateNormal];
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMMyy"];
    dateString = [formatter stringFromDate:[User sharedUser].dateFlight];
    [btnHeader1 setFrame:CGRectMake(0, 1,self.view.frame.size.width,20 )];
        // for demo
//        [User sharedUser].strFlightIdentifier = @"ACA777";
//        [User sharedUser].strAircraftRegistration = @"A6DEMO";
//        [User sharedUser].strFlightPlanTitle = @"DXB - SFO";

    [btnHeader1 setTitle:[[[[[[[[[[[[[[[User sharedUser].strOFPNumber stringByAppendingString:@" "] stringByAppendingString:[User sharedUser].strFlightIdentifier]stringByAppendingString:@" "] stringByAppendingString:dateString]stringByAppendingString:@" "] stringByAppendingString: [User sharedUser].strFlightPlanTitle] stringByAppendingString:@" "] stringByAppendingString: [User sharedUser].strAircraftRegistration] stringByAppendingString:@" "]stringByAppendingString: [User sharedUser].strAircraftType] stringByAppendingString:@" "] stringByAppendingString:[User sharedUser].strTripDuration] stringByAppendingString:@" F"]stringByAppendingString:[User sharedUser].strInitialAltitude] forState:UIControlStateNormal];
    [customHeader addSubview:btnHeader1];
    }else{
//    customHeader = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, yPosition, 200,20 )];
//    customHeader.backgroundColor = [UIColor colorWithRed:0.216 green:0.2 blue:0.204 alpha:0.8]; /*#373334*/
//    customHeader.tag = 102;
//    [self.view addSubview:customHeader];
//    UIButton *btnHeader1 = [[UIButton alloc]init];
//    btnHeader1 = [UIButton buttonWithType: UIButtonTypeRoundedRect];
//    [btnHeader1 setFrame:CGRectMake(0,5 , 200,10 )];
//    [btnHeader1.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
//    [btnHeader1 setTitleColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1] forState:UIControlStateNormal];
//    [btnHeader1 setFrame:CGRectMake(0,5 , 200,10 )];
//    [btnHeader1 setTitle:@"Load OFP" forState:UIControlStateNormal];
//        //    [btnHeader1 addTarget:self action:@selector(showHeader) forControlEvents:UIControlEventTouchUpInside];
//    [customHeader addSubview:btnHeader1];
    }
}
-(void) zoomInOnWaypoint
{
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude =[User sharedUser].dblLatitudeMapCenter;
    zoomLocation.longitude = [User sharedUser].dblLongitudeMapCenter;
    #define METERS_PER_NM 1852
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500*METERS_PER_NM, 500*METERS_PER_NM);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    [_mapView annotationsInMapRect:_mapView.visibleMapRect];
    for (MKPointAnnotation *annotation in _mapView.annotations) {
        if ( MKMapRectContainsPoint(_mapView.visibleMapRect, MKMapPointForCoordinate(annotation.coordinate)) ) {
            if (annotation.coordinate.latitude == zoomLocation.latitude && annotation.coordinate.longitude == zoomLocation.longitude) {
                [_mapView selectAnnotation:annotation animated:YES];
            }
            
        }
    }
    //    [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
}

-(IBAction)chooseFlightPlanButtonTapped:(id)sender

{
    if (_flightplanPicker == nil) {
        //Create the DensityPickerViewController.
        _flightplanPicker = [[FlightPlanPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //Set this VC as the delegate.
        _flightplanPicker.delegate = self;
    }
    
    if (_flightplanPickerPopover == nil) {
        //The color picker popover is not showing. Show it.
        _flightplanPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_flightplanPicker];
        [_flightplanPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [_flightplanPickerPopover dismissPopoverAnimated:YES];
        _flightplanPickerPopover = nil;
    }
}

-(void)loadEnrouteAirports
{
    _enrAirports = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayWXNotams.count)];
    _emerAirport = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayWXNotams.count)];
    _depdestAirport = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayWXNotams.count)];
    _destaltAirport = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayWXNotams.count)];

    for(int idx = 0; idx < [User sharedUser].arrayWXNotams.count; idx++)
    {
        Airport *enrAirport = [[User sharedUser].arrayWXNotams objectAtIndex:idx];
        CLLocationDegrees latitude  = enrAirport.latitude;
        CLLocationDegrees longitude = enrAirport.longitude;
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        if ([enrAirport.strFunction isEqualToString:@"Departure Airport"] || [enrAirport.strFunction isEqualToString:@"Destination Airport"]) {
            AnnotationDepDestAirport *AptAnnotation = [[AnnotationDepDestAirport alloc] init];
            AptAnnotation.coordinate = coordinate;
            AptAnnotation.title = enrAirport.icaoidentifier;
            AptAnnotation.strType = @"Airport";
            AptAnnotation.strFunction = enrAirport.strFunction;
            [_depdestAirport addObject:AptAnnotation];
        }
        if ([enrAirport.strFunction isEqualToString:@"Enroute Airport"] || [enrAirport.strFunction isEqualToString:@"Fuel Enroute Airport"] || [enrAirport.strFunction isEqualToString:@"Fuel Enroute / ETOPS Airport"] || [enrAirport.strFunction isEqualToString:@"ETOPS Airport"]){
            AnnotationEnrouteAirports *enrAptAnnotation = [[AnnotationEnrouteAirports alloc] init];
            enrAptAnnotation.coordinate = coordinate;
            enrAptAnnotation.title = enrAirport.icaoidentifier;
            enrAptAnnotation.strType = @"Airport";
            enrAptAnnotation.strFunction = enrAirport.strFunction;
            [_enrAirports addObject:enrAptAnnotation];
        }
        if ([enrAirport.strFunction isEqualToString:@"Destination Alternate"]) {
            AnnotationDestinationAlternate *AptAnnotation = [[AnnotationDestinationAlternate alloc] init];
            AptAnnotation.coordinate = coordinate;
            AptAnnotation.title = enrAirport.icaoidentifier;
            AptAnnotation.strType = @"Airport";
            AptAnnotation.strFunction = enrAirport.strFunction;
            [_destaltAirport addObject:AptAnnotation];
        }
    }
}
-(void)loadAllAirports
{
    [User sharedUser].arrayAllCompanyAirports = [[NSMutableArray alloc]init];
    NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    int i;
    _CompanyAirports = [[NSMutableArray alloc]init];
    for (i = 0; i < [arrMasterEntity count]; i++) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [NSFetchedResultsController deleteCacheWithName:@"Airports"];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray *results = [context executeFetchRequest:fetchRequest error:NULL];
        if ([results count] != 0){
            for(int idx = 0; idx < results.count; idx++)
            {
                Airports *managedairport = [[Airports alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
                managedairport = [results objectAtIndex:idx];
                CLLocationDegrees latitude  = managedairport.latitude;
                CLLocationDegrees longitude = managedairport.longitude;
                // create our coordinate and add it to the correct spot in the array
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                AnnotationAllCompanyAirports *enrAptAnnotation = [[AnnotationAllCompanyAirports alloc] init];
                enrAptAnnotation.coordinate = coordinate;
                enrAptAnnotation.title = managedairport.icaoidentifier;
                enrAptAnnotation.strType = @"Airport";
                [_CompanyAirports addObject:enrAptAnnotation];
            }
        }
    }
    
    
}


/////////////// load circles

-(void) loadCircles60
{
    _circles60 = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayEnrouteAirports.count)];
    
    for(int idx = 0; idx < [User sharedUser].arrayEnrouteAirports.count; idx++)
    {
        Airport *enrAirport = [[User sharedUser].arrayEnrouteAirports objectAtIndex:idx];
        circle= [[MKCircle alloc]init];
        circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(enrAirport.latitude, enrAirport.longitude) radius:777840];
        [_circles60 addObject:circle];
    }
}
-(void) loadCircles120
{
    _circles120 = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayEnrouteAirports.count)];
    
    for(int idx = 0; idx < [User sharedUser].arrayEnrouteAirports.count; idx++)
    {
        Airport *enrAirport = [[User sharedUser].arrayEnrouteAirports objectAtIndex:idx];
        circle= [[MKCircle alloc]init];
        circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(enrAirport.latitude, enrAirport.longitude) radius:1555680];
        [_circles120 addObject:circle];
    }
}
-(void) loadCircles180
{
    _circles180 = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayEnrouteAirports.count)];
    
    for(int idx = 0; idx < [User sharedUser].arrayAlternates.count; idx++)
    {
        Airport *enrAirport = [[User sharedUser].arrayEnrouteAirports objectAtIndex:idx];
        circle= [[MKCircle alloc]init];
        circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(enrAirport.latitude, enrAirport.longitude) radius:2333520];
        [_circles180 addObject:circle];
    }
}
-(void) loadCircles207
{
    _circles207 = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayEnrouteAirports.count)];
    
    for(int idx = 0; idx < [User sharedUser].arrayEnrouteAirports.count; idx++)
    {
        Airport *enrAirport = [[User sharedUser].arrayEnrouteAirports objectAtIndex:idx];
        circle= [[MKCircle alloc]init];
        circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(enrAirport.latitude, enrAirport.longitude) radius:2685400];
        [_circles207 addObject:circle];
    }
}
-(void) removeCompanyAirports
{
    if (bolCompanyAirports == NO) {
        [_mapView addAnnotations:_CompanyAirports];
        bolCompanyAirports = YES;
    } else {
        [_mapView removeAnnotations:_CompanyAirports];
        bolCompanyAirports = NO;
    }

}

-(void) removeAirports
{
    if (bolAirports == NO) {
        [_mapView addAnnotations:_enrAirports];
        bolAirports = YES;
    } else {
        [_mapView removeAnnotations:_enrAirports];
        bolAirports = NO;
    }
}
-(void) removeCircles60
{
    if (bolCircles60 == NO) {
        [_mapView addOverlays:_circles60];
        bolCircles60 = YES;
    } else {
        [_mapView removeOverlays:_circles60];
        bolCircles60 = NO;
    }
}
-(void) removeCircles120
{
    if (bolCircles120 == NO) {
        [_mapView addOverlays:_circles120];
        bolCircles120 = YES;
    } else {
        [_mapView removeOverlays:_circles120];
        bolCircles120 = NO;
    }
}
-(void) removeCircles180
{
    if (bolCircles180 == NO) {
        [_mapView addOverlays:_circles180];
        bolCircles180 = YES;
    } else {
        [_mapView removeOverlays:_circles180];
        bolCircles180 = NO;
    }
}
-(void) removeCircles207
{
    if (bolCircles207 == NO) {
        [_mapView addOverlays:_circles207];
        bolCircles207 = YES;
    } else {
        [_mapView removeOverlays:_circles207];
        bolCircles207 = NO;
    }
}
- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    dispatch_time_t dt = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
    dispatch_after(dt, dispatch_get_main_queue(), ^(void)
                   {
                       [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
                       [User sharedUser].strSelectedWaypoint = view.annotation.title;

                   });
    
}
////// creates the route (MKPolyline) overlay
-(void) loadSunRoute
{
    // while we create the route points, we will also be calculating the bounding box of our route
    // so we can easily zoom in on it.
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    
    // create a c array of points.
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * [User sharedUser].arrayCoordinates.count);
    _waypointsHigh = [[NSMutableArray alloc] init];
    _waypoints = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayCoordinates.count)];
    //    objLog *objLogWpt = [[objLog alloc]init];
    for(int idx = 0; idx < [User sharedUser].arrayCoordinates.count; idx++)
    {
        
        NSString* currentPointString = [[User sharedUser].arrayCoordinates objectAtIndex:idx];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        
        //
        // adjust the bounding box
        //
        
        // if it is the first point, just use them, since we have nothing to compare to yet.
        if (idx == 1) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else
        {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArr[idx] = point;
    }
    
    //    }
    
    // create the polyline based on the array of points.
    self.routeLineInFlight = [MKPolyline polylineWithPoints:pointArr count:[User sharedUser].arrayCoordinates.count];
    
    _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
    
    // clear the memory allocated earlier for the points
//    free(pointArr);
    

}



-(void) loadRoute
{
    
    // while we create the route points, we will also be calculating the bounding box of our route
    // so we can easily zoom in on it.
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    
    // create a c array of points.
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * [User sharedUser].arrayEnRouteWaypoints.count);
    _waypointsHigh = [[NSMutableArray alloc] init];
    _waypoints = [[NSMutableArray alloc] initWithCapacity:([User sharedUser].arrayEnRouteWaypoints.count)];
    //    objLog *objLogWpt = [[objLog alloc]init];
    for(int idx = 0; idx < [User sharedUser].arrayEnRouteWaypoints.count; idx++)
    {
        objLogWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:idx];
        if ([objLogWpt.strLat isEqualToString:@""]) {
            
        }else{
            if ([objLogWpt.strLat containsString:@"."]) { /////// Departure and Destination Airport
                
            } else {
                if ([[objLogWpt.strLat substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
                    objLogWpt.strLat = [@"-" stringByAppendingString:[objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)]];
                    NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLat];
                    [string1 insertString: @"." atIndex: 3];
                    objLogWpt.strLat = string1;
                }else{
                    objLogWpt.strLat = [objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)];
                    NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLat];
                    [string1 insertString: @"." atIndex: 2];
                    objLogWpt.strLat = string1;
                }
                if ([[objLogWpt.strLon substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"W"]) {
                    objLogWpt.strLon = [@"-" stringByAppendingString:[objLogWpt.strLon substringWithRange:NSMakeRange(1, 4)]];
                    NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLon];
                    [string1 insertString: @"." atIndex: 4];
                    objLogWpt.strLon = string1;
                }else{
                    if ([[objLogWpt.strLon substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                        objLogWpt.strLon = [objLogWpt.strLon substringWithRange:NSMakeRange(2, 4)];
                        NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLon];
                        [string1 insertString: @"." atIndex: 2];
                        objLogWpt.strLon = string1;
                    }else{
                        objLogWpt.strLon = [objLogWpt.strLon substringWithRange:NSMakeRange(1, 5)];
                        NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLon];
                        [string1 insertString: @"." atIndex: 3];
                        objLogWpt.strLon = string1;
                    }
                }
            }
            CLLocationDegrees latitude  = [objLogWpt.strLat doubleValue];
            CLLocationDegrees longitude = [objLogWpt.strLon doubleValue];
            // create our coordinate and add it to the correct spot in the array
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            AnnotationWaypoints *wptAnnotation = [[AnnotationWaypoints alloc] init];
            AnnotationEscapeWaypoints *wptEscape = [[AnnotationEscapeWaypoints alloc]init];
            AnnotationsHighTerrain *wptTerrain  = [[AnnotationsHighTerrain alloc]init];
            if ([objLogWpt.strType isEqualToString:@"Escape"]) {
                wptEscape.coordinate = coordinate;
                wptEscape.title = objLogWpt.strWptName;
                wptEscape.subtitle = [[objLogWpt.strWptAirway stringByAppendingString:@" / " ]stringByAppendingString:objLogWpt.strMORA];
                wptEscape.strType = @"Escape";
                wptEscape.strMORA = objLogWpt.strMORA;
                [_waypoints addObject:wptEscape];
            } else {
                if ([objLogWpt.strType isEqualToString:@"Waypoint"]) {
                    if ([objLogWpt.strMORA intValue] > 100) {
                        wptTerrain.coordinate = coordinate;
                        wptTerrain.title = objLogWpt.strWptName;
                        wptTerrain.subtitle = [[objLogWpt.strWptAirway stringByAppendingString:@" / " ]stringByAppendingString:objLogWpt.strMORA];
                        wptTerrain.strMORA = objLogWpt.strMORA;
                        wptTerrain.strType = @"High Terrain";
                        [_waypointsHigh addObject:wptTerrain];
                    }else {
                        wptAnnotation.coordinate = coordinate;
                        wptAnnotation.title = objLogWpt.strWptName;
                        wptAnnotation.subtitle = [[objLogWpt.strWptAirway stringByAppendingString:@" / " ]stringByAppendingString:objLogWpt.strMORA];
                        wptAnnotation.strMORA = objLogWpt.strMORA;
                        wptAnnotation.strType = @"";
                        wptAnnotation.strType = @"Low Terrain";
                        [_waypoints addObject:wptAnnotation];
                    }
                }
            }
  
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
            //
            // adjust the bounding box
            //
            
            // if it is the first point, just use them, since we have nothing to compare to yet.
            if (idx == 1) {
                northEastPoint = point;
                southWestPoint = point;
            }
            else
            {
                if (point.x > northEastPoint.x)
                    northEastPoint.x = point.x;
                if(point.y > northEastPoint.y)
                    northEastPoint.y = point.y;
                if (point.x < southWestPoint.x)
                    southWestPoint.x = point.x;
                if (point.y < southWestPoint.y)
                    southWestPoint.y = point.y;
            }
            
            pointArr[idx] = point;
        }
        
//    }
    
    // create the polyline based on the array of points.
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:[User sharedUser].arrayEnRouteWaypoints.count];
        lineFlight = self.routeLine;
    _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
//    [_mapView addOverlay:self.routeLine];
    // clear the memory allocated earlier for the points
//    free(pointArr);
//
}
}

-(void) loadGreatCircle
{
            objLogWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:0];
            CLLocationDegrees latitude  = [objLogWpt.strLat doubleValue];
            CLLocationDegrees longitude = [objLogWpt.strLon doubleValue];
            CLLocationCoordinate2D Departurecoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            objLogWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:[User sharedUser].arrayEnRouteWaypoints.count-1];
            latitude  = [objLogWpt.strLat doubleValue];
            longitude = [objLogWpt.strLon doubleValue];
            CLLocationCoordinate2D Destinationcoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [self createGreatCircleMKPolylineFromPoint:Departurecoordinate toPoint:Destinationcoordinate forMapView:_mapView];
}

- (void)createGreatCircleMKPolylineFromPoint:(CLLocationCoordinate2D)point1
                                     toPoint:(CLLocationCoordinate2D)point2
                                  forMapView:(MKMapView*)mapView
{
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;
    lat1 = lat1 * (M_PI/180);
    lon1 = lon1 * (M_PI/180);
    lat2 = lat2 * (M_PI/180);
    lon2 = lon2 * (M_PI/180);
    double d = 2 * asin( sqrt(pow(( sin( (lat1-lat2)/2) ), 2) + cos(lat1) * cos(lat2) * pow(( sin( (lon1-lon2)/2) ), 2)));
    int numsegs = 100;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * numsegs);
    double f = 0.0;
    for(int i=1; i<=numsegs; i++)
    {
        f += 1.0 / (float)numsegs;
        double A=sin((1-f)*d)/sin(d);
        double B=sin(f*d)/sin(d);
        double x = A*cos(lat1) * cos(lon1) +  B * cos(lat2) * cos(lon2);
        double y = A*cos(lat1) * sin(lon1) +  B * cos(lat2) * sin(lon2);
        double z = A*sin(lat1)           +  B*sin(lat2);
        double latr=atan2(z, sqrt(pow(x, 2) + pow(y, 2) ));
        double lonr=atan2(y, x);
        double lat = latr * (180/M_PI);
        double lon = lonr * (180/M_PI);
        //        NSLog(@"lat: %f lon: %f", lat, lon);
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
        coords[i - 1] = loc;
    }
    
    //check for circling west to east. If the plane is crossing 180, we need
    //to draw two lines or else the polyline connects the dots and draws a straight
    //line all the way across the map.
    CLLocationCoordinate2D prevCoord;
    BOOL twoLines = NO;
    int numsegs2 = 0;
    CLLocationCoordinate2D *coords2 = NULL;
    
    for(int i=0; i<numsegs; i++)
    {
        CLLocationCoordinate2D coord = coords[i];
        if(prevCoord.longitude < -170 && prevCoord.longitude > -180  && prevCoord.longitude < 0
           && coord.longitude > 170 && coord.longitude < 180 && coord.longitude > 0)
        {
            twoLines = YES;
            coords2 = malloc(sizeof(CLLocationCoordinate2D) * (numsegs - i));
            numsegs2 = numsegs - i;
            for(int j=0; j<numsegs2; j++)
            {
                coords2[j] = coords[i + j];
            }
            break;
        }
        prevCoord = coord;
    }
    
    //remove any previously added overlays
//    [mapView removeOverlays:mapView.overlays];
    
    if(twoLines)
    {
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:numsegs - numsegs2];
        lineGreatCircle = polyline;
        free(coords);
        [mapView addOverlay:lineGreatCircle];
        lineGreatCircle = nil;
        MKPolyline *polyline2 = [MKPolyline polylineWithCoordinates:coords2 count:numsegs2];
        lineGreatCircle2 = polyline2;
        free(coords2);
        [mapView addOverlay:lineGreatCircle2];
        lineGreatCircle2=nil;
    }
    else
    {
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:numsegs];
        lineGreatCircle = polyline;
        free(coords);
        [mapView addOverlay:lineGreatCircle];
        lineGreatCircle=nil;
    }
    
}

-(void) zoomInOnRoute
{
    [_mapView setVisibleMapRect:_routeRect];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}
#pragma mark - AirportPicker

-(IBAction)chooseAirportButtonTapped:(id)sender

{
    UYLCountryTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"popAirportDirectory"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    nav.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = nav.popoverPresentationController;
    controller.preferredContentSize = CGSizeMake(500, 600);
    popover.delegate = self;
    popover.sourceView = self.view;
    popover.sourceRect = CGRectMake((self.view.frame.size.width/2)+250, 50, 0, 0);
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - WaypointPicker

-(IBAction)chooseWaypointButtonTapped:(id)sender

{
    StartTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"popWaypoints"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    nav.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = nav.popoverPresentationController;
    controller.preferredContentSize = CGSizeMake(525, 600);
    popover.delegate = self;
    popover.sourceView = self.view;
    popover.sourceRect = CGRectMake(100, 50, 0, 0);
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:nav animated:YES completion:nil];
    controller.delegate = self;
//    [User sharedUser].bolPopupWaypoints = YES;
}

-(UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller
{
    return UIModalPresentationNone;
}

-(void)selectedWaypoint:(NSString *)selectedWaypoint
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", selectedWaypoint];
    NSArray *result = [[User sharedUser].arrayEnRouteWaypoints filteredArrayUsingPredicate: predicate];
    if ([result count] != 0) {
        NSUInteger indexOfTheObject = [[User sharedUser].arrayEnRouteWaypoints indexOfObject:result.firstObject];
    objLogWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:indexOfTheObject];
    if ([objLogWpt.strLat isEqualToString:@""]) {
        
    }else{
        if ([objLogWpt.strLat containsString:@"."]) { /////// Departure and Destination Airport
            
        } else {
            if ([[objLogWpt.strLat substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
                objLogWpt.strLat = [@"-" stringByAppendingString:[objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)]];
                NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLat];
                [string1 insertString: @"." atIndex: 3];
                objLogWpt.strLat = string1;
            }else{
                objLogWpt.strLat = [objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)];
                NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLat];
                [string1 insertString: @"." atIndex: 2];
                objLogWpt.strLat = string1;
            }
            if ([[objLogWpt.strLon substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"W"]) {
                objLogWpt.strLon = [@"-" stringByAppendingString:[objLogWpt.strLon substringWithRange:NSMakeRange(1, 4)]];
                NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLon];
                [string1 insertString: @"." atIndex: 4];
                objLogWpt.strLon = string1;
            }else{
                if ([[objLogWpt.strLon substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                    objLogWpt.strLon = [objLogWpt.strLon substringWithRange:NSMakeRange(2, 4)];
                    NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLon];
                    [string1 insertString: @"." atIndex: 2];
                    objLogWpt.strLon = string1;
                }else{
                    objLogWpt.strLon = [objLogWpt.strLon substringWithRange:NSMakeRange(1, 5)];
                    NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLon];
                    [string1 insertString: @"." atIndex: 3];
                    objLogWpt.strLon = string1;
                }
            }
        }
//        CLLocationDegrees latitude  = [objLogWpt.strLat doubleValue];
//        CLLocationDegrees longitude = [objLogWpt.strLon doubleValue];
//        // create our coordinate and add it to the correct spot in the array
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        [User sharedUser].dblLatitudeMapCenter = [objLogWpt.strLat doubleValue];
        [User sharedUser].dblLongitudeMapCenter = [objLogWpt.strLon doubleValue];
        [self zoomInOnWaypoint];
    }
    }
}

#pragma mark - Parsing PDF

-(void)selectedFlightPlan:(NSString *)newFlightPlan
{
    //Dismiss the popover if it's showing.
    if (_flightplanPickerPopover) {
        [_flightplanPickerPopover dismissPopoverAnimated:YES];
        _flightplanPickerPopover = nil;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/Inbox", documentsDirectory ];
    [User sharedUser].strPathOFP = [[path stringByAppendingString:@"/"]stringByAppendingString:newFlightPlan];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    [[User sharedUser].arrayEnRouteWaypoints removeAllObjects];
    [[User sharedUser].arrayLog removeAllObjects];
    convertPDF([User sharedUser].strPathOFP);
    [SVProgressHUD showWithStatus:@"Reading OFP, please wait!"];
    // call in main threat
    dispatch_async(dispatch_get_main_queue(), ^{
        [self readOFP];
        [self showRouteonMap];
    });
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMMyy"];
    dateString = [formatter stringFromDate:[User sharedUser].dateFlight];
    [User sharedUser].strOFPHeader = [[[[User sharedUser].strOFPHeader stringByAppendingString:@" "]stringByAppendingString:dateString] stringByAppendingString:@" "];
    [self createHeader];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnLoadPDF,btnShowList                                                                                                                                                                                                                                 ,btnAirports,btnAirportsAll, btnCircles60, nil]];
}
-(void) finished
{
}
- (void)showWithLabel {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Reading OFP ...";
    [HUD showWhileExecuting:@selector(readOFP) onTarget:self withObject:nil animated:YES];
}

-(void) readOFP
{
    [self readtxtFile];
}


-(void) readtxtFile
{
    
    fltpln = NO;
    bolWeather = NO;
    bolWpt = NO;
    bolLog = NO;
    bolETOPS = NO;
    bolTimes = NO;
    btnFltplanTitle = @"";
    bolAirportNOTAMS = NO;
    [User sharedUser].arrayWXNotams = [[NSMutableArray alloc] init];
    __block NSRange rangeTimes;
    strFltpln = [NSMutableString stringWithString:@""];
    strAlternates = [NSMutableString stringWithString:@""];
    strInfoMessage = [NSMutableString stringWithString:@""];
    strExportWeather = [NSMutableString stringWithString:@""];
    strExportNOTAMS = [NSMutableString stringWithString:@""];
    NSString *path = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"output.txt"]encoding:NSUTF8StringEncoding error:nil];
    fileURL = [NSURL fileURLWithPath:path];

    
    OFPreadObject * reader = [[OFPreadObject alloc] initWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"output.txt"]];
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        
        if ([line isEqualToString:@"\r\n"] || [line containsString:@"NIL"]) {
            
        } else {
            
            if (bolreadHeader==YES && [line containsString:@"ETOW"]) {
                [strInfoMessage appendString:line];
                bolreadHeader = NO;
            }
            if (bolreadHeader==YES) {
                if ([line containsString:@"ATC C/S"]) {
                    
                    [User sharedUser].strFlightIdentifier = [[line substringWithRange:NSMakeRange(8, 8)]stringByTrimmingCharactersInSet:
                                                             [NSCharacterSet whitespaceCharacterSet]];
                    NSRange rangeOFP = [line rangeOfString:@"OFP"];
                    [User sharedUser].strOFPNumber = [[line substringWithRange:NSMakeRange(rangeOFP.location, 7)]stringByTrimmingCharactersInSet:
                                                      [NSCharacterSet whitespaceCharacterSet]];
                    
                }
                if ([line containsString:@"AVG W/C"]) {
                    [User sharedUser].strAircraftType = [line substringWithRange:NSMakeRange(6, 4)];
                    [User sharedUser].strAircraftRegistration = [line substringWithRange:NSMakeRange(0, 5)];
                    
                    if ([[User sharedUser].strAircraftType containsString:@"A32"]) {
                        [User sharedUser].strAircraft = @"Narrowbody";
                    }else{
                        [User sharedUser].strAircraft = @"Widebody";
                    }
                }
                [strInfoMessage appendString:line];
            }
            if (bolreadHeader==NO && [line containsString:@"[ OFP ]"]) {
                bolreadHeader=YES;
            }
            
            if (fltpln == YES && [line containsString:@")"]) {
                fltpln = NO;
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                [strFltpln appendString:@"\n"];
                //                NSLog(@"read line: %@", line);
            }
            if (fltpln == YES) {
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                //                NSRange range = [line rangeOfString:@"/"];
                if ([line containsString:@"-"] && [[line substringWithRange:NSMakeRange(5, 1)]isEqualToString:@"/"]) {
                    [User sharedUser].strAircraftType = [line substringWithRange:NSMakeRange(1, 4)];
                    if ([[User sharedUser].strAircraftType containsString:@"A32"]) {
                        [User sharedUser].strAircraftLog = @"Narrowbody";
                        [User sharedUser].strAircraft = @"Narrowbody";
                    }else{
                        [User sharedUser].strAircraftLog = @"Widebody";
                        [User sharedUser].strAircraft = @"Widebody";
                    }
                }
                if ([line containsString:@"DOF/"]) {
                    NSRange rangeDate = [line rangeOfString:@"DOF/"];
                    NSDateComponents *components3 = [[NSDateComponents alloc] init];
                    [components3 setYear:[[@"20" stringByAppendingString:[line substringWithRange:NSMakeRange(rangeDate.location+4, 2)] ]integerValue]];
                    [components3 setMonth:[[line substringWithRange:NSMakeRange(rangeDate.location+6, 2)]integerValue]];
                    [components3 setDay:[[line substringWithRange:NSMakeRange(rangeDate.location+8, 2)]integerValue]];
                    
                    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian]; // Setup an NSCalendar
                    // Setup the new date
                    NSDate *combinedDate = [gregorianCalendar dateFromComponents: components3];
                    
                    
                    // Generate a new NSDate from components3.
                    
                    [User sharedUser].dateFlight = combinedDate;
                }
                [strFltpln appendString:@"\n"];
                //                NSLog(@"read line: %@", line);
            }
            if ([line containsString:@"(FPL"]) {
                fltpln = YES;
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                [strFltpln appendString:@"\n"];
                //                NSLog(@"read line: %@", line);
            }
            if ([line containsString:@"ROUTE:"]) {
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                [strFltpln appendString:@"\n"];
                //                NSLog(@"read line: %@", line);
            }
            /////////////// Weather for Airports
            if ([line containsString:@"AIRPORTLIST ENDED"]) {
                bolWeather = NO;
            }
            if (bolWeather == YES) {
                
                if ([line containsString:@"ETD"] || [line containsString:@"Page"]){
                }else{
                    [strExportWeather appendString:[NSString stringWithFormat:@"%@", line]];
                    [strExportWeather appendString:@"\n"];
                }
            }
            if ([line containsString:@"DESTINATION AIRPORT:"]) {
                bolWeather = YES;
            }
            //////// Weather Waypoints
            if (bolWpt == YES && [line containsString:@"[ ATC Flight Plan ]"]) {
                bolWpt = NO;
            }
            if (bolWpt == YES) {
                if ([line containsString:@"ETD"] || [line containsString:@"Page"] || [line containsString:@"EY"]){
                }else{
//                    [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
//                    [strFltpln appendString:@"\n"];
                    //                NSLog(@"read line: %@", line);
                    if ([[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"N"] || [[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"S"]) {
                        objEnRouteWpt = [[objWPT alloc]init];
                        objEnRouteWpt.strLat = [line substringWithRange:NSMakeRange(0, 5)];
                        objEnRouteWpt.strWptName = [[line substringWithRange:NSMakeRange(6, 10)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                           withString:@""];
                    }
                    if ([[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"E"] || [[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"W"]) {
                        objEnRouteWpt.strLon = [line substringWithRange:NSMakeRange(0, 6)];
                        objEnRouteWpt.strSR = [line substringWithRange:NSMakeRange(43, 10)];
                        [[User sharedUser].arrayEnRouteWaypoints addObject:objEnRouteWpt];
                    }
                }
            }
            if (bolWpt == NO && [line containsString:@"LONG"] && [line containsString:@"POINT"] && [line containsString:@"SR/TROP/OAT"]) {
                bolWpt = YES;
            }
            //////////////////// Reading Block and Takeoff Times
            
            if (bolTimes == YES && [line containsString:@"BLOCK TIME"]) {
                bolTimes = NO;
            }
            
            if (bolTimes == YES) {
                if ([line containsString:@"TAKEOFF"]) {
                    [User sharedUser].strTakeOffTime = [[line substringWithRange:NSMakeRange(rangeTimes.location, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                withString:@""];
                    NSString *TakeOffhours = [[User sharedUser].strTakeOffTime substringWithRange:NSMakeRange(0,2)];
                    NSString *TakeOffMinutes = [[User sharedUser].strTakeOffTime substringWithRange:NSMakeRange(2,2)];
                    NSInteger hour = [TakeOffhours integerValue];
                    NSInteger min = [TakeOffMinutes integerValue];
                    [User sharedUser].intTimeOvhdFROM = ((hour*60)+min)*60;
                    
                }
                if ([line containsString:@"OFF BLOCK"]) {
                    [User sharedUser].strOffBlockTime = [[line substringWithRange:NSMakeRange(rangeTimes.location, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                 withString:@""];
                }
                if ([line containsString:@"LANDING"]) {
                    [User sharedUser].strLandingTime = [[line substringWithRange:NSMakeRange(rangeTimes.location, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                withString:@""];
                }
                
                
            }
            if (bolTimes == NO && [line containsString:@"SCHEDULED        ESTIMATED        ACTUAL"]) {
                bolTimes = YES;
                rangeTimes = [line rangeOfString:@"ESTIMATED"];
            }
            
            //////////////////// Reading Enroute Alternates
            
            if (bolEnrAlt == YES && [line containsString:@"DEPARTURE AIRPORT:"]) {
                bolEnrAlt = NO;
            }
            
            if (bolEnrAlt == YES) {
                if ([line length] > 7) {
                    
                    if ([[line substringWithRange:NSMakeRange(0, 7)]containsString:@"/"]) {
                        [strAlternates appendString:[line substringWithRange:NSMakeRange(0, 4)]];
                        [strAlternates stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]];
                        [strAlternates appendString:@" "];
                    }
                }
            }
            
            if (bolEnrAlt == NO && [line containsString:@"ENROUTE AIRPORT(S):"]) {
                bolEnrAlt = YES;
                
            }
            
            /////////////////// Reading the Alternates
            
            if (bolAlt == YES && ([line containsString:@"FUEL ENROUTE AIRPORT:"]||[line containsString:@"ENROUTE AIRPORT"])) {
                bolAlt = NO;
            }
            
            if (bolAlt == YES) {
                if ([line length] > 7) {
                    if ([[line substringWithRange:NSMakeRange(0, 7)]containsString:@"/"]) {
                        [strAlternates appendString:[line substringWithRange:NSMakeRange(0, 4)]];
                        [strAlternates stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]];
                        [strAlternates appendString:@" "];
                    }
                }
            }
            
            if (bolAlt == NO && [line containsString:@"DESTINATION ALTERNATE:"]) {
                
                bolAlt = YES;
                
            }            /////////////////// Reading the Log
            
            if (bolLog == YES && [line containsString:@"DESTINATION ALTERNATE FLIGHT LOG"]) {
                bolLog = NO;
                objLogWpt = [[User sharedUser].arrayLog lastObject];
                [User sharedUser].strDestination = objLogWpt.strWptName;
                [self searchAirports];
                NSString *strAlt = strAlternates;
                strAlt = [strAlt stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceCharacterSet]];
                strAlt = [strAlt stringByReplacingOccurrencesOfString:@" "
                                                           withString:@", "];
                objLogWpt.strAlternates = strAlt;
            }
            
            if (bolLog == YES) {
                if ([line containsString:@"|AWY"] || [line containsString:@"|WPT"] || [line containsString:@"OCA PLN"] || [line containsString:@"VHF:"] || [line containsString:@"HF :"] || [line containsString:@"OCA RECVD"] || [line containsString:@"IMT ERROR"] || [line containsString:@"|DP "]) {
                }else{
                    if ([line containsString:@"|EDTO"] ) {
                        objLogWpt = [[objLog alloc]init];
                        NSRange range = [line rangeOfString:@"|"];
                        objLogWpt.strLat = [[line substringWithRange:NSMakeRange(range.location + 13, 8)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                    withString:@""];
                        objLogWpt.strLon = [[line substringWithRange:NSMakeRange(range.location + 24, 8)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                    withString:@""];
                        objLogWpt.strCET = [[line substringWithRange:NSMakeRange(range.location + 38, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                    withString:@""];
                        objLogWpt.strWptName = [[line substringWithRange:NSMakeRange(range.location + 5, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                       withString:@""];
                        objLogWpt.strType = @"ETOPS";
                        objLogWpt.intID = [[User sharedUser].arrayLog count]+1;
                        [[User sharedUser].arrayLog addObject:objLogWpt];
                    }
                    if ([line containsString:@"-"]) {
                        
                    } else{
                        if ([line containsString:@"_"]) {
                            objLogWpt = [[objLog alloc]init];
                            NSRange range = [line rangeOfString:@"|"];
                            objLogWpt.strWptAirway = [[line substringWithRange:NSMakeRange(range.location + 1, 7)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                             withString:@""];
                            objLogWpt.strFL = [[line substringWithRange:NSMakeRange(range.location + 9, 3)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                      withString:@""];
                            objLogWpt.strITT = [[line substringWithRange:NSMakeRange(range.location + 14, 3)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                        withString:@""];
                            objLogWpt.strTAS = [[line substringWithRange:NSMakeRange(range.location + 19, 3)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                        withString:@""];
                            objLogWpt.strCET = [[line substringWithRange:NSMakeRange(range.location + 29, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                        withString:@""];
                            objLogWpt.strLat = @"";
                            objLogWpt.strLon = @"";
                            objLogWpt.strAlternates = @"";
                        }else{
                            if ([line containsString:@"|"]) {
                                
                                if ([line containsString:@"FIR"] || [line containsString:@"UIR"] || [line containsString:@"UTA"] || [line containsString:@"OCEANIC"] || [line containsString:@"ENOB NORGE USSR"] || [line containsString:@"DOMESTIC"]) {
                                    objLogWpt = [[objLog alloc]init];
                                    NSRange range = [line rangeOfString:@"|"];
                                    objLogWpt.strWptName = [[line substringWithRange:NSMakeRange(range.location + 1, 5)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                   withString:@""];
                                    
                                    
                                    objLogWpt.strWptAirway = [[line stringByReplacingOccurrencesOfString:@"|" withString:@""]stringByTrimmingCharactersInSet:
                                                              [NSCharacterSet whitespaceCharacterSet]];
                                    objLogWpt.strLat = @"";
                                    objLogWpt.strLon = @"";
                                    objLogWpt.strType = @"Boundary";
                                    objLogWpt.intID = [[User sharedUser].arrayLog count]+1;
                                    [[User sharedUser].arrayLog addObject:objLogWpt];
                                    
                                }else {
                                    if ([line containsString:@"|EDTO"] ) {
                                        
                                    }else{
                                        NSRange range = [line rangeOfString:@"|"];
                                        objLogWpt.strWptName = [[line substringWithRange:NSMakeRange(range.location + 1, 5)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                       withString:@""];
                                        if ([objLogWpt.strWptName isEqualToString:@"TOC"]) {
                                            [User sharedUser].strInitialAltitude = objLogWpt.strFL;
                                        }
                                        
                                        objLogWpt.strMORA = [[line substringWithRange:NSMakeRange(range.location + 7, 5)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                    withString:@""];
                                        objLogWpt.strDTW = [[line substringWithRange:NSMakeRange(range.location + 24, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                    withString:@""];
                                        objLogWpt.strEET = [[line substringWithRange:NSMakeRange(range.location + 29, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                    withString:@""];
                                        
                                        //                                    [self searchEscapeRoutes];
                                        objLogWpt.intID = [[User sharedUser].arrayLog count]+1;
                                        [[User sharedUser].arrayLog addObject:objLogWpt];
                                        if ([[User sharedUser].arrayLog count]==1) {
                                            [User sharedUser].strDeparture = objLogWpt.strWptName;
                                            [self searchAirports];
                                            if ([[User sharedUser].strDeparture isEqualToString:@"OMAA"]) {
                                                [User sharedUser].strDirectionLog = @"OUTBOUND";
                                            }else{
                                                [User sharedUser].strDirectionLog = @"INBOUND";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (bolLog == NO && [line containsString:@"FLIGHT DESTINATION LOG"]) {
                bolLog = YES;
            }
            
            // Start reading the Notams and export them to notams.txt
            
            if (bolAirportNOTAMS == YES && [line containsString:@"EXTENDED AREA AROUND DEPARTURE"]) {
                [strExportNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                bolAirportNOTAMS = NO;
            }
            if (bolAirportNOTAMS == YES) {
                if ([line containsString:@"ETD"] || [line containsString:@"Page"] || [line containsString:@"Page"]){
                }else{
                    [strExportNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                }
            }
            if (bolAirportNOTAMS == NO && [line containsString:@"DEPARTURE AIRPORT"] &&bolWeather == NO) {
                //                [strExportNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                bolAirportNOTAMS = YES;
            }
        }
        NSLog(@"read line: %@", line);
    }];
    /// notams end
    int i;
    for (i = 0; i < [[User sharedUser].arrayEnRouteWaypoints count]; i++) {
        objEnRouteWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objEnRouteWpt.strWptName];
        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
        if ([result count] == 0) {
            
        }else{
            
            objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexOfTheObject];
            if ([objLogWpt.strType length] == 0) {
                objLogWpt.strType = @"Waypoint";
            }
            objEnRouteWpt.strWptAirway = objLogWpt.strWptAirway;
            objEnRouteWpt.strType = objLogWpt.strType;
            objEnRouteWpt.strMORA = objLogWpt.strMORA;
            objLogWpt.strLat = objEnRouteWpt.strLat;
            objLogWpt.strLon = objEnRouteWpt.strLon;
            objLogWpt.strSR = objEnRouteWpt.strSR;
            
        }
    }
    objLogWpt = [[User sharedUser].arrayLog objectAtIndex:0];
    [[User sharedUser].arrayEnRouteWaypoints insertObject:objLogWpt atIndex:0];
    objLogWpt = [[User sharedUser].arrayLog lastObject];
    [[User sharedUser].arrayEnRouteWaypoints addObject:objLogWpt];
    
    //// reorganize Airways for Waypoints
    
    objLog *objLogWptNext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strType ==  %@", @"Waypoint"];
    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
    objLogWptNext = [objLog alloc];
    NSMutableArray *myMutableLog = [result mutableCopy];
    
    for (i = 0; i < [myMutableLog count]; i++) {
        objLogWpt = [myMutableLog objectAtIndex:i];
        if (i <= [myMutableLog count]-2) {
            objLogWptNext = [myMutableLog objectAtIndex:i+1];
            objLogWpt.strWptAirway = objLogWptNext.strWptAirway;
            
        }
    }
    //// putting all arrays together again
    predicate = [NSPredicate predicateWithFormat:@"strType !=  %@", @"Waypoint"];
    NSArray *resultRestLog = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
    NSArray *newArrayLog=[resultRestLog arrayByAddingObjectsFromArray:myMutableLog];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"intID"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArrayLog;
    sortedArrayLog = [newArrayLog sortedArrayUsingDescriptors:sortDescriptors];
    [User sharedUser].arrayLog = [sortedArrayLog mutableCopy];
    
    //// reorganize CET for all Points
    
    //    objLog *objLogWptNext;
    predicate = [NSPredicate predicateWithFormat:@"strCET !=  %@", @""];
    result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
    objLogWptNext = [objLog alloc];
    myMutableLog = [result mutableCopy];
    
    for (i = 0; i < [myMutableLog count]; i++) {
        objLogWpt = [myMutableLog objectAtIndex:i];
        if (i <= [myMutableLog count]-2) {
            objLogWptNext = [myMutableLog objectAtIndex:i+1];
            //            objLogWpt.strCET = objLogWptNext.strCET;
            objLogWpt.strEET = objLogWptNext.strEET;
        }
    }
    //// putting all arrays together again
    predicate = [NSPredicate predicateWithFormat:@"strCET ==  %@",@""];
    resultRestLog = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
    newArrayLog=[resultRestLog arrayByAddingObjectsFromArray:myMutableLog];
    //    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"intID"
                                                 ascending:YES];
    sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //    NSArray *sortedArrayLog;
    sortedArrayLog = [newArrayLog sortedArrayUsingDescriptors:sortDescriptors];
    [User sharedUser].arrayLog = [sortedArrayLog mutableCopy];
    NSError *error;
    NSString *outputFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"fltpln.txt"];
    [strFltpln writeToFile:outputFileName atomically:YES
                  encoding:NSUTF8StringEncoding error:&error];
    outputFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weather.txt"];
    [strExportWeather writeToFile:outputFileName atomically:YES
                         encoding:NSUTF8StringEncoding error:&error];
    outputFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"notams.txt"];
    [strExportNOTAMS writeToFile:outputFileName atomically:YES
                        encoding:NSUTF8StringEncoding error:&error];
    [self loadAlternates];
    [self readWeather];
    [self readNOTAMS];
    [self getEnrouteAlternates];
    [self loadEnrouteAlternatesPDF];
    //    [self calcMissingCoordinates];
    bool bolSunrise;
    bolSunrise =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"ReadSunrise"] boolValue];
    
    if(bolSunrise == YES)
        
    {
        [StartTableViewController calculateSunriseSunset];
    }
    // get escaperoutes for waypoints
    i=0;
    for (i = 0; i < [[User sharedUser].arrayLog count]; i++) {
        objLogWpt = [[User sharedUser].arrayLog objectAtIndex:i];
        [self searchEscapeRoutes];
    }
    i=0;
    
    for (i = 0; i < [[User sharedUser].arrayEnRouteWaypoints count]; i++) {
        objEnRouteWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objEnRouteWpt.strWptName];
        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
        if ([result count] == 0) {
        }else{
            objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexOfTheObject];
            objEnRouteWpt.strWptAirway = objLogWpt.strWptAirway;
            objEnRouteWpt.strType = objLogWpt.strType;
        }
    }
    
    double dblDecDepTime = [User sharedUser].intTimeOvhdFROM;
    NSString *LandingTimeHours = [[User sharedUser].strLandingTime substringWithRange:NSMakeRange(0,2)];
    NSString *LandingTimeMinutes = [[User sharedUser].strLandingTime substringWithRange:NSMakeRange(2,2)];
    NSInteger hour = [LandingTimeHours integerValue];
    NSInteger min = [LandingTimeMinutes integerValue];
    [User sharedUser].intTimeOvhdTO = ((hour*60)+min)*60;
    double dblDecArrTime = [User sharedUser].intTimeOvhdTO;
    double dblFlighttime;
    if (dblDecDepTime > dblDecArrTime) {
        dblDecArrTime = dblDecArrTime + 86400;
    }
    dblFlighttime = dblDecArrTime - dblDecDepTime;
    [User sharedUser].strTripDuration = [[NSString stringWithFormat:@"%02.0f",floor((dblFlighttime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblFlighttime)/3600 - floor((dblFlighttime)/3600))*60]];
    [SVProgressHUD dismiss];
    [self createHeader];
}


-(void) readWeather
{
    bolWeather = YES;
    
    strWeather = [NSMutableString stringWithString:@""];
    NSString *path = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"weather.txt"]encoding:NSUTF8StringEncoding error:nil];
    fileURL = [NSURL fileURLWithPath:path];
    OFPreadObject * reader = [[OFPreadObject alloc] initWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"weather.txt"]];
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        
        
        if ([line isEqualToString:@"\r\n"] || [line containsString:@"NIL"] || [line isEqualToString:@"\n"] || [line length] < 7) {
        } else {
            if (bolWeather == YES && [line containsString:@"ROUTE:"]) {
                if ([strWeather length] != 0) {
                    NSString *strICAO = [strWeather substringWithRange:NSMakeRange(0, 4)];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
                    NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
                    if ([result count] != 0) {
                        NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
                        Airport *airport = [[Airport alloc] init];
                        airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
                        airport.strMETAR = strWeather;
                        
                    }
                    strWeather = [NSMutableString stringWithString:@""];
                }
                bolWeather = NO;
            }
            if (bolWeather == YES && [[line substringWithRange:NSMakeRange(4, 1)]isEqualToString:@"/"]) {
                bolAirportExists = NO;
                if ([strWeather length] != 0) {
                    NSString *strICAO = [strWeather substringWithRange:NSMakeRange(0, 4)];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
                    NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
                    if ([result count] != 0) {
                        NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
                        Airport *airport = [[Airport alloc] init];
                        airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
                        airport.strMETAR = strWeather;
                        NSLog(@"%@",strWeather);
                    } else {
                        ////////////////////////////// adding missing airports
                        NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
                        int i;
                        for (i = 0; i < [arrMasterEntity count]; i++) {
                            
                            if (self.managedObjectContext)
                            {
                                [self.managedObjectContext performBlockAndWait:^{
                                    [self.managedObjectContext reset];
                                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                                    [NSFetchedResultsController deleteCacheWithName:@"Airports"];
                                    NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
                                    [fetchRequest setEntity:entity];
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier = %@", strICAO];
                                    [fetchRequest setPredicate:predicate];
                                    NSInteger intRecordsCount;
                                    NSError *error = nil;
                                    [fetchRequest setFetchLimit:1000];
                                    
                                    intRecordsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
                                    if (intRecordsCount == 1) {
                                        bolAirportExists = YES  ;
                                    }
                                }];
                            }
                        }
                        if (bolAirportExists == NO) {
                            NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
                            [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ICAOIdentifier ==  %@", strICAO];
                            NSArray *result = [[User sharedUser].arrayAllAirports filteredArrayUsingPredicate: predicate];
                            if ([result count] != 0) {
                                Airports *detairport = [NSEntityDescription insertNewObjectForEntityForName:@"AirportsImported" inManagedObjectContext:context];
                                Airport *newAirport = [[Airport alloc]init];
                                NSDate *now = [NSDate date];
                                [detairport setValue:[NSNumber numberWithInt:SDObjectCreated] forKey:@"syncStatus"];
                                NSArray *myArr = [result valueForKey:@"IATAIdentifier"];
                                NSLog(@"%@",[myArr objectAtIndex:0]);
                                detairport.iataidentifier = [myArr objectAtIndex:0];
                                newAirport.iataidentifier = [myArr objectAtIndex:0];
                                myArr = [result valueForKey:@"ICAOIdentifier"];
                                detairport.icaoidentifier = [myArr objectAtIndex:0];
                                newAirport.icaoidentifier = [myArr objectAtIndex:0];
                                myArr = [result valueForKey:@"Name"];
                                detairport.name = [myArr objectAtIndex:0];
                                newAirport.name = [myArr objectAtIndex:0];
                                myArr = [result valueForKey:@"City"];
                                detairport.date = now;
                                detairport.city = [myArr objectAtIndex:0];
                                newAirport.city = [myArr objectAtIndex:0];
                                myArr = [result valueForKey:@"Elevation"];
                                NSString *intElevation = [myArr objectAtIndex:0];
                                intElevation = [intElevation stringByAppendingString:@".0"];
                                double dblElevation = [intElevation doubleValue];
                                [detairport setValue:[NSNumber numberWithDouble:dblElevation] forKey:@"elevation"];
                                newAirport.elevation = dblElevation;
                                myArr = [result valueForKey:@"Latitude"];
                                NSString *intLatitude = [myArr objectAtIndex:0];
                                double dblLatitude = [intLatitude doubleValue];
                                [detairport setValue:[NSNumber numberWithDouble:dblLatitude] forKey:@"Latitude"];
                                newAirport.latitude = dblLatitude;
                                myArr = [result valueForKey:@"Longitude"];
                                NSString *intLongitude = [myArr objectAtIndex:0];
                                double dblLongitude = [intLongitude doubleValue];
                                [detairport setValue:[NSNumber numberWithDouble:dblLongitude] forKey:@"Longitude"];
                                newAirport.longitude = dblLongitude;
                                myArr = [result valueForKey:@"TimeZone"];
                                detairport.timezone = [myArr objectAtIndex:0];
                                newAirport.timezone = [myArr objectAtIndex:0];
                                [newAirport.country setValue:@"" forKey:@"country"];
                                [detairport.cat32x setValue:@"" forKey:@"cat32x"];
                                [detairport.cat332 setValue:@"" forKey:@"cat332"];
                                [detairport.cat333 setValue:@"" forKey:@"cat333"];
                                [detairport.cat345 setValue:@"" forKey:@"cat345"];
                                [detairport.cat346 setValue:@"" forKey:@"cat346"];
                                [detairport.cat350 setValue:@"" forKey:@"cat350"];
                                [detairport.cat380 setValue:@"" forKey:@"cat380"];
                                [detairport.cat777 setValue:@"" forKey:@"cat777"];
                                [detairport.cat787 setValue:@"" forKey:@"cat787"];
                                [detairport.note32x setValue:@"" forKey:@"note32x"];
                                [detairport.note332 setValue:@"" forKey:@"note332"];
                                [detairport.note333 setValue:@"" forKey:@"note333"];
                                [detairport.note345 setValue:@"" forKey:@"note345"];
                                [detairport.note346 setValue:@"" forKey:@"note346"];
                                [detairport.note350 setValue:@"" forKey:@"note350"];
                                [detairport.note380 setValue:@"" forKey:@"note380"];
                                [detairport.note777 setValue:@"" forKey:@"note777"];
                                [detairport.note787 setValue:@"" forKey:@"note787"];
                                [detairport.rffnotes setValue:@"" forKey:@"rffnotes"];
                                [detairport.rff setValue:@"" forKey:@"rff"];
                                [detairport.rffnotes setValue:@"" forKey:@"rffnotes"];
                                [detairport.peg setValue:@"" forKey:@"peg"];
                                [detairport.pegnotes setValue:@"" forKey:@"pegnotes"];
                                NSDate *date = now;
                                detairport.updatedAt = date;
                                detairport.adequate = NO;
                                detairport.escaperoute = NO;
                                detairport.cpldg = NO;
                                //
                                NSError *error;
                                if (![context save:&error]) {
                                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                                }
                                [[User sharedUser].arrayAlternates addObject:newAirport];
                                [[User sharedUser].arrayWXNotams addObject:newAirport];
                            } else {
                                
                            }
                        }
                    }
                    strWeather = [NSMutableString stringWithString:@""];
                    [strWeather appendString:[NSString stringWithFormat:@"%@", line]];
                } else {
                    [strWeather appendString:[NSString stringWithFormat:@"%@", line]];
                }
            }else {
                if (bolWeather == YES){
                    [strWeather appendString:[NSString stringWithFormat:@"%@", line]];
                }
            }
        }
    }];
    
    // add last weather airport in list
    
    if ([strWeather length] != 0) {
        NSString *strICAO = [strWeather substringWithRange:NSMakeRange(0, 4)];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
        NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
        if ([result count] != 0) {
            NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
            Airport *airport = [[Airport alloc] init];
            airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
            airport.strMETAR = strWeather;
            NSLog(@"%@",strWeather);
        }
    }
}
-(void) readNOTAMS
{
    bolAirportNOTAMS = YES;
    __block NSString *strAirportfunction;
    strNOTAMS = [NSMutableString stringWithString:@""];
    NSString *path = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"notams.txt"]encoding:NSUTF8StringEncoding error:nil];
    fileURL = [NSURL fileURLWithPath:path];
    OFPreadObject * reader = [[OFPreadObject alloc] initWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"notams.txt"]];
    strAirportfunction = @"Enroute Alternate";
    
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        if ([line isEqualToString:@"\r\n"] || [line isEqualToString:@"\n"] || [line containsString:@"===="]) {
            
        } else {
            //            if (bolAirportNOTAMS == YES && [line containsString:@"EXTENDED AREA AROUND DEPARTURE"]) {
            //                bolAirportNOTAMS = NO;
            //            }
            if (bolAirportNOTAMS == YES) {
                if ([line length] > 7) {
                    NSRange whiteSpaceRange = [[line substringWithRange:NSMakeRange(0, 7)] rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([line containsString:@"/"] && [[line substringWithRange:NSMakeRange(4, 2)]isEqualToString:@" /"] && (whiteSpaceRange.location != NSNotFound) && [line rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
                        if ([strNOTAMS length] != 0) {
                            if ([strNOTAMS containsString:@"/DEST/"]) {
                                strAirportfunction = @"Destination Airport";
                            }else
                                if ([strNOTAMS containsString:@"/DEST ALTN/"]) {
                                    strAirportfunction = @"Destination Alternate";
                                }else
                                    if ([strNOTAMS containsString:@"ETOPS"]) {
                                        strAirportfunction = @"ETOPS Airport";
                                    }else
                                        if ([strNOTAMS containsString:@"/FUEL ALTN/"]) {
                                            strAirportfunction = @"Fuel Enroute Airport";
                                        }else
                                            if ([strNOTAMS containsString:@"/FUEL ALTN/ETOPS"]) {
                                                strAirportfunction = @"Fuel Enroute / ETOPS Airport";
                                            }else
                                                if ([strNOTAMS containsString:@"/DEP/"]) {
                                                    strAirportfunction = @"Departure Airport";
                                                }else{
                                                    strAirportfunction = @"Enroute Airport";
                                                }
                            NSString *strICAO = [[strNOTAMS stringByTrimmingCharactersInSet:
                                                  [NSCharacterSet whitespaceCharacterSet]]substringWithRange:NSMakeRange(0, 4)];
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
                            NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
                            if ([result count] != 0) {
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
                                Airport *airport = [[Airport alloc] init];
                                airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
                                airport.strNOTAMS = strNOTAMS;
                                airport.strFunction = strAirportfunction;
                                NSLog(@"%@",strNOTAMS);
                            }
                        }
                        strNOTAMS = [NSMutableString stringWithString:@""];
                        [strNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                    } else {
                        [strNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                    }
                    
                } else {
                    if (bolAirportNOTAMS == YES) {
                        [strNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                    }
                }
            }
            //            if (bolAirportNOTAMS == NO && [line containsString:@"DEPARTURE AIRPORT"]) {
            //                bolAirportNOTAMS = YES;
            //            }
        }
    }];
    // add last airportnotam
    if ([strNOTAMS length] != 0) {
        if ([strNOTAMS containsString:@"/DEST/"]) {
            strAirportfunction = @"Destination Airport";
        }
        if ([strNOTAMS containsString:@"/DEST ALTN/"]) {
            strAirportfunction = @"Destination Alternate";
        }
        if ([strNOTAMS containsString:@"ETOPS"]) {
            strAirportfunction = @"ETOPS Airport";
        }
        if ([strNOTAMS containsString:@"/FUEL ALTN/"]) {
            strAirportfunction = @"Fuel Enroute Airport";
        }
        if ([strNOTAMS containsString:@"/FUEL ALTN/ETOPS"]) {
            strAirportfunction = @"Fuel Enroute / ETOPS Airport";
        }
        if ([strNOTAMS containsString:@"/DEP/"]) {
            strAirportfunction = @"Departure Airport";
        }
        NSString *strICAO = [[strNOTAMS stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]]substringWithRange:NSMakeRange(0, 4)];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
        NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
        if ([result count] != 0) {
            NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
            Airport *airport = [[Airport alloc] init];
            airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
            airport.strNOTAMS = strNOTAMS;
            airport.strFunction = strAirportfunction;
            NSLog(@"%@",strNOTAMS);
        }
    }
    
}
- (void) searchEscapeRoutes
{
    NSArray *arrMasterEntity;
    if ([[User sharedUser].strAircraft isEqualToString:@"Narrowbody"]) {
        if ([[User sharedUser].strDeparture isEqualToString:@"OMAA"]) {
            NSArray *arrEntitiesNarrowOutbound = [[NSArray alloc] initWithObjects:@"EscapeNarrowOutboundEurope",@"EscapeNarrowOutboundMiddleEast",@"EscapeNarrowOutboundIran",@"EscapeNarrowOutboundAfricaUSA",@"EscapeNarrowOutboundChina",nil];
            arrMasterEntity = arrEntitiesNarrowOutbound;
        } else{
            NSArray *arrEntitiesNarrowInbound = [[NSArray alloc] initWithObjects:@"EscapeNarrowInboundEurope",@"EscapeNarrowInboundMiddleEast",@"EscapeNarrowInboundIran",@"EscapeNarrowInboundAfricaUSA",@"EscapeNarrowInboundChina",nil];
            arrMasterEntity = arrEntitiesNarrowInbound;
        }
        
    }else {
        if ([[User sharedUser].strDeparture isEqualToString:@"OMAA"]) {
            NSArray *arrEntitiesWideOutbound = [[NSArray alloc] initWithObjects:@"EscapeWideOutboundEurope",@"EscapeWideOutboundMiddleEast",@"EscapeWideOutboundIran",@"EscapeWideOutboundSEAsia",@"EscapeWideOutboundChina",@"EscapeWideOutboundAfricaUSA", nil] ;
            arrMasterEntity = arrEntitiesWideOutbound;
        } else{
            NSArray *arrEntitiesWideInbound = [[NSArray alloc] initWithObjects:@"EscapeWideInboundEurope",@"EscapeWideInboundMiddleEast",@"EscapeWideInboundIran",@"EscapeWideInboundAfricaUSA",@"EscapeWideInboundSEAsia",@"EscapeWideInboundChina",nil];
            arrMasterEntity = arrEntitiesWideInbound;
        }
    }
    
    int i;
    for (i = 0; i < [arrMasterEntity count]; i++) {
        
        if (self.managedObjectContext)
        {
            [self.managedObjectContext performBlockAndWait:^{
                [self.managedObjectContext reset];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                [NSFetchedResultsController deleteCacheWithName:@"Escape"];
                NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
                [fetchRequest setEntity:entity];
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"wptname = %@", objLogWpt.strWptName];
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"airways contains[c] %@", objLogWpt.strWptAirway];
                NSPredicate *predicate;
                if ([objLogWpt.strWptAirway length]!= 0) {
                    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
                }else{
                    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1]];
                }
                [fetchRequest setPredicate:predicate];
                NSInteger intRecordsCount;
                NSError *error = nil;
                [fetchRequest setFetchLimit:1000];
                intRecordsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
                if (intRecordsCount != 0) {
                    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
                    Escape *escapewpt = nil;
                    escapewpt = [results objectAtIndex:0];
                    objLogWpt.strType = @"Escape";
                    objLogWpt.strPage = escapewpt.page;
                    objLogWpt.strChapter = escapewpt.chapter;
                    objLogWpt.strAlternates = escapewpt.alternates;
                }
            }];
        }
    }
    
}

- (void) searchAirports
{
    NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
    
    //    objLogWpt.strType = @"";
    int i;
    for (i = 0; i < [arrMasterEntity count]; i++) {
        
        if (self.managedObjectContext)
        {
            [self.managedObjectContext performBlockAndWait:^{
                [self.managedObjectContext reset];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                [NSFetchedResultsController deleteCacheWithName:@"Airports"];
                NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
                [fetchRequest setEntity:entity];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier = %@", objLogWpt.strWptName];
                [fetchRequest setPredicate:predicate];
                NSInteger intRecordsCount;
                NSError *error = nil;
                [fetchRequest setFetchLimit:1000];
                intRecordsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
                if (intRecordsCount == 1) {
                    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
                    airportLog = nil;
                    airportLog = [results objectAtIndex:0];
                    objLogWpt.strType = @"Airport";
                    objLogWpt.strLat = [NSString stringWithFormat:@"%@",airportLog.latitude];
                    objLogWpt.strLon = [NSString stringWithFormat:@"%@",airportLog.longitude];
                    [self calcTimeZone];
                    objLogWpt.strFL = airportLog.timezone;
                    objLogWpt.strMORA = [NSString stringWithFormat:@"%@",airportLog.elevation];
                    objLogWpt.strWptAirway = airportLog.iataidentifier;
                    if ([btnFltplanTitle length] == 0)
                    {
                        btnFltplanTitle = airportLog.iataidentifier;
                    } else {
                        btnFltplanTitle = [[btnFltplanTitle stringByAppendingString:@" - "] stringByAppendingString:airportLog.iataidentifier];
                        [User sharedUser].strFlightPlanTitle = btnFltplanTitle;
                        [User sharedUser].strOFPHeader = [[User sharedUser].strOFPHeader stringByAppendingString:btnFltplanTitle];
                    }
                }
                
            }];
        }
    }
    
}
-(void) loadEnrouteAlternatesPDF // for pdf reading only

{
    //    arrAlternates = [[NSArray alloc] init];
    
    NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
    
    [[User sharedUser].arrayEnrouteAirports removeAllObjects];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    for (int i=0; i < [[User sharedUser].arrayAlternates count]; i++)
    {
        //        bool bolAirportExists = NO;
        NSString *strIcaoIdentifier = [[[User sharedUser].arrayAlternates objectAtIndex:i]valueForKeyPath:@"icaoidentifier"];  //find object with this id in core data
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
        int i;
        for (i = 0; i < [arrMasterEntity count]; i++) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [NSFetchedResultsController deleteCacheWithName:@"Airports"];
            NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
            [fetchRequest setPredicate:predicate];
            NSArray *results = [context executeFetchRequest:fetchRequest error:NULL];
            if ([results count] == 1){
                bolAirportExists = YES;
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
                //                detairport.cpldg = [managedairport.cpldg boolValue];
                //                detairport.adequate = [managedairport.adequate boolValue];
                //                detairport.escaperoute = [managedairport.escaperoute boolValue];
                detairport.updatedAt = managedairport.updatedAt;
                detairport.city = managedairport.city;
                detairport.elevation = managedairport.elevation;
                detairport.latitude = managedairport.latitude;
                detairport.longitude = managedairport.longitude;
                detairport.timezone = managedairport.timezone;
                detairport.country = managedairport.country;
                detairport.alternates = managedairport.alternates;
                [[User sharedUser].arrayEnrouteAirports addObject:detairport];
                //                [[User sharedUser].arrayWXNotams addObject:detairport];
                
            }
        }
        if (bolAirportExists == NO)
        {
            NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ICAOIdentifier ==  %@", strIcaoIdentifier];
            NSArray *result = [[User sharedUser].arrayAllAirports filteredArrayUsingPredicate: predicate];
            if ([result count] != 0) {
                Airports *detairport = [NSEntityDescription insertNewObjectForEntityForName:@"AirportsImported" inManagedObjectContext:context];
                Airport *newAirport = [[Airport alloc]init];
                NSDate *now = [NSDate date];
                [detairport setValue:[NSNumber numberWithInt:SDObjectCreated] forKey:@"syncStatus"];
                NSArray *myArr = [result valueForKey:@"IATAIdentifier"];
                NSLog(@"%@",[myArr objectAtIndex:0]);
                detairport.iataidentifier = [myArr objectAtIndex:0];
                newAirport.iataidentifier = [myArr objectAtIndex:0];
                myArr = [result valueForKey:@"ICAOIdentifier"];
                detairport.icaoidentifier = [myArr objectAtIndex:0];
                newAirport.icaoidentifier = [myArr objectAtIndex:0];
                myArr = [result valueForKey:@"Name"];
                detairport.name = [myArr objectAtIndex:0];
                newAirport.name = [myArr objectAtIndex:0];
                myArr = [result valueForKey:@"City"];
                detairport.date = now;
                detairport.city = [myArr objectAtIndex:0];
                newAirport.city = [myArr objectAtIndex:0];
                myArr = [result valueForKey:@"Elevation"];
                NSString *intElevation = [myArr objectAtIndex:0];
                intElevation = [intElevation stringByAppendingString:@".0"];
                double dblElevation = [intElevation doubleValue];
                [detairport setValue:[NSNumber numberWithDouble:dblElevation] forKey:@"elevation"];
                newAirport.elevation = dblElevation;
                myArr = [result valueForKey:@"Latitude"];
                NSString *intLatitude = [myArr objectAtIndex:0];
                double dblLatitude = [intLatitude doubleValue];
                [detairport setValue:[NSNumber numberWithDouble:dblLatitude] forKey:@"Latitude"];
                newAirport.latitude = dblLatitude;
                myArr = [result valueForKey:@"Longitude"];
                NSString *intLongitude = [myArr objectAtIndex:0];
                double dblLongitude = [intLongitude doubleValue];
                [detairport setValue:[NSNumber numberWithDouble:dblLongitude] forKey:@"Longitude"];
                newAirport.longitude = dblLongitude;
                myArr = [result valueForKey:@"TimeZone"];
                detairport.timezone = [myArr objectAtIndex:0];
                newAirport.timezone = [myArr objectAtIndex:0];
                [newAirport.country setValue:@"" forKey:@"country"];
                [detairport.cat32x setValue:@"" forKey:@"cat32x"];
                [detairport.cat332 setValue:@"" forKey:@"cat332"];
                [detairport.cat333 setValue:@"" forKey:@"cat333"];
                [detairport.cat345 setValue:@"" forKey:@"cat345"];
                [detairport.cat346 setValue:@"" forKey:@"cat346"];
                [detairport.cat350 setValue:@"" forKey:@"cat350"];
                [detairport.cat380 setValue:@"" forKey:@"cat380"];
                [detairport.cat777 setValue:@"" forKey:@"cat777"];
                [detairport.cat787 setValue:@"" forKey:@"cat787"];
                [detairport.note32x setValue:@"" forKey:@"note32x"];
                [detairport.note332 setValue:@"" forKey:@"note332"];
                [detairport.note333 setValue:@"" forKey:@"note333"];
                [detairport.note345 setValue:@"" forKey:@"note345"];
                [detairport.note346 setValue:@"" forKey:@"note346"];
                [detairport.note350 setValue:@"" forKey:@"note350"];
                [detairport.note380 setValue:@"" forKey:@"note380"];
                [detairport.note777 setValue:@"" forKey:@"note777"];
                [detairport.note787 setValue:@"" forKey:@"note787"];
                [detairport.rffnotes setValue:@"" forKey:@"rffnotes"];
                [detairport.rff setValue:@"" forKey:@"rff"];
                [detairport.rffnotes setValue:@"" forKey:@"rffnotes"];
                [detairport.peg setValue:@"" forKey:@"peg"];
                [detairport.pegnotes setValue:@"" forKey:@"pegnotes"];
                NSDate *date = now;
                detairport.updatedAt = date;
                detairport.adequate = 0;
                detairport.escaperoute = 0;
                detairport.cpldg = 0;
                //
                NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
                [[User sharedUser].arrayEnrouteAirports addObject:newAirport];
            }
            
        }
    }
}

-(void) getEnrouteAlternates
{
    
    int i;
    for (i = 0; i < [[User sharedUser].arrayLog count]; i++) {
        objLogWpt = [[User sharedUser].arrayLog objectAtIndex:i];
        if ([objLogWpt.strLat isEqualToString:@""]) {
            
        } else {
            NSMutableArray *arrClosestAlternates = [[NSMutableArray alloc]init];
            int i;
            for (i = 0; i < [[User sharedUser].arrayAlternates count]; i++) {
                Airport *enrAirport = [[User sharedUser].arrayAlternates objectAtIndex:i];
                NSMutableString *strLat;
                NSMutableString *strLon;
                if ([objLogWpt.strLat isEqualToString:@""]) {
                    
                }else{
                    if ([objLogWpt.strLat containsString:@"."]) { /////// Departure and Destination Airport
                        strLon = [NSMutableString stringWithString:objLogWpt.strLon];
                        strLat = [NSMutableString stringWithString:objLogWpt.strLat];
                    } else {
                        if ([[objLogWpt.strLat substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
                            strLat = [NSMutableString stringWithString:[@"-" stringByAppendingString:[objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)]]];
                            [strLat insertString: @"." atIndex: 3];
                            
                        }else{
                            strLat = [NSMutableString stringWithString:[objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)]];
                            [strLat insertString: @"." atIndex: 2];
                            
                        }
                        if ([[objLogWpt.strLon substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"W"]) {
                            strLon = [NSMutableString stringWithString:[@"-" stringByAppendingString:[objLogWpt.strLon substringWithRange:NSMakeRange(1, 4)]]];
                            [strLon insertString: @"." atIndex: 4];
                            
                        }else{
                            if ([[objLogWpt.strLon substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                                strLon = [NSMutableString stringWithString:[objLogWpt.strLon substringWithRange:NSMakeRange(2, 4)]];
                                [strLon insertString: @"." atIndex: 2];
                                
                            }else{
                                strLon = [NSMutableString stringWithString:[objLogWpt.strLon substringWithRange:NSMakeRange(1, 4)]];
                                [strLon insertString: @"." atIndex: 3];
                                
                            }
                        }
                    }
                }
                double dblDistanceRad = acos(sin(([strLat doubleValue]*M_PI)/180)*sin((enrAirport.latitude*M_PI)/180)
                                             +cos(([strLat doubleValue]*M_PI)/180)*cos((enrAirport.latitude*M_PI)/180)
                                             *cos((([strLon doubleValue]*M_PI)/180)-(enrAirport.longitude*M_PI)/180));
                double dblDistanceNM = (dblDistanceRad*180*60)/M_PI;
                
                if (dblDistanceNM <= 420) {
                    if ([objLogWpt.strAlternates containsString:enrAirport.icaoidentifier]) {
                    } else {
                        enrAirport.distance = dblDistanceNM;
                        [arrClosestAlternates addObject:enrAirport];
                    }
                }
                
            }
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                         ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray;
            sortedArray = [arrClosestAlternates sortedArrayUsingDescriptors:sortDescriptors];
            int a;
            for (a = 0; a < [sortedArray count]; a++) {
                Airport * altAirport = [sortedArray objectAtIndex:a];
                objLogWpt.strAlternates = [[[objLogWpt.strAlternates stringByAppendingString:@" "] stringByAppendingString:altAirport.icaoidentifier] stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceCharacterSet]];
                if (a == 2) {
                    break;
                }
            }
        }
    }
}
-(void) calcTimeZone
{
    
    NSTimeZone *currentTimeZone =
    [NSTimeZone timeZoneWithName:airportLog.timezone];
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
            airportLog.timezone = [[[NSString alloc] initWithFormat:@"%-.2li:00", (long)intHours]stringByAppendingString:@""];
        }
        else {
            airportLog.timezone = [[[NSString alloc] initWithFormat:@"%-.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@""];
        }
    }
    else {
        if (intMinutes < 15)
        {
            airportLog.timezone = [[[NSString alloc] initWithFormat:@"%+.2li:00", (long)intHours]stringByAppendingString:@""];
        }
        else {
            airportLog.timezone = [[[NSString alloc] initWithFormat:@"%+.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@""];
        }
    }
}
-(void) loadAlternates
{
    NSArray *arrAlternates = [[NSArray alloc] init];
    NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
    NSString *strAlt = strAlternates;
    strAlt = [[[User sharedUser].strDeparture stringByAppendingString:@" "] stringByAppendingString:[[[User sharedUser].strDestination stringByAppendingString:@" "] stringByAppendingString:strAlt]];
    strAlt = [strAlt stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceCharacterSet]];
    strAlt = [strAlt stringByReplacingOccurrencesOfString:@" "
                                               withString:@", "];
    arrAlternates = [strAlt componentsSeparatedByString:@", "];
    [User sharedUser].arrayAlternates = [[NSMutableArray alloc] init];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    for (int i=0; i < [arrAlternates count]; i++)
    {
        NSString *strIcaoIdentifier = [arrAlternates objectAtIndex:i];  //find object with this id in core data
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
        int i;
        for (i = 0; i < [arrMasterEntity count]; i++) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [NSFetchedResultsController deleteCacheWithName:@"Airports"];
            NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
            [fetchRequest setPredicate:predicate];
            NSArray *results = [context executeFetchRequest:fetchRequest error:NULL];
            if ([results count] == 1){
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
                detairport.country = managedairport.country;
                [[User sharedUser].arrayAlternates addObject:detairport];
                [[User sharedUser].arrayWXNotams addObject:detairport];
                
            }
        }
    }
    
}
-(void) calcCoordinates
{
    double dblLatitude;
    dblLatitude = [airportLog.latitude intValue];
    if (dblLatitude >= 0) {
        objLogWpt.strLat = [[NSString alloc]initWithFormat:@"N%02.0f%02.1f", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    } else {
        dblLatitude = dblLatitude*-1;
        objLogWpt.strLat = [[NSString alloc]initWithFormat:@"S%02.0f%02.1f", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    }
    double dblLongitude;
    dblLongitude = [airportLog.longitude intValue];
    if (dblLongitude >= 0) {
        
        objLogWpt.strLon = [[NSString alloc]initWithFormat:@"E%03.0f%02.1f", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60];
    } else {
        dblLongitude = dblLongitude*-1;
        objLogWpt.strLon = [[NSString alloc]initWithFormat:@"W%03.0f%02.1f", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60];
    }
    
}


#pragma mark MKMapViewDelegate
@end
