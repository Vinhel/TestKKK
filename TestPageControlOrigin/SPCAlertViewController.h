//
//  SPCAlertViewController.h
//  SONICPITController
//
//  Created by Panasonic on 2016/05/16.
//  Copyright © 2016年 Panasonic. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ダイアログ表示を管理するためのシングルトンクラス
 */
@interface SPCAlertViewController : UIViewController
+ (SPCAlertViewController *)sharedManager;

/**
 ダイアログを表示

 @param title ダイアログのタイトル
 @param message ダイアログのメッセージ
 @param block_Ok OKボタン押下時のブロック関数
 */
- (void)commonAlertController:(UIViewController *)vtrl Title:(NSString *)title message:(NSString *)message completion:(void(^)())block_Ok;

/**
 ダイアログを表示

 @param title ダイアログのタイトル
 @param message ダイアログのメッセージ
 @param block_Cancel キャンセルボタン押下時のブロック関数
 @param block_Ok OKボタン押下時のブロック関数
 */
- (void)commonAlertController:(UIViewController *)vtrl Title:(NSString *)title message:(NSString *)message completion:(void(^)())block_Ok cancelBlock:(void(^)())block_Cancel;

/**
 キューに貯まっているダイアログ情報をクリアする関数
 */
- (void)removeAllPoolObjects;
@end
