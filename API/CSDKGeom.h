//
//  CSDKGeom.h
//
//  Created by Giovanni Maggini on 6/26/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CSDKGeom : NSObject <NSCoding>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *coordinates;

+ (CSDKGeom *)modelObjectWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
