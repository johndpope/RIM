//
//  StartTableViewController.h
//  RIM
//
//  Created by Mikel on 19.04.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AircraftPickerTableViewController.h"
#import "FlightPlanPickerTableViewController.h"
#import "FlightplanPopUpViewController.h"
#import "User.h"
#include "pdf.h"
#import "OFPreadObject.h"
#import "objWPT.h"
#import "objLog.h"
#import "EscapeCell.h"
#import "OFPLogTableViewCell.h"
#import "AppDelegate.h"
#import "Escape.h"
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
#import <QuickLook/QuickLook.h>
#import "SDCoreDataController.h"
#import "ReaderViewController.h"
#import "EscapeWaypoint.h"
#import "Country.h"
#import "Airports.h"
#import "Airport.h"

@protocol WaypointPickerDelegate <NSObject>
-(void)selectedWaypoint:(NSString *)newWaypoint;
@required
@end
@interface StartTableViewController : UITableViewController <AircraftPickerDelegate, FlightPlanPickerDelegate,WaypointPickerDelegate, UIPopoverPresentationControllerDelegate>
{
    NSMutableArray *documents;
    UITableView *tableview;
    
}
@property (nonatomic, weak) id<WaypointPickerDelegate> delegate;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Escape *escapewpt;
@property (nonatomic, strong) Airports *airport;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) AircraftPickerTableViewController *aircraftPicker;
@property (nonatomic, strong) FlightPlanPickerTableViewController *flightplanPicker;
@property (nonatomic, strong) UIPopoverController *aircraftPickerPopover;
@property (nonatomic, strong) UIPopoverController *flightplanPickerPopover;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnAircraft;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnFlightplan;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnRefresh;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnInfo;
@property (strong, nonatomic) IBOutlet UIView *customHeader;

@property (strong, nonatomic) IBOutlet UITableViewCell *tvcLog;

@property (copy, nonatomic) void (^addDateCompletionBlock)(void);
+ (void) calculateSunriseSunset;
- (void) readtxtFile;
- (void) loadAlternates;
- (void) readWeather;
- (void) readNOTAMS;
- (void) getEnrouteAlternates;
- (void) loadEnrouteAlternatesPDF;
- (void) searchEscapeRoutes;
- (void) searchAirports;
- (IBAction)refreshButtonTouched:(id)sender;
-(IBAction)chooseAircraftButtonTapped:(id)sender;
@end
