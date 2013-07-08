//
//  CSDKHTTPClient.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/2/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPClient.h"


@interface CSDKHTTPClient : AFHTTPClient

+ (CSDKHTTPClient *)sharedClient;


@end
