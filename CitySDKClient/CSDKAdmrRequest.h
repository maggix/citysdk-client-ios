//
//  CSDKAdmrRequest.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/27/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const AdmrRequestNotificationName;

@interface CSDKAdmrRequest : NSObject

@property (nonatomic, strong) NSString *admr;
@property (nonatomic, assign) int per_page;

@property (nonatomic, assign) BOOL skipGeom;

- (NSDictionary*)requestParamsForRequest;

- (NSString*)baseUrlForRequest;

+ (CSDKAdmrRequest*)requestWithAdmr:(NSString*)admr perPage:(int)perPage;

-(void)executeAndProcessRequestWithQuery:(NSString*)query;
- (void)executeAndProcessRequest;

@end
