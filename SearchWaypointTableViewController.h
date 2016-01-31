//
//  SearchWaypointTableViewController.h
//  RIM
//
//  Created by Mikel on 25.03.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

@import UIKit;
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

@interface SearchWaypointTableViewController : UITableViewController {
    AppDelegate *MyDelegate;
    NSArray * arrAlternates;
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnDetails;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Escape *escapewpt;
//@property (nonatomic, strong) EscapeWaypoint *WPTescape;

@end
