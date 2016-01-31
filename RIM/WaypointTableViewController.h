//
//  WaypointTableViewController.h
//  RIM
//
//  Created by Mikel on 24.01.16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "OFPLogTableViewCell.h"
#import "objLog.h"

@protocol WaypointPickerDelegate <NSObject>
-(void)selectedWaypoint:(NSString *)newWaypoint;
@required
@end

@interface WaypointTableViewController : UITableViewController


@property (nonatomic, weak) id<WaypointPickerDelegate> delegate;

@end
