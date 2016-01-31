//
//  Escape+Extensions.m
//  RIM
//
//  Created by Mikel on 27.03.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "Escape+Extensions.h"

@implementation Escape (Extensions)

+ (void)importDataToMoc:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Escape"
                                              inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSUInteger count = [moc countForFetchRequest:fetchRequest error:&error];
    
    if (count == 0)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Escape" ofType:@"plist"];
        NSArray *escapes = [[NSArray alloc] initWithContentsOfFile:plistPath];
        for (NSDictionary *item in escapes)
        {
            Escape *escape = [NSEntityDescription insertNewObjectForEntityForName:@"Escape"
                                                             inManagedObjectContext:moc];
            
            escape.aircraft = [item valueForKey:@"Aircraft"];
            escape.latitude = [NSNumber numberWithFloat:[[item valueForKey:@"Latitude"] floatValue]];
            escape.longitude = [NSNumber numberWithFloat:[[item valueForKey:@"Longitude"] floatValue]];
            
            escape.chapter = [item valueForKey:@"Chapter"];
            escape.direction = [item valueForKey:@"Direction"];
            escape.page = [item valueForKey:@"Page"];
            escape.wptname = [item valueForKey:@"WPTName"];
            escape.wpttype = [item valueForKey:@"WPTType"];
            escape.region = [item valueForKey:@"Region"];
            escape.path = [item valueForKey:@"Path"];
            escape.alternates = [item valueForKey:@"Alternates"];
            escape.airways = [item valueForKey:@"Airways"];

        }
        
        if (![moc save:&error])
        {
            NSLog(@"failed to import data: %@", [error localizedDescription]);
        }
    }
}

- (NSString *)sectionTitle
{
    return [self.wptname substringToIndex:1];
}
@end
