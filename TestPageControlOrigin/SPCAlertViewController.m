//
//  SPCAlertViewController.m
//  SONICPITController
//
//  Created by Panasonic on 2016/05/16.
//  Copyright © 2016年 Panasonic. All rights reserved.
//

#import "SPCAlertViewController.h"
#import "SPCIndicatorWindow.h"
#import "PopAlertView.h"
#import "PopAlertViewController.h"

@interface SPCAlertViewController()
@property (nonatomic) NSMutableArray *pool;
@end

@implementation SPCAlertViewController
// Obd2Wrapperをシングルトンとして設定する
static SPCAlertViewController *sharedData_ = nil;
+ (SPCAlertViewController *)sharedManager{
    if (!sharedData_) {
        sharedData_ = [SPCAlertViewController new];
        sharedData_.pool = [[NSMutableArray alloc] init];
    }
    return sharedData_;
}

- (void)commonAlertController:(UIViewController *)vtrl Title:(NSString *)title message:(NSString *)message completion:(void(^)())block_Ok{
    
//    UIAlertController *alertController = [self presentAlertControllerWithTitle:title message:message buttonTitle:@[NSLocalizedString(@"dialog_button_title_ok", nil)] cancelCompletion:nil okCompletion:block_Ok];
//    [self addPoolObject:alertController];
    
//    PopAlertView *popView = [PopAlertView defaultPopupView];
////    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
////    [window insertSubview:popView atIndex:0];
//    [vtrl.view addSubview:popView];
//    [popView showInfo:vtrl Title:title alertMessage:message alertType:AlertSuccess handler:^(UIButton *button) {
//        NSLog(@"ok");
//    }];
    
    
    PopAlertViewController *popVtrl = [PopAlertViewController sharedManager];
    [popVtrl showVtrl:vtrl title:title alertMessage:message alertType:AlertSuccess handler:^(UIButton *button) {
        
    }];
    
    
}

- (void)commonAlertControllerWithTitle:(NSString *)title message:(NSString *)message completionCancel:(void(^)())block_Cancel completionOk:(void(^)())block_Ok{
    
    UIAlertController *alertController = [self presentAlertControllerWithTitle:title message:message buttonTitle:@[NSLocalizedString(@"dialog_button_title_cancel", nil),NSLocalizedString(@"dialog_button_title_ok", nil)] cancelCompletion:block_Cancel okCompletion:block_Ok];
    [self addPoolObject:alertController];
    
}

- (void)addPoolObject:(UIAlertController *)object{
    if (_pool.count == 0) {
        [self presentedAlertController:object];
    }
    @synchronized (self) {
        [_pool addObject:object];
    }
}

- (void)removeAllPoolObjects{
    @synchronized (self) {
        [_pool removeAllObjects];
    }
    return;
}

- (UIAlertController *)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSArray *)buttonTitle cancelCompletion:(void(^)())block_Cancel  okCompletion:(void(^)())block_Ok{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *imgAlert = [UIAlertAction ]
    UIImage *warningImg = [UIImage imageNamed:@"btn_warning"];

    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title == nil ? @"": title message: message preferredStyle: UIAlertControllerStyleAlert];
//    
//    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle: cancelButtonTitle style: UIAlertActionStyleCancel handler: nil];
//    
//    [alert addAction: defaultAction];
    
    for (int i = 0; i < buttonTitle.count; i++) {
//        [alertcontroller addAction:[UIAlertAction actionWithTitle:buttonTitle[i] style:[buttonTitle[i] isEqualToString:NSLocalizedString(@"dialog_button_title_cancel", nil)] ? UIAlertActionStyleCancel: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self CompletionBlockWithAlertController:alertcontroller buttonTitle:buttonTitle[i] cancelCompletion:block_Cancel  okCompletion:block_Ok];
//        }]];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonTitle[i] style:[buttonTitle[i] isEqualToString:NSLocalizedString(@"dialog_button_title_cancel", nil)] ? UIAlertActionStyleCancel: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self CompletionBlockWithAlertController:alertcontroller buttonTitle:buttonTitle[i] cancelCompletion:block_Cancel  okCompletion:block_Ok];
        }];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 50)];
        view.backgroundColor = [UIColor redColor];
        
        [alertcontroller setValue:view forKey:@"__systemProvidedPresentationView"];
        [alertcontroller addAction:alertAction];
        
        alertcontroller.view.backgroundColor = [UIColor whiteColor];
    }
    return alertcontroller;
}

- (void)CompletionBlockWithAlertController:(UIAlertController *)alertController buttonTitle:(NSString *)buttonTitle cancelCompletion:(void(^)())block_Cancel  okCompletion:(void(^)())block_Ok{
    
    if ([buttonTitle isEqualToString:NSLocalizedString(@"dialog_button_title_cancel", nil)]) {
        if (block_Cancel) {
            block_Cancel();
        }
    } else {
        if (block_Ok) {
            block_Ok();
        }
    }
    [_pool removeObject:alertController];
    if (_pool.count > 0) {
        [self presentedAlertController:_pool[0]];
    }
}

//アラートを最前面にて表示させるメソッド
- (void)presentedAlertController:(UIAlertController *)alertController{
    UIWindow *window;
    UIWindow *tmpWindow;
    UIApplication *application = [UIApplication sharedApplication];
    for (UIWindow *view in [[application windows] reverseObjectEnumerator]) {
        tmpWindow = view;
        if (![tmpWindow isKindOfClass:[SPCIndicatorWindow class]]
            && ![[NSString stringWithFormat:@"%@", [tmpWindow class]] isEqualToString:@"UITextEffectsWindow"]
             && ![[NSString stringWithFormat:@"%@", [tmpWindow class]] isEqualToString:@"UIRemoteKeyboardWindow"]) {
            window = view;
            break;
        }
    }
    UIViewController *presentedViewController = window.rootViewController;
    while (presentedViewController.presentedViewController) {
        presentedViewController = presentedViewController.presentedViewController;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([presentedViewController isBeingDismissed]) {
            [presentedViewController.presentingViewController presentViewController:alertController animated:YES completion:nil];
        } else {
            [presentedViewController presentViewController:alertController animated:YES completion:nil];
        }
    });
}

@end
