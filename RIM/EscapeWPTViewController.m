//
//  EscapeWPTViewController.m
//  RIM
//
//  Created by Mikel on 27.03.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "EscapeWPTViewController.h"
#import "User.h"
#import "Airports.h"
#import "SDCoreDataController.h"
#import "Airport.h"

@interface EscapeWPTViewController () 

@property (nonatomic) IBOutlet UIImageView *imgviewEscape;
@property (nonatomic) IBOutlet UIScrollView *scollviewEscape;
@end

@implementation EscapeWPTViewController

- (void)setEscapewpt:(Escape *)newEscapeWPT
{
    if (_escapewpt != newEscapeWPT)
    {
        _escapewpt = newEscapeWPT;
        [self configureView];
    }
}

- (void)configureView
{
    self.view.backgroundColor = [UIColor grayColor];
    NSLog(@"wpt name: %@", self.escapewpt.wptname);
    NSLog(@"Image Path: %@", self.escapewpt.path);
//    NSString* strImage = [self.escapewpt.chapter stringByAppendingString:self.escapewpt.page];
//    NSString* imageName = [[NSBundle mainBundle] pathForResource:strImage ofType:@"png"];
//    UIImage* imageObj = [[UIImage alloc] initWithContentsOfFile:imageName];
//    self.imgviewEscape = [[UIImageView alloc]initWithImage:imageObj];
//    self.scollviewEscape = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    [self.scollviewEscape addSubview:self.imgviewEscape];
//    self.scollviewEscape.contentSize = self.imgviewEscape.bounds.size;
//    self.scollviewEscape.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//    self.scollviewEscape.minimumZoomScale = 0.3f;
//    self.scollviewEscape.maximumZoomScale = 3.0f;
//    self.scollviewEscape.delegate = self;
//    [self.view addSubview:self.scollviewEscape];
    
    
}
- (IBAction)addWaypointToArray:(id)sender;
{
//    [[User sharedUser].arrayEscapeRoutes addObject:self.escapewpt];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:[@"Escape Route Waypoint " stringByAppendingString:self.escapewpt.wptname]
                                          message:[[@"Do you want to add " stringByAppendingString:self.escapewpt.wptname] stringByAppendingString:@" to your enroute escaperoute list ?"]
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"NO", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       [self.parentViewController.navigationController popViewControllerAnimated:YES];
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"YES", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [[User sharedUser].arrayEscapeRoutes addObject:self.escapewpt];
                                   NSMutableArray * unique = [NSMutableArray array];
                                   
                                   for (id obj in [User sharedUser].arrayEscapeRoutes) {
                                       if (![unique containsObject:obj]) {
                                           [unique addObject:obj];
                                       }
                                   }
                                   [User sharedUser].arrayEscapeRoutes = unique;
                                   
                                   arrAlternates = [[NSArray alloc] init];
                                   NSString* string = @"OMAA";
                                   arrAlternates = [string componentsSeparatedByString:@", "];
                                   [User sharedUser].arrayAlternates = [[NSMutableArray alloc] init];
                                   self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
                                   for (int i=0; i < [arrAlternates count]; i++)
                                   {
                                       
                                       NSString *strIcaoIdentifier = [arrAlternates objectAtIndex:i];  //find object with this id in core data
                                       
                                       NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
                                       [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
                                       
                                       NSFetchRequest *request = [[NSFetchRequest alloc] init];
                                       NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                 inManagedObjectContext:context];
                                       [request setEntity:entity];
                                       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                       [request setPredicate:predicate];
                                       NSArray *results = [context executeFetchRequest:request error:NULL];
                                       Airports *managedairport = [[Airports alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
                                       managedairport = [results objectAtIndex:0];
                                       Airport *detairport = [[Airport alloc] init];
                                       detairport.cat32x = managedairport.cat32x;
                                       detairport.cat332 = managedairport.cat332;
                                       detairport.cat333 = managedairport.cat333;
                                       detairport.cat345 = managedairport.cat345;
                                       detairport.cat346 = managedairport.cat346;
                                       detairport.cat350 = managedairport.cat350;
                                       detairport.cat380 = managedairport.cat380;
                                       detairport.cat777 = managedairport.cat777;
                                       detairport.cat787 = managedairport.cat787;
                                       detairport.note32x = managedairport.note32x;
                                       detairport.note332 = managedairport.note332;
                                       detairport.note333 = managedairport.note333;
                                       detairport.note345 = managedairport.note345;
                                       detairport.note346 = managedairport.note346;
                                       detairport.note350 = managedairport.note350;
                                       detairport.note380 = managedairport.note380;
                                       detairport.note777 = managedairport.note777;
                                       detairport.note787 = managedairport.note787;
                                       detairport.rffnotes = managedairport.rffnotes;
                                       detairport.rff = managedairport.rff;
                                       detairport.rffnotes = managedairport.rffnotes;
                                       detairport.peg = managedairport.peg;
                                       detairport.pegnotes = managedairport.pegnotes;
                                       detairport.iataidentifier = managedairport.iataidentifier;
                                       detairport.icaoidentifier = managedairport.icaoidentifier;
                                       detairport.name = managedairport.name;
                                       detairport.chart = managedairport.chart;
                                       detairport.adequate = managedairport.adequate;
                                       detairport.escaperoute = managedairport.escaperoute;
                                       detairport.updatedAt = managedairport.updatedAt;
                                       detairport.city = managedairport.city;
                                       detairport.cpldg = managedairport.cpldg;
                                       detairport.elevation = managedairport.elevation;
                                       detairport.latitude = managedairport.latitude;
                                       detairport.longitude = managedairport.longitude;
                                       detairport.timezone = managedairport.timezone;
                                       [[User sharedUser].arrayAlternates addObject:detairport];
                                   }

                                   [self.parentViewController.navigationController popViewControllerAnimated:YES];

                               }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    

}

#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        [[User sharedUser].arrayEscapeRoutes addObject:self.escapewpt];
        [self.parentViewController.navigationController popViewControllerAnimated:YES];    }
    else
    {
        
        [self.parentViewController.navigationController popViewControllerAnimated:YES];
    }
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSLog(@"viewForZoomingInScrollView");
    return self.imgviewEscape;
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
