//
//  MQRoutePolyline.h
//  mq_ios_sdk
//
//  Created by Ty Beltramo on 9/27/12.
//  Copyright (c) 2012 MapQuest. All rights reserved.
//

#import "MQPolyline.h"

@interface MQRoutePolyline : MQPolyline

/**Create a route polyline object with a collection of coordinates
 * @param coords c array of CLLocationCoordinate2D coords
 * @param count number of coords in array
 * @return new polyline object
 */
+ (MQRoutePolyline *)routePolylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

/**Create a route polyline object with a collection of map points
 * @param points c array of map points
 * @param count number of coords in array
 * @return polyline object
 */
+ (MQRoutePolyline *)routePolylineWithPoints:(MQMapPoint *)points count:(NSUInteger)count;


@end
