//
//  MenuViewController.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/2/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "MenuViewController.h"
#import "CSDKRequest.h"
#import "MapViewController.h"
#import "ViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong) NSMutableArray *userObjects; //for the queries custom-made by user

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
    [self initObjects];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)initObjects
{
    if(_objects == nil)
    {
        _objects = [[NSMutableArray alloc] init];
        //museums in Amsterdam
        CSDKRequest *r1 = [[CSDKRequest alloc] init];
        r1.admr = @"admr.nl.amsterdam";
        r1.layerKey = @"osm::tourism";
        r1.layerValue = @"museum";
        r1.per_page = 100;
        [_objects addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Museums in Amsterdam", @"title", r1, @"request", nil]];
        
        //open service requests in Helsinki
        //nodes?311.helsinki::status=open
        CSDKRequest *r2 = [[CSDKRequest alloc] init];
        r2.layerKey = @"311.helsinki::status";
        r2.layerValue = @"open";
        r2.per_page = 100;
        [_objects addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Open Service Requests in Amsterdam", @"title", r2, @"request", nil]];
        
        //Highways in a 10km radius around Utrecht
        //nodes?lat=52.090774&lon=5.121281&radius=10000&per_page=1000&osm::highway=motorway
        [_objects addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:@"Highways in a 10km radius around Utrecht", @"title",
          [CSDKRequest requestWithAdmr:nil layerKey:@"osm::highway" layerValue:@"motorway" latitude:52.09077 longitude:5.121281 perPage:1000 radius:10000], @"request"
          ,nil]];
    }
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [_objects count];
            break;
        case 1:
            return 1;
        default:
            break;
    }
    return nil;
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
            cell.textLabel.text = NSLocalizedString(@"Play with Map", nil);
        default:
            break;
    }

    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Choose a request for CitySDK", nil);
            break;
        case 1:
            return NSLocalizedString(@"Free play", nil);
        default:
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
    // Navigation logic may go here. Create and push another view controller.
    switch (indexPath.section) {
        case 0:
        {
            MapViewController *detailViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
            detailViewController.request = [[_objects objectAtIndex:indexPath.row] objectForKey:@"request"];
            
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
            break;
        case 1:
        {
            ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        default:
            break;
    }
    
}

@end
