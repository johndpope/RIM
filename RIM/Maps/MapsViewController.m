//
//  MapsViewController.m
//  RIM
//
//  Created by Jerald Abille on 2/22/16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import "MapsViewController.h"
#import "FlightPlanPickerTableViewController.h"
#import "SDCoreDataController.h"
#import <pdf.h>
#import "OFPreadObject.h"
#import <SVProgressHUD.h>
#import "StartTableViewController.h"
#import "objLog.h"
#import "objWPT.h"
#import "Country.h"
#import "SDSyncEngine.h"
#import <MaplyScreenMarker.h>
#import <MaplyShape.h>
#import <MaplySticker.h>

@interface MapsViewController ()
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
    NSString *btnFltplanTitle;
    NSMutableString *strFltpln;
    NSMutableString *strInfoMessage;
    NSMutableString *strAlternates;
    NSMutableString *strWeather;
    NSMutableString *strExportWeather;
    NSMutableString *strNOTAMS;
    NSMutableString *strExportNOTAMS;
    
    objWPT *objEnRouteWpt;
    objLog *objLogWpt;
    
    Country *airportLog;
    
    UIBarButtonItem *ofpListBarButtonItem;
    UIBarButtonItem *waypointsListBarButtonItem;
    UIBarButtonItem *airportsBarButtonItem;
    UIBarButtonItem *allAirportsBarButtonItem;
}

@property (nonatomic, strong) FlightPlanPickerTableViewController *flightplanPicker;
@property (nonatomic, strong) UIPopoverController *flightplanPickerPopover;

@end

@implementation MapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.globeVC = [[GlobeViewController alloc] init];
    self.globeVC.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.globeVC.view];
    [self addChildViewController:self.globeVC];
    [self.globeVC didMoveToParentViewController:self];
    
    self.globeVC.delegate = self;
    
    self.globeVC.autoMoveToTap = NO;
    [self.globeVC setZoomLimitsMin:0.015 max:2.25];
    self.globeVC.keepNorthUp = NO;
    
    ofpListBarButtonItem = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"pdf.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(chooseFlightPlanButtonTapped:)];
    waypointsListBarButtonItem = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"list.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(chooseWaypointButtonTapped:)];
    
    airportsBarButtonItem = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"AirportG_25.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(removeAirports)];
    allAirportsBarButtonItem = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"AirportO_25.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(removeCompanyAirports)];
    
    self.navigationItem.leftBarButtonItems = @[ofpListBarButtonItem];
    
}

- (void)removeViewController:(UIViewController *)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

-(IBAction)chooseWaypointButtonTapped:(id)sender
{
    
    StartTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"popWaypoints"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    nav.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = nav.popoverPresentationController;
    controller.preferredContentSize = CGSizeMake(500, 600);
    popover.delegate = self;
    popover.sourceView = self.view;
    popover.sourceRect = CGRectMake(100, 50, 0, 0);
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:nav animated:YES completion:nil];
    controller.delegate = self;
    
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

#pragma mark !!!!: Show markers on globe or map
-(void)selectedFlightPlan:(NSString *)newFlightPlan
{
    //Dismiss the popover if it's showing.
    if (_flightplanPickerPopover) {
        [_flightplanPickerPopover dismissPopoverAnimated:YES];
        _flightplanPickerPopover = nil;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/Inbox", documentsDirectory ];
    [User sharedUser].strPathOFP = [[path stringByAppendingString:@"/"]stringByAppendingString:newFlightPlan];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    [[User sharedUser].arrayEnRouteWaypoints removeAllObjects];
    [[User sharedUser].arrayLog removeAllObjects];
    convertPDF([User sharedUser].strPathOFP);
    [SVProgressHUD showWithStatus:@"Reading OFP, please wait!"];
    // call in main threat
    dispatch_async(dispatch_get_main_queue(), ^{
        [self readOFP];
        
        [self showRouteOnMap];
        
        // Show markers on globe or map.
        
        // [self showRouteonMap];
        
        
    });
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMMyy"];
    dateString = [formatter stringFromDate:[User sharedUser].dateFlight];
    [User sharedUser].strOFPHeader = [[[[User sharedUser].strOFPHeader stringByAppendingString:@" "]stringByAppendingString:dateString] stringByAppendingString:@" "];
    
    [self.navigationItem setLeftBarButtonItems:@[ofpListBarButtonItem, waypointsListBarButtonItem]];
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC didSelect:(NSObject *)selectedObj {
    MaplyScreenMarker *selectedMarker = (MaplyScreenMarker *)selectedObj;
    objWPT *wpt = selectedMarker.userObject;
    
    NSLog(@"Waypoint %@ - %@", wpt.strWptName, wpt.strType);
    
    MaplyAnnotation *annotation = [[MaplyAnnotation alloc] init];
    annotation.title = wpt.strWptName;
    
    if ([wpt.strType isEqualToString:@"Airport"]) {
        UIButton *airportDetailButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        annotation.rightAccessoryView = airportDetailButton;
    }
    else if ([wpt.strType isEqualToString:@"Waypoint"]) {
        annotation.subTitle = [NSString stringWithFormat:@"%@/%@", wpt.strWptAirway, wpt.strMORA];
    }
    else if ([wpt.strType isEqualToString:@"Escape"]) {
        annotation.subTitle = [NSString stringWithFormat:@"%@/%@", wpt.strWptAirway, wpt.strMORA];
        UIButton *waypointDetailButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        annotation.rightAccessoryView = waypointDetailButton;
    }
    
    [self.globeVC clearAnnotations];
    [self.globeVC addAnnotation:annotation forPoint:selectedMarker.loc offset:CGPointZero];
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC didTapAt:(WGCoordinate)coord {
    [self.globeVC clearAnnotations];
}

- (void)showRouteOnMap {
    
    [self.globeVC removeObject:self.waypointsObj];
    self.waypointsObj = nil;
    
    [self.globeVC removeObject:self.routesObj];
    self.routesObj = nil;
    
    self.globeVC.keepNorthUp = YES;
    objWPT *orig = [[User sharedUser].arrayEnRouteWaypoints firstObject];
    
    [self.globeVC setPosition:MaplyCoordinateMakeWithDegrees([orig.strLon floatValue], [orig.strLat floatValue])];
    [self.globeVC setHeight:2.25];
    self.globeVC.keepNorthUp = NO;
    
    CGSize size = CGSizeMake(12, 12);
    
    NSMutableArray *markers = [[NSMutableArray alloc] init];
    
    MaplyCoordinate coords[[User sharedUser].arrayEnRouteWaypoints.count];
    
    for (objWPT *wpt in [User sharedUser].arrayEnRouteWaypoints) {
        NSLog(@"$$$ %@ %f %@", wpt.strWptName, [self coordFromString:wpt.strLon], wpt.strLon);
        if ([wpt.strType isEqualToString:@"Airport"]) {
            NSLog(@"--> %f", [wpt.strLon floatValue]);
        }
        NSInteger index = [[User sharedUser].arrayEnRouteWaypoints indexOfObject:wpt];
        
        MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
        marker.size = size;
        if ([wpt.strMORA floatValue] > 100) {
            marker.image = [UIImage imageNamed:@"WaypointHT"];
        }
        else {
            marker.image = [UIImage imageNamed:@"WaypointLT"];
        }
        
        if ([wpt.strType isEqualToString:@"Airport"]) {
            objWPT *orig = [[User sharedUser].arrayEnRouteWaypoints firstObject];
            objWPT *dest = [[User sharedUser].arrayEnRouteWaypoints lastObject];
            
            if ([wpt.strWptName isEqualToString:orig.strWptName] || [wpt.strWptName isEqualToString:dest.strWptName]) {
                marker.image = [UIImage imageNamed:@"AirportO_25"];
            }
            marker.loc = MaplyCoordinateMakeWithDegrees([wpt.strLon floatValue], [wpt.strLat floatValue]);
            marker.size = CGSizeMake(20, 20);

        }
        else {
            marker.loc = MaplyCoordinateMakeWithDegrees([self coordFromString:wpt.strLon], [self coordFromString:wpt.strLat]);
        }
        
        coords[index] = marker.loc;
        
        marker.userObject = wpt;
        marker.layoutImportance = MAXFLOAT;
        [markers addObject:marker];
    }
    
    self.waypointsObj = [self.globeVC addScreenMarkers:markers desc:nil];
    
    MaplyVectorObject *vectorObj = [[MaplyVectorObject alloc] initWithLineString:coords numCoords:(int)[User sharedUser].arrayEnRouteWaypoints.count attributes:nil];
    NSMutableArray *vectors = [[NSMutableArray alloc] init];
    [vectors addObject:vectorObj];
    NSDictionary *desc = @{kMaplyColor: [UIColor blueColor], kMaplySubdivType: kMaplySubdivStatic, kMaplySubdivEpsilon: @(0.001), kMaplyVecWidth: @(4)};
    self.routesObj = [self.globeVC addVectors:vectors desc:desc];
    
    [self showGreatCircle];
}

- (void)showGreatCircle {
    
    [self.globeVC removeObject:self.greatCircleObj];
    self.greatCircleObj = nil;
    
    MaplyShapeGreatCircle *greatCircle = [[MaplyShapeGreatCircle alloc] init];
    objWPT *departure = [[User sharedUser].arrayEnRouteWaypoints firstObject];
    objWPT *destination = [[User sharedUser].arrayEnRouteWaypoints  lastObject];
    greatCircle.startPt = MaplyCoordinateMakeWithDegrees([departure.strLon floatValue], [departure.strLat floatValue]);
    greatCircle.endPt = MaplyCoordinateMakeWithDegrees([destination.strLon floatValue], [destination.strLat floatValue]);
    
    greatCircle.lineWidth = 2;
    float angle = [greatCircle calcAngleBetween];
    greatCircle.height = 0.15 * angle / M_PI;
    greatCircle.color = [UIColor magentaColor];
    
    self.greatCircleObj = [self.globeVC addShapes:@[greatCircle] desc:nil];
}

- (CGFloat)coordFromString:(NSString *)coordString {
    if ([[coordString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"N"]) {
        coordString = [coordString substringWithRange:NSMakeRange(1, 4)];
        NSMutableString *string = [NSMutableString stringWithString:coordString];
        [string insertString:@"." atIndex:2];
        return [string floatValue];
    }
    else if ([[coordString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
        coordString = [@"-" stringByAppendingString:[coordString substringWithRange:NSMakeRange(1, 4)]];
        NSMutableString *string = [NSMutableString stringWithString:coordString];
        [string insertString:@"." atIndex:2];
        return [string floatValue];
    }
    else if ([[coordString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"W"]) {
        coordString = [@"-" stringByAppendingString:[coordString substringWithRange:NSMakeRange(1, 4)]];
        NSMutableString *string = [NSMutableString stringWithString:coordString];
        [string insertString:@"." atIndex:4];
        return [string floatValue];
    }
    else if ([[coordString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"E"]) {
        if ([[coordString substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
            coordString = [coordString substringWithRange:NSMakeRange(2, 4)];
            NSMutableString *string = [NSMutableString stringWithString:coordString];
            [string insertString:@"." atIndex:2];
            return [string floatValue];
        }
        else {
            coordString = [coordString substringWithRange:NSMakeRange(1, 5)];
            NSMutableString *string = [NSMutableString stringWithString:coordString];
            [string insertString:@"." atIndex:3];
            return [string floatValue];
        }
    }
    
    return 0;
}

-(void) readOFP
{
    [self readtxtFile];
}

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
            
            if (fltpln == YES && [line containsString:@")"]) {
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
        // NSLog(@"read line: %@", line);
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
    bool bolSunrise;
    bolSunrise =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"ReadSunrise"] boolValue];
    
    if(bolSunrise == YES)
        
    {
        [StartTableViewController calculateSunriseSunset];
    }
    // get escaperoutes for waypoints
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
    [SVProgressHUD dismiss];
    
    
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

-(void)selectedWaypoint:(NSString *)selctedWaypoint
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", selctedWaypoint];
    NSArray *result = [[User sharedUser].arrayEnRouteWaypoints filteredArrayUsingPredicate: predicate];
    if ([result count] != 0) {
        NSUInteger indexOfTheObject = [[User sharedUser].arrayEnRouteWaypoints indexOfObject:result.firstObject];
        objLogWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:indexOfTheObject];
        if ([objLogWpt.strLat isEqualToString:@""]) {
            
        }else{
            if ([objLogWpt.strLat containsString:@"."]) { /////// Departure and Destination Airport
                
            } else {
                if ([[objLogWpt.strLat substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"S"]) {
                    objLogWpt.strLat = [@"-" stringByAppendingString:[objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)]];
                    NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLat];
                    [string1 insertString: @"." atIndex: 3];
                    objLogWpt.strLat = string1;
                }else{
                    objLogWpt.strLat = [objLogWpt.strLat substringWithRange:NSMakeRange(1, 4)];
                    NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLat];
                    [string1 insertString: @"." atIndex: 2];
                    objLogWpt.strLat = string1;
                }
                if ([[objLogWpt.strLon substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"W"]) {
                    objLogWpt.strLon = [@"-" stringByAppendingString:[objLogWpt.strLon substringWithRange:NSMakeRange(1, 4)]];
                    NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLon];
                    [string1 insertString: @"." atIndex: 4];
                    objLogWpt.strLon = string1;
                }else{
                    if ([[objLogWpt.strLon substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                        objLogWpt.strLon = [objLogWpt.strLon substringWithRange:NSMakeRange(2, 4)];
                        NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLon];
                        [string1 insertString: @"." atIndex: 2];
                        objLogWpt.strLon = string1;
                    }else{
                        objLogWpt.strLon = [objLogWpt.strLon substringWithRange:NSMakeRange(1, 5)];
                        NSMutableString *string1 = [NSMutableString stringWithString:objLogWpt.strLon];
                        [string1 insertString: @"." atIndex: 3];
                        objLogWpt.strLon = string1;
                    }
                }
            }
            //        CLLocationDegrees latitude  = [objLogWpt.strLat doubleValue];
            //        CLLocationDegrees longitude = [objLogWpt.strLon doubleValue];
            //        // create our coordinate and add it to the correct spot in the array
            //        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            [User sharedUser].dblLatitudeMapCenter = [objLogWpt.strLat doubleValue];
            [User sharedUser].dblLongitudeMapCenter = [objLogWpt.strLon doubleValue];
            
            // [self zoomInOnWaypoint];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
