//
//  CSDKResponse.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/9/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSDKResponse : NSObject

@property (nonatomic, strong) NSError *error;
//@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSArray *allCoordinates;

-(NSArray*)resultsToOverlays;


@end
