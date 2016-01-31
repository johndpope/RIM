//
//  EscapeOutInboundTableviewController.m
//  RIM
//
//  Created by Mikel on 15.04.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "EscapeRegionsTableviewController.h"
#import "User.h"

@interface EscapeRegionsTableviewController ()

@end

@implementation EscapeRegionsTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [[[@"Escape Routes " stringByAppendingString:[User sharedUser].strAircraft] stringByAppendingString:@" "] stringByAppendingString:[User sharedUser].strDirection];
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
    if ([[User sharedUser].strAircraft isEqualToString:@"Widebody"]) {

    switch (intSection) {
        case 0:
            switch (intRow){
                case 0:
                    [User sharedUser].strWptRegion = @"Iran";
                    if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                        [User sharedUser].strEntityName = @"EscapeWideOutboundIran";
                    }
                    if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                        [User sharedUser].strEntityName = @"EscapeWideInboundIran";
                    }
                    [self performSegueWithIdentifier:@"segShowEscapeList" sender:self];
                    break;
            }
            break;
        case 1:
                    switch (intRow){
                        case 0:
                            [User sharedUser].strWptRegion = @"Middle East";
                            if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                                [User sharedUser].strEntityName = @"EscapeWideOutboundMiddleEast";
                            }
                            if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                                [User sharedUser].strEntityName = @"EscapeWideInboundMiddleEast";
                            }
                            [self performSegueWithIdentifier:@"segShowEscapeList" sender:self];
                            break;
                    }
            break;
        case 2:
                            switch (intRow){
                                case 0:
                                    [User sharedUser].strWptRegion = @"Europe";

                                    if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                                        [User sharedUser].strEntityName = @"EscapeWideOutboundEurope";
                                    }
                                    if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                                        [User sharedUser].strEntityName = @"EscapeWideInboundEurope";
                                    }
                                    [self performSegueWithIdentifier:@"segShowEscapeList" sender:self];
                                    break;
                            }
            break;
        case 3:
                                    switch (intRow){
                                        case 0:
                                            [User sharedUser].strWptRegion = @"Eurasia";

                                            if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                                                [User sharedUser].strEntityName = @"EscapeWideOutboundChina";
                                            }
                                            if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                                                [User sharedUser].strEntityName = @"EscapeWideInboundChina";
                                            }
                                            [self performSegueWithIdentifier:@"segShowEscapeList" sender:self];
                                            break;
                                    }
            break;
        case 4:
                                            switch (intRow){
                                                case 0:
                                                    [User sharedUser].strWptRegion = @"South East Asia";

                                                    if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                                                        [User sharedUser].strEntityName = @"EscapeWideOutboundSEAsia";
                                                    }
                                                    if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                                                        [User sharedUser].strEntityName = @"EscapeWideInboundSEAsia";
                                                    }
                                                    [self performSegueWithIdentifier:@"segShowEscapeList" sender:self];
                                                    break;
                                            }
            break;
        case 5:
                                                    switch (intRow){
                                                        case 0:
                                                            [User sharedUser].strWptRegion = @"Africa";

                                                            if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                                                                [User sharedUser].strEntityName = @"EscapeWideOutboundAfrica";
                                                            }
                                                            if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                                                                [User sharedUser].strEntityName = @"EscapeWideInboundAfrica";
                                                            }
                                                            [self performSegueWithIdentifier:@"segShowEscapeList" sender:self];
                                                            break;
                                                    }
            break;
        case 6:
                                                            switch (intRow){
                                                                case 0:
                                                                    [User sharedUser].strWptRegion = @"North America";

                                                                    if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                                                                        [User sharedUser].strEntityName = @"EscapeWideOutboundUSA";
                                                                    }
                                                                    if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                                                                        [User sharedUser].strEntityName = @"EscapeWideInboundUSA";
                                                                    }
                                                                    [self performSegueWithIdentifier:@"segShowEscapeList" sender:self];
                                                                    break;
                                                            }
            break;
    
                                                            }
    }
    if ([[User sharedUser].strAircraft isEqualToString:@"Narrowbody"]) {
        
        switch (intSection) {
            case 0:
                switch (intRow){
                    case 0:
                        [User sharedUser].strWptRegion = @"Iran";

                        if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowOutboundIran";
                        }
                        if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowInboundIran";
                        }
                        [self performSegueWithIdentifier:@"segShowNarrowEscapeList" sender:self];
                        break;
                }
                break;
            case 1:
                switch (intRow){
                    case 0:
                        [User sharedUser].strWptRegion = @"Middle East";

                        if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowOutboundMiddleEast";
                        }
                        if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowInboundMiddleEast";
                        }
                        [self performSegueWithIdentifier:@"segShowNarrowEscapeList" sender:self];
                        break;
                }
                break;
            case 2:
                switch (intRow){
                    case 0:
                        [User sharedUser].strWptRegion = @"Europe";

                        if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowOutboundEurope";
                        }
                        if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowInboundEurope";
                        }
                        [self performSegueWithIdentifier:@"segShowNarrowEscapeList" sender:self];
                        break;
                }
                break;
            case 3:
                switch (intRow){
                    case 0:
                        [User sharedUser].strWptRegion = @"Eurasia";

                        if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowOutboundChina";
                        }
                        if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowInboundChina";
                        }
                        [self performSegueWithIdentifier:@"segShowNarrowEscapeList" sender:self];
                        break;
                }
                break;
            case 4:
                switch (intRow){
                    case 0:
                        [User sharedUser].strWptRegion = @"Africa";

                        if ([[User sharedUser].strDirection isEqualToString:@"OUTBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowOutboundAfricaUSA";
                        }
                        if ([[User sharedUser].strDirection isEqualToString:@"INBOUND"]) {
                            [User sharedUser].strEntityName = @"EscapeNarrowInboundAfricaUSA";
                        }
                        [self performSegueWithIdentifier:@"segShowNarrowEscapeList" sender:self];
                        break;
                }
                break;
                
        }
    }


    
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
