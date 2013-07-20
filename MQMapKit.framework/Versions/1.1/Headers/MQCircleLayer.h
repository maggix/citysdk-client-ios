//
//  MQCircleLayer.h
//  mq_ios_sdk
//
//  Created by Ty Beltramo on 7/22/11.
//  Copyright 2011 MapQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface MQCircleLayer : CALayer {
	CGFloat		radius;
	CGFloat		strokeWidth;
    UIColor*    strokeColor;
    UIColor*    fillColor;
}

@property (assign) CGFloat	radius;
@property (assign) CGFloat	strokeWidth;
@property (nonatomic,retain) UIColor*    strokeColor;
@property (nonatomic,retain) UIColor*    fillColor;

@end