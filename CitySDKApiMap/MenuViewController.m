//
//  MenuViewController.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/2/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "MenuViewController.h"
#import "CSDKNodesRequest.h"
#import "CSDKAdmrRequest.h"
#import "MapViewController.h"
#import "ViewController.h"
#import "SettingsViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong) NSMutableArray *locationObjects; //objects around me

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Requests"];
    [self initObjects];
//    [self initLocationObjects];
    
    [self startLocationServices];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
}

- (void) showSettings
{
    SettingsViewController *svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:svc];
    [self presentViewController:n animated:YES completion:^{
        
    }];
}

- (void)initObjects
{
    if(_objects == nil)
    {
        _objects = [[NSMutableArray alloc] init];

        //museums in Amsterdam
        [_objects addObject:
        [NSDictionary dictionaryWithObjectsAndKeys:@"Museums in Amsterdam", @"title",
         [CSDKNodesRequest requestWithAdmr:@"admr.nl.amsterdam" layerKey:@"osm::tourism" layerValue:@"museum" perPage:1000], @"request", nil]];
        
        //all borders
        [_objects addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:@"Border of Amsterdam", @"title",
          [CSDKAdmrRequest requestWithAdmr:@"admr.nl.amsterdam" perPage:1000], @"request", nil]];

        //museums in Amsterdam (only of type Points)
        NSArray *filter = @[@"Point"];
        CSDKNodesRequest *r = [CSDKNodesRequest requestWithAdmr:@"admr.nl.amsterdam" layerKey:@"osm::tourism" layerValue:@"museum" perPage:1000];
        r.geomTypesFilter = filter;
        [_objects addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:@"Museums in Amsterdam (Points only)", @"title",
          r, @"request", nil]];

        
        //Parks in Amsterdam
        //http://api.citysdk.waag.org/admr.nl.amsterdam/nodes?osm::leisure=park&per_page=1000
        [_objects addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:@"Parks in Amsterdam", @"title",
          [CSDKNodesRequest requestWithAdmr:@"admr.nl.amsterdam" layerKey:@"osm::leisure" layerValue:@"park" perPage:1000], @"request", nil]];
        
        //open service requests in Helsinki
        //nodes?311.helsinki::status=open
        CSDKNodesRequest *r2 = [[CSDKNodesRequest alloc] init];
        r2.layerKey = @"311.helsinki::status";
        r2.layerValue = @"open";
        r2.per_page = 100;
        [_objects addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Open Service Requests in Amsterdam", @"title", r2, @"request", nil]];
        
        //Highways in a 10km radius around Utrecht
        //nodes?lat=52.090774&lon=5.121281&radius=10000&per_page=1000&osm::highway=motorway
        //Not working!! Because node_type = LineString
        [_objects addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:@"Highways in a 10km radius around Utrecht", @"title",
          [CSDKNodesRequest requestWithAdmr:nil layerKey:@"osm::highway" layerValue:@"motorway" latitude:52.09077 longitude:5.121281 perPage:1000 radius:10000], @"request"
          ,nil]];
        
        //routes named "Stedenroute"
        //nodes?name=stedenroute&layer=osm
        [_objects addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:@"Routes named \"StedenRoute\"", @"title",
          [CSDKNodesRequest requestWithAdmr:nil layerKey:@"layer" layerValue:@"osm" name:@"stedenroute" latitude:0 longitude:0 perPage:0 radius:0], @"request", nil]];
        
        //Railway stations in Zoetermeer
        //admr.nl.zoetermeer/nodes?osm::railway=station&geom&per_page=100
        [_objects addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:@"Railway stations in Zoetermeer", @"title",
          [CSDKNodesRequest requestWithAdmr:@"admr.nl.zoetermeer" layerKey:@"osm::railway" layerValue:@"station" perPage:1000], @"request", nil]];
        
        //All ArtsHolland data in Amsterdam
        //http://api.citysdk.waag.org/admr.nl.amsterdam/nodes?layer=artsholland&per_page=1000
        [_objects addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:@"ArtsHolland in Amsterdam", @"title",
          [CSDKNodesRequest requestWithAdmr:@"admr.nl.amsterdam" layerKey:@"layer" layerValue:@"artsholland" perPage:1000], @"request", nil]];
        
    }
    
}

- (void)initLocationObjects
{

        _locationObjects = [[NSMutableArray alloc] init];
        
        //museums 1KM from here
        CSDKNodesRequest *r1 = [[CSDKNodesRequest alloc] init];
        r1.admr = nil;
        r1.layerKey = @"osm::tourism";
        r1.layerValue = @"museum";
        r1.per_page = 100;
        r1.latitude = _location.coordinate.latitude;
        r1.longitude = _location.coordinate.longitude;
        r1.radius = 1000;
        [_locationObjects addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Museums within 1Km from here", @"title", r1, @"request", nil]];
        
        //All Administrative regions, ordered (by default from citysdk) from the closest to where I am
        r1 = [[CSDKNodesRequest alloc] init];
        r1.admr = nil;
        r1.layerKey = @"layer";
        r1.layerValue = @"admr";
        r1.additionalParams = @{@"admr::admn_level": @"3"};
        r1.per_page = 100;
        r1.latitude = _location.coordinate.latitude;
        r1.longitude = _location.coordinate.longitude;
//        r1.radius = 1000;
        [_locationObjects addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Admrs ordered by distance from here", @"title", r1, @"request", nil]];
        
        //in what ADMR am I now?
        r1 = [[CSDKNodesRequest alloc] init];
        r1.admr = nil;
        r1.layerKey = @"layer";
        r1.layerValue = @"admr";
        r1.additionalParams = @{@"admr::admn_level": @"3"};
        r1.per_page = 100;
        r1.latitude = _location.coordinate.latitude;
        r1.longitude = _location.coordinate.longitude;
        r1.radius = 1000;
        [_locationObjects addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"In what ADMR am I now?", @"title", r1, @"request", nil]];
    
        
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [_objects count];
            break;
        case 1:
            return [_locationObjects count];
        default:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[_objects objectAtIndex:indexPath.row] objectForKey:@"title"];
            break;
        case 1:
            cell.textLabel.text = [[_locationObjects objectAtIndex:indexPath.row] objectForKey:@"title"];
            break;
        default:
            cell.textLabel.text = NSLocalizedString(@"Play with Map", nil);

            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Demo requests", nil);
            break;
        case 1:
            return NSLocalizedString(@"GPS-based requests", nil);
            break;
        default:
            return NSLocalizedString(@"Free play", nil);
            break;
    }

return nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    switch (indexPath.section) {
        case 0:
        {
            MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
            mapViewController.request = [[_objects objectAtIndex:indexPath.row] objectForKey:@"request"];
            [mapViewController setTitle:@""];
            [self.navigationController pushViewController:mapViewController animated:YES];
        }
            break;
        case 1:
        {
            MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
            mapViewController.request = [[_locationObjects objectAtIndex:indexPath.row] objectForKey:@"request"];
            [mapViewController setTitle:@""];
            [self.navigationController pushViewController:mapViewController animated:YES];
        }
            break;
        default:
        {
            ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
    }
    
}

# pragma mark - location stuff

- (void)startLocationServices
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"location services are disabled");
        return;
    }
    
    if (nil == locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100;
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];

    NSDate* eventDate = currentLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        
        _location = currentLocation;
//        [_locationObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            ((CSDKNodesRequest*)[obj objectForKey:@"request"]).latitude = _location.coordinate.latitude;
//            ((CSDKNodesRequest*)[obj objectForKey:@"request"]).longitude = _location.coordinate.longitude;
//        }];
        [locationManager stopUpdatingLocation];
        [self initLocationObjects];
        [self.tableView reloadData];
    }
    
}



@end
