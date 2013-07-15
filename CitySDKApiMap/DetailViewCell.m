//
//  DetailViewCell.m
//  CitySDKApiMap
//
//  Created by Giovanni on 7/16/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import "DetailViewCell.h"

@implementation DetailViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
