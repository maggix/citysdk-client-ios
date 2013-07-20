//
//  MQUserTrackingBarButtonItem.h
//  mq_ios_sdk
//
//  Created by Fabian Canas on 6/18/12.
//  Copyright (c) 2012 MapQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQMapView.h"

@interface MQUserTrackingBarButtonItem : UIBarButtonItem

@property(nonatomic, retain) MQMapView *mapView;

- (id)initWithMapView:(MQMapView *)mapView;

@end
