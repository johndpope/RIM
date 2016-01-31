//
//  FuelUpliftViewController.h
//  uplift
//
//  Created by Michael Gehringer on 22.03.12.
//  Copyright (c) 2012 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightsViewController.h"
#import "VolumesViewController.h"
#import "DensityViewController.h"
//#import "ReceiptsViewController.h"
//#import "Receipt.h"

@class FuelUpliftViewController;
@class Receipt;


@protocol FuelUpliftViewControllerDelegate <NSObject>


- (void)fuelUpliftViewController:(FuelUpliftViewController *)controller didAddReceipt:(Receipt *)receipt;

@end

@interface FuelUpliftViewController : UITableViewController <WeightsViewControllerDelegate, VolumesViewControllerDelegate,DensityViewControllerDelegate, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate>
{
    BOOL keyboardVisible;
    NSMutableArray* receipts;
    IBOutlet UISlider *sldDensity;
    IBOutlet UITextField *txtDensity;
    IBOutlet UILabel *lblDensity;
    IBOutlet UILabel *lblSGDecimal;
    UITextField *activeField;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, weak) id <FuelUpliftViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableViewCell *tblvcFuelRemaining;
@property (weak, nonatomic) IBOutlet UITableViewCell *tblvcFuelUpliftVolume;
@property (weak, nonatomic) IBOutlet UITableViewCell *tblvcDensity;

@property (weak, nonatomic) IBOutlet UITableViewCell *tblvcDepartureFuel;

@property (strong, nonatomic) IBOutlet UITextField *txtFuelRemaining;
@property (strong, nonatomic) IBOutlet UITextField *txtFuelUpliftVolume;
@property (strong, nonatomic) IBOutlet UITextField *txtDensity;
@property (strong, nonatomic) IBOutlet UISlider *sldDensity;
@property (strong, nonatomic) IBOutlet UILabel *lblDensity;
@property (strong, nonatomic) IBOutlet UILabel *lblSGDecimal;
@property (strong, nonatomic) IBOutlet UITextField *txtCalculatedUpliftWeight;
@property (strong, nonatomic) IBOutlet UITextField *txtTotalFuelCell;
@property (strong, nonatomic) IBOutlet UILabel *lblWeight5;
@property (strong, nonatomic) IBOutlet UITextField *txtDepartureFuelCell;
@property (strong, nonatomic) IBOutlet UITextField *txtDiscrepancy;
@property (strong, nonatomic) IBOutlet UILabel *lblWeight;
@property (strong, nonatomic) IBOutlet UILabel *lblWeight2;
@property (strong, nonatomic) IBOutlet UILabel *lblWeight3;
@property (strong, nonatomic) IBOutlet UILabel *lblWeight4;
@property (strong, nonatomic) IBOutlet UITabBarController *myTabBarController;
@property (strong, nonatomic) IBOutlet UITextField *txtDiscrepancyPerc;
@property (strong, nonatomic) IBOutlet UILabel *lblVolume;
@property (nonatomic, retain) IBOutlet UIPickerView *fuelPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *fuelPickerVolumeUplift;
@property (nonatomic, retain) IBOutlet UIPickerView *fuelPickerDensity;
@property (nonatomic, retain) IBOutlet UIPickerView *fuelPickerDeparture;

//@property (nonatomic, strong) UIViewController *popoverController;
@property (nonatomic, strong) UIPopoverController *popoverController;



- (IBAction)CalculateUplift:(id)sender;
- (IBAction)CalculateDiscrepancy:(id)sender;
- (IBAction)ResetReceipts:(id)sender;
- (IBAction)SetintVolume:(id)sender;
- (void)CalculateUplift;
- (void)CalculateDiscrepancy;
- (void)ResetReceipts;
- (void)applyPaddedFooter ;
- (IBAction)clearDensityField:(id)sender;
@end
