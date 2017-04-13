//
//  PopAlertViewController.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/12.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "PopAlertViewController.h"

@interface PopAlertViewController ()
@property (nonatomic, strong) NSMutableArray *pool;
//@property (nonatomic, strong) UIView *containerView;
//@property (nonatomic, strong) UITextView *textView;
//@property (nonatomic, strong) UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) UIViewController *rootVtrl;
@property (strong, nonatomic) UIWindow *alertWindow;
@property (assign, nonatomic) BOOL usingNewWindow;
@property (strong, nonatomic) NSString *alertTitle, *alertImg, *alertMessage;
@property (nonatomic) AlertStyle alertStyle;

@end

@implementation PopAlertViewController
static PopAlertViewController *sharedData_ = nil;

+ (PopAlertViewController *)sharedManager
{
    if (!sharedData_) {
        sharedData_ = [PopAlertViewController new];
        sharedData_.pool = [[NSMutableArray alloc] init];
    }
    return sharedData_;
}

- (void)setupNewWindow
{
    UIWindow *alertWindow = [[UIWindow alloc]initWithFrame:kScreen_Bounds];
    alertWindow.windowLevel = UIWindowLevelAlert;
    alertWindow.backgroundColor = [UIColor clearColor];
    alertWindow.rootViewController = self;
    
}


- (void)showVtrl:(UIViewController *)vtrl title:(NSString *)titleString alertMessage:(NSString *)alertMessage alertType:(AlertStyle)type handler:(void (^ __nullable)(UIButton *button))handler
{
    _rootVtrl = vtrl;
    
    [_rootVtrl addChildViewController:self];
    [_rootVtrl.view addSubview:self.view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
