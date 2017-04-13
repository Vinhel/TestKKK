//
//  UIBarButtonItem+Badge.m
//  TestPageControlOrigin
//
//  Created by noah on 2017/04/11.
//  Copyright © 2017年 noah. All rights reserved.
//

#import "UIBarButtonItem+Badge.h"
#import <objc/runtime.h>

@interface UIBarButtonItem (badge)

@property (strong, nonatomic) UILabel *badge;
@property (nonatomic) CGFloat OriginX, OriginY;

@end

NSString const *UIBarButtonItem_badgeKey = @"UIBarButtonItem_badgeKey";
NSString const *UIBarButtonItem_badgeLabel = @"UIBarButtonItem_badgeLabel";
NSString const *UIBarButtonItem_badgeOriginX = @"UIBarButtonItem_badgeOriginX";
NSString const *UIBarButtonItem_badgeOriginY = @"UIBarButtonItem_badgeOriginY";

@implementation UIBarButtonItem (Badge)

- (void)setBadge:(UILabel *)badge
{
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeLabel, badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UILabel *)badge
{
    
    UILabel *label = (UILabel *)objc_getAssociatedObject(self, &UIBarButtonItem_badgeLabel);
    //    CGRect customFrame = self.customView.frame;
    
    if (!label) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(self.OriginX, self.OriginY, 20, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = label.frame.size.width/2;
        label.clipsToBounds = YES;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:13.0];
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        label.layer.borderWidth = 2;
        [self setBadge:label];
        [self badgeInit];
        [self.customView addSubview:self.badge];
    }
    
    label.backgroundColor = [UIColor redColor];
    return label;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([badgeValue integerValue] == 0) {
        self.badge.hidden = YES;
    } else {
        self.badge.hidden = NO;
    }
    
    self.customView.backgroundColor = [UIColor greenColor];
    //    [self createBadgeLabel];
    //    [self.customView addSubview:self.badge];
    self.badge.text = self.badgeValue;
}

- (NSString *)badgeValue
{
    return objc_getAssociatedObject(self, &UIBarButtonItem_badgeKey);
}

- (void)badgeInit
{
    UIView *superview;
    CGFloat defaultOriginX = 0;
    if (self.customView) {
        superview = self.customView;
        defaultOriginX = superview.frame.size.width - self.badge.frame.size.width/2;
        // Avoids badge to be clipped when animating its scale
        superview.clipsToBounds = NO;
    } else if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        superview = [(id)self view];
        defaultOriginX = superview.frame.size.width - self.badge.frame.size.width;
    }
    [superview addSubview:self.badge];
    self.OriginX = defaultOriginX;
    self.OriginY = -4;
    
}

- (void)setOriginX:(CGFloat)OriginX
{
    objc_setAssociatedObject(self, &OriginX, [NSNumber numberWithFloat:OriginX], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

- (NSNumber *)OriginX
{
    return  objc_getAssociatedObject(self, &UIBarButtonItem_badgeOriginX);
}

- (void)setOriginY:(CGFloat)OriginY
{
    objc_setAssociatedObject(self, &OriginY, [NSNumber numberWithFloat:OriginY], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

- (NSNumber *)OriginY
{
    return objc_getAssociatedObject(self, &UIBarButtonItem_badgeOriginY);
}

- (void)updateBadgeFrame
{
    self.badge.frame = CGRectMake(self.OriginX, self.OriginY, 20, 20);
}

//- (NSString *)badgeValue
//{
//
//}

@end
