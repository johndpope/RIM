//
//  FuelUpliftViewController.m
//  uplift
//
//  Created by Michael Gehringer on 22.03.12.
//  Copyright (c) 2012 Mikelsoft.com. All rights reserved.
//

#define SCROLLVIEW_CONTENT_HEIGHT 568
#define SCROLLVIEW_CONTENT_WIDTH  320

#import "FuelUpliftViewController.h"
//#import "ReceiptsViewController.h"
//#import "Receipt.h"
#import "User.h"

@implementation FuelUpliftViewController



{
    UITabBarController *myTabBarController;
    NSString *weight;
    NSString *volume;
    NSString *density;
    NSString *specificSG;
    NSString *txtvolume;
    NSString *txtweight;
    NSArray *arrNumbers;
    NSArray *arrDensity;
}

@synthesize window = _window;
@synthesize delegate;
@synthesize txtFuelRemaining;
@synthesize txtFuelUpliftVolume;
@synthesize txtDensity;
@synthesize sldDensity;
@synthesize lblDensity;
@synthesize txtCalculatedUpliftWeight;
@synthesize txtTotalFuelCell;
@synthesize lblWeight5;
@synthesize txtDepartureFuelCell;
@synthesize txtDiscrepancy;
@synthesize lblWeight;
@synthesize lblWeight2;
@synthesize lblWeight3;
@synthesize lblWeight4;
@synthesize txtDiscrepancyPerc;
@synthesize lblVolume;
@synthesize lblSGDecimal;
@synthesize myTabBarController;
@synthesize popoverController;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
        
        NSLog(@"init FuelUpliftViewController");
       
        weight = @"kg";
        volume = @"ltr";
        density = @"kg/ltr";
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        weight = [[NSString alloc] initWithFormat:@"%@", [defaults objectForKey:@"mulValueWeight"]];
        volume = [[NSString alloc] initWithFormat:@"%@", [defaults objectForKey:@"mulValueVolume"]];
        density = [[NSString alloc] initWithFormat:@"%@", [defaults objectForKey:@"mulValueSG"]];
        if ([weight isEqualToString:@"(null)"]) {
            weight = @"kg";
        }
        if ([volume isEqualToString:@"(null)"]) {
            volume = @"ltr";
        }
        if ([density isEqualToString:@"(null)"]) {
            density = @"kg/ltr";
        }
        [self setWeightandVolumeFactors];
	}
	return self;
}

- (void) setWeightandVolumeFactors {

//    if ([[User sharedUser].specificSG isEqualToString:@"kg/ltr"]) {
    if ([density isEqualToString:@"kg/ltr"]) {
    
        if ([weight isEqualToString:@"kg"]) {
        [User sharedUser].intFactWeight = 1.0;
        [User sharedUser].strWeighttxt = @"kg";
        }
        if ([weight isEqualToString:@"lb"]) {
        [User sharedUser].intFactWeight = 2.204;
        [User sharedUser].strWeighttxt = @"lb";
        }
    
        if ([volume isEqualToString:@"ltr"]) {
        [User sharedUser].intFactVolume = 1.0;
        [User sharedUser].strVolumetxt = @"ltr";
        }
        if ([volume isEqualToString:@"usg"]) {
        [User sharedUser].intFactVolume = 3.785;
        [User sharedUser].strVolumetxt = @"usg";
        }
        if ([volume isEqualToString:@"ipg"]) {
        [User sharedUser].intFactVolume = 4.546;
        [User sharedUser].strVolumetxt = @"ipg";
        }
    
        txtvolume = [[NSString alloc] initWithFormat:@"%li", (long)[User sharedUser].intVolume];
        txtweight = [[NSString alloc] initWithFormat:@"%li", (long)[User sharedUser].intWeight];
    }else{
        
        if ([weight isEqualToString:@"kg"]) {
            [User sharedUser].intFactWeight = 0.453;
            [User sharedUser].strWeighttxt = @"kg";
        }
        if ([weight isEqualToString:@"lb"]) {
            [User sharedUser].intFactWeight = 1;
            [User sharedUser].strWeighttxt = @"lb";
        }
        
        if ([volume isEqualToString:@"ltr"]) {
            [User sharedUser].intFactVolume = 0.264;
            [User sharedUser].strVolumetxt = @"ltr";
        }
        if ([volume isEqualToString:@"usg"]) {
            [User sharedUser].intFactVolume = 1.0;
            [User sharedUser].strVolumetxt = @"usg";
        }
        if ([volume isEqualToString:@"ipg"]) {
            [User sharedUser].intFactVolume = 1.201;
            [User sharedUser].strVolumetxt = @"ipg";
        }
        
        txtvolume = [[NSString alloc] initWithFormat:@"%li", (long)[User sharedUser].intVolume];
        txtweight = [[NSString alloc] initWithFormat:@"%li", (long)[User sharedUser].intWeight];
    }

}

- (IBAction)CalculateUplift:(id)sender
{
    [self CalculateUplift];
}
- (IBAction)ResetReceipts:(id)sender
{
    [self ResetReceipts];
}
- (void) SetintVolume:(id)sender
{
    
}

- (void) ResetReceipts
{
    
    [receipts removeAllObjects];
    [User sharedUser].intVolume = 0;
    [User sharedUser].intWeight = 0;
    [User sharedUser].bolMultipleReceipts = NO;
    self.txtFuelUpliftVolume.font = [UIFont systemFontOfSize:21.f weight:UIFontWeightLight];
    [[[[[self tabBarController] viewControllers] objectAtIndex: 0] tabBarItem] setBadgeValue: Nil];
    [self CalculateUplift];
//    [self SetintVolume];
}

- (void)CalculateUplift
{

    NSLog(@"%f",[User sharedUser].intFactWeight);
    NSLog(@"%f",[User sharedUser].intFactVolume);
    NSLog(@"%f",[User sharedUser].intDensity);
    NSLog(@"%f",[[@"0." stringByAppendingFormat:@"%@",self.txtDensity.text] doubleValue]);

    if ([User sharedUser].bolMultipleReceipts == YES) {
        self.txtCalculatedUpliftWeight.text = [[NSString alloc] initWithFormat:@"%2.0li",(long)[User sharedUser].intWeight];
    } else {
        if ([density isEqualToString:@"kg/ltr"]) {
            [self setWeightandVolumeFactors];
            self.txtCalculatedUpliftWeight.text = [[NSString alloc] initWithFormat:@"%2.0f",[self.txtFuelUpliftVolume.text doubleValue] * [[@"0." stringByAppendingFormat:@"%@",self.txtDensity.text] doubleValue] * [User sharedUser].intFactVolume * [User sharedUser].intFactWeight];
        } else {
            [self setWeightandVolumeFactors];
            NSLog(@"%f",[User sharedUser].intFactWeight);
            NSLog(@"%f",[User sharedUser].intFactVolume);
            [User sharedUser].intDensity = [[[self.lblSGDecimal.text stringByAppendingString:@"."] stringByAppendingFormat:@"%@",self.txtDensity.text] doubleValue];
            NSLog(@"%f",[User sharedUser].intDensity);
            NSLog(@"%@",self.txtDensity.text);
            self.lblSGDecimal.text = [self.lblSGDecimal.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"%@",self.lblSGDecimal.text);
            NSLog(@"%@",[[self.lblSGDecimal.text stringByAppendingString:@"."] stringByAppendingFormat:@"%@",self.txtDensity.text]);
            self.txtCalculatedUpliftWeight.text = [[NSString alloc] initWithFormat:@"%2.0f",[self.txtFuelUpliftVolume.text doubleValue] * [[[[self.lblSGDecimal.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@"."] stringByAppendingFormat:@"%@",self.txtDensity.text] doubleValue] * [User sharedUser].intFactVolume * [User sharedUser].intFactWeight];
        }
    }
    self.txtTotalFuelCell.text = [[NSString alloc] initWithFormat:@"%2.0i",[self.txtFuelRemaining.text intValue] + [self.txtCalculatedUpliftWeight.text intValue]];
    if ([self.txtDepartureFuelCell.text isEqualToString:@"0"]) {
        
    } else {
        [self CalculateDiscrepancy];
    }
//    [self SetintVolume];
}

- (void)applyPaddedFooter {
	UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 50)];
	footer.backgroundColor = [UIColor clearColor];
	self.tableView.tableFooterView = footer;
}

- (IBAction)clearDensityField:(id)sender
{
    self.txtDensity.text = @"";
}
- (IBAction)CalculateDiscrepancy:(id)sender
{
    [self CalculateDiscrepancy];
}
- (void)CalculateDiscrepancy
{
    double c = [txtTotalFuelCell.text doubleValue]-[txtDepartureFuelCell.text doubleValue];
//	txtFuelDiscrep.text = [[NSString alloc]initWithFormat:@"%2.1f", c];
    double p = ((([self.txtDepartureFuelCell.text doubleValue]-[self.txtFuelRemaining.text doubleValue])-[self.txtCalculatedUpliftWeight.text doubleValue])/([self.txtDepartureFuelCell.text doubleValue]-[self.txtFuelRemaining.text doubleValue]))*100;
    self.txtDiscrepancy.text = [[NSString alloc]initWithFormat:@"%2.0f", c];
    self.txtDiscrepancyPerc.text = [[NSString alloc]initWithFormat:@"%2.2f", p];
}

- (IBAction)sliderWasChanged:(id)sender
{
    if ([density isEqualToString:@"kg/ltr"]) {
        self.sldDensity.minimumValue = 700;
        self.sldDensity.maximumValue = 900;
        self.txtDensity.text= [[NSString alloc] initWithFormat:@"%d ", (int)self.sldDensity.value];
    }else{
        self.sldDensity.minimumValue = 5800;
        self.sldDensity.maximumValue = 7500;
        self.txtDensity.text= [[[NSString alloc] initWithFormat:@"%i ", (int)self.sldDensity.value] substringFromIndex:1];
        self.lblSGDecimal.text = [[NSString alloc] initWithFormat:@"%1.0f ", floor((int)self.sldDensity.value/1000)];
    }
    NSLog(@"%@",[[NSString alloc] initWithFormat:@"%d ", (int)self.sldDensity.value]);
    
}
- (IBAction)DensityFieldChanged:(id)sender
{
    if ([density isEqualToString:@"kg/ltr"] ) {
        
        if ([self.txtDensity.text length] == 1) {
            self.sldDensity.value = ([self.txtDensity.text doubleValue]*100);
        } else {
            if ([self.txtDensity.text length] == 2) {
                self.sldDensity.value = ([self.txtDensity.text doubleValue]*10);
            } else {
                if ([self.txtDensity.text length] == 3) {
                    self.sldDensity.value = [self.txtDensity.text doubleValue];
                }else{
                    if ([self.txtDensity.text length] == 0) {
                        self.txtDensity.text = @"000";
                        self.sldDensity.value = [self.txtDensity.text doubleValue];
                    } else {
                        self.txtDensity.text = [self.txtDensity.text substringToIndex:3];
                        self.sldDensity.value = [self.txtDensity.text doubleValue];
                    }
                }
            }
        }
    } else {
        if ([self.txtDensity.text length] == 1) {
            self.sldDensity.value = ([self.txtDensity.text doubleValue]*100) + [[self.lblSGDecimal.text substringToIndex:1] intValue]*1000;
        } else {
            if ([self.txtDensity.text length] == 2) {
                self.sldDensity.value = ([self.txtDensity.text doubleValue]*10)+ [[self.lblSGDecimal.text substringToIndex:1] intValue]*1000;
            } else {
                if ([self.txtDensity.text length] == 3) {
                    self.sldDensity.value = [self.txtDensity.text doubleValue]+ [[self.lblSGDecimal.text substringToIndex:1] intValue]*1000;
                }else{
                    if ([self.txtDensity.text length] == 0) {
                        self.txtDensity.text = @"000";
                        self.sldDensity.value = [self.txtDensity.text doubleValue] + [[self.lblSGDecimal.text substringToIndex:1] intValue]*1000;
                    } else {
                        self.txtDensity.text = [self.txtDensity.text substringToIndex:3];                    self.sldDensity.value = [self.txtDensity.text doubleValue] + [[self.lblSGDecimal.text substringToIndex:1] intValue]*1000;
                    }
                }
            }
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self applyPaddedFooter];
    self.lblWeight.text = weight;
    self.lblWeight2.text = weight;
    self.lblWeight3.text = weight;
    self.lblWeight4.text = weight;
    self.lblWeight5.text = weight;
    self.lblVolume.text = volume;
    self.txtFuelUpliftVolume.text = txtvolume;
//    self.txtFuelUpliftVolume.text = @"000000";

    arrNumbers = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    arrDensity = [NSArray arrayWithObjects:@"7", @"8", @"9", nil];
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    if ([density isEqualToString:@"kg/ltr"]) {
        self.lblDensity.text = @"kg/ltr";
        self.lblSGDecimal.text = @"0";
        self.sldDensity.minimumValue = 700;
        self.sldDensity.maximumValue = 900;
        [User sharedUser].intDensity = 0.790;
        [User sharedUser].strlblDensity = @"kg/ltr";
    }else{
        self.lblDensity.text = @"lb/usg";
        self.lblSGDecimal.text = @"6";
        self.sldDensity.minimumValue = 5800;
        self.sldDensity.maximumValue = 7500;
        self.sldDensity.value = 6400;
        [User sharedUser].intDensity = 6.400;
        [User sharedUser].strlblDensity = @"lb/usg";
    }
        [User sharedUser].bolMultipleReceipts = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
    }
    receipts = [NSMutableArray arrayWithCapacity:20];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (void)viewDidUnload
{
    [self setTxtFuelRemaining:nil];
    [self setTxtFuelUpliftVolume:nil];
    [self setTxtDensity:nil];
    [self setSldDensity:nil];
    [self setTxtCalculatedUpliftWeight:nil];
    [self setTxtTotalFuelCell:nil];
    [self setTxtDepartureFuelCell:nil];
    [self setTxtDiscrepancy:nil];
    [self setLblWeight:nil];
    [self setLblWeight2:nil];
    [self setLblWeight3:nil];
    [self setLblWeight4:nil];
    [self setLblWeight5:nil];
    [self setLblVolume:nil];
    [self setLblWeight5:nil];
    [self setTxtDiscrepancyPerc:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.txtFuelRemaining)
    {
        [self showPickerFuelRemaining:self];
        return NO;
    }
    if (textField == self.txtFuelUpliftVolume)
    {
        [self showPickerFuelVolumeUplift:self];
        return NO;
    }
    if (textField == self.txtDensity)
    {
        [self showPickerFuelDensity:self];
        return NO;
    }
    if (textField == self.txtDepartureFuelCell)
    {
        [self showPickerFuelDeparture:self];
        return NO;
    }

    return NO;
}
#pragma mark- IBAction

- (IBAction)DoneTapped:(id)sender {
    [txtFuelUpliftVolume resignFirstResponder];
    [txtDensity resignFirstResponder];
    [txtDepartureFuelCell resignFirstResponder];
    [txtFuelRemaining resignFirstResponder];
}

- (IBAction)CancelTapped:(id)sender {
    [txtFuelRemaining resignFirstResponder];
}

- (void)doneButton:(id)sender {
	
	[txtFuelUpliftVolume resignFirstResponder];
	[txtDensity resignFirstResponder];
	[txtDepartureFuelCell resignFirstResponder];
    [txtFuelRemaining resignFirstResponder];
}
- (void) didUpdateData {
    self.lblWeight.text = weight;
    self.lblWeight2.text = weight;
    self.lblWeight3.text = weight;
    self.lblWeight4.text = weight;
    self.lblWeight5.text = weight;
    self.lblVolume.text = volume;

    if ([density isEqualToString:@"kg/ltr"]) {
        self.lblDensity.text = @"kg/ltr";
        self.lblSGDecimal.text = @"0";
        self.sldDensity.minimumValue = 700;
        self.sldDensity.maximumValue = 900;
    }else{
        self.lblDensity.text = @"lb/usg";
        self.lblSGDecimal.text = @"6";
        self.sldDensity.minimumValue = 5800;
        self.sldDensity.maximumValue = 7500;
        self.sldDensity.value = [User sharedUser].intDensity * 1000;
        self.txtDensity.text= [[[NSString alloc] initWithFormat:@"%i ", (int)self.sldDensity.value] substringFromIndex:1];
        self.lblSGDecimal.text = [[NSString alloc] initWithFormat:@"%1.0f ", floor((int)self.sldDensity.value/1000)];
    }
    self.txtFuelUpliftVolume.text = [[NSString alloc] initWithFormat:@"%li", (long)[User sharedUser].intVolume];
//    self.txtFuelUpliftVolume.text = @"000000";
    if ([self.txtFuelUpliftVolume.text isEqualToString:@"0"]) {
        
    } else {

            //            double dblWeight = [User sharedUser].intWeight*[User sharedUser].intFactWeight;
            double dblVolume = [User sharedUser].intVolume/[User sharedUser].intFactVolume;
            double dblDensity = [[[[self.lblSGDecimal.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@"."] stringByAppendingFormat:@"%@",self.txtDensity.text] doubleValue];
            self.txtCalculatedUpliftWeight.text = [[NSString alloc] initWithFormat:@"%f", dblVolume * dblDensity *  [User sharedUser].intFactWeight];
    }
    [self CalculateUplift];
}

- (void)keyboardDidShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        NSLog(@"Keyboard is visible");
        // If keyboard is visible, return
        if (keyboardVisible) {
            NSLog(@"Keyboard is already visible. Ignore notification.");
            return;
        }
        keyboardVisible = YES;
    }
}
-(void) keyboardDidHide: (NSNotification *)note {
	// Is the keyboard already shown
	if (!keyboardVisible) {
		NSLog(@"Keyboard is already hidden. Ignore notification.");
		return;
	}
    // Reset the frame scroll view to its original value
    self.tableView.frame = CGRectMake(0, 0, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
    keyboardVisible = NO;

}
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    self.txtFuelUpliftVolume.text = [[NSString alloc] initWithFormat:@"%li", (long)[User sharedUser].intVolume];
//    self.txtFuelUpliftVolume.text = @"000000";
    if ([self.txtFuelUpliftVolume.text isEqualToString:@"0"]) {
        
    } else {
            //            double dblWeight = [User sharedUser].intWeight*[User sharedUser].intFactWeight;
            double dblVolume = [User sharedUser].intVolume/[User sharedUser].intFactVolume;
            double dblDensity = [[[[self.lblSGDecimal.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@"."] stringByAppendingFormat:@"%@",self.txtDensity.text] doubleValue];
            
            self.txtCalculatedUpliftWeight.text = [[NSString alloc] initWithFormat:@"%f", dblVolume * dblDensity *  [User sharedUser].intFactWeight];
            
    }
    
    [self CalculateUplift];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector (keyboardDidHide:)
         name: UIKeyboardDidHideNotification
         object:nil];
    }
    [self.tableView reloadData];

    if ([density isEqualToString:@"kg/ltr"]) {
        self.lblDensity.text = @"kg/ltr";
        self.lblSGDecimal.text = @"0";
        self.sldDensity.minimumValue = 700;
        self.sldDensity.maximumValue = 900;
    }else{
        self.lblDensity.text = @"lb/usg";
        self.lblSGDecimal.text = @"6";
        self.sldDensity.minimumValue = 5800;
        self.sldDensity.maximumValue = 7500;
        self.sldDensity.value = [User sharedUser].intDensity * 1000;
        self.txtDensity.text= [[[NSString alloc] initWithFormat:@"%i ", (int)self.sldDensity.value] substringFromIndex:1];
        self.lblSGDecimal.text = [[NSString alloc] initWithFormat:@"%1.0f ", floor((int)self.sldDensity.value/1000)];
    }
    [self DensityFieldChanged:self];
    [self CalculateUplift];
}

    
-(void) viewWillDisappear:(BOOL)animated {
        NSLog (@"Unregister for keyboard events");
        [[NSNotificationCenter defaultCenter]
         removeObserver:self];
    if ([User sharedUser].bolMultipleReceipts == NO) {
        [User sharedUser].intVolume = [self.txtFuelUpliftVolume.text intValue];
        [User sharedUser].intWeight = [self.txtCalculatedUpliftWeight.text intValue];
    }
	keyboardVisible = NO;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"segShowWeight"])
	{
		WeightsViewController *weightsViewController = 
        segue.destinationViewController;
		weightsViewController.delegate = self;
		weightsViewController.weight = weight;
//        [self ResetReceipts];

	}
    
    if ([segue.identifier isEqualToString:@"segShowDensity"])
	{
		DensityViewController *densityViewController =
        segue.destinationViewController;
		densityViewController.delegate = self;
		densityViewController.density = density;
//        [self ResetReceipts];
	}
    if ([segue.identifier isEqualToString:@"segShowVolume"])
    {
        VolumesViewController *volumesViewController =
        segue.destinationViewController;
        volumesViewController.delegate = self;
        volumesViewController.volume = volume;
        //        [self ResetReceipts];
    }

 
}



#pragma mark - WeightVolumeViewControllerDelegate

- (void)weightsViewController:(WeightsViewController *)controller didSelectWeight:(NSString *)theWeight
{
	weight = theWeight;
	self.lblWeight.text = weight;
    self.lblWeight2.text = weight;
    self.lblWeight3.text = weight;
    self.lblWeight4.text = weight;
    self.lblWeight5.text = weight;
    
//	[self.navigationController popViewControllerAnimated:YES];
}
- (void)volumesViewController:(VolumesViewController *)controller didSelectVolume:(NSString *)theVolume
{
	volume = theVolume;
	self.lblVolume.text = volume;
    
//	[self.navigationController popViewControllerAnimated:YES];
}
- (void)densityViewController:(DensityViewController *)controller didSelectDensity:(NSString *)theDensity
{
	density = theDensity;
	self.lblDensity.text = density;
    
//	[self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0){
        if (row==0) {
            [self performSegueWithIdentifier:@"segShowWeight" sender:self];
        }
    }
    if(section == 1){
        if (row==0) {
            [self performSegueWithIdentifier:@"segShowVolume" sender:self];
        }
        if (row==1) {
            [self performSegueWithIdentifier:@"segShowDensity" sender:self];
        }
    }

}



#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
		return 1;
	}
	if (section == 1) {
		return 3;
	}
    if (section == 2) {
		return 1;
	}
    if (section == 3) {
		return 1;
	}
    if (section == 4) {
		return 1;
	}
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 10.0)];
    if (section==4) {
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        
        headerLabel.textColor = [UIColor blueColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont systemFontOfSize:11.f weight:UIFontWeightLight];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.frame = CGRectMake(10.0, 2.0, 300.0, 20.0);
        
        // If you want to align the header text as centered
        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
        
        headerLabel.text = @""; // i.e. array element
        [customView addSubview:headerLabel];
        
    }

    return customView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0){
		return @"Remaining Fuel";
	}
    if(section == 1){
		return @"Fuel Uplift:";
	}
	if(section == 2){
		return @"Total Fuel:";
	}
    if(section == 3){
		return @"Departure Fuel:";
	}
    if(section == 4){
        return @"Discrepancy:";
    }
	else
		return @"";
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	// create the parent view that will hold header Label
//	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
//	if (section==0) {
//        
//        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.opaque = NO;
//        
//        headerLabel.textColor = [UIColor darkGrayColor];
//        headerLabel.textColor = [UIColor darkGrayColor];
//        headerLabel.highlightedTextColor = [UIColor whiteColor];
//        headerLabel.font = [UIFont systemFontOfSize:14.f];
//        headerLabel.frame = CGRectMake(15.0, 5.0, 300.0, 25.0);
//        
//        // If you want to align the header text as centered
//        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//        
//        headerLabel.text = @"Fuel Remaining:"; // i.e. array element
//        [customView addSubview:headerLabel];
//        
//    }
//    if (section==1) {
//        
//        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.opaque = NO;
//        
//        headerLabel.textColor = [UIColor darkGrayColor];
//        headerLabel.highlightedTextColor = [UIColor whiteColor];
//        headerLabel.font = [UIFont systemFontOfSize:14.f];
//        headerLabel.frame = CGRectMake(15.0, 5.0, 300.0, 25.0);
////        headerLabel.frame = CGRectMake(1,2,3,4);
//        // If you want to align the header text as centered
//        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//        
//        headerLabel.text = @"Fuel Uplift:"; // i.e. array element
//        [customView addSubview:headerLabel];
//        
//    }
//    if (section==2) {
//        
//        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.opaque = NO;
//        
//        headerLabel.textColor = [UIColor darkGrayColor];
//        headerLabel.highlightedTextColor = [UIColor whiteColor];
//        headerLabel.font = [UIFont systemFontOfSize:14.f];
//        headerLabel.frame = CGRectMake(15.0, 5.0, 300.0, 25.0);
//        
//        // If you want to align the header text as centered
//        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//        
//        headerLabel.text = @"Total Fuel:"; // i.e. array element
////        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 45.0)];
//        [customView addSubview:headerLabel];
//        
//    }
//    if (section==3) {
//        
//        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.opaque = NO;
//        
//        headerLabel.textColor = [UIColor darkGrayColor];
//        headerLabel.highlightedTextColor = [UIColor whiteColor];
//        headerLabel.font = [UIFont systemFontOfSize:14.f];
//        headerLabel.frame = CGRectMake(15.0, 5.0, 300.0, 25.0);
//        
//        // If you want to align the header text as centered
//        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//        
//        headerLabel.text = @"Departure Fuel:"; // i.e. array element
//        [customView addSubview:headerLabel];
//        
//    }
//    
//    if (section==4) {
//        
//        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.opaque = NO;
//        
//        headerLabel.textColor = [UIColor darkGrayColor];
//        headerLabel.highlightedTextColor = [UIColor whiteColor];
//        headerLabel.font = [UIFont systemFontOfSize:14.f];
//        headerLabel.frame = CGRectMake(15.0, 5.0, 300.0, 25.0);
//        
//        // If you want to align the header text as centered
//        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//        
//        headerLabel.text = @"Fuel Discrepancy:"; // i.e. array element
//        [customView addSubview:headerLabel];
//        
//    }
//    
//	// create the button object
//    
//	return customView;
//}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 60.0;
    } else {
        return 30.0;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0.0;
    } else {
        return 0.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	
	if(section == 0){
		return @"";
	}
    if(section == 1){
		return @"";
	}
	if(section == 2){
		return @"";
	}
    if(section == 3){
		return @"";
	}
    else
		return @"";
}

#pragma mark - Remaining Fuel
#pragma mark -
#pragma mark UIPickerViewDataSource
#pragma mark - ABO Picker
#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *returnStr = @"";
        // note: custom picker doesn't care about titles, it uses custom views
    if (pickerView == _fuelPicker)
    {
        if (component == 0)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 1)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 2)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 3)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 4)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 5)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
    }
    if (pickerView == _fuelPickerVolumeUplift)
    {
        if (component == 0)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 1)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 2)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 3)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 4)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 5)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
    }
    if (pickerView == _fuelPickerDensity)
    {
        if (component == 0)
        {
            if ([[User sharedUser].strlblDensity isEqualToString: @"kg/ltr"]) {
                returnStr = [arrDensity objectAtIndex:row];
            }else{
                returnStr = [arrNumbers objectAtIndex:row];
            }
        }
        if (component == 1)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 2)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
    }
    if (pickerView == _fuelPickerDeparture)
    {
        if (component == 0)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 1)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 2)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 3)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 4)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
        if (component == 5)
        {
            returnStr = [arrNumbers objectAtIndex:row];
        }
    }


    
    
    
    return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = 0.0;
    
    componentWidth = 50.0;	// second column is narrower to show numbers
    
    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _fuelPickerDensity) {
        if ([[User sharedUser].strlblDensity isEqualToString: @"kg/ltr"]) {
            if (component==0) {
                return [arrDensity count];
            }
        }
    }
        return [arrNumbers count];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _fuelPickerDensity) {
        return 3;
    } else {
        return 6;
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (thePickerView == _fuelPicker) {
        self.txtFuelRemaining.text = [[[[[[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:0]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:1]]] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:2]]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:3]]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:4]]] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:5]]];
        self.txtFuelRemaining.text = [NSString stringWithFormat:@"%d", [self.txtFuelRemaining.text intValue]];
        [self result];
    }
    if (thePickerView == _fuelPickerVolumeUplift) {
        self.txtFuelUpliftVolume.text = [[[[[[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:0]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:1]]] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:2]]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:3]]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:4]]] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:5]]];
        self.txtFuelUpliftVolume.text = [NSString stringWithFormat:@"%d", [self.txtFuelUpliftVolume.text intValue]];
        [self result];
    }
    if (thePickerView == _fuelPickerDensity) {
        if ([[User sharedUser].strlblDensity isEqualToString: @"kg/ltr"]) {
        self.txtDensity.text = [[[NSString stringWithFormat:@"%ld", [thePickerView selectedRowInComponent:0]+7]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:1]]] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:2]]];
        }else{
            self.txtDensity.text = [[[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:0]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:1]]] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:2]]];
        }
            [self DensityFieldChanged:self];
            [self result];
    }
    if (thePickerView == _fuelPickerDeparture) {
        self.txtDepartureFuelCell.text = [[[[[[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:0]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:1]]] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:2]]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:3]]]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:4]]] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[thePickerView selectedRowInComponent:5]]];
        self.txtDepartureFuelCell.text = [NSString stringWithFormat:@"%d", [self.txtDepartureFuelCell.text intValue]];
        [self result];
    }

}


- (IBAction)showPickerFuelRemaining:(id)sender
{
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor clearColor];
    
    _fuelPicker=[[UIPickerView alloc]init];//Date picker
    _fuelPicker.frame=CGRectMake(0,30,320, 216);
    _fuelPicker.delegate = self;
    [_fuelPicker setTag:1];
    NSInteger int5 = 0;
    NSInteger int4 = 0;
    NSInteger int3 = 0;
    NSInteger int2 = 0;
    NSInteger int1 = 0;
    NSInteger int0 = 0;
    
    if ([self.txtFuelRemaining.text length] == 6) {
        int5 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(5, 1)] integerValue];
        int4 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(4, 1)] integerValue];
        int3 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(3, 1)] integerValue];
        int2 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPicker selectRow:int0 inComponent:0 animated:YES];
        [_fuelPicker selectRow:int1 inComponent:1 animated:YES];
        [_fuelPicker selectRow:int2 inComponent:2 animated:YES];
        [_fuelPicker selectRow:int3 inComponent:3 animated:YES];
        [_fuelPicker selectRow:int4 inComponent:4 animated:YES];
        [_fuelPicker selectRow:int5 inComponent:5 animated:YES];
        
    }
    if ([self.txtFuelRemaining.text length] == 5) {
        int4 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(4, 1)] integerValue];
        int3 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(3, 1)] integerValue];
        int2 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPicker selectRow:int0 inComponent:1 animated:YES];
        [_fuelPicker selectRow:int1 inComponent:2 animated:YES];
        [_fuelPicker selectRow:int2 inComponent:3 animated:YES];
        [_fuelPicker selectRow:int3 inComponent:4 animated:YES];
        [_fuelPicker selectRow:int4 inComponent:5 animated:YES];
    }
    if ([self.txtFuelRemaining.text length] == 4) {
        int3 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(3, 1)] integerValue];
        int2 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPicker selectRow:int0 inComponent:2 animated:YES];
        [_fuelPicker selectRow:int1 inComponent:3 animated:YES];
        [_fuelPicker selectRow:int2 inComponent:4 animated:YES];
        [_fuelPicker selectRow:int3 inComponent:5 animated:YES];
    }
    if ([self.txtFuelRemaining.text length] == 3) {
        int2 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPicker selectRow:int0 inComponent:3 animated:YES];
        [_fuelPicker selectRow:int1 inComponent:4 animated:YES];
        [_fuelPicker selectRow:int2 inComponent:5 animated:YES];
    }
    if ([self.txtFuelRemaining.text length] == 2) {
        int1 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPicker selectRow:int0 inComponent:4 animated:YES];
        [_fuelPicker selectRow:int1 inComponent:5 animated:YES];
        
    }
    if ([self.txtFuelRemaining.text length] == 1) {
        int0 = [[self.txtFuelRemaining.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPicker selectRow:int0 inComponent:5 animated:YES];
    }
    [popoverView addSubview:_fuelPicker];
    popoverContent.view = popoverView;
    CGRect myFrame =self.txtFuelRemaining.frame;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(hidePicker:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    [popoverView addSubview:toolBar];
    
//    popoverController = [[UIViewController alloc] init];
//    popoverController.modalPresentationStyle = UIModalPresentationPopover;
////    [popoverController setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
////    [popoverController presentPopoverFromRect:myFrame inView:self.tblvcFuelRemaining permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    UIPopoverPresentationController* pc = [popoverController popoverPresentationController];
//    pc.sourceView = self.view;
//    pc.delegate = self;
//    pc.sourceRect = self.txtFuelRemaining.bounds;
////    pc.sourceRect = CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.height/6.0, 0.0, 0.0);
//    pc.permittedArrowDirections = UIPopoverArrowDirectionUp;
//    [self presentViewController:popoverController animated:YES completion:^{
//        
//    }];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
    [popoverController presentPopoverFromRect:myFrame inView:self.tblvcFuelRemaining permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
- (IBAction)showPickerFuelVolumeUplift:(id)sender
{
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor clearColor];
    
    _fuelPickerVolumeUplift=[[UIPickerView alloc]init];//Date picker
    _fuelPickerVolumeUplift.frame=CGRectMake(0,30,320, 216);
    _fuelPickerVolumeUplift.delegate = self;
    [_fuelPickerVolumeUplift setTag:1];
    NSInteger int5 = 0;
    NSInteger int4 = 0;
    NSInteger int3 = 0;
    NSInteger int2 = 0;
    NSInteger int1 = 0;
    NSInteger int0 = 0;
    
    if ([self.txtFuelUpliftVolume.text length] == 6) {
        int5 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(5, 1)] integerValue];
        int4 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(4, 1)] integerValue];
        int3 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(3, 1)] integerValue];
        int2 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerVolumeUplift selectRow:int0 inComponent:0 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int1 inComponent:1 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int2 inComponent:2 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int3 inComponent:3 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int4 inComponent:4 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int5 inComponent:5 animated:YES];
        
    }
    if ([self.txtFuelUpliftVolume.text length] == 5) {
        int4 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(4, 1)] integerValue];
        int3 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(3, 1)] integerValue];
        int2 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerVolumeUplift selectRow:int0 inComponent:1 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int1 inComponent:2 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int2 inComponent:3 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int3 inComponent:4 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int4 inComponent:5 animated:YES];
    }
    if ([self.txtFuelUpliftVolume.text length] == 4) {
        int3 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(3, 1)] integerValue];
        int2 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerVolumeUplift selectRow:int0 inComponent:2 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int1 inComponent:3 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int2 inComponent:4 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int3 inComponent:5 animated:YES];
    }
    if ([self.txtFuelUpliftVolume.text length] == 3) {
        int2 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerVolumeUplift selectRow:int0 inComponent:3 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int1 inComponent:4 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int2 inComponent:5 animated:YES];
    }
    if ([self.txtFuelUpliftVolume.text length] == 2) {
        int1 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerVolumeUplift selectRow:int0 inComponent:4 animated:YES];
        [_fuelPickerVolumeUplift selectRow:int1 inComponent:5 animated:YES];
        
    }
    if ([self.txtFuelUpliftVolume.text length] == 1) {
        int0 = [[self.txtFuelUpliftVolume.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerVolumeUplift selectRow:int0 inComponent:5 animated:YES];
    }
    [popoverView addSubview:_fuelPickerVolumeUplift];
    popoverContent.view = popoverView;
    CGRect myFrame =self.txtFuelUpliftVolume.frame;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(hidePicker:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    [popoverView addSubview:toolBar];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
    [popoverController presentPopoverFromRect:myFrame inView:self.tblvcFuelUpliftVolume permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
- (IBAction)showPickerFuelDensity:(id)sender
{
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor clearColor];
    
    _fuelPickerDensity=[[UIPickerView alloc]init];//Date picker
    _fuelPickerDensity.frame=CGRectMake(0,30,320, 216);
    _fuelPickerDensity.delegate = self;
    [_fuelPickerDensity setTag:1];
  
    NSInteger int2 = 0;
    NSInteger int1 = 0;
    NSInteger int0 = 0;
    
//        NSArray *split = [self.txtDensity.text componentsSeparatedByString:@"."];
    NSString * strDensity =  [self.txtDensity.text stringByTrimmingCharactersInSet:
                                                  [NSCharacterSet whitespaceCharacterSet]];
    if ([strDensity length] == 3) {
        int2 = [[self.txtDensity.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtDensity.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtDensity.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        if ([[User sharedUser].strlblDensity isEqualToString: @"kg/ltr"]) {
            [_fuelPickerDensity selectRow:int0-7 inComponent:0 animated:YES];
        }else {
        [_fuelPickerDensity selectRow:int0 inComponent:0 animated:YES];
        }
        [_fuelPickerDensity selectRow:int1 inComponent:1 animated:YES];
        [_fuelPickerDensity selectRow:int2 inComponent:2 animated:YES];
    }
    if ([self.txtDensity.text length] == 2) {
        int1 = [[self.txtDensity.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtDensity.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerDensity selectRow:int0 inComponent:0 animated:YES];
        [_fuelPickerDensity selectRow:int1 inComponent:1 animated:YES];
        
    }
    if ([self.txtDensity.text length] == 1) {
        int0 = [[self.txtDensity.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerDensity selectRow:int0 inComponent:0 animated:YES];
    }

    
    [popoverView addSubview:_fuelPickerDensity];
    popoverContent.view = popoverView;
    CGRect myFrame =self.txtDensity.frame;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(hideDensityPicker:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    [popoverView addSubview:toolBar];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
    [popoverController presentPopoverFromRect:myFrame inView:self.tblvcDensity permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
- (IBAction)showPickerFuelDeparture:(id)sender
{
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor clearColor];
    
    _fuelPickerDeparture=[[UIPickerView alloc]init];//Date picker
    _fuelPickerDeparture.frame=CGRectMake(0,30,320, 216);
    _fuelPickerDeparture.delegate = self;
    [_fuelPickerDeparture setTag:1];
    NSInteger int5 = 0;
    NSInteger int4 = 0;
    NSInteger int3 = 0;
    NSInteger int2 = 0;
    NSInteger int1 = 0;
    NSInteger int0 = 0;
    
    if ([self.txtDepartureFuelCell.text length] == 6) {
        int5 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(5, 1)] integerValue];
        int4 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(4, 1)] integerValue];
        int3 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(3, 1)] integerValue];
        int2 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerDeparture selectRow:int0 inComponent:0 animated:YES];
        [_fuelPickerDeparture selectRow:int1 inComponent:1 animated:YES];
        [_fuelPickerDeparture selectRow:int2 inComponent:2 animated:YES];
        [_fuelPickerDeparture selectRow:int3 inComponent:3 animated:YES];
        [_fuelPickerDeparture selectRow:int4 inComponent:4 animated:YES];
        [_fuelPickerDeparture selectRow:int5 inComponent:5 animated:YES];
    }
    if ([self.txtDepartureFuelCell.text length] == 5) {
        int4 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(4, 1)] integerValue];
        int3 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(3, 1)] integerValue];
        int2 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerDeparture selectRow:int0 inComponent:1 animated:YES];
        [_fuelPickerDeparture selectRow:int1 inComponent:2 animated:YES];
        [_fuelPickerDeparture selectRow:int2 inComponent:3 animated:YES];
        [_fuelPickerDeparture selectRow:int3 inComponent:4 animated:YES];
        [_fuelPickerDeparture selectRow:int4 inComponent:5 animated:YES];
    }
    if ([self.txtDepartureFuelCell.text length] == 4) {
        int3 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(3, 1)] integerValue];
        int2 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerDeparture selectRow:int0 inComponent:2 animated:YES];
        [_fuelPickerDeparture selectRow:int1 inComponent:3 animated:YES];
        [_fuelPickerDeparture selectRow:int2 inComponent:4 animated:YES];
        [_fuelPickerDeparture selectRow:int3 inComponent:5 animated:YES];
    }
    if ([self.txtDepartureFuelCell.text length] == 3) {
        int2 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(2, 1)] integerValue];
        int1 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerDeparture selectRow:int0 inComponent:3 animated:YES];
        [_fuelPickerDeparture selectRow:int1 inComponent:4 animated:YES];
        [_fuelPickerDeparture selectRow:int2 inComponent:5 animated:YES];
    }
    if ([self.txtDepartureFuelCell.text length] == 2) {
        int1 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(1, 1)] integerValue];
        int0 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerDeparture selectRow:int0 inComponent:4 animated:YES];
        [_fuelPickerDeparture selectRow:int1 inComponent:5 animated:YES];
        
    }
    if ([self.txtDepartureFuelCell.text length] == 1) {
        int0 = [[self.txtDepartureFuelCell.text substringWithRange:NSMakeRange(0, 1)] integerValue];
        [_fuelPickerDeparture selectRow:int0 inComponent:5 animated:YES];
    }
    
    [popoverView addSubview:_fuelPickerDeparture];
    popoverContent.view = popoverView;
    CGRect myFrame =self.txtDepartureFuelCell.frame;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(hidePickerDepartureFuel:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    [popoverView addSubview:toolBar];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
    [popoverController presentPopoverFromRect:myFrame inView:self.tblvcDepartureFuel permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
-(void)hidePickerDepartureFuel:(id)sender
{
    //    [popoverController dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self CalculateDiscrepancy:self];
}

-(void)hideDensityPicker:(id)sender
{
    //    [popoverController dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [self DensityFieldChanged:self];
}

-(void)hidePicker:(id)sender
{
//    [popoverController dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self result];
}
-(void) result

{
    [self CalculateUplift];
}


@end
