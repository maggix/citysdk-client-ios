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

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextField *admrTextField;
@property (nonatomic, weak) IBOutlet UITextField *nodesTextField;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic, weak) IBOutlet MQMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *resultsLabel;
@property (nonatomic, weak) IBOutlet UILabel *layersLabel;

@property (nonatomic, strong) CSDKResults *results;
@property (nonatomic, strong) NSMutableArray *allCoordinates;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    path = [path stringByAppendingString:@"&geom"];
    
    
//    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init]; //I put everything in the path
//    [paramsDict setValue:@"bag.panden" forKey:@"layer"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
        [[CSDKHTTPClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"operation: %@", [operation description]);
            NSLog(@"operation: %@", [[operation request] URL]);
            __autoreleasing NSError* dataError = nil;
            NSDictionary *r = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&dataError];
            
            //get JSON stuff
            CSDKresponse *resp = [CSDKresponse modelObjectWithDictionary:r];
            if ([resp.status isEqualToString:@"success"]) {
                NSLog(@"Success!");
                //                NSLog(@"Resp: %@", resp);
                __block NSString *stringLayers = @"Layers: ";
                [resp.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    stringLayers = [stringLayers stringByAppendingString:[((CSDKResults*)obj) layer]];
                    stringLayers = [stringLayers stringByAppendingString:@" "];
                }];
                
                
                __block NSMutableArray *result = [[NSMutableArray alloc] init];
                
                //let's see each result from CitySDK
                [resp.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    CSDKResults *r = ((CSDKResults*)obj);
                    
                    //If it's a Multipolygon type we need a polyline
                    if( [r.geom.type isEqualToString:@"MultiPolygon"])
                    {
                        //each one is a set of coordinates. For example the admr.nl.amsterdam is made of 3 different groups
                        for(NSArray *coordGrp in r.geom.coordinates){
                            //for each group I need to loop again
                            for (NSArray *polylineCoord in coordGrp) {
                                
                                int caIndex = 0;
                                NSInteger coordCount = [polylineCoord count];
                                CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);
                                
                                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                                for(NSArray *coord in polylineCoord){
                                    double lon = [[[coord objectAtIndex:0] stringValue] floatValue];
                                    double lat = [[[coord objectAtIndex:1] stringValue] floatValue];
                                    
                                    coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
                                    [_allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                                    caIndex++;
                                }
                                
                                MQPolyline *pl = [MQPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                                [result addObject:pl];
                                free(coordinateArray);
                                
                            }
                        }
                        
                    }
                    if ([r.geom.type isEqualToString:@"Point"]) {
                        //point
                        double lon = [[[r.geom.coordinates objectAtIndex:0] stringValue] doubleValue];
                        double lat = [[[r.geom.coordinates objectAtIndex:1] stringValue] doubleValue];
                        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * 1);
                        coordinateArray[0] = CLLocationCoordinate2DMake(lat, lon);
                        MQPolyline *pl = [MQPolyline polylineWithCoordinates:coordinateArray count:1];
                        [result addObject:pl];
                        [_allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                        free(coordinateArray);
                    }
                    
                    if ([r.geom.type isEqualToString:@"Polygon"]) {
                        //each one is a set of coordinates.
                        for(NSArray *coordGrp in r.geom.coordinates){
                            int caIndex = 0;
                            NSInteger coordCount = [coordGrp count];
                            CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);
                            
                            for(NSArray *coord in coordGrp){
                                
                                double lon = [[[coord objectAtIndex:0] stringValue] floatValue];
                                double lat = [[[coord objectAtIndex:1] stringValue] floatValue];
                                
                                coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
                                [_allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                                caIndex++;
                            }
                            
                            MQPolyline *pl = [MQPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                            [result addObject:pl];
                            free(coordinateArray);
                        }
                    }
                    
                    if ([r.geom.type isEqualToString:@"MultiLineString"]) {
                        //each one is a set of coordinate that define a line (not a polygon)
                        //it parses just as Polygon does
                        for(NSArray *coordGrp in r.geom.coordinates){
                            int caIndex = 0;
                            NSInteger coordCount = [coordGrp count];
                            CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);
                            
                            for(NSArray *coord in coordGrp){
                                
                                double lon = [[[coord objectAtIndex:0] stringValue] floatValue];
                                double lat = [[[coord objectAtIndex:1] stringValue] floatValue];
                                
                                coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
                                [_allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                                caIndex++;
                            }
                            
                            MQPolyline *pl = [MQPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                            [result addObject:pl];
                            free(coordinateArray);
                        }
                        
                    }
                    if ([r.geom.type isEqualToString:@"LineString"]) {
                        //r.geom.coordinates is just an array of coordinates, so I iterate only 1 time
                        int caIndex = 0;
                        NSInteger coordCount = [r.geom.coordinates count];
                        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);
                        
                        for(NSArray *coordGrp in r.geom.coordinates){
                            double lon = [[[coordGrp objectAtIndex:0] stringValue] floatValue];
                            double lat = [[[coordGrp objectAtIndex:1] stringValue] floatValue];
                            
                            coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
                            [_allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                            caIndex++;
                        }
                        MQPolyline *pl = [MQPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                        [result addObject:pl];
                        free(coordinateArray);
                    }
                    if ([r.geom.type isEqualToString:@"GeometryCollection"]) {
                        //This is a container for different types of geometries (can contain points, LineString, MultiLineString, Polygon, etc.
                        //TODO: still have to deal with it
                    }
                }];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                
                //Update map
                [_mapView addOverlays:result];
                
                //set region to display
                [_mapView setRegion:[self getCenterRegionFromPoints:_allCoordinates] animated:YES];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",[error description] );
            //Hide hud
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error while loading", nil) message:[NSString stringWithFormat:@"%@", [error description]] delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
            [a show];
        }];
        
        
    });
}


- (MQCoordinateRegion)getCenterRegionFromPoints:(NSArray *)points
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
    MQCoordinateRegion region;
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

- (MQOverlayView *)mapView:(MQMapView *)mapView viewForOverlay:(id<MQOverlay>)overlay
{
    if([overlay isKindOfClass:[MQPolyline class]])
    {
        MQPolylineView *lineView = [[MQPolylineView alloc] initWithPolyline:overlay];
        lineView.lineWidth = 5;
        lineView.strokeColor = [UIColor redColor];
        lineView.fillColor = [UIColor redColor];
        return lineView;
    }
    return nil;
}

@end
