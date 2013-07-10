//
//  CSDKData.h
//
//  Created by Giovanni Maggini on 6/26/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CSDKOSMData : NSObject <NSCoding>

@property (nonatomic, strong) NSString *platforms;
@property (nonatomic, strong) NSString *subway;
@property (nonatomic, strong) NSString *train;
@property (nonatomic, strong) NSString *wheelchair;
@property (nonatomic, strong) NSString *publicTransport;
@property (nonatomic, strong) NSString *operator;
@property (nonatomic, strong) NSString *station;
@property (nonatomic, strong) NSString *bicycle;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *railway;

+ (CSDKOSMData *)modelObjectWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
