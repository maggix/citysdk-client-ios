//
//  CSDKresponse.h
//
//  Created by Giovanni Maggini on 6/26/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CSDKresponse : NSObject <NSCoding>

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *pages;
@property (nonatomic, assign) double perPage;
@property (nonatomic, strong) NSString *recordCount;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, assign) double nextPage;
@property (nonatomic, strong) NSString *url;

+ (CSDKresponse *)modelObjectWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
