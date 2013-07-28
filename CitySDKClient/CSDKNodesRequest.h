//
//  CSDKRequest.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/2/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString* const NodesRequestNotificationName;

static NSArray *CSDKLayersKeys;

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

@interface CSDKNodesRequest : NSObject

//To request parameters
@property (nonatomic, strong) NSString *admr;
@property (nonatomic, strong) NSString *layerKey;
@property (nonatomic, strong) NSString *layerValue;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) int per_page;
@property (nonatomic, assign) int radius;

//For processing the request
@property (nonatomic, assign) BOOL cleanup_data;
@property (nonatomic, strong) NSArray *geomTypesFilter;

+ (CSDKNodesRequest*)requestWithAdmr:(NSString*)admr layerKey:(NSString*)layerKey layerValue:(NSString*)layerValue latitude:(double)latitude longitude:(double)longitude perPage:(int)perPage radius:(int)radius;

+ (CSDKNodesRequest*)requestWithAdmr:(NSString*)admr layerKey:(NSString*)layerKey layerValue:(NSString*)layerValue perPage:(int)perPage;

+ (CSDKNodesRequest*)requestWithAdmr:(NSString*)admr layerKey:(NSString*)layerKey layerValue:(NSString*)layerValue name:(NSString*)name latitude:(double)latitude longitude:(double)longitude perPage:(int)perPage radius:(int)radius;

- (NSDictionary*)requestParamsForRequest;

- (NSString*)baseUrlForRequest;

-(void)executeAndProcessRequestWithQuery:(NSString*)query;
- (void)executeAndProcessRequest;

@end
