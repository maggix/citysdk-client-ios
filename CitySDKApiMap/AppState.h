//
//  AppState.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/19/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppState : NSObject

+(AppState *)sharedInstance;

@property (nonatomic, assign) BOOL setting_cleanup_data;

- (BOOL)save;
- (void)restore;

@end
