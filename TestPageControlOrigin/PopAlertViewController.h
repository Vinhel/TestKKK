//
//  PopAlertViewController.h
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/13.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertButton.h"

@interface PopAlertViewController : UIViewController
typedef void (^AlertActionBlock)(void);


+ (PopAlertViewController *)sharedManager;
- (instancetype)initWithNewWindow;

- (void)showVtrl:(UIViewController *)vtrl title:(NSString *)titleString alertMessage:(NSString *)alertMessage alertType:(AlertStyle)type completeText:(NSString *)completeText;

- (AlertButton *)addDoneButtonWithTitle:(NSString *)title;
- (AlertButton *)addButton:(NSString *)titleStr actionBlock:(AlertActionBlock)action;

@property (nonatomic, assign) BOOL shouldDismissOnTapOutside;//add gesture at backgroundView
//@property (nonatomic, assign) AlertStyle alertType;
@property (nonatomic, assign) BOOL isHeaderIcon;

@end
