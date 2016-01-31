//
//  FlightPlanPickerTableViewController.h
//  RIM
//
//  Created by Mikel on 19.07.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol FlightPlanPickerDelegate <NSObject>
-(void)selectedFlightPlan:(NSString *)newFlightPlan;
@required
@end

@interface FlightPlanPickerTableViewController : UITableViewController
{
    NSMutableArray *documents;

}
@property (nonatomic, strong) NSMutableArray *aircraftNames;
@property (nonatomic, weak) id<FlightPlanPickerDelegate> delegate;
@end
