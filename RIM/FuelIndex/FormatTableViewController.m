//
//  FormatTableViewController.m
//  FuelIndex
//
//  Created by Mikel on 08.03.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "FormatTableViewController.h"

@interface FormatTableViewController ()

@end

@implementation FormatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
//    if (section==0) {
//        
//        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.opaque = NO;
//        
//        headerLabel.textColor = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1]; /*#007aff*/
//       
//        headerLabel.highlightedTextColor = [UIColor whiteColor];
//        headerLabel.font = [UIFont systemFontOfSize:17.f];
//        headerLabel.frame = CGRectMake(15.0, 5.0, 300.0, 25.0);
//        
//        // If you want to align the header text as centered
//        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//        
//        headerLabel.text = @"In-App Purchase"; // i.e. array element
//        [customView addSubview:headerLabel];
//        
//    }
    if (section==0) {
        
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        
        headerLabel.textColor = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1]; /*#007aff*/
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont systemFontOfSize: 17.f];
        headerLabel.frame = CGRectMake(15.0, 5.0, 300.0, 25.0);
        //        headerLabel.frame = CGRectMake(1,2,3,4);
        // If you want to align the header text as centered
        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
        
        headerLabel.text = @"Application Information"; // i.e. array element
        [customView addSubview:headerLabel];
        
    }
    if (section==1) {
        
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        
        headerLabel.textColor = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1]; /*#007aff*/
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont systemFontOfSize:17.f];
        headerLabel.frame = CGRectMake(18.0, 5.0, 300.0, 25.0);
        
        // If you want to align the header text as centered
        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
        
        headerLabel.text = @"Disclaimer"; // i.e. array element
        //        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 45.0)];
        [customView addSubview:headerLabel];
        
    }
    
    // create the button object
    
    return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40.0;
    } else {
        return 40.0;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10.0;
    } else {
        return 10.0;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 640.0, 44.0)];
    customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (section==(tableView.numberOfSections-1)) {
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        
        //        headerLabel.textColor = [UIColor colorWithRed:0.7803f green:0.6784f blue:0.4235f alpha:1.0];
        headerLabel.textColor = [UIColor blueColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont systemFontOfSize:13.f];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.frame = CGRectMake(0, 2.0, self.tableView.frame.size.width, 44.0);
        headerLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        // If you want to align the header text as centered
        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
        
        headerLabel.text = @""; // i.e. array element
        [customView addSubview:headerLabel];
        
    }
    return customView;
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
