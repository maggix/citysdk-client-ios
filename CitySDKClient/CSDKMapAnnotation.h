//
//  CSDKMapAnnotation.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/10/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQMapKit/MQMapKit.h>

@interface CSDKMapAnnotation : NSObject <MQAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//- (MQMapItem*)mapItem;
- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate;


@end
