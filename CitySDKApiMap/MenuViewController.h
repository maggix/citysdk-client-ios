//
//  MenuViewController.h
//  CitySDKApiMap
//
//  Created by Giovanni on 7/2/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MenuViewController : UITableViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@end
