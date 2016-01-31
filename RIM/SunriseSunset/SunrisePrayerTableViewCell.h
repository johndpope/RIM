//
//  SunrisePrayerTableViewCell.h
//  RIM
//
//  Created by Michael Gehringer on 8/20/15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunrisePrayerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblnamewpt;
@property (weak, nonatomic) IBOutlet UILabel *lblLat;
@property (weak, nonatomic) IBOutlet UILabel *lblLon;
@property (weak, nonatomic) IBOutlet UILabel *lblPage;
@property (weak, nonatomic) IBOutlet UILabel *lblChapter;

@property (weak, nonatomic) IBOutlet UILabel *lblAirways;
@property (weak, nonatomic) IBOutlet UILabel *lblAlternates;
@property (weak, nonatomic) IBOutlet UILabel *lblupdatedAt;
@property (weak, nonatomic) IBOutlet UILabel *lblFlightlevel;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLog;
@property (weak, nonatomic) IBOutlet UILabel *lblMORA;
@property (weak, nonatomic) IBOutlet UILabel *lblEET;
@property (weak, nonatomic) IBOutlet UILabel *lblSR;
@property (weak, nonatomic) IBOutlet UILabel *lblTempWind;

@end
