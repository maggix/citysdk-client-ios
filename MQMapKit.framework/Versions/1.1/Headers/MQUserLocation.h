//
//  MQUserLocation.h
//  mq_ios_sdk
//
//  Created by Ty Beltramo on 7/19/11.
//  Copyright 2011 MapQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQAnnotation.h"

@class UIImage;     //  Alternative to #import <UIKit/UIKit.h> for an opaque object

/**A special annotation type reserved to represent the user's current location on a map.
 * @warning You do not create instances of this class directly. Instead, the mapView creates and manages the instance when showUserLocation is enabled on the mapView.
 */
@interface MQUserLocation : NSObject<MQAnnotation, NSCopying> {
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
    
    CLLocation *location;
    BOOL updating;
    
    UIImage*    customIcon;
    BOOL        rotateIconToHeading;
    BOOL        pulsingEnabled;

}
/** The heading of the user location
 * @warning This property may not be correctly set if the user tracking location is not MQUserTrackingModeFollowWithHeading
 */
@property (readonly, nonatomic) CLHeading *heading;

///The location of the user's device
@property (readonly, nonatomic) CLLocation *location;

///Indicates whether the user location is being periodically updated
@property (readonly, nonatomic, getter=isUpdating) BOOL updating;

/** Title and subtitle for callout. 
 * @warning An empty title will disable user interaction for the annotation */
@property (nonatomic, copy) NSString *title;

/** @warning Will only be displayed if the title is not empty */
@property (nonatomic, copy) NSString *subtitle;


/* Replace the default blue dot with this image if non-nil */
@property (nonatomic, copy) UIImage*    customIcon;

/* Rotate the custom image based on the heading property */
@property (nonatomic, assign) BOOL      rotateIconToHeading;

// Pass this value along to the MQUserLocationView
@property (nonatomic, assign) BOOL      pulsingEnabled;

/** Initialize a user location annotation with a coord title, and subtitle.
 * @param coord  A CLLocationCoordinate2D in a user-defined coordinate system.
 * @param aTitle An NSString denoting the primary user-readable label
 * @param aSubtitle An NSString object denoting the detailed description
 * 
 */
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord 
                   title:(NSString *)aTitle 
                subTitle:(NSString*)aSubtitle;

- (void) addObserversForView: (UIView*) theView;

- (void) removeObserversForView: (UIView*) theView;

@end
