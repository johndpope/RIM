//
//  FlightplanPopUpViewController.m
//  RIM
//
//  Created by Michael Gehringer on 8/29/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import "FlightplanPopUpViewController.h"


@implementation FlightplanPopUpViewController

- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle;
{
    self = [super init];
    
    if ( self ) {
        _titleText = title;
        _messageText = message;
        _buttonTitleText = buttonTitle;
    }
    
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    _titleLabel = [UILabel new];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_titleLabel setText:_titleText];
    [self.view addSubview:_titleLabel];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_titleLabel]|"     options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    _textLabel = [UITextView new];
    [_textLabel setTextAlignment:NSTextAlignmentNatural];
    [_textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_textLabel setNumberOfLines:0];
    [_textLabel setText:_messageText];
    _textLabel.editable = NO;
    [self.view addSubview:_textLabel];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_textLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_submitButton setTitle:_buttonTitleText forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_submitButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_submitButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_submitButton)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel(<=44.0)]-16-[_textLabel]-16-[_submitButton(<=44.0)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel,_textLabel,_submitButton)]];
}

- (void)submitButtonTouched:(id)sender;
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end