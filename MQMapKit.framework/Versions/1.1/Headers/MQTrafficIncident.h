//
//  MQTrafficIncident.h
//  sdk_dev
//
//  Created by Jason Sypher on 3/12/12.
//  Copyright (c) 2012 MapQuest Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MQTrafficIncident : NSObject

@property(nonatomic,retain) NSString *idString;
@property int type;
@property int severity;
@property int eventCode;
@property (nonatomic,retain) NSDecimalNumber* lat;
@property (nonatomic,retain) NSDecimalNumber* lng;
@property(nonatomic,retain) NSString *startTime;
@property(nonatomic,retain) NSString *endTime;
@property(nonatomic,retain) NSString *shortDesc;
@property(nonatomic,retain) NSString *fullDescription;
@property(nonatomic,retain) NSString *iconURL;

@property(readonly) CLLocationCoordinate2D coordinate;

@end
