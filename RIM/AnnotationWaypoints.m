//
//  AnnotationWaypoints.m
//  RIM
//
//  Created by Mikel on 24.07.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "AnnotationWaypoints.h"

@implementation AnnotationWaypoints
- (MKMapItem*)mapItem {
    MKMapItem *mapItem = [[MKMapItem alloc]init];
    mapItem.name = self.title;

    return mapItem;
}

@end
