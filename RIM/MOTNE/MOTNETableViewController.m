//
//  MOTNETableViewController.m
//  RIM
//
//  Created by Mikel on 30.01.16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import "MOTNETableViewController.h"

@interface MOTNETableViewController ()

@end

@implementation MOTNETableViewController
{
    NSArray *_pickerData;
    NSMutableArray * arrRWY;
    NSArray *arrRWYLRC;
    NSArray *arrDeposits;
    NSArray *arrContamination;
    NSMutableArray * arrDepthDeposit;
    NSMutableArray * arrFrictionCoeff;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    arrRWY = [[NSMutableArray alloc]init];
    arrRWYLRC = [[NSArray alloc]init];
    arrDepthDeposit = [[NSMutableArray alloc]init];
    arrFrictionCoeff = [[NSMutableArray alloc]init];
    int i;
    for (i=1; i<37; i++) {
        [arrRWY addObject: [[NSString alloc] initWithFormat:@"%02li",(long)i]];
    }
//    for (i=51; i<87; i++) {
//        [arrRWYL addObject: [[NSString alloc] initWithFormat:@"%02li",(long)i]];
//    }
    [arrRWY addObject: [[NSString alloc] initWithFormat:@"%02li",(long)88]];
    [arrRWY addObject: [[NSString alloc] initWithFormat:@"%02li",(long)99]];
    arrDeposits = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"/", nil];
    arrRWYLRC = [NSArray arrayWithObjects:@"/", @"L", @"R", @"C",nil];
    arrContamination = [NSArray arrayWithObjects:@"1", @"2", @"5", @"9", @"/", nil];
    
    for (i=0; i<91; i++) {
        [arrDepthDeposit addObject: [[NSString alloc] initWithFormat:@"%02li",(long)i]];
    }
    for (i=92; i<100;i++) {
        [arrDepthDeposit addObject: [[NSString alloc] initWithFormat:@"%02li",(long)i]];
    }
    [arrDepthDeposit addObject:@"//"];
    for (i=22; i<42; i++) {
        [arrFrictionCoeff addObject: [[NSString alloc] initWithFormat:@"%02li",(long)i]];
    }
    for (i=91; i<96; i++) {
        [arrFrictionCoeff addObject: [[NSString alloc] initWithFormat:@"%02li",(long)i]];
    }
    [arrFrictionCoeff addObject:@"99"];
    [arrFrictionCoeff addObject:@"//"];
    
    // Initialize Data
    _pickerData = @[ @[@"R"],
                     arrRWY,
                     arrRWYLRC,
                     arrDeposits,
                     arrContamination,
                     arrDepthDeposit,
                     arrFrictionCoeff];
    
    // Connect data
    self.MOTNEPicker.dataSource = self;
    self.MOTNEPicker.delegate = self;
    self.lblBrakingAction.text = @"";
    self.lblContamination.text = @"";
    self.lblDeposit.text = @"";
    self.lblDepthDeposit.text = @"";
    self.lblRWY.text = @"";

}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 7;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = _pickerData[component][row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 1;
    }
    if (component == 1) {
        return [arrRWY count];
    }
    if (component == 2) {
        return [arrRWYLRC count];
    }
    if (component == 3) {
        return [arrDeposits count];
    }
    if (component == 4) {
        return [arrContamination count];
    }
    if (component == 5) {
        return [arrDepthDeposit count];
    }
    if (component == 6) {
        return [arrFrictionCoeff count];
    }else{
        return _pickerData.count;
    }
}
// Capture the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([[arrRWY objectAtIndex:[self.MOTNEPicker selectedRowInComponent:1]]integerValue] == 88) {
        self.lblRWY.text = @"All Runways";
    }else
    if ([[arrRWY objectAtIndex:[self.MOTNEPicker selectedRowInComponent:1]]integerValue] == 99) {
        self.lblRWY.text = @"Repetition of last message due to missing new report";
    }else
    {
        self.lblRWY.text = [[@"" stringByAppendingString:[NSString stringWithFormat:@"%02li",[[arrRWY objectAtIndex:[self.MOTNEPicker selectedRowInComponent:1]]integerValue]]]stringByAppendingString:[arrRWYLRC objectAtIndex:[self.MOTNEPicker selectedRowInComponent:2]]];
    }
    if ([[NSString stringWithFormat:@"%@",[arrDeposits objectAtIndex:[self.MOTNEPicker selectedRowInComponent:3]]] isEqualToString:@"/"]) {
        self.lblDeposit.text = @"Type of deposit not reported";
    }else{
    switch ([[arrDeposits objectAtIndex:[self.MOTNEPicker selectedRowInComponent:3]]integerValue]) {
        case 0:
            self.lblDeposit.text = @"Clear and Dry";
            break;
        case 1:
            self.lblDeposit.text = @"Damp";
            break;
        case 2:
            self.lblDeposit.text = @"Wet or water patches";
            break;
        case 3:
            self.lblDeposit.text = @"Rime or frost (depth normally less than 1mm";
            break;
        case 4:
            self.lblDeposit.text = @"Dry snow";
            break;
        case 5:
            self.lblDeposit.text = @"Wet snow";
            break;
        case 6:
            self.lblDeposit.text = @"Slush";
            break;
        case 7:
            self.lblDeposit.text = @"Ice";
            break;
        case 8:
            self.lblDeposit.text = @"Compact or rolled snow";
            break;
        case 9:
            self.lblDeposit.text = @"Frozen ruts or ridges";
            break;
        default:
            break;
    }
    }
    if ([[NSString stringWithFormat:@"%@",[arrContamination objectAtIndex:[self.MOTNEPicker selectedRowInComponent:4]]] isEqualToString:@"/"]) {
        self.lblContamination.text = @"Not reported";
    }else{
        switch ([[arrContamination objectAtIndex:[self.MOTNEPicker selectedRowInComponent:4]]integerValue]) {
            case 1:
                self.lblContamination.text = @"<= 10%";
                break;
            case 2:
                self.lblContamination.text = @"11% - 25%";
                break;
            case 5:
                self.lblContamination.text = @"26% - 50%";
                break;
            case 9:
                self.lblContamination.text = @">= 50%";
                break;
            default:
                break;
        }
    }
    if ([[NSString stringWithFormat:@"%@",[arrDepthDeposit objectAtIndex:[self.MOTNEPicker selectedRowInComponent:5]]] isEqualToString:@"//"]) {
        self.lblDepthDeposit.text = @"Operationally not significant or not measurable";
    }else{
        switch ([[arrDepthDeposit objectAtIndex:[self.MOTNEPicker selectedRowInComponent:5]]integerValue]) {
            case 00:
                self.lblDepthDeposit.text = @"< 1mm";
                break;
            case 92:
                self.lblDepthDeposit.text = @"10cm";
                break;
            case 93:
                self.lblDepthDeposit.text = @"15cm";
                break;
            case 94:
                self.lblDepthDeposit.text = @"20cm";
                break;
            case 95:
                self.lblDepthDeposit.text = @"25cm";
                break;
            case 96:
                self.lblDepthDeposit.text = @"30cm";
                break;
            case 97:
                self.lblDepthDeposit.text = @"35cm";
                break;
            case 98:
                self.lblDepthDeposit.text = @"40cm or more";
                break;
            case 99:
                self.lblDepthDeposit.text = @"Runway not operational";
                break;
            default:
                break;
        }
        if ([[arrDepthDeposit objectAtIndex:[self.MOTNEPicker selectedRowInComponent:5]]integerValue] >= 1 && [[arrDepthDeposit objectAtIndex:[self.MOTNEPicker selectedRowInComponent:5]]integerValue] <= 90) {
            self.lblDepthDeposit.text = [[@"" stringByAppendingString:[NSString stringWithFormat:@"%@",[arrDepthDeposit objectAtIndex:[self.MOTNEPicker selectedRowInComponent:5]]]]stringByAppendingString:@"mm"];
        }
    }
    
    if ([[NSString stringWithFormat:@"%@",[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]] isEqualToString:@"//"]) {
        self.lblBrakingAction.text = @"Braking Action not reported";
    }else{
        if ([[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue] <= 25) {
            self.lblBrakingAction.text = @"POOR - 1";
        }
        if ([[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue] <= 29 && [[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue] >=26) {
            self.lblBrakingAction.text = @"Medium to Poor - 2";
        }
        if ([[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue] <= 35 && [[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue] >=30) {
            self.lblBrakingAction.text = @"Medium - 3";
        }
        if ([[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue] <= 39 && [[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue] >=36) {
            self.lblBrakingAction.text = @"Medium to Good - 4";
        }
        if ([[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue] >=40 && [[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue] <=42) {
            self.lblBrakingAction.text = @"Good - 5";
        }
        switch ([[arrFrictionCoeff objectAtIndex:[self.MOTNEPicker selectedRowInComponent:6]]integerValue]) {
            case 95:
                self.lblBrakingAction.text = @"Good - 5";
                break;
            case 94:
                self.lblBrakingAction.text = @"Good to Medium - 4";
                break;
            case 93:
                self.lblBrakingAction.text = @"Medium - 3";
                break;
            case 92:
                self.lblBrakingAction.text = @"Medium to Poor - 2";
                break;
            case 91:
                self.lblBrakingAction.text = @"POOR - 1";
                break;
            case 99:
                self.lblBrakingAction.text = @"Unreliable";
                break;
            default:
                break;
        }

    }
}



@end


