//
//  MapViewController.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/7/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "MapViewController.h"
#import "CSDKNodesRequest.h"
#import "DataModels.h"
#import "CSDKHTTPClient.h"
#import "CSDKMapAnnotation.h"
#import "DetailViewController.h"
#import "AppState.h"

@interface MapViewController ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CSDKresponse *response;
//@property (nonatomic, strong) CSDKResults *results;
//@property (nonatomic, strong) NSMutableArray *allCoordinates;
//@property (nonatomic, strong) NSMutableArray *mapAnnotations;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_mapView setDelegate:self];
    [_mapView setShowsUserLocation:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoadComplete:) name:@"kNodesRequestComplete" object:nil];
    
    [self loadResults];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mapTypeChange:(id)sender {
    switch (((UISegmentedControl*)sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}


- (void)loadResults
{
    //cleanup
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];

    //reinitialize arrays to store objects to
//    _allCoordinates = [[NSMutableArray alloc] init];
//    _mapAnnotations = [[NSMutableArray alloc] init];
    
    //build the path for the request
    NSString *path = @"";
    path = [path stringByAppendingString:[_request baseUrlForRequest]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [ _request doAndProcessRequest];
        
    });
    
}

- (MKCoordinateRegion)getCenterRegionFromPoints:(NSArray *)points
{
    CLLocationCoordinate2D topLeftCoordinate;
    topLeftCoordinate.latitude = -90;
    topLeftCoordinate.longitude = 180;
    CLLocationCoordinate2D bottomRightCoordinate;
    bottomRightCoordinate.latitude = 90;
    bottomRightCoordinate.longitude = -180;
    for (CLLocation *location in points) {
        topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, location.coordinate.longitude);
        topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, location.coordinate.latitude);
        bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, location.coordinate.longitude);
        bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, location.coordinate.latitude);
    }
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.5;
    region.center.longitude = topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 1.2; //2
    region.span.longitudeDelta = fabs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 1.2; //2
    //    NSLog(@"zoom lvl : %f, %f", region.span.latitudeDelta, region.span.latitudeDelta);
    return region;
}

#pragma mark -
#pragma mark MKOverlayView Delegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        lineView.lineWidth = 5;
        lineView.strokeColor = [UIColor redColor];
        //Todo: fill with a semi-transparent color
        lineView.fillColor = [UIColor redColor];
        return lineView;
    }
    return nil;
}

#pragma mark -
#pragma mark Annotations

//To return a generic annotationview, use:
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
//}

- (MKPinAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"CSDKAnnotation";
    if ([annotation isKindOfClass:[CSDKMapAnnotation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            annotationView.image = [UIImage imageNamed:@"something"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
//    CSDKMapAnnotation *location = (CSDKMapAnnotation*)view.annotation;
//    
//    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
//    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
    
    DetailViewController *dvc = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    CSDKMapAnnotation *annotation =  (CSDKMapAnnotation*)view.annotation;
    NSString *csdk_id = annotation.subtitle;
    NSUInteger i = [_response.results indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    if([((CSDKResults*)obj).cdkId isEqualToString:csdk_id])
            {
                *stop =YES;
        return YES;
            }
        return NO;
    }];
    
    if (i == NSNotFound) {
        return;
    }
    dvc.layers =  [NSArray arrayWithObjects:[[[_response.results objectAtIndex:i] dictionaryRepresentation] objectForKey:@"layers"], nil];
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - Notification handler

-(void)handleLoadComplete:(NSNotification *) notification
{
    
    __weak MapViewController *weakSelf = self;
    
    NSDictionary *userDict = [notification userInfo];
    if(![userDict objectForKey:@"error"])
    {
        
        NSLog(@"allcoordinates %@", [userDict objectForKey:@"allCoordinates"]);
        [_mapView addAnnotations:[userDict objectForKey:@"annotations"]];
        [_mapView addOverlays:[userDict objectForKey:@"result"]];
        [_mapView setRegion:[self getCenterRegionFromPoints:[userDict objectForKey:@"allCoordinates"]] animated:YES];

    }
    else{
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error while loading", nil) message:[NSString stringWithFormat:@"%@", [[userDict objectForKey:@"resultError"] description]] delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
        [a show];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
}

@end
