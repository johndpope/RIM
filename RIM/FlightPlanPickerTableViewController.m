//
//  FlightPlanPickerTableViewController.m
//  RIM
//
//  Created by Mikel on 19.07.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "FlightPlanPickerTableViewController.h"

@interface FlightPlanPickerTableViewController ()

@end

@implementation FlightPlanPickerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil) {
        [self loadDocuments];
        //Make row selections persist.
        self.clearsSelectionOnViewWillAppear = NO;
        
        //Calculate how tall the view should be by multiplying the individual row height
        //by the total number of rows.
        NSInteger rowsCount = [documents count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        //Calculate how wide the view should be by finding how wide each string is expected to be
        CGFloat largestLabelWidth = 0;
        for (NSString *FlightPlanName in documents) {
            //Checks size of text using the default font for UITableViewCell's textLabel.
            //            CGSize labelSize = [densityName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            CGSize labelSize = [FlightPlanName sizeWithAttributes:
                                @{NSFontAttributeName:
                                      [UIFont systemFontOfSize:20]}];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        //Add a little padding to the width
        CGFloat popoverWidth = largestLabelWidth + 100;
        
        //Set the property to tell the popover container how big this view will be.
        self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);
    }
    return self;
}
- (void)loadDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/Inbox", documentsDirectory ];
    NSString *documentDirectoryPath = path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:documentDirectoryPath error:NULL];
    documents = [NSMutableArray arrayWithArray:files];
    NSLog(@"directories %@", files);
//    [[[[[self tabBarController] viewControllers] objectAtIndex: 0] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (unsigned long)[documents count]]];
//    if ([documents count] == 0) {
//        [[[[[self tabBarController] viewControllers] objectAtIndex: 0] tabBarItem] setBadgeValue:nil];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [documents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [documents objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedFlightPlanName = [documents objectAtIndex:indexPath.row];
    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate selectedFlightPlan:selectedFlightPlanName];
    }

    
}
- (void)applicationEnteredForeground:(NSNotification *)notification {
    NSLog(@"Application Entered Foreground");
    [self loadDocuments];
    [self.tableView reloadData];
}
- (void)appplicationIsActive:(NSNotification *)notification {
    NSLog(@"Application Did Become Active");
    [self loadDocuments];
    [self.tableView reloadData];

}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/Inbox", documentsDirectory ];
        NSString *appFile = [path stringByAppendingPathComponent:[documents objectAtIndex:indexPath.row]];
        [[NSFileManager defaultManager] removeItemAtPath:appFile error:nil];
        //        [self.tableView beginUpdates];
        //        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [documents removeObjectAtIndex:indexPath.row];
        //        [self.tableView endUpdates];
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //        [tableView reloadData];
        [[[[[self tabBarController] viewControllers] objectAtIndex: 0] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (unsigned long)[documents count]]];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([documents count] == 0) {
            [[[[[self tabBarController] viewControllers] objectAtIndex: 0] tabBarItem] setBadgeValue:nil];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


@end
