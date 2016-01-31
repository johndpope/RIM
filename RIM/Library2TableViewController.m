//
//  LibraryTableViewController.m
//  RIM
//
//  Created by Mikel on 02.06.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "Library2TableViewController.h"
#import "ReaderViewController.h"
#import "LibraryTableViewCell.h"
#import "User.h"

@interface Library2TableViewController ()

@end

@implementation Library2TableViewController
{
    ReaderViewController *readerViewController;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFolders];
    self.navigationItem.title = [User sharedUser].strPath2Title;
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 55;
    
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]]; /*#555555*/
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadFolders];
}
-(void)viewWillDisappear:(BOOL)animated
{
//    [self loadFolders];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadFolders
{
    [User sharedUser].strPathDirectory = [[@"%@/Library" stringByAppendingString:@"/"] stringByAppendingString:[User sharedUser].strPath2Title];
    documentDirectoryPath = [NSString stringWithFormat:[User sharedUser].strPathDirectory, [[NSBundle mainBundle] bundlePath]];
    NSLog(@"%@", [User sharedUser].strPathDirectory);
    NSLog(@"%@", documentDirectoryPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentDirectoryPath error:nil];
    directoryList = [[NSMutableArray alloc] init];
    for(NSString *file in fileList) {
        BOOL isDir = NO;
        [fileManager fileExistsAtPath:documentDirectoryPath isDirectory:(&isDir)];
        if(isDir) {
            [directoryList addObject:file];
        }
    }
    NSLog(@"%@", directoryList);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [directoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    LibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //    if (!cell)
    //    {
    //        cell = [[LibraryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    //    }
    NSString *title = [directoryList objectAtIndex:indexPath.row];
    if ([[title pathExtension] isEqualToString:@"pdf"]) {
        title = [title stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.lblDocument.font = [UIFont systemFontOfSize:18.f];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImage *image = [UIImage imageNamed: @"courses-32.png"];
        [cell.imgDocument setImage:image];
    }
    cell.lblDocument.text = title;
    
    [cell.lblDocument setTextColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]]; /*#c99e2d*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *title = [directoryList objectAtIndex:indexPath.row];
    if ([[title pathExtension] isEqualToString:@"pdf"]) {
        NSString *strPath = [[documentDirectoryPath stringByAppendingString:@"/"] stringByAppendingString:title];
        [User sharedUser].strPathDocuments = strPath;
        readerViewController = [[ReaderViewController alloc] initWithNibName:nil bundle:nil]; // Demo controller
        [[self navigationController] pushViewController:readerViewController animated:NO];
    }else{
        [User sharedUser].strPath3Title = title;
        [User sharedUser].strPathDirectory = [[[User sharedUser].strPathDirectory stringByAppendingString:@"/"] stringByAppendingString:title];
        [self performSegueWithIdentifier: @"segLibraryPush" sender:indexPath];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segLibraryPush"])
    {
        
    }
}

@end