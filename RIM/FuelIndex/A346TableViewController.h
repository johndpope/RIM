//
//  A332TableViewController.h
//  Fuel Index
//
//  Created by Mikel on 06.08.14.
//  Copyright (c) 2014 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DensityPickerTableViewController.h"



@interface A346TableViewController : UITableViewController  <DensityPickerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) DensityPickerTableViewController *densityPicker;
@property (nonatomic, strong) UIPopoverController *densityPickerPopover;
@property (nonatomic, weak) IBOutlet UILabel *lblDensity;
@property (nonatomic, weak) IBOutlet UISlider *sldFuel;
@property (nonatomic, weak) IBOutlet UITextField *txtTotalFuel;
@property (nonatomic, weak) IBOutlet UITextField *txtOuterFuelLeft;
@property (nonatomic, weak) IBOutlet UITextField *txtOuterFuelRight;
@property (nonatomic, weak) IBOutlet UITextField *txtInnerFuelLeft1;
@property (nonatomic, weak) IBOutlet UITextField *txtInnerFuelLeft2;
@property (nonatomic, weak) IBOutlet UITextField *txtInnerFuelRight3;
@property (nonatomic, weak) IBOutlet UITextField *txtInnerFuelRight4;
@property (nonatomic, weak) IBOutlet UITextField *txtTrimFuel;
@property (nonatomic, weak) IBOutlet UITextField *txtCenterFuel;
@property (nonatomic, weak) IBOutlet UITextField *txtCenterRearFuel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnDensity;

@property (nonatomic, weak) IBOutlet UILabel *lblIndexOuterLeft;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexOuterRight;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerLeft1;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerRight3;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerLeft2;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerRight4;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexTrimTank;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexCenterTank;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerLeft1lbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerRight3lbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerLeft2lbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerRight4lbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexOuterLeftlbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexOuterRightlbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexTrimTanklbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexCenterTanklbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexCenterRearTank;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexCenterRearTanklbl;

@property (nonatomic, weak) IBOutlet UILabel *lblFuelIndex;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelOuterLeft;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelOuterRight;

@property (nonatomic, weak) IBOutlet UIProgressView *progFuelInnerLeft1;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelInnerLeft2;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelInnerRight3;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelInnerRight4;

@property (nonatomic, weak) IBOutlet UIProgressView *progFuelTrimTank;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelCenterTank;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelCenterRearTank;

@property (nonatomic, weak) IBOutlet UITextField *txtZFW;
@property (nonatomic, weak) IBOutlet UITextField *txtZFWIndex;
@property (nonatomic, weak) IBOutlet UITextField *txtGW;
@property (nonatomic, weak) IBOutlet UITextField *txtGWCG;
@property (nonatomic, weak) IBOutlet UITextField *txtTrim;
@property (nonatomic, weak) IBOutlet UILabel *lblTrim;

-(IBAction)chooseDensityButtonTapped:(id)sender;
-(IBAction)chooseFuelAmount:(id)sender;
-(IBAction)updatesldFuel:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)formatZFW:(id)sender;

@end
