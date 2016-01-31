//
//  DelayTableViewController.h
//  RIM
//
//  Created by Michael Gehringer on 9/1/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "PopOverFDPDatePickerViewController.h"
#import "StartFDPTableViewController.h"

@interface DelayTableViewController : UITableViewController
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnReportTimetxt;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnReportTime;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

//- (IBAction)showDelayTimePicker:(id)sender;
- (IBAction)switchDelay:(id)sender;
- (void)enableActDelay;
- (IBAction)infoDelay:(id)sender;
@end
