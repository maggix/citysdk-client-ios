//
//  SettingsViewController.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/19/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppState.h"    
#define CLEANUP_SWITCH_CELL 0

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissModalViewControllerAnimated:)];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case CLEANUP_SWITCH_CELL:
        {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
//            if( cell == nil ) {
//                cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"SwitchCell"] ;
                cell.textLabel.text = NSLocalizedString(@"Cleanup Empty Names", nil);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                cell.accessoryView = switchView;
                [switchView setOn:[[AppState sharedInstance] setting_cleanup_data] animated:NO];
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//            }
//            return cell;
        }
            break;
            
        default:
        {

            
        }
            break;
    }
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Sometimes data can be shitty, so turn this on to suppress results with empty names or with null way_area", nil);
            break;
            
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;

    [[AppState sharedInstance] setSetting_cleanup_data:switchControl.on];
    [[AppState sharedInstance] save];
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

@end
