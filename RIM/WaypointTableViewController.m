//
//  WaypointTableViewController.m
//  RIM
//
//  Created by Mikel on 24.01.16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import "WaypointTableViewController.h"

@interface WaypointTableViewController ()
{
    objLog *objLogWpt;
}
@end

@implementation WaypointTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    if ([super initWithStyle:style] != nil) {
////        [self loadDocuments];
//        //Make row selections persist.
//        self.clearsSelectionOnViewWillAppear = NO;
//        
//        //Calculate how tall the view should be by multiplying the individual row height
//        //by the total number of rows.
//        NSInteger rowsCount = [[User sharedUser].arrayLog count];
//        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
//        
//        //Calculate how wide the view should be by finding how wide each string is expected to be
//        CGFloat largestLabelWidth = 0;
//        for (NSString *WaypointName in [User sharedUser].arrayLog) {
//            //Checks size of text using the default font for UITableViewCell's textLabel.
//            //            CGSize labelSize = [densityName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
//            CGSize labelSize = [WaypointName sizeWithAttributes:
//                                @{NSFontAttributeName:
//                                      [UIFont systemFontOfSize:17]}];
//            if (labelSize.width > largestLabelWidth) {
//                largestLabelWidth = labelSize.width;
//            }
//        }
//        
//        //Add a little padding to the width
//        CGFloat popoverWidth = largestLabelWidth + 100;
//        
//        //Set the property to tell the popover container how big this view will be.
//        self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);
//    }
//    return self;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[User sharedUser].arrayLog count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    OFPLogTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexPath.row];
    if ([objLogWpt.strFL length]==0) {
        objLogWpt.strFL = @"";
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.lblnamewpt.text = objLogWpt.strWptName;
    cell.lblAirways.text = objLogWpt.strWptAirway;
    cell.lblLat.text = objLogWpt.strLat;
    cell.lblLon.text = objLogWpt.strLon;
    cell.lblMORA.text = objLogWpt.strMORA;
    cell.lblEET.text = objLogWpt.strCET;
    cell.lblSR.text = [objLogWpt.strSR substringWithRange:NSMakeRange(0, 2)];
    NSLog(@"%@",[objLogWpt.strSR substringWithRange:NSMakeRange(7, 3)]);
    NSInteger intISA = (([objLogWpt.strFL intValue]*0.2)-15) + [[objLogWpt.strSR substringWithRange:NSMakeRange(7, 3)] intValue];
    if (intISA > 0) {
        cell.lblTempWind.text = [[[[objLogWpt.strSR substringWithRange:NSMakeRange(2, 8)] stringByAppendingString:@"/"]stringByAppendingString:@"ISA+"] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)intISA]];
    }else{
        cell.lblTempWind.text = [[[[objLogWpt.strSR substringWithRange:NSMakeRange(2, 8)] stringByAppendingString:@"/"]stringByAppendingString:@"ISA"]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)intISA]];
    }
    
    if ([[objLogWpt.strSR substringWithRange:NSMakeRange(0, 2)] intValue] > 2) {
        cell.lblSR.textColor = [UIColor yellowColor];
    }
    if ([[objLogWpt.strSR substringWithRange:NSMakeRange(0, 2)] intValue] > 5) {
        cell.lblSR.textColor = [UIColor redColor];
    }
    if ([[objLogWpt.strSR substringWithRange:NSMakeRange(0, 2)] intValue] <= 2) {
        cell.lblSR.textColor = [UIColor greenColor];
    }
    
    if ([objLogWpt.strWptAirway containsString:@"FIR"] || [objLogWpt.strWptAirway containsString:@"UIR"] || [objLogWpt.strWptAirway containsString:@"UTA"] || [objLogWpt.strWptAirway containsString:@"OCEANIC"] || [objLogWpt.strWptAirway containsString:@"ENOB NORGE USSR"] || [objLogWpt.strWptAirway containsString:@"DOMESTIC"]) {
        cell.imgViewLog.image = [UIImage imageNamed:@"radio_tower-32.png"];
        cell.lblAirways.text = [[objLogWpt.strWptAirway stringByReplacingOccurrencesOfString:objLogWpt.strWptName
                                                                                  withString:@""] stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"FIR/UIR";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]; /*#c99e2d*/
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
        cell.lblFlightlevel.text = @"";
    }else{
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        if ([objLogWpt.strType isEqualToString:@"Escape"]) {
            cell.imgViewLog.image = [UIImage imageNamed:@"earth_element-red-32.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = YES;
            //        [cell setBackgroundColor:[UIColor redColor]];
            cell.lblPage.text = [[objLogWpt.strPage stringByAppendingString:@" / "]stringByAppendingString:objLogWpt.strChapter];
            cell.lblAlternates.text = objLogWpt.strAlternates;
            if ([objLogWpt.strFL length]!=0) {
                cell.lblFlightlevel.text = [@"FL" stringByAppendingString:objLogWpt.strFL];
            }else{
                cell.lblFlightlevel.text = @"";
            }
            cell.lblMORA.textColor = [UIColor redColor];
        }else{
            if ([objLogWpt.strMORA intValue] > 100 ) {
                cell.lblMORA.textColor = [UIColor redColor];
                cell.imgViewLog.image = [UIImage imageNamed:@"earth_element-red-32.png"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.userInteractionEnabled = YES;
                cell.lblPage.text = @"";
                cell.lblAlternates.text = objLogWpt.strAlternates;
                if ([objLogWpt.strFL length]!=0) {
                    cell.lblFlightlevel.text = [@"FL" stringByAppendingString:objLogWpt.strFL];
                }else{
                    cell.lblFlightlevel.text = @"";
                }
            }else{
                cell.lblMORA.textColor = [UIColor colorWithRed:0.365 green:1 blue:0.396 alpha:1]; /*#5dff65*/
                cell.imgViewLog.image = [UIImage imageNamed:@"earth_element-green-32.png"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.userInteractionEnabled = YES;
                cell.lblPage.text = @"";
                cell.lblAlternates.text = objLogWpt.strAlternates;
                if ([objLogWpt.strFL length]!=0) {
                    cell.lblFlightlevel.text = [@"FL" stringByAppendingString:objLogWpt.strFL];
                }else{
                    cell.lblFlightlevel.text = @"";
                }
            }
            if ([objLogWpt.strAlternates length] != 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.userInteractionEnabled = YES;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.userInteractionEnabled = NO;
                if ([objLogWpt.strLat length] == 0) {
                    cell.lblAlternates.text = @"";
                } else {
                    cell.lblAlternates.text = @"ETOPS";
                }
            }
        }}
    if ([objLogWpt.strType isEqualToString:@"ETOPS"] ) {
        
        cell.imgViewLog.image = [UIImage imageNamed:@"water_element-32.png"];
    }
    
    if ([objLogWpt.strWptName isEqualToString:@"Sunrise"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"sunrise-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Sun";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strWptName isEqualToString:@"Sunrise (2)"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"sunrise-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Sun";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strWptName isEqualToString:@"Sunset"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"sunset-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Sun";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strWptName isEqualToString:@"Sunset (2)"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"sunset-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Sun";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strType isEqualToString:@"Prayer"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"mosque-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Prayer";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strType isEqualToString:@"Prayer"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"mosque-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Prayer";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strType isEqualToString:@"Prayer"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"mosque-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Prayer";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strType isEqualToString:@"Prayer"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"mosque-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Prayer";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    
    if ([objLogWpt.strType isEqualToString:@"Airport"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"airplane-32.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
        cell.lblAirways.text = [[objLogWpt.strWptAirway stringByReplacingOccurrencesOfString:objLogWpt.strWptName
                                                                                  withString:@""] stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        cell.lblAlternates.text = objLogWpt.strAlternates;
        cell.lblFlightlevel.text = objLogWpt.strFL;
        
        double dblLatitude;
        dblLatitude = [objLogWpt.strLat intValue];
        if (dblLatitude >= 0) {
            cell.lblLat.text = [@"N" stringByAppendingString:objLogWpt.strLat];
        } else {
            dblLatitude = dblLatitude*-1;
            cell.lblLat.text = [@"S" stringByAppendingString:objLogWpt.strLat];
        }
        double dblLongitude;
        dblLongitude = [objLogWpt.strLon intValue];
        if (dblLongitude >= 0) {
            cell.lblLon.text = [@"E" stringByAppendingString:objLogWpt.strLon];
        } else {
            dblLongitude = dblLongitude*-1;
            cell.lblLon.text = [@"W" stringByAppendingString:objLogWpt.strLon];
        }
        cell.lblMORA.text = [objLogWpt.strMORA stringByAppendingString:@"ft"];
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]; /*#c99e2d*/
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    
    return cell;
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
