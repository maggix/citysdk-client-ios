//
//  CSDKSelectRequest.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/21/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const SelectRequestNotificationName;

@interface CSDKSelectRequest : NSObject

@property (nonatomic, strong) NSString *nodeName;  //e.g. n34050860
@property (nonatomic, strong) NSString *selectItem; //e.g. regions

@property (nonatomic, assign) BOOL skipGeom;

- (NSString*)baseUrlForRequest;
-(void)executeAndProcessRequestWithQuery:(NSString*)query;
-(void)executeAndProcessRequest;


@end
