//
//  MapViewController.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/7/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MQMapKit/MQMapKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@class CSDKNodesRequest;

@interface MapViewController : UIViewController <UIAlertViewDelegate, MQMapViewDelegate>

@property (nonatomic, strong) CSDKNodesRequest *request;

@end
