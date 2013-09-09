//
//  CSDKGeom.m
//
//  Created by Giovanni Maggini on 6/26/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import "CSDKGeom.h"


@interface CSDKGeom ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CSDKGeom

@synthesize type = _type;
@synthesize coordinates = _coordinates;


+ (CSDKGeom *)modelObjectWithDictionary:(NSDictionary *)dict
{
    CSDKGeom *instance = [[CSDKGeom alloc] initWithDictionary:dict];
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.type = [self objectOrNilForKey:@"type" fromDictionary:dict];
            self.coordinates = [self objectOrNilForKey:@"coordinates" fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.type forKey:@"type"];
NSMutableArray *tempArrayForCoordinates = [NSMutableArray array];
    for (NSObject *subArrayObject in self.coordinates) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCoordinates addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCoordinates addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCoordinates] forKey:@"coordinates"];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.type = [aDecoder decodeObjectForKey:@"type"];
    self.coordinates = [aDecoder decodeObjectForKey:@"coordinates"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_coordinates forKey:@"coordinates"];
}

#pragma mark - Location Methods

- (CLLocationCoordinate2D)centerCoordinates
{
    NSMutableArray *allCoordinates = [[NSMutableArray alloc] init];
    NSMutableArray *polylines = [[NSMutableArray alloc] init];
    //If it's a Multipolygon type we need a polyline
    if( [self.type isEqualToString:@"MultiPolygon"])
    {
        //each one is a set of coordinates. For example the admr.nl.amsterdam is made of 3 different groups
        for(NSArray *coordGrp in  self.coordinates){
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
                
                free(coordinateArray);
            }
        }
    }
    if ([ self.type isEqualToString:@"Point"]) {
        //point
        double lon = [[[ self.coordinates objectAtIndex:0] stringValue] doubleValue];
        double lat = [[[ self.coordinates objectAtIndex:1] stringValue] doubleValue];
        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * 1);
        coordinateArray[0] = CLLocationCoordinate2DMake(lat, lon);

        [allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
        free(coordinateArray);
        
    }
    
    if ([ self.type isEqualToString:@"Polygon"]) {
        //each one is a set of coordinates.
        for(NSArray *coordGrp in  self.coordinates){
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
            
            free(coordinateArray);
        }
        
    }
    
    if ([ self.type isEqualToString:@"MultiLineString"]) {
        //each one is a set of coordinate that define a line (not a polygon)
        //it parses just as Polygon does
        for(NSArray *coordGrp in  self.coordinates){
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
            
            free(coordinateArray);
        }
    }
    if ([ self.type isEqualToString:@"LineString"]) {
        // self.coordinates is just an array of coordinates, so I iterate only 1 time
        int caIndex = 0;
        NSInteger coordCount = [ self.coordinates count];
        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);
        
        for(NSArray *coordGrp in  self.coordinates){
            double lon = [[[coordGrp objectAtIndex:0] stringValue] floatValue];
            double lat = [[[coordGrp objectAtIndex:1] stringValue] floatValue];
            
            coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
            [allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
            caIndex++;
        }
        free(coordinateArray);

    }
    if ([ self.type isEqualToString:@"GeometryCollection"] ) {
        //This is a container for different types of geometries (can contain points, LineString, MultiLineString, Polygon, etc.
        //TODO: still have to deal with it
    }

    if([allCoordinates count] > 0)
    {
        return [self getCenterRegionFromPoints:allCoordinates];
    }
    else{
        return CLLocationCoordinate2DMake(0, 0);
    }
    
}

- (CLLocationCoordinate2D)getCenterRegionFromPoints:(NSArray *)points
{
    CLLocationCoordinate2D topLeftCoordinate;
    topLeftCoordinate.latitude = -90;
    topLeftCoordinate.longitude = 180;
    CLLocationCoordinate2D bottomRightCoordinate;
    bottomRightCoordinate.latitude = 90;
    bottomRightCoordinate.longitude = -180;
    for (CLLocation *location in points) {
        topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, location.coordinate.longitude);
        topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, location.coordinate.latitude);
        bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, location.coordinate.longitude);
        bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, location.coordinate.latitude);
    }
    double centerLatitude = topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.5;
    double centerLongitude = topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.5;

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude);
    return center;
}

@end
