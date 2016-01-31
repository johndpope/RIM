//
//  AnnotationEnrouteAirports.h
//  RIM
//
//  Created by Michael Gehringer on 7/26/15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationEnrouteAirports : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * strType;
@property (nonatomic, copy) NSString * strFunction;

@end