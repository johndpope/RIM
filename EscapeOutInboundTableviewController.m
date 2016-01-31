//
//  EscapeOutInboundTableviewController.m
//  RIM
//
//  Created by Mikel on 15.04.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "EscapeOutInboundTableviewController.h"
#import "User.h"

@interface EscapeOutInboundTableviewController ()

@end

@implementation EscapeOutInboundTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    // Return the number of sections.
//    return 1;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    // Return the number of rows in the section.
//    return 0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger intRow = indexPath.row;
    NSInteger intSection = indexPath.section;
    switch (intSection) {
        case 0:
            switch (intRow){
                    
                case 0:
                    [User sharedUser].strDirection = @"OUTBOUND";
                    [User sharedUser].strAircraft = @"Narrowbody";
//                    [User sharedUser].strEntityName = @"EscapeWideOutbound";
                    [self performSegueWithIdentifier:@"segShowNarrowRegionList" sender:self];
                    break;
                case 1:
                    [User sharedUser].strDirection = @"INBOUND";
                    [User sharedUser].strAircraft = @"Narrowbody";
//                    [User sharedUser].strEntityName = @"EscapeWideInbound";
                    [self performSegueWithIdentifier:@"segShowNarrowRegionList" sender:self];
                    break;
                }
            break;
          case 1:
            switch (intRow){
                    
                case 0:
                    [User sharedUser].strDirection = @"OUTBOUND";
                    [User sharedUser].strAircraft = @"Widebody";
//                    [User sharedUser].strEntityName = @"EscapeWideOutbound";
                    [self performSegueWithIdentifier:@"segShowRegionList" sender:self];
                    break;
                case 1:
                    [User sharedUser].strDirection = @"INBOUND";
                    [User sharedUser].strAircraft = @"Widebody";
//                    [User sharedUser].strEntityName = @"EscapeWideInbound";
                    [self performSegueWithIdentifier:@"segShowRegionList" sender:self];
                    break;
            }
        default:
            break;
    }
//    switch (intRow){
//    
//         case 0:
//            [User sharedUser].strDirection = @"OUTBOUND";
//            [User sharedUser].strAircraft = @"Widebody";
//            [User sharedUser].strEntityName = @"EscapeWideOutbound";
//            [self performSegueWithIdentifier:@"segShowRegionList" sender:self];
//            break;
//         case 1:
//            [User sharedUser].strDirection = @"INBOUND";
//            [User sharedUser].strAircraft = @"Widebody";
//            [User sharedUser].strEntityName = @"EscapeWideInbound";
//            [self performSegueWithIdentifier:@"segShowRegionList" sender:self];
//            break;
//         case 2:
//            [User sharedUser].strDirection = @"OUTBOUND";
//            [User sharedUser].strAircraft = @"Narrowbody";
//            [User sharedUser].strEntityName = @"EscapeNarrowOutbound";
//            [self performSegueWithIdentifier:@"segShowRegionList" sender:self];
//            break;
//         case 3:
//            [User sharedUser].strDirection = @"INBOUND";
//            [User sharedUser].strAircraft = @"Narrowbody";
//            [User sharedUser].strEntityName = @"EscapeNarrowInbound";
//            [self performSegueWithIdentifier:@"segShowRegionList" sender:self];
//            break;
//         case 4:
//            [User sharedUser].strDirection = @"OUTBOUND";
//            [User sharedUser].strAircraft = @"Narrowbody";
//            [User sharedUser].strEntityName = @"EscapeNarrowOutbound";
//            [self performSegueWithIdentifier:@"segShowRegionList" sender:self];
//            break;
//         case 5:
//            [User sharedUser].strDirection = @"INBOUND";
//            [User sharedUser].strAircraft = @"Narrowbody";
//            [User sharedUser].strEntityName = @"EscapeNarrowInbound";
//            [self performSegueWithIdentifier:@"segShowRegionList" sender:self];
//            break;
//            
//    }
//      [self performSegueWithIdentifier:@"segShowEscapeList" sender:self];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end
