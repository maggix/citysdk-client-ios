//
//  CSDKData.h
//
//  Created by Giovanni Maggini on 7/10/13
//  Copyright (c) 2013 gixWorks. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CSDKArtsHollandData : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSString *streetAddress;

+ (CSDKArtsHollandData *)modelObjectWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
