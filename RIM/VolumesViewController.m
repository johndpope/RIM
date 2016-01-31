//
//  VolumesViewController.m
//  uplift
//
//  Created by Michael Gehringer on 29.03.12.
//  Copyright (c) 2012 Mikelsoft.com. All rights reserved.
//

#import "VolumesViewController.h"
#import "User.h"

@interface VolumesViewController ()

@end

@implementation VolumesViewController
{
    NSArray *volumes;
    NSUInteger selectedIndex;
}

@synthesize delegate;
@synthesize volume;

- (void)viewDidLoad
{
    [super viewDidLoad];
    volumes = [NSArray arrayWithObjects:
               @"ltr",
               @"usg",
               @"ipg",
               nil];    
    selectedIndex = [volumes indexOfObject:self.volume];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    volumes = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Table view data source




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [volumes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"VolumesCell"];
	cell.textLabel.text = [volumes objectAtIndex:indexPath.row];
    if (indexPath.row == selectedIndex)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
    
    
	return cell;
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if (selectedIndex != NSNotFound)
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
	selectedIndex = indexPath.row;
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
	NSString *theVolume = [volumes objectAtIndex:indexPath.row];
	[self.delegate volumesViewController:self didSelectVolume:theVolume];
    if ([theVolume isEqualToString:@"ltr"]) {
        [User sharedUser].intFactVolume = 1.0;
        [User sharedUser].strVolumetxt = @"ltr";
    }
    if ([theVolume isEqualToString:@"usg"]) {
        [User sharedUser].intFactVolume = 3.785;
        [User sharedUser].strVolumetxt = @"usg";
    }
    if ([theVolume isEqualToString:@"ipg"]) {
        [User sharedUser].intFactVolume = 4.546;
        [User sharedUser].strVolumetxt = @"ipg";
    }
    [self.delegate didUpdateData];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
