//
//  EscapeWaypoint.h
//  RIM
//
//  Created by Mikel on 02.05.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EscapeWaypoint : NSObject

@property (nonatomic, retain) NSString * aircraft;
@property (nonatomic, retain) NSString * chapter;
@property (nonatomic, retain) NSString * direction;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSString * page;
@property (nonatomic, retain) NSString * wptname;
@property (nonatomic, retain) NSString * wpttype;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * alternates;
@property (nonatomic, retain) NSString * airways;
@property (nonatomic, retain) NSData * chart;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * syncStatus;
@end
