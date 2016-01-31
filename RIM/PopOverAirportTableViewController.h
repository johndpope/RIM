//
//  PopOverAirportTableViewController.h
//  RIM
//
//  Created by Mikel on 29.07.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "os4MapsViewController.h"
#import "Airport.h"
#import "Airports.h"
#import "SDCoreDataController.h"

@interface PopOverAirportTableViewController : UITableViewController
{
    
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITextView *txtViewMETAR;
@property (nonatomic, retain) IBOutlet UITextView *txtViewNOTAMS;

@end
