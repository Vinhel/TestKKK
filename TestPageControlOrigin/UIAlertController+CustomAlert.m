//
//  UIAlertController+CustomAlert.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/12.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "UIAlertController+CustomAlert.h"
#import <objc/runtime.h>

NSString const *Alert_TitleBgView = @"UIAlert_TitleBgView";
NSString const *Alert_TitleImgView = @"UIAlert_TitleImgView";

@implementation UIAlertController (CustomAlert)
@dynamic titleBgView, titleImgView;

- (void)alertInit
{
    UIView *superView = self.view;
    
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    [self alertInit];
}

- (void)setTitleImgView:(UIImageView *)titleImgView
{
    objc_setAssociatedObject(self, &Alert_TitleImgView, titleImgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)titleImgView
{
   return objc_getAssociatedObject(self, &Alert_TitleImgView);
}





@end
