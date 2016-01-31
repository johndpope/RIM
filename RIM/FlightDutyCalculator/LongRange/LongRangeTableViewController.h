//
//  LongRangeTableViewController.h
//  RIM
//
//  Created by Michael Gehringer on 9/1/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "PopOverFDPDatePickerViewController.h"
#import "StartFDPTableViewController.h"
#import "AKSegmentedControl.h"

@interface LongRangeTableViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource >
{
    
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnReportTimetxt;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnReportTime;
@property (nonatomic, retain) IBOutlet UIPickerView *datePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end
