//
//  AnnotationAllCompanyAirports.h
//  RIM
//
//  Created by Michael Gehringer on 1/20/16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationAllCompanyAirports : NSObject  <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * strType;

@end
