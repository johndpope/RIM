//
//  DensityPickerTableViewController.h
//  Fuel Index
//
//  Created by Mikel on 7/26/14.
//  Copyright (c) 2014 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DensityPickerDelegate <NSObject>
-(void)selectedDensity:(NSString *)newDensity;
@required
//-(void)selectedDensity:(UIColor *)newColor;
@end

@interface DensityPickerTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *densityNames;
@property (nonatomic, weak) id<DensityPickerDelegate> delegate;

@end
