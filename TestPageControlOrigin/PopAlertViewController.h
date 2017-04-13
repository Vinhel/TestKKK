//
//  PopAlertViewController.h
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/13.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopAlertViewController : UIViewController

+ (PopAlertViewController *)sharedManager;


- (void)showVtrl:(UIViewController *)vtrl title:(NSString *)titleString alertMessage:(NSString *)alertMessage alertType:(AlertStyle)type handler:(void (^ __nullable)(UIButton *button))handler;

@end
