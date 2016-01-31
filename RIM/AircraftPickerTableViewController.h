//
//  DensityPickerTableViewController.h
//  Fuel Index
//
//  Created by Mikel on 7/26/14.
//  Copyright (c) 2014 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AircraftPickerDelegate <NSObject>
-(void)selectedAircraft:(NSString *)newAircraft;
@required
//-(void)selectedDensity:(UIColor *)newColor;
@end

@interface AircraftPickerTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *aircraftNames;
@property (nonatomic, weak) id<AircraftPickerDelegate> delegate;

@end
