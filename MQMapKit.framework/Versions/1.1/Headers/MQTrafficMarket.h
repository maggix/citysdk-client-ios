//
//  MQTrafficMarket.h
//  sdk_dev
//
//  Created by Jason Sypher on 3/13/12.
//  Copyright (c) 2012 MapQuest Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MQTrafficMarket : NSObject

@property (nonatomic,retain) NSString* city;
@property (nonatomic,retain) NSString* state;
@property double lat;
@property double lng;

@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) NSString* title;

@end
