//
//  AnnotationEnrouteAirports.m
//  RIM
//
//  Created by Michael Gehringer on 7/26/15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "AnnotationEnrouteAirports.h"

@implementation AnnotationEnrouteAirports
- (MKMapItem*)mapItem {
    MKMapItem *mapItem = [[MKMapItem alloc]init];
    mapItem.name = self.title;
    return mapItem;
}
@end