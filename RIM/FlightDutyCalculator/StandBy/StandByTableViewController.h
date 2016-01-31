//
//  StandByTableViewController.h
//  RIM
//
//  Created by Michael Gehringer on 9/1/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "PopOverFDPDatePickerViewController.h"
#import "StartFDPTableViewController.h"

@interface StandByTableViewController : UITableViewController

@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnReportTimetxt;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnReportTime;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIButton *btnSBYTime;
@property (nonatomic, retain) IBOutlet UITextField *txtSBYTime;
@property (nonatomic, retain) IBOutlet UISwitch *swcStandby;
@property (nonatomic, retain) IBOutlet UISwitch *swcSBYRest;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcStandBy;
@property (nonatomic, strong) UIPopoverController *popoverController;

- (IBAction)switchStandby:(id)sender;

@end
