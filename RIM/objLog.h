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
@property (nonatomic, retain) NSString * strWptName; //Name of waypoint
@property (nonatomic, retain) NSString * strWptAirway; // Name of airway attached to waypoint
@property (nonatomic, retain) NSString * strLat;// latitude of wpt
@property (nonatomic, retain) NSString * strLon;// longitude of wpt
@property (nonatomic, retain) NSString * strType;// type e.g. waypoint, escape, airport etc ....
@property (nonatomic, retain) NSString * strAlternates; // alternates withing 420 nm
@property (nonatomic, retain) NSString * strPage; // reference to page in escape routes
@property (nonatomic, retain) NSString * strChapter; // reference to chapter in escape routes

@property (nonatomic, retain) NSString * strMORA; // highest altitude above terrain
@property (nonatomic, retain) NSString * strFL; // flightlevel at wpt
@property (nonatomic, copy) NSString * title; // title for annotation
@property (nonatomic, copy) NSString * subtitle; // subtitle for annotation
@property (nonatomic, retain) NSString * strITT;// initial true track
@property (nonatomic, retain) NSString * strDTW;// distance to waypoint
@property (nonatomic, retain) NSString * strCET;// cumulated elapsed time
@property (nonatomic, retain) NSString * strTAS;// trueairspeed
@property (nonatomic, retain) NSString * strSR;// shear factor
@property (nonatomic, retain) NSString * strEET;// estimated elapsed time
@property (nonatomic) NSInteger intID; // id to sort the waypoints

@property (nonatomic, assign) CLLocationCoordinate2D coordinate; // coordinates for mapkit


- (MKMapItem*)mapItem;
@end
