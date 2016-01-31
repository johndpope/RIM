//
//  SunriseFlightplanTableViewCell.h
//  RIM
//
//  Created by Michael Gehringer on 8/20/15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunriseFlightplanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *txtTakeOffTime;
@property (weak, nonatomic) IBOutlet UILabel *lblFlightPlan;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLog;
@property (weak, nonatomic) IBOutlet UILabel *lblMORA;


@end
