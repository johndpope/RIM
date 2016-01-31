//
//  os4MapsViewController.h
//  os4Maps
//
//  Created by Craig Spitzkoff on 7/4/10.
//  Copyright Craig Spitzkoff 2010. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AnnotationAllCompanyAirports.h"
#import "AnnotationWaypoints.h"
#import "AnnotationEscapeWaypoints.h"
#import "AnnotationEnrouteAirports.h"
#import "AnnotationsHighTerrain.h"
#import "AnnotationDepDestAirport.h"
#import "AnnotationEnrouteAirport.h"
#import "AnnotationDestinationAlternate.h"
#import "AnnotationEmergencyAirport.h"
#import "ReaderViewController.h"
#import "AirportAlternateDetailTableViewController.h"
#import "User.h"
#import "objLog.h"
#import "Airport.h"
#import "Airports.h"
#import "SDCoreDataController.h"
#import "AirportbriefingTableViewController.h"
#import "AirportAlternatesBriefingTableViewController.h"
#import "FlightPlanPickerTableViewController.h"
#include "pdf.h"
#import "StartTableViewController.h"
//#import "WaypointTableViewController.h"
#import "UYLCountryTableViewController.h"
#import "MKNumberBadgeView.h"

@interface os4MapsViewController : UIViewController <MKMapViewDelegate , FlightPlanPickerDelegate,WaypointPickerDelegate,UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate>
{
    	// the map view
	MKMapView* _mapView;
	
	// the data representing the route points. 
	MKPolyline* _routeLine;
    MKPolyline* _routeGreatCircle;
    MKPolyline* _routeLineInFlight;
	NSMutableArray *mapAnnotations;
    NSMutableArray *mapAnnotationsInFlight;
	// the view we create for the line on the map
	MKPolylineView* _routeLineView;
    MKPolylineView* _routeLineViewInFlight;
	
	// the rect that bounds the loaded points
	MKMapRect _routeRect;
    NSMutableArray *documents;

}

@property (nonatomic, strong) UIPopoverController *flightplanPickerPopover;
@property (nonatomic, strong) UIPopoverController *WaypointPickerPopover;

@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) MKPolyline* routeLine;
@property (nonatomic, strong) MKPolyline* routeGreatCircle;
@property (nonatomic, strong) MKPolyline* routeLineInFlight;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) NSMutableArray *mapAnnotationsInFlight;
@property (nonatomic, strong) MKPolylineView* routeLineView;
@property (nonatomic, strong) MKPolylineView* routeLineViewInFlight;
@property (nonatomic, strong) NSArray *arrSunRiseSet;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnAirports;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnAirportsAll;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnLoadPDF;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnShowList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnCircles60;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnCircles120;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnCircles180;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnCircles207;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnRefresh;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnSearch;

@property (nonatomic, retain) IBOutlet UITableViewController *tblviewPopover;
@property (strong, nonatomic) IBOutlet UIView *customHeader;
@property (nonatomic, strong) FlightPlanPickerTableViewController *flightplanPicker;
@property (nonatomic, strong) StartTableViewController *WaypointPicker;

//@property (nonatomic, strong) Airport *airport;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// load the points of the route from the data source, in this case
// a CSV file. 
-(void) loadRoute;
//-(void) loadRouteInFlight;


// use the computed _routeRect to zoom in on the route. 
-(void) zoomInOnRoute;


@end

