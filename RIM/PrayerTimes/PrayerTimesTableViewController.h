//
//  PrayerTimesTableViewController.h
//  RIM
//
//  Created by Michael Gehringer on 8/25/15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAPrayerTimes.h"
#import "SunrisePrayerTableViewCell.h"
#import "AirportDetailTableViewController.h"
#import "User.h"
#import "Airports.h"
#import "Airport.h"

@interface PrayerTimesTableViewController : UITableViewController
@property (nonatomic, strong) Airports *airport;

@end
