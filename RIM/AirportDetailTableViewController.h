//
//  AirportDetailTableViewController.h
//  RIM
//
//  Created by Mikel on 03.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Airports.h"
#import "AppDelegate.h"
#import <QuickLook/QuickLook.h>


@interface AirportDetailTableViewController : UITableViewController
{
   NSArray * arrAlternates;
    AppDelegate *MyDelegate;

}
@property (weak) IBOutlet UITableViewCell *cellICAO;
@property (weak) IBOutlet UITableViewCell *cellIATA;
@property (weak) IBOutlet UITableViewCell *cellName;
@property (weak) IBOutlet UITableViewCell *cellCity;
@property (weak) IBOutlet UITableViewCell *cellCountry;
@property (weak) IBOutlet UITableViewCell *cellLatitude;
@property (weak) IBOutlet UITableViewCell *cellLongitude;
@property (weak) IBOutlet UITableViewCell *cellSunrise;
@property (weak) IBOutlet UITableViewCell *cellSunset;

@property (weak) IBOutlet UITableViewCell *cellElevation;
@property (weak) IBOutlet UITableViewCell *cellTimezone;
@property (weak) IBOutlet UITableViewCell *cellRFF;
@property (nonatomic, strong) Airports *airport;
@property (nonatomic, strong) IBOutlet UILabel *lblICAO;
@property (nonatomic, strong) IBOutlet UILabel *lblIATA;
@property (nonatomic, strong) IBOutlet UILabel *lblCITY;
@property (nonatomic, strong) IBOutlet UILabel *lblNAME;
@property (nonatomic, strong) IBOutlet UILabel *lblCoordinates;
@property (nonatomic, strong) IBOutlet UILabel *lblElevation;
@property (nonatomic, strong) IBOutlet UILabel *lblSunrise;
@property (nonatomic, strong) IBOutlet UILabel *lblTimezone;
@property (nonatomic, strong) IBOutlet UILabel *lbl32x;
@property (nonatomic, strong) IBOutlet UILabel *lbl332;
@property (nonatomic, strong) IBOutlet UILabel *lbl333;
@property (nonatomic, strong) IBOutlet UILabel *lbl345;
@property (nonatomic, strong) IBOutlet UILabel *lbl346;
@property (nonatomic, strong) IBOutlet UILabel *lbl350;
@property (nonatomic, strong) IBOutlet UILabel *lbl380;
@property (nonatomic, strong) IBOutlet UILabel *lbl777;
@property (nonatomic, strong) IBOutlet UILabel *lbl787;
- (IBAction)addToTripkit:(id)sender;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
