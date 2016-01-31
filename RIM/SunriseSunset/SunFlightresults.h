//
//  SunFlightresults.h
//  FlySun
//
//  Created by Mikel on 18.12.13.
//  Copyright (c) 2013 Mikelsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunFlightresults : NSObject
{
}
@property (nonatomic, copy) NSString *strWptName;
@property (nonatomic, copy) NSString *strTime;
@property (nonatomic, copy) NSString *strTimeLCL;
@property (nonatomic, copy) NSString *strCount;
@property (nonatomic, copy) NSString *strLatitude;
@property (nonatomic, copy) NSString *strLongitude;
@property (nonatomic, copy) NSString *strFlightLevel;
@property (nonatomic, copy) NSString *strCET;
@property (nonatomic, copy) NSString *strType;

@property (nonatomic) double dblLatitude;
@property (nonatomic) double dblLongitude;
@property (nonatomic) NSInteger intTime;
@end
