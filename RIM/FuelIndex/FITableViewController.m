//
//  FITableViewController.m
//  FuelIndex
//
//  Created by Mikel on 12.02.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "FITableViewController.h"
//#import "HMIAPHelper.h"
//#import "IAPProduct.h"
#import "User.h"
@interface FITableViewController ()

@end

@implementation FITableViewController{
//NSArray * _products;
}
- (void)viewDidLoad {
        [super viewDidLoad];
    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:@"Fuel Index"];
//    [bar pushNavigationItem:item animated:YES];
//    self.navigationItem.topItem.title = @"title text";
    item.title = @"title text";
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.clearsSelectionOnViewWillAppear = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}
-(void)viewWillAppear:(BOOL)animated
{
//    [[User sharedUser].arrAirbusTypeA330 removeAllObjects];
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
//    return [[User sharedUser].arrAirbusTypeA330 count ];
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    FIAircraftTableViewCell *cell = (FIAircraftTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
////    cell.lblAircraft.text = [[User sharedUser].arrAirbusTypeA330 objectAtIndex:indexPath.row];
//    // Configure the cell...
//    
//    return cell;
//}

//-(void) fillupArray
//{
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.Mikelsoft.FuelIndex.A332"]) {
//        [[User sharedUser].arrAirbusTypeA330 addObject:@"A330-200"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.Mikelsoft.FuelIndex.A33F"]) {
//        [[User sharedUser].arrAirbusTypeA330 addObject:@"A330-200 Freighter with Center Tank"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.Mikelsoft.FuelIndex.A33Fx"]) {
//        [[User sharedUser].arrAirbusTypeA330 addObject:@"A330-200 Freighter without Center Tank"];
//    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.Mikelsoft.FuelIndex.A333"]) {
//        [[User sharedUser].arrAirbusTypeA330 addObject:@"A330-300"];
//    }
//    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);
//    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
   switch (row)
    {
        case 0:
            [self performSegueWithIdentifier:@"seqPushA332" sender:self];
        break;
        case 1:
            [self performSegueWithIdentifier:@"seqPushA33F" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"seqPushA33Fx" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"seqPushA333" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"seqPushA345" sender:self];
            break;
        case 5:
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
