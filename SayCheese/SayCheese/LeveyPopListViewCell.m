//
//  LeveyPopListViewCell.m
//  LeveyPopListViewDemo
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//

#import "LeveyPopListViewCell.h"


@implementation LeveyPopListViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = CGRectMake(10, 0, 35, 35);
    self.imageView.frame = CGRectOffset(rect, 5, 5);
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
