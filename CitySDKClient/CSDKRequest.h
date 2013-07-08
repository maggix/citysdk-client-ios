//
//  CSDKRequest.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/2/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSArray *CSDKLayersKeys = nil;

@interface CSDKRequest : NSObject

//Some requests have "layer=..." others have "osm::tourism"
typedef NS_ENUM(NSUInteger, CSDKLayerKeys) {
    kCSDKGenericLayer = 0,
    kCSDKOSMLayerRailway = 1,
    kCSDKOSMLayerTourism = 2
    
};

typedef NS_ENUM(NSUInteger, CSDKLayerTypes)
{
    kCSDKOSMLayerRailwayStation = 1,
    kCSDKOSMLayerTourismMuseum = 2,
};

@property (nonatomic, strong) NSString *admr;
@property (nonatomic, strong) NSString *layerKey;
@property (nonatomic, strong) NSString *layerValue;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) int per_page;
@property (nonatomic, assign) int radius;
//@property (nonatomic, strong) NSString *geom;

+ (CSDKRequest*)requestWithAdmr:(NSString*)admr layerKey:(NSString*)layerKey layerValue:(NSString*)layerValue latitude:(double)latitude longitude:(double)longitude perPage:(int)perPage radius:(int)radius;

- (NSDictionary*)requestParamsForRequest;

- (NSString*)baseUrlForRequest;

@end
