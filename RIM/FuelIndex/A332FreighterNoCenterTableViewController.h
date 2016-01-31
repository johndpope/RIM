//
//  A332TableViewController.h
//  Fuel Index
//
//  Created by Mikel on 19.12.14.
//  Copyright (c) 2014 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DensityPickerTableViewController.h"



@interface A332FreighterNoCenterTableViewController : UITableViewController  <DensityPickerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) DensityPickerTableViewController *densityPicker;
@property (nonatomic, strong) UIPopoverController *densityPickerPopover;
@property (nonatomic, weak) IBOutlet UILabel *lblDensity;
@property (nonatomic, weak) IBOutlet UISlider *sldFuel;
@property (nonatomic, weak) IBOutlet UITextField *txtTotalFuel;
@property (nonatomic, weak) IBOutlet UITextField *txtOuterFuelLeft;
@property (nonatomic, weak) IBOutlet UITextField *txtOuterFuelRight;
@property (nonatomic, weak) IBOutlet UITextField *txtInnerFuelLeft;
@property (nonatomic, weak) IBOutlet UITextField *txtInnerFuelRight;
@property (nonatomic, weak) IBOutlet UITextField *txtTrimFuel;
@property (nonatomic, weak) IBOutlet UITextField *txtCenterFuel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnDensity;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerLeft;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerRight;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexOuterLeft;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexOuterRight;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexTrimTank;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexCenterTank;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerLeftlbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexInnerRightlbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexOuterLeftlbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexOuterRightlbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexTrimTanklbl;
@property (nonatomic, weak) IBOutlet UILabel *lblIndexCenterTanklbl;
@property (nonatomic, weak) IBOutlet UILabel *lblFuelIndex;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelOuterLeft;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelOuterRight;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelInnerLeft;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelInnerRight;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelTrimTank;
@property (nonatomic, weak) IBOutlet UIProgressView *progFuelCenterTank;

@property (nonatomic, weak) IBOutlet UITextField *txtZFW;
@property (nonatomic, weak) IBOutlet UITextField *txtZFWIndex;
@property (nonatomic, weak) IBOutlet UITextField *txtGW;
@property (nonatomic, weak) IBOutlet UITextField *txtGWCG;
@property (nonatomic, weak) IBOutlet UITextField *txtTrim;


-(IBAction)chooseDensityButtonTapped:(id)sender;
-(IBAction)chooseFuelAmount:(id)sender;
-(IBAction)updatesldFuel:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)formatZFW:(id)sender;

@end
