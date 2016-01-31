//
//  PrayerTimesTableViewController.m
//  RIM
//
//  Created by Michael Gehringer on 8/25/15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "PrayerTimesTableViewController.h"

@interface PrayerTimesTableViewController ()
@property (strong, nonatomic) BAPrayerTimes *prayerTimes;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation PrayerTimesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    self.prayerTimes = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                  latitude:self.airport.latitude
                                                 longitude:self.airport.longitude
                                                            timeZone:[NSTimeZone timeZoneWithName:self.airport.timezone]
                                                              method:BAPrayerMethodMWL
                                                              madhab:BAPrayerMadhabShafi];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 70;
    
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
- (void)setAirport:(Airports *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"cellPRAYER";
    SunrisePrayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SunrisePrayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    switch (indexPath.row) {
        case 0:
            cell.lblnamewpt.text = @"Fajr";
            cell.lblAirways.text = [self.dateFormatter stringFromDate:self.prayerTimes.fajrTime];
            break;
        case 1:
            cell.lblnamewpt.text = @"Sunrise";
            cell.lblAirways.text = [self.dateFormatter stringFromDate:self.prayerTimes.sunriseTime];
            break;
        case 2:
            cell.lblnamewpt.text = @"Dhuhr";
            cell.lblAirways.text = [self.dateFormatter stringFromDate:self.prayerTimes.dhuhrTime];
            break;
        case 3:
            cell.lblnamewpt.text = @"Asr";
            cell.lblAirways.text = [self.dateFormatter stringFromDate:self.prayerTimes.asrTime];
            break;
        case 4:
            cell.lblnamewpt.text = @"Maghrib";
            cell.lblAirways.text = [self.dateFormatter stringFromDate:self.prayerTimes.maghribTime];
            break;
        case 5:
            cell.lblnamewpt.text = @"Isha";
            cell.lblAirways.text = [self.dateFormatter stringFromDate:self.prayerTimes.ishaTime];
            break;
        case 6:
            cell.lblnamewpt.text = @"Fajr Tomorrow";
            cell.lblAirways.text = [self.dateFormatter stringFromDate:self.prayerTimes.tomorrowFajrTime];
            break;
    }

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
