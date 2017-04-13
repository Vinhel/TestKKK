//
//  PopAlertView.h
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/12.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopAlertView : UIView

+ (instancetype)defaultPopupView;

- (void)showInfo:(UIViewController *)vtrl Title:(NSString *)titleString alertMessage:(NSString *)alertMessage alertType:(AlertStyle)type handler:(void (^ __nullable)(UIButton *button))handler;

@end
