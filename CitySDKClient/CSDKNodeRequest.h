//
//  CSDKNodeRequest.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/27/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const NodeRequestNotificationName;

@interface CSDKNodeRequest : NSObject

@property (nonatomic, strong) NSString *nodeName;  //e.g. n34050860

- (NSString*)baseUrlForRequest;
-(void)executeAndProcessRequestWithQuery:(NSString*)query;
-(void)executeAndProcessRequest;


@end
