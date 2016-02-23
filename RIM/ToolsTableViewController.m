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
#import "PCNTableViewController.h"

@interface ToolsTableViewController ()

@end

@implementation ToolsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self applyBlurToView:self.view withEffectStyle:UIBlurEffectStyleDark andConstraints:YES];
//    self.tableView.backgroundColor = [UIColor clearColor];
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    [blurEffectView setFrame:self.view.bounds];
//    [self.view addSubview:blurEffectView];
//    
//    [blurEffectView.contentView addSubview:self.tableView];
//    [blurEffectView.contentView addSubview:self.titleLabel];
//    [blurEffectView.contentView addSubview:self.tableView];
//    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
}
- (void) viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
//    [self applyBlurToView:self.view withEffectStyle:UIBlurEffectStyleLight andConstraints:YES];

}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
//    [cell setBackgroundColor:[UIColor clearColor]]; /*#555555*/
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
- (UIView *)applyBlurToView:(UIView *)view withEffectStyle:(UIBlurEffectStyle)style andConstraints:(BOOL)addConstraints
{
    //only apply the blur if the user hasn't disabled transparency effects
    if(!UIAccessibilityIsReduceTransparencyEnabled())
    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = view.bounds;
        
        [view addSubview:blurEffectView];
        
        if(addConstraints)
        {
            //add auto layout constraints so that the blur fills the screen upon rotating device
            [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1
                                                              constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1
                                                              constant:0]];
        }
    }
    else
    {
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    
    return view;
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

        case 5:
        {
            
            PCNTableViewController *vc = [[UIStoryboard storyboardWithName:@"PCN"
                                                                        bundle: nil] instantiateViewControllerWithIdentifier: @"PCN"] ;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }

    }
    
}

@end
