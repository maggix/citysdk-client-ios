//
//  CSDKRequest.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/2/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "CSDKNodesRequest.h"
#import "CSDKHTTPClient.h"
#import "DataModels.h"
#import <CoreLocation/CoreLocation.h>
#import "AppState.h"
#import <MapKit/MapKit.h>
#import "CSDKMapAnnotation.h"

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


-(void)doAndProcessRequestWithParamsString:(NSString*)query
{
    NSString *path = [self baseUrlForRequest];

    if(query)
    {
        path = query;
    }
   
    [[CSDKHTTPClient sharedClient] getPath:path parameters:[self requestParamsForRequest] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"operation: %@", [operation description]);
        NSLog(@"operation: %@", [[operation request] URL]);
        __autoreleasing NSError* dataError = nil;
        NSDictionary *r = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&dataError];
        
        __block NSMutableArray *allCoordinates = [[NSMutableArray alloc] init];
        __block NSMutableArray *annotations = [[NSMutableArray alloc] init];
        __block NSMutableArray *result = [[NSMutableArray alloc] init];
        
        
        
        //get JSON stuff
        CSDKresponse *response = [CSDKresponse modelObjectWithDictionary:r];
        if ([response.status isEqualToString:@"success"]) {
            NSLog(@"Success!");
            
            //let's see each result from CitySDK
            [response.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CSDKResults *r = ((CSDKResults*)obj);
                
                if([[AppState sharedInstance] setting_cleanup_data])
                {
                    
                    if([[r name] isEqualToString:@""])
                    {
                        return ;
                    }
                    if([[[[[r dictionaryRepresentation] objectForKey:@"layers"] objectForKey:@"osm" ] objectForKey:@"data"] objectForKey:@"way_area"]  )
                    {
                        double wayarea =[[[[[[r dictionaryRepresentation] objectForKey:@"layers"] objectForKey:@"osm" ] objectForKey:@"data"] objectForKey:@"way_area"] doubleValue];
                        if(!(wayarea >0)){
                            return;
                        }
                    }
                }
                //If it's a Multipolygon type we need a polyline
                if( [r.geom.type isEqualToString:@"MultiPolygon"])
                {
                    //each one is a set of coordinates. For example the admr.nl.amsterdam is made of 3 different groups
                    for(NSArray *coordGrp in r.geom.coordinates){
                        //for each group I need to loop again
                        for (NSArray *polylineCoord in coordGrp) {
                            
                            int caIndex = 0;
                            NSInteger coordCount = [polylineCoord count];
                            CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);
                            
                            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                            [f setNumberStyle:NSNumberFormatterDecimalStyle];
                            for(NSArray *coord in polylineCoord){
                                double lon = [[[coord objectAtIndex:0] stringValue] floatValue];
                                double lat = [[[coord objectAtIndex:1] stringValue] floatValue];
                                
                                coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
                                [allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                                caIndex++;
                            }
                            
                            MKPolyline *pl = [MKPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                            [result addObject:pl];
                            free(coordinateArray);
                            
                        }
                    }
                    //Annotation in the first coordinate of the Polyline
                    CLLocationCoordinate2D *c = malloc(sizeof(CLLocationCoordinate2D));
                    [[result lastObject] getCoordinates:c range:NSMakeRange(0, 1)];
                    CSDKMapAnnotation *annotation = [[CSDKMapAnnotation alloc] initWithTitle:r.name subtitle:r.cdkId coordinate:CLLocationCoordinate2DMake(c->latitude, c->longitude)];
                    [annotations addObject:annotation];
                    free(c);
                }
                if ([r.geom.type isEqualToString:@"Point"]) {
                    //point
                    double lon = [[[r.geom.coordinates objectAtIndex:0] stringValue] doubleValue];
                    double lat = [[[r.geom.coordinates objectAtIndex:1] stringValue] doubleValue];
                    CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * 1);
                    coordinateArray[0] = CLLocationCoordinate2DMake(lat, lon);
                    MKPolyline *pl = [MKPolyline polylineWithCoordinates:coordinateArray count:1];
                    [result addObject:pl];
                    [allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                    free(coordinateArray);
                    
                    //Annotation
                    CLLocationCoordinate2D c;
                    c.latitude = lat;
                    c.longitude = lon;
                    CSDKMapAnnotation *annotation = [[CSDKMapAnnotation alloc] initWithTitle:r.name subtitle:r.cdkId coordinate:c];
                    [annotations addObject:annotation];
                }
                
                if ([r.geom.type isEqualToString:@"Polygon"]) {
                    //each one is a set of coordinates.
                    for(NSArray *coordGrp in r.geom.coordinates){
                        int caIndex = 0;
                        NSInteger coordCount = [coordGrp count];
                        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);
                        
                        for(NSArray *coord in coordGrp){
                            
                            double lon = [[[coord objectAtIndex:0] stringValue] floatValue];
                            double lat = [[[coord objectAtIndex:1] stringValue] floatValue];
                            
                            coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
                            [allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                            caIndex++;
                        }
                        
                        MKPolyline *pl = [MKPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                        [result addObject:pl];
                        free(coordinateArray);
                    }
                    
                    //Annotation in the first coordinate of the Polyline
                    CLLocationCoordinate2D *c = malloc(sizeof(CLLocationCoordinate2D));
                    [[result lastObject] getCoordinates:c range:NSMakeRange(0, 1)];
                    CSDKMapAnnotation *annotation = [[CSDKMapAnnotation alloc] initWithTitle:r.name subtitle:r.cdkId coordinate:CLLocationCoordinate2DMake(c->latitude, c->longitude)];
                    [annotations addObject:annotation];
                    free(c);
                    
                }
                
                if ([r.geom.type isEqualToString:@"MultiLineString"]) {
                    //each one is a set of coordinate that define a line (not a polygon)
                    //it parses just as Polygon does
                    for(NSArray *coordGrp in r.geom.coordinates){
                        int caIndex = 0;
                        NSInteger coordCount = [coordGrp count];
                        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);
                        
                        for(NSArray *coord in coordGrp){
                            
                            double lon = [[[coord objectAtIndex:0] stringValue] floatValue];
                            double lat = [[[coord objectAtIndex:1] stringValue] floatValue];
                            
                            coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
                            [allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                            caIndex++;
                        }
                        
                        MKPolyline *pl = [MKPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                        [result addObject:pl];
                        free(coordinateArray);
                    }
                    //Annotation in the first coordinate of the Polyline
                    CLLocationCoordinate2D *c = malloc(sizeof(CLLocationCoordinate2D));
                    [[result lastObject] getCoordinates:c range:NSMakeRange(0, 1)];
                    CSDKMapAnnotation *annotation = [[CSDKMapAnnotation alloc] initWithTitle:r.name subtitle:r.cdkId coordinate:CLLocationCoordinate2DMake(c->latitude, c->longitude)];
                    [annotations addObject:annotation];
                    free(c);
                }
                if ([r.geom.type isEqualToString:@"LineString"]) {
                    //r.geom.coordinates is just an array of coordinates, so I iterate only 1 time
                    int caIndex = 0;
                    NSInteger coordCount = [r.geom.coordinates count];
                    CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);
                    
                    for(NSArray *coordGrp in r.geom.coordinates){
                        double lon = [[[coordGrp objectAtIndex:0] stringValue] floatValue];
                        double lat = [[[coordGrp objectAtIndex:1] stringValue] floatValue];
                        
                        coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
                        [allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                        caIndex++;
                    }
                    MKPolyline *pl = [MKPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                    [result addObject:pl];
                    free(coordinateArray);
                    
                    //Annotation in the first coordinate of the Polyline
                    CLLocationCoordinate2D *c = malloc(sizeof(CLLocationCoordinate2D));
                    [[result lastObject] getCoordinates:c range:NSMakeRange(0, 1)];
                    CSDKMapAnnotation *annotation = [[CSDKMapAnnotation alloc] initWithTitle:r.name subtitle:r.cdkId coordinate:CLLocationCoordinate2DMake(c->latitude, c->longitude)];
                    [annotations addObject:annotation];
                    free(c);
                }
                if ([r.geom.type isEqualToString:@"GeometryCollection"]) {
                    //This is a container for different types of geometries (can contain points, LineString, MultiLineString, Polygon, etc.
                    //TODO: still have to deal with it
                }
            }];
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:result, @"result", allCoordinates, @"allCoordinates", annotations, @"annotations", nil];
            //using this I got the allCoordinates nil-ed
            //  @{@"result": result,
            //                                       @"allCoordinates,": allCoordinates,
            //                                       @"annotations": annotations,
            //                                       };
            
            NSNotification *resultNotification = [NSNotification notificationWithName:@"kNodesRequestComplete" object:self userInfo:userInfo];
            [[NSNotificationCenter defaultCenter] postNotification:resultNotification];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",[error description] );
        
        NSDictionary *userInfo = @{
                                   @"resultError": error
                                   };
        
        NSNotification *resultNotification = [NSNotification notificationWithName:@"kNodesRequestComplete" object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:resultNotification];
        
    }];
    

}

- (void)doAndProcessRequest
{
    [self doAndProcessRequestWithParamsString:nil];
    
    
}


@end
