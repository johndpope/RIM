//
//  AirportCategorieTableViewController.m
//  RIM
//
//  Created by Mikel on 06.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "AirportCategorieTableViewController.h"
#import "User.h"
#import "Airport.h"
@interface AirportCategorieTableViewController ()

@end

@implementation AirportCategorieTableViewController

- (void)setAirport:(Airports *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;
        //        [self configureView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.airport.icaoidentifier;
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cella32xCat.detailTextLabel.text = self.airport.cat32x;
    if ([self.airport.cat32x isEqualToString:@"C"]) {
        self.cella32xCat.backgroundColor = [UIColor redColor];
    }
    self.cella32xPEG.detailTextLabel.text = self.airport.peg;
    if ([self.airport.pegnotes isEqualToString:@""]) {
        self.cella32xPEG.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.cella32xPEG.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    if (self.airport.cpldg == TRUE) {
        self.cella32xCPLdg.detailTextLabel.text = @"YES";
        self.cella32xCPLdg.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        self.cella32xCPLdg.detailTextLabel.text = @"NO";
        self.cella32xCPLdg.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.airport.cat32x isEqualToString:@""]) {
        self.cella32xNotes.accessoryType = UITableViewCellAccessoryNone;
        self.cella32xNotes.detailTextLabel.text = @"NONE";
    }else{
        self.cella32xNotes.accessoryType = UITableViewCellAccessoryDetailButton;
        self.cella32xNotes.detailTextLabel.text = @"";
//        self.cella32xNotes.backgroundColor = [UIColor yellowColor];
    }
    
    
    self.cella332Cat.detailTextLabel.text = self.airport.cat332;
    if ([self.airport.cat332 isEqualToString:@"C"]) {
        self.cella332Cat.backgroundColor = [UIColor redColor];
    }
    self.cella332PEG.detailTextLabel.text = self.airport.peg;
    if ([self.airport.pegnotes isEqualToString:@""]) {
        self.cella332PEG.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.cella332PEG.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    if (self.airport.cpldg == TRUE) {
        self.cella332CPLdg.detailTextLabel.text = @"YES";
        self.cella332CPLdg.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        self.cella332CPLdg.detailTextLabel.text = @"NO";
        self.cella332CPLdg.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.airport.cat332 isEqualToString:@""]) {
        self.cella332Notes.accessoryType = UITableViewCellAccessoryNone;
        self.cella332Notes.detailTextLabel.text = @"NONE";
    }else{
        self.cella332Notes.accessoryType = UITableViewCellAccessoryDetailButton;
        self.cella332Notes.detailTextLabel.text = @"";
//        self.cella332Notes.backgroundColor = [UIColor yellowColor];
    }
    
    
    self.cella333Cat.detailTextLabel.text = self.airport.cat333;
    if ([self.airport.cat333 isEqualToString:@"C"]) {
        self.cella333Cat.backgroundColor = [UIColor redColor];
    }
    self.cella333PEG.detailTextLabel.text = self.airport.peg;
    if ([self.airport.pegnotes isEqualToString:@""]) {
        self.cella333PEG.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.cella333PEG.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    if (self.airport.cpldg == TRUE) {
        self.cella333CPLdg.detailTextLabel.text = @"YES";
        self.cella333CPLdg.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        self.cella333CPLdg.detailTextLabel.text = @"NO";
        self.cella333CPLdg.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.airport.cat333 isEqualToString:@""]) {
        self.cella333Notes.accessoryType = UITableViewCellAccessoryNone;
        self.cella333Notes.detailTextLabel.text = @"NONE";
    }else{
        self.cella333Notes.accessoryType = UITableViewCellAccessoryDetailButton;
        self.cella333Notes.detailTextLabel.text = @"";
//        self.cella333Notes.backgroundColor = [UIColor yellowColor];
    }
    
    
    self.cella345Cat.detailTextLabel.text = self.airport.cat345;
    if ([self.airport.cat345 isEqualToString:@"C"]) {
        self.cella345Cat.backgroundColor = [UIColor redColor];
    }
    self.cella345PEG.detailTextLabel.text = self.airport.peg;
    if ([self.airport.pegnotes isEqualToString:@""]) {
        self.cella345PEG.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.cella345PEG.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    if (self.airport.cpldg == TRUE) {
        self.cella345CPLdg.detailTextLabel.text = @"YES";
        self.cella345CPLdg.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        self.cella345CPLdg.detailTextLabel.text = @"NO";
        self.cella345CPLdg.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.airport.cat345 isEqualToString:@""]) {
        self.cella345Notes.accessoryType = UITableViewCellAccessoryNone;
        self.cella345Notes.detailTextLabel.text = @"NONE";
    }else{
        self.cella345Notes.accessoryType = UITableViewCellAccessoryDetailButton;
        self.cella345Notes.detailTextLabel.text = @"";
//        self.cella345Notes.backgroundColor = [UIColor yellowColor];
    }
    
    
    self.cella346Cat.detailTextLabel.text = self.airport.cat346;
    if ([self.airport.cat346 isEqualToString:@"C"]) {
        self.cella346Cat.backgroundColor = [UIColor redColor];
    }
    self.cella346PEG.detailTextLabel.text = self.airport.peg;
    if ([self.airport.pegnotes isEqualToString:@""]) {
        self.cella346PEG.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.cella346PEG.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    if (self.airport.cpldg == TRUE) {
        self.cella346CPLdg.detailTextLabel.text = @"YES";
        self.cella346CPLdg.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        self.cella346CPLdg.detailTextLabel.text = @"NO";
        self.cella346CPLdg.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.airport.cat346 isEqualToString:@""]) {
        self.cella346Notes.accessoryType = UITableViewCellAccessoryNone;
        self.cella346Notes.detailTextLabel.text = @"NONE";
    }else{
        self.cella346Notes.accessoryType = UITableViewCellAccessoryDetailButton;
        self.cella346Notes.detailTextLabel.text = @"";
//        self.cella346Notes.backgroundColor = [UIColor yellowColor];
    }
    
    
    
    self.cella350Cat.detailTextLabel.text = self.airport.cat350;
    if ([self.airport.cat350 isEqualToString:@"C"]) {
        self.cella350Cat.backgroundColor = [UIColor redColor];
    }
    self.cella350PEG.detailTextLabel.text = self.airport.peg;
    if ([self.airport.pegnotes isEqualToString:@""]) {
        self.cella350PEG.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.cella350PEG.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    if (self.airport.cpldg == TRUE) {
        self.cella350CPLdg.detailTextLabel.text = @"YES";
        self.cella350CPLdg.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        self.cella350CPLdg.detailTextLabel.text = @"NO";
        self.cella350CPLdg.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.airport.cat350 isEqualToString:@""]) {
        self.cella350Notes.accessoryType = UITableViewCellAccessoryNone;
        self.cella350Notes.detailTextLabel.text = @"NONE";
    }else{
        self.cella350Notes.accessoryType = UITableViewCellAccessoryDetailButton;
        self.cella350Notes.detailTextLabel.text = @"";
//        self.cella350Notes.backgroundColor = [UIColor yellowColor];
    }

    
    
    
    self.cella380Cat.detailTextLabel.text = self.airport.cat380;
    if ([self.airport.cat380 isEqualToString:@"C"]) {
        self.cella350Cat.backgroundColor = [UIColor redColor];
    }
    self.cella380PEG.detailTextLabel.text = self.airport.peg;
    if ([self.airport.pegnotes isEqualToString:@""]) {
        self.cella380PEG.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.cella380PEG.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    if (self.airport.cpldg == TRUE) {
        self.cella380CPLdg.detailTextLabel.text = @"YES";
        self.cella380CPLdg.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        self.cella380CPLdg.detailTextLabel.text = @"NO";
        self.cella380CPLdg.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.airport.cat380 isEqualToString:@""]) {
        self.cella380Notes.accessoryType = UITableViewCellAccessoryNone;
        self.cella380Notes.detailTextLabel.text = @"NONE";
    }else{
        self.cella380Notes.accessoryType = UITableViewCellAccessoryDetailButton;
        self.cella380Notes.detailTextLabel.text = @"";
//        self.cella380Notes.backgroundColor = [UIColor yellowColor];
    }

    
    
    
    self.cellb777Cat.detailTextLabel.text = self.airport.cat777;
    if ([self.airport.cat777 isEqualToString:@"C"]) {
        self.cellb777Cat.backgroundColor = [UIColor redColor];
    }
    self.cellb777PEG.detailTextLabel.text = self.airport.peg;
    if ([self.airport.pegnotes isEqualToString:@""]) {
        self.cellb777PEG.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.cellb777PEG.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    if (self.airport.cpldg == TRUE) {
        self.cellb777CPLdg.detailTextLabel.text = @"YES";
        self.cellb777CPLdg.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        self.cellb777CPLdg.detailTextLabel.text = @"NO";
        self.cellb777CPLdg.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.airport.cat777 isEqualToString:@""]) {
        self.cellb777Notes.accessoryType = UITableViewCellAccessoryNone;
        self.cellb777Notes.detailTextLabel.text = @"NONE";
    }else{
        self.cellb777Notes.accessoryType = UITableViewCellAccessoryDetailButton;
        self.cellb777Notes.detailTextLabel.text = @"";
//        self.cellb777Notes.backgroundColor = [UIColor yellowColor];
    }
    
    
    
    
    self.cellb787Cat.detailTextLabel.text = self.airport.cat787;
    if ([self.airport.cat787 isEqualToString:@"C"]) {
        self.cellb787Cat.backgroundColor = [UIColor redColor];
    }
    self.cellb787PEG.detailTextLabel.text = self.airport.peg;
    if ([self.airport.pegnotes isEqualToString:@""]) {
        self.cellb787PEG.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.cellb787PEG.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    if (self.airport.cpldg == TRUE) {
        self.cellb787CPLdg.detailTextLabel.text = @"YES";
        self.cellb787CPLdg.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        self.cellb787CPLdg.detailTextLabel.text = @"NO";
        self.cellb787CPLdg.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.airport.cat787 isEqualToString:@""]) {
        self.cellb787Notes.accessoryType = UITableViewCellAccessoryNone;
        self.cellb787Notes.detailTextLabel.text = @"NONE";
    }else{
        self.cellb787Notes.accessoryType = UITableViewCellAccessoryDetailButton;
        self.cellb787Notes.detailTextLabel.text = @"";
//        self.cellb787Notes.backgroundColor = [UIColor yellowColor];
    }

    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]];
    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];





}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
