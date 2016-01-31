//
//  Airports.h
//  RIM
//
//  Created by Mikel on 19.04.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface AirportsEurope : NSManagedObject

@property (nonatomic, retain) NSString * iataidentifier;
@property (nonatomic, retain) NSString * icaoidentifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * chart;
@property (nonatomic) BOOL adequate;
@property (nonatomic) BOOL escaperoute;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString *cat32x;
@property (nonatomic, retain) NSString *cat332;
@property (nonatomic, retain) NSString *cat333;
@property (nonatomic, retain) NSString *cat345;
@property (nonatomic, retain) NSString *cat346;
@property (nonatomic, retain) NSString *cat350;
@property (nonatomic, retain) NSString *cat380;
@property (nonatomic, retain) NSString *cat777;
@property (nonatomic, retain) NSString *cat787;
@property (nonatomic, retain) NSString *city;
@property (nonatomic) BOOL cpldg;
@property (nonatomic) NSNumber *elevation;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic, retain) NSString *note32x;
@property (nonatomic, retain) NSString *note332;
@property (nonatomic, retain) NSString *note333;
@property (nonatomic, retain) NSString *note345;
@property (nonatomic, retain) NSString *note346;
@property (nonatomic, retain) NSString *note350;
@property (nonatomic, retain) NSString *note380;
@property (nonatomic, retain) NSString *note777;
@property (nonatomic, retain) NSString *note787;
@property (nonatomic, retain) NSString *peg;
@property (nonatomic, retain) NSString *region;
@property (nonatomic, retain) NSString *rff;
@property (nonatomic, retain) NSString *timezone;
@property (nonatomic) NSNumber *variation;
@property (nonatomic, retain) NSString *pegnotes;
@property (nonatomic, retain) NSString *rffnotes;
@property (nonatomic, retain) NSString *alternates;
@property (nonatomic, retain) NSString *cpldgnote;
@property (nonatomic, retain) NSString *country;

@end


