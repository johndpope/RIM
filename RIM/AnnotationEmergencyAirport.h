//
//  AnnotationEmergencyAirport.h
//  RIM
//
//  Created by Mikel on 22.01.16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationEmergencyAirport : NSObject   <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * strType;
@property (nonatomic, copy) NSString * strFunction;


@end
