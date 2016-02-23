//
//  PCNTableViewController.m
//  RIM
//
//  Created by Mikel on 01.02.16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import "PCNTableViewController.h"

@interface PCNTableViewController ()

@end

@implementation PCNTableViewController
{
    NSArray *_pickerData;
    NSArray *_pickerDataAircraft;
    NSArray *_pickerDataWeight;
    
    NSMutableArray *arrAircraft;
    NSArray * arrPCNumbers;
    NSArray * arrRF;
    NSArray * arrABCD;
    NSArray * arrWXYZ;
    NSArray * arrTU;
    NSArray *arrRoot;
    NSArray *arrRigidMax;
    NSArray *arrRigidMin;
    NSArray *arrFlexibleMax;
    NSArray *arrFlexibleMin;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    arrAircraft = [[NSMutableArray alloc]init];
    arrRoot = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PCN" ofType:@"plist"]];
    int i;
    for (i=0; i<[arrRoot count]; i++) {
        [arrAircraft addObject:[[arrRoot objectAtIndex:i]valueForKeyPath:@"Name"]];
    }
    arrPCNumbers= [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    arrRF = [NSArray arrayWithObjects:@"R", @"F",nil];
    arrABCD = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", nil];
    arrWXYZ = [NSArray arrayWithObjects:@"W", @"X", @"Y", @"Z", nil];
    arrTU = [NSArray arrayWithObjects:@"T", @"U", nil];
    // Initialize Data
    _pickerDataAircraft = @[arrAircraft];
    _pickerData = @[@[@"ACN",@"PCN"],
                     arrPCNumbers,
                     arrPCNumbers,
                     arrRF,
                     arrABCD,
                     arrWXYZ,
                     arrTU];
    _pickerDataWeight = @[
                          arrPCNumbers,
                          arrPCNumbers,
                          arrPCNumbers,
                          arrPCNumbers,
                          arrPCNumbers,
                          arrPCNumbers];
    self.PCNPicker.dataSource = self;
    self.PCNPicker.delegate = self;
    self.PCNAircraft.dataSource = self;
    self.PCNAircraft.delegate = self;
    self.PCNWeight.dataSource = self;
    self.PCNWeight.delegate = self;
    [_PCNAircraft selectRow:0 inComponent:0 animated:YES];
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

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _PCNPicker) {
        return 7;
    }
    if (pickerView == _PCNWeight) {
        return 6;
    }
    if (pickerView == _PCNAircraft) {
        return 1;
    } else {
    return 1;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _PCNAircraft) {
        [self getDataForAircraft];
        
    }
    if (pickerView == _PCNPicker) {
        if (component ==3 || component == 4 || component ==5 || component == 6) {
        [self getDataForAircraft];
        }else{
            if (component == 1 || component == 2) {
                [self calcLimitingWeight];
                [_PCNPicker selectRow:1 inComponent:0 animated:YES];
            }
        }
    }
    if (pickerView == _PCNWeight) {
        [self calcACN];
        [_PCNPicker selectRow:0 inComponent:0 animated:YES];
    }
    
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if (pickerView == _PCNAircraft) {
        title = _pickerDataAircraft[component][row];
    }
    if (pickerView == _PCNPicker) {
        title = _pickerData[component][row];
    }
    if (pickerView == _PCNWeight) {
        title = _pickerDataWeight[component][row];
    }
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView == _PCNAircraft) {
        return 156 ;
    }
    if (pickerView == _PCNWeight) {
        return 30 ;
    }
    if (pickerView == _PCNPicker) {
    if (component == 1 || component == 2)
    {
        return 30 ;
    }
        if (component == 0 )
        {
            return 80 ;
        }
    else
    {
        return 50  ;
    }
    }else{
        return 50;
    }
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _PCNAircraft) {
        return [arrAircraft count];
    }
    if (pickerView == _PCNWeight) {
        return [arrPCNumbers count];
    }
    if (pickerView == _PCNPicker) {
    if (component == 0) {
        return 2;
    }
    if (component == 1) {
        return [arrPCNumbers count];
    }
    if (component == 2) {
        return [arrPCNumbers count];
    }
    if (component == 3) {
        return [arrRF count];
    }
    if (component == 4) {
        return [arrABCD count];
    }
    if (component == 5) {
        return [arrWXYZ count];
    }
    if (component == 6) {
        return [arrTU count];
    } else {
        return 1;
    }
    } else {
        return 1;
    }
}

-(void) getDataForAircraft
{
    arrRigidMax = [[NSArray alloc]init];
    NSString *strMaxWeight;
    NSString *strPavement;
    int i;
    for (i=0; i<[arrRoot count]; i++) {
        if ([[[arrRoot objectAtIndex:i]valueForKeyPath:@"Name"] isEqualToString:[arrAircraft objectAtIndex:[_PCNAircraft selectedRowInComponent:0]]]) {
            strMaxWeight = [[arrRoot objectAtIndex:i]valueForKeyPath:@"Max"];
            NSLog(@"Weight:%@", [[arrRoot objectAtIndex:i]valueForKeyPath:@"Max"]);
            NSDictionary *dictMAM = [[arrRoot objectAtIndex:i]valueForKey:@"MAM"];
            arrRigidMax = [dictMAM objectForKey:@"Rigid"];
            arrFlexibleMax = [dictMAM objectForKey:@"Flexible"];
            NSDictionary *dictOME = [[arrRoot objectAtIndex:i]valueForKey:@"OME"];
            arrRigidMin = [dictOME objectForKey:@"Rigid"];
            arrFlexibleMin = [dictOME objectForKey:@"Flexible"];
            if ([_PCNPicker selectedRowInComponent:3] == 0) {
                strPavement = [arrRigidMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
                NSLog(@"Rigid:%@", [arrRigidMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]]);
            }else{
                strPavement = [arrFlexibleMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
                NSLog(@"Rigid:%@", [arrFlexibleMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]]);
            }

            NSLog(@"Rigid:%@", [arrRigidMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]]);
            int i;
            NSInteger intLength = [strPavement length];
            for (i=0; i<intLength; i++) {
                NSInteger f = [[strPavement substringWithRange:NSMakeRange(i, 1)] integerValue];
                [_PCNPicker selectRow:f inComponent:i+1 animated:YES];
            }
            intLength = [strMaxWeight length];
            for (i=0; i<intLength; i++) {
                NSInteger f = [[strMaxWeight substringWithRange:NSMakeRange(i, 1)] integerValue];
                [_PCNWeight selectRow:f inComponent:i animated:YES];
            }
        }
    }
    strMaxWeight = [[NSString alloc] initWithFormat:@"%02li",[strMaxWeight integerValue]];
    [self fillLabels:strMaxWeight ACNNumber:strPavement];
}
-(void) fillLabels:(NSString*)strWeight ACNNumber:(NSString*)strACN
{
    self.lblACN.text = strACN;
    self.lblMAWNormal.text = [strWeight stringByAppendingString:@" kg"];
    if ([[arrABCD objectAtIndex:[_PCNPicker selectedRowInComponent:4]] isEqualToString:@"A"]) {
        self.lblPavementSubgrades.text = @"A - High";
    }
    if ([[arrABCD objectAtIndex:[_PCNPicker selectedRowInComponent:4]] isEqualToString:@"B"]) {
        self.lblPavementSubgrades.text = @"B - Medium";
    }
    if ([[arrABCD objectAtIndex:[_PCNPicker selectedRowInComponent:4]] isEqualToString:@"C"]) {
        self.lblPavementSubgrades.text = @"C - Low";
    }
    if ([[arrABCD objectAtIndex:[_PCNPicker selectedRowInComponent:4]] isEqualToString:@"D"]) {
        self.lblPavementSubgrades.text = @"D - Ultralow";
    }
    if ([[arrRF objectAtIndex:[_PCNPicker selectedRowInComponent:3]] isEqualToString:@"F"]) {
        self.lblPavementType.text = @"F - Flexible";
    }
    if ([[arrRF objectAtIndex:[_PCNPicker selectedRowInComponent:3]] isEqualToString:@"R"]) {
        self.lblPavementType.text = @"R - Rigid";
    }
    if ([[arrWXYZ objectAtIndex:[_PCNPicker selectedRowInComponent:5]] isEqualToString:@"W"]) {
        self.lblTirePressureCat.text = @"W - Unlimited, no pressure limit";
    }
    if ([[arrWXYZ objectAtIndex:[_PCNPicker selectedRowInComponent:5]] isEqualToString:@"X"]) {
        self.lblTirePressureCat.text = @"X - High, limited to 1.75MPa (254psi)";
    }
    if ([[arrWXYZ objectAtIndex:[_PCNPicker selectedRowInComponent:5]] isEqualToString:@"Y"]) {
        self.lblTirePressureCat.text = @"Y - Medium, limited to 1.25MPa (181psi)";
    }
    if ([[arrWXYZ objectAtIndex:[_PCNPicker selectedRowInComponent:5]] isEqualToString:@"Z"]) {
        self.lblTirePressureCat.text = @"Z - Low, limited to 0.5MPa (73psi)";
    }
    if ([[arrTU objectAtIndex:[_PCNPicker selectedRowInComponent:6]] isEqualToString:@"T"]) {
        self.lblPavementCalculationMethod.text = @"T - Technical Evaluation";
    }
    if ([[arrTU objectAtIndex:[_PCNPicker selectedRowInComponent:6]] isEqualToString:@"U"]) {
        self.lblPavementCalculationMethod.text = @"U - Using Aircraft Experience";
    }

}
-(void) calcLimitingWeight
    {
        NSString *strMaxWeight = [[arrRoot objectAtIndex:[_PCNAircraft selectedRowInComponent:0]]valueForKeyPath:@"Max"];
        NSString *strMinWeight = [[arrRoot objectAtIndex:[_PCNAircraft selectedRowInComponent:0]]valueForKeyPath:@"Min"];
        NSString *strACNMax;
        NSString *strACNMin;
        if ([_PCNPicker selectedRowInComponent:3] == 0) {
            strACNMax = [arrRigidMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
            strACNMin = [arrRigidMin objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
            NSLog(@"Rigid:%@", [arrRigidMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]]);
        }else{
            strACNMax = [arrFlexibleMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
            strACNMin = [arrFlexibleMin objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
            NSLog(@"Rigid:%@", [arrFlexibleMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]]);
        }
        int i;
        NSString * strActPCN = @"";
        for (i=0; i<2; i++) {
            strActPCN = [strActPCN stringByAppendingString:[NSString stringWithFormat:@"%ld", [_PCNPicker selectedRowInComponent:i+1]]];
        }
        NSLog(@"WeightMAX:%@", strMaxWeight);
        NSLog(@"WeightMIN:%@", strMinWeight);
        NSLog(@"ACNMAX:%@", strACNMax);
        NSLog(@"ACNMIN:%@", strACNMin);
        
        double dblActWeight = ((([strActPCN doubleValue]-[strACNMax doubleValue])/([strACNMax doubleValue]-[strACNMin doubleValue]))*([strMaxWeight doubleValue]-[strMinWeight doubleValue]))+[strMaxWeight doubleValue];
        if (dblActWeight > [strMaxWeight doubleValue]) {
            dblActWeight = [strMaxWeight doubleValue];
        }
        NSString *strLength = [[NSString alloc] initWithFormat:@"%06li",(long)dblActWeight];
        for (i=0; i<[strLength length]; i++) {
            NSInteger f = [[strLength substringWithRange:NSMakeRange(i, 1)] integerValue];
            [_PCNWeight selectRow:f inComponent:i animated:YES];
        }
        NSLog(@"ActWeight:%@", [[NSString alloc] initWithFormat:@"%06li",(long)dblActWeight]);
        [self fillLabels:[[NSString alloc] initWithFormat:@"%02li",(long)dblActWeight] ACNNumber:strActPCN];
    }

-(void) calcACN
{
    NSString *strMaxWeight = [[arrRoot objectAtIndex:[_PCNAircraft selectedRowInComponent:0]]valueForKeyPath:@"Max"];
    NSString *strMinWeight = [[arrRoot objectAtIndex:[_PCNAircraft selectedRowInComponent:0]]valueForKeyPath:@"Min"];
    NSString *strACNMax;
    NSString *strACNMin;
    if ([_PCNPicker selectedRowInComponent:3] == 0) {
        strACNMax = [arrRigidMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
        strACNMin = [arrRigidMin objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
        NSLog(@"Rigid:%@", [arrRigidMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]]);
    }else{
        strACNMax = [arrFlexibleMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
        strACNMin = [arrFlexibleMin objectAtIndex:[_PCNPicker selectedRowInComponent:4]];
        NSLog(@"Rigid:%@", [arrFlexibleMax objectAtIndex:[_PCNPicker selectedRowInComponent:4]]);
    }
    int i;
    NSString * strActWeight = @"";
    for (i=0; i< 6; i++) {
        strActWeight = [strActWeight stringByAppendingString:[NSString stringWithFormat:@"%ld", [_PCNWeight selectedRowInComponent:i]]];
        }
    NSLog(@"WeightMAX:%@", strMaxWeight);
    NSLog(@"WeightMIN:%@", strMinWeight);
    NSLog(@"WeightAct:%@", strActWeight);
    NSLog(@"ACNMAX:%@", strACNMax);
    NSLog(@"ACNMIN:%@", strACNMin);
    
    double dblACN = [strACNMax doubleValue]-(([strMaxWeight doubleValue]-[strActWeight doubleValue])/([strMaxWeight doubleValue]-[strMinWeight doubleValue]))* ([strACNMax doubleValue]-[strACNMin doubleValue]);
    NSString *strLength = [[NSString alloc] initWithFormat:@"%02li",(long)dblACN];
    for (i=0; i<[strLength length]; i++) {
        NSInteger f = [[strLength substringWithRange:NSMakeRange(i, 1)] integerValue];
        [_PCNPicker selectRow:f inComponent:i+1 animated:YES];
    }
    NSLog(@"ACN:%@", [[NSString alloc] initWithFormat:@"%02li",(long)dblACN]);
    [self fillLabels:strActWeight ACNNumber:[[NSString alloc] initWithFormat:@"%02li",(long)dblACN]];
}

@end
