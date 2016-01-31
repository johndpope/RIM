//
//  Library2TableViewController.h
//  RIM
//
//  Created by Mikel on 04.06.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Airports.h"

@interface AirportLibrary2TableViewController : UITableViewController
{
    NSMutableArray *directoryList;
    NSString *documentDirectoryPath;
}
@property (nonatomic, strong) Airports *airport;

@end
