//
//  MOTNETableViewController.h
//  RIM
//
//  Created by Mikel on 30.01.16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOTNETableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, retain) IBOutlet UIPickerView *MOTNEPicker;
@property (nonatomic, retain) IBOutlet UILabel *lblRWY;
@property (nonatomic, retain) IBOutlet UILabel *lblDeposit;
@property (nonatomic, retain) IBOutlet UILabel *lblContamination;
@property (nonatomic, retain) IBOutlet UILabel *lblDepthDeposit;
@property (nonatomic, retain) IBOutlet UILabel *lblBrakingAction;


@end
