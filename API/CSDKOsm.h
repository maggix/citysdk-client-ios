//
//  CSDKOsm.h
//
//  Created by Giovanni Maggini on 6/26/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSDKData;

@interface CSDKOsm : NSObject <NSCoding>

@property (nonatomic, strong) CSDKData *data;

+ (CSDKOsm *)modelObjectWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
