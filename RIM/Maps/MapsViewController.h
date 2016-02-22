//
//  MapsViewController.h
//  RIM
//
//  Created by Jerald Abille on 2/22/16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WhirlyGlobeViewController.h>
#import "GlobeViewController.h"
#import "FlightPlanPickerTableViewController.h"
#import "StartTableViewController.h"

@interface MapsViewController : UIViewController <WhirlyGlobeViewControllerDelegate, FlightPlanPickerDelegate, UIPopoverPresentationControllerDelegate, WaypointPickerDelegate>

@property (nonatomic, strong) IBOutlet UIView *containerView;

@property (nonatomic, strong) GlobeViewController *globeVC;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) MaplyComponentObject *waypointsObj;
@property (strong, nonatomic) MaplyComponentObject *routesObj;
@property (strong, nonatomic) MaplyComponentObject *greatCircleObj;

@end
