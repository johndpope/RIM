//
//  AirportBriefingViewController.h
//  RIM
//
//  Created by Michael Gehringer on 9/5/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Airports.h"
#import "Fiddler.h"
#import "BAPrayerTimes.h"
#import "User.h"


@interface AirportBriefingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblICAOIATA;
@property (weak, nonatomic) IBOutlet UILabel *lblElevation;
@property (weak, nonatomic) IBOutlet UILabel *lblCoordinates;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeZone;
@property (weak, nonatomic) IBOutlet UILabel *lblSRSS;
@property (weak, nonatomic) IBOutlet UILabel *lblPrayers;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblRFF;
@property (weak, nonatomic) IBOutlet UILabel *lblPEG;
@property (weak, nonatomic) IBOutlet UILabel *lblCPldg;





@property (weak, nonatomic) IBOutlet UILabel *lblFajr;
@property (weak, nonatomic) IBOutlet UILabel *lblSunrise;
@property (weak, nonatomic) IBOutlet UILabel *lblDhur;
@property (weak, nonatomic) IBOutlet UILabel *lblAsr;
@property (weak, nonatomic) IBOutlet UILabel *lblMaghrib;
@property (weak, nonatomic) IBOutlet UILabel *lblIsha;

@property (nonatomic, strong) Airports *airport;

@end
