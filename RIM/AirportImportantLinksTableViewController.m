//
//  AirportImportantLinksTableViewController.m
//  RIM
//
//  Created by Mikel on 31.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "AirportImportantLinksTableViewController.h"
#import "ReaderDemoController.h"
#import "ReaderViewController.h"
#import "User.h"

@interface AirportImportantLinksTableViewController ()
{
    NSString *path;
}
//@property(nonatomic,retain) NSString *path;
@end

@implementation AirportImportantLinksTableViewController
{
//    ReaderDemoController *readerDemoController;
    ReaderViewController *readerViewController;

}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    [self loadDocuments];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

- (void)setAirport:(Airports *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;
        //        [self configureView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    // [self loadDocuments];
    // [self.tableView reloadData];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDocuments
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [NSString stringWithFormat:@"%@/Inbox", documentsDirectory ];
    path = [NSString stringWithFormat:[[@"%@/Airportbriefing/" stringByAppendingString:self.airport.icaoidentifier] stringByAppendingString:@"/Important_links"], [[NSBundle mainBundle] bundlePath]];
    NSString *documentDirectoryPath = path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:documentDirectoryPath error:NULL];
    documents = [NSMutableArray arrayWithArray:files];
    NSLog(@"directories %@", files);
    
}


#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [documents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSString *title = [documents objectAtIndex:indexPath.row];
    title = [title stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
    cell.textLabel.text = title;
    [cell.textLabel setTextColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]]; /*#c99e2d*/
//        cell.detailTextLabel.text = [[urlsByName objectForKey:title] relativePath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *title = [documents objectAtIndex:indexPath.row];
//    title = [title stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
//        [User sharedUser].strPathDocuments = [[NSBundle mainBundle] pathForResource:title ofType:@"pdf"];
    NSString *strPathDir = [[@"/Airportbriefing/" stringByAppendingString:self.airport.icaoidentifier] stringByAppendingString:@"/Important_links"];
        NSString *strPath = [[NSBundle mainBundle] pathForResource:[[strPathDir stringByAppendingString:@"/"] stringByAppendingString:title] ofType:nil];
    [User sharedUser].strPathDocuments = strPath;
    readerViewController = [[ReaderViewController alloc] initWithNibName:nil bundle:nil]; // Demo controller
    [[self navigationController] pushViewController:readerViewController animated:NO];

//        readerDemoController = [[ReaderDemoController alloc] initWithNibName:nil bundle:nil]; // Demo controller
//        [[self navigationController] pushViewController:readerDemoController animated:NO];
//    [self.navigationController presentViewController:readerDemoController animated:NO completion:nil];

}

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
