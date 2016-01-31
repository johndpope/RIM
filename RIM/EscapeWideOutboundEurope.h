//
//  Escape.h
//  RIM
//
//  Created by Mikel on 27.03.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EscapeWideOutboundEurope : NSManagedObject

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

@end
