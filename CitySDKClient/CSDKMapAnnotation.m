//
//  CSDKMapAnnotation.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/10/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "CSDKMapAnnotation.h"

@implementation CSDKMapAnnotation

- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
    }
    return self;
}

//- (MKMapItem*)mapItem
//{
//    MKPlacemark *placemark = [[MKPlacemark alloc]
//                              initWithCoordinate:(self.coordinate)
//                              addressDictionary:nil];
//    
//    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
//    mapItem.name = self.title;
//    
//    return mapItem;
//}


@end
