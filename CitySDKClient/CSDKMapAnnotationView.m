//
//  CSDKMapAnnotationView.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/11/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "CSDKMapAnnotationView.h"

@implementation CSDKMapAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithAnnotation:(id<MQAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        CSDKMapAnnotation *csdkAnnotation = self.annotation;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
