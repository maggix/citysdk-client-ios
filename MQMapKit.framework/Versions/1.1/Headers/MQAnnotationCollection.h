//
//  MQAnnotationCollection.h
//  mq_ios_sdk
//
//  Created by Jason Sypher on 2/24/12.
//  Copyright (c) 2012 MapQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQAnnotation.h"

static NSString* MQ_ANNOTATION_COLLECTION_UPDATE_NOTIFICATION_NAME=@"_mq_annotationCollection_updated";

@class UIView;

@interface MQAnnotationCollection : NSObject{
    NSMutableArray *_annotations; //array of MQAnnotation objects
    NSNumber *minZoomLevel;
    NSNumber *maxZoomLevel;
    int zIndex;
    BOOL visible;
    NSString *key;
    id userData;
}


@property (atomic, retain) NSArray* annotations;
@property (atomic, readonly) NSString* key;
@property (atomic, retain) NSNumber *minZoomLevel;
@property (atomic, retain) NSNumber *maxZoomLevel;
@property (atomic, assign) int zIndex;
@property (atomic, assign) BOOL visible;

//Optionally associate arbitrary data with an MQAnnotationCollection. The SDK will not use this internally.
@property (atomic, retain) id userData;

@property (nonatomic, copy) void (^animateAnnotationViewRemovalFromMap)(UIView*, void(^complete)(void) );
@property (nonatomic, copy) void (^animateAnnotationViewAdditionToMap)(UIView*, void(^complete)(void) );

- (id) initWithKey: (NSString*) initKey andWithZIndex:(int) initZIndex;

@end
