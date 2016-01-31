//
//  WeightsViewController.h
//  uplift
//
//  Created by Michael Gehringer on 29.03.12.
//  Copyright (c) 2012 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@class WeightsViewController;

@protocol WeightsViewControllerDelegate <NSObject>
 - (void) didUpdateData;
- (void)weightsViewController:
(WeightsViewController *)controller didSelectWeight:(NSString *)weight;
@end

@interface WeightsViewController : UITableViewController 
@property (nonatomic, weak) id <WeightsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *weight;

@end
