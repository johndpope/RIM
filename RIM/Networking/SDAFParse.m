//
//  SDAFParse.m
//  RIM
//
//  Created by Jerald Abille on 2/14/16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import "SDAFParse.h"

static NSString * const kSDFParseAPIBaseURLString = @"https://api.parse.com/1/";
static NSString * const kSDFParseAPIApplicationId = @"GYBg21cT9XDB7o9EbnFJgXoJq3N7MDvYJoOfSgBV";
static NSString * const kSDFParseAPIKey = @"vvn83BGb4ZfoaUgrzjLElY26HVnsQzNbvzOzKvUw";

@implementation SDAFParse

+ (instancetype)sharedClient {
    static SDAFParse *sharedClient = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[SDAFParse alloc] initWithBaseURL:[NSURL URLWithString:kSDFParseAPIBaseURLString] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        // [self.requestSerializer setValue:kSDFParseAPIApplicationId forKey:@"X-Parse-Application-Id"];
        // [self.requestSerializer setValue:kSDFParseAPIKey forKey:@"X-Parse-REST-API-Key"];
        
    }
    
    return self;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSString *urlString = [[kSDFParseAPIBaseURLString stringByAppendingPathComponent:@"classes"] stringByAppendingPathComponent:className];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setValue:kSDFParseAPIApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:kSDFParseAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSError *error;
    if (parameters) {
        NSData *params = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        [request setHTTPBody:params];
    }
    
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSString *urlString = [[kSDFParseAPIBaseURLString stringByAppendingPathComponent:@"classes"] stringByAppendingPathComponent:className];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setValue:kSDFParseAPIApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:kSDFParseAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSDictionary *parameters;
    
    if (updatedDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSString *jsonString = [NSString stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}", [formatter stringFromDate:updatedDate]];
        parameters = @{@"where" : jsonString, @"limit" : @(50)};
    }
    
    request = [self GETRequestForClass:className parameters:parameters];
    
    return request;
}

- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSString *urlString = [[kSDFParseAPIBaseURLString stringByAppendingPathComponent:@"classes"] stringByAppendingPathComponent:className];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setValue:kSDFParseAPIApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:kSDFParseAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    [request setHTTPMethod:@"POST"];
    NSData *dataParam = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    [request setHTTPBody:dataParam];
    
    NSLog(@"POSTRequestForClass %@", [request URL]);
    
    return request;
}

- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId {
    NSString *urlString = [[kSDFParseAPIBaseURLString stringByAppendingPathComponent:@"classes"] stringByAppendingPathComponent:className];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[urlString stringByAppendingPathComponent:className] stringByAppendingPathComponent:objectId]]];
    [request setValue:kSDFParseAPIApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:kSDFParseAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [request setHTTPMethod:@"DELETE"];
    NSLog(@"DELETERequestForClass %@", [request URL]);
    
    return request;
}


@end
