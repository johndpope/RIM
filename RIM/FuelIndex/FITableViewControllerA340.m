//
//  FITableViewController.m
//  FuelIndex
//
//  Created by Mikel on 12.02.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "FITableViewControllerA340.h"
//#import "HMIAPHelper.h"
//#import "IAPProduct.h"
#import "User.h"
@interface FITableViewControllerA340 ()

@end

@implementation FITableViewControllerA340{
    NSArray * _products;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Fuel Index";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
//    [[User sharedUser].arrAirbusTypeA340 removeAllObjects];
//    [self fillupArray];
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    return [[User sharedUser].arrAirbusTypeA340 count];
    return 2;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FIAircraftTableViewCell *cell = (FIAircraftTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    
//    cell.lblAircraft.text = [[User sharedUser].arrAirbusTypeA340 objectAtIndex:indexPath.row];
//    // Configure the cell...
//    
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

//-(void) fillupArray
//{
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.Mikelsoft.FuelIndex.A345"]) {
//        [[User sharedUser].arrAirbusTypeA340 addObject:@"A340-500"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.Mikelsoft.FuelIndex.A346"]) {
//        [[User sharedUser].arrAirbusTypeA340 addObject:@"A340-600"];
//    }
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row)
    {
        case 0:
        [self performSegueWithIdentifier:@"seqPushA345" sender:self];
        break;
        case 1:
        [self performSegueWithIdentifier:@"seqPushA346" sender:self];
        break;
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
