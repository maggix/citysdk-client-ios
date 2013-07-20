//
//  ViewController.m
//  CitySDKApiMap
//
//  Created by Giovanni on 6/29/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "ViewController.h"
#import "DataModels.h"
#import "CSDKHTTPClient.h"
#import "CSDKNodesRequest.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextField *admrTextField;
@property (nonatomic, weak) IBOutlet UITextField *nodesTextField;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *resultsLabel;
@property (nonatomic, weak) IBOutlet UILabel *layersLabel;

@property (nonatomic,strong) CSDKNodesRequest *request;
@property (nonatomic, strong) CSDKResults *results;
@property (nonatomic, strong) NSMutableArray *allCoordinates;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoadComplete:) name:@"kNodesRequestComplete" object:nil];
    
    [_mapView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goButtonPressed:(id)sender
{
    [_admrTextField endEditing:YES];
    [_nodesTextField endEditing:YES];
    
    [_mapView removeOverlays:_mapView.overlays];
    _allCoordinates = [[NSMutableArray alloc] init];
        
    //build the path for the request
    NSString *path = @"";
    
    if( _admrTextField.text.length < 1)
    {

    }
    else{
        path = [path stringByAppendingString:_admrTextField.text];
        path = [path stringByAppendingString:@"/"];
    }
    
    if(_nodesTextField.text.length < 1)
    {
//        path = [path stringByAppendingString:_admrTextField.text];
        path = [path stringByAppendingString:@"?"];
    }
    else{
    path = [path stringByAppendingString:_nodesTextField.text];
    }
//    path = [path stringByAppendingString:@"&geom"]; //it's already set in the request params dictionary
    
    _request = [[CSDKNodesRequest alloc] init];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [ _request executeAndProcessRequestWithQuery:path];
        
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


#pragma mark -- UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
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
        lineView.fillColor = [UIColor redColor];
        return lineView;
    }
    return nil;
}

#pragma mark - Notification handler

-(void)handleLoadComplete:(NSNotification *) notification
{
    
    __weak ViewController *weakSelf = self;
    
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
