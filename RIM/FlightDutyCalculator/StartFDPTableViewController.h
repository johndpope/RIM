//
//  StartFDPTableViewController.h
//  RIM
//
//  Created by Michael Gehringer on 8/31/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopOverFDPDatePickerViewController.h"
#import "AKSegmentedControl.h"

@interface StartFDPTableViewController : UITableViewController
{
UIButton *ReportButton;
UIButton *btnLongRange;
UILabel *lblReportLCL;
UILabel *lblTimeZone;
UITextField *txtReportLCL;
UITextField *txtTimeZone;
NSDateFormatter *dateFormatter;
NSNumber *totalDays;
NSNumber *totalHours;
NSNumber *totalMinutes;
NSNumber *totalSeconds;
UISegmentedControl *segCrew;
UISegmentedControl *segBodyClock;
UISegmentedControl *segPrecRest;
UISegmentedControl *segLongRange;
UISegmentedControl *segSectors;
NSTimeZone *timeZone;
UITabBarItem *tabMaxFDP;
NSTimeInterval *starttime;
NSTimeInterval *endtime;
UITableViewCell *tblvcLongRange;
}
- (IBAction)enablePrecRest:(id)sender;
- (IBAction)enableSectors:(id)sender;
- (IBAction)showLongRange:(id)sender;
- (IBAction)segPilotsCabinCrew:(id)sender;
- (IBAction)segPreceedingRest:(id)sender;
- (IBAction)chooseSectorNumbers:(id)sender;
- (IBAction)infoCrew:(id)sender;
- (IBAction)infoAcclimatised:(id)sender;
- (IBAction)infoRestNonAcclimatised:(id)sender;
- (void) displayMaxFDPBatchvalue;
+ (void) calcLimitingFDP;

@property (nonatomic, retain) NSTimeZone *timeZone;
@property (nonatomic) NSTimeInterval *starttime;
@property (nonatomic) NSTimeInterval *endtime;
@property (nonatomic, retain) IBOutlet UIButton *ReportButton;
@property (nonatomic, retain) IBOutlet UIButton *btnLongRange;
@property (nonatomic, retain) IBOutlet UILabel *lblReportLCL;
@property (nonatomic, retain) IBOutlet UILabel *lblTimeZone;
@property (nonatomic, retain) IBOutlet UITextField *txtReportLCL;
@property (nonatomic, retain) IBOutlet UITextField *txtTimeZone;
@property (nonatomic, retain) IBOutlet UITextField *txtMaxPermittedFDP;
@property (nonatomic, retain) IBOutlet UITextField *txtFDPEndUTC;
@property (nonatomic, retain) IBOutlet UITextField *txtBasedON;
@property (nonatomic, retain) IBOutlet UITextField *txtStartsAt;
@property (nonatomic, retain) IBOutlet UITextField *txtMaxFDP;
@property (nonatomic, retain) IBOutlet UITextField *txtCorrectedBy;
@property (nonatomic, retain) IBOutlet UITextField *txtCorrections;

@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcLongRange;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcMaxPermittedFDP;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcFDPEnd;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcBasedOn;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcStartsAt;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcMaxFDP;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcCrorrectedBy;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcCorrections;







@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSNumber *totalDays;
@property (nonatomic, retain) NSNumber *totalHours;
@property (nonatomic, retain) NSNumber *totalMinutes;
@property (nonatomic, retain) NSNumber *totalSeconds;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segCrew;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segBodyClock;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segPrecRest;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segLongRange;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segSectors;
@property (nonatomic, retain) IBOutlet UITabBarItem *tabMaxFDP;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnReportTimetxt;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnReportTime;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@end
