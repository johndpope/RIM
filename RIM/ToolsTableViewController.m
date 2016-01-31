//
//  ToolsTableViewController.m
//  RIM
//
//  Created by Mikel on 02.06.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "ToolsTableViewController.h"
#import "FuelUpliftViewController.h"
#import "FITableViewController.h"
#import "StartFDPTableViewController.h"
#import "DecoderTableViewController.h"
#import "User.h"

@interface ToolsTableViewController ()

@end

@implementation ToolsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
}
- (void) viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
    NSInteger intRow = indexPath.row;
    if (intRow == 4) {
        if ([[User sharedUser].arrayLog count] == 0) {
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    switch (row)
    {
        case 1:
        {
            StartFDPTableViewController *vc = [[UIStoryboard storyboardWithName:@"MaxFDP"
                                                                         bundle: nil] instantiateViewControllerWithIdentifier: @"MaxFDP"] ;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            FITableViewController *vc = [[UIStoryboard storyboardWithName:@"FuelIndex"
                                                                   bundle: nil] instantiateViewControllerWithIdentifier: @"FuelIndex"] ;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            
            FuelUpliftViewController *vc = [[UIStoryboard storyboardWithName:@"FuelUplift"
                                                                      bundle: nil] instantiateViewControllerWithIdentifier: @"FuelUplift"] ;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            
            DecoderTableViewController *vc = [[UIStoryboard storyboardWithName:@"ATCDecoder"
                                                                      bundle: nil] instantiateViewControllerWithIdentifier: @"ATCDecoder"] ;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:
        {
            
            DecoderTableViewController *vc = [[UIStoryboard storyboardWithName:@"MOTNE"
                                                                        bundle: nil] instantiateViewControllerWithIdentifier: @"MOTNE"] ;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }

    }
    
}

@end
