//
//  objLog.h
//  RIM
//
//  Created by Mikel on 11.07.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface objLog : NSObject <MKAnnotation>
@property (nonatomic, retain) NSString * strWptName;
@property (nonatomic, retain) NSString * strWptAirway;
@property (nonatomic, retain) NSString * strLat;
@property (nonatomic, retain) NSString * strLon;
@property (nonatomic, retain) NSString * strType;
@property (nonatomic, retain) NSString * strAlternates;
@property (nonatomic, retain) NSString * strPage;
@property (nonatomic, retain) NSString * strChapter;
@property (nonatomic, retain) NSString * strMORA;
@property (nonatomic, retain) NSString * strFL;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, retain) NSString * strITT;
@property (nonatomic, retain) NSString * strDTW;
@property (nonatomic, retain) NSString * strCET;
@property (nonatomic, retain) NSString * strTAS;
@property (nonatomic, retain) NSString * strSR;
@property (nonatomic, retain) NSString * strEET;
@property (nonatomic) NSInteger intID;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


- (MKMapItem*)mapItem;
@end
