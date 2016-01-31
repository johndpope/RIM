//
//  AirportImportantLinksTableViewController.h
//  RIM
//
//  Created by Mikel on 31.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Airports.h"

@interface AirportImportantLinksTableViewController : UITableViewController
{
    NSMutableArray *documents;
    UITableView *tableview;
}
@property (nonatomic, strong) Airports *airport;

@end
