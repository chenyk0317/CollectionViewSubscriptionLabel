//
//  CollectionHeaderView.m
//  CollectionViewSubscriptionLabel
//
//  Created by chenyk on 15/4/24.
//  Copyright (c) 2015年 chenyk. All rights reserved.
//

#import "CollectionHeaderView.h"

#define kTitleButtonWidth 250.f
#define kMoreButtonWidth  36*2
#define kCureOfLineHight  0.5
#define kCureOfLineOffX   16

float CYLFilterHeaderViewHeigt = 38;

@implementation CollectionHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}
- (id)initWithCoder: (NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (id)sharedInit {
       self.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:1.0];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.titleLabel.text = @"我的订阅";
    [self addSubview:self.titleLabel];
    return self;
}

@end
