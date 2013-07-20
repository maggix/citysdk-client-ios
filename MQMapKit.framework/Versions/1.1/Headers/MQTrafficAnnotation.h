//
//  MQTrafficAnnotation.h
//  mq_ios_sdk
//
//  Created by Jason Sypher on 3/19/12.
//  Copyright (c) 2012 MapQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQPointAnnotation.h"
#import "MQTrafficCamera.h"
#import "MQTrafficMarket.h"
#import "MQTrafficIncident.h"

@class UIImage;

typedef enum {
    MQTrafficPinTypeMarket=0,
    MQTrafficPinTypeIncident1=1,
    MQTrafficPinTypeIncident2=2,
    MQTrafficPinTypeIncident3=3, 
    MQTrafficPinTypeConstruction1=4,
    MQTrafficPinTypeConstruction2=5,
    MQTrafficPinTypeConstruction3=6,
    MQTrafficPinTypeCamera
} MQTrafficPinType;


@interface MQTrafficAnnotation : MQPointAnnotation

@property (nonatomic,retain) MQTrafficMarket *trafficMarket;
@property (nonatomic,retain) MQTrafficCamera *trafficCamera;
@property (nonatomic,retain) MQTrafficIncident *trafficIncident;
@property (assign) MQTrafficPinType type;
@property (nonatomic,retain) UIImage *flow;

-(UIImage*) imageForAnnotation;
-(NSString*) reuseIdentifer;

@end
