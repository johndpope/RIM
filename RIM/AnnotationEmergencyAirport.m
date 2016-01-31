//
//  AnnotationEmergencyAirport.m
//  RIM
//
//  Created by Mikel on 22.01.16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import "AnnotationEmergencyAirport.h"

@implementation AnnotationEmergencyAirport

- (MKMapItem*)mapItem {
    MKMapItem *mapItem = [[MKMapItem alloc]init];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
