//
//  OFPlistTableViewController.m
//  RIM
//
//  Created by Mikel on 15.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "OFPlistTableViewController.h"


@interface OFPlistTableViewController ()
{
    NSURL *fileURL;
    BOOL fltpln;
    BOOL bolWeather;
    BOOL bolWpt;
    BOOL bolLog;
    NSMutableString *strFltpln;
    objWPT *objEnRouteWpt;
    objLog *objLogWpt;
    EscapeWaypoint *WPTescape;
}
@property(nonatomic) NSURL *fileURL;
@end

@implementation OFPlistTableViewController
{
    ReaderViewController *readerViewController;
}
@synthesize fileURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];
    self.tableView.rowHeight = 70;
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];

    [[User sharedUser].arrayEnRouteWaypoints removeAllObjects];
    [[User sharedUser].arrayLog removeAllObjects];
    convertPDF([User sharedUser].strPathOFP);
    [self readtxtFile];
    
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

-(void) readtxtFile
{
    
    fltpln = NO;
    bolWeather = NO;
    bolWpt = NO;
    bolLog = NO;
    strFltpln = [NSMutableString stringWithString:@""];
    [User sharedUser].strAircraft = @"Widebody";
    NSString *path = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"output.txt"]encoding:NSUTF8StringEncoding error:nil];
    fileURL = [NSURL fileURLWithPath:path];
    OFPreadObject * reader = [[OFPreadObject alloc] initWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"output.txt"]];
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        
        if ([line isEqualToString:@"\r\n"] || [line containsString:@"NIL"]) {
            
        } else {
            if (fltpln == YES && [line containsString:@")"]) {
                fltpln = NO;
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                [strFltpln appendString:@"\n"];
                //                NSLog(@"read line: %@", line);
            }
            if (fltpln == YES) {
                [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
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
                    [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                    [strFltpln appendString:@"\n"];
                    //                    NSLog(@"read line: %@", line);
                }
            }
            if ([line containsString:@"Destination:"]) {
                bolWeather = YES;
            }
            //////// Weather Waypoints
            if (bolWpt == YES && [line containsString:@"[ ATC Flight Plan ]"]) {
                bolWpt = NO;
                
            }
            
            if (bolWpt == YES) {
                if ([line containsString:@"ETD"] || [line containsString:@"Page"] || [line containsString:@"EY"]){
                }else{
                    [strFltpln appendString:[NSString stringWithFormat:@"%@", line]];
                    [strFltpln appendString:@"\n"];
                    //                NSLog(@"read line: %@", line);
                    if ([[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"N"] || [[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"S"]) {
                        objEnRouteWpt = [[objWPT alloc]init];
                        objEnRouteWpt.strLat = [line substringWithRange:NSMakeRange(0, 5)];
                        objEnRouteWpt.strWptName = [[line substringWithRange:NSMakeRange(6, 10)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                           withString:@""];
                    }
                    if ([[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"E"] || [[line substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"W"]) {
                        objEnRouteWpt.strLon = [line substringWithRange:NSMakeRange(0, 6)];
                        [[User sharedUser].arrayEnRouteWaypoints addObject:objEnRouteWpt];
                    }
                }
            }
            if (bolWpt == NO && [line containsString:@"LONG"] && [line containsString:@"POINT"] && [line containsString:@"SR/TROP/OAT"]) {
                bolWpt = YES;
            }
            if (bolLog == YES && [line containsString:@"[ ATC Flight Plan ]"]) {
                bolLog = NO;
            }
            /////////////////// Reading the Log
            
            if (bolLog == YES) {
                if ([line containsString:@"|AWY"] || [line containsString:@"|WPT"]) {
                }else{
                    if ([line containsString:@"-"]) {
                        
                    } else{
                        if ([line containsString:@"_"]) {
                            objLogWpt = [[objLog alloc]init];
                            NSRange range = [line rangeOfString:@"|"];
                            objLogWpt.strWptAirway = [[line substringWithRange:NSMakeRange(range.location + 1, 7)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                             withString:@""];
                            objLogWpt.strLat = @"";
                            objLogWpt.strLon = @"";
                        }else{
                            if ([line containsString:@"|"]) {
                                if ([line containsString:@"FIR"] || [line containsString:@"UIR"]) {
                                }else {
                                    NSRange range = [line rangeOfString:@"|"];
                                    objLogWpt.strWptName = [[line substringWithRange:NSMakeRange(range.location + 1, 5)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                               withString:@""];
                                    [self searchEscapereoutes];
                                    [[User sharedUser].arrayLog addObject:objLogWpt];
                                    if ([[User sharedUser].arrayLog count]==1) {
                                        [User sharedUser].strDeparture = objLogWpt.strWptName;
                                        if ([[User sharedUser].strDeparture isEqualToString:@"OMAA"]) {
                                            [User sharedUser].strDirection = @"OUTBOUND";
                                        }else{
                                            [User sharedUser].strDirection = @"INBOUND";
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
        }
        NSLog(@"read line: %@", line);
    }];
    
    int i;
    for (i = 0; i < [[User sharedUser].arrayEnRouteWaypoints count]; i++) {
        objEnRouteWpt = [[User sharedUser].arrayEnRouteWaypoints objectAtIndex:i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strWptName ==  %@", objEnRouteWpt.strWptName];
        NSArray *result = [[User sharedUser].arrayLog filteredArrayUsingPredicate: predicate];
        NSUInteger indexOfTheObject = [[User sharedUser].arrayLog indexOfObject:result.firstObject];
        if ([result count] == 0) {
            
        }else{
        
        objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexOfTheObject];
        objEnRouteWpt.strWptAirway = objLogWpt.strWptAirway;
        objLogWpt.strLat = objEnRouteWpt.strLat;
        objLogWpt.strLon = objEnRouteWpt.strLon;
//        [self searchEscapereoutes];
        }
    }
    NSError *error;
    NSString *outputFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"fltpln.txt"];
    [strFltpln writeToFile:outputFileName atomically:YES
                  encoding:NSUTF8StringEncoding error:&error];
}

- (void) searchEscapereoutes
{
    NSArray *arrEntitiesWideOutbound = [[NSArray alloc] initWithObjects:@"EscapeWideOutboundEurope",@"EscapeWideOutboundMiddleEast",@"EscapeWideOutboundIran",@"EscapeWideOutboundSEAsia",@"EscapeWideOutboundChina",@"EscapeWideOutboundAfricaUSA", nil] ;
//    NSArray *arrEntitiesWideInbound = [[NSArray alloc] initWithObjects:@"EscapeWideInboundEurope",@"EscapeWideInboundMiddleEast",@"EscapeWideInboundIran",@"EscapeWideInboundAfricaUSA",@"EscapeWideInboundSEAsia",@"EscapeWideInboundChina",nil];
//    NSArray *arrEntitiesNarrowInbound = [[NSArray alloc] initWithObjects:@"EscapeNarrowInboundEurope",@"EscapeNarrowInboundMiddleEast",@"EscapeNarrowInboundIran",@"EscapeNarrowInboundAfricaUSA",@"EscapeNarrowInboundChina",nil];
//    NSArray *arrEntitiesNarrowOutbound = [[NSArray alloc] initWithObjects:@"EscapeNarrowOutboundEurope",@"EscapeNarrowOutboundMiddleEast",@"EscapeNarrowOutboundIran",@"EscapeNarrowOutboundAfricaUSA",@"EscapeNarrowOutboundChina",nil];
    objLogWpt.strType = @"";
    int i;
    for (i = 0; i < [arrEntitiesWideOutbound count]; i++) {
    
    if (self.managedObjectContext)
    {
        [self.managedObjectContext performBlockAndWait:^{
            [self.managedObjectContext reset];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [NSFetchedResultsController deleteCacheWithName:@"Escape"];
            NSEntityDescription *entity = [NSEntityDescription entityForName:[arrEntitiesWideOutbound objectAtIndex:i] inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"wptname = %@", objLogWpt.strWptName];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"airways contains[c] %@", objLogWpt.strWptAirway];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
            [fetchRequest setPredicate:predicate];
            NSInteger intRecordsCount;
            NSError *error = nil;
            [fetchRequest setFetchLimit:1000];
            intRecordsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
            if (intRecordsCount == 1) {
                NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
                Escape *escapewpt = nil;
                escapewpt = [results objectAtIndex:0];
                objLogWpt.strType = @"Escape";
                objLogWpt.strPage = escapewpt.page;
                objLogWpt.strChapter = escapewpt.chapter;
            }

        }];
    }
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
    cell.lblnamewpt.text = objLogWpt.strWptName;
    cell.lblAirways.text = objLogWpt.strWptAirway;
    cell.lblLat.text = objLogWpt.strLat;
    cell.lblLon.text = objLogWpt.strLon;
    if ([objLogWpt.strType isEqualToString:@"Escape"]) {
        cell.imgViewLog.image = [UIImage imageNamed:@"earth_element-red-32.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.lblPage.text = [[objLogWpt.strPage stringByAppendingString:@" / "]stringByAppendingString:objLogWpt.strChapter];
    }else{
        cell.imgViewLog.image = [UIImage imageNamed:@"earth_element-green-32.png"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.lblPage.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Escape *escapewpt = [[User sharedUser].arrayLog objectAtIndex:indexPath.row];
    
    objLogWpt = [[objLog alloc] init];
    objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexPath.row];
    NSString *strPathDir = [[[@"/EscapeRoutes/" stringByAppendingString:[User sharedUser].strAircraft] stringByAppendingString:@"/"]stringByAppendingString:objLogWpt.strChapter];
    strPathDir = [[strPathDir stringByAppendingString:@"/"] stringByAppendingString:[User sharedUser].strDirection];
    NSString *strPath = [[NSBundle mainBundle] pathForResource:[[[strPathDir stringByAppendingString:@"/"]stringByAppendingString:objLogWpt.strChapter] stringByAppendingString:objLogWpt.strPage] ofType:@"pdf"];
    [User sharedUser].bolPreviewWPT = YES;
    [User sharedUser].bolWPT = YES;
    [User sharedUser].strWptTitle = objLogWpt.strWptName;
    [User sharedUser].strPathDocuments = strPath;
    readerViewController = [[ReaderViewController alloc] initWithNibName:nil bundle:nil]; // Demo controller
    [readerViewController setEscape:escapewpt];
    //    [readerViewController setAirport:ai];
    [[self navigationController] pushViewController:readerViewController animated:NO];
}
@end
