//
//  CSDKresponse.m
//
//  Created by Giovanni Maggini on 6/26/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import "CSDKresponse.h"
#import "CSDKResults.h"


@interface CSDKresponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CSDKresponse

@synthesize status = _status;
@synthesize pages = _pages;
@synthesize perPage = _perPage;
@synthesize recordCount = _recordCount;
@synthesize results = _results;
@synthesize nextPage = _nextPage;
@synthesize url = _url;


+ (CSDKresponse *)modelObjectWithDictionary:(NSDictionary *)dict
{
    CSDKresponse *instance = [[CSDKresponse alloc] initWithDictionary:dict];
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.status = [self objectOrNilForKey:@"status" fromDictionary:dict];
            self.pages = [self objectOrNilForKey:@"pages" fromDictionary:dict];
            self.perPage = [[dict objectForKey:@"per_page"] doubleValue];
            self.recordCount = [self objectOrNilForKey:@"record_count" fromDictionary:dict];
    NSObject *receivedCSDKResults = [dict objectForKey:@"results"];
    NSMutableArray *parsedCSDKResults = [NSMutableArray array];
    if ([receivedCSDKResults isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCSDKResults) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCSDKResults addObject:[CSDKResults modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCSDKResults isKindOfClass:[NSDictionary class]]) {
       [parsedCSDKResults addObject:[CSDKResults modelObjectWithDictionary:(NSDictionary *)receivedCSDKResults]];
    }

    self.results = [NSArray arrayWithArray:parsedCSDKResults];
            self.nextPage = [[dict objectForKey:@"next_page"] doubleValue];
            self.url = [self objectOrNilForKey:@"url" fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.status forKey:@"status"];
    [mutableDict setValue:self.pages forKey:@"pages"];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perPage] forKey:@"per_page"];
    [mutableDict setValue:self.recordCount forKey:@"record_count"];
NSMutableArray *tempArrayForResults = [NSMutableArray array];
    for (NSObject *subArrayObject in self.results) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForResults addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForResults addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForResults] forKey:@"results"];
    [mutableDict setValue:[NSNumber numberWithDouble:self.nextPage] forKey:@"next_page"];
    [mutableDict setValue:self.url forKey:@"url"];

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

    self.status = [aDecoder decodeObjectForKey:@"status"];
    self.pages = [aDecoder decodeObjectForKey:@"pages"];
    self.perPage = [aDecoder decodeDoubleForKey:@"perPage"];
    self.recordCount = [aDecoder decodeObjectForKey:@"recordCount"];
    self.results = [aDecoder decodeObjectForKey:@"results"];
    self.nextPage = [aDecoder decodeDoubleForKey:@"nextPage"];
    self.url = [aDecoder decodeObjectForKey:@"url"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_status forKey:@"status"];
    [aCoder encodeObject:_pages forKey:@"pages"];
    [aCoder encodeDouble:_perPage forKey:@"perPage"];
    [aCoder encodeObject:_recordCount forKey:@"recordCount"];
    [aCoder encodeObject:_results forKey:@"results"];
    [aCoder encodeDouble:_nextPage forKey:@"nextPage"];
    [aCoder encodeObject:_url forKey:@"url"];
}


@end
