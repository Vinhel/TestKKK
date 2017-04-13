//
//  UIViewController+UIActivityIndicatorView.m
//  OBD2Sim_SystemTest
//
//  Created by Panasonic on 2016/01/13.
//  Copyright © 2016年 Panasonic. All rights reserved.
//

#import "UIViewController+UIActivityIndicatorView.h"
#import "SPCAlertViewController.h"
#import <objc/runtime.h>

static const char kAssocKey_Window;

@interface UIViewController_UIActivityIndicatorView ()
@property SPCAlertViewController *alertView;
@end

@implementation UIViewController_UIActivityIndicatorView{
    NSTimer *mTimer;
    NSTimeInterval startTime;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    // 縦画面固定
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _alertView = [SPCAlertViewController sharedManager];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem performSelector:@selector(setHidesBackButton:) withObject:0 afterDelay:0.3];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Indicator_StartWithTitle:(NSString *)title message:(NSString *)message{
    _IndicatorWindow = [[SPCIndicatorWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _IndicatorWindow.rootViewController = self;
    _IndicatorBackGroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _IndicatorBackGroundView.center = CGPointMake(_IndicatorWindow.frame.size.width/2, _IndicatorWindow.frame.size.height/2);
    _IndicatorBackGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    _IndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _IndicatorView.color = [UIColor darkGrayColor];
    
    _IndicatorMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 150)];
    _IndicatorMessageView.center = CGPointMake(_IndicatorBackGroundView.frame.size.width/2, _IndicatorBackGroundView.frame.size.height/2);
    _IndicatorMessageView.backgroundColor = [UIColor whiteColor];
    _IndicatorMessageView.layer.cornerRadius = 10.0f;
    _IndicatorMessageView.layer.masksToBounds = YES;
    _IndicatorMessageView.alpha = 0.95;
    
    _IndicatorMessageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300,50)];
    _IndicatorMessageTitle.text = title;
    _IndicatorMessageTitle.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
    _IndicatorMessage = [[UITextView alloc] initWithFrame:CGRectMake(0,0,250,100)];
    _IndicatorMessage.text = message;
    _IndicatorMessage.editable = NO;
    _IndicatorMessage.selectable = NO;
    _IndicatorMessage.font = [UIFont systemFontOfSize:14];
    
    _IndicatorTimer.text = @"";
    
    [_IndicatorWindow addSubview:_IndicatorBackGroundView];
    [_IndicatorBackGroundView addSubview:_IndicatorMessageView];
    [_IndicatorMessageView addSubview:_IndicatorMessageTitle];
    [_IndicatorMessageView addSubview:_IndicatorMessage];
    [_IndicatorMessageView addSubview:_IndicatorView];
    
    _IndicatorMessageTitle.center = CGPointMake(_IndicatorMessageView.frame.size.width/2, _IndicatorMessageView.frame.size.height/5);
    _IndicatorMessage.center = CGPointMake(_IndicatorMessageView.frame.size.width * 4/7, _IndicatorMessageView.frame.size.height * 3/5);
    _IndicatorView.center = CGPointMake(_IndicatorMessageView.frame.size.width/8, _IndicatorMessageView.frame.size.height * 3/5);
    
    //インジケータをセンターに表示する
    [_IndicatorView startAnimating];
    _IndicatorWindow.windowLevel = UIWindowLevelNormal + 1;
    [_IndicatorWindow makeKeyAndVisible];
    // ウィンドウのオーナーとしてアプリ自身に括りつけとく
    objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window, _IndicatorWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [UIView transitionWithView:_IndicatorWindow duration:.2 options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
        _IndicatorWindow.alpha = 1.;
        _IndicatorWindow.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setIndicatorViewTimer{
    _IndicatorTimer  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    _IndicatorTimer.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
    _IndicatorTimer.textColor = [UIColor grayColor];
    [_IndicatorMessageView addSubview:_IndicatorTimer];
    _IndicatorTimer.center = CGPointMake(_IndicatorMessageView.frame.size.width/2, _IndicatorMessageView.frame.size.height * 7/8);
    [self timerSetUp];
}

- (void)Indicator_End:(myCompletion) block{
//    [_IndicatorView removeFromSuperview];
//    _IndicatorView = nil;
//    [_IndicatorMessageView removeFromSuperview];
//    _IndicatorMessageView = nil;
//    [_IndicatorBackGroundView removeFromSuperview];
//    _IndicatorBackGroundView = nil;
    
    UIWindow *window = objc_getAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window);

    
    dispatch_async(dispatch_get_main_queue(), ^{
    [UIView transitionWithView:window
                      duration:0
                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
                    animations:^{
//                        UIView *view = window.rootViewController.view;
//                        
////                        for (UIView *v in view.subviews) {
////                            v.transform = CGAffineTransformMakeScale(.8, .8);
////                        }

                        window.alpha = 0;
                    }
                    completion:^(BOOL finished) {
                        
//                        [_IndicatorWindow.rootViewController.view removeFromSuperview];
//                        _IndicatorWindow.rootViewController = nil;
                        
                        // 上乗せしたウィンドウを破棄
                        objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        
                        // メインウィンドウをキーウィンドウにする
                        UIWindow *nextWindow = [[UIApplication sharedApplication].delegate window];
                        [nextWindow makeKeyAndVisible];
                        if (block) {
                            block(YES);
                        }
                    }];
    });
}

#pragma mark Timer
- (void)timerSetUp {
    // 現在の時間を取得
    _IndicatorTimer.text = NSLocalizedString(@"wait_dialog_timer_default", nil);
    startTime = [NSDate timeIntervalSinceReferenceDate];
    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                              target:self
                                            selector:@selector(timeCounter)
                                            userInfo:nil
                                             repeats:YES];
    
}

- (void)timeCounter{
    double cTime = [NSDate timeIntervalSinceReferenceDate] - startTime;
    // doubleで余りを出す計算をするときはfmod
    int hour = fmod((cTime/3600), 60);
    int minute = fmod((cTime/60), 60);
    int second = fmod(cTime, 60);
//    int milisecond = (cTime - floor(cTime))*100;
    _IndicatorTimer.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
}

#pragma mark UIAlertController Utility
- (void)commonAlertController:(NSString *)title message:(NSString *)message {
    
    [self Indicator_End:^(BOOL block) {
        if (block) {
//            [_alertView commonAlertControllerWithTitle:title message:message completion:nil];
            [_alertView commonAlertController:self Title:title message:message completion:nil];
        }
    }];
    
    return;
}

- (void)commonAlertController:(NSString *)title message:(NSString *)message completion:(void(^)())block_Ok{
    
    [self Indicator_End:^(BOOL block) {
        if (block) {
//            [_alertView commonAlertControllerWithTitle:title message:message completion:block_Ok];
            [_alertView commonAlertController:self Title:title message:message completion:block_Ok];
        }
    }];
    
    return;
}

- (void)commonAlertControllerWithTitle:(NSString *)title message:(NSString *)message completionCancel:(void(^)())block_Cancel completionOk:(void(^)())block_Ok{
    [self Indicator_End:^(BOOL block) {
        if (block) {
            [_alertView commonAlertControllerWithTitle:title message:message completionCancel:block_Cancel completionOk:block_Ok];
        }
    }];
    
    return;
}

- (void)popViewAlertController:(NSString *)title message:(NSString *)message {
    
    [self Indicator_End:^(BOOL block) {
        if (block) {
//            [_alertView commonAlertControllerWithTitle:title message:message completion:^{
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
            [_alertView commonAlertController:self Title:title message:message completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];

        }
    }];
    
    return;
}

- (void)popToMainMenuViewAlertController:(NSString *)title message:(NSString *)message {
    
    [self Indicator_End:^(BOOL block) {
        if (block) {
//            [_alertView commonAlertControllerWithTitle:title message:message completion:^{
//                [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
//            }];
             [_alertView commonAlertController:self Title:title message:message completion:^{
                [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
    
    return;
}



- (void)removeAllAlertController{
    [_alertView removeAllPoolObjects];
}

#pragma mark get CloudErrorMessage
- (NSString *)getErrorMessage:(NSDictionary *)errorDictionary{
    int errorCode = [[errorDictionary valueForKey:@"code"] intValue];
    NSString *description = [errorDictionary valueForKey:@"description"];
    
    NSString *message;
    
    switch (errorCode) {
        case FFLERROR_NETWORK_CONNECTION:
            message = NSLocalizedString(@"fflerror_network_connection_message", nil);
            break;
        case FFLERROR_MALFORMAT_RESPONSE:
            message = NSLocalizedString(@"fflerror_malformat_response_message", nil);
            break;
        case FFLERROR_MALFORMAT_REQUEST:
            message = NSLocalizedString(@"fflerror_malformat_request_message", nil);
            break;
        case FFLERROR_BADREQUEST:
            message = NSLocalizedString(@"fflerror_badrequest_message", nil);
            break;
        case FFLERROR_UNAUTHORIZED:
            message = NSLocalizedString(@"fflerror_unauthorized_message", nil);
            break;
        case FFLERROR_FORBIDDEN:
            message = NSLocalizedString(@"fflerror_forbidden_message", nil);
            break;
        case FFLERROR_NOTFOUND:
            message = NSLocalizedString(@"fflerror_notfound_message", nil);
            break;
        case FFLERROR_INTERNAL_SERVER_ERROR:
            message = NSLocalizedString(@"fflerror_internal_server_error_message", nil);
            break;
        case FFLERROR_SERVICE_UNAVAILABLE:
            message = description;
            break;
        case FFLERROR_REQUEST_TIMEOUT:
            message = NSLocalizedString(@"fflerror_request_timeout_message", nil);
            break;
        case FFLERROR_USER_REGISTRATION:
            message = NSLocalizedString(@"fflerror_user_registration_message", nil);
            break;
        case FFLERROR_VEHICLE_UNMATCH:
            message = NSLocalizedString(@"fflerror_vehicle_unmatch_message", nil);
            break;
        case FFLERROR_ECU_PROTOCOL_NOTFOUND:
            message = NSLocalizedString(@"fflerror_ecu_protocol_notfound_message", nil);
            break;
        case FFLERROR_OTHER:
        case FFLERROR_UNKNOWN:
            message = NSLocalizedString(@"fflerror_other_message", nil);
            break;
        default:
            break;
    }
    
    return message;
    
}

#pragma mark OBD2 Wrapper Control Delegate
- (void)didFailFWVersionAscending:(NSError *)error{
    NSString *message = [error.userInfo objectForKey:@"message"];
    [self popToMainMenuViewAlertController:NSLocalizedString(@"app_firmware_version_Confirmation", nil) message:message];
}
- (void)didFailFWVersionDesending:(NSError *)error{
    NSString *message = [error.userInfo objectForKey:@"message"];
    [self commonAlertController:NSLocalizedString(@"app_firmware_version_Confirmation", nil) message:message completion:^{
        
//        [vehicleMainMenuViewController showUpdateFirmWareView];
    }];
}
- (void)didFailWaitingTimeInfoMode:(NSError *)error{
    NSString *message = [error.userInfo objectForKey:@"message"];
    [self commonAlertController:NSLocalizedString(@"resetting_vehicle_title", nil) message:message completion:^{
       
        //        [vehicleMainMenuViewController showReSettingVehicleView];
    }];
}
- (void)didFailMacAdressNotSetting:(NSError *)error{
//    [[AppInfoManager sharedManager] setUserDefaultsIsSettingMacAdressFinished:NO];
//    [[AppInfoManager sharedManager] setUserDefaultsIsSettingVehicleFinished:NO];
    NSString *message = [error.userInfo objectForKey:@"message"];
    [self commonAlertController:NSLocalizedString(@"macaddress_setting_unfinished_Confirmation", nil) message:message completion:^{
//        VehicleMainMenuViewController *vehicleMainMenuViewController = self.navigationController.viewControllers[0];
//        [self.navigationController popToViewController:vehicleMainMenuViewController animated:NO];
//        [vehicleMainMenuViewController showSettingMacAdressFirstView];
    }];
}
- (void)didFailAlermMode:(NSError *)error{
    NSString *message = [error.userInfo objectForKey:@"message"];
    [self commonAlertController:NSLocalizedString(@"app_error_alerm_Confirmation", nil) message:message completion:^{
//        VehicleMainMenuViewController *vehicleMainMenuViewController = self.navigationController.viewControllers[0];
//        [self.navigationController popToViewController:vehicleMainMenuViewController animated:NO];
//        [vehicleMainMenuViewController showErrorInfoView];
    }];
}

@end
