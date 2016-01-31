//
//  EnrouteInfoTableViewController.h
//  RIM
//
//  Created by Mikel on 28.04.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnrouteInfoTableViewController : UITableViewController
@property (nonatomic, strong) IBOutlet UILabel *lblcountEscape;
@property (nonatomic, strong) IBOutlet UILabel *lblcountAirport;
@property (nonatomic, strong) IBOutlet UITableViewCell *tvcAirports;
@property (nonatomic, strong) IBOutlet UITableViewCell *tvcEscapes;

@end
