//
//  UIViewController+UIActivityIndicatorView.h
//  OBD2Sim_SystemTest
//
//  Created by Panasonic on 2016/01/13.
//  Copyright © 2016年 Panasonic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCIndicatorWindow.h"

#define FFLERROR_NETWORK_CONNECTION 0
#define FFLERROR_MALFORMAT_RESPONSE 1
#define FFLERROR_MALFORMAT_REQUEST 2
#define FFLERROR_BADREQUEST 400
#define FFLERROR_UNAUTHORIZED 401
#define FFLERROR_FORBIDDEN 403
#define FFLERROR_NOTFOUND 404
#define FFLERROR_INTERNAL_SERVER_ERROR 500
#define FFLERROR_SERVICE_UNAVAILABLE 503
#define FFLERROR_REQUEST_TIMEOUT 504
#define FFLERROR_USER_REGISTRATION 600
#define FFLERROR_VEHICLE_UNMATCH 601
#define FFLERROR_ECU_PROTOCOL_NOTFOUND 602
#define FFLERROR_OTHER 777
#define FFLERROR_UNKNOWN 999

typedef void(^myCompletion)(BOOL);

/**
 TCP通信用のダイアログ表示やインジケータ表示機能を追加した継承元のUIViewController
 */
@interface UIViewController_UIActivityIndicatorView : UIViewController

/**
 インジケータ表示時に表示するグレーの透過バックグラウンドビュー
 */
@property UIView *IndicatorBackGroundView;

/**
 インジケータ表示時に使用する通信中メッセージを表示するビュー
 */
@property UIView *IndicatorMessageView;

/**
 インジケータ表示時のタイトル
 */
@property UILabel *IndicatorMessageTitle;

/**
 インジケータ表示時のメッセージ
 */
@property UITextView *IndicatorMessage;

/**
 インジケータ表示時に経過時間を表示するためのラベル
 */
@property UILabel *IndicatorTimer;

/**
 インジケータ
 */
@property UIActivityIndicatorView *IndicatorView;

/**
 インジケータビュー表示用にWindowの階層を変更
 */
@property SPCIndicatorWindow *IndicatorWindow;

/**
 インジケータの表示開始関数

 @param title インジケータに表示するタイトル
 @param message インジケータに表示するメッセージ
 */
- (void)Indicator_StartWithTitle:(NSString *)title message:(NSString *)message;

/**
 インジケータの表示終了関数

 @param block インジケータの処理終了時に追加で処理するブロック関数
 */
- (void)Indicator_End:(myCompletion) block;

/**
 インジケータの経過時間を表示させる関数
 */
- (void)setIndicatorViewTimer;

/**
 ダイアログ表示(画面遷移なし)

 @param title ダイアログのタイトル
 @param message ダイアログのメッセージ
 */
- (void)commonAlertController:(NSString *)title message:(NSString *)message;

/**
 ダイアログ表示(画面遷移なし)

 @param title ダイアログのタイトル
 @param message ダイアログのメッセージ
 @param block_Ok OKボタン押下時に処理するブロック関数
 */
- (void)commonAlertController:(NSString *)title message:(NSString *)message completion:(void(^)())block_Ok;

/**
 ダイアログ表示(画面遷移なし)

 @param title ダイアログのタイトル
 @param message ダイアログのメッセージ
 @param block_Cancel キャンセルボタン押下時に処理するブロック関数
 @param block_Ok OKボタン押下時に処理するブロック関数
 */
- (void)commonAlertControllerWithTitle:(NSString *)title message:(NSString *)message completionCancel:(void(^)())block_Cancel completionOk:(void(^)())block_Ok;

/**
 ダイアログ表示(前画面へ画面遷移)

 @param title ダイアログのタイトル
 @param message ダイアログのメッセージ
 */
- (void)popViewAlertController:(NSString *)title message:(NSString *)message;

/**
 ダイアログ表示(メインメニューへ画面遷移)

 @param title ダイアログのタイトル
 @param message ダイアログのメッセージ
 */
- (void)popToMainMenuViewAlertController:(NSString *)title message:(NSString *)message;

- (void)dismissToMainMenuViewAlertController:(NSString *)title message:(NSString *)message;

/**
 ダイアログの表示(設定画面へ画面遷移)

 @param title ダイアログのタイトル
 @param message ダイアログのメッセージ
 */
- (void)popToSettingMenuViewAlertController:(NSString *)title message:(NSString *)message;

/**
 キューに溜まっているダイアログを削除
 */
- (void)removeAllAlertController;

/**
 クラウド通信APIより返却されたエラーディクショナリーに保存されたエラーコードに対して指定の文字列を返却する関数

 @param errorDictionary クラウドより返却されたエラーオブジェクト
 @return エラーコードに紐づくダイアログに表示する文字列を返却
 */
- (NSString *)getErrorMessage:(NSDictionary *)errorDictionary;

/**
 ファームウェアの更新が必要な場合にOBD2WrapperControlクラスよりコールバックで返却される関数

 @param error エラーコードとメッセージを含んだエラーオブジェクト
 */
- (void)didFailFWVersionAscending:(NSError *)error;

/**
 アプリの更新が必要な場合にOBD2WrapperControlクラスよりコールバックで返却される関数
 
 @param error エラーコードとメッセージを含んだエラーオブジェクト
 */
- (void)didFailFWVersionDesending:(NSError *)error;

/**
 OBD2アダプタが時刻設定待ちモードの場合にOBD2WrapperControlクラスよりコールバックで返却される関数
 
 @param error エラーコードとメッセージを含んだエラーオブジェクト
 */
- (void)didFailWaitingTimeInfoMode:(NSError *)error;

/**
 OBD2アダプタがMACアドレス未登録の場合にOBD2WrapperControlクラスよりコールバックで返却される関数
 
 @param error エラーコードとメッセージを含んだエラーオブジェクト
 */
- (void)didFailMacAdressNotSetting:(NSError *)error;

/**
 OBD2アダプタがアラームモードの場合にOBD2WrapperControlクラスよりコールバックで返却される関数
 
 @param error エラーコードとメッセージを含んだエラーオブジェクト
 */
- (void)didFailAlermMode:(NSError *)error;
@end
