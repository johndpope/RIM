//
//  DensityViewController.h
//  uplift
//
//  Created by Mikel on 5/14/14.
//  Copyright (c) 2014 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@class DensityViewController;

@protocol DensityViewControllerDelegate <NSObject>
 - (void) didUpdateData;
- (void)densityViewController:
(DensityViewController *)controller didSelectDensity:(NSString *)density;
@end

@interface DensityViewController : UITableViewController
@property (nonatomic, weak) id <DensityViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *density;

@end

