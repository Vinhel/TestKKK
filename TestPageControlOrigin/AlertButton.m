//
//  AlertButton.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/13.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "AlertButton.h"

@implementation AlertButton

- (instancetype)init
{
    if (self = [super init]) {
//        [self initWithWindowWidth:kScreen_Width];
    }
    return self;
}

- (instancetype)initWithWindowWidth:(CGFloat)windowWidth
{
    self = [super init];
    if (self)
    {
        [self setupWithWindowWidth:windowWidth];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setupWithWindowWidth:kScreen_Width];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupWithWindowWidth:kScreen_Width];
    }
    return self;
}

- (void)setupWithWindowWidth:(CGFloat)windowWidth
{
    self.frame = CGRectMake(0.0f, 0.0f, windowWidth - (10 * 2), 36);
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.layer.cornerRadius = 3.0f;
}


@end
