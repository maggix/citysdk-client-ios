//
//  MQOverlayView.h
//  mq_ios_sdk
//
//  Created by Erik Scrafford on 8/5/11.
//  Copyright 2011 MapQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQGeometry.h"
#import "MQOverlay.h"
#import "MQMapView.h"

CGFloat MQRoadWidthAtZoomScale( MQZoomScale zoomScale );

/** The MQOverlayView is the base class for all overlay view implementations. 
 *
 */
@interface MQOverlayView : UIView {
    id <MQOverlay> m_overlay;
}

//Since we use a multi-threaded means to rendering overlays, a thread may be in the process of drawing when the backing overlay is released.
//There doesn't seem to be a way to interrupt those rendering threads once started
//Set this to NO to stop additional rendering threads from spawning
//NOTE: make sure this is set to YES in the constructor
@property (atomic) BOOL isValid;


///The overlay attached to this overlay view
@property (nonatomic, readonly) id <MQOverlay> overlay;

/**Ask this overlay view if it can draw the given mapRect
 * @param mapRect The map rect that serves as the projected boundary around some annotations
 * @param zoomScale The zoomScale to be drawn at
 * @return a BOOL whether the mapRect can be drawn
 */
- (BOOL)canDrawMapRect:(MQMapRect)mapRect zoomScale:(MQZoomScale)zoomScale;


/**Draw into the given mapRect at zoomScale using the passed context
 * @param mapRect The map rect that serves as the projected boundary around some annotations
 * @param zoomScale The zoomScale to be drawn at
 * @param context The context to draw into
 * @return a BOOL whether the mapRect can be drawn
 */
- (void)drawMapRect:(MQMapRect)mapRect zoomScale:(MQZoomScale)zoomScale inContext:(CGContextRef)context;

/**Initialization method for MQOverlayView
 * @param overlay An MQOverlay that this view will be representing on screen
 * @return a new MQOverlay object
 */
- (id)initWithOverlay:(id <MQOverlay>)overlay;

/**Translate a screen point into a map point
 * @param point A screen point to be translated
 * @return a point in map points
 */
- (MQMapPoint)mapPointForPoint:(CGPoint)point;

/**Translate a screen region into a map region
 * @param rect A screen region to be translated
 * @return a region in map points
 */
- (MQMapRect)mapRectForRect:(CGRect)rect;

/**Translate a map point into a screen point
 * @param mapPoint A map point to be translated
 * @return a screen point
 */
- (CGPoint)pointForMapPoint:(MQMapPoint)mapPoint;

/**Translate a map region into a screen region
 * @param mapRect A map region to be translated
 * @return a screen region
 */
- (CGRect)rectForMapRect:(MQMapRect)mapRect;

/**Mark the overlay as needing to be redrawn
 * @param mapRect region that needs to be redrawn
 */
- (void)setNeedsDisplayInMapRect:(MQMapRect)mapRect;

/**Mark the overlay as needing to be redrawn
 * @param mapRect region that needs to be redrawn
 * @param zoomScale zoom scale at which the region needs to be redrawn
 */
- (void)setNeedsDisplayInMapRect:(MQMapRect)mapRect zoomScale:(MQZoomScale)zoomScale;

/** The mapView that contains the given view
 *@param aView A view that is contained by the mapview
 */
-(MQMapView*)mapViewForView:(UIView*)aView;


/**Get the current zoom scale
 * @return the current scale
 */
-(double)scale;

-(float)zoom;

-(float)ratio;

@end
