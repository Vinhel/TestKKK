//
//  PopAlertViewController.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/13.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "PopAlertViewController.h"
#import "AlertButton.h"
#import "AlertTextView.h"

@interface PopAlertViewController ()
typedef void (^DismissBlock)(void);
typedef void (^DismissAnimationCompletionBlock)(void);
typedef void (^ShowAnimationCompletionBlock)(void);
typedef NSDictionary* (^CompleteButtonFormatBlock)(void);

@property (nonatomic, strong) NSMutableArray *pool;
@property (strong, nonatomic) UIViewController *rootVtrl;
@property (strong, nonatomic) UIWindow *alertWindow, *previousWindow;

@property (strong, nonatomic) NSString *alertTitle, *alertImg, *alertMessage;
@property (nonatomic) AlertStyle alertStyle;
//@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) UIView *containerView, *backgroundView, *headerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) AlertTextView *messageTextView;


@property (assign, nonatomic) BOOL usingNewWindow, headImg;
@property (nonatomic) CGFloat windowHeight;
@property (nonatomic) CGFloat windowWidth;
@property (nonatomic) CGFloat subTitleHeight;//message Height

//gesture
@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;

//inputs like textview textfield
@property (strong, nonatomic) NSMutableArray *inputs;



//frame
@property (assign, nonatomic) CGFloat kTitleTop;

@property (copy, nonatomic) DismissAnimationCompletionBlock dismissAnimationCompletionBlock;
@property (copy, nonatomic)
ShowAnimationCompletionBlock showAnimationCompletionBlock;
@property (nonatomic, copy) CompleteButtonFormatBlock completeButtonFormatBlock;

@end

@implementation PopAlertViewController

@synthesize kTitleTop;

static PopAlertViewController *sharedData_ = nil;

+ (PopAlertViewController *)sharedManager
{
    if (!sharedData_) {
        sharedData_ = [[PopAlertViewController alloc]init];
        sharedData_.pool = [[NSMutableArray alloc] init];
    }
    return sharedData_;
}

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"NSCoding not supported"
                                 userInfo:nil];
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

- (instancetype)initWithWindowWidth:(CGFloat)windowWidth
{
    self = [super init];
    if (self)
    {
        [self setupViewWindowWidth:windowWidth];
    }
    return self;
}

- (instancetype)initWithNewWindow
{
    self = [self initWithWindowWidth:kScreen_Width*0.9];
    if(self)
    {
        [self setupNewWindow];
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
    
    // Check for larger top circle icon flag
    
    // Check if the rootViewController is modal, if so we need to get the modal size not the main screen size
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
    _backgroundView.frame = kScreen_Bounds;

    _containerView.backgroundColor = [UIColor whiteColor];
    
    _headerView.frame = CGRectMake(0, 0, _windowWidth, 50);
    _titleLabel.frame = CGRectMake(12, 0, _windowWidth-12, 50);
    
    // Text fields
    CGFloat y = (_titleLabel.text == nil) ? kTitleTop : kTitleTop + _titleLabel.frame.size.height;
    _messageTextView.frame = CGRectMake(12.0f, y, _windowWidth - 24.0f, _subTitleHeight);
    
    if (!_titleLabel && !_messageTextView) {
        y = 0.0f;
    }
    
    y += _subTitleHeight + 14.0f;
    for (AlertTextView *textField in _inputs)
    {
        textField.frame = CGRectMake(12.0f, y, _windowWidth - 24.0f, textField.frame.size.height);
        textField.layer.cornerRadius = 3.0f;
        y += textField.frame.size.height + 10.0f;
    }


}



- (void)setupViewWindowWidth:(CGFloat)width
{
    self.windowWidth = width;
    self.windowHeight = width/5*4;
    
    self.subTitleHeight = 90;
    
    //Init
    
    _titleLabel = [[UILabel alloc]init];
    _headerView = [[UIView alloc]init];
    _containerView = [[UIView alloc]init];
    _backgroundView = [[UIView alloc]initWithFrame:kScreen_Bounds];
    _messageTextView = [[AlertTextView alloc]init];
    
  
    //titleLabel
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = [UIFont boldSystemFontOfSize:27.0];
    _titleLabel.frame = CGRectMake(12.0f, kTitleTop, _containerView.frame.size.width - 12.0, 50);
    _titleLabel.textColor = [UIColor whiteColor];
    
    
    //Header View
    _headerView.backgroundColor = RGBA(201, 0, 4, 1.0);
    
    //containerView
    _containerView.backgroundColor = [UIColor whiteColor];
    
    //backgroundView
    _backgroundView.backgroundColor = RGBA(0, 0, 0, 0.8);
    
    
    
    
    //add subview
    [_containerView addSubview:_headerView];
    [_headerView addSubview:_titleLabel];
    [_containerView addSubview:_messageTextView];
    [self.view addSubview:_containerView];
    
    [_containerView layoutIfNeeded];
    
}

- (void)setupNewWindow
{
    UIWindow *alertWindow0 = [[UIWindow alloc] initWithFrame:kScreen_Bounds];
    alertWindow0.windowLevel = UIWindowLevelAlert;
    alertWindow0.backgroundColor = [UIColor clearColor];
    alertWindow0.rootViewController = self;
    self.alertWindow = alertWindow0;
    
    self.usingNewWindow = YES;
}


- (void)showVtrl:(UIViewController *)vtrl title:(NSString *)titleString alertMessage:(NSString *)alertMessage alertType:(AlertStyle)type handler:(void (^ __nullable)(UIButton *button))handler
{
    
    if(_usingNewWindow)
    {
        // Save previous window
        self.previousWindow = [UIApplication sharedApplication].keyWindow;
        self.backgroundView.frame = _alertWindow.bounds;
        
        // Add window subview
        [_alertWindow addSubview:_backgroundView];
        
    }else {
        _rootVtrl = vtrl;
        
        self.backgroundView.frame = _alertWindow.bounds;
        [_rootVtrl addChildViewController:self];
        [_rootVtrl.view addSubview:self.backgroundView];
    }
   
    
    self.view.alpha = 0.0f;
    [self setBackground];
    
    
    if(_usingNewWindow)
    {
        [_alertWindow makeKeyAndVisible];
    }
    
    
     [self showView];
    
    self.titleLabel.text = titleString;
    _messageTextView.text = alertMessage;
    
    
}

#pragma mark -- Background
- (void)setBackground
{
    _backgroundView.backgroundColor = RGBA(0, 0, 0, 0.6);

}



#pragma mark -- Show View

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


#pragma mark -- Button
- (AlertButton *)addDoneButtonWithTitle:(NSString *)title
{
    AlertButton *btn = [self addButton:title];
    
    if (_completeButtonFormatBlock != nil)
    {
        btn.completeButtonFormatBlock = _completeButtonFormatBlock;
    }
    
    [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (AlertButton *)addButton:(NSString *)titleStr
{
    AlertButton *btn = [[AlertButton alloc] initWithFrame:CGRectMake(0, 0, 120, 36)];
    btn.layer.masksToBounds = YES;
    [btn setTitle:titleStr forState:UIControlStateNormal];
    
    return btn;
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
