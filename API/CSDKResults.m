//
//  CSDKResults.m
//
//  Created by Giovanni Maggini on 6/26/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import "CSDKResults.h"
#import "CSDKGeom.h"


@interface CSDKResults ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CSDKResults

@synthesize layers = _layers;
@synthesize geom = _geom;
@synthesize nodeType = _nodeType;
@synthesize layer = _layer;
@synthesize name = _name;
@synthesize cdkId = _cdkId;


+ (CSDKResults *)modelObjectWithDictionary:(NSDictionary *)dict
{
    CSDKResults *instance = [[CSDKResults alloc] initWithDictionary:dict];
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.layers = [dict objectForKey:@"layers"];
            self.geom = [CSDKGeom modelObjectWithDictionary:[dict objectForKey:@"geom"]];
            self.nodeType = [self objectOrNilForKey:@"node_type" fromDictionary:dict];
            self.layer = [self objectOrNilForKey:@"layer" fromDictionary:dict];
            self.name = [self objectOrNilForKey:@"name" fromDictionary:dict];
            self.cdkId = [self objectOrNilForKey:@"cdk_id" fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.layers forKey:@"layers"];
    [mutableDict setValue:[self.geom dictionaryRepresentation] forKey:@"geom"];
    [mutableDict setValue:self.nodeType forKey:@"node_type"];
    [mutableDict setValue:self.layer forKey:@"layer"];
    [mutableDict setValue:self.name forKey:@"name"];
    [mutableDict setValue:self.cdkId forKey:@"cdk_id"];

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

    self.layers = [aDecoder decodeObjectForKey:@"layers"];
    self.geom = [aDecoder decodeObjectForKey:@"geom"];
    self.nodeType = [aDecoder decodeObjectForKey:@"nodeType"];
    self.layer = [aDecoder decodeObjectForKey:@"layer"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.cdkId = [aDecoder decodeObjectForKey:@"cdkId"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_layers forKey:@"layers"];
    [aCoder encodeObject:_geom forKey:@"geom"];
    [aCoder encodeObject:_nodeType forKey:@"nodeType"];
    [aCoder encodeObject:_layer forKey:@"layer"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_cdkId forKey:@"cdkId"];
}


@end
