//
//  CSDKSelectRequest.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/21/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "CSDKSelectRequest.h"
#import "CSDKHTTPClient.h"

NSString* const SelectRequestNotificationName = @"kSelectRequestComplete";

@implementation CSDKSelectRequest

//nodename/select/regionns

- (NSString*)baseUrlForRequest
{
        return [NSString stringWithFormat:@"%@/select/%@", _nodeName, _selectItem];  
}


-(void)executeAndProcessRequestWithQuery:(NSString*)query
{
    NSString *path = [self baseUrlForRequest];
    
    if(query)
    {
        path = query;
    }
    
     [[CSDKHTTPClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"operation: %@", [operation description]);
         NSLog(@"operation: %@", [[operation request] URL]);
         SBJsonParser *parser = [[SBJsonParser alloc] init];
         NSDictionary *r = [parser objectWithData:responseObject];
         NSArray *results = [r objectForKey:@"results"];
         
         
         NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:results, @"result", results, @"CSDKResults", nil];
         //using this I got the allCoordinates nil-ed
         //  @{@"result": result,
         //                                       @"allCoordinates,": allCoordinates,
         //                                       @"annotations": annotations,
         //                                       };
         
         NSNotification *resultNotification = [NSNotification notificationWithName:SelectRequestNotificationName object:self userInfo:userInfo];
         [[NSNotificationCenter defaultCenter] postNotification:resultNotification];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error: %@",[error description] );
         
         NSDictionary *userInfo = @{
                                    @"resultError": error
                                    };
         
         NSNotification *resultNotification = [NSNotification notificationWithName:SelectRequestNotificationName object:self userInfo:userInfo];
         [[NSNotificationCenter defaultCenter] postNotification:resultNotification];
     }];
    
}

-(void)executeAndProcessRequest
{
    [self executeAndProcessRequestWithQuery:nil];
}

@end
