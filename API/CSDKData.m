//
//  CSDKData.m
//
//  Created by Giovanni Maggini on 6/26/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import "CSDKData.h"


@interface CSDKData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CSDKData

@synthesize platforms = _platforms;
@synthesize subway = _subway;
@synthesize train = _train;
@synthesize wheelchair = _wheelchair;
@synthesize publicTransport = _publicTransport;
@synthesize operator = _operator;
@synthesize station = _station;
@synthesize bicycle = _bicycle;
@synthesize name = _name;
@synthesize railway = _railway;


+ (CSDKData *)modelObjectWithDictionary:(NSDictionary *)dict
{
    CSDKData *instance = [[CSDKData alloc] initWithDictionary:dict];
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.platforms = [self objectOrNilForKey:@"platforms" fromDictionary:dict];
            self.subway = [self objectOrNilForKey:@"subway" fromDictionary:dict];
            self.train = [self objectOrNilForKey:@"train" fromDictionary:dict];
            self.wheelchair = [self objectOrNilForKey:@"wheelchair" fromDictionary:dict];
            self.publicTransport = [self objectOrNilForKey:@"public_transport" fromDictionary:dict];
            self.operator = [self objectOrNilForKey:@"operator" fromDictionary:dict];
            self.station = [self objectOrNilForKey:@"station" fromDictionary:dict];
            self.bicycle = [self objectOrNilForKey:@"bicycle" fromDictionary:dict];
            self.name = [self objectOrNilForKey:@"name" fromDictionary:dict];
            self.railway = [self objectOrNilForKey:@"railway" fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.platforms forKey:@"platforms"];
    [mutableDict setValue:self.subway forKey:@"subway"];
    [mutableDict setValue:self.train forKey:@"train"];
    [mutableDict setValue:self.wheelchair forKey:@"wheelchair"];
    [mutableDict setValue:self.publicTransport forKey:@"public_transport"];
    [mutableDict setValue:self.operator forKey:@"operator"];
    [mutableDict setValue:self.station forKey:@"station"];
    [mutableDict setValue:self.bicycle forKey:@"bicycle"];
    [mutableDict setValue:self.name forKey:@"name"];
    [mutableDict setValue:self.railway forKey:@"railway"];

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

    self.platforms = [aDecoder decodeObjectForKey:@"platforms"];
    self.subway = [aDecoder decodeObjectForKey:@"subway"];
    self.train = [aDecoder decodeObjectForKey:@"train"];
    self.wheelchair = [aDecoder decodeObjectForKey:@"wheelchair"];
    self.publicTransport = [aDecoder decodeObjectForKey:@"publicTransport"];
    self.operator = [aDecoder decodeObjectForKey:@"operator"];
    self.station = [aDecoder decodeObjectForKey:@"station"];
    self.bicycle = [aDecoder decodeObjectForKey:@"bicycle"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.railway = [aDecoder decodeObjectForKey:@"railway"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_platforms forKey:@"platforms"];
    [aCoder encodeObject:_subway forKey:@"subway"];
    [aCoder encodeObject:_train forKey:@"train"];
    [aCoder encodeObject:_wheelchair forKey:@"wheelchair"];
    [aCoder encodeObject:_publicTransport forKey:@"publicTransport"];
    [aCoder encodeObject:_operator forKey:@"operator"];
    [aCoder encodeObject:_station forKey:@"station"];
    [aCoder encodeObject:_bicycle forKey:@"bicycle"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_railway forKey:@"railway"];
}


@end
