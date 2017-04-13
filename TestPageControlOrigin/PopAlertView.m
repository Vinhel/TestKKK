//
//  PopAlertView.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/12.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "PopAlertView.h"

@interface PopAlertView ()

@property (nonatomic) BOOL isShow;
@property (weak, nonatomic) IBOutlet UIView *TitleBgView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *TitleImgView;
@property (weak, nonatomic) IBOutlet UILabel *MessageView;
@property (strong, nonatomic) IBOutlet UIView *BGView;

@property (strong, nonatomic) UIViewController *rootVtrl;
@property (strong, nonatomic) UIWindow *alertWindow;
@property (assign, nonatomic) BOOL usingNewWindow;
@property (strong, nonatomic) NSString *alertTitle, *alertImg, *alertMessage;
@property (nonatomic) AlertStyle alertStyle;
//@property (strong, nonatomic) IBOutlet PopAlertView *popAlertView;

@end

@implementation PopAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
//        NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
//        self = [nibView firstObject];
       
        _BGView.frame = frame;
        [self addSubview:_BGView];
//        [self.superview addSubview:self];
        
        
        _usingNewWindow = NO;
        self.TitleImgView.image = [UIImage imageNamed:@"btn_warning"];
        self.MessageView.text = self.alertMessage;
        self.TitleLabel.text = self.alertTitle;
    }
    return self;
}


+ (instancetype)defaultPopupView{
    return [[PopAlertView alloc]initWithFrame:kScreen_Bounds];
}

//UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonTitle[i] style:[buttonTitle[i] isEqualToString:NSLocalizedString(@"dialog_button_title_cancel", nil)] ? UIAlertActionStyleCancel: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    [self CompletionBlockWithAlertController:alertcontroller buttonTitle:buttonTitle[i] cancelCompletion:block_Cancel  okCompletion:block_Ok];
//}];

- (void)showInfo:(UIViewController *)vtrl Title:(NSString *)titleString alertMessage:(NSString *)alertMessage alertType:(AlertStyle)type handler:(void (^ __nullable)(UIButton *button))handler
{
    self.hidden = NO;
    __weak typeof(self) weakSelf = self;
    if (!_isShow) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self.superview addSubview:self];
            weakSelf.alertMessage = alertMessage;
            weakSelf.alertTitle = titleString;
            weakSelf.alertStyle = type;
            
            weakSelf.TitleLabel.text = _alertTitle;
            weakSelf.MessageView.text = alertMessage;
            
            [self setTap];
            
        } completion:^(BOOL finished) {
            weakSelf.isShow = YES;
        }];
    }else {
//        [self dismissFromSuperView];
    }

}




- (void)setupAlertWithTitle:(NSString *)titleString alertMessage:(NSString *)alertMessage alertType:(AlertStyle)type handler:(void (^ __nullable)(UIButton *button))handler
{
    
}

- (void)setTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissFromSuperView)];
    [_BGView addGestureRecognizer:tap];
}


- (void)dismissFromSuperView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
        weakSelf.isShow = NO;
        weakSelf.hidden = YES;
    }];
}



@end
