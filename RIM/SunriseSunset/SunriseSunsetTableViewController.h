//
//  SunriseSunsetTableViewController.h
//  RIM
//
//  Created by Michael Gehringer on 8/11/15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SunriseFlightplanTableViewCell.h"
#import "SunriseOfpTableViewCell.h"
#import "SunrisePrayerTableViewCell.h"
#import "SunriseTableViewCell.h"
#import "Fiddler.h"
#import "DatePickerViewController.h"
#import "PopOverDatePickerViewController.h"
#import "MBProgressHUD.h"

@interface SunriseSunsetTableViewController : UITableViewController



@property (weak) IBOutlet UITableView *tblResults;
@property (weak) IBOutlet UIDatePicker *pcDatePicker;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnTakeOffTime;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnUpdate;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
//@property (nonatomic, strong) UIPopoverController *popoverController;

- (IBAction)switchAction:(id)sender;
@end
