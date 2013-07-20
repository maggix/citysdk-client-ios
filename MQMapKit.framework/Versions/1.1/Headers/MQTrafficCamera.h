//
//  MQTrafficCamera.h
//  mq_ios_sdk
//
//  Created by Jason Sypher on 3/26/12.
//  Copyright (c) 2012 MapQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MQTrafficCamera : UITapGestureRecognizer

@property (nonatomic,retain) NSString* idString;
@property (nonatomic,retain) NSDecimalNumber* lat;
@property (nonatomic,retain) NSDecimalNumber* lng;
@property (nonatomic,retain) NSString* name;
@property (assign) int updateFrequency;
@property (nonatomic,retain) NSString* view;

-(CLLocationCoordinate2D) coordinate;

@end
