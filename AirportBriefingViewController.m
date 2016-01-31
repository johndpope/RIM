//
//  AirportBriefingViewController.m
//  RIM
//
//  Created by Michael Gehringer on 9/5/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import "AirportBriefingViewController.h"
#import "User.h"
#import "SDCoreDataController.h"

@interface AirportBriefingViewController ()
@property (strong, nonatomic) BAPrayerTimes *prayerTimes;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation AirportBriefingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]];
//    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    imageView.frame = self.view.bounds;
    imageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    [self calcTimeZone];
    [self calcCoordinates];
    [self calcAirportSunriseSunset];
    self.lblName.text = [self.airport.name length] ? self.airport.name : @"";
    self.lblICAOIATA.text = [self.airport.icaoidentifier length] ? self.airport.icaoidentifier : @"N/A";
    self.lblICAOIATA.text = [[self.lblICAOIATA.text stringByAppendingString:@" / "] stringByAppendingString:[self.airport.iataidentifier length] ? self.airport.iataidentifier :@"N/A"];

    self.lblCity.text = [self.airport.city length] ? self.airport.city : @"";
    self.lblCountry.text =[self.airport.country length] ? self.airport.country : @"";
    self.lblElevation.text = [[[NSString alloc]initWithFormat:@"%.0f",self.airport.elevation] stringByAppendingString:@" ft"];
    self.lblRFF.text = [@"RFF: " stringByAppendingString:[self.airport.rff length] ? self.airport.rff : @"TBA"];
    
    self.lblCategory.text = [@"Cat: " stringByAppendingString:[self.airport.cat32x length] ? self.airport.cat32x :@"TBA" ];
    self.lblPEG.text = [@"PEG: " stringByAppendingString:[self.airport.peg length] ? self.airport.peg : @"TBA"];
    
    
    
    
    self.prayerTimes = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                  latitude:self.airport.latitude
                                                 longitude:self.airport.longitude
                                                  timeZone:[NSTimeZone timeZoneWithName:self.airport.timezone]
                                                    method:BAPrayerMethodMWL
                                                    madhab:BAPrayerMadhabShafi];
//    self.lblPrayers.text = [[[[[[[[[[[self.dateFormatter stringFromDate:self.prayerTimes.fajrTime] stringByAppendingString:@"/"] stringByAppendingString:[self.dateFormatter stringFromDate:self.prayerTimes.sunriseTime]] stringByAppendingString:@"/"]stringByAppendingString:[self.dateFormatter stringFromDate:self.prayerTimes.dhuhrTime]] stringByAppendingString:@"/"]stringByAppendingString:[self.dateFormatter stringFromDate:self.prayerTimes.asrTime]] stringByAppendingString:@"/"] stringByAppendingString:[self.dateFormatter stringFromDate:self.prayerTimes.maghribTime]] stringByAppendingString:@"/"]stringByAppendingString:[self.dateFormatter stringFromDate:self.prayerTimes.ishaTime]];
    self.lblPrayers.text = @"";
    self.lblFajr.text = [@"Fajr: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.fajrTime]];
    
    self.lblSunrise.text = [@"Sunrise: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.sunriseTime]];
    self.lblDhur.text = [@"Dhuhr: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.dhuhrTime]];

    self.lblAsr.text = [@"Asr: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.asrTime]];

    self.lblMaghrib.text = [@"Maghrib: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.maghribTime]];

    self.lblIsha.text = [@"Isha: " stringByAppendingString:[dateFormat stringFromDate:self.prayerTimes.ishaTime]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setAirport:(Airports *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;
        
    }
}

-(void) calcCoordinates
{
    double dblLatitude;
    dblLatitude = self.airport.latitude;
    if (dblLatitude >= 0) {
        self.lblCoordinates.text = [[NSString alloc]initWithFormat:@"%02.0f°%02.1f N", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    } else {
        dblLatitude = dblLatitude*-1;
        self.lblCoordinates.text = [[NSString alloc]initWithFormat:@"%02.0f°%02.1f S", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    }
    double dblLongitude;
    dblLongitude = self.airport.longitude;
    if (dblLongitude >= 0) {
        
        self.lblCoordinates.text = [[self.lblCoordinates.text stringByAppendingString:@" / "] stringByAppendingString:[[NSString alloc]initWithFormat:@"%03.0f°%02.1f E", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60]];
    } else {
        dblLongitude = dblLongitude*-1;
        self.lblCoordinates.text = [[self.lblCoordinates.text stringByAppendingString:@" / "] stringByAppendingString:[[NSString alloc]initWithFormat:@"%03.0f°%02.1f W", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60]];
    }
    
}

-(void) calcTimeZone
{
    
    NSTimeZone *currentTimeZone =
    [NSTimeZone timeZoneWithName:self.airport.timezone];
    NSInteger GMTOffset;
    GMTOffset = [currentTimeZone secondsFromGMT];
    
    NSNumber *totalDays = [NSNumber numberWithDouble:
                           (GMTOffset / 86400)];
    NSNumber *totalHours = [NSNumber numberWithDouble:
                            ((GMTOffset / 3600) -
                             ([totalDays intValue] * 24))];
    NSNumber *totalMinutes = [NSNumber numberWithDouble:
                              ((GMTOffset / 60) -
                               ([totalDays intValue] * 24 * 60) -
                               ([totalHours intValue] * 60))];
    NSInteger intHours;
    intHours = [totalHours intValue];
    NSInteger intMinutes;
    intMinutes = [totalMinutes intValue];
    
    
    
    if (intHours < 0) {
        if (intMinutes < 15)
        {
            //            self.cellTimezone.textLabel.text = @"Timezone:";
            self.lblTimeZone.text = [@"UTC " stringByAppendingString:[[[NSString alloc] initWithFormat:@"%-.2li:00", (long)intHours]stringByAppendingString:@" hrs"]];
            //            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.textColor = [UIColor darkGrayColor];
            //            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
        else {
            //            cell.textLabel.text = @"Timezone:";
            self.lblTimeZone.text = [@"UTC " stringByAppendingString:[[[NSString alloc] initWithFormat:@"%-.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"]];
            //            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.textColor = [UIColor darkGrayColor];
            //            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
    }
    else {
        if (intMinutes < 15)
        {
            //            cell.textLabel.text = @"Timezone:";
            self.lblTimeZone.text = [@"UTC " stringByAppendingString:[[[NSString alloc] initWithFormat:@"%+.2li:00", (long)intHours]stringByAppendingString:@" hrs"]];
            //            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.textColor = [UIColor darkGrayColor];
            //            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
        else {
            //            cell.textLabel.text = @"Timezone:";
            self.lblTimeZone.text = [@"UTC " stringByAppendingString:[[[NSString alloc] initWithFormat:@"%+.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@" hrs"]];
            //            self.cellTimezone.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
            //            cell.textLabel.textColor = [UIColor darkGrayColor];
            //            self.cellTimezone.detailTextLabel.textColor = [UIColor blueColor];
        }
    }
}



-(void) calcAirportSunriseSunset
{
    //    NSInteger GMTOffset;
    //    GMTOffset = intTimedifference;
    NSDate* date = [NSDate date];
    NSTimeZone* tz =  [NSTimeZone timeZoneForSecondsFromGMT:(0 * 3600)];
    double dblLongitude = self.airport.longitude;
    dblLongitude = -dblLongitude;
    
    Fiddler* fiddlerAirport = [[Fiddler alloc] initWithDate:date timeZone:tz latitude:self.airport.latitude longitude:dblLongitude];
    [fiddlerAirport reload];
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsSR = [gregorian components:unitFlags fromDate:fiddlerAirport.sunrise];
    // Now extract the hour:mins from today's date
    NSInteger hourSR = [compsSR hour];
    NSInteger minSR = [compsSR minute];
    NSInteger intSunriseUTC = ((hourSR*60)+minSR)*60;
    NSTimeZone *currentTimeZone =
    [NSTimeZone timeZoneWithName:self.airport.timezone];
    NSInteger GMTOffset;
    GMTOffset = [currentTimeZone secondsFromGMT];
    intSunriseUTC = intSunriseUTC + GMTOffset;
    if (intSunriseUTC < 0) {
        intSunriseUTC = 86400 + intSunriseUTC;
    }
    NSNumber *totalDaysSR = [NSNumber numberWithDouble:
                             (intSunriseUTC / 86400)];
    NSNumber *totalHoursSR = [NSNumber numberWithDouble:
                              ((intSunriseUTC / 3600) -
                               ([totalDaysSR intValue] * 24))];
    NSNumber *totalMinutesSR = [NSNumber numberWithDouble:
                                ((intSunriseUTC / 60) -
                                 ([totalDaysSR intValue] * 24 * 60) -
                                 ([totalHoursSR intValue] * 60))];
    NSInteger intHoursSR;
    intHoursSR = [totalHoursSR intValue];
    NSInteger intMinutesSR;
    intMinutesSR = [totalMinutesSR intValue];
    [compsSR setHour:intHoursSR];
    [compsSR setMinute:intMinutesSR];
    
//    self.lblSRSS.text = [@"SR:" stringByAppendingString:[[[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSR,(long)minSR] stringByAppendingString:@" UTC / "] stringByAppendingString:[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursSR,(long)intMinutesSR]]stringByAppendingString:@" LCL"]];
    
    self.lblSRSS.text = [@"SR:" stringByAppendingString:[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSR,(long)minSR] stringByAppendingString:@" UTC / "]];
    //
    NSDateComponents *compsSS = [gregorian components:unitFlags fromDate:fiddlerAirport.sunset];
    NSInteger hourSS = [compsSS hour];
    NSInteger minSS = [compsSS minute];
    NSInteger intSunsetUTC = ((hourSS*60)+minSS)*60;
    
    intSunsetUTC = intSunsetUTC + GMTOffset;
    if (intSunsetUTC < 0) {
        intSunsetUTC = 86400 + intSunsetUTC;
    }
    NSNumber *totalDaysSS = [NSNumber numberWithDouble:
                             (intSunsetUTC / 86400)];
    NSNumber *totalHoursSS = [NSNumber numberWithDouble:
                              ((intSunsetUTC / 3600) -
                               ([totalDaysSS intValue] * 24))];
    NSNumber *totalMinutesSS = [NSNumber numberWithDouble:
                                ((intSunsetUTC / 60) -
                                 ([totalDaysSS intValue] * 24 * 60) -
                                 ([totalHoursSS intValue] * 60))];
    NSInteger intHoursSS;
    intHoursSS = [totalHoursSS intValue];
    NSInteger intMinutesSS;
    intMinutesSS = [totalMinutesSS intValue];
    [compsSS setHour:intHoursSS];
    [compsSS setMinute:intMinutesSS];
    
    
//    self.lblSRSS.text = [[self.lblSRSS.text stringByAppendingString:@" / "]stringByAppendingString:[@"SS:" stringByAppendingString:[[[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSS,(long)minSS] stringByAppendingString:@" UTC / "] stringByAppendingString:[[NSString alloc] initWithFormat:@"%02li:%02li",(long)intHoursSS,(long)intMinutesSS]]stringByAppendingString:@" LCL"]]];
    
    self.lblSRSS.text = [self.lblSRSS.text stringByAppendingString:[@"SS:" stringByAppendingString:[[[NSString alloc] initWithFormat:@"%02li:%02li",(long)hourSS,(long)minSS] stringByAppendingString:@" UTC"]]];
}

@end
