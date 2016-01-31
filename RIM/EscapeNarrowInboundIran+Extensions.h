//
//  Escape+Extensions.h
//  RIM
//
//  Created by Mikel on 27.03.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Escape.h"
#import "EscapeNarrowInboundIran.h"
#import "SDCoreDataController.h"

@interface EscapeNarrowInboundIran (Extensions)
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (void)importDataToMoc:(NSManagedObjectContext *)moc;
- (NSString *)sectionTitle;

@end
