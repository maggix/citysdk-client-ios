//
//  ViewController.m
//  CitySDKApiMap
//
//  Created by Giovanni on 6/29/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "ViewController.h"
#import "DataModels.h"
#import <objc/runtime.h>

#define kCitySDKApiBaseUrl @"http://api.citysdk.waag.org/"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextField *admrTextField;
@property (nonatomic, weak) IBOutlet UITextField *nodesTextField;
@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
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
    
    //TODO: center map on the correct admr region (e.g. Roma..)
    
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
    
    
    NSDictionary *paramsDict = [[NSDictionary alloc] init]; //I put everything in the path
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSURL *url = [NSURL URLWithString:kCitySDKApiBaseUrl];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [httpClient getPath:path parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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

                _resultsLabel.text = [NSString stringWithFormat:@"Results: %@",resp.recordCount];
                
                __block NSMutableArray *result = [[NSMutableArray alloc] init];
                
                //let's see each result from CitySDK
                [resp.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    CSDKResults *r = ((CSDKResults*)obj);
                    
                    //If it's a Multipolygon type we need a polyline
                   if( [r.geom.type isEqualToString:@"MultiPolygon"])
                   {
                       //each one is a set of coordinates. For example the admr.nl.amsterdam is made of 3 different groups
                        for(NSArray *coordGrp in r.geom.coordinates){
                            //for each group I need to loop again (this is unclear why?)
                            for (NSArray *polylineCoord in coordGrp) {
                                
                                int caIndex = 0;
                                NSInteger coordCount = [polylineCoord count];
                                CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * coordCount);

                                for(NSArray *coord in polylineCoord){
                                    double lon = [[[coord objectAtIndex:0] stringValue] floatValue];
                                    double lat = [[[coord objectAtIndex:1] stringValue] floatValue];
                                    
                                    coordinateArray[caIndex] = CLLocationCoordinate2DMake(lat, lon);
                                    [_allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
                                    caIndex++;
                                }
                                
                                MKPolyline *pl = [MKPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                                [result addObject:pl];
                                free(coordinateArray);

                            }
                        }
  
                   }
                    if ([r.geom.type isEqualToString:@"Point"]) {
                        //point
                        double lat = [[[r.geom.coordinates objectAtIndex:1] stringValue] doubleValue];
                        double lon = [[[r.geom.coordinates objectAtIndex:1] stringValue] doubleValue];
                        CLLocation *p = [[CLLocation alloc] initWithLatitude:lat longitude: lon];
                        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * 1);
                        coordinateArray[0] = CLLocationCoordinate2DMake(lat, lon);
                        MKPolyline *pl = [MKPolyline polylineWithCoordinates:coordinateArray count:1];
                        [result addObject:pl];
                        [_allCoordinates addObject:[[CLLocation alloc] initWithLatitude:lon longitude:lon]];
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
                                
                                MKPolyline *pl = [MKPolyline polylineWithCoordinates:coordinateArray count:coordCount];
                                [result addObject:pl];
                                free(coordinateArray);
                                
                            
                        }

                    }
                }];

                //Update map
                
                [_mapView addOverlays:result];
                
                //set region to display
                
                [_mapView setRegion:[self getCenterRegionFromPoints:_allCoordinates] animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",[error description] );
            _resultsLabel.text = @"Error";

        }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
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

@end
