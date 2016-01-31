//
//  AirportbriefingTableViewController.h
//  RIM
//
//  Created by Michael Gehringer on 9/15/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//
#import "Airports.h"
#import "Fiddler.h"
#import "BAPrayerTimes.h"
#import "User.h"
#import "Airport.h"
#import <UIKit/UIKit.h>
#import "AirportLibraryTableViewController.h"
#import "AircraftPickerTableViewController.h"

@interface AirportbriefingTableViewController : UITableViewController <AircraftPickerDelegate, UIPopoverPresentationControllerDelegate>

{
    NSArray * arrAlternates;

}
@property (weak, nonatomic) IBOutlet UILabel *lblICAOIATA;
@property (weak, nonatomic) IBOutlet UILabel *lblElevation;
@property (weak, nonatomic) IBOutlet UILabel *lblCoordinates;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeZone;
@property (weak, nonatomic) IBOutlet UILabel *lblSRSS;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblRFF;
@property (weak, nonatomic) IBOutlet UILabel *lblPEG;
@property (weak, nonatomic) IBOutlet UILabel *lblCPldg;
@property (weak, nonatomic) IBOutlet UILabel *lblNotes;
@property (weak, nonatomic) IBOutlet UILabel *lblRFFNotes;

@property (nonatomic, retain) IBOutlet UITextView *txtViewMETAR;
@property (nonatomic, retain) IBOutlet UITextView *txtViewNOTAMS;
@property (nonatomic, retain) IBOutlet UITextView *txtViewNOTES;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcNOTAMS;
@property (nonatomic, retain) IBOutlet UITableViewCell *tblvcMETAR;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnAircraft;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnShowMap;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnBack;

@property (nonatomic, strong) AircraftPickerTableViewController *aircraftPicker;
@property (nonatomic, strong) UIPopoverController *aircraftPickerPopover;


@property (weak, nonatomic) IBOutlet UILabel *lblFajr;
@property (weak, nonatomic) IBOutlet UILabel *lblSunrise;
@property (weak, nonatomic) IBOutlet UILabel *lblDhur;
@property (weak, nonatomic) IBOutlet UILabel *lblAsr;
@property (weak, nonatomic) IBOutlet UILabel *lblMaghrib;
@property (weak, nonatomic) IBOutlet UILabel *lblIsha;

@property (nonatomic, strong) Airports *airport;
@property (nonatomic, strong) Airport *airportWX;
@property (nonatomic, strong) Airport *detairport;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(IBAction)chooseAircraftButtonTapped:(id)sender;

@end
