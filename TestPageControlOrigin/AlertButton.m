//
//  AlertButton.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/13.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "AlertButton.h"

#define MARGIN_BUTTON 12.0f
#define DEFAULT_WINDOW_WIDTH 240
#define MIN_HEIGHT 35.0f

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
    self.frame = CGRectMake(0.0f, 0.0f, windowWidth - (MARGIN_BUTTON * 2), MIN_HEIGHT);
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.layer.cornerRadius = (windowWidth - (MARGIN_BUTTON * 2))/6;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self setTitleColor:RGBA(49, 213, 255, 1.0) forState:UIControlStateNormal];
//    self.titleLabel.textColor = RGBA(49, 213, 255, 1.0);
//    self.titleLabel.textColor = [UIColor redColor];
}

- (void)adjustWidthWithWindowWidth:(CGFloat)windowWidth numberOfButtons:(NSUInteger)numberOfButtons
{
    CGFloat allButtonsWidth = windowWidth - (MARGIN_BUTTON * 2);
    CGFloat buttonWidth = (allButtonsWidth - ((numberOfButtons - 1) * 10)) / numberOfButtons;
    
    self.frame = CGRectMake(0.0f, 0.0f, buttonWidth, MIN_HEIGHT);
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    self.titleLabel.numberOfLines = 0;
    
    [self.titleLabel sizeToFit]; // calls sizeThatFits: with current view bounds and changes bounds size.
    [self layoutIfNeeded];//update button frame
    // Get height needed to display title label completely
    CGFloat buttonHeight = MAX(self.titleLabel.frame.size.height, MIN_HEIGHT);
    // Update button frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, buttonHeight);
}


@end
