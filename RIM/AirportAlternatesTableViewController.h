//
//  AirportAlternatesTableViewController.h
//  RIM
//
//  Created by Mikel on 12.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Airports.h"
#import "Airport.h"

@interface AirportAlternatesTableViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) Airports *airport;
@property (nonatomic, strong) Airport *airport;

@end
