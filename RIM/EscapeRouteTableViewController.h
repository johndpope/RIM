//
//  DetailViewController.h
//  NOTECHS
//
//  Created by Michael Gehringer on 19.06.12.
//  Copyright (c) 2012 Etihad Airways. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>


@interface EscapeRouteTableViewController: UITableViewController {
   
}

//@property (nonatomic, strong) NSMutableArray *arrBriefingItems;
@property (nonatomic, strong) IBOutlet UITableView *myTableview;
@property (nonatomic, strong) IBOutlet UILabel *lblcountEscape;

@end
