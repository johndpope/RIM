//
//  Country+Extensions.m
//  WorldFacts
//
//  Created by Keith Harrison http://useyourloaf.com
//  Copyright (c) 2012 Keith Harrison. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  Neither the name of Keith Harrison nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ''AS IS'' AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 


#import "Country+Extensions.h"

@implementation Country (Extensions)

+ (void)importDataToMoc:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Airport"
                                              inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSUInteger count = [moc countForFetchRequest:fetchRequest error:&error];
    
    if (count == 0)
    {
//        NSString* dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Airports.sqlite"];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"airports" ofType:@"plist"];
        NSArray *airports = [[NSArray alloc] initWithContentsOfFile:plistPath];
        for (NSDictionary *item in airports)
        {
            Country *airport = [NSEntityDescription insertNewObjectForEntityForName:@"Airport"
                                                             inManagedObjectContext:moc];
            
            airport.atis = [item valueForKey:@"ATIS"];
            airport.city = [item valueForKey:@"City"];
            airport.elevation = [NSNumber numberWithInteger:[[item valueForKey:@"Elevation"] integerValue]];
            airport.iataidentifier = [item valueForKey:@"IATAIdentifier"];
            airport.icaoidentifier = [item valueForKey:@"ICAOIdentifier"];
            airport.latitude = [NSNumber numberWithFloat:[[item valueForKey:@"Latitude"] floatValue]];
            airport.longitude = [NSNumber numberWithFloat:[[item valueForKey:@"Longitude"] floatValue]];
            airport.timezone = [item valueForKey:@"TimeZone"];
            airport.enoutealternate = [NSNumber numberWithInteger:[[item valueForKey:@"EnrouteAlternate"] integerValue]];
            airport.escaperoute = [NSNumber numberWithInteger:[[item valueForKey:@"EmerRoute"] integerValue]];
            airport.variation = [NSNumber numberWithFloat:[[item valueForKey:@"Variation"] floatValue]];
            airport.region = [item valueForKey:@"Region"];
//            airport.population = [NSNumber numberWithInteger:[[item valueForKey:@"population"] integerValue]];
            
        }
        
        if (![moc save:&error])
        {
            NSLog(@"failed to import data: %@", [error localizedDescription]);
        }
    }
}

- (NSString *)sectionTitle
{
    return [self.name substringToIndex:1];
}
@end
