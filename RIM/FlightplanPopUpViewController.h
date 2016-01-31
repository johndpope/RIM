//
//  FlightplanPopUpViewController.h
//  RIM
//
//  Created by Michael Gehringer on 8/29/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightplanPopUpViewController: UIViewController

- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle;

@property NSString* titleText;
@property NSString* messageText;
@property NSString* buttonTitleText;

@property UILabel* titleLabel;
@property UITextView    * textLabel;
@property UIButton* submitButton;

@end

