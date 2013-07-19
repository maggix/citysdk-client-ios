//
//  AppState.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/19/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "AppState.h"

@implementation AppState

+(AppState *)sharedInstance {
    static dispatch_once_t pred;
    static AppState *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[AppState alloc] init];
    });
    return shared;
}

#pragma mark - Save and restore

- (BOOL)save
{
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docsPath stringByAppendingPathComponent: @"AppData"];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

    [encoder encodeBool:_setting_cleanup_data forKey:@"setting_cleanup_data"];
    
    [encoder finishEncoding];
    
    BOOL result = [data writeToFile:filePath atomically:YES];
    
    return result;

}

- (void)restore
{
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docsPath stringByAppendingPathComponent: @"AppData"];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
    if (data){
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        _setting_cleanup_data = [decoder decodeBoolForKey:@"setting_cleanup_data"];
        [decoder finishDecoding];
    }

}


@end
