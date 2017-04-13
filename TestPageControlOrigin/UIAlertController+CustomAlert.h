//
//  UIAlertController+CustomAlert.h
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/12.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (CustomAlert)

@property (nonatomic, strong) UIImageView *titleImgView;
@property (nonatomic, strong) UIView *titleBgView;

- (void)alertWithTitle:(NSString *)title message:(NSString *)message;

@end
