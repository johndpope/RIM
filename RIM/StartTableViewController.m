//
//  StartTableViewController.m
//  RIM
//
//  Created by Mikel on 19.04.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "StartTableViewController.h"
#import "MBProgressHUD.h"
#import "SDSyncEngine.h"
#import "User.h"
#import <tgmath.h>
#import "Fiddler.h"
#import "EDSunriseSet.h"
#import "SunFlightresults.h"

@interface StartTableViewController () <MBProgressHUDDelegate>
{
    NSURL *fileURL;
    BOOL fltpln;
    BOOL bolWeather;
    BOOL bolWpt;
    BOOL bolLog;
    BOOL bolAlt;
    BOOL bolEnrAlt;
    BOOL bolAirportNOTAMS;
    BOOL bolAirportExists;
    BOOL bolETOPS;
    BOOL bolTimes;
    BOOL bolreadHeader;
    //    NSArray * arrAlternates;
    NSMutableString *strFltpln;
    NSMutableString *strInfoMessage;
    NSMutableString *strAlternates;
    NSMutableString *strWeather;
    NSMutableString *strExportWeather;
    NSMutableString *strNOTAMS;
    NSMutableString *strExportNOTAMS;
    objWPT *objEnRouteWpt;
    objLog *objLogWpt;
    EscapeWaypoint *WPTescape;
    Country *airportLog;
    NSString *btnFltplanTitle;
    MBProgressHUD *HUD;
    NSInteger intSelectedWaypoint;
}
@property(nonatomic) NSURL *fileURL;

@end

@implementation StartTableViewController
{
    ReaderViewController *readerViewController;
}
@synthesize btnAircraft,btnFlightplan,fileURL,btnInfo,btnRefresh;
@synthesize addDateCompletionBlock;
@synthesize customHeader;

NSString * const DateFormat = @"dd/MMM/yyyy";

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
//    [self.tableView setBackgroundView:nil];
//    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 55;
    [self.navigationController.navigationBar setBounds :CGRectMake(0, 0, 320, 100)];
    //        btnFlightplan = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"waypoint_map-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(chooseFlightPlanButtonTapped:)];
    //        btnAircraft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"airplane_take_off-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(chooseAircraftButtonTapped:)];
//    btnRefresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"process-32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshButtonTouched:)];
    //    btnInfo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(infoButtonTapped:)];
//    btnInfo = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(infoButtonTapped:)];
    btnAircraft = [[UIBarButtonItem alloc]initWithTitle:@"| Aircraft |" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAircraftButtonTapped:)];
    btnFlightplan = [[UIBarButtonItem alloc] initWithTitle:@"| FlightPlan |" style:UIBarButtonItemStylePlain target:self action:@selector(chooseFlightPlanButtonTapped:)];
    // Blur Effect
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    [bluredEffectView setFrame:self.tableView.bounds];
    
//    [self.tableView addSubview:bluredEffectView];
//    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        self.tableView.backgroundColor = [UIColor clearColor];
//        
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        blurEffectView.frame = self.view.bounds;
//        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        
//        [self.tableView addSubview:blurEffectView];
//    }
//    else {
//        self.tableView.backgroundColor = [UIColor blackColor];
//    }
//    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnFlightplan, btnAircraft, nil]];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnRefresh, btnInfo, nil]];
//    [self createHeader];
    //    UITabBarItem *tabBarItem = [[[[self tabBarController]tabBar]items] objectAtIndex:1];
    //    [tabBarItem setEnabled:FALSE];
    
//    self.backgroundColorView.opaque = NO; self.backgroundColorView.alpha = 0.5; self.backgroundColorView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", [User sharedUser].strSelectedWaypoint];
    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
    if ([result count] != 0) {
        intSelectedWaypoint = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
    }else{
        intSelectedWaypoint = 0;
        [User sharedUser].strSelectedWaypoint = @"";
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:intSelectedWaypoint inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
    

//    [self checkSyncStatus];
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
//        //        [self loadRecordsFromCoreData];
//        //        [self.tableView reloadData];
//    }];
//    [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [User sharedUser].bolPopupWaypoints = YES;

//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
//    [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)applicationEnteredForeground:(NSNotification *)notification {
    NSLog(@"Application Entered Foreground");
    
}



#pragma mark - IBActions

-(IBAction)chooseAircraftButtonTapped:(id)sender

{
    if (_aircraftPicker == nil) {
        //Create the DensityPickerViewController.
        _aircraftPicker = [[AircraftPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //Set this VC as the delegate.
        _aircraftPicker.delegate = self;
    }
    
    if (_aircraftPickerPopover == nil) {
        //The color picker popover is not showing. Show it.
        _aircraftPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_aircraftPicker];
        [_aircraftPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [_aircraftPickerPopover dismissPopoverAnimated:YES];
        _aircraftPickerPopover = nil;
    }
}

-(IBAction)chooseFlightPlanButtonTapped:(id)sender

{
    if (_flightplanPicker == nil) {
        //Create the DensityPickerViewController.
        _flightplanPicker = [[FlightPlanPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //Set this VC as the delegate.
        _flightplanPicker.delegate = self;
    }
    
    if (_flightplanPickerPopover == nil) {
        //The color picker popover is not showing. Show it.
        _flightplanPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_flightplanPicker];
        [_flightplanPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [_flightplanPickerPopover dismissPopoverAnimated:YES];
        _flightplanPickerPopover = nil;
    }
}


-(void)selectedAircraft:(NSString *)newAircraft
{
    [User sharedUser].strAircraftType = newAircraft;
    
    //Dismiss the popover if it's showing.
    if (_aircraftPickerPopover) {
        [_aircraftPickerPopover dismissPopoverAnimated:YES];
        _aircraftPickerPopover = nil;
    }
    btnAircraft.title = [User sharedUser].strAircraftType;
    //    [[[[[self tabBarController] viewControllers] objectAtIndex: 0] tabBarItem] setTitle:[User sharedUser].strAircraftType];
    
}
-(void)selectedFlightPlan:(NSString *)newFlightPlan
{
    //    [User sharedUser].strAircraftType = newAircraft;
    
    //Dismiss the popover if it's showing.
    if (_flightplanPickerPopover) {
        [_flightplanPickerPopover dismissPopoverAnimated:YES];
        _flightplanPickerPopover = nil;
    }
    //        NSString *title = [documents objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/Inbox", documentsDirectory ];
    [User sharedUser].strPathOFP = [[path stringByAppendingString:@"/"]stringByAppendingString:newFlightPlan];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    [[User sharedUser].arrayEnRouteWaypoints removeAllObjects];
    [[User sharedUser].arrayLog removeAllObjects];
    convertPDF([User sharedUser].strPathOFP);
    [self showWithLabel];
    
    
    
}

-(void)selectedWaypoint:(NSString *)newWaypoint
{
    
}
- (void)showWithLabel {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Reading OFP ...";
    
    [HUD showWhileExecuting:@selector(readOFP) onTarget:self withObject:nil animated:YES];
}

-(void) readOFP
{
    [self readtxtFile];
    [self.tableView reloadData];
    //    btnInfo.title = @"| Flight Info |";
    btnAircraft.title = [User sharedUser].strAircraftType;
    btnFlightplan.title = btnFltplanTitle;
    [User sharedUser].strFltplanTitle = btnFltplanTitle;
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMMyy"];
    dateString = [formatter stringFromDate:[User sharedUser].dateFlight];
    [User sharedUser].strOFPHeader = [[[[User sharedUser].strOFPHeader stringByAppendingString:@" "]stringByAppendingString:dateString] stringByAppendingString:@" "];
    if ([[User sharedUser].arrayEnRouteWaypoints count] != 0) {
        UITabBarItem *tabBarItem = [[[[self tabBarController]tabBar]items] objectAtIndex:1];
        [tabBarItem setEnabled:TRUE];
    }else{
        UITabBarItem *tabBarItem = [[[[self tabBarController]tabBar]items] objectAtIndex:1];
        [tabBarItem setEnabled:FALSE];
    }
}
#pragma mark - Table view data source

- (IBAction)refreshButtonTouched:(id)sender {
    [[SDSyncEngine sharedEngine] startSync];
}

- (void)checkSyncStatus {
    if ([[SDSyncEngine sharedEngine] syncInProgress]) {
        [self replaceRefreshButtonWithActivityIndicator];
    } else {
        [self removeActivityIndicatorFromRefreshButton];
    }
}

- (void)replaceRefreshButtonWithActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)removeActivityIndicatorFromRefreshButton {
    self.navigationItem.rightBarButtonItem = self.refreshButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
//        [self checkSyncStatus];
    }
}

- (void)appplicationIsActive:(NSNotification *)notification {
    NSLog(@"Application Did Become Active");
}

-(void)createHeader
{
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 102)
        {
            [subView removeFromSuperview];
        }
    }
    CGFloat yPosition = 0;
    //    customHeader = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, self.view.frame.size.width,25 )];
    customHeader = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, yPosition, 200,20 )];
    
    customHeader.backgroundColor = [UIColor redColor]; /*#373334*/
    customHeader.tag = 102;
    [self.view addSubview:customHeader];
    [self.tableView.superview addSubview:customHeader];
    [self.tableView setContentInset:UIEdgeInsetsMake(yPosition + 10, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)];
    UIButton *btnHeader1 = [[UIButton alloc]init];
    btnHeader1 = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [btnHeader1 setFrame:CGRectMake(0,5 , 200,10 )];
    [btnHeader1.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    [btnHeader1 setTitleColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1] forState:UIControlStateNormal];
    ////    [btnHeader1 addTarget:self action:@selector(showHeader) forControlEvents:UIControlEventTouchUpInside];
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yy"];
    dateString = [formatter stringFromDate:[User sharedUser].dateFlight];
        
    [btnHeader1 setTitle:[[[[[[[[[[[[[[[User sharedUser].strOFPNumber stringByAppendingString:@" "] stringByAppendingString:[User sharedUser].strFlightIdentifier]stringByAppendingString:@" "] stringByAppendingString:dateString]stringByAppendingString:@" "] stringByAppendingString: [User sharedUser].strFltplanTitle] stringByAppendingString:@" "] stringByAppendingString: [User sharedUser].strAircraftRegistration] stringByAppendingString:@" "]stringByAppendingString: [User sharedUser].strAircraftType] stringByAppendingString:@" "] stringByAppendingString:[User sharedUser].strTripDuration] stringByAppendingString:@" F"]stringByAppendingString:[User sharedUser].strInitialAltitude] forState:UIControlStateNormal];
    [btnHeader1 setTitle:@"Load OFP" forState:UIControlStateNormal];
    [customHeader addSubview:btnHeader1];
}


#pragma mark - Parsing PDF



-(void) readtxtFile
{
    
    fltpln = NO;
    bolWeather = NO;
    bolWpt = NO;
    bolLog = NO;
    bolETOPS = NO;
    bolTimes = NO;
    btnFltplanTitle = @"";
    bolAirportNOTAMS = NO;
    [User sharedUser].arrayWXNotams = [[NSMutableArray alloc] init];
    __block NSRange rangeTimes;
    strFltpln = [NSMutableString stringWithString:@""];
    strAlternates = [NSMutableString stringWithString:@""];
    strInfoMessage = [NSMutableString stringWithString:@""];
    strExportWeather = [NSMutableString stringWithString:@""];
    strExportNOTAMS = [NSMutableString stringWithString:@""];
    NSString *path = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"output.txt"]encoding:NSUTF8StringEncoding error:nil];
    fileURL = [NSURL fileURLWithPath:path];
    OFPreadObject * reader = [[OFPreadObject alloc] initWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"output.txt"]];
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        
        if ([line isEqualToString:@"\r\n"] || [line containsString:@"NIL"]) {
            
        } else {
            
            if (bolreadHeader==YES && [line containsString:@"ETOW"]) {
                [strInfoMessage appendString:line];
                bolreadHeader = NO;
            }
            if (bolreadHeader==YES) {
                if ([line containsString:@"ATC C/S"]) {
                    
                    [User sharedUser].strFlightIdentifier = [[line substringWithRange:NSMakeRange(8, 8)]stringByTrimmingCharactersInSet:
                                                             [NSCharacterSet whitespaceCharacterSet]];
                    NSRange rangeOFP = [line rangeOfString:@"OFP"];
                    [User sharedUser].strOFPNumber = [[line substringWithRange:NSMakeRange(rangeOFP.location, 7)]stringByTrimmingCharactersInSet:
                                                      [NSCharacterSet whitespaceCharacterSet]];
                    
                }
                if ([line containsString:@"AVG W/C"]) {
                    [User sharedUser].strAircraftType = [line substringWithRange:NSMakeRange(6, 4)];
                    [User sharedUser].strAircraftRegistration = [line substringWithRange:NSMakeRange(0, 5)];
                    
                    if ([[User sharedUser].strAircraftType containsString:@"A32"]) {
                        [User sharedUser].strAircraft = @"Narrowbody";
                    }else{
                        [User sharedUser].strAircraft = @"Widebody";
                    }
                }
                [strInfoMessage appendString:line];
            }
            if (bolreadHeader==NO && [line containsString:@"[ OFP ]"]) {
                bolreadHeader=YES;
            }
            
            if (fltpln == YES && [line containsString:@"TCAS)"]) {
                fltpln = NO;
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                [strFltpln appendString:@"\n"];
                //                NSLog(@"read line: %@", line);
            }
            if (fltpln == YES) {
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                //                NSRange range = [line rangeOfString:@"/"];
                if ([line containsString:@"-"] && [[line substringWithRange:NSMakeRange(5, 1)]isEqualToString:@"/"]) {
                    [User sharedUser].strAircraftType = [line substringWithRange:NSMakeRange(1, 4)];
                    if ([[User sharedUser].strAircraftType containsString:@"A32"]) {
                        [User sharedUser].strAircraftLog = @"Narrowbody";
                        [User sharedUser].strAircraft = @"Narrowbody";
                    }else{
                        [User sharedUser].strAircraftLog = @"Widebody";
                        [User sharedUser].strAircraft = @"Widebody";
                    }
                }
                if ([line containsString:@"DOF/"]) {
                    NSRange rangeDate = [line rangeOfString:@"DOF/"];
                    NSDateComponents *components3 = [[NSDateComponents alloc] init];
                    [components3 setYear:[[@"20" stringByAppendingString:[line substringWithRange:NSMakeRange(rangeDate.location+4, 2)] ]integerValue]];
                    [components3 setMonth:[[line substringWithRange:NSMakeRange(rangeDate.location+6, 2)]integerValue]];
                    [components3 setDay:[[line substringWithRange:NSMakeRange(rangeDate.location+8, 2)]integerValue]];
                    
                    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian]; // Setup an NSCalendar
                    // Setup the new date
                    NSDate *combinedDate = [gregorianCalendar dateFromComponents: components3];
                    
                    
                    // Generate a new NSDate from components3.
                    
                    [User sharedUser].dateFlight = combinedDate;
                }
                [strFltpln appendString:@"\n"];
                //                NSLog(@"read line: %@", line);
            }
            if ([line containsString:@"(FPL"]) {
                fltpln = YES;
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                [strFltpln appendString:@"\n"];
                //                NSLog(@"read line: %@", line);
            }
            if ([line containsString:@"ROUTE:"]) {
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                [strFltpln appendString:@"\n"];
                //                NSLog(@"read line: %@", line);
            }
            /////////////// Weather for Airports
            if ([line containsString:@"AIRPORTLIST ENDED"]) {
                bolWeather = NO;
            }
            if (bolWeather == YES) {
                
                if ([line containsString:@"ETD"] || [line containsString:@"Page"]){
                }else{
                    [strExportWeather appendString:[NSString stringWithFormat:@"%@", line]];
                    [strExportWeather appendString:@"\n"];
                }
            }
            if ([line containsString:@"DESTINATION AIRPORT:"]) {
                bolWeather = YES;
            }
            //////// Weather Waypoints
            if (bolWpt == YES && [line containsString:@"[ ATC Flight Plan ]"]) {
                bolWpt = NO;
            }
            if (bolWpt == YES) {
                if ([line containsString:@"ETD"] || [line containsString:@"Page"] || [line containsString:@"EY"]){
                }else{
//                    [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
//                    [strFltpln appendString:@"\n"];
                    //                NSLog(@"read line: %@", line);
                    if ([[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"N"] || [[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"S"]) {
                        objEnRouteWpt = [[objWPT alloc]init];
                        objEnRouteWpt.strLat = [line substringWithRange:NSMakeRange(0, 5)];
                        objEnRouteWpt.strWptName = [[line substringWithRange:NSMakeRange(6, 10)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                           withString:@""];
                    }
                    if ([[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"E"] || [[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"W"]) {
                        objEnRouteWpt.strLon = [line substringWithRange:NSMakeRange(0, 6)];
                        objEnRouteWpt.strSR = [line substringWithRange:NSMakeRange(43, 10)];
                        [[User sharedUser].arrayEnRouteWaypoints addObject:objEnRouteWpt];
                    }
                }
            }
            if (bolWpt == NO && [line containsString:@"LONG"] && [line containsString:@"POINT"] && [line containsString:@"SR/TROP/OAT"]) {
                bolWpt = YES;
            }
            //////////////////// Reading Block and Takeoff Times
            
            if (bolTimes == YES && [line containsString:@"BLOCK TIME"]) {
                bolTimes = NO;
            }
            
            if (bolTimes == YES) {
                if ([line containsString:@"TAKEOFF"]) {
                    [User sharedUser].strTakeOffTime = [[line substringWithRange:NSMakeRange(rangeTimes.location, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                withString:@""];
                    NSString *TakeOffhours = [[User sharedUser].strTakeOffTime substringWithRange:NSMakeRange(0,2)];
                    NSString *TakeOffMinutes = [[User sharedUser].strTakeOffTime substringWithRange:NSMakeRange(2,2)];
                    NSInteger hour = [TakeOffhours integerValue];
                    NSInteger min = [TakeOffMinutes integerValue];
                    [User sharedUser].intTimeOvhdFROM = ((hour*60)+min)*60;
                    
                }
                if ([line containsString:@"OFF BLOCK"]) {
                    [User sharedUser].strOffBlockTime = [[line substringWithRange:NSMakeRange(rangeTimes.location, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                 withString:@""];
                }
                if ([line containsString:@"LANDING"]) {
                    [User sharedUser].strLandingTime = [[line substringWithRange:NSMakeRange(rangeTimes.location, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                withString:@""];
                }
                
                
            }
            if (bolTimes == NO && [line containsString:@"SCHEDULED        ESTIMATED        ACTUAL"]) {
                bolTimes = YES;
                rangeTimes = [line rangeOfString:@"ESTIMATED"];
            }
            
            //////////////////// Reading Enroute Alternates
            
            if (bolEnrAlt == YES && [line containsString:@"DEPARTURE AIRPORT:"]) {
                bolEnrAlt = NO;
            }
            
            if (bolEnrAlt == YES) {
                if ([line length] > 7) {
                    
                    if ([[line substringWithRange:NSMakeRange(0, 7)]containsString:@"/"]) {
                        [strAlternates appendString:[line substringWithRange:NSMakeRange(0, 4)]];
                        [strAlternates stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]];
                        [strAlternates appendString:@" "];
                    }
                }
            }
            
            if (bolEnrAlt == NO && [line containsString:@"ENROUTE AIRPORT(S):"]) {
                bolEnrAlt = YES;
                
            }
            
            /////////////////// Reading the Alternates
            
            if (bolAlt == YES && ([line containsString:@"FUEL ENROUTE AIRPORT:"]||[line containsString:@"ENROUTE AIRPORT"])) {
                bolAlt = NO;
            }
            
            if (bolAlt == YES) {
                if ([line length] > 7) {
                    if ([[line substringWithRange:NSMakeRange(0, 7)]containsString:@"/"]) {
                        [strAlternates appendString:[line substringWithRange:NSMakeRange(0, 4)]];
                        [strAlternates stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]];
                        [strAlternates appendString:@" "];
                    }
                }
            }
            
            if (bolAlt == NO && [line containsString:@"DESTINATION ALTERNATE:"]) {
                
                bolAlt = YES;
                
            }            /////////////////// Reading the Log
            
            if (bolLog == YES && [line containsString:@"DESTINATION ALTERNATE FLIGHT LOG"]) {
                bolLog = NO;
                objLogWpt = [[User sharedUser].arrayLog lastObject];
                [User sharedUser].strDestination = objLogWpt.strWptName;
                [self searchAirports];
                NSString *strAlt = strAlternates;
                strAlt = [strAlt stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceCharacterSet]];
                strAlt = [strAlt stringByReplacingOccurrencesOfString:@" "
                                                           withString:@", "];
                objLogWpt.strAlternates = strAlt;
            }
            
            if (bolLog == YES) {
                if ([line containsString:@"|AWY"] || [line containsString:@"|WPT"] || [line containsString:@"OCA PLN"] || [line containsString:@"VHF:"] || [line containsString:@"HF :"] || [line containsString:@"OCA RECVD"] || [line containsString:@"IMT ERROR"] || [line containsString:@"|DP "]) {
                }else{
                    if ([line containsString:@"|EDTO"] ) {
                        objLogWpt = [[objLog alloc]init];
                        NSRange range = [line rangeOfString:@"|"];
                        objLogWpt.strLat = [[line substringWithRange:NSMakeRange(range.location + 13, 8)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                    withString:@""];
                        objLogWpt.strLon = [[line substringWithRange:NSMakeRange(range.location + 24, 8)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                    withString:@""];
                        objLogWpt.strCET = [[line substringWithRange:NSMakeRange(range.location + 38, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                    withString:@""];
                        objLogWpt.strWptName = [[line substringWithRange:NSMakeRange(range.location + 5, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                       withString:@""];
                        objLogWpt.strType = @"ETOPS";
                        objLogWpt.intID = [[User sharedUser].arrayLog count]+1;
                        [[User sharedUser].arrayLog addObject:objLogWpt];
                    }
                    if ([line containsString:@"-"]) {
                        
                    } else{
                        if ([line containsString:@"_"]) {
                            objLogWpt = [[objLog alloc]init];
                            NSRange range = [line rangeOfString:@"|"];
                            objLogWpt.strWptAirway = [[line substringWithRange:NSMakeRange(range.location + 1, 7)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                             withString:@""];
                            objLogWpt.strFL = [[line substringWithRange:NSMakeRange(range.location + 9, 3)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                      withString:@""];
                            objLogWpt.strITT = [[line substringWithRange:NSMakeRange(range.location + 14, 3)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                        withString:@""];
                            objLogWpt.strTAS = [[line substringWithRange:NSMakeRange(range.location + 19, 3)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                        withString:@""];
                            objLogWpt.strCET = [[line substringWithRange:NSMakeRange(range.location + 29, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                        withString:@""];
                            objLogWpt.strLat = @"";
                            objLogWpt.strLon = @"";
                            objLogWpt.strAlternates = @"";
                        }else{
                            if ([line containsString:@"|"]) {
                                
                                if ([line containsString:@"FIR"] || [line containsString:@"UIR"] || [line containsString:@"UTA"] || [line containsString:@"OCEANIC"] || [line containsString:@"ENOB NORGE USSR"] || [line containsString:@"DOMESTIC"]) {
                                    objLogWpt = [[objLog alloc]init];
                                    NSRange range = [line rangeOfString:@"|"];
                                    objLogWpt.strWptName = [[line substringWithRange:NSMakeRange(range.location + 1, 5)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                   withString:@""];
                                    
                                    
                                    objLogWpt.strWptAirway = [[line stringByReplacingOccurrencesOfString:@"|" withString:@""]stringByTrimmingCharactersInSet:
                                                              [NSCharacterSet whitespaceCharacterSet]];
                                    objLogWpt.strLat = @"";
                                    objLogWpt.strLon = @"";
                                    objLogWpt.strType = @"Boundary";
                                    objLogWpt.intID = [[User sharedUser].arrayLog count]+1;
                                    [[User sharedUser].arrayLog addObject:objLogWpt];
                                    
                                }else {
                                    if ([line containsString:@"|EDTO"] ) {
                                        
                                    }else{
                                        NSRange range = [line rangeOfString:@"|"];
                                        objLogWpt.strWptName = [[line substringWithRange:NSMakeRange(range.location + 1, 5)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                       withString:@""];
                                        if ([objLogWpt.strWptName isEqualToString:@"TOC"]) {
                                            [User sharedUser].strInitialAltitude = objLogWpt.strFL;
                                        }
                                        
                                        objLogWpt.strMORA = [[line substringWithRange:NSMakeRange(range.location + 7, 5)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                    withString:@""];
                                        objLogWpt.strDTW = [[line substringWithRange:NSMakeRange(range.location + 24, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                    withString:@""];
                                        objLogWpt.strEET = [[line substringWithRange:NSMakeRange(range.location + 29, 4)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                    withString:@""];
                                        
                                        //                                    [self searchEscapeRoutes];
                                        objLogWpt.intID = [[User sharedUser].arrayLog count]+1;
                                        [[User sharedUser].arrayLog addObject:objLogWpt];
                                        if ([[User sharedUser].arrayLog count]==1) {
                                            [User sharedUser].strDeparture = objLogWpt.strWptName;
                                            [self searchAirports];
                                            if ([[User sharedUser].strDeparture isEqualToString:@"OMAA"]) {
                                                [User sharedUser].strDirectionLog = @"OUTBOUND";
                                            }else{
                                                [User sharedUser].strDirectionLog = @"INBOUND";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (bolLog == NO && [line containsString:@"FLIGHT DESTINATION LOG"]) {
                bolLog = YES;
            }
            
            // Start reading the Notams and export them to notams.txt
            
            if (bolAirportNOTAMS == YES && [line containsString:@"EXTENDED AREA AROUND DEPARTURE"]) {
                [strExportNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                bolAirportNOTAMS = NO;
            }
            if (bolAirportNOTAMS == YES) {
                if ([line containsString:@"ETD"] || [line containsString:@"Page"] || [line containsString:@"Page"]){
                }else{
                    [strExportNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                }
            }
            if (bolAirportNOTAMS == NO && [line containsString:@"DEPARTURE AIRPORT"] &&bolWeather == NO) {
                //                [strExportNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                bolAirportNOTAMS = YES;
            }
        }
        NSLog(@"read line: %@", line);
    }];
    /// notams end
    int i;
    for (i = 0; i < [[User sharedUser].arrayEnRouteWaypoints count]; i++) {
        objEnRouteWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objEnRouteWpt.strWptName];
        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
        if ([result count] == 0) {
            
        }else{
            
            objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexOfTheObject];
            if ([objLogWpt.strType length] == 0) {
                objLogWpt.strType = @"Waypoint";
            }
            objEnRouteWpt.strWptAirway = objLogWpt.strWptAirway;
            objEnRouteWpt.strType = objLogWpt.strType;
            objEnRouteWpt.strMORA = objLogWpt.strMORA;
            objLogWpt.strLat = objEnRouteWpt.strLat;
            objLogWpt.strLon = objEnRouteWpt.strLon;
            objLogWpt.strSR = objEnRouteWpt.strSR;
            
        }
    }
    objLogWpt = [[User sharedUser].arrayLog objectAtIndex:0];
    [[User sharedUser].arrayEnRouteWaypoints insertObject:objLogWpt atIndex:0];
    objLogWpt = [[User sharedUser].arrayLog lastObject];
    [[User sharedUser].arrayEnRouteWaypoints addObject:objLogWpt];
    
    //// reorganize Airways for Waypoints
    
    objLog *objLogWptNext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strType ==  %@", @"Waypoint"];
    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
    objLogWptNext = [objLog alloc];
    NSMutableArray *myMutableLog = [result mutableCopy];
    
    for (i = 0; i < [myMutableLog count]; i++) {
        objLogWpt = [myMutableLog objectAtIndex:i];
        if (i <= [myMutableLog count]-2) {
            objLogWptNext = [myMutableLog objectAtIndex:i+1];
            objLogWpt.strWptAirway = objLogWptNext.strWptAirway;
            
        }
    }
    //// putting all arrays together again
    predicate = [NSPredicate predicateWithFormat:@"strType !=  %@", @"Waypoint"];
    NSArray *resultRestLog = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
    NSArray *newArrayLog=[resultRestLog arrayByAddingObjectsFromArray:myMutableLog];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"intID"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArrayLog;
    sortedArrayLog = [newArrayLog sortedArrayUsingDescriptors:sortDescriptors];
    [User sharedUser].arrayLog = [sortedArrayLog mutableCopy];
    
    //// reorganize CET for all Points
    
    //    objLog *objLogWptNext;
    predicate = [NSPredicate predicateWithFormat:@"strCET !=  %@", @""];
    result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
    objLogWptNext = [objLog alloc];
    myMutableLog = [result mutableCopy];
    
    for (i = 0; i < [myMutableLog count]; i++) {
        objLogWpt = [myMutableLog objectAtIndex:i];
        if (i <= [myMutableLog count]-2) {
            objLogWptNext = [myMutableLog objectAtIndex:i+1];
            //            objLogWpt.strCET = objLogWptNext.strCET;
            objLogWpt.strEET = objLogWptNext.strEET;
        }
    }
    //// putting all arrays together again
    predicate = [NSPredicate predicateWithFormat:@"strCET ==  %@",@""];
    resultRestLog = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
    newArrayLog=[resultRestLog arrayByAddingObjectsFromArray:myMutableLog];
    //    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"intID"
                                                 ascending:YES];
    sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //    NSArray *sortedArrayLog;
    sortedArrayLog = [newArrayLog sortedArrayUsingDescriptors:sortDescriptors];
    [User sharedUser].arrayLog = [sortedArrayLog mutableCopy];
    NSError *error;
    NSString *outputFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"fltpln.txt"];
    [strFltpln writeToFile:outputFileName atomically:YES
                  encoding:NSUTF8StringEncoding error:&error];
    outputFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weather.txt"];
    [strExportWeather writeToFile:outputFileName atomically:YES
                         encoding:NSUTF8StringEncoding error:&error];
    outputFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"notams.txt"];
    [strExportNOTAMS writeToFile:outputFileName atomically:YES
                        encoding:NSUTF8StringEncoding error:&error];
    [self loadAlternates];
    [self readWeather];
    [self readNOTAMS];
    [self getEnrouteAlternates];
    [self loadEnrouteAlternatesPDF];
    //    [self calcMissingCoordinates];
    if([User sharedUser].bolCalcSSSR == YES)
        
    {
        [StartTableViewController calculateSunriseSunset];
    }    // get escaperoutes for waypoints
    i=0;
    for (i = 0; i < [[User sharedUser].arrayLog count]; i++) {
        objLogWpt = [[User sharedUser].arrayLog objectAtIndex:i];
        [self searchEscapeRoutes];
    }
    i=0;
    
    for (i = 0; i < [[User sharedUser].arrayEnRouteWaypoints count]; i++) {
        objEnRouteWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objEnRouteWpt.strWptName];
        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
        if ([result count] == 0) {
        }else{
            objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexOfTheObject];
            objEnRouteWpt.strWptAirway = objLogWpt.strWptAirway;
            objEnRouteWpt.strType = objLogWpt.strType;
        }
    }
    
    double dblDecDepTime = [User sharedUser].intTimeOvhdFROM;
    NSString *LandingTimeHours = [[User sharedUser].strLandingTime substringWithRange:NSMakeRange(0,2)];
    NSString *LandingTimeMinutes = [[User sharedUser].strLandingTime substringWithRange:NSMakeRange(2,2)];
    NSInteger hour = [LandingTimeHours integerValue];
    NSInteger min = [LandingTimeMinutes integerValue];
    [User sharedUser].intTimeOvhdTO = ((hour*60)+min)*60;
    double dblDecArrTime = [User sharedUser].intTimeOvhdTO;
    double dblFlighttime;
    if (dblDecDepTime > dblDecArrTime) {
        dblDecArrTime = dblDecArrTime + 86400;
    }
    dblFlighttime = dblDecArrTime - dblDecDepTime;
    [User sharedUser].strTripDuration = [[NSString stringWithFormat:@"%02.0f",floor((dblFlighttime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblFlighttime)/3600 - floor((dblFlighttime)/3600))*60]];
}


-(void) readWeather
{
    bolWeather = YES;
    
    strWeather = [NSMutableString stringWithString:@""];
    NSString *path = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"weather.txt"]encoding:NSUTF8StringEncoding error:nil];
    fileURL = [NSURL fileURLWithPath:path];
    OFPreadObject * reader = [[OFPreadObject alloc] initWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"weather.txt"]];
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        
        
        if ([line isEqualToString:@"\r\n"] || [line containsString:@"NIL"] || [line isEqualToString:@"\n"] || [line length] < 7) {
        } else {
            if (bolWeather == YES && [line containsString:@"ROUTE:"]) {
                if ([strWeather length] != 0) {
                    NSString *strICAO = [strWeather substringWithRange:NSMakeRange(0, 4)];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
                    NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
                    if ([result count] != 0) {
                        NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
                        Airport *airport = [[Airport alloc] init];
                        airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
                        airport.strMETAR = strWeather;
                        
                    }
                    strWeather = [NSMutableString stringWithString:@""];
                }
                bolWeather = NO;
            }
            if (bolWeather == YES && [[line substringWithRange:NSMakeRange(4, 1)]isEqualToString:@"/"]) {
                bolAirportExists = NO;
                if ([strWeather length] != 0) {
                    NSString *strICAO = [strWeather substringWithRange:NSMakeRange(0, 4)];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
                    NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
                    if ([result count] != 0) {
                        NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
                        Airport *airport = [[Airport alloc] init];
                        airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
                        airport.strMETAR = strWeather;
                        NSLog(@"%@",strWeather);
                    } else {
                        ////////////////////////////// adding missing airports
                        NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
                        int i;
                        for (i = 0; i < [arrMasterEntity count]; i++) {
                            
                            if (self.managedObjectContext)
                            {
                                [self.managedObjectContext performBlockAndWait:^{
                                    [self.managedObjectContext reset];
                                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                                    [NSFetchedResultsController deleteCacheWithName:@"Airports"];
                                    NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
                                    [fetchRequest setEntity:entity];
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier = %@", strICAO];
                                    [fetchRequest setPredicate:predicate];
                                    NSInteger intRecordsCount;
                                    NSError *error = nil;
                                    [fetchRequest setFetchLimit:1000];
                                    
                                    intRecordsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
                                    if (intRecordsCount == 1) {
                                        bolAirportExists = YES  ;
                                    }
                                }];
                            }
                        }
                        if (bolAirportExists == NO) {
                            NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
                            [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ICAOIdentifier ==  %@", strICAO];
                            NSArray *result = [[User sharedUser].arrayAllAirports filteredArrayUsingPredicate: predicate];
                            if ([result count] != 0) {
                                Airports *detairport = [NSEntityDescription insertNewObjectForEntityForName:@"AirportsImported" inManagedObjectContext:context];
                                Airport *newAirport = [[Airport alloc]init];
                                NSDate *now = [NSDate date];
                                [detairport setValue:[NSNumber numberWithInt:SDObjectCreated] forKey:@"syncStatus"];
                                NSArray *myArr = [result valueForKey:@"IATAIdentifier"];
                                NSLog(@"%@",[myArr objectAtIndex:0]);
                                detairport.iataidentifier = [myArr objectAtIndex:0];
                                newAirport.iataidentifier = [myArr objectAtIndex:0];
                                myArr = [result valueForKey:@"ICAOIdentifier"];
                                detairport.icaoidentifier = [myArr objectAtIndex:0];
                                newAirport.icaoidentifier = [myArr objectAtIndex:0];
                                myArr = [result valueForKey:@"Name"];
                                detairport.name = [myArr objectAtIndex:0];
                                newAirport.name = [myArr objectAtIndex:0];
                                myArr = [result valueForKey:@"City"];
                                detairport.date = now;
                                detairport.city = [myArr objectAtIndex:0];
                                newAirport.city = [myArr objectAtIndex:0];
                                myArr = [result valueForKey:@"Elevation"];
                                NSString *intElevation = [myArr objectAtIndex:0];
                                intElevation = [intElevation stringByAppendingString:@".0"];
                                double dblElevation = [intElevation doubleValue];
                                [detairport setValue:[NSNumber numberWithDouble:dblElevation] forKey:@"elevation"];
                                newAirport.elevation = dblElevation;
                                myArr = [result valueForKey:@"Latitude"];
                                NSString *intLatitude = [myArr objectAtIndex:0];
                                double dblLatitude = [intLatitude doubleValue];
                                [detairport setValue:[NSNumber numberWithDouble:dblLatitude] forKey:@"Latitude"];
                                newAirport.latitude = dblLatitude;
                                myArr = [result valueForKey:@"Longitude"];
                                NSString *intLongitude = [myArr objectAtIndex:0];
                                double dblLongitude = [intLongitude doubleValue];
                                [detairport setValue:[NSNumber numberWithDouble:dblLongitude] forKey:@"Longitude"];
                                newAirport.longitude = dblLongitude;
                                myArr = [result valueForKey:@"TimeZone"];
                                detairport.timezone = [myArr objectAtIndex:0];
                                newAirport.timezone = [myArr objectAtIndex:0];
                                [newAirport.country setValue:@"" forKey:@"country"];
                                [detairport.cat32x setValue:@"" forKey:@"cat32x"];
                                [detairport.cat332 setValue:@"" forKey:@"cat332"];
                                [detairport.cat333 setValue:@"" forKey:@"cat333"];
                                [detairport.cat345 setValue:@"" forKey:@"cat345"];
                                [detairport.cat346 setValue:@"" forKey:@"cat346"];
                                [detairport.cat350 setValue:@"" forKey:@"cat350"];
                                [detairport.cat380 setValue:@"" forKey:@"cat380"];
                                [detairport.cat777 setValue:@"" forKey:@"cat777"];
                                [detairport.cat787 setValue:@"" forKey:@"cat787"];
                                [detairport.note32x setValue:@"" forKey:@"note32x"];
                                [detairport.note332 setValue:@"" forKey:@"note332"];
                                [detairport.note333 setValue:@"" forKey:@"note333"];
                                [detairport.note345 setValue:@"" forKey:@"note345"];
                                [detairport.note346 setValue:@"" forKey:@"note346"];
                                [detairport.note350 setValue:@"" forKey:@"note350"];
                                [detairport.note380 setValue:@"" forKey:@"note380"];
                                [detairport.note777 setValue:@"" forKey:@"note777"];
                                [detairport.note787 setValue:@"" forKey:@"note787"];
                                [detairport.rffnotes setValue:@"" forKey:@"rffnotes"];
                                [detairport.rff setValue:@"" forKey:@"rff"];
                                [detairport.rffnotes setValue:@"" forKey:@"rffnotes"];
                                [detairport.peg setValue:@"" forKey:@"peg"];
                                [detairport.pegnotes setValue:@"" forKey:@"pegnotes"];
                                NSDate *date = now;
                                detairport.updatedAt = date;
                                detairport.adequate = NO;
                                detairport.escaperoute = NO;
                                detairport.cpldg = NO;
                                //
                                NSError *error;
                                if (![context save:&error]) {
                                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                                }
                                [[User sharedUser].arrayAlternates addObject:newAirport];
                                [[User sharedUser].arrayWXNotams addObject:newAirport];
                            } else {
                                
                            }
                        }
                    }
                    strWeather = [NSMutableString stringWithString:@""];
                    [strWeather appendString:[NSString stringWithFormat:@"%@", line]];
                } else {
                    [strWeather appendString:[NSString stringWithFormat:@"%@", line]];
                }
            }else {
                if (bolWeather == YES){
                    
                    [strWeather appendString:[NSString stringWithFormat:@"%@", line]];
                }
            }
        }
    }];
    
    // add last weather airport in list
    
    if ([strWeather length] != 0) {
        NSString *strICAO = [strWeather substringWithRange:NSMakeRange(0, 4)];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
        NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
        if ([result count] != 0) {
            NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
            Airport *airport = [[Airport alloc] init];
            airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
            airport.strMETAR = strWeather;
            NSLog(@"%@",strWeather);
        }
    }
}
-(void) readNOTAMS
{
    bolAirportNOTAMS = YES;
    __block NSString *strAirportfunction;
    strNOTAMS = [NSMutableString stringWithString:@""];
    NSString *path = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"notams.txt"]encoding:NSUTF8StringEncoding error:nil];
    fileURL = [NSURL fileURLWithPath:path];
    OFPreadObject * reader = [[OFPreadObject alloc] initWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"notams.txt"]];
    strAirportfunction = @"Enroute Alternate";
    
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        if ([line isEqualToString:@"\r\n"] || [line isEqualToString:@"\n"] || [line containsString:@"===="]) {
            
        } else {
            //            if (bolAirportNOTAMS == YES && [line containsString:@"EXTENDED AREA AROUND DEPARTURE"]) {
            //                bolAirportNOTAMS = NO;
            //            }
            if (bolAirportNOTAMS == YES) {
                if ([line length] > 7) {
                    NSRange whiteSpaceRange = [[line substringWithRange:NSMakeRange(0, 7)] rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([line containsString:@"/"] && [[line substringWithRange:NSMakeRange(4, 2)]isEqualToString:@" /"] && (whiteSpaceRange.location != NSNotFound) && [line rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
                        if ([strNOTAMS length] != 0) {
                            if ([strNOTAMS containsString:@"/DEST/"]) {
                                strAirportfunction = @"Destination Airport";
                            }else
                                if ([strNOTAMS containsString:@"/DEST ALTN/"]) {
                                    strAirportfunction = @"Destination Alternate";
                                }else
                                    if ([strNOTAMS containsString:@"ETOPS"]) {
                                        strAirportfunction = @"ETOPS Airport";
                                    }else
                                        if ([strNOTAMS containsString:@"/FUEL ALTN/"]) {
                                            strAirportfunction = @"Fuel Enroute Airport";
                                        }else
                                            if ([strNOTAMS containsString:@"/FUEL ALTN/ETOPS"]) {
                                                strAirportfunction = @"Fuel Enroute / ETOPS Airport";
                                            }else
                                                if ([strNOTAMS containsString:@"/DEP/"]) {
                                                    strAirportfunction = @"Departure Airport";
                                                }else{
                                                    strAirportfunction = @"Enroute Airport";
                                                }
                            NSString *strICAO = [[strNOTAMS stringByTrimmingCharactersInSet:
                                                  [NSCharacterSet whitespaceCharacterSet]]substringWithRange:NSMakeRange(0, 4)];
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
                            NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
                            if ([result count] != 0) {
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
                                Airport *airport = [[Airport alloc] init];
                                airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
                                airport.strNOTAMS = strNOTAMS;
                                airport.strFunction = strAirportfunction;
                                NSLog(@"%@",strNOTAMS);
                            }
                        }
                        strNOTAMS = [NSMutableString stringWithString:@""];
                        [strNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                    } else {
                        [strNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                    }
                    
                } else {
                    if (bolAirportNOTAMS == YES) {
                        [strNOTAMS appendString:[NSString stringWithFormat:@"%@", line]];
                    }
                }
            }
            //            if (bolAirportNOTAMS == NO && [line containsString:@"DEPARTURE AIRPORT"]) {
            //                bolAirportNOTAMS = YES;
            //            }
        }
    }];
    // add last airportnotam
    if ([strNOTAMS length] != 0) {
        if ([strNOTAMS containsString:@"/DEST/"]) {
            strAirportfunction = @"Destination Airport";
        }
        if ([strNOTAMS containsString:@"/DEST ALTN/"]) {
            strAirportfunction = @"Destination Alternate";
        }
        if ([strNOTAMS containsString:@"ETOPS"]) {
            strAirportfunction = @"ETOPS Airport";
        }
        if ([strNOTAMS containsString:@"/FUEL ALTN/"]) {
            strAirportfunction = @"Fuel Enroute Airport";
        }
        if ([strNOTAMS containsString:@"/FUEL ALTN/ETOPS"]) {
            strAirportfunction = @"Fuel Enroute / ETOPS Airport";
        }
        if ([strNOTAMS containsString:@"/DEP/"]) {
            strAirportfunction = @"Departure Airport";
        }
        NSString *strICAO = [[strNOTAMS stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]]substringWithRange:NSMakeRange(0, 4)];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strICAO];
        NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
        if ([result count] != 0) {
            NSUInteger indexOfTheObject = [[User sharedUser].arrayWXNotams indexOfObject:result.firstObject];
            Airport *airport = [[Airport alloc] init];
            airport = [[User sharedUser].arrayWXNotams objectAtIndex:indexOfTheObject];
            airport.strNOTAMS = strNOTAMS;
            airport.strFunction = strAirportfunction;
            NSLog(@"%@",strNOTAMS);
        }
    }
    
}
- (void) searchEscapeRoutes
{
    NSArray *arrMasterEntity;
    if ([[User sharedUser].strAircraft isEqualToString:@"Narrowbody"]) {
        if ([[User sharedUser].strDeparture isEqualToString:@"OMAA"]) {
            NSArray *arrEntitiesNarrowOutbound = [[NSArray alloc] initWithObjects:@"EscapeNarrowOutboundEurope",@"EscapeNarrowOutboundMiddleEast",@"EscapeNarrowOutboundIran",@"EscapeNarrowOutboundAfricaUSA",@"EscapeNarrowOutboundChina",nil];
            arrMasterEntity = arrEntitiesNarrowOutbound;
        } else{
            NSArray *arrEntitiesNarrowInbound = [[NSArray alloc] initWithObjects:@"EscapeNarrowInboundEurope",@"EscapeNarrowInboundMiddleEast",@"EscapeNarrowInboundIran",@"EscapeNarrowInboundAfricaUSA",@"EscapeNarrowInboundChina",nil];
            arrMasterEntity = arrEntitiesNarrowInbound;
        }
        
    }else {
        if ([[User sharedUser].strDeparture isEqualToString:@"OMAA"]) {
            NSArray *arrEntitiesWideOutbound = [[NSArray alloc] initWithObjects:@"EscapeWideOutboundEurope",@"EscapeWideOutboundMiddleEast",@"EscapeWideOutboundIran",@"EscapeWideOutboundSEAsia",@"EscapeWideOutboundChina",@"EscapeWideOutboundAfricaUSA", nil] ;
            arrMasterEntity = arrEntitiesWideOutbound;
        } else{
            NSArray *arrEntitiesWideInbound = [[NSArray alloc] initWithObjects:@"EscapeWideInboundEurope",@"EscapeWideInboundMiddleEast",@"EscapeWideInboundIran",@"EscapeWideInboundAfricaUSA",@"EscapeWideInboundSEAsia",@"EscapeWideInboundChina",nil];
            arrMasterEntity = arrEntitiesWideInbound;
        }
    }
    
    int i;
    for (i = 0; i < [arrMasterEntity count]; i++) {
        
        if (self.managedObjectContext)
        {
            [self.managedObjectContext performBlockAndWait:^{
                [self.managedObjectContext reset];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                [NSFetchedResultsController deleteCacheWithName:@"Escape"];
                NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
                [fetchRequest setEntity:entity];
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"wptname = %@", objLogWpt.strWptName];
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"airways contains[c] %@", objLogWpt.strWptAirway];
                NSPredicate *predicate;
                if ([objLogWpt.strWptAirway length]!= 0) {
                    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
                }else{
                    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1]];
                }
                [fetchRequest setPredicate:predicate];
                NSInteger intRecordsCount;
                NSError *error = nil;
                [fetchRequest setFetchLimit:1000];
                intRecordsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
                if (intRecordsCount != 0) {
                    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
                    Escape *escapewpt = nil;
                    escapewpt = [results objectAtIndex:0];
                    objLogWpt.strType = @"Escape";
                    objLogWpt.strPage = escapewpt.page;
                    objLogWpt.strChapter = escapewpt.chapter;
                    objLogWpt.strAlternates = escapewpt.alternates;
                }
            }];
        }
    }
    
}

- (void) searchAirports
{
    NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
    
    //    objLogWpt.strType = @"";
    int i;
    for (i = 0; i < [arrMasterEntity count]; i++) {
        
        if (self.managedObjectContext)
        {
            [self.managedObjectContext performBlockAndWait:^{
                [self.managedObjectContext reset];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                [NSFetchedResultsController deleteCacheWithName:@"Airports"];
                NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
                [fetchRequest setEntity:entity];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier = %@", objLogWpt.strWptName];
                [fetchRequest setPredicate:predicate];
                NSInteger intRecordsCount;
                NSError *error = nil;
                [fetchRequest setFetchLimit:1000];
                intRecordsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
                if (intRecordsCount == 1) {
                    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
                    airportLog = nil;
                    airportLog = [results objectAtIndex:0];
                    objLogWpt.strType = @"Airport";
                    objLogWpt.strLat = [NSString stringWithFormat:@"%@",airportLog.latitude];
                    objLogWpt.strLon = [NSString stringWithFormat:@"%@",airportLog.longitude];
                    [self calcTimeZone];
                    objLogWpt.strFL = airportLog.timezone;
                    objLogWpt.strMORA = [NSString stringWithFormat:@"%@",airportLog.elevation];
                    objLogWpt.strWptAirway = airportLog.iataidentifier;
                    if ([btnFltplanTitle length] == 0)
                    {
                        btnFltplanTitle = airportLog.iataidentifier;
                    } else {
                        btnFltplanTitle = [[btnFltplanTitle stringByAppendingString:@" - "] stringByAppendingString:airportLog.iataidentifier];
                        [User sharedUser].strFlightPlanTitle = btnFltplanTitle;
                        [User sharedUser].strOFPHeader = [[User sharedUser].strOFPHeader stringByAppendingString:btnFltplanTitle];
                    }
                }
                
            }];
        }
    }
    
}
-(void) loadEnrouteAlternatesPDF // for pdf reading only

{
    //    arrAlternates = [[NSArray alloc] init];
    
    NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
    
    [[User sharedUser].arrayEnrouteAirports removeAllObjects];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    for (int i=0; i < [[User sharedUser].arrayAlternates count]; i++)
    {
        //        bool bolAirportExists = NO;
        NSString *strIcaoIdentifier = [[[User sharedUser].arrayAlternates objectAtIndex:i]valueForKeyPath:@"icaoidentifier"];  //find object with this id in core data
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
        int i;
        for (i = 0; i < [arrMasterEntity count]; i++) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [NSFetchedResultsController deleteCacheWithName:@"Airports"];
            NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
            [fetchRequest setPredicate:predicate];
            NSArray *results = [context executeFetchRequest:fetchRequest error:NULL];
            if ([results count] == 1){
                bolAirportExists = YES;
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
                //                detairport.cpldg = [managedairport.cpldg boolValue];
                //                detairport.adequate = [managedairport.adequate boolValue];
                //                detairport.escaperoute = [managedairport.escaperoute boolValue];
                detairport.updatedAt = managedairport.updatedAt;
                detairport.city = managedairport.city;
                detairport.elevation = managedairport.elevation;
                detairport.latitude = managedairport.latitude;
                detairport.longitude = managedairport.longitude;
                detairport.timezone = managedairport.timezone;
                detairport.country = managedairport.country;
                detairport.alternates = managedairport.alternates;
                [[User sharedUser].arrayEnrouteAirports addObject:detairport];
                //                [[User sharedUser].arrayWXNotams addObject:detairport];
                
            }
        }
        if (bolAirportExists == NO)
        {
            NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ICAOIdentifier ==  %@", strIcaoIdentifier];
            NSArray *result = [[User sharedUser].arrayAllAirports filteredArrayUsingPredicate: predicate];
            if ([result count] != 0) {
                Airports *detairport = [NSEntityDescription insertNewObjectForEntityForName:@"AirportsImported" inManagedObjectContext:context];
                Airport *newAirport = [[Airport alloc]init];
                NSDate *now = [NSDate date];
                [detairport setValue:[NSNumber numberWithInt:SDObjectCreated] forKey:@"syncStatus"];
                NSArray *myArr = [result valueForKey:@"IATAIdentifier"];
                NSLog(@"%@",[myArr objectAtIndex:0]);
                detairport.iataidentifier = [myArr objectAtIndex:0];
                newAirport.iataidentifier = [myArr objectAtIndex:0];
                myArr = [result valueForKey:@"ICAOIdentifier"];
                detairport.icaoidentifier = [myArr objectAtIndex:0];
                newAirport.icaoidentifier = [myArr objectAtIndex:0];
                myArr = [result valueForKey:@"Name"];
                detairport.name = [myArr objectAtIndex:0];
                newAirport.name = [myArr objectAtIndex:0];
                myArr = [result valueForKey:@"City"];
                detairport.date = now;
                detairport.city = [myArr objectAtIndex:0];
                newAirport.city = [myArr objectAtIndex:0];
                myArr = [result valueForKey:@"Elevation"];
                NSString *intElevation = [myArr objectAtIndex:0];
                intElevation = [intElevation stringByAppendingString:@".0"];
                double dblElevation = [intElevation doubleValue];
                [detairport setValue:[NSNumber numberWithDouble:dblElevation] forKey:@"elevation"];
                newAirport.elevation = dblElevation;
                myArr = [result valueForKey:@"Latitude"];
                NSString *intLatitude = [myArr objectAtIndex:0];
                double dblLatitude = [intLatitude doubleValue];
                [detairport setValue:[NSNumber numberWithDouble:dblLatitude] forKey:@"Latitude"];
                newAirport.latitude = dblLatitude;
                myArr = [result valueForKey:@"Longitude"];
                NSString *intLongitude = [myArr objectAtIndex:0];
                double dblLongitude = [intLongitude doubleValue];
                [detairport setValue:[NSNumber numberWithDouble:dblLongitude] forKey:@"Longitude"];
                newAirport.longitude = dblLongitude;
                myArr = [result valueForKey:@"TimeZone"];
                detairport.timezone = [myArr objectAtIndex:0];
                newAirport.timezone = [myArr objectAtIndex:0];
                [newAirport.country setValue:@"" forKey:@"country"];
                [detairport.cat32x setValue:@"" forKey:@"cat32x"];
                [detairport.cat332 setValue:@"" forKey:@"cat332"];
                [detairport.cat333 setValue:@"" forKey:@"cat333"];
                [detairport.cat345 setValue:@"" forKey:@"cat345"];
                [detairport.cat346 setValue:@"" forKey:@"cat346"];
                [detairport.cat350 setValue:@"" forKey:@"cat350"];
                [detairport.cat380 setValue:@"" forKey:@"cat380"];
                [detairport.cat777 setValue:@"" forKey:@"cat777"];
                [detairport.cat787 setValue:@"" forKey:@"cat787"];
                [detairport.note32x setValue:@"" forKey:@"note32x"];
                [detairport.note332 setValue:@"" forKey:@"note332"];
                [detairport.note333 setValue:@"" forKey:@"note333"];
                [detairport.note345 setValue:@"" forKey:@"note345"];
                [detairport.note346 setValue:@"" forKey:@"note346"];
                [detairport.note350 setValue:@"" forKey:@"note350"];
                [detairport.note380 setValue:@"" forKey:@"note380"];
                [detairport.note777 setValue:@"" forKey:@"note777"];
                [detairport.note787 setValue:@"" forKey:@"note787"];
                [detairport.rffnotes setValue:@"" forKey:@"rffnotes"];
                [detairport.rff setValue:@"" forKey:@"rff"];
                [detairport.rffnotes setValue:@"" forKey:@"rffnotes"];
                [detairport.peg setValue:@"" forKey:@"peg"];
                [detairport.pegnotes setValue:@"" forKey:@"pegnotes"];
                NSDate *date = now;
                detairport.updatedAt = date;
                detairport.adequate = 0;
                detairport.escaperoute = 0;
                detairport.cpldg = 0;
                //
                NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
                [[User sharedUser].arrayEnrouteAirports addObject:newAirport];
            }
            
        }
    }
}

-(void) getEnrouteAlternates
{
    
    int i;
    for (i = 0; i < [[User sharedUser].arrayLog count]; i++) {
        objLogWpt = [[User sharedUser].arrayLog objectAtIndex:i];
        if ([objLogWpt.strLat isEqualToString:@""]) {
            
        } else {
            NSMutableArray *arrClosestAlternates = [[NSMutableArray alloc]init];
            int i;
            for (i = 0; i < [[User sharedUser].arrayAlternates count]; i++) {
                Airport *enrAirport = [[User sharedUser].arrayAlternates objectAtIndex:i];
                NSMutableString *strLat;
                NSMutableString *strLon;
                if ([objLogWpt.strLat isEqualToString:@""]) {
                    
                }else{
                    if ([objLogWpt.strLat containsString:@"."]) { /////// Departure and Destination Airport
                        strLon = [NSMutableString stringWithString:objLogWpt.strLon];
                        strLat = [NSMutableString stringWithString:objLogWpt.strLat];
                    } else {
                        if ([[objLogWpt.strLat substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
                            strLat = [NSMutableString stringWithString:[@"-" stringByAppendingString:[objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)]]];
                            [strLat insertString: @"." atIndex: 3];
                            
                        }else{
                            strLat = [NSMutableString stringWithString:[objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)]];
                            [strLat insertString: @"." atIndex: 2];
                            
                        }
                        if ([[objLogWpt.strLon substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"W"]) {
                            strLon = [NSMutableString stringWithString:[@"-" stringByAppendingString:[objLogWpt.strLon substringWithRange:NSMakeRange(1, 4)]]];
                            [strLon insertString: @"." atIndex: 4];
                            
                        }else{
                            if ([[objLogWpt.strLon substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                                strLon = [NSMutableString stringWithString:[objLogWpt.strLon substringWithRange:NSMakeRange(2, 4)]];
                                [strLon insertString: @"." atIndex: 2];
                                
                            }else{
                                strLon = [NSMutableString stringWithString:[objLogWpt.strLon substringWithRange:NSMakeRange(1, 4)]];
                                [strLon insertString: @"." atIndex: 3];
                                
                            }
                        }
                    }
                }
                double dblDistanceRad = acos(sin(([strLat doubleValue]*M_PI)/180)*sin((enrAirport.latitude*M_PI)/180)
                                             +cos(([strLat doubleValue]*M_PI)/180)*cos((enrAirport.latitude*M_PI)/180)
                                             *cos((([strLon doubleValue]*M_PI)/180)-(enrAirport.longitude*M_PI)/180));
                double dblDistanceNM = (dblDistanceRad*180*60)/M_PI;
                
                if (dblDistanceNM <= 420) {
                    if ([objLogWpt.strAlternates containsString:enrAirport.icaoidentifier]) {
                    } else {
                        enrAirport.distance = dblDistanceNM;
                        [arrClosestAlternates addObject:enrAirport];
                    }
                }
                
            }
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                         ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray;
            sortedArray = [arrClosestAlternates sortedArrayUsingDescriptors:sortDescriptors];
            int a;
            for (a = 0; a < [sortedArray count]; a++) {
                Airport * altAirport = [sortedArray objectAtIndex:a];
                objLogWpt.strAlternates = [[[objLogWpt.strAlternates stringByAppendingString:@" "] stringByAppendingString:altAirport.icaoidentifier] stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceCharacterSet]];
                if (a == 2) {
                    break;
                }
            }
        }
    }
}
-(void) calcTimeZone
{
    
    NSTimeZone *currentTimeZone =
    [NSTimeZone timeZoneWithName:airportLog.timezone];
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
            airportLog.timezone = [[[NSString alloc] initWithFormat:@"%-.2li:00", (long)intHours]stringByAppendingString:@""];
        }
        else {
            airportLog.timezone = [[[NSString alloc] initWithFormat:@"%-.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@""];
        }
    }
    else {
        if (intMinutes < 15)
        {
            airportLog.timezone = [[[NSString alloc] initWithFormat:@"%+.2li:00", (long)intHours]stringByAppendingString:@""];
        }
        else {
            airportLog.timezone = [[[NSString alloc] initWithFormat:@"%+.2li:%.2li", (long)intHours, (long)intMinutes]stringByAppendingString:@""];
        }
    }
}
-(void) loadAlternates
{
    NSArray *arrAlternates = [[NSArray alloc] init];
    NSArray *arrMasterEntity = [[NSArray alloc] initWithObjects:@"AirportsAfrica",@"AirportsAmericas",@"AirportsAustralia",@"AirportsEurasia",@"AirportsEurope",@"AirportsMiddleEast",@"AirportsAsia",@"AirportsImported",nil];
    NSString *strAlt = strAlternates;
    strAlt = [[[User sharedUser].strDeparture stringByAppendingString:@" "] stringByAppendingString:[[[User sharedUser].strDestination stringByAppendingString:@" "] stringByAppendingString:strAlt]];
    strAlt = [strAlt stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceCharacterSet]];
    strAlt = [strAlt stringByReplacingOccurrencesOfString:@" "
                                               withString:@", "];
    arrAlternates = [strAlt componentsSeparatedByString:@", "];
    [User sharedUser].arrayAlternates = [[NSMutableArray alloc] init];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    for (int i=0; i < [arrAlternates count]; i++)
    {
        NSString *strIcaoIdentifier = [arrAlternates objectAtIndex:i];  //find object with this id in core data
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
        int i;
        for (i = 0; i < [arrMasterEntity count]; i++) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [NSFetchedResultsController deleteCacheWithName:@"Airports"];
            NSEntityDescription *entity = [NSEntityDescription entityForName:[arrMasterEntity objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
            [fetchRequest setPredicate:predicate];
            NSArray *results = [context executeFetchRequest:fetchRequest error:NULL];
            if ([results count] == 1){
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
                detairport.country = managedairport.country;
                [[User sharedUser].arrayAlternates addObject:detairport];
                [[User sharedUser].arrayWXNotams addObject:detairport];
                
            }
        }
    }
    
}
-(void) calcCoordinates
{
    double dblLatitude;
    dblLatitude = [airportLog.latitude intValue];
    if (dblLatitude >= 0) {
        objLogWpt.strLat = [[NSString alloc]initWithFormat:@"N%02.0f%02.1f", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    } else {
        dblLatitude = dblLatitude*-1;
        objLogWpt.strLat = [[NSString alloc]initWithFormat:@"S%02.0f%02.1f", floor(dblLatitude),(dblLatitude-floor(dblLatitude))*60];
    }
    double dblLongitude;
    dblLongitude = [airportLog.longitude intValue];
    if (dblLongitude >= 0) {
        
        objLogWpt.strLon = [[NSString alloc]initWithFormat:@"E%03.0f%02.1f", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60];
    } else {
        dblLongitude = dblLongitude*-1;
        objLogWpt.strLon = [[NSString alloc]initWithFormat:@"W%03.0f%02.1f", floor(dblLongitude),(dblLongitude-floor(dblLongitude))*60];
    }
    
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[User sharedUser].arrayLog count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    OFPLogTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexPath.row];
    if ([objLogWpt.strFL length]==0) {
        objLogWpt.strFL = @"";
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.lblnamewpt.text = objLogWpt.strWptName;
    cell.lblAirways.text = objLogWpt.strWptAirway;
    cell.lblLat.text = objLogWpt.strLat;
    cell.lblLon.text = objLogWpt.strLon;
    cell.lblMORA.text = objLogWpt.strMORA;
    cell.lblEET.text = objLogWpt.strCET;
    cell.lblSR.text = [objLogWpt.strSR substringWithRange:NSMakeRange(0, 2)];
    NSLog(@"%@",[objLogWpt.strSR substringWithRange:NSMakeRange(7, 3)]);
    NSInteger intISA = (([objLogWpt.strFL intValue]*0.2)-15) + [[objLogWpt.strSR substringWithRange:NSMakeRange(7, 3)] intValue];
    if (intISA > 0) {
        cell.lblTempWind.text = [[[[objLogWpt.strSR substringWithRange:NSMakeRange(2, 8)] stringByAppendingString:@"/"]stringByAppendingString:@"ISA+"] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)intISA]];
    }else{
        cell.lblTempWind.text = [[[[objLogWpt.strSR substringWithRange:NSMakeRange(2, 8)] stringByAppendingString:@"/"]stringByAppendingString:@"ISA"]stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)intISA]];
    }
    
    if ([[objLogWpt.strSR substringWithRange:NSMakeRange(0, 2)] intValue] > 2) {
        cell.lblSR.textColor = [UIColor yellowColor];
    }
    if ([[objLogWpt.strSR substringWithRange:NSMakeRange(0, 2)] intValue] > 5) {
        cell.lblSR.textColor = [UIColor redColor];
    }
    if ([[objLogWpt.strSR substringWithRange:NSMakeRange(0, 2)] intValue] <= 2) {
        cell.lblSR.textColor = [UIColor greenColor];
    }
    
    if ([objLogWpt.strWptAirway containsString:@"FIR"] || [objLogWpt.strWptAirway containsString:@"UIR"] || [objLogWpt.strWptAirway containsString:@"UTA"] || [objLogWpt.strWptAirway containsString:@"OCEANIC"] || [objLogWpt.strWptAirway containsString:@"ENOB NORGE USSR"] || [objLogWpt.strWptAirway containsString:@"DOMESTIC"]) {
        cell.imgViewLog.image = [UIImage imageNamed:@"radio_tower-32.png"];
        cell.lblAirways.text = [[objLogWpt.strWptAirway stringByReplacingOccurrencesOfString:objLogWpt.strWptName
                                                                                  withString:@""] stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"FIR/UIR";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]; /*#c99e2d*/
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
        cell.lblFlightlevel.text = @"";
        cell.lblPage.text = @"";
    }else{
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        if ([objLogWpt.strType isEqualToString:@"Escape"]) {
            cell.imgViewLog.image = [UIImage imageNamed:@"earth_element-red-32.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = YES;
            //        [cell setBackgroundColor:[UIColor redColor]];
            cell.lblPage.text = [[objLogWpt.strPage stringByAppendingString:@" / "]stringByAppendingString:objLogWpt.strChapter];
            cell.lblAlternates.text = objLogWpt.strAlternates;
            if ([objLogWpt.strFL length]!=0) {
                cell.lblFlightlevel.text = [@"FL" stringByAppendingString:objLogWpt.strFL];
            }else{
                cell.lblFlightlevel.text = @"";
            }
            cell.lblMORA.textColor = [UIColor redColor];
        }else{
            if ([objLogWpt.strMORA intValue] > 100 ) {
                cell.lblMORA.textColor = [UIColor redColor];
                cell.imgViewLog.image = [UIImage imageNamed:@"earth_element-red-32.png"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.userInteractionEnabled = YES;
                cell.lblPage.text = @"";
                cell.lblAlternates.text = objLogWpt.strAlternates;
                if ([objLogWpt.strFL length]!=0) {
                    cell.lblFlightlevel.text = [@"FL" stringByAppendingString:objLogWpt.strFL];
                }else{
                    cell.lblFlightlevel.text = @"";
                }
            }else{
                cell.lblMORA.textColor = [UIColor colorWithRed:0.365 green:1 blue:0.396 alpha:1]; /*#5dff65*/
                cell.imgViewLog.image = [UIImage imageNamed:@"earth_element-green-32.png"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.userInteractionEnabled = YES;
                cell.lblPage.text = @"";
                cell.lblAlternates.text = objLogWpt.strAlternates;
                if ([objLogWpt.strFL length]!=0) {
                    cell.lblFlightlevel.text = [@"FL" stringByAppendingString:objLogWpt.strFL];
                }else{
                    cell.lblFlightlevel.text = @"";
                }
            }
            if ([objLogWpt.strAlternates length] != 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.userInteractionEnabled = YES;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.userInteractionEnabled = NO;
                if ([objLogWpt.strLat length] == 0) {
                    cell.lblAlternates.text = @"";
                } else {
                    cell.lblAlternates.text = @"ETOPS";
                }
            }
        }}
    if ([objLogWpt.strType isEqualToString:@"ETOPS"] ) {
        
        cell.imgViewLog.image = [UIImage imageNamed:@"water_element-32.png"];
    }
    
    if ([objLogWpt.strWptName isEqualToString:@"Sunrise"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"sunrise-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Sun";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strWptName isEqualToString:@"Sunrise (2)"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"sunrise-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Sun";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strWptName isEqualToString:@"Sunset"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"sunset-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Sun";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strWptName isEqualToString:@"Sunset (2)"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"sunset-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Sun";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strType isEqualToString:@"Prayer"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"mosque-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Prayer";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strType isEqualToString:@"Prayer"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"mosque-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Prayer";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strType isEqualToString:@"Prayer"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"mosque-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Prayer";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    if ([objLogWpt.strType isEqualToString:@"Prayer"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"mosque-32.png"];
        cell.lblAlternates.text = @"";
        cell.lblMORA.text = @"Prayer";
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1];
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    
    if ([objLogWpt.strType isEqualToString:@"Airport"] ) {
        cell.imgViewLog.image = [UIImage imageNamed:@"airplane-32.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
        cell.lblAirways.text = [[objLogWpt.strWptAirway stringByReplacingOccurrencesOfString:objLogWpt.strWptName
                                                                                  withString:@""] stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        cell.lblAlternates.text = objLogWpt.strAlternates;
        cell.lblFlightlevel.text = objLogWpt.strFL;
        
        double dblLatitude;
        dblLatitude = [objLogWpt.strLat intValue];
        if (dblLatitude >= 0) {
            NSString *str = objLogWpt.strLat;
            str = [str stringByReplacingOccurrencesOfString:@"-"
                                                 withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"."
                                                 withString:@""];
            cell.lblLat.text = [@"N" stringByAppendingString:[str substringWithRange:NSMakeRange(0, 4)]];
        } else {
            dblLatitude = dblLatitude*-1;
            NSString *str = objLogWpt.strLat;
            str = [str stringByReplacingOccurrencesOfString:@"-"
                                                 withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"."
                                                 withString:@""];
            cell.lblLat.text = [@"S" stringByAppendingString:[str substringWithRange:NSMakeRange(0, 4)]];
        }
        double dblLongitude;
        dblLongitude = [objLogWpt.strLon intValue];
        if (dblLongitude >= 0) {
            NSString *str = objLogWpt.strLon;
            str = [str stringByReplacingOccurrencesOfString:@"-"
                                                 withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"."
                                                 withString:@""];
            cell.lblLon.text = [@"E" stringByAppendingString:[str substringWithRange:NSMakeRange(0, 5)]];
//            cell.lblLon.text = [@"E" stringByAppendingString:objLogWpt.strLon];
        } else {
            dblLongitude = dblLongitude*-1;
            NSString *str = objLogWpt.strLon;
            str = [str stringByReplacingOccurrencesOfString:@"-"
                                                 withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"."
                                                 withString:@""];
            cell.lblLon.text = [@"W" stringByAppendingString:[str substringWithRange:NSMakeRange(0, 5)]];
//            cell.lblLon.text = [@"W" stringByAppendingString:objLogWpt.strLon];
        }
        cell.lblMORA.text = [objLogWpt.strMORA stringByAppendingString:@"ft"];
        cell.lblMORA.textColor = [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]; /*#c99e2d*/
        cell.lblMORA.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0];
    }
    
    if ([cell.lblLat.text isEqualToString:@""]) {
        cell.userInteractionEnabled = NO;
        if ([cell.lblPage.text isEqualToString:@""]) {
            
        }else{
            cell.userInteractionEnabled = YES;
        }
    }else{
            cell.userInteractionEnabled = YES;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Escape *escapewpt = [[User sharedUser].arrayLog objectAtIndex:indexPath.row];
    objLogWpt = [[objLog alloc] init];
    objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexPath.row];
    NSString *selectedWaypointName = objLogWpt.strWptName;
    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate selectedWaypoint:selectedWaypointName];
        [User sharedUser].strSelectedWaypoint = selectedWaypointName;
    }
    if ([objLogWpt.strType isEqualToString:@"Escape"]) {
        NSString *strPathDir = [[[@"/EscapeRoutes/" stringByAppendingString:[User sharedUser].strAircraftLog] stringByAppendingString:@"/"]stringByAppendingString:objLogWpt.strChapter];
        strPathDir = [[strPathDir stringByAppendingString:@"/"] stringByAppendingString:[User sharedUser].strDirectionLog];
        NSString *strPath = [[NSBundle mainBundle] pathForResource:[[[strPathDir stringByAppendingString:@"/"]stringByAppendingString:objLogWpt.strChapter] stringByAppendingString:objLogWpt.strPage] ofType:@"pdf"];
        [User sharedUser].bolPreviewWPT = YES;
        [User sharedUser].bolWPT = YES;
        [User sharedUser].strWptTitle = objLogWpt.strWptName;
        [User sharedUser].strPathDocuments = strPath;
        if ([objLogWpt.strAlternates length] != 0) {
            [[User sharedUser].arrayAlternates removeAllObjects];
            NSArray *arrAlternates = [[NSArray alloc] init];
            NSString* string = objLogWpt.strAlternates;
            NSString *strEscapeAlternates = [string stringByReplacingOccurrencesOfString:@", "
                                                                              withString:@" "];
            arrAlternates = [strEscapeAlternates componentsSeparatedByString:@" "];
            [User sharedUser].arrayAlternates = [[NSMutableArray alloc] init];
            for (int i=0; i < [arrAlternates count]; i++)
            {
                NSString *strIcaoIdentifier = [arrAlternates objectAtIndex:i];  //find object with this id in core data
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strIcaoIdentifier];
                NSArray *result = [[User sharedUser].arrayEnrouteAirports filteredArrayUsingPredicate: predicate];
                if ([result count] != 0) {
                    [[User sharedUser].arrayAlternates addObject:result.firstObject];
                }
            }
        }
        
        
        readerViewController = [[ReaderViewController alloc] initWithNibName:nil bundle:nil]; // Demo controller
        [readerViewController setEscape:escapewpt];
        [[self navigationController] pushViewController:readerViewController animated:NO];
    }else {
        if ([objLogWpt.strType isEqualToString:@"Airport"]) {
            if ([objLogWpt.strWptName isEqualToString:[User sharedUser].strDestination]) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strFunction ==  %@", @"Destination Alternate"];
                NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
                [User sharedUser].arrayAlternates = [result mutableCopy];
            }else{
            [User sharedUser].arrayAlternates = [[User sharedUser].arrayWXNotams mutableCopy];
            }
            [self performSegueWithIdentifier: @"segShowAlternates" sender: self];
        }
        if ([objLogWpt.strType isEqualToString:@"Waypoint"]) {
            if ([objLogWpt.strAlternates length] != 0) {
                [[User sharedUser].arrayAlternates removeAllObjects];
                NSArray *arrAlternates = [[NSArray alloc] init];
                NSString* string = objLogWpt.strAlternates;
                NSString *strEscapeAlternates = [string stringByReplacingOccurrencesOfString:@", "
                                                                                  withString:@" "];
                
                arrAlternates = [strEscapeAlternates componentsSeparatedByString:@" "];
                [User sharedUser].arrayAlternates = [[NSMutableArray alloc] init];
                for (int i=0; i < [arrAlternates count]; i++)
                {
                    NSString *strIcaoIdentifier = [arrAlternates objectAtIndex:i];  //find object with this id in core data
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier ==  %@", strIcaoIdentifier];
                    NSArray *result = [[User sharedUser].arrayWXNotams filteredArrayUsingPredicate: predicate];
                    if ([result count] != 0) {
                        [[User sharedUser].arrayAlternates addObject:result.firstObject];
                    }
                }
                           }
            [self performSegueWithIdentifier: @"segShowAlternates" sender: self];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
+ (void)calculateSunriseSunset;
{
    {
        BOOL bolLongDay;
        
        double dblTrueCourseRad;
        double dblDistanceNM;
        double dblDistanceRad;
        double dblTrueCourseValRad;
        double dblGroundSpeed;
        double dblIncrement;
        //        double dblFltTime;
        double dblLoopTime;
        double dblGCLatitude;
        double dblGCLongitude;
        double dblDistAlongGCRad;
        double dblDLongitude;
        objLog *objLogWpt;
        
        //        NSUInteger intFltTime;
        int intLoopCounter;
        
        [User sharedUser].bolSunRise = NO;
        [User sharedUser].bolSunSet = NO;
        [User sharedUser].bolSunRise2 = NO;
        [User sharedUser].bolSunSet2 = NO;
        [User sharedUser].bolSunRiseInFlight = NO;
        [User sharedUser].bolSunSetInFlight = NO;
        [User sharedUser].bolIsha = NO;
        [User sharedUser].bolFajr = NO;
        [User sharedUser].bolIsha2 = NO;
        [User sharedUser].bolFajr2 = NO;
        [User sharedUser].bolCalcPossible = NO;
        [User sharedUser].dblLongitudeSR2 = 0.0;
        [User sharedUser].dblLongitudeSS2 = 0.0;
        [User sharedUser].arrayResults = [[NSMutableArray alloc] init];
        [[User sharedUser].arrayResults removeAllObjects];
        
        NSMutableArray *arrayCoordinates = [[NSMutableArray alloc] init];
        
        
        // GROUNDSPEED
        NSLog(@"%ld", (long)[User sharedUser].intTimeOvhdTO);
        NSLog(@"%ld", (long)[User sharedUser].intTimeOvhdFROM);
        
        
        
        //LOOPTROUGHTRACK
        
        double dblDecDepTime = [User sharedUser].intTimeOvhdFROM;
        NSString *LandingTimeHours = [[User sharedUser].strLandingTime substringWithRange:NSMakeRange(0,2)];
        NSString *LandingTimeMinutes = [[User sharedUser].strLandingTime substringWithRange:NSMakeRange(2,2)];
        NSInteger hour = [LandingTimeHours integerValue];
        NSInteger min = [LandingTimeMinutes integerValue];
        [User sharedUser].intTimeOvhdTO = ((hour*60)+min)*60;
        double dblDecArrTime = [User sharedUser].intTimeOvhdTO;
        
        //            double dblSectorTime = (double)[objLogWpt.strCET integerValue]*60;
        double dblFlighttime;
        if (dblDecDepTime < dblDecArrTime) {
            dblLoopTime=dblDecDepTime;
            bolLongDay = NO;
        } else {
            dblDecArrTime = dblDecArrTime + 86400;
            dblLoopTime=dblDecDepTime;
            bolLongDay = YES;
        }
        dblFlighttime = dblDecArrTime - dblDecDepTime;
        // start at dep time
        intLoopCounter=0;		// initialise Counter
        int IntLooptime = dblLoopTime;
        dblIncrement = (1.0/60.0);
        // get sunrise sunset for dep
        NSDate* date = [User sharedUser].dateFlight;
        NSTimeZone* tz =  [NSTimeZone timeZoneForSecondsFromGMT:(0 * 3600)];
        objLogWpt = [[User sharedUser].arrayLog objectAtIndex:0];
        double DepLatitude = [objLogWpt.strLat doubleValue];
        double DepLongitude = [objLogWpt.strLon doubleValue];
        DepLongitude = -DepLongitude;
        Fiddler* fiddlerDEP = [[Fiddler alloc] initWithDate:date timeZone:tz latitude:DepLatitude longitude:DepLongitude];
        
        // setup sunrise/sunset
        [User sharedUser].TimeSunriseDep = fiddlerDEP.sunrise;
        [User sharedUser].TimeSunsetDep = fiddlerDEP.sunset;
        
        unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        if (bolLongDay == YES) {
            NSDateComponents *compsaddADay = [[NSDateComponents alloc] init];
            [compsaddADay setDay:1];
            date = [gregorian dateByAddingComponents:compsaddADay toDate:date options:0];
        }
        
        // get sunrise sunset for dest
        objLogWpt = [[User sharedUser].arrayLog objectAtIndex:[[User sharedUser].arrayLog count]-1];
        double DestLatitude = [objLogWpt.strLat doubleValue];
        double DestLongitude = [objLogWpt.strLon doubleValue];
        DestLongitude = -DestLongitude;
        
        Fiddler* fiddlerDEST = [[Fiddler alloc] initWithDate:date timeZone:tz latitude:DestLatitude longitude:DestLongitude];
        
        [User sharedUser].TimeSunriseDest = fiddlerDEST.sunrise;
        [User sharedUser].TimeSunsetDest = fiddlerDEST.sunset;
        
        NSDateComponents *compsSunsetDep = [gregorian components:unitFlags fromDate:[User sharedUser].TimeSunsetDep];
        NSInteger hourSunsetDep = [compsSunsetDep hour];
        NSInteger minSunsetDep = [compsSunsetDep minute];
        [User sharedUser].intSunsetDep = ((hourSunsetDep*60)+minSunsetDep)*60;
        
        NSDateComponents *compsSunsetDest = [gregorian components:unitFlags fromDate:[User sharedUser].TimeSunsetDest];
        NSInteger hourSunsetDest = [compsSunsetDest hour];
        NSInteger minSunsetDest = [compsSunsetDest minute];
        [User sharedUser].intSunsetDest = ((hourSunsetDest*60)+minSunsetDest)*60;
        NSDateComponents *compsSunriseDep = [gregorian components:unitFlags fromDate:[User sharedUser].TimeSunriseDep];
        NSInteger hourSunriseDep = [compsSunriseDep hour];
        NSInteger minSunriseDep = [compsSunriseDep minute];
        [User sharedUser].intSunriseDep = ((hourSunriseDep*60)+minSunriseDep)*60;
        NSDateComponents *compsSunriseDest = [gregorian components:unitFlags fromDate:[User sharedUser].TimeSunriseDest];
        NSInteger hourSunriseDest = [compsSunriseDest hour];
        NSInteger minSunriseDest = [compsSunriseDest minute];
        [User sharedUser].intSunriseDest = (((hourSunriseDest*60)+minSunriseDest)*60);
        
        NSInteger intSunriseDepLCL = (((hourSunriseDep*60)+minSunriseDep)*60) + [User sharedUser].IntTimeDifference;
        NSInteger intSunsetDepLCL = (((hourSunsetDep*60)+minSunsetDep)*60) + [User sharedUser].IntTimeDifference;
        NSInteger intTimeDepLCL = [User sharedUser].intTimeOvhdFROMPreFlight + [User sharedUser].IntTimeDifference;
        
        if (intSunriseDepLCL > 86400) {
            intSunriseDepLCL = intSunriseDepLCL - 86400;
        }
        if (intSunriseDepLCL < 0) {
            intSunriseDepLCL = 86400 - intSunriseDepLCL;
        }
        
        if (intSunsetDepLCL > 86400) {
            intSunsetDepLCL = intSunsetDepLCL - 86400;
        }
        if (intSunsetDepLCL < 0) {
            intSunsetDepLCL = 86400 - intSunsetDepLCL;
        }
        
        if (intTimeDepLCL > 86400) {
            intTimeDepLCL = intTimeDepLCL - 86400;
        }
        if (intTimeDepLCL < 0) {
            intTimeDepLCL = 86400 - intTimeDepLCL;
        }
        
        if (intSunriseDepLCL <= intTimeDepLCL && intTimeDepLCL <= intSunsetDepLCL) {
            [User sharedUser].bolDay = YES;
        } else {
            [User sharedUser].bolDay = NO;
        }
        
        bool bolsunrise1 = NO;
        bool bolsunset1 = NO;
        bool bolfajr1 = NO;
        bool bolfajr2 = NO;
        bool bolisha1 = NO;
        int intlooptimesunrise = 0;
        int intlooptimesunset = 0;
        int intlooptimefajr = 0;
        int intlooptimeisha = 0;
        
        ///// LOOP FROM HERE !!
        objLog *objLogWptNext;
        NSMutableArray * myMutableLog;
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"strLat !=  %@", @""];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"strType !=  %@", @"ETOPS"];
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
        NSArray *resultLog = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
        int i;
        i=0;
        
        for (int i=0; i < [resultLog count]; i++)
        {
            double dblLat1;
            double dblLon1;
            double dblLat2;
            double dblLon2;
            double dblCETTime;
            objLogWptNext = [objLog alloc];
            myMutableLog = [resultLog mutableCopy];
            objLogWpt = [myMutableLog objectAtIndex:i];
            
            //// format coordinates
            if ([objLogWpt.strLat isEqualToString:@""]) {
            }else{
                if ([objLogWpt.strLat containsString:@"."]) { /////// Departure and Destination Airport
                    dblLat1 = [objLogWpt.strLat doubleValue];
                    dblLon1 = [objLogWpt.strLon doubleValue];
                } else {
                    if ([[objLogWpt.strLat substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
                        NSString *stringLat = objLogWpt.strLat;
                        stringLat = [@"-" stringByAppendingString:[stringLat substringWithRange:NSMakeRange(1, 4)]];
                        NSMutableString *string1 = [NSMutableString stringWithString:stringLat];
                        [string1 insertString: @"." atIndex: 3];
                        dblLat1 = [string1 doubleValue];
                    }else{
                        NSString *stringLat = objLogWpt.strLat;
                        stringLat = [stringLat substringWithRange:NSMakeRange(1, 4)];
                        NSMutableString *string1 = [NSMutableString stringWithString:stringLat];
                        [string1 insertString: @"." atIndex: 2];
                        dblLat1 = [string1 doubleValue];
                    }
                    if ([[objLogWpt.strLon substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"W"]) {
                        NSString *stringLon = objLogWpt.strLon;
                        stringLon = [@"-" stringByAppendingString:[stringLon substringWithRange:NSMakeRange(1, 4)]];
                        NSMutableString *string1 = [NSMutableString stringWithString:stringLon];
                        [string1 insertString: @"." atIndex: 4];
                        dblLon1 = [string1 doubleValue];
                    }else{
                        if ([[objLogWpt.strLon substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                            NSString *stringLon = objLogWpt.strLon;
                            stringLon = [stringLon substringWithRange:NSMakeRange(2, 4)];
                            NSMutableString *string1 = [NSMutableString stringWithString:stringLon];
                            [string1 insertString: @"." atIndex: 2];
                            dblLon1 = [string1 doubleValue];
                        }else{
                            NSString *stringLon = objLogWpt.strLon;
                            stringLon = [stringLon substringWithRange:NSMakeRange(1, 5)];
                            NSMutableString *string1 = [NSMutableString stringWithString:stringLon];
                            [string1 insertString: @"." atIndex: 3];
                            dblLon1 = [string1 doubleValue];
                        }
                    }
                }
                
                [User sharedUser].dblLatitudeFROM  = dblLat1;
                [User sharedUser].dblLongitudeFROM = dblLon1;
                if (i <= [myMutableLog count]-2) {
                    objLogWptNext = [myMutableLog objectAtIndex:i+1];
                    
                    //// format coordinates
                    if ([objLogWptNext.strLat isEqualToString:@""]) {
                        
                    }else{
                        if ([objLogWptNext.strLat containsString:@"."]) { /////// Departure and Destination Airport
                            dblLat2 = [objLogWptNext.strLat doubleValue];
                            dblLon2 = [objLogWptNext.strLon doubleValue];
                        } else {
                            if ([[objLogWptNext.strLat substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
                                NSString *stringLat = objLogWptNext.strLat;
                                stringLat = [@"-" stringByAppendingString:[stringLat substringWithRange:NSMakeRange(1, 4)]];
                                NSMutableString *string1 = [NSMutableString stringWithString:stringLat];
                                [string1 insertString: @"." atIndex: 3];
                                dblLat2 = [string1 doubleValue];
                            }else{
                                NSString *stringLat = objLogWptNext.strLat;
                                stringLat = [stringLat substringWithRange:NSMakeRange(1, 4)];
                                NSMutableString *string1 = [NSMutableString stringWithString:stringLat];
                                [string1 insertString: @"." atIndex: 2];
                                dblLat2 = [string1 doubleValue];
                            }
                            if ([[objLogWptNext.strLon substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"W"]) {
                                NSString *stringLon = objLogWptNext.strLon;
                                stringLon = [@"-" stringByAppendingString:[stringLon substringWithRange:NSMakeRange(1, 4)]];
                                NSMutableString *string1 = [NSMutableString stringWithString:stringLon];
                                [string1 insertString: @"." atIndex: 4];
                                dblLon2 = [string1 doubleValue];
                            }else{
                                if ([[objLogWptNext.strLon substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                                    NSString *stringLon = objLogWptNext.strLon;
                                    stringLon = [stringLon substringWithRange:NSMakeRange(2, 4)];
                                    NSMutableString *string1 = [NSMutableString stringWithString:stringLon];
                                    [string1 insertString: @"." atIndex: 2];
                                    dblLon2 = [string1 doubleValue];
                                }else{
                                    NSString *stringLon = objLogWptNext.strLon;
                                    stringLon = [stringLon substringWithRange:NSMakeRange(1, 5)];
                                    NSMutableString *string1 = [NSMutableString stringWithString:stringLon];
                                    [string1 insertString: @"." atIndex: 3];
                                    dblLon2 = [string1 doubleValue];
                                }
                            }
                        }
                    }
                    
                    [User sharedUser].dblLatitudeTO  = dblLat2;
                    [User sharedUser].dblLongitudeTO = dblLon2;
                }
                [User sharedUser].intFlightLevel = [objLogWpt.strFL doubleValue];
                //TRUECOURSERAD
                dblDistanceRad = acos(sin(([User sharedUser].dblLatitudeFROM*M_PI)/180)*sin(([User sharedUser].dblLatitudeTO*M_PI)/180)
                                      +cos(([User sharedUser].dblLatitudeFROM*M_PI)/180)*cos(([User sharedUser].dblLatitudeTO*M_PI)/180)
                                      *cos((([User sharedUser].dblLongitudeTO*M_PI)/180)-([User sharedUser].dblLongitudeFROM*M_PI)/180));
                
                dblDistanceNM = (dblDistanceRad*180*60)/M_PI;
                [User sharedUser].dblDistanceNM = dblDistanceNM;
                dblTrueCourseValRad = (sin(([User sharedUser].dblLatitudeTO*M_PI)/180)-sin(([User sharedUser].dblLatitudeFROM*M_PI)/180)*cos(dblDistanceRad))/(sin(dblDistanceRad)*cos(([User sharedUser].dblLatitudeFROM*M_PI)/180));
                
                if (dblTrueCourseValRad > 1) {
                    dblTrueCourseValRad = 1;
                }
                if (dblTrueCourseValRad < -1) {
                    dblTrueCourseValRad = -1;
                }
                
                if (sin(((([User sharedUser].dblLongitudeTO*M_PI)/180)*-1)-((([User sharedUser].dblLongitudeFROM*M_PI)/180)*-1))<0) {
                    dblTrueCourseRad = acos(dblTrueCourseValRad);
                }
                else  {
                    dblTrueCourseRad = 2*M_PI - acos(dblTrueCourseValRad);
                }
                
                
                if (([User sharedUser].dblLatitudeFROM*M_PI)/180 == M_PI/2)
                {
                    dblTrueCourseRad = M_PI;
                }
                else {
                    if (([User sharedUser].dblLatitudeFROM*M_PI)/180 == -M_PI/2) {
                        dblTrueCourseRad = 0;
                    }
                }
                
                // GROUNDSPEED
                NSLog(@"%ld", (long)[User sharedUser].intTimeOvhdTO);
                NSLog(@"%ld", (long)[User sharedUser].intTimeOvhdFROM);
                
                //                    if ([User sharedUser].intTimeOvhdTO < [User sharedUser].intTimeOvhdFROM) {
                //
                //                        intFltTime = ([User sharedUser].intTimeOvhdTO + 86400) - [User sharedUser].intTimeOvhdFROM;
                //                    }
                //                    else {
                //                        intFltTime = [User sharedUser].intTimeOvhdTO - [User sharedUser].intTimeOvhdFROM;
                //                    }
                //                    double dblFltTime = intFltTime;
                
                double dblTimeWpt1 = [[objLogWpt.strCET substringWithRange:NSMakeRange(0, 2)] doubleValue]*60 + [[objLogWpt.strCET substringWithRange:NSMakeRange(2, 2)] doubleValue];
                double dblTimeWpt2 = [[objLogWptNext.strCET substringWithRange:NSMakeRange(0, 2)] doubleValue]*60 + [[objLogWptNext.strCET substringWithRange:NSMakeRange(2, 2)] doubleValue];
                double dblSectorTime = dblTimeWpt2 - dblTimeWpt1;
                dblGroundSpeed = (dblDistanceNM/dblSectorTime)*60;
                //                    dblGroundSpeed = ([objLogWpt.strDTW doubleValue]/[objLogWpt.strEET doubleValue])*60;
                //                    dblTrueCourseRad = ([objLogWpt.strITT doubleValue]*M_PI)/180;
                //                    double dblSectorTime = (double)[objLogWpt.strEET integerValue]*60;
                dblSectorTime = dblSectorTime *60;
                if (objLogWpt.intID == 1) {
                    //                         IntLooptime = IntLooptime-60;
                }
                dblSectorTime = dblSectorTime + dblLoopTime;
                intLoopCounter = 0;
                do {
                    if (dblDecDepTime <= IntLooptime) {
                        dblCETTime = IntLooptime - dblDecDepTime;
                    }else {
                        dblCETTime = (IntLooptime+86400)-dblDecDepTime;
                    }
                    dblDistAlongGCRad=(dblGroundSpeed*dblIncrement*intLoopCounter) * M_PI / (180*60);
                    //calculate distance along track
                    dblGCLatitude=asin((sin(([User sharedUser].dblLatitudeFROM*M_PI)/180)*cos(dblDistAlongGCRad)+cos(([User sharedUser].dblLatitudeFROM*M_PI)/180)*sin(dblDistAlongGCRad)*cos(dblTrueCourseRad)));
                    // calc new latitude of waypoint
                    NSLog(@"%f", (([User sharedUser].dblLongitudeFROM*M_PI)/180));
                    NSLog(@"%f", (([User sharedUser].dblLatitudeFROM*M_PI)/180));
                    
                    dblDLongitude = atan2(sin(dblTrueCourseRad) * sin(dblDistAlongGCRad) * cos(([User sharedUser].dblLatitudeFROM*M_PI)/180), cos(dblDistAlongGCRad) - sin(([User sharedUser].dblLatitudeFROM*M_PI)/180)* sin(dblGCLatitude));
                    
                    double y = ((([User sharedUser].dblLongitudeFROM*M_PI)/180)*-1)-dblDLongitude+M_PI;
                    double x = 2*M_PI;
                    
                    if (y >= 0) {
                        dblGCLongitude = y - x * floor(y/x)-M_PI;
                    }else{
                        dblGCLongitude = y + x * (floor(-y/x)+1)-M_PI;
                    }
                    
                    // set up formatter
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:DateFormat];
                    
                    // set up current time zone
                    NSTimeZone* tz =  [NSTimeZone timeZoneForSecondsFromGMT:(0 * 3600)];
                    
                    // get current date
                    //            NSDate* date = [User sharedUser].dateFlight;
                    
                    // set up Fiddler object
                    NSLog(@"%f", (dblGCLatitude*(180/M_PI)));
                    NSLog(@"%f", (dblGCLongitude*(180/M_PI)));
                    NSLog(@"%f", (dblGCLatitude));
                    NSLog(@"%f", (dblGCLongitude));
                    
                    if (intLoopCounter > 0) {
                        NSString *coordinatesWpt = [[NSString alloc] initWithFormat:@"%.2f,%.2f",dblGCLatitude*(180/M_PI),((dblGCLongitude*(180/M_PI))*-1)];
                        [arrayCoordinates addObject:coordinatesWpt];
                        NSLog(@"enroute");
                        NSLog(@"%@", (coordinatesWpt));
                        
                    }else{
                        
                        
                        NSString *coordinatesInit = [[NSString alloc] initWithFormat:@"%.2f,%.2f",[User sharedUser].dblLatitudeFROM,[User sharedUser].dblLongitudeFROM];
                        [arrayCoordinates addObject:coordinatesInit];
                        NSLog(@"Init");
                        NSLog(@"%@", (coordinatesInit));
                    }
                    
                    //[[[NSString alloc] initWithFormat:@"%.2i:%.2i", hourSunrise, minSunrise] stringByAppendingString:@" hrs"];
                    double dblLoopTimeLog = dblLoopTime;
                    if (dblLoopTimeLog > 86400) {
                        dblLoopTimeLog = dblLoopTimeLog - 86400;
                        
                    }
                    if (IntLooptime > 86400) {
                        IntLooptime = IntLooptime - 86400;
                    }
                    NSLog(@"%@",[[[NSString alloc] initWithFormat:@"%.2f:%.2f", floor(dblLoopTimeLog/3600), (((dblLoopTimeLog/3600)-floor(dblLoopTimeLog/3600))*60)] stringByAppendingString:@" hrs"]);
                    
                    NSInteger intAltitudeCorrection = ((((1.17*sqrt([User sharedUser].intFlightLevel*100))/cos(dblGCLatitude))/60)*4)*60;
                    
                    // calculate sunrise/sunset
                    dblGCLongitude = -dblGCLongitude;
                    EDSunriseSet* EDSSSR = [EDSunriseSet sunrisesetWithTimezone:tz latitude:dblGCLatitude*(180/M_PI) longitude:dblGCLongitude*(180/M_PI)];
                    //	calculate Fajr Time
                    NSDateComponents *compsFajr = [gregorian components:unitFlags fromDate:EDSSSR.astronomicalTwilightStart];
                    // Now extract the hour:mins from today's date
                    NSInteger hourFajr = [compsFajr hour];
                    NSInteger minFajr = [compsFajr minute];
                    NSInteger intFajr = ((hourFajr*60)+minFajr)*60;
                    if (intFajr < intAltitudeCorrection) {
                        intFajr = (intFajr + 86400) - intAltitudeCorrection;
                    }else{
                        intFajr = intFajr - intAltitudeCorrection;
                    }
                    if (intFajr > 86400) {
                        intFajr = intFajr - 86400;
                    }
                    NSNumber *totalDaysFajrCOR = [NSNumber numberWithDouble:
                                                  (intFajr / 86400)];
                    NSNumber *totalHoursFajrCOR = [NSNumber numberWithDouble:
                                                   ((intFajr / 3600) -
                                                    ([totalDaysFajrCOR intValue] * 24))];
                    NSNumber *totalMinutesFajrCOR = [NSNumber numberWithDouble:
                                                     ((intFajr / 60) -
                                                      ([totalDaysFajrCOR intValue] * 24 * 60) -
                                                      ([totalHoursFajrCOR intValue] * 60))];
                    
                    NSInteger intHoursFajr;
                    intHoursFajr = [totalHoursFajrCOR intValue];
                    NSInteger intMinutesFajr;
                    intMinutesFajr = [totalMinutesFajrCOR intValue];
                    
                    if ((IntLooptime -60) <= intFajr && (IntLooptime +60) >= intFajr ) {
                        if (bolfajr1 == NO) {
                            bolfajr1 = YES;
                            intlooptimefajr = IntLooptime;
                            [User sharedUser].bolFajr = YES;
                            [User sharedUser].strFajr = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursFajr, (long)intMinutesFajr] stringByAppendingString:@" UTC"];
                            
                            NSInteger intFajrLCL = intFajr + [User sharedUser].IntTimeZone;
                            if (intFajrLCL < 0) {
                                intFajrLCL = 86400 + intFajrLCL;
                            }
                            NSNumber *totalDays = [NSNumber numberWithDouble:
                                                   (intFajrLCL / 86400)];
                            NSNumber *totalHours = [NSNumber numberWithDouble:
                                                    ((intFajrLCL / 3600) -
                                                     ([totalDays intValue] * 24))];
                            NSNumber *totalMinutes = [NSNumber numberWithDouble:
                                                      ((intFajrLCL / 60) -
                                                       ([totalDays intValue] * 24 * 60) -
                                                       ([totalHours intValue] * 60))];
                            
                            NSInteger intHoursFajrLCL;
                            intHoursFajrLCL = [totalHours intValue];
                            NSInteger intMinutesFajrLCL;
                            intMinutesFajrLCL = [totalMinutes intValue];
                            
                            [User sharedUser].strFajrLCL = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursFajrLCL, (long)intMinutesFajrLCL] stringByAppendingString:@" LCL"];
                            SunFlightresults *Result = [[SunFlightresults alloc] init];
                            objLog *objLogSSSR = [[objLog alloc ]init];
                            BOOL found = NO;
                            for (Result in [User sharedUser].arrayResults){
                                if([Result.strWptName isEqualToString:@"Fajr"]){
                                    found = YES;
                                    [[User sharedUser].arrayResults removeObject: Result];
                                    break;
                                }
                            }
                            if (found){
                                for (objLogSSSR in [User sharedUser].arrayResults){
                                    if([objLogSSSR.strWptName isEqualToString:@"Fajr"]){
                                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogSSSR.strWptName];
                                        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                        [[User sharedUser].arrayLog removeObjectAtIndex:indexOfTheObject];
                                    }
                                }
//                                [[User sharedUser].arrayResults removeObject: Result];
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                Result.strWptName = @"Fajr";
                                Result.strType = @"Prayer";
                                Result.strTime = [User sharedUser].strFajr;
                                Result.strTimeLCL = [User sharedUser].strFajrLCL;
                                Result.strFlightLevel = objLogWpt.strFL;
                                Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                [[User sharedUser].arrayResults addObject: Result];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                objLogSSSR.strType = @"Prayer";
                                objLogSSSR.strWptName = @"Fajr";
                                objLogSSSR.strWptAirway = [User sharedUser].strFajr;
                                objLogSSSR.strFL = objLogWpt.strFL;
                                objLogSSSR.strAlternates = @"";
                                objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                
                            }else{
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                Result.strWptName = @"Fajr";
                                Result.strType = @"Prayer";
                                Result.strTime = [User sharedUser].strFajr;
                                Result.strTimeLCL = [User sharedUser].strFajrLCL;
                                Result.strFlightLevel = objLogWpt.strFL;
                                Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",(dblCETTime/3600 - floor(dblCETTime/3600))*60]];
                                [[User sharedUser].arrayResults addObject: Result];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                objLogSSSR.strType = @"Prayer";
                                objLogSSSR.strWptName = @"Fajr";
                                objLogSSSR.strWptAirway = [User sharedUser].strFajr;
                                objLogSSSR.strFL = objLogWpt.strFL;
                                objLogSSSR.strAlternates = @"";
                                objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                            }
                            
                        }else{
                            if ((IntLooptime - intlooptimefajr) > 3600 ) {
                                bolfajr2 = YES;
                                [User sharedUser].bolFajr2 = YES;
                                [User sharedUser].strFajr2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursFajr, (long)intMinutesFajr] stringByAppendingString:@" UTC"];
                                
                                NSInteger intFajrLCL = intFajr + [User sharedUser].IntTimeZone;
                                if (intFajrLCL < 0) {
                                    intFajrLCL = 86400 + intFajrLCL;
                                }
                                NSNumber *totalDays = [NSNumber numberWithDouble:
                                                       (intFajrLCL / 86400)];
                                NSNumber *totalHours = [NSNumber numberWithDouble:
                                                        ((intFajrLCL / 3600) -
                                                         ([totalDays intValue] * 24))];
                                NSNumber *totalMinutes = [NSNumber numberWithDouble:
                                                          ((intFajrLCL / 60) -
                                                           ([totalDays intValue] * 24 * 60) -
                                                           ([totalHours intValue] * 60))];
                                
                                NSInteger intHoursFajrLCL;
                                intHoursFajrLCL = [totalHours intValue];
                                NSInteger intMinutesFajrLCL;
                                intMinutesFajrLCL = [totalMinutes intValue];
                                
                                [User sharedUser].strFajrLCL2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursFajrLCL, (long)intMinutesFajrLCL] stringByAppendingString:@" LCL"];
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                BOOL found = NO;
                                for (Result in [User sharedUser].arrayResults){
                                    if([Result.strWptName isEqualToString:@"Fajr (2)"]){
                                        found = YES;
                                        [[User sharedUser].arrayResults removeObject: Result];
                                        break;
                                    }
                                }
                                if (found){
                                    for (objLogSSSR in [User sharedUser].arrayResults){
                                        if([objLogSSSR.strWptName isEqualToString:@"Fajr (2)"]){
                                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogSSSR.strWptName];
                                            NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                            NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                            [[User sharedUser].arrayLog removeObjectAtIndex:indexOfTheObject];
                                        }
                                    }
//                                    [[User sharedUser].arrayResults removeObject: Result];
                                    SunFlightresults *Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Fajr (2)";
                                    Result.strType = @"Prayer";
                                    Result.strTime = [User sharedUser].strFajr2;
                                    Result.strTimeLCL = [User sharedUser].strFajrLCL2;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    [[User sharedUser].arrayResults addObject: Result];
                                    objLog *objLogSSSR = [[objLog alloc ]init];
                                    objLogSSSR.strType = @"Prayer";
                                    objLogSSSR.strWptName = @"Fajr (2)";
                                    objLogSSSR.strWptAirway = [User sharedUser].strFajr2;
                                    objLogSSSR.strFL = objLogWpt.strFL;
                                    objLogSSSR.strAlternates = @"";
                                    objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                    NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                    [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                    
                                }else{
                                    SunFlightresults *Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Fajr (2)";
                                    Result.strType = @"Prayer";
                                    Result.strTime = [User sharedUser].strFajr2;
                                    Result.strTimeLCL = [User sharedUser].strFajrLCL2;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    [[User sharedUser].arrayResults addObject: Result];
                                    objLog *objLogSSSR = [[objLog alloc ]init];
                                    objLogSSSR.strType = @"Prayer";
                                    objLogSSSR.strWptName = @"Fajr (2)";
                                    objLogSSSR.strWptAirway = [User sharedUser].strFajr2;
                                    objLogSSSR.strFL = objLogWpt.strFL;
                                    objLogSSSR.strAlternates = @"";
                                    objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                    NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                    [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                }
                                
                            }
                        }
                    }
                    
                    
                    //	calculate Isha Time
                    NSDateComponents *compsIsha = [gregorian components:unitFlags fromDate:EDSSSR.nauticalTwilightEnd];
                    // Now extract the hour:mins from today's date
                    NSInteger hourIsha = [compsIsha hour];
                    NSInteger minIsha = [compsIsha minute];
                    NSInteger intIsha = ((hourIsha*60)+minIsha)*60;
                    if (intIsha < intAltitudeCorrection) {
                        intIsha = (intIsha + 86400) + intAltitudeCorrection;
                    }else{
                        intIsha = intIsha + intAltitudeCorrection;
                    }
                    if (intIsha > 86400) {
                        intIsha = intIsha - 86400;
                    }
                    NSNumber *totalDaysIshaCOR = [NSNumber numberWithDouble:
                                                  (intIsha / 86400)];
                    NSNumber *totalHoursIshaCOR = [NSNumber numberWithDouble:
                                                   ((intIsha / 3600) -
                                                    ([totalDaysIshaCOR intValue] * 24))];
                    NSNumber *totalMinutesIshaCOR = [NSNumber numberWithDouble:
                                                     ((intIsha / 60) -
                                                      ([totalDaysIshaCOR intValue] * 24 * 60) -
                                                      ([totalHoursIshaCOR intValue] * 60))];
                    
                    NSInteger intHoursIsha;
                    intHoursIsha = [totalHoursIshaCOR intValue];
                    NSInteger intMinutesIsha;
                    intMinutesIsha = [totalMinutesIshaCOR intValue];
                    
                    if ((IntLooptime -60) <= intIsha && (IntLooptime +60) >= intIsha) {
                        if (bolisha1 == NO) {
                            bolisha1 = YES;
                            intlooptimeisha = IntLooptime;
                            
                            [User sharedUser].bolIsha = YES;
                            [User sharedUser].strIsha = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursIsha, (long)intMinutesIsha] stringByAppendingString:@" UTC"];
                            
                            NSInteger intIshaLCL = intIsha + [User sharedUser].IntTimeZone;
                            if (intIshaLCL < 0) {
                                intIshaLCL = 86400 + intIshaLCL;
                            }
                            NSNumber *totalDays = [NSNumber numberWithDouble:
                                                   (intIshaLCL / 86400)];
                            NSNumber *totalHours = [NSNumber numberWithDouble:
                                                    ((intIshaLCL / 3600) -
                                                     ([totalDays intValue] * 24))];
                            NSNumber *totalMinutes = [NSNumber numberWithDouble:
                                                      ((intIshaLCL / 60) -
                                                       ([totalDays intValue] * 24 * 60) -
                                                       ([totalHours intValue] * 60))];
                            
                            NSInteger intHoursIshaLCL;
                            intHoursIshaLCL = [totalHours intValue];
                            NSInteger intMinutesIshaLCL;
                            intMinutesIshaLCL = [totalMinutes intValue];
                            
                            [User sharedUser].strIshaLCL = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursIshaLCL, (long)intMinutesIshaLCL] stringByAppendingString:@" LCL"];
                            SunFlightresults *Result = [[SunFlightresults alloc] init];
                            objLog *objLogSSSR = [[objLog alloc ]init];
                            BOOL found = NO;
                            for (Result in [User sharedUser].arrayResults){
                                if([Result.strWptName isEqualToString:@"Isha"]){
                                    found = YES;
                                    [[User sharedUser].arrayResults removeObject: Result];
                                    break;
                                }
                            }
                            if (found){
                                for (objLogSSSR in [User sharedUser].arrayResults){
                                    if([objLogSSSR.strWptName isEqualToString:@"Isha"]){
                                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogSSSR.strWptName];
                                        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                        [[User sharedUser].arrayLog removeObjectAtIndex:indexOfTheObject];
                                    }
                                }
//                                [[User sharedUser].arrayResults removeObject: Result];
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                Result.strWptName = @"Isha";
                                Result.strType = @"Prayer";
                                Result.strTime = [User sharedUser].strIsha;
                                Result.strTimeLCL = [User sharedUser].strIshaLCL;
                                Result.strFlightLevel = objLogWpt.strFL;
                                Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                [[User sharedUser].arrayResults addObject: Result];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                objLogSSSR.strType = @"Prayer";
                                objLogSSSR.strWptName = @"Isha";
                                objLogSSSR.strWptAirway = [User sharedUser].strIsha;
                                objLogSSSR.strFL = objLogWpt.strFL;
                                objLogSSSR.strAlternates = @"";
                                objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                
                            }else{
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                Result.strWptName = @"Isha";
                                Result.strType = @"Prayer";
                                Result.strTime = [User sharedUser].strIsha;
                                Result.strTimeLCL = [User sharedUser].strIshaLCL;
                                Result.strFlightLevel = objLogWpt.strFL;
                                Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                [[User sharedUser].arrayResults addObject: Result];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                objLogSSSR.strType = @"Prayer";
                                objLogSSSR.strWptName = @"Isha";
                                objLogSSSR.strWptAirway = [User sharedUser].strIsha;
                                objLogSSSR.strFL = objLogWpt.strFL;
                                objLogSSSR.strAlternates = @"";
                                objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                            }
                            
                        }else{
                            if ((IntLooptime - intlooptimeisha) > 3600 ) {
                                SunFlightresults *Result;
                                [User sharedUser].bolIsha2 = YES;
                                [User sharedUser].strIsha2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursIsha, (long)intMinutesIsha] stringByAppendingString:@" UTC"];
                                NSInteger intIshaLCL = intIsha + [User sharedUser].IntTimeZone;
                                if (intIshaLCL < 0) {
                                    intIshaLCL = 86400 + intIshaLCL;
                                }
                                NSNumber *totalDays = [NSNumber numberWithDouble:
                                                       (intIshaLCL / 86400)];
                                NSNumber *totalHours = [NSNumber numberWithDouble:
                                                        ((intIshaLCL / 3600) -
                                                         ([totalDays intValue] * 24))];
                                NSNumber *totalMinutes = [NSNumber numberWithDouble:
                                                          ((intIshaLCL / 60) -
                                                           ([totalDays intValue] * 24 * 60) -
                                                           ([totalHours intValue] * 60))];
                                
                                NSInteger intHoursIshaLCL;
                                intHoursIshaLCL = [totalHours intValue];
                                NSInteger intMinutesIshaLCL;
                                intMinutesIshaLCL = [totalMinutes intValue];
                                [User sharedUser].strIshaLCL2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursIshaLCL, (long)intMinutesIshaLCL] stringByAppendingString:@" LCL"];
                                Result = [[SunFlightresults alloc] init];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                BOOL found = NO;
                                for (Result in [User sharedUser].arrayResults){
                                    if([Result.strWptName isEqualToString:@"Isha (2)"]){
                                        found = YES;
                                        [[User sharedUser].arrayResults removeObject: Result];
                                        break;
                                    }
                                }
                                if (found){
                                    for (objLogSSSR in [User sharedUser].arrayResults){
                                        if([objLogSSSR.strWptName isEqualToString:@"Isha (2)"]){
                                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogSSSR.strWptName];
                                            NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                            NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                            [[User sharedUser].arrayLog removeObjectAtIndex:indexOfTheObject];
                                        }
                                    }
//                                    [[User sharedUser].arrayResults removeObject: Result];
                                    SunFlightresults *Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Isha (2)";
                                    Result.strType = @"Prayer";
                                    Result.strTime = [User sharedUser].strIsha2;
                                    Result.strTimeLCL = [User sharedUser].strIshaLCL2;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    [[User sharedUser].arrayResults addObject: Result];
                                    objLog *objLogSSSR = [[objLog alloc ]init];
                                    objLogSSSR.strType = @"Prayer";
                                    objLogSSSR.strWptName = @"Isha (2)";
                                    objLogSSSR.strWptAirway = [User sharedUser].strIsha2;
                                    objLogSSSR.strFL = objLogWpt.strFL;
                                    objLogSSSR.strAlternates = @"";
                                    objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                    NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                    [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                    
                                }else{
                                    SunFlightresults *Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Isha (2)";
                                    Result.strType = @"Prayer";
                                    Result.strTime = [User sharedUser].strIsha2;
                                    Result.strTimeLCL = [User sharedUser].strIshaLCL2;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    [[User sharedUser].arrayResults addObject: Result];
                                    objLog *objLogSSSR = [[objLog alloc ]init];
                                    objLogSSSR.strType = @"Prayer";
                                    objLogSSSR.strWptName = @"Isha (2)";
                                    objLogSSSR.strWptAirway = [User sharedUser].strIsha2;
                                    objLogSSSR.strFL = objLogWpt.strFL;
                                    objLogSSSR.strAlternates = @"";
                                    objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                    NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                    [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                }
                            }
                        }
                    }
                    
                    NSDateComponents *compsSunrise = [gregorian components:unitFlags fromDate:EDSSSR.sunrise];
                    
                    // Now extract the hour:mins from today's date
                    NSInteger hourSunrise = [compsSunrise hour];
                    NSInteger minSunrise = [compsSunrise minute];
                    NSInteger intSunrise = ((hourSunrise*60)+minSunrise)*60;
                    if (intSunrise < intAltitudeCorrection) {
                        intSunrise = (intSunrise + 86400) - intAltitudeCorrection;
                    }else{
                        intSunrise = intSunrise - intAltitudeCorrection;
                    }
                    if (intSunrise > 86400) {
                        intSunrise = intSunrise - 86400;
                    }
                    NSNumber *totalDaysCOR = [NSNumber numberWithDouble:
                                              (intSunrise / 86400)];
                    NSNumber *totalHoursCOR = [NSNumber numberWithDouble:
                                               ((intSunrise / 3600) -
                                                ([totalDaysCOR intValue] * 24))];
                    NSNumber *totalMinutesCOR = [NSNumber numberWithDouble:
                                                 ((intSunrise / 60) -
                                                  ([totalDaysCOR intValue] * 24 * 60) -
                                                  ([totalHoursCOR intValue] * 60))];
                    
                    NSInteger intHoursSR;
                    intHoursSR = [totalHoursCOR intValue];
                    NSInteger intMinutesSR;
                    intMinutesSR = [totalMinutesCOR intValue];
                    NSLog(@"dblLoopTime");
                    NSLog(@"%f", (floor(dblLoopTimeLog)));
                    NSLog(@"intLoopTime");
                    NSLog(@"%i", IntLooptime);
                    NSLog(@"intSunrise");
                    NSLog(@"%li", (long)(intSunrise));
                    NSInteger intSunriseLCL = intSunrise + [User sharedUser].IntTimeZone;
                    if (intSunriseLCL < 0) {
                        intSunriseLCL = 86400 + intSunriseLCL;
                    }
                    NSNumber *totalDays = [NSNumber numberWithDouble:
                                           (intSunriseLCL / 86400)];
                    NSNumber *totalHours = [NSNumber numberWithDouble:
                                            ((intSunriseLCL / 3600) -
                                             ([totalDays intValue] * 24))];
                    NSNumber *totalMinutes = [NSNumber numberWithDouble:
                                              ((intSunriseLCL / 60) -
                                               ([totalDays intValue] * 24 * 60) -
                                               ([totalHours intValue] * 60))];
                    NSInteger intHoursSRLCL;
                    intHoursSRLCL = [totalHours intValue];
                    NSInteger intMinutesSRLCL;
                    intMinutesSRLCL = [totalMinutes intValue];
                    
                    
                    
                    if ((IntLooptime -60) <= intSunrise && (IntLooptime +60) >= intSunrise) {
                        // display computed values
                        dblGCLongitude = -dblGCLongitude;
                        if (bolsunrise1 == NO) {
                            bolsunrise1 = YES;
                            intlooptimesunrise = IntLooptime;
                            
                            if ([User sharedUser].bolPreFlight == YES) {
                                [User sharedUser].bolSunRise = YES;
                            }
                            if ([User sharedUser].bolInFlight == YES) {
                                [User sharedUser].bolSunRiseInFlight = YES;
                            }
                            [User sharedUser].bolDay = YES;
                            [User sharedUser].intSunrise = floor(IntLooptime/60)*60;
                            
                            if ([User sharedUser].bolSunSet == NO) {
                                NSInteger intSunriseCalc = [User sharedUser].intSunrise;
                                if (intSunriseCalc < [User sharedUser].intTimeOvhdFROMPreFlight){
                                    intSunriseCalc = intSunriseCalc + 86400;
                                }
                                [User sharedUser].intNightFlightTime = intSunriseCalc - [User sharedUser].intTimeOvhdFROMPreFlight;
                                NSLog(@"Nighttime");
                                NSLog(@"%li", (long)([User sharedUser].intNightFlightTime));
                                NSLog(@"IntsunriseCalc");
                                NSLog(@"%li", (long)(intSunriseCalc));
                            } else {
                                NSInteger intSunriseCalc = [User sharedUser].intSunrise;
                                if (intSunriseCalc < [User sharedUser].intSunset) {
                                    intSunriseCalc = intSunriseCalc + 86400;
                                }
                                [User sharedUser].intNightFlightTime = intSunriseCalc - [User sharedUser].intSunset;
                                NSLog(@"intSunset");
                                NSLog(@"%li", (long)([User sharedUser].intSunset));
                                NSLog(@"intSunrise");
                                NSLog(@"%li", (long)([User sharedUser].intSunrise));
                                NSLog(@"Nighttime");
                                NSLog(@"%li", (long)([User sharedUser].intNightFlightTime));
                            }
                            [User sharedUser].strSunrise = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSR, (long)intMinutesSR] stringByAppendingString:@" UTC"];
                            [User sharedUser].strSunriseLCL = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSRLCL, (long)intMinutesSRLCL] stringByAppendingString:@" LCL"];
                            if (dblGCLatitude >= 0) {
                                NSString *strLatSR = [[NSString alloc]initWithFormat:@"%02.0f° %02.1f' N", floor(dblGCLatitude*(180/M_PI)),(dblGCLatitude*(180/M_PI)-floor(dblGCLatitude*(180/M_PI)))*60];
                                [User sharedUser].strLatSunrise = strLatSR;
                                [User sharedUser].dblLatitudeSR = dblGCLatitude*(180/M_PI);
                            } else {
                                dblGCLatitude = dblGCLatitude*-1;
                                NSString *strLatSR = [[NSString alloc]initWithFormat:@"%02.0f° %02.1f' S", floor(dblGCLatitude*(180/M_PI)),(dblGCLatitude*(180/M_PI)-floor(dblGCLatitude*(180/M_PI)))*60];
                                [User sharedUser].strLatSunrise = strLatSR;
                                [User sharedUser].dblLatitudeSR = (dblGCLatitude*(180/M_PI))*-1;
                            }
                            if (dblGCLongitude >= 0) {
                                NSString *strLongSR = [[NSString alloc]initWithFormat:@"%03.0f° %02.1f' W", floor(dblGCLongitude*(180/M_PI)),(dblGCLongitude*(180/M_PI)-floor(dblGCLongitude*(180/M_PI)))*60];
                                [User sharedUser].strLongSunrise = strLongSR;
                                [User sharedUser].dblLongitudeSR = (dblGCLongitude*(180/M_PI))*-1;
                            } else {
                                dblGCLongitude = dblGCLongitude*-1;
                                NSString *strLongSR = [[NSString alloc]initWithFormat:@"%03.0f° %02.1f' E", floor(dblGCLongitude*(180/M_PI)),(dblGCLongitude*(180/M_PI)-floor(dblGCLongitude*(180/M_PI)))*60];
                                [User sharedUser].strLongSunrise = strLongSR;
                                [User sharedUser].dblLongitudeSR = dblGCLongitude*(180/M_PI);
                            }
                            SunFlightresults *Result = [[SunFlightresults alloc] init];
                            BOOL found = NO;
                            for (Result in [User sharedUser].arrayResults){
                                if([Result.strWptName isEqualToString:@"Sunrise"]){
                                    found = YES;
                                    [[User sharedUser].arrayResults removeObject: Result];
                                    break;
                                }
                            }
                            if (found){
//                                [[User sharedUser].arrayResults removeObject: Result];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                for (objLogSSSR in [User sharedUser].arrayResults){
                                    if([objLogSSSR.strWptName isEqualToString:@"Sunrise"]){
                                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogSSSR.strWptName];
                                        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                        [[User sharedUser].arrayLog removeObjectAtIndex:indexOfTheObject];
                                    }
                                }
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                Result.strWptName = @"Sunrise";
                                Result.strType = @"SSSR";
                                Result.strTime = [User sharedUser].strSunrise;
                                Result.strTimeLCL = [User sharedUser].strSunriseLCL;
                                Result.strLatitude = [User sharedUser].strLatSunrise;
                                Result.strLongitude = [User sharedUser].strLongSunrise;
                                Result.dblLatitude = [User sharedUser].dblLatitudeSR;
                                Result.dblLongitude = [User sharedUser].dblLongitudeSR;
                                Result.intTime = [User sharedUser].intSunrise;
                                Result.strFlightLevel = objLogWpt.strFL;
                                Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                [[User sharedUser].arrayResults addObject: Result];
                                objLogSSSR.strType = @"SSSR";
                                objLogSSSR.strWptName = @"Sunrise";
                                objLogSSSR.strWptAirway = [User sharedUser].strSunrise;
                                objLogSSSR.strFL = objLogWpt.strFL;
                                objLogSSSR.strAlternates = @"";
                                objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                objLogSSSR.strLat = [User sharedUser].strLatSunrise;
                                objLogSSSR.strLon = [User sharedUser].strLongSunrise;
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                            }else{
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                Result.strWptName = @"Sunrise";
                                Result.strType = @"SSSR";
                                Result.strTime = [User sharedUser].strSunrise;
                                Result.strTimeLCL = [User sharedUser].strSunriseLCL;
                                Result.strLatitude = [User sharedUser].strLatSunrise;
                                Result.strLongitude = [User sharedUser].strLongSunrise;
                                Result.dblLatitude = [User sharedUser].dblLatitudeSR;
                                Result.dblLongitude = [User sharedUser].dblLongitudeSR;
                                Result.intTime = [User sharedUser].intSunrise;
                                Result.strFlightLevel = objLogWpt.strFL;
                                Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                [[User sharedUser].arrayResults addObject: Result];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                objLogSSSR.strType = @"SSSR";
                                objLogSSSR.strWptName = @"Sunrise";
                                objLogSSSR.strWptAirway = [User sharedUser].strSunrise;
                                objLogSSSR.strFL = objLogWpt.strFL;
                                objLogSSSR.strAlternates = @"";
                                objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                objLogSSSR.strLat = [User sharedUser].strLatSunrise;
                                objLogSSSR.strLon = [User sharedUser].strLongSunrise;
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                            }
                            
                        }else{
                            if ((IntLooptime - intlooptimesunrise) > 3600 )
                            {
                                [User sharedUser].bolSunRise2 = YES;
                                [User sharedUser].bolDay = YES;
                                [User sharedUser].intSunrise = floor(IntLooptime/60)*60;
                                
                                if ([User sharedUser].bolSunSet2 == NO) {
                                    NSInteger intSunriseCalc = [User sharedUser].intSunrise;
                                    if (intSunriseCalc < [User sharedUser].intTimeOvhdFROMPreFlight){
                                        intSunriseCalc = intSunriseCalc + 86400;
                                    }
                                    [User sharedUser].intNightFlightTime = intSunriseCalc - [User sharedUser].intTimeOvhdFROMPreFlight;
                                    NSLog(@"Nighttime");
                                    NSLog(@"%li", (long)([User sharedUser].intNightFlightTime));
                                    NSLog(@"IntsunriseCalc");
                                    NSLog(@"%li", (long)(intSunriseCalc));
                                    
                                    
                                } else {
                                    NSInteger intSunriseCalc = [User sharedUser].intSunrise;
                                    if (intSunriseCalc < [User sharedUser].intSunset) {
                                        intSunriseCalc = intSunriseCalc + 86400;
                                    }
                                    [User sharedUser].intNightFlightTime = intSunriseCalc - [User sharedUser].intSunset;
                                    NSLog(@"intSunset");
                                    NSLog(@"%li", (long)([User sharedUser].intSunset));
                                    NSLog(@"intSunrise");
                                    NSLog(@"%li", (long)([User sharedUser].intSunrise));
                                    NSLog(@"Nighttime");
                                    NSLog(@"%li", (long)([User sharedUser].intNightFlightTime));
                                }
                                
                                if ([User sharedUser].bolInFlight == YES) {
                                    [User sharedUser].strSunriseInFlight2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSR, (long)intMinutesSR] stringByAppendingString:@" UTC"];
                                    [User sharedUser].strSunriseLCLinFlight2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSRLCL, (long)intMinutesSRLCL] stringByAppendingString:@" LCL"];
                                }else{
                                    [User sharedUser].strSunrise2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSR, (long)intMinutesSR] stringByAppendingString:@" UTC"];
                                    [User sharedUser].strSunriseLCL2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSRLCL, (long)intMinutesSRLCL] stringByAppendingString:@" LCL"];
                                }
                                
                                if (dblGCLatitude >= 0) {
                                    NSString *strLatSR = [[NSString alloc]initWithFormat:@"%02.0f° %02.1f' N", floor(dblGCLatitude*(180/M_PI)),(dblGCLatitude*(180/M_PI)-floor(dblGCLatitude*(180/M_PI)))*60];
                                    if ([User sharedUser].bolPreFlight == YES) {
                                        [User sharedUser].strLatSunrise2 = strLatSR;
                                        [User sharedUser].dblLatitudeSR2 = dblGCLatitude*(180/M_PI);
                                    }
                                    if ([User sharedUser].bolInFlight == YES) {
                                        [User sharedUser].strLatSunriseInFlight2 = strLatSR;
                                        [User sharedUser].dblLatitudeSRInFlight2 = dblGCLatitude*(180/M_PI);
                                        
                                    }
                                    
                                } else {
                                    dblGCLatitude = dblGCLatitude*-1;
                                    NSString *strLatSR = [[NSString alloc]initWithFormat:@"%02.0f° %02.1f' S", floor(dblGCLatitude*(180/M_PI)),(dblGCLatitude*(180/M_PI)-floor(dblGCLatitude*(180/M_PI)))*60];
                                    if ([User sharedUser].bolPreFlight == YES) {
                                        [User sharedUser].strLatSunrise2 = strLatSR;
                                        [User sharedUser].dblLatitudeSR2 = (dblGCLatitude*(180/M_PI))*-1;
                                    }
                                    if ([User sharedUser].bolInFlight == YES) {
                                        [User sharedUser].strLatSunriseInFlight2 = strLatSR;
                                        [User sharedUser].dblLatitudeSRInFlight2 = (dblGCLatitude*(180/M_PI))*-1;
                                        
                                    }
                                }
                                if (dblGCLongitude >= 0) {
                                    NSString *strLongSR = [[NSString alloc]initWithFormat:@"%03.0f° %02.1f' W", floor(dblGCLongitude*(180/M_PI)),(dblGCLongitude*(180/M_PI)-floor(dblGCLongitude*(180/M_PI)))*60];
                                    if ([User sharedUser].bolPreFlight == YES) {
                                        [User sharedUser].strLongSunrise2 = strLongSR;
                                        [User sharedUser].dblLongitudeSR2 = (dblGCLongitude*(180/M_PI))*-1;
                                    }
                                    if ([User sharedUser].bolInFlight == YES) {
                                        [User sharedUser].strLongSunriseInFlight2 = strLongSR;
                                        [User sharedUser].dblLongitudeSRInFlight2 = (dblGCLongitude*(180/M_PI))*-1;
                                    }
                                    
                                } else {
                                    dblGCLongitude = dblGCLongitude*-1;
                                    NSString *strLongSR = [[NSString alloc]initWithFormat:@"%03.0f° %02.1f' E", floor(dblGCLongitude*(180/M_PI)),(dblGCLongitude*(180/M_PI)-floor(dblGCLongitude*(180/M_PI)))*60];
                                    if ([User sharedUser].bolPreFlight == YES) {
                                        [User sharedUser].strLongSunrise2 = strLongSR;
                                        [User sharedUser].dblLongitudeSR2 = dblGCLongitude*(180/M_PI);
                                    }
                                    if ([User sharedUser].bolInFlight == YES) {
                                        [User sharedUser].strLongSunriseInFlight2 = strLongSR;
                                        [User sharedUser].dblLongitudeSRInFlight2 = dblGCLongitude*(180/M_PI);
                                    }
                                }
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                
                                BOOL found = NO;
                                for (Result in [User sharedUser].arrayResults){
                                    if([Result.strWptName isEqualToString:@"Sunrise (2)"]){
                                        found = YES;
                                        [[User sharedUser].arrayResults removeObject: Result];
                                        break;
                                    }
                                }
                                if (found){
//                                    [[User sharedUser].arrayResults removeObject: Result];
                                    for (objLogSSSR in [User sharedUser].arrayResults){
                                        if([objLogSSSR.strWptName isEqualToString:@"Sunrise (2)"]){
                                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogSSSR.strWptName];
                                            NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                            NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                            [[User sharedUser].arrayLog removeObjectAtIndex:indexOfTheObject];
                                        }
                                    }
                                    SunFlightresults *Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Sunrise (2)";
                                    Result.strType = @"SSSR";
                                    Result.strTime = [User sharedUser].strSunrise2;
                                    Result.strTimeLCL = [User sharedUser].strSunriseLCL2;
                                    Result.strLatitude = [User sharedUser].strLatSunrise2;
                                    Result.strLongitude = [User sharedUser].strLongSunrise2;
                                    Result.dblLatitude = [User sharedUser].dblLatitudeSR2;
                                    Result.dblLongitude = [User sharedUser].dblLongitudeSR2;
                                    Result.intTime = [User sharedUser].intSunrise;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = objLogWpt.strCET;
                                    [[User sharedUser].arrayResults addObject: Result];
                                    objLogSSSR.strType = @"SSSR";
                                    objLogSSSR.strWptName = @"Sunrise (2)";
                                    objLogSSSR.strWptAirway = [User sharedUser].strSunrise2;
                                    objLogSSSR.strFL = objLogWpt.strFL;
                                    objLogSSSR.strAlternates = @"";
                                    objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    objLogSSSR.strLat = [User sharedUser].strLatSunrise2;
                                    objLogSSSR.strLon = [User sharedUser].strLongSunrise2;
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                    NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                    [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                    
                                }else{
                                    SunFlightresults *Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Sunrise (2)";
                                    Result.strType = @"SSSR";
                                    Result.strTime = [User sharedUser].strSunrise2;
                                    Result.strTimeLCL = [User sharedUser].strSunriseLCL2;
                                    Result.strLatitude = [User sharedUser].strLatSunrise2;
                                    Result.strLongitude = [User sharedUser].strLongSunrise2;
                                    Result.dblLatitude = [User sharedUser].dblLatitudeSR2;
                                    Result.dblLongitude = [User sharedUser].dblLongitudeSR2;
                                    Result.intTime = [User sharedUser].intSunrise;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = objLogWpt.strCET;
                                    [[User sharedUser].arrayResults addObject: Result];
                                    objLogSSSR.strType = @"SSSR";
                                    objLogSSSR.strWptName = @"Sunrise (2)";
                                    objLogSSSR.strWptAirway = [User sharedUser].strSunrise2;
                                    objLogSSSR.strFL = objLogWpt.strFL;
                                    objLogSSSR.strAlternates = @"";
                                    objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    objLogSSSR.strLat = [User sharedUser].strLatSunrise2;
                                    objLogSSSR.strLon = [User sharedUser].strLongSunrise2;
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                    NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                    [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                }
                                
                            }
                        }
                    }
                    NSDateComponents *compsSunset = [gregorian components:unitFlags fromDate:EDSSSR.sunset];
                    // Now extract the hour:mins from today's date
                    NSInteger hourSunSet = [compsSunset hour];
                    NSInteger minSunSet = [compsSunset minute];
                    NSInteger intSunSet = ((hourSunSet*60)+minSunSet)*60;
                    
                    if (intSunSet < intAltitudeCorrection) {
                        intSunSet = (intSunSet + 86400) + intAltitudeCorrection;
                    }else{
                        intSunSet = intSunSet + intAltitudeCorrection;
                    }
                    if (intSunSet > 86400) {
                        intSunSet = intSunSet - 86400;
                    }
                    
                    
                    
                    NSNumber *totalDaysSSCOR = [NSNumber numberWithDouble:
                                                (intSunSet / 86400)];
                    NSNumber *totalHoursSSCOR = [NSNumber numberWithDouble:
                                                 ((intSunSet / 3600) -
                                                  ([totalDaysSSCOR intValue] * 24))];
                    NSNumber *totalMinutesSSCOR = [NSNumber numberWithDouble:
                                                   ((intSunSet / 60) -
                                                    ([totalDaysSSCOR intValue] * 24 * 60) -
                                                    ([totalHoursSSCOR intValue] * 60))];
                    
                    NSInteger intHoursSS;
                    intHoursSS = [totalHoursSSCOR intValue];
                    NSInteger intMinutesSS;
                    intMinutesSS = [totalMinutesSSCOR intValue];
                    NSInteger intSunSetLCL = intSunSet + [User sharedUser].IntTimeZone;
                    if (intSunSetLCL < 0 ) {
                        intSunSetLCL = 86400 + intSunSetLCL;
                    }
                    NSNumber *totalDaysSSLCL = [NSNumber numberWithDouble:
                                                (intSunSetLCL / 86400)];
                    NSNumber *totalHoursSSLCL = [NSNumber numberWithDouble:
                                                 ((intSunSetLCL / 3600) -
                                                  ([totalDaysSSLCL intValue] * 24))];
                    NSNumber *totalMinutesSSLCL = [NSNumber numberWithDouble:
                                                   ((intSunSetLCL / 60) -
                                                    ([totalDaysSSLCL intValue] * 24 * 60) -
                                                    ([totalHoursSSLCL intValue] * 60))];
                    
                    NSInteger intHoursSSLCL;
                    intHoursSSLCL = [totalHoursSSLCL intValue];
                    NSInteger intMinutesSSLCL;
                    intMinutesSSLCL = [totalMinutesSSLCL intValue];
                    
                    
                    if ((IntLooptime -60) <= intSunSet && (IntLooptime +60) >= intSunSet) {  // plus minus 1 min range
                        // display computed values
                        dblGCLongitude = -dblGCLongitude;
                        if (bolsunset1 == NO) {
                            bolsunset1 = YES;
                            intlooptimesunset = IntLooptime;
                            [User sharedUser].bolSunSet = YES;
                            [User sharedUser].bolDay = NO;
                            [User sharedUser].intSunset = floor(IntLooptime/60)*60;
                            if ([User sharedUser].bolSunRise == NO) {
                                NSInteger intSunsetCalc = [User sharedUser].intSunset;
                                if (intSunsetCalc < [User sharedUser].intTimeOvhdFROMPreFlight){
                                    intSunsetCalc = intSunsetCalc + 86400;
                                }
                                
                            } else {
                                NSInteger intSunsetCalc = [User sharedUser].intSunset;
                                if (intSunsetCalc < [User sharedUser].intSunrise) {
                                    intSunsetCalc = intSunsetCalc + 86400;
                                }
                                NSLog(@"intSunset");
                                NSLog(@"%li", (long)([User sharedUser].intSunset));
                                NSLog(@"intSunrise");
                                NSLog(@"%li", (long)([User sharedUser].intSunrise));
                                NSLog(@"Nighttime");
                                NSLog(@"%li", (long)([User sharedUser].intNightFlightTime));
                                
                            }
                            [User sharedUser].strSunset = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSS, (long)intMinutesSS] stringByAppendingString:@" UTC"];
                            [User sharedUser].strSunsetLCL = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSSLCL, (long)intMinutesSSLCL] stringByAppendingString:@" LCL"];
                            
                            if (dblGCLatitude >= 0) {
                                NSString *strLatSS = [[NSString alloc]initWithFormat:@"%02.0f° %02.1f' N", floor(dblGCLatitude*(180/M_PI)),(dblGCLatitude*(180/M_PI)-floor(dblGCLatitude*(180/M_PI)))*60];
                                [User sharedUser].strLatSunset = strLatSS;
                                [User sharedUser].dblLatitudeSS = dblGCLatitude*(180/M_PI);
                            } else {
                                dblGCLatitude = dblGCLatitude*-1;
                                NSString *strLatSS = [[NSString alloc]initWithFormat:@"%02.0f° %02.1f' S", floor(dblGCLatitude*(180/M_PI)),(dblGCLatitude*(180/M_PI)-floor(dblGCLatitude*(180/M_PI)))*60];
                                [User sharedUser].strLatSunset = strLatSS;
                                [User sharedUser].dblLatitudeSS = (dblGCLatitude*(180/M_PI))*-1;
                            }
                            if (dblGCLongitude >= 0) {
                                NSString *strLongSS = [[NSString alloc]initWithFormat:@"%03.0f° %02.1f' W", floor(dblGCLongitude*(180/M_PI)),(dblGCLongitude*(180/M_PI)-floor(dblGCLongitude*(180/M_PI)))*60];
                                [User sharedUser].strLongSunset = strLongSS;
                                [User sharedUser].dblLongitudeSS = (dblGCLongitude*(180/M_PI))*-1;
                            } else {
                                dblGCLongitude = dblGCLongitude*-1;
                                NSString *strLongSS = [[NSString alloc]initWithFormat:@"%03.0f° %02.1f' E", floor(dblGCLongitude*(180/M_PI)),(dblGCLongitude*(180/M_PI)-floor(dblGCLongitude*(180/M_PI)))*60];
                                [User sharedUser].strLongSunset = strLongSS;
                                [User sharedUser].dblLongitudeSS = dblGCLongitude*(180/M_PI);
                            }
                            SunFlightresults *Result = [[SunFlightresults alloc] init];
                            objLog *objLogSSSR = [[objLog alloc ]init];
                            BOOL found = NO;
                            for (Result in [User sharedUser].arrayResults){
                                if([Result.strWptName isEqualToString:@"Sunset"]){
                                    found = YES;
                                    [[User sharedUser].arrayResults removeObject: Result];
                                    break;
                                }
                            }
                            if (found){
//                                [[User sharedUser].arrayResults removeObject: Result];
                                for (objLogSSSR in [User sharedUser].arrayResults){
                                    if([objLogSSSR.strWptName isEqualToString:@"Sunset"]){
                                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogSSSR.strWptName];
                                        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                        [[User sharedUser].arrayLog removeObjectAtIndex:indexOfTheObject];
                                    }
                                }
                                
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                Result.strWptName = @"Sunset";
                                if ([User sharedUser].bolInFlight == YES) {
                                    Result.strTime = [User sharedUser].strSunsetInFlight;
                                    Result.strTimeLCL = [User sharedUser].strSunsetLCLinFlight;
                                }else{
                                    Result.strTime = [User sharedUser].strSunset;
                                    Result.strTimeLCL = [User sharedUser].strSunsetLCL;
                                }
                                Result.strLatitude = [User sharedUser].strLatSunset;
                                Result.strLongitude = [User sharedUser].strLongSunset;
                                Result.dblLatitude = [User sharedUser].dblLatitudeSS;
                                Result.dblLongitude = [User sharedUser].dblLongitudeSS;
                                Result.intTime = [User sharedUser].intSunset;
                                Result.strFlightLevel = objLogWpt.strFL;
                                Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                [[User sharedUser].arrayResults addObject: Result];
                                objLogSSSR.strType = @"SSSR";
                                objLogSSSR.strWptName = @"Sunset";
                                objLogSSSR.strWptAirway = [User sharedUser].strSunset;
                                objLogSSSR.strFL = objLogWpt.strFL;
                                objLogSSSR.strAlternates = @"";
                                objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                objLogSSSR.strLat = [User sharedUser].strLatSunset;
                                objLogSSSR.strLon = [User sharedUser].strLongSunset;
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                
                            }else{
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                Result.strWptName = @"Sunset";
                                Result.strType = @"SSSR";
                                Result.strTime = [User sharedUser].strSunset;
                                Result.strTimeLCL = [User sharedUser].strSunsetLCL;
                                Result.strLatitude = [User sharedUser].strLatSunset;
                                Result.strLongitude = [User sharedUser].strLongSunset;
                                Result.dblLatitude = [User sharedUser].dblLatitudeSS;
                                Result.dblLongitude = [User sharedUser].dblLongitudeSS;
                                Result.intTime = [User sharedUser].intSunset;
                                Result.strFlightLevel = objLogWpt.strFL;
                                Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                [[User sharedUser].arrayResults addObject: Result];
                                Result = [[SunFlightresults alloc] init];
                                Result.strWptName = @"Maghrib";
                                Result.strType = @"Prayer";
                                Result.strTime = [User sharedUser].strSunset;
                                Result.strTimeLCL = [User sharedUser].strSunsetLCL;
                                Result.strLatitude = [User sharedUser].strLatSunset;
                                Result.strLongitude = [User sharedUser].strLongSunset;
                                Result.dblLatitude = [User sharedUser].dblLatitudeSS;
                                Result.dblLongitude = [User sharedUser].dblLongitudeSS;
                                Result.intTime = [User sharedUser].intSunset;
                                Result.strFlightLevel = objLogWpt.strFL;
                                Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                [[User sharedUser].arrayResults addObject: Result];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                objLogSSSR.strType = @"SSSR";
                                objLogSSSR.strWptName = @"Sunset";
                                objLogSSSR.strWptAirway = [User sharedUser].strSunset;
                                objLogSSSR.strFL = objLogWpt.strFL;
                                objLogSSSR.strAlternates = @"";
                                objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                objLogSSSR.strLat = [User sharedUser].strLatSunset;
                                objLogSSSR.strLon = [User sharedUser].strLongSunset;
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                
                            }
                            
                        }else{
                            if ((IntLooptime - intlooptimesunset) > 3600 )
                            {
                                [User sharedUser].bolSunSet2 = YES;
                                [User sharedUser].bolDay = NO;
                                [User sharedUser].intSunset = floor(IntLooptime/60)*60;
                                if ([User sharedUser].bolSunRise2 == NO) {
                                    
                                    NSInteger intSunsetCalc = [User sharedUser].intSunset;
                                    if (intSunsetCalc < [User sharedUser].intTimeOvhdFROMPreFlight){
                                        intSunsetCalc = intSunsetCalc + 86400;
                                    }
                                    
                                    NSLog(@"intSunset");
                                    NSLog(@"%li", (long)([User sharedUser].intSunset));
                                    NSLog(@"intSunrise");
                                    NSLog(@"%li", (long)([User sharedUser].intSunrise));
                                    NSLog(@"Nighttime");
                                    NSLog(@"%li", (long)([User sharedUser].intNightFlightTime));
                                    
                                }
                                [User sharedUser].strSunset2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSS, (long)intMinutesSS] stringByAppendingString:@" UTC"];
                                [User sharedUser].strSunsetLCL2 = [[[NSString alloc] initWithFormat:@"%.2li:%.2li", (long)intHoursSSLCL, (long)intMinutesSSLCL] stringByAppendingString:@" LCL"];
                                if (dblGCLatitude >= 0) {
                                    NSString *strLatSS = [[NSString alloc]initWithFormat:@"%02.0f° %02.1f' N", floor(dblGCLatitude*(180/M_PI)),(dblGCLatitude*(180/M_PI)-floor(dblGCLatitude*(180/M_PI)))*60];
                                    [User sharedUser].strLatSunset2 = strLatSS;
                                    [User sharedUser].dblLatitudeSS2 = dblGCLatitude*(180/M_PI);
                                } else {
                                    dblGCLatitude = dblGCLatitude*-1;
                                    NSString *strLatSS = [[NSString alloc]initWithFormat:@"%02.0f° %02.1f' S", floor(dblGCLatitude*(180/M_PI)),(dblGCLatitude*(180/M_PI)-floor(dblGCLatitude*(180/M_PI)))*60];
                                    [User sharedUser].strLatSunset2 = strLatSS;
                                    [User sharedUser].dblLatitudeSS2 = (dblGCLatitude*(180/M_PI))*-1;
                                }
                                if (dblGCLongitude >= 0) {
                                    NSString *strLongSS = [[NSString alloc]initWithFormat:@"%03.0f° %02.1f' W", floor(dblGCLongitude*(180/M_PI)),(dblGCLongitude*(180/M_PI)-floor(dblGCLongitude*(180/M_PI)))*60];
                                    [User sharedUser].strLongSunset2 = strLongSS;
                                    [User sharedUser].dblLongitudeSS2 = (dblGCLongitude*(180/M_PI))*-1;
                                } else {
                                    dblGCLongitude = dblGCLongitude*-1;
                                    NSString *strLongSS = [[NSString alloc]initWithFormat:@"%03.0f° %02.1f' E", floor(dblGCLongitude*(180/M_PI)),(dblGCLongitude*(180/M_PI)-floor(dblGCLongitude*(180/M_PI)))*60];
                                    [User sharedUser].strLongSunset2 = strLongSS;
                                    [User sharedUser].dblLongitudeSS2 = dblGCLongitude*(180/M_PI);
                                }
                                SunFlightresults *Result = [[SunFlightresults alloc] init];
                                objLog *objLogSSSR = [[objLog alloc ]init];
                                BOOL found = NO;
                                for (Result in [User sharedUser].arrayResults){
                                    if([Result.strWptName isEqualToString:@"Sunset (2)"]){
                                        found = YES;
                                        [[User sharedUser].arrayResults removeObject: Result];
                                        break;
                                    }
                                }
                                if (found){
//                                    [[User sharedUser].arrayResults removeObject: Result];
                                    for (objLogSSSR in [User sharedUser].arrayResults){
                                        if([objLogSSSR.strWptName isEqualToString:@"Sunset (2)"]){
                                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogSSSR.strWptName];
                                            NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                            NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                            [[User sharedUser].arrayLog removeObjectAtIndex:indexOfTheObject];
                                        }
                                    }
                                    
                                    SunFlightresults *Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Sunset (2)";
                                    Result.strType = @"SSSR";
                                    Result.strTime = [User sharedUser].strSunset2;
                                    Result.strTimeLCL = [User sharedUser].strSunsetLCL2;
                                    Result.strLatitude = [User sharedUser].strLatSunset2;
                                    Result.strLongitude = [User sharedUser].strLongSunset2;
                                    Result.dblLatitude = [User sharedUser].dblLatitudeSS2;
                                    Result.dblLongitude = [User sharedUser].dblLongitudeSS2;
                                    Result.intTime = [User sharedUser].intSunset;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    [[User sharedUser].arrayResults addObject: Result];
                                    Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Maghrib (2)";
                                    Result.strType = @"Prayer";
                                    Result.strTime = [User sharedUser].strSunset2;
                                    Result.strTimeLCL = [User sharedUser].strSunsetLCL2;
                                    Result.strLatitude = [User sharedUser].strLatSunset2;
                                    Result.strLongitude = [User sharedUser].strLongSunset2;
                                    Result.dblLatitude = [User sharedUser].dblLatitudeSS2;
                                    Result.dblLongitude = [User sharedUser].dblLongitudeSS2;
                                    Result.intTime = [User sharedUser].intSunset;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    [[User sharedUser].arrayResults addObject: Result];
                                    objLogSSSR.strType = @"SSSR";
                                    objLogSSSR.strWptName = @"Sunset (2)";
                                    objLogSSSR.strWptAirway = [User sharedUser].strSunset;
                                    objLogSSSR.strFL = objLogWpt.strFL;
                                    objLogSSSR.strAlternates = @"";
                                    objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    objLogSSSR.strLat = [User sharedUser].strLatSunset;
                                    objLogSSSR.strLon = [User sharedUser].strLongSunset;
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                    NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                    [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                    
                                }else{
                                    SunFlightresults *Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Sunset (2)";
                                    Result.strType = @"SSSR";
                                    Result.strTime = [User sharedUser].strSunset2;
                                    Result.strTimeLCL = [User sharedUser].strSunsetLCL2;
                                    Result.strLatitude = [User sharedUser].strLatSunset2;
                                    Result.strLongitude = [User sharedUser].strLongSunset2;
                                    Result.dblLatitude = [User sharedUser].dblLatitudeSS2;
                                    Result.dblLongitude = [User sharedUser].dblLongitudeSS2;
                                    Result.intTime = [User sharedUser].intSunset;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    [[User sharedUser].arrayResults addObject: Result];
                                    Result = [[SunFlightresults alloc] init];
                                    Result.strWptName = @"Maghrib (2)";
                                    Result.strType = @"Prayer";
                                    Result.strTime = [User sharedUser].strSunset2;
                                    Result.strTimeLCL = [User sharedUser].strSunsetLCL2;
                                    Result.strLatitude = [User sharedUser].strLatSunset2;
                                    Result.strLongitude = [User sharedUser].strLongSunset2;
                                    Result.dblLatitude = [User sharedUser].dblLatitudeSS2;
                                    Result.dblLongitude = [User sharedUser].dblLongitudeSS2;
                                    Result.intTime = [User sharedUser].intSunset;
                                    Result.strFlightLevel = objLogWpt.strFL;
                                    Result.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    [[User sharedUser].arrayResults addObject: Result];
                                    objLogSSSR.strType = @"SSSR";
                                    objLogSSSR.strWptName = @"Sunset (2)";
                                    objLogSSSR.strWptAirway = [User sharedUser].strSunset;
                                    objLogSSSR.strFL = objLogWpt.strFL;
                                    objLogSSSR.strAlternates = @"";
                                    objLogSSSR.strCET = [[NSString stringWithFormat:@"%02.0f",floor((dblCETTime)/3600)]stringByAppendingString:[NSString stringWithFormat:@"%02.0f",((dblCETTime)/3600 - floor((dblCETTime)/3600))*60]];
                                    objLogSSSR.strLat = [User sharedUser].strLatSunset;
                                    objLogSSSR.strLon = [User sharedUser].strLongSunset;
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objLogWpt.strWptName];
                                    NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
                                    NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
                                    [[User sharedUser].arrayLog insertObject:objLogSSSR atIndex:indexOfTheObject+1];
                                }
                                
                                
                            }
                        }
                        
                    }
                    
                    if (dblDecArrTime - dblLoopTime < 180 && [User sharedUser].bolPreFlight == YES) {
                        NSString *coordinatesWpt = [[NSString alloc] initWithFormat:@"%.2f,%.2f",[User sharedUser].dblLatitudeTOPreFlight,[User sharedUser].dblLongitudeTOPreFlight];
                        [arrayCoordinates addObject:coordinatesWpt];
                        break;
                    }else{
                        
                        intLoopCounter = intLoopCounter + 1;
                        dblLoopTime = dblLoopTime + 60;
                        IntLooptime = IntLooptime + 60;
                        
                    }
                    
                } while (dblLoopTime < dblSectorTime);
                
                //// LOOP END HERE
                
                
                
                [User sharedUser].arrayCoordinates = arrayCoordinates;
            }
        }
    }
}

@end
