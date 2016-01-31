//
//  A332TableViewController.m
//  Fuel Index
//
//  Created by Mikel on 19.12.14.
//  Copyright (c) 2014 Mikelsoft.com. All rights reserved.
//

#import "A332FreighterNoCenterTableViewController.h"


@interface A332FreighterNoCenterTableViewController ()

@end

@implementation A332FreighterNoCenterTableViewController

@synthesize btnDensity;

#pragma mark -
#pragma mark Constants

#define K 100
#define C 2500
#define CGa 25
#define LengthMAC 7.27
#define RefSta 33.1555
#define LEMAC 31.3380


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *expression;
    if (textField.tag == 1) {
        expression =@"^([0-9]*)(\\.([0-9]{0,1})?)?$"; //change this regular expression as your requirement
    } else
        expression = @"^[0-9]*$";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger noOfMatches = [regex numberOfMatchesInString:newStr
                                                    options:0
                                                      range:NSMakeRange(0, [newStr length])];
    if (noOfMatches==0){
        return NO;
    }
    return YES;
}

-(IBAction)formatZFWIndex:(id)sender
{
    
    NSLog(@"%2.1f", [self.txtZFWIndex.text doubleValue]);
    if ([self.txtZFWIndex.text intValue] > 160) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Index Limit exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtZFWIndex.text = @"100";
    }
    
    
}

-(IBAction)formatInnerLeft:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtInnerFuelLeft.text intValue] > ((41904*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtInnerFuelLeft.text = [[NSString alloc] initWithFormat:@"%li ", ((41904*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatInnerRight:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtInnerFuelRight.text intValue] > ((41904*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtInnerFuelRight.text = [[NSString alloc] initWithFormat:@"%li ", ((41904*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatOuterLeft:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtOuterFuelLeft.text intValue] > ((3624*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%li ", ((3624*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatOuterRight:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtOuterFuelRight.text intValue] > ((3624*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%li ", ((3624*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatCenter:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtCenterFuel.text intValue] > ((41560*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtCenterFuel.text = [[NSString alloc] initWithFormat:@"%li ", ((41560*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatTrim:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtTrimFuel.text intValue] > ((6230*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%li ", ((6230*intDensity)/1000)];
    }
    
    
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.btnDensity;
    self.navigationController.navigationBar.translucent = YES;
    self.lblDensity.hidden = NO;
    self.btnDensity.title = @"Choose Density";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A332.png"]];
    imageView.contentMode = UIViewContentModeCenter;
    self.tableView.backgroundView = imageView;
    self.txtTotalFuel.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    self.txtTotalFuel.delegate=self;
    self.lblIndexCenterTank.hidden = YES;
    self.lblIndexCenterTanklbl.hidden = YES;
    self.lblIndexInnerLeft.hidden = YES;
    self.lblIndexInnerLeftlbl.hidden = YES;
    self.lblIndexInnerRight.hidden = YES;
    self.lblIndexInnerRightlbl.hidden = YES;
    self.lblIndexOuterLeft.hidden = YES;
    self.lblIndexOuterLeftlbl.hidden = YES;
    self.lblIndexOuterRight.hidden = YES;
    self.lblIndexOuterRightlbl.hidden = YES;
    self.lblIndexTrimTank.hidden = YES;
    self.lblIndexTrimTanklbl.hidden = YES;
    
//    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
//    float fltDensity = intDensity/1000.0f;
//    double dblFuel = (76369/(fltDensity));
//    NSLog(@"%i", ([[[NSString alloc]initWithFormat:@"%f",dblFuel] intValue]));
//    self.sldFuel.maximumValue = ([[[NSString alloc]initWithFormat:@"%f",dblFuel] intValue]);
}
- (UIBarButtonItem *)btnDensity {
    if (!btnDensity) {
        btnDensity = [[UIBarButtonItem alloc] init];
        //configure the button here
    }
    return btnDensity;
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    barButtonItem.title = NSLocalizedString(@"Aircraft", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    //    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions
-(IBAction)chooseDensityButtonTapped:(id)sender
{
    if (_densityPicker == nil) {
        //Create the DensityPickerViewController.
        _densityPicker = [[DensityPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //Set this VC as the delegate.
        _densityPicker.delegate = self;
    }
    
    if (_densityPickerPopover == nil) {
        //The color picker popover is not showing. Show it.
        _densityPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_densityPicker];
        [_densityPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [_densityPickerPopover dismissPopoverAnimated:YES];
        _densityPickerPopover = nil;
    }
}
#pragma mark - DensityPickerDelegate method

-(void)selectedDensity:(NSString *)newDensity
{
    self.lblDensity.text = newDensity;
    
    //Dismiss the popover if it's showing.
    if (_densityPickerPopover) {
        [_densityPickerPopover dismissPopoverAnimated:YES];
        _densityPickerPopover = nil;
    }
//    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
//    float fltDensity = intDensity/1000.0f;
//    double dblFuel = (76369/(fltDensity));
//    NSLog(@"%i", ([[[NSString alloc]initWithFormat:@"%f",dblFuel] intValue]));
//    self.sldFuel.maximumValue = ([[[NSString alloc]initWithFormat:@"%f",dblFuel] intValue]);
    
    [self indexInnerTankLeft];
    [self indexInnerTankRight];
    [self indexOuterTankRight];
    [self indexOuterTankLeft];
    [self indexTrimTank];
    [self indexCenterTank];
    [self calculateIndex];
}
-(IBAction)CalcGW:(id)sender
{
    NSInteger intGW = [self.txtTotalFuel.text intValue] + [self.txtZFW.text intValue];
    self.txtGW.text = [[NSString alloc] initWithFormat:@"%ld ", intGW];
    [self CalcCG:self];
}
-(IBAction)CalcZFW:(id)sender
{
    NSInteger intZFW = [self.txtGW.text intValue] - [self.txtTotalFuel.text intValue];
    self.txtZFW.text = [[NSString alloc] initWithFormat:@"%ld ", intZFW];
}
-(IBAction)CalcFOB:(id)sender
{
    NSInteger intFOB = [self.txtGW.text intValue] - [self.txtZFW.text intValue];
    self.txtTotalFuel.text = [[NSString alloc] initWithFormat:@"%ld ", intFOB];
}
-(IBAction)CalcCG:(id)sender
{
    double intTotalIndex = [self.txtZFWIndex.text intValue]+[self.lblFuelIndex.text intValue];
    double intGW = [self.txtGW.text intValue];
    double intC = C;
    double intK = K;
    double intLEMAC = LEMAC;
    double intRefSta = RefSta;
    double intLengthMAC = LengthMAC;
    
    NSLog(@"%i ",[self.txtGW.text intValue]);
    NSLog(@"%i ",C);
    NSLog(@"%i ",K);
    NSLog(@"%f ",RefSta);
    NSLog(@"%f ",LEMAC);
    NSLog(@"%f ",LengthMAC);

    
    double intCG = (((intC*(intTotalIndex-intK))/intGW)+intRefSta-intLEMAC)/(intLengthMAC/100);
    
    self.txtGWCG.text = [[NSString alloc] initWithFormat:@"%2.1f ", intCG];
    [self calcTrimSet];
}
- (void) calcTrimSet
{
    double c = 9-(7.5 * (([self.txtGWCG.text doubleValue]-15)/23));
    if (c < 0) {
        self.txtTrim.text = [[[NSString alloc]initWithFormat:@"%2.2f", c] stringByAppendingString:@"° DN"];
    }
    else {
        self.txtTrim.text = [[[NSString alloc]initWithFormat:@"%2.2f", c] stringByAppendingString:@"° UP"];
    }
    
    if ([self.txtGWCG.text doubleValue] <= 15 && [self.txtGWCG.text doubleValue] <=15) {
        self.txtTrim.text = [[[NSString alloc]initWithFormat:@"%2.2f", 7.0] stringByAppendingString:@"° UP"];
    }
    else {
        if ([self.txtGWCG.text doubleValue] <= 40 && [self.txtGWCG.text doubleValue] >= 38) {
            self.txtTrim.text = [[[NSString alloc]initWithFormat:@"%2.2f", 0.0] stringByAppendingString:@"° UP"];
        }
    }
    if ([self.txtGWCG.text doubleValue] > 40 || [self.txtGWCG.text doubleValue] < 15) {
        self.txtTrim.text = @"XXXX";
    }
    
}

-(IBAction)formatZFW:(id)sender
{
    if ([self.txtZFW.text length] >= 6) {
        if ([self.txtZFW.text intValue] > 178000) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                              message:@"Max ZFW exceeded!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
            self.txtZFW.text = @"178000";
        }
    }
    
}

-(IBAction)updatesldFuel:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    NSLog(@"%@", self.txtTotalFuel.text);
    NSLog(@"%i", ([self.txtTotalFuel.text intValue]));
    double dblFuel = ((double)[self.txtTotalFuel.text intValue]/((double)intDensity/1000));
    self.sldFuel.value = [[[NSString alloc]initWithFormat:@"%f",dblFuel] intValue];
    NSLog(@"%i", ([[[NSString alloc]initWithFormat:@"%f",dblFuel] intValue]));
    
//    if ([self.navigationItem.title isEqualToString:@"Standard Fuel Distribution A33F w/o Center Tank"]) {
        [self chooseFuelAmount:self];
//    }
    
}

-(IBAction)nonStdFuel:(id)sender
{
//    self.navBarStandartFuel.topItem.title = @"Non Standard Fuel Distribution A330-200";
    [self.navigationItem setTitle:@"Non Standard Fuel Distribution A33F w/o Center Tank"];
    
    self.lblIndexCenterTank.hidden = NO;
    self.lblIndexCenterTanklbl.hidden = NO;
    self.lblIndexInnerLeft.hidden = NO;
    self.lblIndexInnerLeftlbl.hidden = NO;
    self.lblIndexInnerRight.hidden = NO;
    self.lblIndexInnerRightlbl.hidden = NO;
    self.lblIndexOuterLeft.hidden = NO;
    self.lblIndexOuterLeftlbl.hidden = NO;
    self.lblIndexOuterRight.hidden = NO;
    self.lblIndexOuterRightlbl.hidden = NO;
    self.lblIndexTrimTank.hidden = NO;
    self.lblIndexTrimTanklbl.hidden = NO;
    
    self.txtTotalFuel.textColor = [UIColor blackColor];
    self.txtOuterFuelLeft.textColor = [UIColor blackColor];
    self.txtOuterFuelRight.textColor = [UIColor blackColor];
    self.txtInnerFuelLeft.textColor = [UIColor blackColor];
    self.txtInnerFuelRight.textColor = [UIColor blackColor];
    self.txtCenterFuel.textColor = [UIColor blackColor];
    self.txtTrimFuel.textColor = [UIColor blackColor];
    //    self.btnDensity.title = @"Choose Density";
    NSInteger intTotalFuel = [self.txtInnerFuelLeft.text intValue]+[self.txtInnerFuelRight.text intValue]+[self.txtOuterFuelLeft.text intValue]+[self.txtOuterFuelRight.text intValue]+[self.txtCenterFuel.text intValue]+[self.txtTrimFuel.text intValue];
    self.txtTotalFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (long)intTotalFuel];
//    self.progTotalFuel.progress = (float)intTotalFuel/(float)76369;
    [self indexInnerTankLeft];
    [self indexInnerTankRight];
    [self indexOuterTankRight];
    [self indexOuterTankLeft];
    [self indexTrimTank];
    [self indexCenterTank];
    [self calculateIndex];
    [self updatesldFuelNonStandard:self];
    [self CalcGW:self];
}
-(IBAction)updatesldFuelNonStandard:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    NSLog(@"%@", self.txtTotalFuel.text);
    NSLog(@"%i", ([self.txtTotalFuel.text intValue]));
    double dblFuel = ((double)[self.txtTotalFuel.text intValue]/((double)intDensity/1000));
    self.sldFuel.value = [[[NSString alloc]initWithFormat:@"%f",dblFuel] intValue];
    NSLog(@"%i", ([[[NSString alloc]initWithFormat:@"%f",dblFuel] intValue]));
}


-(IBAction)chooseFuelAmount:(id)sender
{
    [self.navigationItem setTitle:@"Standard Fuel Distribution A33F w/o Center Tank"];
    self.txtTotalFuel.textColor = [UIColor darkGrayColor];
    self.txtOuterFuelLeft.textColor = [UIColor darkGrayColor];
    self.txtOuterFuelRight.textColor = [UIColor darkGrayColor];
    self.txtInnerFuelLeft.textColor = [UIColor darkGrayColor];
    self.txtInnerFuelRight.textColor = [UIColor darkGrayColor];
    self.txtCenterFuel.textColor = [UIColor darkGrayColor];
    self.txtTrimFuel.textColor = [UIColor darkGrayColor];
    
    self.lblIndexCenterTank.hidden = YES;
    self.lblIndexCenterTanklbl.hidden = YES;
    self.lblIndexInnerLeft.hidden = YES;
    self.lblIndexInnerLeftlbl.hidden = YES;
    self.lblIndexInnerRight.hidden = YES;
    self.lblIndexInnerRightlbl.hidden = YES;
    self.lblIndexOuterLeft.hidden = YES;
    self.lblIndexOuterLeftlbl.hidden = YES;
    self.lblIndexOuterRight.hidden = YES;
    self.lblIndexOuterRightlbl.hidden = YES;
    self.lblIndexTrimTank.hidden = YES;
    self.lblIndexTrimTanklbl.hidden = YES;

    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    self.txtTotalFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((int)self.sldFuel.value*intDensity)/1000)+1];
//    self.txtTotalFuel.text = [[NSString alloc] initWithFormat:@"%d ", (int)self.sldFuel.value];
    NSInteger intTotalFuel = [self.txtTotalFuel.text doubleValue];
    
    if (intTotalFuel <= 9000) { // INNERS
        self.txtInnerFuelLeft.text = [[NSString alloc] initWithFormat:@"%ld ", intTotalFuel/2];
        self.progFuelInnerLeft.progress = (float)intTotalFuel/2/(float)((42000*intDensity)/1000);
        self.txtInnerFuelRight.text = [[NSString alloc] initWithFormat:@"%ld ", intTotalFuel/2];
        self.progFuelInnerRight.progress = (float)intTotalFuel/2/(float)((42000*intDensity)/1000);
        self.txtOuterFuelLeft.text = @"0";
        self.progFuelOuterLeft.progress = 0;
        self.txtOuterFuelRight.text = @"0";
        self.progFuelOuterRight.progress = 0;
        self.txtCenterFuel.text = @"0";
        self.progFuelCenterTank.progress = 0;
        self.txtTrimFuel.text = @"0";
        self.progFuelTrimTank.progress = 0;
        
    } else if ( intTotalFuel > 9000 && intTotalFuel <= ((7300*intDensity)/1000)+9000) //OUTERS
    {
        self.txtInnerFuelLeft.text = [[NSString alloc] initWithFormat:@"%d ", 4500];
        self.progFuelInnerLeft.progress = (float)4500/(float)((42000*intDensity)/1000);
        self.txtInnerFuelRight.text = [[NSString alloc] initWithFormat:@"%d ", 4500];
        self.progFuelInnerRight.progress = (float)4500/(float)((42000*intDensity)/1000);
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%ld ", ((intTotalFuel-9000))/2];
        self.progFuelOuterLeft.progress = (float)((intTotalFuel-9000)/2)/(float)((3650*intDensity)/1000);
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%ld ", ((intTotalFuel-9000))/2];
        self.progFuelOuterRight.progress = (float)((intTotalFuel-9000)/2)/(float)((3650*intDensity)/1000);
        self.txtCenterFuel.text = @"0";
        self.progFuelCenterTank.progress = 0;
        self.txtTrimFuel.text = @"0";
        self.progFuelTrimTank.progress = 0;
    } else if ( intTotalFuel > ((7248*intDensity)/1000)+9000 && intTotalFuel <= ((7248*intDensity)/1000)+18300) // INNERS to 9150
    {
        self.txtInnerFuelLeft.text = [[NSString alloc] initWithFormat:@"%ld ", (intTotalFuel-(((3650*intDensity)/1000)*2))/2];
        self.progFuelInnerLeft.progress = (float)(intTotalFuel-5730)/2/(float)((42000*intDensity)/1000);
        self.txtInnerFuelRight.text = [[NSString alloc] initWithFormat:@"%ld ", (intTotalFuel-(((3650*intDensity)/1000)*2))/2];
        self.progFuelInnerRight.progress = (float)(intTotalFuel-5730)/2/(float)((42000*intDensity)/1000);
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%li ",((3650*intDensity)/1000)];
        self.progFuelOuterLeft.progress = 1;
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%li ",((3650*intDensity)/1000)];
        self.progFuelOuterRight.progress = 1;
        self.txtCenterFuel.text = @"0";
        self.progFuelCenterTank.progress = 0;
        self.txtTrimFuel.text = @"0";
        self.progFuelTrimTank.progress = 0;
    } else if ( intTotalFuel > ((7248*intDensity)/1000)+18300 && intTotalFuel <= ((7248*intDensity)/1000)+3600+18300) // TRIM TO 3600
    {
        self.txtInnerFuelLeft.text = [[NSString alloc] initWithFormat:@"%d ", 9150];
        self.progFuelInnerLeft.progress = (float)9150/(float)((32970*intDensity)/1000);
        self.txtInnerFuelRight.text = [[NSString alloc] initWithFormat:@"%d ", 9150];
        self.progFuelInnerRight.progress = (float)9150/(float)((32970*intDensity)/1000);
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%li ", ((3624*intDensity)/1000)];
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%li ", ((3624*intDensity)/1000)];
        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (intTotalFuel-(18300+(2*((3624*intDensity)/1000))))];
        self.progFuelTrimTank.progress = (float)(intTotalFuel-(18300+(2*((3624*intDensity)/1000))))/(float)((6230*intDensity)/1000);
        self.txtCenterFuel.text = @"0";
        self.progFuelCenterTank.progress = 0;
    } else if ( intTotalFuel > ((7248*intDensity)/1000)+3600+18300 && intTotalFuel <= ((7248*intDensity)/1000)+((83808*intDensity)/1000)+3600) // inner to full 41904ltrs
    {
        self.txtInnerFuelLeft.text = [[NSString alloc] initWithFormat:@"%ld ", (intTotalFuel-(((7300*intDensity)/1000)+3600))/2];
        self.progFuelInnerLeft.progress = (float)((intTotalFuel-(((7300*intDensity)/1000)+3200))/2)/(float)((32970*intDensity)/1000);
        NSLog(@"%f", (float)((intTotalFuel-(((7248*intDensity)/1000)+3600))/2)/(float)((32970*intDensity)/1000));
        self.txtInnerFuelRight.text = [[NSString alloc] initWithFormat:@"%ld ", (intTotalFuel-(((7248*intDensity)/1000)+3600))/2];
        self.progFuelInnerRight.progress = (float)((intTotalFuel-8130)/2)/(float)((32970*intDensity)/1000);
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%li ", ((3624*intDensity)/1000)];
        self.progFuelOuterLeft.progress = 1;
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%li ", ((3624*intDensity)/1000)];
        self.progFuelOuterRight.progress = 1;
        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%d ", 3600];
        self.progFuelTrimTank.progress = (float)3600/(float)((6230*intDensity)/1000);
        self.txtCenterFuel.text = @"0";
        self.progFuelCenterTank.progress = 0;
    } else if ( intTotalFuel > ((7248*intDensity)/1000)+((83808*intDensity)/1000)+3600 && intTotalFuel <= ((97286*intDensity)/1000)) // trim to full
    {
        self.txtInnerFuelLeft.text = [[NSString alloc] initWithFormat:@"%li ", ((41904*intDensity)/1000)];
        self.progFuelInnerLeft.progress = 1;
        self.txtInnerFuelRight.text = [[NSString alloc] initWithFormat:@"%li ", ((41904*intDensity)/1000)];
        self.progFuelInnerRight.progress = 1;
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%li ", ((3624*intDensity)/1000)];
        self.progFuelOuterLeft.progress = 1;
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%li ", ((3624*intDensity)/1000)];
        self.progFuelOuterRight.progress = 1;
        
        NSInteger intFueled = (((41904*intDensity)/1000)*2)+(((3624*intDensity)/1000)*2)+3600;
        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%1.0ld ", (((intTotalFuel-intFueled)))+3600];
        self.progFuelTrimTank.progress = (float)((((intTotalFuel-intFueled)))+3600)/(float)((6230*intDensity)/1000);
        
//        self.txtCenterFuel.text = [[NSString alloc] initWithFormat:@"%1.0f ",(intTotalFuel - intFueled) - ((intTotalFuel-intFueled)*3.805)/100];
//        NSInteger intfuelonboard = (((42000*intDensity)/1000)*2) + (((3650*intDensity)/1000)*2) + 3600;
//        self.progFuelCenterTank.progress = (float)((intTotalFuel - intfuelonboard) - ((intTotalFuel-intfuelonboard)*3.805)/100)/(float)((41560*intDensity)/1000);
    }
    [self indexInnerTankLeft];
    [self indexInnerTankRight];
    [self indexOuterTankRight];
    [self indexOuterTankLeft];
    [self indexTrimTank];
    [self indexCenterTank];
    [self calculateIndex];
}
-(void)calculateIndex
{
    NSInteger intIndex = [self.lblIndexInnerLeft.text intValue]+[self.lblIndexInnerRight.text intValue]+[self.lblIndexOuterRight.text intValue]+[self.lblIndexOuterLeft.text intValue]+[self.lblIndexCenterTank.text intValue]+[self.lblIndexTrimTank.text intValue];
    self.lblFuelIndex.text = [[NSString alloc] initWithFormat:@"%1.0ld",(long)intIndex];
    if ([self.lblFuelIndex.text isEqualToString:@" "]) {
        self.lblFuelIndex.text = @"0";
    }

}
-(void)indexInnerTankLeft
{
    NSInteger intInnerFuel = [self.txtInnerFuelLeft.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intInnerFuel==0) {
        self.lblIndexInnerLeft.text = @"0";
    }else if (intInnerFuel<=1000) {
        self.lblIndexInnerLeft.text = @"-1";
    } else if (intInnerFuel<=2000) {
        self.lblIndexInnerLeft.text = @"-2";
    } else if (intInnerFuel<=3000) {
        self.lblIndexInnerLeft.text = @"-3";
    } else if (intInnerFuel<=4000) {
        self.lblIndexInnerLeft.text = @"-4";
    } else if (intInnerFuel<=5000) {
        self.lblIndexInnerLeft.text = @"-5";
    } else if (intInnerFuel<=6000) {
        self.lblIndexInnerLeft.text = @"-6";
    } else if (intInnerFuel<=7000) {
        self.lblIndexInnerLeft.text = @"-7";
    } else if (intInnerFuel<=8000) {
        self.lblIndexInnerLeft.text = @"-8";
    } else if (intInnerFuel<=9000) {
        self.lblIndexInnerLeft.text = @"-9";
    } else if (intInnerFuel<=10000) {
        self.lblIndexInnerLeft.text = @"-10";
    } else if (intInnerFuel<=11000) {
        self.lblIndexInnerLeft.text = @"-11";
    } else if (intInnerFuel<=12000) {
        self.lblIndexInnerLeft.text = @"-12";
    } else if (intInnerFuel<=13000) {
        self.lblIndexInnerLeft.text = @"-13";
    } else if (intInnerFuel<=14000) {
        self.lblIndexInnerLeft.text = @"-13";
    } else if (intInnerFuel<=15000) {
        self.lblIndexInnerLeft.text = @"-14";
    } else if (intInnerFuel<=16000) {
        self.lblIndexInnerLeft.text = @"-15";
    } else if (intInnerFuel<=17000) {
        self.lblIndexInnerLeft.text = @"-16";
    } else if (intInnerFuel<=18000) {
        if (intDensity <= 760) {
            self.lblIndexInnerLeft.text = @"-16";
        } else {
            self.lblIndexInnerLeft.text = @"-17";
        }
    } else if (intInnerFuel<=19000) {
        if (intDensity >= 825) {
            self.lblIndexInnerLeft.text = @"-18";
        } else {
            self.lblIndexInnerLeft.text = @"-17";
        }
    } else if (intInnerFuel<=20000) {
        self.lblIndexInnerLeft.text = @"-18";
    } else if (intInnerFuel<=21000) {
        if (intDensity >= 790) {
            self.lblIndexInnerLeft.text = @"-19";
        } else {
            self.lblIndexInnerLeft.text = @"-18";
        }
    } else if (intInnerFuel<=22000) {
        self.lblIndexInnerLeft.text = @"-19";
    } else if (intInnerFuel<=23000) {
        if (intDensity >= 805) {
            self.lblIndexInnerLeft.text = @"-20";
        } else {
            self.lblIndexInnerLeft.text = @"-19";
        }
    } else if (intInnerFuel<=24000) {
        if (intDensity >= 790) {
            self.lblIndexInnerLeft.text = @"-20";
        } else {
            self.lblIndexInnerLeft.text = @"-19";
        }
    } else if (intInnerFuel<=25000) {
        if (intDensity >= 785) {
            self.lblIndexInnerLeft.text = @"-20";
            if (intDensity >= 830) {
                self.lblIndexInnerLeft.text = @"-21";
            }
        } else {
            self.lblIndexInnerLeft.text = @"-19";
        }
    } else if (intInnerFuel<=26000) {
        if (intDensity >= 790) {
            self.lblIndexInnerLeft.text = @"-20";
            if (intDensity >= 825) {
                self.lblIndexInnerLeft.text = @"-21";
            }
        } else {
            self.lblIndexInnerLeft.text = @"-19";
        }
    } else if (intInnerFuel<=27000) {
        if (intDensity <= 760) {
            self.lblIndexInnerLeft.text = @"-18";
        } else if (intDensity >= 795) {
            self.lblIndexInnerLeft.text = @"-20";
            if (intDensity >= 830) {
                self.lblIndexInnerLeft.text = @"-21";
            }
        } else {
            self.lblIndexInnerLeft.text = @"-19";
        }
    } else if (intInnerFuel<=28000) {
        if (intDensity <= 770) {
            self.lblIndexInnerLeft.text = @"-18";
        } else if (intDensity >= 800) {
            self.lblIndexInnerLeft.text = @"-20";
        } else {
            self.lblIndexInnerLeft.text = @"-19";
        }
    } else if (intInnerFuel<=29000) {
        if (intDensity <= 760) {
            self.lblIndexInnerLeft.text = @"-17";
        } else if (intDensity >= 790) {
            self.lblIndexInnerLeft.text = @"-19";
            if (intDensity >= 810) {
                self.lblIndexInnerLeft.text = @"-20";
            }
        } else {
            self.lblIndexInnerLeft.text = @"-18";
        }
    } else if (intInnerFuel<=30000) {
        if (intDensity <= 775) {
            self.lblIndexInnerLeft.text = @"-17";
        } else if (intDensity >= 800) {
            self.lblIndexInnerLeft.text = @"-19";
            if (intDensity >= 825) {
                self.lblIndexInnerLeft.text = @"-20";
            }
        } else {
            self.lblIndexInnerLeft.text = @"-18";
        }
    } else if (intInnerFuel<=31000) {
        if (intDensity <= 775) {
            self.lblIndexInnerLeft.text = @"-16";
        } else if (intDensity >= 795) {
            self.lblIndexInnerLeft.text = @"-18";
            if (intDensity >= 815) {
                self.lblIndexInnerLeft.text = @"-19";
            }
        } else {
            self.lblIndexInnerLeft.text = @"-17";
        }
        
    } else if (intInnerFuel<=32000) {
        if (intDensity <= 775) {
            if (intDensity <= 760) {
                self.lblIndexInnerLeft.text = @"-14";
            } else {
                self.lblIndexInnerLeft.text = @"-15";
            }
        } else if (intDensity >= 795) {
            self.lblIndexInnerLeft.text = @"-17";
            if (intDensity >= 810) {
                self.lblIndexInnerLeft.text = @"-18";
            }
            if (intDensity >= 830) {
                self.lblIndexInnerLeft.text = @"-19";
            }
        } else {
            self.lblIndexInnerLeft.text = @"-16";
        }
    } else if (intInnerFuel<=33000) {
        if (intDensity <= 790) {
            if (intDensity <= 760) {
                self.lblIndexInnerLeft.text = @"-14";
            } else {
                self.lblIndexInnerLeft.text = @"-15";
            }
        } else if (intDensity >= 810) {
            self.lblIndexInnerLeft.text = @"-17";
            if (intDensity >= 825) {
                self.lblIndexInnerLeft.text = @"-18";
            }
        } else {
            self.lblIndexInnerLeft.text = @"-16";
        }
        
    } else if (intInnerFuel<=34000) {
        if (intDensity <= 790) {
            if (intDensity <= 760) {
                self.lblIndexInnerLeft.text = @"-14";
            } else {
                self.lblIndexInnerLeft.text = @"-15";
            }
        } else if (intDensity >= 810) {
            self.lblIndexInnerLeft.text = @"-17";
            if (intDensity >= 825) {
                self.lblIndexInnerLeft.text = @"-18";
            }
        } else {
            self.lblIndexInnerLeft.text = @"-16";
        }
    }
//    if ([self.txtInnerFuelLeft.text intValue] > (42000*intDensity)/1000) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Attention!"
//                              message:@"Max Tank Capacity Left Inner Tank reached!"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//        self.txtInnerFuelLeft.text = [[NSString alloc] initWithFormat:@"%ld ", (long)(42000*intDensity)/1000];
//    }
    self.progFuelInnerLeft.progress = (float)intInnerFuel/(float)((41904*intDensity)/1000);
    NSLog(@"%f", (float)intInnerFuel/(float)((41904*intDensity)/1000));
}
-(void)indexOuterTankRight
{
    NSInteger intOuterFuel = [self.txtOuterFuelRight.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intOuterFuel==0) {
        self.lblIndexOuterRight.text = @"0";
    } else if (intOuterFuel<=200) {
        self.lblIndexOuterRight.text = @"0";
    } else if (intOuterFuel<=800) {
        self.lblIndexOuterRight.text = @"+1";
    } else if (intOuterFuel<=1300) {
        self.lblIndexOuterRight.text = @"+2";
    } else if (intOuterFuel<=1700) {
        self.lblIndexOuterRight.text = @"+3";
    } else if (intOuterFuel<=1800) {
        if (intDensity <= 785) {
            self.lblIndexOuterRight.text = @"+3";
        } else {
            self.lblIndexOuterRight.text = @"+4";
        }
    } else if (intOuterFuel<=2200) {
        self.lblIndexOuterRight.text = @"+4";
    } else if (intOuterFuel<=2500) {
        self.lblIndexOuterRight.text = @"+5";
    } else if (intOuterFuel<=2600) {
        if (intDensity <= 770) {
            self.lblIndexOuterRight.text = @"+6";
        } else {
            self.lblIndexOuterRight.text = @"+5";
        }
    } else if (intOuterFuel<=2900) {
        self.lblIndexOuterRight.text = @"+6";
        
    }
//    if ([self.txtOuterFuelRight.text intValue] > (3650*intDensity)/1000) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Attention!"
//                              message:@"Max Tank Capacity Right Outer Tank reached!"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//        self.txtOuterFuelRight.text = @"0";
//        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%ld ", (long)(3650*intDensity)/1000];
//    }
    self.progFuelOuterRight.progress = (float)intOuterFuel/(float)((3650*intDensity)/1000);
}

-(void)indexOuterTankLeft
{
    NSInteger intOuterFuel = [self.txtOuterFuelLeft.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intOuterFuel<=200) {
        self.lblIndexOuterLeft.text = @"0";
    } else if (intOuterFuel<=800) {
        self.lblIndexOuterLeft.text = @"+1";
    } else if (intOuterFuel<=1300) {
        self.lblIndexOuterLeft.text = @"+2";
    } else if (intOuterFuel<=1700) {
        self.lblIndexOuterLeft.text = @"+3";
    } else if (intOuterFuel<=1800) {
        if (intDensity <= 785) {
            self.lblIndexOuterLeft.text = @"+3";
        } else {
            self.lblIndexOuterLeft.text = @"+4";
        }
    } else if (intOuterFuel<=2200) {
        self.lblIndexOuterLeft.text = @"+4";
    } else if (intOuterFuel<=2500) {
        self.lblIndexOuterLeft.text = @"+5";
    } else if (intOuterFuel<=2600) {
        if (intDensity <= 770) {
            self.lblIndexOuterLeft.text = @"+6";
        } else {
            self.lblIndexOuterLeft.text = @"+5";
        }
    } else if (intOuterFuel<=2900) {
        self.lblIndexOuterLeft.text = @"+6";
        
    } else if (intOuterFuel<=(3650*intDensity)/1000) {
        self.lblIndexOuterLeft.text = @"+6";
        
    }
    
//    if ([self.txtOuterFuelLeft.text intValue] > (int)(3650*intDensity)/1000) {
//        NSLog(@"%i", ((int)(3650*intDensity)/1000));
//        NSLog(@"%i", ([self.txtOuterFuelLeft.text intValue]));
//        
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Attention!"
//                              message:@"Max Tank Capacity Left Outer Tank reached!"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%ld ", (long)(3650*intDensity)/1000];
//    }
    self.progFuelOuterLeft.progress = (float)intOuterFuel/((3650*intDensity)/1000);
}
-(void)indexCenterTank
{
    NSInteger intCenterFuel = [self.txtCenterFuel.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intCenterFuel==0) {
        self.lblIndexCenterTank.text = @"0";
    }else if (intCenterFuel<=1000) {
        self.lblIndexCenterTank.text = @"-1";
    } else if (intCenterFuel<=2000) {
        self.lblIndexCenterTank.text = @"-2";
    } else if (intCenterFuel<=3000) {
        self.lblIndexCenterTank.text = @"-3";
    } else if (intCenterFuel<=4000) {
        self.lblIndexCenterTank.text = @"-4";
    } else if (intCenterFuel<=5000) {
        self.lblIndexCenterTank.text = @"-5";
    } else if (intCenterFuel<=6000) {
        self.lblIndexCenterTank.text = @"-7";
    } else if (intCenterFuel<=7000) {
        self.lblIndexCenterTank.text = @"-8";
    } else if (intCenterFuel<=8000) {
        self.lblIndexCenterTank.text = @"-9";
    } else if (intCenterFuel<=9000) {
        self.lblIndexCenterTank.text = @"-11";
    } else if (intCenterFuel<=10000) {
        self.lblIndexCenterTank.text = @"-12";
    } else if (intCenterFuel<=11000) {
        self.lblIndexCenterTank.text = @"-13";
    } else if (intCenterFuel<=12000) {
        self.lblIndexCenterTank.text = @"-15";
    } else if (intCenterFuel<=13000) {
        self.lblIndexCenterTank.text = @"-16";
    } else if (intCenterFuel<=14000) {
        self.lblIndexCenterTank.text = @"-17";
    } else if (intCenterFuel<=15000) {
        self.lblIndexCenterTank.text = @"-19";
    } else if (intCenterFuel<=16000) {
        self.lblIndexCenterTank.text = @"-20";
    } else if (intCenterFuel<=17000) {
        self.lblIndexCenterTank.text = @"-21";
    } else if (intCenterFuel<=18000) {
        self.lblIndexCenterTank.text = @"-23";
    } else if (intCenterFuel<=19000) {
        self.lblIndexCenterTank.text = @"-24";
    } else if (intCenterFuel<=20000) {
        self.lblIndexCenterTank.text = @"-25";
    } else if (intCenterFuel<=21000) {
        self.lblIndexCenterTank.text = @"-27";
    } else if (intCenterFuel<=22000) {
        self.lblIndexCenterTank.text = @"-28";
    } else if (intCenterFuel<=23000) {
        self.lblIndexCenterTank.text = @"-29";
    } else if (intCenterFuel<=24000) {
        self.lblIndexCenterTank.text = @"-31";
    } else if (intCenterFuel<=25000) {
        self.lblIndexCenterTank.text = @"-32";
    } else if (intCenterFuel<=26000) {
        self.lblIndexCenterTank.text = @"-34";
    } else if (intCenterFuel<=27000) {
        self.lblIndexCenterTank.text = @"-35";
    } else if (intCenterFuel<=28000) {
        self.lblIndexCenterTank.text = @"-36";
    } else if (intCenterFuel<=29000) {
        if (intDensity >= 830) {
            self.lblIndexCenterTank.text = @"-37";
        } else {
            self.lblIndexCenterTank.text = @"-38";
        }
    } else if (intCenterFuel<=30000) {
        if (intDensity <= 775) {
            self.lblIndexCenterTank.text = @"-40";
        } else {
            self.lblIndexCenterTank.text = @"-39";
        }
    } else if (intCenterFuel<=31000) {
        if (intDensity <= 760) {
            self.lblIndexCenterTank.text = @"-42";
        } else if (intDensity >= 830){
            self.lblIndexCenterTank.text = @"-40";
        } else {
            self.lblIndexCenterTank.text = @"-41";
        }
    } else if (intCenterFuel<=32000) {
        if (intDensity <= 805) {
            self.lblIndexCenterTank.text = @"-43";
        } else {
            self.lblIndexCenterTank.text = @"-42";
        }
    } else if (intCenterFuel<=33000) {
        if (intDensity <= 795) {
            self.lblIndexCenterTank.text = @"-45";
        } else {
            self.lblIndexCenterTank.text = @"-44";
        }
    } else if (intCenterFuel<=34000) {
        self.lblIndexCenterTank.text = @"-46";
    }
    
//    if ([self.txtCenterFuel.text intValue] > (41560*intDensity)/1000) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Attention!"
//                              message:@"Max Tank Capacity Center Tank reached!"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//        self.txtCenterFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (long)(41560*intDensity)/1000];
//    }
    self.progFuelCenterTank.progress = (float)intCenterFuel/((41560*intDensity)/1000);
    
}

-(void)indexTrimTank
{
    NSInteger intTrimFuel = [self.txtTrimFuel.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intTrimFuel==0) {
        self.lblIndexTrimTank.text = @"0";
    } else if (intTrimFuel<=100) {
        self.lblIndexTrimTank.text = @"+1";
    } else if (intTrimFuel<=200) {
        self.lblIndexTrimTank.text = @"+2";
    } else if (intTrimFuel<=200) {
        self.lblIndexTrimTank.text = @"+2";
    } else if (intTrimFuel<=300) {
        self.lblIndexTrimTank.text = @"+3";
    } else if (intTrimFuel<=400) {
        self.lblIndexTrimTank.text = @"+4";
    } else if (intTrimFuel<=500) {
        self.lblIndexTrimTank.text = @"+5";
    } else if (intTrimFuel<=600) {
        self.lblIndexTrimTank.text = @"+6";
    } else if (intTrimFuel<=700) {
        self.lblIndexTrimTank.text = @"+7";
    } else if (intTrimFuel<=800) {
        self.lblIndexTrimTank.text = @"+8";
    } else if (intTrimFuel<=900) {
        self.lblIndexTrimTank.text = @"+9";
    } else if (intTrimFuel<=1000) {
        self.lblIndexTrimTank.text = @"+10";
    } else if (intTrimFuel<=1100) {
        self.lblIndexTrimTank.text = @"+11";
    } else if (intTrimFuel<=1200) {
        self.lblIndexTrimTank.text = @"+12";
    } else if (intTrimFuel<=1300) {
        self.lblIndexTrimTank.text = @"+13";
    } else if (intTrimFuel<=1400) {
        self.lblIndexTrimTank.text = @"+14";
    } else if (intTrimFuel<=1500) {
        self.lblIndexTrimTank.text = @"+15";
    } else if (intTrimFuel<=1600) {
        self.lblIndexTrimTank.text = @"+17";
    } else if (intTrimFuel<=1700) {
        self.lblIndexTrimTank.text = @"+18";
    } else if (intTrimFuel<=1800) {
        self.lblIndexTrimTank.text = @"+19";
    } else if (intTrimFuel<=1900) {
        self.lblIndexTrimTank.text = @"+20";
    } else if (intTrimFuel<=2000) {
        self.lblIndexTrimTank.text = @"+21";
    } else if (intTrimFuel<=2100) {
        self.lblIndexTrimTank.text = @"+22";
    } else if (intTrimFuel<=2200) {
        self.lblIndexTrimTank.text = @"+23";
    } else if (intTrimFuel<=2300) {
        self.lblIndexTrimTank.text = @"+24";
    } else if (intTrimFuel<=2400) {
        self.lblIndexTrimTank.text = @"+25";
    } else if (intTrimFuel<=2500) {
        self.lblIndexTrimTank.text = @"+26";
    } else if (intTrimFuel<=2600) {
        self.lblIndexTrimTank.text = @"+27";
    } else if (intTrimFuel<=2700) {
        self.lblIndexTrimTank.text = @"+28";
    } else if (intTrimFuel<=2800) {
        self.lblIndexTrimTank.text = @"+29";
    } else if (intTrimFuel<=2900) {
        self.lblIndexTrimTank.text = @"+30";
    } else if (intTrimFuel<=3000) {
        self.lblIndexTrimTank.text = @"+31";
    } else if (intTrimFuel<=3100) {
        self.lblIndexTrimTank.text = @"+32";
    } else if (intTrimFuel<=3200) {
        self.lblIndexTrimTank.text = @"+33";
    } else if (intTrimFuel<=3300) {
        if (intDensity <= 795) {
            self.lblIndexTrimTank.text = @"+35";
        }else {
            self.lblIndexTrimTank.text = @"+34";
        }
    } else if (intTrimFuel<=3400) {
        self.lblIndexTrimTank.text = @"+36";
    } else if (intTrimFuel<=3500) {
        self.lblIndexTrimTank.text = @"+37";
    } else if (intTrimFuel<=3600) {
        self.lblIndexTrimTank.text = @"+38";
    } else if (intTrimFuel<=3700) {
        self.lblIndexTrimTank.text = @"+39";
    } else if (intTrimFuel<=3800) {
        self.lblIndexTrimTank.text = @"+40";
    } else if (intTrimFuel<=3900) {
        self.lblIndexTrimTank.text = @"+41";
    } else if (intTrimFuel<=4000) {
        self.lblIndexTrimTank.text = @"+42";
    } else if (intTrimFuel<=4100) {
        self.lblIndexTrimTank.text = @"+43";
    } else if (intTrimFuel<=4200) {
        if (intDensity <= 770) {
            self.lblIndexTrimTank.text = @"+45";
        }else {
            self.lblIndexTrimTank.text = @"+44";
        }
    } else if (intTrimFuel<=4300) {
        if (intDensity <= 805) {
            self.lblIndexTrimTank.text = @"+46";
        }else {
            self.lblIndexTrimTank.text = @"+45";
        }
    } else if (intTrimFuel<=4400) {
        self.lblIndexTrimTank.text = @"+47";
    } else if (intTrimFuel<=4500) {
        self.lblIndexTrimTank.text = @"+48";
    } else if (intTrimFuel<=4600) {
        self.lblIndexTrimTank.text = @"+49";
    } else if (intTrimFuel<=4700) {
        self.lblIndexTrimTank.text = @"+50";
    } else if (intTrimFuel<=4800) {
        self.lblIndexTrimTank.text = @"+51";
    } else if (intTrimFuel<=4900) {
        self.lblIndexTrimTank.text = @"+52";
    } else if (intTrimFuel<=5000) {
        self.lblIndexTrimTank.text = @"+53";
    } else if (intTrimFuel<=5100) {
        if (intDensity >= 830) {
            self.lblIndexTrimTank.text = @"+54";
        }else {
            self.lblIndexTrimTank.text = @"+55";
        }
    }
//    if ([self.txtTrimFuel.text intValue] > (6230*intDensity)/1000) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Attention!"
//                              message:@"Max Tank Capacity Trim Tank reached!"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (long)(6230*intDensity)/1000];
//    }
    self.progFuelTrimTank.progress = (float)intTrimFuel/((6230*intDensity)/1000);
}
-(void)indexInnerTankRight
{
    NSInteger intInnerFuel = [self.txtInnerFuelRight.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intInnerFuel==0) {
        self.lblIndexInnerRight.text = @"0";
    } else if (intInnerFuel<=1000) {
        self.lblIndexInnerRight.text = @"-1";
    } else if (intInnerFuel<=2000) {
        self.lblIndexInnerRight.text = @"-2";
    } else if (intInnerFuel<=3000) {
        self.lblIndexInnerRight.text = @"-3";
    } else if (intInnerFuel<=4000) {
        self.lblIndexInnerRight.text = @"-4";
    } else if (intInnerFuel<=5000) {
        self.lblIndexInnerRight.text = @"-5";
    } else if (intInnerFuel<=6000) {
        self.lblIndexInnerRight.text = @"-6";
    } else if (intInnerFuel<=7000) {
        self.lblIndexInnerRight.text = @"-7";
    } else if (intInnerFuel<=8000) {
        self.lblIndexInnerRight.text = @"-8";
    } else if (intInnerFuel<=9000) {
        self.lblIndexInnerRight.text = @"-9";
    } else if (intInnerFuel<=10000) {
        self.lblIndexInnerRight.text = @"-10";
    } else if (intInnerFuel<=11000) {
        self.lblIndexInnerRight.text = @"-11";
    } else if (intInnerFuel<=12000) {
        self.lblIndexInnerRight.text = @"-12";
    } else if (intInnerFuel<=13000) {
        self.lblIndexInnerRight.text = @"-13";
    } else if (intInnerFuel<=14000) {
        self.lblIndexInnerRight.text = @"-13";
    } else if (intInnerFuel<=15000) {
        self.lblIndexInnerRight.text = @"-14";
    } else if (intInnerFuel<=16000) {
        self.lblIndexInnerRight.text = @"-15";
    } else if (intInnerFuel<=17000) {
        self.lblIndexInnerRight.text = @"-16";
    } else if (intInnerFuel<=18000) {
        if (intDensity <= 760) {
            self.lblIndexInnerRight.text = @"-16";
        } else {
            self.lblIndexInnerRight.text = @"-17";
        }
    } else if (intInnerFuel<=19000) {
        if (intDensity >= 825) {
            self.lblIndexInnerRight.text = @"-18";
        } else {
            self.lblIndexInnerRight.text = @"-17";
        }
    } else if (intInnerFuel<=20000) {
        self.lblIndexInnerRight.text = @"-18";
    } else if (intInnerFuel<=21000) {
        if (intDensity >= 790) {
            self.lblIndexInnerRight.text = @"-19";
        } else {
            self.lblIndexInnerRight.text = @"-18";
        }
    } else if (intInnerFuel<=22000) {
        self.lblIndexInnerRight.text = @"-19";
    } else if (intInnerFuel<=23000) {
        if (intDensity >= 805) {
            self.lblIndexInnerRight.text = @"-20";
        } else {
            self.lblIndexInnerRight.text = @"-19";
        }
    } else if (intInnerFuel<=24000) {
        if (intDensity >= 790) {
            self.lblIndexInnerRight.text = @"-20";
        } else {
            self.lblIndexInnerRight.text = @"-19";
        }
    } else if (intInnerFuel<=25000) {
        if (intDensity >= 785) {
            self.lblIndexInnerRight.text = @"-20";
            if (intDensity >= 830) {
                self.lblIndexInnerRight.text = @"-21";
            }
        } else {
            self.lblIndexInnerRight.text = @"-19";
        }
    } else if (intInnerFuel<=26000) {
        if (intDensity >= 790) {
            self.lblIndexInnerRight.text = @"-20";
            if (intDensity >= 825) {
                self.lblIndexInnerRight.text = @"-21";
            }
        } else {
            self.lblIndexInnerRight.text = @"-19";
        }
    } else if (intInnerFuel<=27000) {
        if (intDensity <= 760) {
            self.lblIndexInnerRight.text = @"-18";
        } else if (intDensity >= 795) {
            self.lblIndexInnerRight.text = @"-20";
            if (intDensity >= 830) {
                self.lblIndexInnerRight.text = @"-21";
            }
        } else {
            self.lblIndexInnerRight.text = @"-19";
        }
    } else if (intInnerFuel<=28000) {
        if (intDensity <= 770) {
            self.lblIndexInnerRight.text = @"-18";
        } else if (intDensity >= 800) {
            self.lblIndexInnerRight.text = @"-20";
        } else {
            self.lblIndexInnerRight.text = @"-19";
        }
    } else if (intInnerFuel<=29000) {
        if (intDensity <= 760) {
            self.lblIndexInnerRight.text = @"-17";
        } else if (intDensity >= 790) {
            self.lblIndexInnerRight.text = @"-19";
            if (intDensity >= 810) {
                self.lblIndexInnerRight.text = @"-20";
            }
        } else {
            self.lblIndexInnerRight.text = @"-18";
        }
    } else if (intInnerFuel<=30000) {
        if (intDensity <= 775) {
            self.lblIndexInnerRight.text = @"-17";
        } else if (intDensity >= 800) {
            self.lblIndexInnerRight.text = @"-19";
            if (intDensity >= 825) {
                self.lblIndexInnerRight.text = @"-20";
            }
        } else {
            self.lblIndexInnerRight.text = @"-18";
        }
    } else if (intInnerFuel<=31000) {
        if (intDensity <= 775) {
            self.lblIndexInnerRight.text = @"-16";
        } else if (intDensity >= 795) {
            self.lblIndexInnerRight.text = @"-18";
            if (intDensity >= 815) {
                self.lblIndexInnerRight.text = @"-19";
            }
        } else {
            self.lblIndexInnerRight.text = @"-17";
        }
        
    } else if (intInnerFuel<=32000) {
        if (intDensity <= 775) {
            if (intDensity <= 760) {
                self.lblIndexInnerRight.text = @"-14";
            } else {
                self.lblIndexInnerRight.text = @"-15";
            }
        } else if (intDensity >= 795) {
            self.lblIndexInnerRight.text = @"-17";
            if (intDensity >= 810) {
                self.lblIndexInnerRight.text = @"-18";
            }
            if (intDensity >= 830) {
                self.lblIndexInnerRight.text = @"-19";
            }
        } else {
            self.lblIndexInnerRight.text = @"-16";
        }
    } else if (intInnerFuel<=33000) {
        if (intDensity <= 790) {
            if (intDensity <= 760) {
                self.lblIndexInnerRight.text = @"-14";
            } else {
                self.lblIndexInnerRight.text = @"-15";
            }
        } else if (intDensity >= 810) {
            self.lblIndexInnerRight.text = @"-17";
            if (intDensity >= 825) {
                self.lblIndexInnerRight.text = @"-18";
            }
        } else {
            self.lblIndexInnerRight.text = @"-16";
        }
        
    } else if (intInnerFuel<=34000) {
        if (intDensity <= 790) {
            if (intDensity <= 760) {
                self.lblIndexInnerRight.text = @"-14";
            } else {
                self.lblIndexInnerRight.text = @"-15";
            }
        } else if (intDensity >= 810) {
            self.lblIndexInnerRight.text = @"-17";
            if (intDensity >= 825) {
                self.lblIndexInnerRight.text = @"-18";
            }
        } else {
            self.lblIndexInnerRight.text = @"-16";
        }
    }
//    if ([self.txtInnerFuelRight.text intValue] > (42000*intDensity)/1000) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Attention!"
//                              message:@"Max Tank Capacity Right Inner Tank reached!"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//        self.txtInnerFuelRight.text = [[NSString alloc] initWithFormat:@"%ld ", (long)(42000*intDensity)/1000];
//    }
    self.progFuelInnerRight.progress = (float)intInnerFuel/((41904*intDensity)/1000);
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
