//
//  PopAlertViewController.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/13.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "PopAlertViewController.h"

@interface PopAlertViewController ()
typedef void (^DismissBlock)(void);
typedef void (^DismissAnimationCompletionBlock)(void);
typedef void (^ShowAnimationCompletionBlock)(void);

@property (nonatomic, strong) NSMutableArray *pool;
@property (strong, nonatomic) UIViewController *rootVtrl;
@property (strong, nonatomic) UIWindow *alertWindow, *previousWindow;

@property (strong, nonatomic) NSString *alertTitle, *alertImg, *alertMessage;
@property (nonatomic) AlertStyle alertStyle;
//@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) UIView *containerView, *backgroundView, *headerView;
@property (strong, nonatomic) UILabel *titleLabel;


@property (assign, nonatomic) BOOL usingNewWindow, headImg;
@property (nonatomic) CGFloat windowHeight;
@property (nonatomic) CGFloat windowWidth;



//frame
@property (assign, nonatomic) CGFloat kTitleTop;

@property (copy, nonatomic) DismissAnimationCompletionBlock dismissAnimationCompletionBlock;
@property (copy, nonatomic)
ShowAnimationCompletionBlock showAnimationCompletionBlock;
@end

@implementation PopAlertViewController

@synthesize kTitleTop;

static PopAlertViewController *sharedData_ = nil;

+ (PopAlertViewController *)sharedManager
{
    if (!sharedData_) {
        sharedData_ = [PopAlertViewController new];
        sharedData_.pool = [[NSMutableArray alloc] init];
    }
    return sharedData_;
}

- (instancetype)init
{
    if (self = [super init]) {
//        [self setupNewWindow];
//        self.usingNewWindow = YES;
        [self setupViewWindowWidth:kScreen_Width*0.9];
    }
    return self;
}

#pragma mark - Modal Validation

- (BOOL)isModal
{
    return (_rootVtrl != nil && _rootVtrl.presentingViewController);
}

#pragma mark - View Cycle
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGSize sz = kScreen_Bounds.size;
    if (_headImg) {
        
    }
    if([self isModal] && !_usingNewWindow)
    {
        sz = _rootVtrl.view.frame.size;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        // iOS versions before 7.0 did not switch the width and height on device roration
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            CGSize ssz = sz;
            sz = CGSizeMake(ssz.height, ssz.width);
        }
    }
    
    // Set new background frame
    CGRect newBackgroundFrame = self.backgroundView.frame;
    newBackgroundFrame.size = sz;
    self.backgroundView.frame = newBackgroundFrame;
    
    // Set new main frame
    CGRect r;
    if (self.view.superview != nil)
    {
        // View is showing, position at center of screen
        r = CGRectMake((sz.width-_windowWidth)/2, (sz.height-_windowHeight)/2, _windowWidth, _windowHeight);
    }
    else
    {
        // View is not visible, position outside screen bounds
        r = CGRectMake((sz.width-_windowWidth)/2, -_windowHeight, _windowWidth, _windowHeight);
    }
    
    
    // Set frames
    self.view.frame = r;
    _containerView.frame = CGRectMake(0.0f, 0.0f, _windowWidth, _windowHeight);
    _containerView.backgroundColor = [UIColor colorWithRed:189 green:127 blue:110 alpha:0.8];
    


    

    
    
}

- (void)setupViewWindowWidth:(CGFloat)width
{
    self.windowWidth = width;
    self.windowHeight = width/5*4;
    
    //Init
    
    _titleLabel = [[UILabel alloc]init];
    _headerView = [[UIView alloc]init];
    _containerView = [[UIView alloc]init];
    
    [self.view addSubview:_containerView];
    [_containerView addSubview:_titleLabel];
    
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = [UIFont boldSystemFontOfSize:27.0];
    _titleLabel.frame = CGRectMake(12.0f, kTitleTop, _containerView.frame.size.width - 12.0, 50);
    
    
    _containerView.backgroundColor = [UIColor whiteColor];
    
    
    
}

- (void)setupNewWindow
{
    UIWindow *alertWin = [[UIWindow alloc]initWithFrame:kScreen_Bounds];
    alertWin.windowLevel = UIWindowLevelAlert;
    alertWin.backgroundColor = [UIColor clearColor];
    alertWin.rootViewController = self;
    self.alertWindow = alertWin;
    self.usingNewWindow = YES;
}


- (void)showVtrl:(UIViewController *)vtrl title:(NSString *)titleString alertMessage:(NSString *)alertMessage alertType:(AlertStyle)type handler:(void (^ __nullable)(UIButton *button))handler
{
    
    if (_usingNewWindow) {
        self.previousWindow = [UIApplication sharedApplication].keyWindow;
        self.backgroundView.frame = _alertWindow.frame;
        
        [self.previousWindow addSubview:self.view];
    }else {
        _rootVtrl = vtrl;
        
        self.backgroundView.frame = kScreen_Bounds;
        [_rootVtrl addChildViewController:self];
        [_rootVtrl.view addSubview:self.backgroundView];
    }
    [self showView];
    
    self.titleLabel.text = titleString;
    
    
}

- (void)showView
{
    self.backgroundView.alpha = 0.0f;
    self.view.alpha = 0.0f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backgroundView.alpha = 1.0;
        self.view.alpha = 1.0f;
        if ( _showAnimationCompletionBlock ){
            self.showAnimationCompletionBlock();
        }
    });
}

#pragma mark -- Hide View
- (void)hideView
{
    self.view.alpha = 1.0f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self fadeOutWithDuration:0];
    });

}

- (void)fadeOutWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.backgroundView.alpha = 0.0f;
        self.view.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self.backgroundView removeFromSuperview];
        if (_usingNewWindow)
        {
            // Remove current window
            [self.alertWindow setHidden:YES];
            self.alertWindow = nil;
        }
        else
        {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
        if ( _dismissAnimationCompletionBlock ){
            self.dismissAnimationCompletionBlock();
        }
    }];
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
