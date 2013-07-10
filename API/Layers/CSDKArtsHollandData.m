//
//  CSDKData.m
//
//  Created by Giovanni Maggini on 7/10/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import "CSDKArtsHollandData.h"


@interface CSDKArtsHollandData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CSDKArtsHollandData

@synthesize events = _events;
@synthesize locality = _locality;
@synthesize website = _website;
@synthesize title = _title;
@synthesize telephone = _telephone;
@synthesize postalCode = _postalCode;
@synthesize uri = _uri;
@synthesize streetAddress = _streetAddress;


+ (CSDKArtsHollandData *)modelObjectWithDictionary:(NSDictionary *)dict
{
    CSDKArtsHollandData *instance = [[CSDKArtsHollandData alloc] initWithDictionary:dict];
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.events = [self objectOrNilForKey:@"events" fromDictionary:dict];
            self.locality = [self objectOrNilForKey:@"locality" fromDictionary:dict];
            self.website = [self objectOrNilForKey:@"website" fromDictionary:dict];
            self.title = [self objectOrNilForKey:@"title" fromDictionary:dict];
            self.telephone = [self objectOrNilForKey:@"telephone" fromDictionary:dict];
            self.postalCode = [self objectOrNilForKey:@"postal-code" fromDictionary:dict];
            self.uri = [self objectOrNilForKey:@"uri" fromDictionary:dict];
            self.streetAddress = [self objectOrNilForKey:@"street-address" fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
NSMutableArray *tempArrayForEvents = [NSMutableArray array];
    for (NSObject *subArrayObject in self.events) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEvents addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEvents addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEvents] forKey:@"events"];
    [mutableDict setValue:self.locality forKey:@"locality"];
    [mutableDict setValue:self.website forKey:@"website"];
    [mutableDict setValue:self.title forKey:@"title"];
    [mutableDict setValue:self.telephone forKey:@"telephone"];
    [mutableDict setValue:self.postalCode forKey:@"postal-code"];
    [mutableDict setValue:self.uri forKey:@"uri"];
    [mutableDict setValue:self.streetAddress forKey:@"street-address"];

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

    self.events = [aDecoder decodeObjectForKey:@"events"];
    self.locality = [aDecoder decodeObjectForKey:@"locality"];
    self.website = [aDecoder decodeObjectForKey:@"website"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.telephone = [aDecoder decodeObjectForKey:@"telephone"];
    self.postalCode = [aDecoder decodeObjectForKey:@"postalCode"];
    self.uri = [aDecoder decodeObjectForKey:@"uri"];
    self.streetAddress = [aDecoder decodeObjectForKey:@"streetAddress"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_events forKey:@"events"];
    [aCoder encodeObject:_locality forKey:@"locality"];
    [aCoder encodeObject:_website forKey:@"website"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_telephone forKey:@"telephone"];
    [aCoder encodeObject:_postalCode forKey:@"postalCode"];
    [aCoder encodeObject:_uri forKey:@"uri"];
    [aCoder encodeObject:_streetAddress forKey:@"streetAddress"];
}


@end
