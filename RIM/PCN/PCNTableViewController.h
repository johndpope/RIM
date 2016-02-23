//
//  PCNTableViewController.h
//  RIM
//
//  Created by Mikel on 01.02.16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCNTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, retain) IBOutlet UIPickerView *PCNPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *PCNAircraft;
@property (nonatomic, retain) IBOutlet UIPickerView *PCNWeight;

@property (nonatomic, retain) IBOutlet UILabel *lblMAWNormal;
@property (nonatomic, retain) IBOutlet UILabel *lblACN;

@property (nonatomic, retain) IBOutlet UILabel *lblPavementType;
@property (nonatomic, retain) IBOutlet UILabel *lblPavementSubgrades;
@property (nonatomic, retain) IBOutlet UILabel *lblTirePressureCat;
@property (nonatomic, retain) IBOutlet UILabel *lblPavementCalculationMethod;

@end
