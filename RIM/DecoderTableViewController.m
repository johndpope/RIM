//
//  DecoderTableViewController.m
//  RIM
//
//  Created by Michael Gehringer on 10/5/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//
#import "DecoderALTTableViewCell.h"
#import "DecoderATCTableViewCell.h"
#import "DecoderEquipmentTableViewCell.h"
#import "DecoderTableViewController.h"
#import "User.h"

@interface DecoderTableViewController ()
{
    NSString *strItem;
    NSMutableArray *arrEquipment;
    NSMutableArray *arrSurveillance;
    NSMutableArray *arrNavigation;
    NSString *strEquipment;
    NSString * strNAVEqu;
    int i;
}
@end

@implementation DecoderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    NSString *myText = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"fltpln.txt"] encoding:NSUTF8StringEncoding error:nil];
//    [User sharedUser].strATCFltpln = myText;
//    self.myTextView.text  = [User sharedUser].strATCFltpln;
    self.myTextView.text = myText;
    self.myAltTextView.text  = [User sharedUser].strAlt;
    NSArray *arrATCFltPln = [myText componentsSeparatedByString:@"/"];
    arrEquipment = [[NSMutableArray alloc]init];
    arrSurveillance = [[NSMutableArray alloc]init];
    arrNavigation = [[NSMutableArray alloc]init];
    strEquipment = [arrATCFltPln objectAtIndex:1];
    strItem = [strEquipment substringWithRange:NSMakeRange(0, 1)];
    
    if ([strItem isEqualToString:@"J"]) {
        [arrEquipment addObject:@"SUPER HEAVY"];
    }
    if ([strItem isEqualToString:@"M"]) {
        [arrEquipment addObject:@"MEDIUM"];
    }
    if ([strItem isEqualToString:@"H"]) {
        [arrEquipment addObject:@"HEAVY"];
    }
    if ([strItem isEqualToString:@"L"]) {
        [arrEquipment addObject:@"LIGHT"];
    }

    for (i=1; i < [strEquipment length]; i++) {
        strItem = [strEquipment substringWithRange:NSMakeRange(i, 1)];
        [self checkCat];
    }
    strEquipment = [arrATCFltPln objectAtIndex:2];

    NSArray *arrSurveilance = [strEquipment componentsSeparatedByString:@"-"];
    strEquipment = [arrSurveilance objectAtIndex:0];
    for (i=0; i < [strEquipment length]; i++) {
        
        strItem = [strEquipment substringWithRange:NSMakeRange(i, 1)];
        if ([strItem isEqualToString:@" "]) {
            break;
        }else {
            strItem = [strEquipment substringWithRange:NSMakeRange(i, 1)];
            [self checkSSR];
        }
    }
    arrATCFltPln = [myText componentsSeparatedByString:@"-"];
    strEquipment = [arrATCFltPln objectAtIndex:8];
    NSArray *arrNavEqu = [strEquipment componentsSeparatedByString:@"/"];
    strNAVEqu = [arrNavEqu objectAtIndex:1];
    
    strItem = [strNAVEqu substringWithRange:NSMakeRange(0, 1)];
    for (i=0; i < [strEquipment length]; i++) {
        strItem = [strEquipment substringWithRange:NSMakeRange(i, 1)];
        if ([strItem isEqualToString:@" "]) {
            break;
        }else {
            strItem = [strEquipment substringWithRange:NSMakeRange(i, 1)];
            [self checkNAV];
        }
    }
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
- (void) checkNAV
{
    if ([strItem isEqualToString:@"A"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"A1"]) {
        [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 10 (RNP 10)"]];
        }
    }
    if ([strItem isEqualToString:@"B"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"B1"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 5 all permitted sensors"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"B2"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 5 GNSS"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"B3"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 5 DME/DME"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"B4"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 5 VOR/DME"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"B5"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 5 INS or IRS"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"B6"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 5 LORANC"]];
        }
    }
    if ([strItem isEqualToString:@"C"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"C1"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 2 all permitted sensors"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"C2"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 2 GNSS"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"C3"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 2 DME/DME"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"C4"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 2 DME/DME/IRU"]];
        }
    }
    if ([strItem isEqualToString:@"D"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"D1"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 1 all permitted sensors"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"D2"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 1 GNSS"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"D3"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 1 DME/DME"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"D4"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNAV 1 DME/DME/IRU"]];
        }
    }
    if ([strItem isEqualToString:@"L"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"L1"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNP 4"]];
        }
    }
    if ([strItem isEqualToString:@"O"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"O1"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": Basic RNP 1 all permitted sensors"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"O2"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": Basic RNP 1 GNSS"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"O3"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": Basic RNP 1 DME/DME"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"O4"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": Basic RNP 1 DME/DME/IRU"]];
        }
    }
    if ([strItem isEqualToString:@"S"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"S1"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNP APCH"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"S2"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNP APCH with BARO-VNAV"]];
        }
    }
    if ([strItem isEqualToString:@"T"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"T1"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNP AR APCH with RF (special authorization required)"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"T2"]) {
            [arrNavigation addObject: [[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": RNP AR APCH without RF (special authorization required)"]];
        }
    }
}
-(void) checkSSR
{
    if ([strItem isEqualToString:@"A"]) {
        [arrSurveillance addObject: [strItem stringByAppendingString:@": Transponder - Mode A (4 digits -- 4096 codes)"]];
    }
    if ([strItem isEqualToString:@"C"]) {
        [arrSurveillance addObject: [strItem stringByAppendingString:@": Transponder - Mode A (4 digits -- 4096 codes) and Mode C"]];
    }
    if ([strItem isEqualToString:@"E"]) {
        [arrSurveillance addObject: [strItem stringByAppendingString:@": Transponder - Mode S including aircraft identification, pressure-altitude and extended squitter (ADS-B) capability"]];
    }
    if ([strItem isEqualToString:@"H"]) {
        [arrSurveillance addObject: [strItem stringByAppendingString:@": Transponder — Mode S, including aircraft identification, pressure-altitude and enhanced surveillance capability"]];
    }
    if ([strItem isEqualToString:@"I"]) {
        [arrSurveillance addObject: [strItem stringByAppendingString:@": Transponder — Mode S, including aircraft identification, but no pressure-altitude capability"]];
    }
    if ([strItem isEqualToString:@"L"]) {
        [arrSurveillance addObject: [strItem stringByAppendingString:@": Transponder — Mode S, including aircraft identification, pressure-altitude, extended squitter (ADS-B) and enhanced surveillance capability"]];
    }
    if ([strItem isEqualToString:@"P"]) {
        [arrSurveillance addObject: [strItem stringByAppendingString:@": Transponder — Mode S, including pressure-altitude, but no aircraft identification capability"]];
    }
    if ([strItem isEqualToString:@"S"]) {
        [arrSurveillance addObject: [strItem stringByAppendingString:@": Transponder — Mode S, including both pressure-altitude and aircraft identification capability"]];
    }
    if ([strItem isEqualToString:@"X"]) {
        [arrSurveillance addObject: [strItem stringByAppendingString:@": Transponder — Mode S with neither aircraft identification nor pressure-altitude capability"]];
    }
    if ([strItem isEqualToString:@"B"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"B1"]) {
            [arrSurveillance addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ADS-B with dedicated 1 090 MHz ADS-B “out” capability"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"B2"]) {
            [arrSurveillance addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ADS-B with dedicated 1 090 MHz ADS-B “out” and “in” capability"]];
        }
    }
    if ([strItem isEqualToString:@"U"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"U1"]) {
            [arrSurveillance addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ADS-B “out” capability using UAT"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"U2"]) {
            [arrSurveillance addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ADS-B “out” and “in” capability using UAT"]];
        }
    }
    if ([strItem isEqualToString:@"V"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"V1"]) {
            [arrSurveillance addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ADS-B “out” capability using VDL Mode 4"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"V2"]) {
            [arrSurveillance addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ADS-B “out” and “in” capability using VDL Mode 4"]];
        }
    }
    if ([strItem isEqualToString:@"D"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"D1"]) {
            [arrSurveillance addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ADS-C with FANS 1/A capabilities"]];
        }
    }
    if ([strItem isEqualToString:@"G"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"G1"]) {
            [arrSurveillance addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ADS-C with ATN capabilities"]];
        }
    }

    

}
-(void) checkCat
{
    if ([strItem isEqualToString:@"S"]) {
        [arrEquipment addObject: [strItem stringByAppendingString:@": Standard Equipment: VHF RTF, VOR & ILS"]];
    }
    if ([strItem isEqualToString:@"A"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": GBAS landing system"]];
    }
    if ([strItem isEqualToString:@"B"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": LPV (APV with SBAS)"]];
    }
    if ([strItem isEqualToString:@"C"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": LORAN C"]];
    }
    if ([strItem isEqualToString:@"D"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": DME"]];
    }
    if ([strItem isEqualToString:@"E"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"E1"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": FMC WPR ACARS"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"E2"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": D-FIS ACARS"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"E3"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": PDC ACARS"]];
        }
    }
    if ([strItem isEqualToString:@"F"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": ADF"]];
    }
    if ([strItem isEqualToString:@"G"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": GNSS"]];
    }
    if ([strItem isEqualToString:@"H"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": HF RTF"]];
    }
    if ([strItem isEqualToString:@"I"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": INERTIAL NAVIGATION"]];
    }
    if ([strItem isEqualToString:@"J"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"J1"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": CPDLC ATN VDL Mode 2"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"J2"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": CPDLC FANS 1/A HFDL"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"J3"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": CPDLC FANS 1/A VDL Mode 4"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"J4"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": CPDLC FANS 1/A VDL Mode 2"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"J5"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": CPDLC FANS 1/A VDL SATCOM (INMARSAT)"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"J6"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": CPDLC FANS 1/A VDL SATCOM (MTSAT)"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"J7"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": CPDLC FANS 1/A VDL SATCOM (Iridium)"]];
        }
    }
    if ([strItem isEqualToString:@"K"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": MLS"]];
    }
    if ([strItem isEqualToString:@"L"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": ILS"]];
    }
    if ([strItem isEqualToString:@"M"]) {
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"M1"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ATC RTF SATCOM (INMARSAT)"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"M2"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ATC RTF (MTSAT)"]];
        }
        if ([[strEquipment substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"M3"]) {
            [arrEquipment addObject:[[strEquipment substringWithRange:NSMakeRange(i, 2)] stringByAppendingString:@": ATC RTF (Iridium"]];
        }
    }
    if ([strItem isEqualToString:@"O"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": VOR"]];
    }
    if ([strItem isEqualToString:@"P"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": RESERVED FOR RCP"]];
    }
    if ([strItem isEqualToString:@"R"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": PBN approved"]];
    }
    if ([strItem isEqualToString:@"T"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": TACAN"]];
    }
    if ([strItem isEqualToString:@"U"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": UHF RTF"]];
    }
    if ([strItem isEqualToString:@"V"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": VHF RTF"]];
    }
    if ([strItem isEqualToString:@"W"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": RVSM approved"]];
    }
    if ([strItem isEqualToString:@"X"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": MNPS approved"]];
    }
    if ([strItem isEqualToString:@"Y"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": VHF with 8.33 kHZ channel spacing capability"]];
    }
    if ([strItem isEqualToString:@"Z"]) {
        [arrEquipment addObject:[strItem stringByAppendingString:@": Other equipment carried or other capabilities"]];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return [arrEquipment count];
    }
    if (section == 2) {
        return [arrSurveillance count];
    }
    if (section == 3) {
        return [arrNavigation count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 300;
    }
    else {
        return 55;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return @"ATC FlightPlan";
    }
    
    if(section == 1){
        return @"Wake turbulence category, Radio Communication, Navigation and Approach Aid Equipment and Capabilities";
    }
    if(section == 2){
        return @"Surveillance Equipment and Capabilities";
    }
    if(section == 3){
        return @"RNAV SPECIFICATIONS and RNP SPECIFICATIONS";
    }
    
    else
        return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *cellIdentifier = @"CellATC";
        DecoderATCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[DecoderATCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSString *myText = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"fltpln.txt"] encoding:NSUTF8StringEncoding error:nil];
        //    self.myTextView.text  = [User sharedUser].strATCFltpln;
        cell.myTextView.text = myText;
        
        return cell;
    }
    
//    if (indexPath.section == 1) {
//        NSString *cellIdentifier = @"CellAlt";
//        DecoderALTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        
//        if (cell == nil) {
//            cell = [[DecoderALTTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        }
//        cell.myTextView.text = [User sharedUser].strAlt;
//        return cell;
//    }
    if (indexPath.section == 1) {
        NSString *cellIdentifier = @"CellEquipment";
        DecoderEquipmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[DecoderEquipmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.lblEquipment.text = [arrEquipment objectAtIndex:indexPath.row];
        return cell;
        
        }
    if (indexPath.section == 2) {
            NSString *cellIdentifier = @"CellSurveillance";
            DecoderEquipmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[DecoderEquipmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.lblEquipment.text = [arrSurveillance objectAtIndex:indexPath.row];
            return cell;
            
        }
    if (indexPath.section == 3) {
        NSString *cellIdentifier = @"CellNavigation";
        DecoderEquipmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[DecoderEquipmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.lblEquipment.text = [arrNavigation objectAtIndex:indexPath.row];
        return cell;
        
    }

    
    return nil;
}


@end
