//
//  objLog.m
//  RIM
//
//  Created by Mikel on 11.07.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "objLog.h"

@implementation objLog
@synthesize strLat;
@synthesize strLon;
@synthesize strWptName;
@synthesize strWptAirway;
@synthesize strType;
@synthesize strAlternates;
@synthesize strPage;
@synthesize strChapter;
@synthesize strMORA;
@synthesize strFL;
@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize strCET;
@synthesize strEET;
@synthesize strDTW;
@synthesize strITT;
@synthesize strTAS;
@synthesize intID;
- (MKMapItem*)mapItem {
    MKMapItem *mapItem = [[MKMapItem alloc]init];
    mapItem.name = self.title;
    
    return mapItem;
}
@end
