//
//  CSDKResults.h
//
//  Created by Giovanni Maggini on 6/26/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSDKLayers, CSDKGeom;

@interface CSDKResults : NSObject <NSCoding>

@property (nonatomic, strong) NSDictionary *layers;
@property (nonatomic, strong) CSDKGeom *geom;
@property (nonatomic, strong) NSString *nodeType;
@property (nonatomic, strong) NSString *layer;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cdkId;

+ (CSDKResults *)modelObjectWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
