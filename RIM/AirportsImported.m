//
//  AirportsImported.m
//  RIM
//
//  Created by Mikel on 03.08.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "AirportsImported.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"

@implementation AirportsImported
@dynamic iataidentifier;
@dynamic icaoidentifier;
@dynamic name;
@dynamic updatedAt;
@dynamic createdAt;
@dynamic objectId;
@dynamic syncStatus;
@dynamic city;
@dynamic elevation;
@dynamic latitude;
@dynamic longitude;
@dynamic timezone;
@dynamic variation;
@dynamic country;
@dynamic date;
@dynamic adequate;
@dynamic escaperoute;
@dynamic chart;
@dynamic cat32x;
@dynamic cat332;
@dynamic cat333;
@dynamic cat345;
@dynamic cat346;
@dynamic cat350;
@dynamic cat380;
@dynamic cat777;
@dynamic cat787;
@dynamic cpldg;
@dynamic note32x;
@dynamic note332;
@dynamic note333;
@dynamic note345;
@dynamic note346;
@dynamic note350;
@dynamic note380;
@dynamic note777;
@dynamic note787;
@dynamic peg;
@dynamic region;
@dynamic rff;
@dynamic pegnotes;
@dynamic rffnotes;
@dynamic cpldgnote;
@dynamic alternates;

- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.name, @"name",
                                    self.iataidentifier, @"iataidentifier",
                                    self.icaoidentifier, @"icaoidentifier",
                                    self.city,@"city",
                                    self.elevation,@"elevation",
                                    self.latitude,@"latitude",
                                    self.longitude,@"longitude",
                                    self.timezone,@"timezone",
                                    self.variation,@"variation",
                                    self.country,@"country",
                                    self.adequate,@"",
                                    self.escaperoute,@"",
                                    self.chart,@"",
                                    self.cat32x,@"",
                                    self.cat332,@"",
                                    self.cat333,@"",
                                    self.cat345,@"",
                                    self.cat346,@"",
                                    self.cat346,@"",
                                    self.cat350,@"",
                                    self.cat380,@"",
                                    self.cat777,@"",
                                    self.cat787,@"",
                                    self.cpldg,@"",
                                    self.note32x,@"",
                                    self.note332,@"",
                                    self.note333,@"",
                                    self.note345,@"",
                                    self.note346,@"",
                                    self.note350,@"",
                                    self.note380,@"",
                                    self.note777,@"",
                                    self.note787,@"",
                                    self.peg,@"",
                                    self.region,@"",
                                    self.rff,@"",
                                    self.pegnotes,@"",
                                    self.rffnotes,@"",
                                    self.cpldgnote,@"",
                                    self.alternates,@"",
                                    date, @"date", nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:jsonDictionary
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if (!jsonData) {
        NSLog(@"Error creaing jsonData: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonDictionary;
}

@end
