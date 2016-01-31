//
//  AnnotationAllCompanyAirports.m
//  RIM
//
//  Created by Michael Gehringer on 1/20/16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import "AnnotationAllCompanyAirports.h"

@implementation AnnotationAllCompanyAirports

- (MKMapItem*)mapItem {
    MKMapItem *mapItem = [[MKMapItem alloc]init];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
