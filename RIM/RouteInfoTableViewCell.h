//
//  RouteInfoTableViewCell.h
//  RIM
//
//  Created by Mikel on 28.04.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *lblcountEscape;
@property (nonatomic, strong) IBOutlet UILabel *lblDescription;
@property (nonatomic, strong) IBOutlet UILabel *lblWaypoints;

@end
