//
//  OFPViewController.m
//  RIM
//
//  Created by Mikel on 10.07.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "OFPViewController.h"

@interface OFPViewController ()
{
     NSURL *fileURL;
    BOOL fltpln;
    BOOL bolWeather;
    BOOL bolWpt;
    BOOL bolLog;
    NSMutableString *strFltpln;
    objWPT *objEnRouteWpt;
    objLog *objLogWpt;
}
@property(nonatomic) NSURL *fileURL;
@end

@implementation OFPViewController
@synthesize fileURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[User sharedUser].arrayEnRouteWaypoints removeAllObjects];
    [[User sharedUser].arrayLog removeAllObjects];
    convertPDF([User sharedUser].strPathOFP);
    [self readtxtFile];
    NSString *myText = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"fltpln.txt"] encoding:NSUTF8StringEncoding error:nil];
    self.myTextView.text  = myText;
    // Do any additional setup after loading the view.
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
    NSString *path = [NSString stringWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"output.txt"]encoding:NSUTF8StringEncoding error:nil];
    fileURL = [NSURL fileURLWithPath:path];
    OFPreadObject * reader = [[OFPreadObject alloc] initWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"output.txt"]];
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        
        if ([line isEqualToString:@"\r\n"]) {
            
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
                if ([line containsString:@"ETD"] || [line containsString:@"Page"]){
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
            if (bolWpt == NO && [line containsString:@"LONG"] && [line containsString:@"POINT"]) {
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
                                
                            }else{
                                if ([line containsString:@"|"]) {
                                    if ([line containsString:@"FIR"] || [line containsString:@"UIR"]) {
                                    }else {
                                    NSRange range = [line rangeOfString:@"|"];
                                    objLogWpt.strWptName = [[line substringWithRange:NSMakeRange(range.location + 1, 5)] stringByReplacingOccurrencesOfString:@" "
                                                                                                                                                   withString:@""];
                                    [[User sharedUser].arrayLog addObject:objLogWpt];
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
    objLogWpt = [[User sharedUser].arrayLog objectAtIndex:indexOfTheObject];
    objEnRouteWpt.strWptAirway = objLogWpt.strWptAirway;
    objLogWpt.strLat = objEnRouteWpt.strLat;
    objLogWpt.strLon = objEnRouteWpt.strLon;
    }
    NSError *error;
    NSString *outputFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"fltpln.txt"];
    [strFltpln writeToFile:outputFileName atomically:YES
                    encoding:NSUTF8StringEncoding error:&error];
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
