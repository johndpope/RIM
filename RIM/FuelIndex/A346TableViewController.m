//
//  A332TableViewController.m
//  Fuel Index
//
//  Created by Mikel on 06.08.14.
//  Copyright (c) 2014 Mikelsoft.com. All rights reserved.
//

#import "A346TableViewController.h"


@interface A346TableViewController ()

@end

@implementation A346TableViewController

@synthesize btnDensity;

#pragma mark -
#pragma mark Constants

#define K 100
#define C 5000
#define CGa 25
#define LengthMAC 8.3661
#define RefSta 43.1255
#define LEMAC 41.0340


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

-(IBAction)formatInnerLeft1:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtInnerFuelLeft1.text intValue] > ((24589*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtInnerFuelLeft1.text = [[NSString alloc] initWithFormat:@"%li ", ((24589*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatInnerRight3:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtInnerFuelRight3.text intValue] > ((34824*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtInnerFuelRight3.text = [[NSString alloc] initWithFormat:@"%li ", ((34824*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatInnerLeft2:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtInnerFuelLeft1.text intValue] > ((34824*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtInnerFuelLeft1.text = [[NSString alloc] initWithFormat:@"%li ", ((34824*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatInnerRight4:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtInnerFuelRight3.text intValue] > ((24589*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtInnerFuelRight3.text = [[NSString alloc] initWithFormat:@"%li ", ((24589*intDensity)/1000)];
    }
    
    
}

-(IBAction)formatOuterLeft:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtOuterFuelLeft.text intValue] > ((6221*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%li ", ((6221*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatOuterRight:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtOuterFuelRight.text intValue] > ((6221*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%li ", ((6221*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatCenter:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtCenterFuel.text intValue] > ((55202*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtCenterFuel.text = [[NSString alloc] initWithFormat:@"%li ", ((55202*intDensity)/1000)];
    }
    
    
}
-(IBAction)formatTrim:(id)sender
{
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    
    if ([self.txtTrimFuel.text intValue] > ((9509*intDensity)/1000)) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                          message:@"Max Quantity exceeded!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%li ", ((9509*intDensity)/1000)];
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A345top.png"]];
    imageView.contentMode = UIViewContentModeCenter;
    self.tableView.backgroundView = imageView;
    self.txtTotalFuel.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    self.txtTotalFuel.delegate=self;
    self.lblIndexCenterTank.hidden = YES;
    self.lblIndexCenterTanklbl.hidden = YES;
//    self.lblIndexCenterRearTank.hidden = YES;
//    self.lblIndexCenterRearTanklbl.hidden = YES;
    self.lblIndexInnerLeft1.hidden = YES;
    self.lblIndexInnerLeft1lbl.hidden = YES;
    self.lblIndexInnerLeft2.hidden = YES;
    self.lblIndexInnerLeft2lbl.hidden = YES;
    self.lblIndexInnerRight3.hidden = YES;
    self.lblIndexInnerRight3lbl.hidden = YES;
    self.lblIndexInnerRight4.hidden = YES;
    self.lblIndexInnerRight4lbl.hidden = YES;
    self.lblIndexOuterLeft.hidden = YES;
    self.lblIndexOuterLeftlbl.hidden = YES;
    self.lblIndexOuterRight.hidden = YES;
    self.lblIndexOuterRightlbl.hidden = YES;
    self.lblIndexTrimTank.hidden = YES;
    self.lblIndexTrimTanklbl.hidden = YES;
    
//    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
//    float fltDensity = intDensity/1000.0f;
//    double dblFuel = (153842/(fltDensity));
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
    [self indexInnerTankLeft1];
    [self indexInnerTankLeft2];
    [self indexInnerTankRight3];
    [self indexInnerTankRight4];
    [self indexOuterTankRight];
    [self indexOuterTankLeft];
    [self indexTrimTank];
    [self indexCenterTank];
    [self indexCenterREARTank];
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
-(void) calcTrimSet {
    double c = 6.5-(7.5 * (([self.txtGWCG.text doubleValue]-16)/24));
    if (c < 0) {
        self.txtTrim.text = [[[NSString alloc]initWithFormat:@"%2.2f", c] stringByAppendingString:@"° DN"];
    }
    else {
        self.txtTrim.text = [[[NSString alloc]initWithFormat:@"%2.2f", c] stringByAppendingString:@"° UP"];
    }
    if ([self.txtGWCG.text doubleValue] <= 16 && [self.txtGWCG.text doubleValue] >= 13) {
        self.txtTrim.text = [[[NSString alloc]initWithFormat:@"%2.2f", 6.5] stringByAppendingString:@"° UP"];
    }
    else {
        if ([self.txtGWCG.text doubleValue] <= 44 && [self.txtGWCG.text doubleValue] >= 40) {
            self.txtTrim.text = [[[NSString alloc]initWithFormat:@"%2.2f", -1.0] stringByAppendingString:@"° DN"];
        }
    }
    if ([self.txtTrim.text doubleValue] > 44 || [self.txtGWCG.text doubleValue] < 13) {
        
        self.txtTrim.text = @"XXXX";
    }
//    self.txtTrim.text = @"";
    if ([self.txtGWCG.text doubleValue] >= 26 && [self.txtGWCG.text doubleValue] <= 44) {
        self.lblTrim.text = @"AFT CG";
    }
    else {
        self.lblTrim.text = @"FWD CG";
    }

    
}


-(IBAction)formatZFW:(id)sender
{
    if ([self.txtZFW.text length] >= 6) {
        if ([self.txtZFW.text intValue] > 251000) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                              message:@"Max ZFW exceeded!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
            self.txtZFW.text = @"251000";
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
    
    //    if ([self.navigationItem.title isEqualToString:@"Standard Fuel Distribution A330-200"]) {
    [self chooseFuelAmount:self];
    //    }

    
}

-(IBAction)nonStdFuel:(id)sender
{
    //    self.navBarStandartFuel.topItem.title = @"Non Standard Fuel Distribution A330-200";
    [self.navigationItem setTitle:@"Non Standard Fuel Distribution A340-600"];
    
    self.lblIndexCenterTank.hidden = NO;
    self.lblIndexCenterTanklbl.hidden = NO;
//    self.lblIndexCenterRearTank.hidden = NO;
//    self.lblIndexCenterRearTanklbl.hidden = NO;
    self.lblIndexInnerLeft1.hidden = NO;
    self.lblIndexInnerLeft1lbl.hidden = NO;
    self.lblIndexInnerLeft2.hidden = NO;
    self.lblIndexInnerLeft2lbl.hidden = NO;
    self.lblIndexInnerRight3.hidden = NO;
    self.lblIndexInnerRight3lbl.hidden = NO;
    self.lblIndexInnerRight4.hidden = NO;
    self.lblIndexInnerRight4lbl.hidden = NO;
    self.lblIndexOuterLeft.hidden = NO;
    self.lblIndexOuterLeftlbl.hidden = NO;
    self.lblIndexOuterRight.hidden = NO;
    self.lblIndexOuterRightlbl.hidden = NO;
    self.lblIndexTrimTank.hidden = NO;
    self.lblIndexTrimTanklbl.hidden = NO;
    
    self.txtTotalFuel.textColor = [UIColor blackColor];
    self.txtOuterFuelLeft.textColor = [UIColor blackColor];
    self.txtOuterFuelRight.textColor = [UIColor blackColor];
    self.txtInnerFuelLeft1.textColor = [UIColor blackColor];
    self.txtInnerFuelRight3.textColor = [UIColor blackColor];
    self.txtInnerFuelLeft2.textColor = [UIColor blackColor];
    self.txtInnerFuelRight4.textColor = [UIColor blackColor];
    self.txtCenterFuel.textColor = [UIColor blackColor];
//    self.txtCenterRearFuel.textColor = [UIColor blackColor];
    self.txtTrimFuel.textColor = [UIColor blackColor];
    //    self.btnDensity.title = @"Choose Density";
    
    NSInteger intTotalFuel = [self.txtInnerFuelLeft1.text intValue]+[self.txtInnerFuelLeft2.text intValue]+[self.txtInnerFuelRight3.text intValue] +[self.txtInnerFuelRight4.text intValue]+[self.txtOuterFuelLeft.text intValue]+[self.txtOuterFuelRight.text intValue]+[self.txtCenterFuel.text intValue]+[self.txtTrimFuel.text intValue];
    
    self.txtTotalFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (long)intTotalFuel];
    //    self.progTotalFuel.progress = (float)intTotalFuel/(float)109186;
    [self indexInnerTankLeft1];
    [self indexInnerTankLeft2];
    [self indexInnerTankRight3];
    [self indexInnerTankRight4];
    [self indexOuterTankRight];
    [self indexOuterTankLeft];
    [self indexTrimTank];
    [self indexCenterTank];
//    [self indexCenterREARTank];
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
    [self.navigationItem setTitle:@"Standard Fuel Distribution A340-600"];
    self.txtTotalFuel.textColor = [UIColor darkGrayColor];
    self.txtOuterFuelLeft.textColor = [UIColor darkGrayColor];
    self.txtOuterFuelRight.textColor = [UIColor darkGrayColor];
    self.txtInnerFuelLeft1.textColor = [UIColor darkGrayColor];
    self.txtInnerFuelRight3.textColor = [UIColor darkGrayColor];
    self.txtInnerFuelLeft2.textColor = [UIColor darkGrayColor];
    self.txtInnerFuelRight4.textColor = [UIColor darkGrayColor];
    self.txtCenterFuel.textColor = [UIColor darkGrayColor];
//    self.txtCenterRearFuel.textColor = [UIColor darkGrayColor];
    self.txtTrimFuel.textColor = [UIColor darkGrayColor];
    
    self.lblIndexCenterTank.hidden = YES;
    self.lblIndexCenterTanklbl.hidden = YES;
//    self.lblIndexCenterRearTank.hidden = YES;
//    self.lblIndexCenterRearTanklbl.hidden = YES;
    self.lblIndexInnerLeft1.hidden = YES;
    self.lblIndexInnerLeft1lbl.hidden = YES;
    self.lblIndexInnerLeft2.hidden = YES;
    self.lblIndexInnerLeft2lbl.hidden = YES;
    self.lblIndexInnerRight3.hidden = YES;
    self.lblIndexInnerRight3lbl.hidden = YES;
    self.lblIndexInnerRight4.hidden = YES;
    self.lblIndexInnerRight4lbl.hidden = YES;
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
    
    if (intTotalFuel <= 12000) { //12000
        self.txtInnerFuelLeft1.text = [[NSString alloc] initWithFormat:@"%ld ", intTotalFuel/4];
        self.progFuelInnerLeft1.progress = (float)(intTotalFuel/4)/(float)((24589*intDensity)/1000);
        
        
        self.txtInnerFuelLeft2.text = [[NSString alloc] initWithFormat:@"%ld ", intTotalFuel/4];
        self.progFuelInnerLeft2.progress = (float)(intTotalFuel/4)/(float)((34824*intDensity)/1000);
        
        
        self.txtInnerFuelRight3.text = [[NSString alloc] initWithFormat:@"%ld ", intTotalFuel/4];
        self.progFuelInnerRight3.progress = (float)(intTotalFuel/4)/(float)((34824*intDensity)/1000);
        
        
        self.txtInnerFuelRight4.text = [[NSString alloc] initWithFormat:@"%ld ", intTotalFuel/4];
        self.progFuelInnerRight4.progress = (float)(intTotalFuel/4)/(float)((24589*intDensity)/1000);
        
        
        self.txtOuterFuelLeft.text = @"0";
        self.progFuelOuterLeft.progress = 0;
        self.txtOuterFuelRight.text = @"0";
        self.progFuelOuterRight.progress = 0;
        self.txtCenterFuel.text = @"0";
        self.progFuelCenterTank.progress = 0;
//        self.txtCenterRearFuel.text = @"0";
//        self.progFuelCenterRearTank.progress = 0;
        self.txtTrimFuel.text = @"0";
        self.progFuelTrimTank.progress = 0;
        
    } else if ( intTotalFuel > 12000 && intTotalFuel <= 21000) //210000
    {
        self.txtInnerFuelLeft1.text = [[NSString alloc] initWithFormat:@"%d ", 3000];
        self.progFuelInnerLeft1.progress = (float)3000/(float)((24589*intDensity)/1000);
        
        NSLog(@"%f", (float)3000/((24716*intDensity)/1000));
        
        self.txtInnerFuelLeft2.text = [[NSString alloc] initWithFormat:@"%d ", 3000];
        self.progFuelInnerLeft2.progress = (float)3000/(float)((34824*intDensity)/1000);
        
        NSLog(@"%f", (float)3000/((24716*intDensity)/1000));
        
        self.txtInnerFuelRight3.text = [[NSString alloc] initWithFormat:@"%d ", 3000];
        self.progFuelInnerRight3.progress = (float)3000/(float)((34824*intDensity)/1000);
        
        NSLog(@"%f", (float)3000/(float)((34805*intDensity)/1000));
        
        self.txtInnerFuelRight4.text = [[NSString alloc] initWithFormat:@"%d ", 3000];
        self.progFuelInnerRight4.progress = (float)3000/(float)((24589*intDensity)/1000);
        
        NSLog(@"%f", (float)3000/((24716*intDensity)/1000));
        
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%ld ", ((intTotalFuel-12000))/2];
        self.progFuelOuterLeft.progress = (float)((intTotalFuel-12000)/2)/(float)((6221*intDensity)/1000);
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%ld ", ((intTotalFuel-12000))/2];
        self.progFuelOuterRight.progress = (float)((intTotalFuel-12000)/2)/(float)((6221*intDensity)/1000);
        
        self.txtCenterFuel.text = @"0";
        self.progFuelCenterTank.progress = 0;
//        self.txtCenterRearFuel.text = @"0";
//        self.progFuelCenterRearTank.progress = 0;
        self.txtTrimFuel.text = @"0";
        self.progFuelTrimTank.progress = 0;
        
    } else if ( intTotalFuel > 21000 && intTotalFuel <= (81800))
    {
        self.txtInnerFuelLeft1.text = [[NSString alloc] initWithFormat:@"%ld ", ((intTotalFuel-21000)/4)+3000];
        self.progFuelInnerLeft1.progress = (float)(((intTotalFuel-21000)/4)+3000)/((24589*intDensity)/1000);
        
        NSLog(@"%f", (float)(((intTotalFuel-21000)/4)+3000)/((24716*intDensity)/1000));
        
        self.txtInnerFuelLeft2.text = [[NSString alloc] initWithFormat:@"%ld ", ((intTotalFuel-21000)/4)+3000];
        self.progFuelInnerLeft2.progress = (float)(((intTotalFuel-21000)/4)+3000)/((34824*intDensity)/1000);
        
        NSLog(@"%f", (float)(((intTotalFuel-21000)/4)+3000)/((34805*intDensity)/1000));
        NSLog(@"%f", (float)intTotalFuel/2/(float)((42000*intDensity)/1000));
        self.txtInnerFuelRight3.text = [[NSString alloc] initWithFormat:@"%ld ", ((intTotalFuel-21000)/4)+3000];
        self.progFuelInnerRight3.progress = (float)(((intTotalFuel-21000)/4)+3000)/((34824*intDensity)/1000);
        
        NSLog(@"%f", (float)((intTotalFuel-21000)/4)+3000/((34805*intDensity)/1000));
        
        self.txtInnerFuelRight4.text = [[NSString alloc] initWithFormat:@"%ld ", ((intTotalFuel-21000)/4)+3000];
        self.progFuelInnerRight4.progress = (float)(((intTotalFuel-21000)/4)+3000)/((24589*intDensity)/1000);
        
        NSLog(@"%f", (float)(((intTotalFuel-21000)/4)+3000)/((24716*intDensity)/1000));
        
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%d ",4500];
        self.progFuelOuterLeft.progress = 1;
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%d ",4500];
        self.progFuelOuterRight.progress = 1;
        
        self.txtCenterFuel.text = @"0";
        self.progFuelCenterTank.progress = 0;
//        self.txtCenterRearFuel.text = @"0";
//        self.progFuelCenterRearTank.progress = 0;
        self.txtTrimFuel.text = @"0";
        self.progFuelTrimTank.progress = 0;
        
    } else if ( intTotalFuel > 81800 && intTotalFuel <= 116200)
    {
        
        self.txtInnerFuelLeft1.text = [[NSString alloc] initWithFormat:@"%d ", 18200];
        self.progFuelInnerLeft1.progress = (float)18200/(float)((24589*intDensity)/1000);
        
        self.txtInnerFuelLeft2.text = [[NSString alloc] initWithFormat:@"%ld ", ((((intTotalFuel-81800)*22)/100)/2)+18200]; //22%
        self.progFuelInnerLeft2.progress = (float)(((((intTotalFuel-81800)*22)/100)/2)+18200)/(float)((34824*intDensity)/1000);
        
        self.txtInnerFuelRight3.text = [[NSString alloc] initWithFormat:@"%ld ", ((((intTotalFuel-81800)*22)/100)/2)+18200]; //22%
        self.progFuelInnerRight3.progress = (float)(((((intTotalFuel-81800)*22)/100)/2)+18200)/(float)((34824*intDensity)/1000);
        
        self.txtInnerFuelRight4.text = [[NSString alloc] initWithFormat:@"%d ", 18200];
        self.progFuelInnerRight4.progress = (float)18200/(float)((24589*intDensity)/1000);
        
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%d ",(4500)];
        self.progFuelOuterLeft.progress = (float)4500/(float)((6221*intDensity)/1000);
        
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%d ",(4500)];
        self.progFuelOuterRight.progress = (float)4500/(float)((6221*intDensity)/1000);
        
        self.txtCenterFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-81800)*49)/100)]; //49%
        self.progFuelCenterTank.progress = (float)(((intTotalFuel-81800)*49)/100)/(float)((55202*intDensity)/1000);
        
        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-81800)*7)/100)];//7%
        self.progFuelTrimTank.progress = (float)(((intTotalFuel-81800)*7)/100)/(float)((9509*intDensity)/1000);
        
//        self.txtCenterRearFuel.text = @"0";
//        self.progFuelCenterRearTank.progress = 0;
        
        
        
        
    } else if ( intTotalFuel > 116200 && intTotalFuel <= 142700)
    {
        self.txtInnerFuelLeft1.text = [[NSString alloc] initWithFormat:@"%d ", 18200];
        self.progFuelInnerLeft1.progress = (float)18200/(float)((24589*intDensity)/1000);
        
        NSLog(@"%f", (float)18200/(float)((24716*intDensity)/1000));
        
        
        self.txtInnerFuelLeft2.text = [[NSString alloc] initWithFormat:@"%d ", 25700];
        self.progFuelInnerLeft2.progress = (float)25700/(float)((34824*intDensity)/1000);
        
        self.txtInnerFuelRight3.text = [[NSString alloc] initWithFormat:@"%d ", 25700];
        self.progFuelInnerRight3.progress = (float)25700/(float)((34824*intDensity)/1000);
        
        self.txtInnerFuelRight4.text = [[NSString alloc] initWithFormat:@"%d ", 18200];
        self.progFuelInnerRight4.progress = (float)18200/(float)((24589*intDensity)/1000);
        
        NSLog(@"%f", (float)18200/(float)((24716*intDensity)/1000));
        
        
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%d ",(4500)];
        self.progFuelOuterLeft.progress = (float)4500/(float)((6221*intDensity)/1000);
        
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%d ",(4500)];
        self.progFuelOuterRight.progress = (float)4500/(float)((6221*intDensity)/1000);
        
        self.txtCenterFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-116200)*87)/100)+17000]; //87%
        self.progFuelCenterTank.progress = (float)((((intTotalFuel-116200)*87)/100)+17000)/(float)((55202*intDensity)/1000);
        
        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-116200)*13)/100)+2400];//13%
        self.progFuelTrimTank.progress = (float)((((intTotalFuel-116200)*13)/100)+2400)/(float)((9509*intDensity)/1000);
        
        self.txtCenterRearFuel.text = @"0";
        self.progFuelCenterRearTank.progress = 0;
        
    } else if ( intTotalFuel > 142700 && intTotalFuel <= (196979*intDensity/1000)) //153842
    {
        self.txtInnerFuelLeft1.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-142700)*10)/100)+18200];//10%
        self.progFuelInnerLeft1.progress = (float)((((intTotalFuel-142700)*10)/100)+18200)/(float)((24589*intDensity)/1000);
        
        self.txtInnerFuelLeft2.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-142700)*15)/100)+25700];//15%
        self.progFuelInnerLeft2.progress = (float)((((intTotalFuel-142700)*15)/100)+25700)/(float)((34824*intDensity)/1000);
        
        self.txtInnerFuelRight3.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-142700)*15)/100)+25700];//15%
        self.progFuelInnerRight3.progress = (float)((((intTotalFuel-142700)*15)/100)+25700)/(float)((34824*intDensity)/1000);
        
        self.txtInnerFuelRight4.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-142700)*10)/100)+18200];//10%
        self.progFuelInnerRight4.progress = (float)((((intTotalFuel-142700)*10)/100)+18200)/(float)((24589*intDensity)/1000);
        
        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-142700)*3)/100)+4500];//3%
        self.progFuelOuterLeft.progress = (float)((((intTotalFuel-142700)*3)/100)+4500)/(float)((6221*intDensity)/1000);
        
        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-142700)*3)/100)+4500];//3%
        self.progFuelOuterRight.progress = (float)((((intTotalFuel-142700)*3)/100)+4500)/(float)((6221*intDensity)/1000);
        
        self.txtCenterFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-142700)*30)/100)+40000];//30%
        self.progFuelCenterTank.progress = (float)((((intTotalFuel-142700)*30)/100)+40000)/(float)((55202*intDensity)/1000);
        
        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-142700)*14)/100)+5900];//14%
        self.progFuelTrimTank.progress = (float)((((intTotalFuel-142700)*14)/100)+5900)/(float)((9509*intDensity)/1000);
        
//        self.txtCenterRearFuel.text = [[NSString alloc] initWithFormat:@"%ld ", intTotalFuel-142700];
//        self.progFuelCenterRearTank.progress = (float)(intTotalFuel-142700)/(float)((19741*intDensity)/1000);
        
//    } else if ( intTotalFuel > 156900 && intTotalFuel <= 168321)
//    {
//        self.txtInnerFuelLeft1.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-156900)*11)/100)+18200];//11%
//        self.progFuelInnerLeft1.progress = (float)((((intTotalFuel-156900)*11)/100)+18200)/(float)((24716*intDensity)/1000);
//        
//        self.txtInnerFuelLeft2.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-156900)*14)/100)+25700];//14%
//        self.progFuelInnerLeft2.progress = (float)((((intTotalFuel-156900)*14)/100)+25700)/(float)((34805*intDensity)/1000);
//        
//        self.txtInnerFuelRight3.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-156900)*14)/100)+25700];//14%
//        self.progFuelInnerRight3.progress = (float)((((intTotalFuel-156900)*14)/100)+25700)/(float)((34805*intDensity)/1000);
//        
//        self.txtInnerFuelRight4.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-156900)*11)/100)+18200];//11%
//        self.progFuelInnerRight4.progress = (float)((((intTotalFuel-156900)*11)/100)+18200)/(float)((24716*intDensity)/1000);
//        
//        self.txtOuterFuelLeft.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-156900)*4)/100)+4500];//4%
//        self.progFuelOuterLeft.progress = (float)((((intTotalFuel-156900)*4)/100)+4500)/(float)((6310*intDensity)/1000);
//        
//        self.txtOuterFuelRight.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-156900)*4)/100)+4500];//4%
//        self.progFuelOuterRight.progress = (float)((((intTotalFuel-156900)*4)/100)+4500)/(float)((6310*intDensity)/1000);
//        
//        self.txtCenterFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-156900)*29)/100)+40000];//29%
//        self.progFuelCenterTank.progress = (float)((((intTotalFuel-156900)*29)/100)+40000)/(float)((55133*intDensity)/1000);
//        
//        self.txtTrimFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-156900)*2)/100)+5900];//2%
//        self.progFuelTrimTank.progress = (float)((((intTotalFuel-156900)*2)/100)+5900)/(float)((7886*intDensity)/1000);
        
//        self.txtCenterRearFuel.text = [[NSString alloc] initWithFormat:@"%ld ", (((intTotalFuel-156900)*11)/100)+14200];//11%
//        self.progFuelCenterRearTank.progress = (float)((((intTotalFuel-156900)*11)/100)+14200)/(float)((19741*intDensity)/1000);
    }
    //    self.progTotalFuel.progress = (float)intTotalFuel/(float)((139090*intDensity)/1000);
    [self indexInnerTankLeft1];
    [self indexInnerTankLeft2];
    [self indexInnerTankRight3];
    [self indexInnerTankRight4];
    [self indexOuterTankRight];
    [self indexOuterTankLeft];
    [self indexTrimTank];
    [self indexCenterTank];
//    [self indexCenterREARTank];
    [self calculateIndex];
}
-(void)calculateIndex
{
    NSInteger intIndex = [self.lblIndexInnerLeft1.text intValue]+ [self.lblIndexInnerLeft2.text intValue]+[self.lblIndexInnerRight3.text intValue]+[self.lblIndexInnerRight4.text intValue]+[self.lblIndexOuterRight.text intValue]+[self.lblIndexOuterLeft.text intValue]+[self.lblIndexCenterTank.text intValue]+[self.lblIndexTrimTank.text intValue];
    self.lblFuelIndex.text = [[NSString alloc] initWithFormat:@"%1.0ld",(long)intIndex];
    if ([self.lblFuelIndex.text isEqualToString:@" "]) {
        self.lblFuelIndex.text = @"0";
    }
}
-(void)indexInnerTankLeft1
{
    NSInteger intInnerFuel = [self.txtInnerFuelLeft1.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intInnerFuel==0) {
        self.lblIndexInnerLeft1.text = @"0";
    }else if (intInnerFuel<=6000) {
        self.lblIndexInnerLeft1.text = @"0";
    } else if (intInnerFuel<=7000) {
        if (intDensity <= 775) {
            self.lblIndexInnerLeft1.text = @"+1";
        } else {
            self.lblIndexInnerLeft1.text = @"0";
        }
    } else if (intInnerFuel<=11000) {
        self.lblIndexInnerLeft1.text = @"+1";
    } else if (intInnerFuel<=13000) {
        self.lblIndexInnerLeft1.text = @"+2";
    } else if (intInnerFuel<=14000) {
        if (intDensity <= 760) {
            self.lblIndexInnerLeft1.text = @"+3";
        } else {
            self.lblIndexInnerLeft1.text = @"+2";
        }
    } else if (intInnerFuel<=16000) {
        self.lblIndexInnerLeft1.text = @"+3";
    } else if (intInnerFuel<=17000) {
        self.lblIndexInnerLeft1.text = @"+4";
    } else if (intInnerFuel<=18000) {
        if (intDensity <= 770) {
            self.lblIndexInnerLeft1.text = @"+5";
        } else {
            self.lblIndexInnerLeft1.text = @"+4";
        }
    } else if (intInnerFuel<=20000) {
        self.lblIndexInnerLeft1.text = @"+5";
    } else
        if (intDensity <= 815) {
            self.lblIndexInnerLeft1.text = @"+5";
        } else {
            self.lblIndexInnerLeft1.text = @"+6";
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
    self.progFuelInnerLeft1.progress = (float)intInnerFuel/(float)((24716*intDensity)/1000);
    NSLog(@"%f", (float)intInnerFuel/(float)((24716*intDensity)/1000));
}

-(void)indexInnerTankLeft2
{
    NSInteger intInnerFuel = [self.txtInnerFuelLeft2.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intInnerFuel==0) {
        self.lblIndexInnerLeft2.text = @"0";
    }else if (intInnerFuel<=1000) {
        self.lblIndexInnerLeft2.text = @"0";
    } else if (intInnerFuel<=2000) {
        self.lblIndexInnerLeft2.text = @"-1";
    } else if (intInnerFuel<=4000) {
        self.lblIndexInnerLeft2.text = @"-2";
    } else if (intInnerFuel<=6000) {
        self.lblIndexInnerLeft2.text = @"-3";
    } else if (intInnerFuel<=8000) {
        self.lblIndexInnerLeft2.text = @"-4";
    } else if (intInnerFuel<=10000) {
        self.lblIndexInnerLeft2.text = @"-5";
    } else if (intInnerFuel<=12000) {
        self.lblIndexInnerLeft2.text = @"-6";
    } else if (intInnerFuel<=14000) {
        self.lblIndexInnerLeft2.text = @"-7";
    } else if (intInnerFuel<=15000) {
        self.lblIndexInnerLeft2.text = @"-8";
    } else if (intInnerFuel<=17000) {
        self.lblIndexInnerLeft2.text = @"-9";
    } else if (intInnerFuel<=19000) {
        self.lblIndexInnerLeft2.text = @"-10";
    } else if (intInnerFuel<=21000) {
        self.lblIndexInnerLeft2.text = @"-11";
    } else if (intInnerFuel<=23000) {
        self.lblIndexInnerLeft2.text = @"-12";
    } else if (intInnerFuel<=25000) {
        self.lblIndexInnerLeft2.text = @"-13";
    } else if (intInnerFuel<=26000) {
        self.lblIndexInnerLeft2.text = @"-14";
    } else if (intInnerFuel<=27000) {
        if (intDensity <= 805) {
            self.lblIndexInnerLeft2.text = @"-14";
        } else {
            self.lblIndexInnerLeft2.text = @"-15";
        }
    } else if (intInnerFuel<=28000) {
        self.lblIndexInnerLeft2.text = @"-15";
        
    } else
        if (intDensity <= 780) {
            self.lblIndexInnerLeft2.text = @"-14";
        } else {
            self.lblIndexInnerLeft2.text = @"-15";
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
    self.progFuelInnerLeft2.progress = (float)intInnerFuel/(float)((34805*intDensity)/1000);
    NSLog(@"%f", (float)intInnerFuel/(float)((34805*intDensity)/1000));
}

-(void)indexOuterTankRight
{
    NSInteger intOuterFuel = [self.txtOuterFuelLeft.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intOuterFuel<=500) {
        self.lblIndexOuterRight.text = @"0";
    } else if (intOuterFuel<=1000) {
        self.lblIndexOuterRight.text = @"+1";
    } else if (intOuterFuel<=1500) {
        self.lblIndexOuterRight.text = @"+2";
    } else if (intOuterFuel<=2000) {
        self.lblIndexOuterRight.text = @"+2";
    } else if (intOuterFuel<=2500) {
        self.lblIndexOuterRight.text = @"+3";
    } else if (intOuterFuel<=3000) {
        self.lblIndexOuterRight.text = @"+3";
    } else if (intOuterFuel<=3500) {
        self.lblIndexOuterRight.text = @"+4";
    } else if (intOuterFuel<=4000) {
        self.lblIndexOuterRight.text = @"+5";
    } else if (intOuterFuel<=4500) {
        self.lblIndexOuterRight.text = @"+5";
    } else if (intOuterFuel<=5000) {
        self.lblIndexOuterRight.text = @"+6";
    } else
        self.lblIndexOuterRight.text = @"+6";
    
    
    
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
    self.progFuelOuterRight.progress = (float)intOuterFuel/((6310*intDensity)/1000);
}

-(void)indexOuterTankLeft
{
    NSInteger intOuterFuel = [self.txtOuterFuelLeft.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intOuterFuel<=500) {
        self.lblIndexOuterLeft.text = @"0";
    } else if (intOuterFuel<=1000) {
        self.lblIndexOuterLeft.text = @"+1";
    } else if (intOuterFuel<=2000) {
        self.lblIndexOuterLeft.text = @"+2";
    } else if (intOuterFuel<=3000) {
        self.lblIndexOuterLeft.text = @"+3";
    } else if (intOuterFuel<=3500) {
        self.lblIndexOuterLeft.text = @"+4";
    } else if (intOuterFuel<=4500) {
        self.lblIndexOuterLeft.text = @"+5";
    } else
        self.lblIndexOuterLeft.text = @"+6";
    
    
    
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
    self.progFuelOuterLeft.progress = (float)intOuterFuel/((6310*intDensity)/1000);
}
-(void)indexCenterTank
{
    NSInteger intCenterFuel = [self.txtCenterFuel.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intCenterFuel==0) {
        self.lblIndexCenterTank.text = @"0";
    }else if (intCenterFuel<=1000) {
        self.lblIndexCenterTank.text = @"0";
    } else if (intCenterFuel<=2000) {
        self.lblIndexCenterTank.text = @"-1";
    } else if (intCenterFuel<=3000) {
        self.lblIndexCenterTank.text = @"-1";
    } else if (intCenterFuel<=4000) {
        self.lblIndexCenterTank.text = @"-2";
    } else if (intCenterFuel<=5000) {
        self.lblIndexCenterTank.text = @"-2";
    } else if (intCenterFuel<=6000) {
        self.lblIndexCenterTank.text = @"-3";
    } else if (intCenterFuel<=7000) {
        self.lblIndexCenterTank.text = @"-4";
    } else if (intCenterFuel<=8000) {
        self.lblIndexCenterTank.text = @"-4";
    } else if (intCenterFuel<=9000) {
        self.lblIndexCenterTank.text = @"-5";
    } else if (intCenterFuel<=10000) {
        self.lblIndexCenterTank.text = @"-6";
    } else if (intCenterFuel<=11000) {
        self.lblIndexCenterTank.text = @"-6";
    } else if (intCenterFuel<=12000) {
        self.lblIndexCenterTank.text = @"-7";
    } else if (intCenterFuel<=13000) {
        self.lblIndexCenterTank.text = @"-8";
    } else if (intCenterFuel<=14000) {
        self.lblIndexCenterTank.text = @"-8";
    } else if (intCenterFuel<=15000) {
        self.lblIndexCenterTank.text = @"-9";
    } else if (intCenterFuel<=16000) {
        self.lblIndexCenterTank.text = @"-10";
    } else if (intCenterFuel<=17000) {
        self.lblIndexCenterTank.text = @"-11";
    } else if (intCenterFuel<=18000) {
        self.lblIndexCenterTank.text = @"-12";
    } else if (intCenterFuel<=19000) {
        self.lblIndexCenterTank.text = @"-12";
    } else if (intCenterFuel<=20000) {
        self.lblIndexCenterTank.text = @"-13";
    } else if (intCenterFuel<=21000) {
        self.lblIndexCenterTank.text = @"-14";
    } else if (intCenterFuel<=22000) {
        self.lblIndexCenterTank.text = @"-14";
    } else if (intCenterFuel<=23000) {
        self.lblIndexCenterTank.text = @"-15";
    } else if (intCenterFuel<=24000) {
        self.lblIndexCenterTank.text = @"-16";
    } else if (intCenterFuel<=25000) {
        self.lblIndexCenterTank.text = @"-16";
    } else if (intCenterFuel<=26000) {
        self.lblIndexCenterTank.text = @"-17";
    } else if (intCenterFuel<=27000) {
        self.lblIndexCenterTank.text = @"-18";
    } else if (intCenterFuel<=28000) {
        self.lblIndexCenterTank.text = @"-19";
    } else if (intCenterFuel<=29000) {
        self.lblIndexCenterTank.text = @"-19";
    } else if (intCenterFuel<=30000) {
        self.lblIndexCenterTank.text = @"-20";
    } else if (intCenterFuel<=31000) {
        self.lblIndexCenterTank.text = @"-21";
    } else if (intCenterFuel<=32000) {
        self.lblIndexCenterTank.text = @"-21";
    } else if (intCenterFuel<=33000) {
        self.lblIndexCenterTank.text = @"-22";
    } else if (intCenterFuel<=34000) {
        self.lblIndexCenterTank.text = @"-23";
    } else if (intCenterFuel<=35000) {
        if (intDensity <= 800) {
            self.lblIndexCenterTank.text = @"-24";
        } else {
            self.lblIndexCenterTank.text = @"-23";
        }
    } else if (intCenterFuel<=36000) {
        if (intDensity <= 760) {
            self.lblIndexCenterTank.text = @"-25";
        } else {
            self.lblIndexCenterTank.text = @"-24";
        }
    } else if (intCenterFuel<=37000) {
        self.lblIndexCenterTank.text = @"-25";
    } else if (intCenterFuel<=38000) {
        self.lblIndexCenterTank.text = @"-26";
    } else if (intCenterFuel<=39000) {
        self.lblIndexCenterTank.text = @"-27";
    } else if (intCenterFuel<=40000) {
        if (intDensity <= 810) {
            self.lblIndexCenterTank.text = @"-28";
        } else {
            self.lblIndexCenterTank.text = @"-27";
        }
    } else if (intCenterFuel<=41000) {
        if (intDensity <= 795) {
            self.lblIndexCenterTank.text = @"-29";
        } else {
            self.lblIndexCenterTank.text = @"-28";
        }
    } else if (intCenterFuel<=42000) {
        if (intDensity <= 795) {
            self.lblIndexCenterTank.text = @"-30";
        } else {
            self.lblIndexCenterTank.text = @"-29";
        }
    } else if (intCenterFuel<=43000) {
        if (intDensity <= 795) {
            self.lblIndexCenterTank.text = @"-31";
        } else {
            self.lblIndexCenterTank.text = @"-30";
        }
    } else if (intCenterFuel<=44000) {
        if (intDensity <= 800) {
            self.lblIndexCenterTank.text = @"-32";
        } else {
            self.lblIndexCenterTank.text = @"-31";
        }
    } else if (intCenterFuel<=45000) {
        self.lblIndexCenterTank.text = @"-32";
    } else
        if (intDensity <= 770) {
            self.lblIndexCenterTank.text = @"-30";
        } else if (intDensity <= 795) {
            self.lblIndexCenterTank.text = @"-31";
        } else if (intDensity <= 820) {
            self.lblIndexCenterTank.text = @"-32";
        } else {
            self.lblIndexCenterTank.text = @"-33";
        }
    
    
    self.progFuelCenterTank.progress = (float)intCenterFuel/((55133*intDensity)/1000);
    
}
-(void)indexCenterREARTank
{
    NSInteger intCenterFuel = [self.txtCenterFuel.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intCenterFuel==0) {
        self.lblIndexCenterRearTank.text = @"0";
    }else if (intCenterFuel<=1000) {
        self.lblIndexCenterRearTank.text = @"+1";
    } else if (intCenterFuel<=2000) {
        self.lblIndexCenterRearTank.text = @"+2";
    } else if (intCenterFuel<=3000) {
        self.lblIndexCenterRearTank.text = @"+3";
    } else if (intCenterFuel<=4000) {
        self.lblIndexCenterRearTank.text = @"+4";
    } else if (intCenterFuel<=5000) {
        self.lblIndexCenterRearTank.text = @"+6";
    } else if (intCenterFuel<=6000) {
        self.lblIndexCenterRearTank.text = @"+7";
    } else if (intCenterFuel<=7000) {
        self.lblIndexCenterRearTank.text = @"+8";
    } else if (intCenterFuel<=8000) {
        self.lblIndexCenterRearTank.text = @"+9";
    } else if (intCenterFuel<=9000) {
        self.lblIndexCenterRearTank.text = @"+10";
    } else if (intCenterFuel<=10000) {
        self.lblIndexCenterRearTank.text = @"+11";
    } else if (intCenterFuel<=11000) {
        self.lblIndexCenterRearTank.text = @"+12";
    } else if (intCenterFuel<=12000) {
        self.lblIndexCenterRearTank.text = @"+13";
    } else if (intCenterFuel<=13000) {
        self.lblIndexCenterRearTank.text = @"+14";
    } else if (intCenterFuel<=14000) {
        self.lblIndexCenterRearTank.text = @"+16";
    } else if (intCenterFuel<=15000) {
        self.lblIndexCenterRearTank.text = @"+17";
    } else if (intCenterFuel<=16000) {
        self.lblIndexCenterRearTank.text = @"+18";
    } else
        if (intDensity <= 795) {
            self.lblIndexCenterRearTank.text = @"+17";
        }else if (intDensity <= 780) {
            self.lblIndexCenterRearTank.text = @"+18";
        }
    
    self.progFuelCenterRearTank.progress = (float)intCenterFuel/((19741*intDensity)/1000);
    
}


-(void)indexTrimTank
{
    NSInteger intTrimFuel = [self.txtTrimFuel.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intTrimFuel==0) {
        self.lblIndexTrimTank.text = @"0";
    } else if (intTrimFuel<=250) {
        self.lblIndexTrimTank.text = @"+1";
    } else if (intTrimFuel<=500) {
        self.lblIndexTrimTank.text = @"+3";
    } else if (intTrimFuel<=750) {
        self.lblIndexTrimTank.text = @"+4";
    } else if (intTrimFuel<=1000) {
        self.lblIndexTrimTank.text = @"+6";
    } else if (intTrimFuel<=1250) {
        self.lblIndexTrimTank.text = @"+7";
    } else if (intTrimFuel<=1500) {
        self.lblIndexTrimTank.text = @"+9";
    } else if (intTrimFuel<=1750) {
        self.lblIndexTrimTank.text = @"+10";
    } else if (intTrimFuel<=2000) {
        self.lblIndexTrimTank.text = @"+12";
    } else if (intTrimFuel<=2250) {
        self.lblIndexTrimTank.text = @"+13";
    } else if (intTrimFuel<=2500) {
        self.lblIndexTrimTank.text = @"+15";
    } else if (intTrimFuel<=2750) {
        self.lblIndexTrimTank.text = @"+16";
    } else if (intTrimFuel<=3000) {
        self.lblIndexTrimTank.text = @"+18";
    } else if (intTrimFuel<=3250) {
        self.lblIndexTrimTank.text = @"+19";
    } else if (intTrimFuel<=3500) {
        self.lblIndexTrimTank.text = @"+21";
    } else if (intTrimFuel<=3750) {
        self.lblIndexTrimTank.text = @"+22";
    } else if (intTrimFuel<=4000) {
        self.lblIndexTrimTank.text = @"+24";
    } else if (intTrimFuel<=4250) {
        self.lblIndexTrimTank.text = @"+25";
    } else if (intTrimFuel<=4500) {
        self.lblIndexTrimTank.text = @"+27";
    } else if (intTrimFuel<=4750) {
        self.lblIndexTrimTank.text = @"+29";
    } else if (intTrimFuel<=5000) {
        self.lblIndexTrimTank.text = @"+30";
    } else if (intTrimFuel<=5250) {
        self.lblIndexTrimTank.text = @"+32";
    } else if (intTrimFuel<=5500) {
        self.lblIndexTrimTank.text = @"+33";
    } else if (intTrimFuel<=5750) {
        self.lblIndexTrimTank.text = @"+35";
    } else if (intTrimFuel<=6000) {
        self.lblIndexTrimTank.text = @"+36";
    } else if (intTrimFuel<=6250) {
        self.lblIndexTrimTank.text = @"+38";
    } else if (intTrimFuel<=6500) {
        self.lblIndexTrimTank.text = @"+40";
    } else
        if (intDensity <= 760) {
            self.lblIndexTrimTank.text = @"+36";
        }else if (intDensity <= 780) {
            self.lblIndexTrimTank.text = @"+37";
        }else if (intDensity <= 800) {
            self.lblIndexTrimTank.text = @"+38";
        }else if (intDensity <= 820) {
            self.lblIndexTrimTank.text = @"+39";
        }else {
            self.lblIndexTrimTank.text = @"+40";
        }
    
    self.progFuelTrimTank.progress = (float)intTrimFuel/((7886*intDensity)/1000);
}
-(void)indexInnerTankRight3
{
    NSInteger intInnerFuel = [self.txtInnerFuelLeft2.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intInnerFuel==0) {
        self.lblIndexInnerRight3.text = @"0";
    }else if (intInnerFuel<=1000) {
        self.lblIndexInnerRight3.text = @"0";
    } else if (intInnerFuel<=2000) {
        self.lblIndexInnerRight3.text = @"-1";
    } else if (intInnerFuel<=4000) {
        self.lblIndexInnerRight3.text = @"-2";
    } else if (intInnerFuel<=6000) {
        self.lblIndexInnerRight3.text = @"-3";
    } else if (intInnerFuel<=8000) {
        self.lblIndexInnerRight3.text = @"-4";
    } else if (intInnerFuel<=10000) {
        self.lblIndexInnerRight3.text = @"-5";
    } else if (intInnerFuel<=12000) {
        self.lblIndexInnerRight3.text = @"-6";
    } else if (intInnerFuel<=14000) {
        self.lblIndexInnerRight3.text = @"-7";
    } else if (intInnerFuel<=15000) {
        self.lblIndexInnerRight3.text = @"-8";
    } else if (intInnerFuel<=17000) {
        self.lblIndexInnerRight3.text = @"-9";
    } else if (intInnerFuel<=19000) {
        self.lblIndexInnerRight3.text = @"-10";
    } else if (intInnerFuel<=21000) {
        self.lblIndexInnerRight3.text = @"-11";
    } else if (intInnerFuel<=23000) {
        self.lblIndexInnerRight3.text = @"-12";
    } else if (intInnerFuel<=25000) {
        self.lblIndexInnerRight3.text = @"-13";
    } else if (intInnerFuel<=26000) {
        self.lblIndexInnerRight3.text = @"-14";
    } else if (intInnerFuel<=27000) {
        if (intDensity <= 805) {
            self.lblIndexInnerRight3.text = @"-14";
        } else {
            self.lblIndexInnerRight3.text = @"-15";
        }
    } else if (intInnerFuel<=28000) {
        self.lblIndexInnerRight3.text = @"-15";
        
    } else
        if (intDensity <= 780) {
            self.lblIndexInnerRight3.text = @"-14";
        } else {
            self.lblIndexInnerRight3.text = @"-15";
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
    self.progFuelInnerRight3.progress = (float)intInnerFuel/(float)((34805*intDensity)/1000);
    NSLog(@"%f", (float)intInnerFuel/(float)((34805*intDensity)/1000));
}

-(void)indexInnerTankRight4
{
    NSInteger intInnerFuel = [self.txtInnerFuelLeft1.text doubleValue];
    NSInteger intDensity = [[self.lblDensity.text substringWithRange:NSMakeRange(2, 3)] intValue];
    if (intInnerFuel==0) {
        self.lblIndexInnerRight4.text = @"0";
    }else if (intInnerFuel<=6000) {
        self.lblIndexInnerRight4.text = @"0";
    } else if (intInnerFuel<=7000) {
        if (intDensity <= 775) {
            self.lblIndexInnerRight4.text = @"+1";
        } else {
            self.lblIndexInnerRight4.text = @"0";
        }
    } else if (intInnerFuel<=11000) {
        self.lblIndexInnerRight4.text = @"+1";
    } else if (intInnerFuel<=13000) {
        self.lblIndexInnerRight4.text = @"+2";
    } else if (intInnerFuel<=14000) {
        if (intDensity <= 760) {
            self.lblIndexInnerRight4.text = @"+3";
        } else {
            self.lblIndexInnerRight4.text = @"+2";
        }
    } else if (intInnerFuel<=16000) {
        self.lblIndexInnerRight4.text = @"+3";
    } else if (intInnerFuel<=17000) {
        self.lblIndexInnerRight4.text = @"+4";
    } else if (intInnerFuel<=18000) {
        if (intDensity <= 770) {
            self.lblIndexInnerRight4.text = @"+5";
        } else {
            self.lblIndexInnerRight4.text = @"+4";
        }
    } else if (intInnerFuel<=20000) {
        self.lblIndexInnerRight4.text = @"+5";
    } else
        if (intDensity <= 815) {
            self.lblIndexInnerRight4.text = @"+5";
        } else {
            self.lblIndexInnerRight4.text = @"+6";
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
    self.progFuelInnerRight4.progress = (float)intInnerFuel/(float)((24716*intDensity)/1000);
    NSLog(@"%f", (float)intInnerFuel/(float)((24716*intDensity)/1000));
    
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
