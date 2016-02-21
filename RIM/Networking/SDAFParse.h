//
//  SDAFParse.h
//  RIM
//
//  Created by Jerald Abille on 2/14/16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface SDAFParse : AFHTTPSessionManager

+ (instancetype)sharedClient;
- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;
- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId;

@end
