//
//  CSDKAdmrRequest.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/27/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "CSDKAdmrRequest.h"
#import "CSDKHTTPClient.h"
#import "DataModels.h"
#import <CoreLocation/CoreLocation.h>
#import "AppState.h"
#import <MapKit/MapKit.h>
#import "CSDKMapAnnotation.h"

NSString* const AdmrRequestNotificationName = @"kAdmrRequestComplete";

@implementation CSDKAdmrRequest

//to find in which ADMR is located a certain node. It should combine the NodesRequest (with nodes within few meters) and then ask for a SelectRequest with /nodeID/select/regions to get the regions in which the node is located, and thus also the current user

- (NSString*)baseUrlForRequest
{
    if(_admr){
        return [NSString stringWithFormat:@"%@/?", _admr];
    }
    else{
        return @"?";
    }
    
}

- (NSDictionary*)requestParamsForRequest
{
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init]; //WithObjectsAndKeys:

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

+ (CSDKAdmrRequest*)requestWithAdmr:(NSString*)admr perPage:(int)perPage
{
    CSDKAdmrRequest *r = [[CSDKAdmrRequest alloc] init];
    r.admr = admr;
    r.per_page = perPage;

    return r;
}

-(void)executeAndProcessRequestWithQuery:(NSString*)query
{
    NSString *path = [self baseUrlForRequest];
    
    if(query)
    {
        path = query;
    }
    
    [[CSDKHTTPClient sharedClient] getPath:path parameters:[self requestParamsForRequest] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *r = [parser objectWithData:responseObject];
        
        __block NSMutableArray *allCoordinates = [[NSMutableArray alloc] init];
        __block NSMutableArray *annotations = [[NSMutableArray alloc] init];
        __block NSMutableArray *polylines = [[NSMutableArray alloc] init];
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        
        
        
        //get JSON stuff
        CSDKresponse *response = [CSDKresponse modelObjectWithDictionary:r];
        if ([response.status isEqualToString:@"success"]) {
            
            //let's see each result from CitySDK
            [response.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CSDKResults *r = ((CSDKResults*)obj);
                
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
                            [polylines addObject:pl];
                            free(coordinateArray);
                        }
                        [results addObject:r];
                    }
                    //Annotation in the first coordinate of the Polyline
                    CLLocationCoordinate2D *c = malloc(sizeof(CLLocationCoordinate2D));
                    [[polylines lastObject] getCoordinates:c range:NSMakeRange(0, 1)];
                    CSDKMapAnnotation *annotation = [[CSDKMapAnnotation alloc] initWithTitle:r.name subtitle:r.cdkId coordinate:CLLocationCoordinate2DMake(c->latitude, c->longitude)];
                    [annotations addObject:annotation];
                    free(c);
                }
                
            }];
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:polylines, @"result", allCoordinates, @"allCoordinates", annotations, @"annotations", results, @"CSDKResults", nil];
            //using this I got the allCoordinates nil-ed
            //  @{@"result": result,
            //                                       @"allCoordinates,": allCoordinates,
            //                                       @"annotations": annotations,
            //                                       };
            
            NSNotification *resultNotification = [NSNotification notificationWithName:AdmrRequestNotificationName object:self userInfo:userInfo];
            [[NSNotificationCenter defaultCenter] postNotification:resultNotification];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *userInfo = @{
                                   @"resultError": error
                                   };
        
        NSNotification *resultNotification = [NSNotification notificationWithName:AdmrRequestNotificationName object:self userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:resultNotification];
        
    }];
    
    
}

- (void)executeAndProcessRequest
{
    [self executeAndProcessRequestWithQuery:nil];
    
}


@end
