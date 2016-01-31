//
//  UYLCountryViewController.m
//  WorldFacts
//
//  Created by Keith Harrison http://useyourloaf.com
//  Copyright (c) 2012-2014 Keith Harrison. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  Neither the name of Keith Harrison nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ''AS IS'' AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 


#import "UYLCountryViewController.h"

@interface UYLCountryViewController ()

@property (nonatomic, weak) IBOutlet UILabel *atis;
@property (nonatomic, weak) IBOutlet UILabel *city;
@property (nonatomic, weak) IBOutlet UILabel *elevation;
@property (nonatomic, weak) IBOutlet UILabel *iata;
@property (nonatomic, weak) IBOutlet UILabel *icao;
@property (nonatomic, weak) IBOutlet UILabel *latitude;
@property (nonatomic, weak) IBOutlet UILabel *longitude;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *timezone;
@property (nonatomic, weak) IBOutlet UILabel *variation;
@property (nonatomic, weak) IBOutlet UILabel *region;
@property (nonatomic, weak) IBOutlet UISwitch *swcEnrouteAlternate;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *headlineCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *bodyCollection;

@end

@implementation UYLCountryViewController

//- (void)setAirport:(Country *)newAirport
//{
//    if (_airport != newAirport)
//    {
//        _airport = newAirport;
//        [self configureView];
//    }
//}

- (void)setAirport:(Airports *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;
        [self configureView];
    }
}

- (void)configureView
{
    for (UILabel *label in self.headlineCollection)
    {
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }
    
    for (UILabel *label in self.bodyCollection)
    {
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    
    self.title = self.airport.icaoidentifier;
//    NSString *elevation = [NSNumberFormatter localizedStringFromNumber:self.airport.elevation numberStyle:NSNumberFormatterDecimalStyle];
//    self.elevation.text = [elevation length] ? elevation : @"None";
//    NSString *latitude = [NSNumberFormatter localizedStringFromNumber:self.airport.latitude numberStyle:NSNumberFormatterDecimalStyle];
//    self.latitude.text = [latitude length] ? latitude : @"None";
//    NSString *longitude = [NSNumberFormatter localizedStringFromNumber:self.airport.longitude numberStyle:NSNumberFormatterDecimalStyle];
//    self.longitude.text = [longitude length] ? longitude : @"None";
//    NSString *variation = [NSNumberFormatter localizedStringFromNumber:self.airport.variation numberStyle:NSNumberFormatterDecimalStyle];
//    self.variation.text = [variation length] ? variation : @"None";
    self.city.text = [self.airport.name length] ? self.airport.name : @"None";
    self.iata.text = [self.airport.iataidentifier length] ? self.airport.iataidentifier : @"None";
    self.icao.text = [self.airport.icaoidentifier length] ? self.airport.icaoidentifier : @"None";
//    self.name.text = [self.airport.city length] ? self.airport.city : @"None";
//    self.timezone.text = [self.airport.timezone length] ? self.airport.timezone : @"None";
//    self.atis.text = [self.airport.atis length] ? self.airport.atis : @"None";
//    [self.swcEnrouteAlternate setOn:([self.airport.adequate boolValue])];
//    self.region.text = [self.airport.region length] ? self.airport.region : @"None";

}

#pragma mark -
#pragma mark === View Life Cycle Management ===
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self configureView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

@end
