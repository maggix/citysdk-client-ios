//
//  CSDKRequest.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/2/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "CSDKNodesRequest.h"

@implementation CSDKNodesRequest

- (id)init
{
    self = [super init];
    if (self) {
        [CSDKNodesRequest initCSDKLayerKeys];
    }
    return self;
}

+ (void)initCSDKLayerKeys
{
    if(CSDKLayersKeys == nil)
    {
        CSDKLayersKeys = @[@"layer", @"osm::railway", @"osm::tourism"];
    }
}

+ (CSDKNodesRequest*)requestWithAdmr:(NSString*)admr layerKey:(NSString*)layerKey layerValue:(NSString*)layerValue latitude:(double)latitude longitude:(double)longitude perPage:(int)perPage radius:(int)radius
{
    CSDKNodesRequest *r = [[CSDKNodesRequest alloc] init];
    r.admr = admr;
    r.layerKey = layerKey;
    r.layerValue = layerValue;
    r.latitude = latitude;
    r.longitude = longitude;
    r.per_page = perPage;
    r.radius = radius;
    return r;
}

+ (CSDKNodesRequest*)requestWithAdmr:(NSString*)admr layerKey:(NSString*)layerKey layerValue:(NSString*)layerValue perPage:(int)perPage
{
    CSDKNodesRequest *r = [[CSDKNodesRequest alloc] init];
    r.admr = admr;
    r.layerKey = layerKey;
    r.layerValue = layerValue;
    r.per_page = perPage;
    return r;
}

+ (CSDKNodesRequest*)requestWithAdmr:(NSString*)admr layerKey:(NSString*)layerKey layerValue:(NSString*)layerValue name:(NSString*)name latitude:(double)latitude longitude:(double)longitude perPage:(int)perPage radius:(int)radius
{
    CSDKNodesRequest *r = [[CSDKNodesRequest alloc] init];
    r.admr = admr;
    r.layerKey = layerKey;
    r.layerValue = layerValue;
    r.name = name;
    r.latitude = latitude;
    r.longitude = longitude;
    r.per_page = perPage;
    r.radius = radius;
    return r;
}



- (NSDictionary*)requestParamsForRequest
{
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init]; //WithObjectsAndKeys:
    if(_layerValue != nil && _layerKey != nil){
        [returnDict setObject:_layerValue forKey:_layerKey];
    }
    if(_name){
        [returnDict setObject:_name forKey:@"name"];
    }
    if(_latitude && _longitude){
        [returnDict setObject:[NSNumber numberWithDouble:_latitude] forKey:@"lat"];
        [returnDict setObject:[NSNumber numberWithDouble:_longitude] forKey:@"lon"];
    }
    if (_radius) {
        [returnDict setObject:[NSNumber numberWithInt:_radius] forKey:@"radius"];
    }
    if(_per_page)
    {
        [returnDict setObject:[NSNumber numberWithInt:_per_page] forKey:@"per_page"];
    }
    [returnDict setObject:@"true" forKey:@"geom"];
//    _layerValue, _layerKey,
//    _latitude, @"lat",
//    _longitude, @"lon",
//    _radius, @"radius",
//    @"true", @"geom",
    
    return returnDict;
}

- (NSString*)baseUrlForRequest
{
    if(_admr){
        return [NSString stringWithFormat:@"%@/nodes?", _admr];
    }
    else{
        return @"nodes?";
    }
        
}



@end
