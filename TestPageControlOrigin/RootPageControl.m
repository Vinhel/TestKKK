//
//  RootPageControl.m
//  TestPageControlOrigin
//
//  Created by noah on 2017/04/10.
//  Copyright © 2017年 noah. All rights reserved.
//

#import "RootPageControl.h"
#import "SegControl.h"
//#import "SCPageController.h"
#import "SCNavigationController.h"

@interface RootPageControl ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *segView;
@property (strong, nonatomic) SCNavigationController *navigationController;
@end

@implementation RootPageControl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        [self setupSegment];
    [self setupViewControllers];


}

- (void)setupSegment
{
    NSArray *imgArr = @[@"btn_user_off", @"btn_init_off", @"btn_mobile_off",@"btn_device_off"];
    
    __weak typeof(self) weakSelf = self;
    
    SegControl *_mySegmentControl = [[SegControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50) Items:imgArr selectedBlock:^(NSInteger index) {
        weakSelf.navigationController.selectedIndex = index;
        
    }];
    [_mySegmentControl selectIndex:0];
    _mySegmentControl.selectedIndex = 0;
    _mySegmentControl.backgroundColor = [UIColor redColor];
    [self.segView addSubview:_mySegmentControl];
    
    
}

- (void)setupViewControllers
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *a = [main instantiateViewControllerWithIdentifier:@"a"];
    a.view.backgroundColor = [UIColor redColor];
    
    UIViewController *b = [main instantiateViewControllerWithIdentifier:@"b"];
    b.view.backgroundColor = [UIColor orangeColor];
    
    UIViewController *c = [main instantiateViewControllerWithIdentifier:@"c"];
    c.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *d = [main instantiateViewControllerWithIdentifier:@"d"];
    d.view.backgroundColor = [UIColor greenColor];
    
    
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    _navigationController = [[SCNavigationController alloc]initWithRootViewController:pageController];
    _navigationController.navigationBar.hidden = YES;
    [_navigationController.viewControllerArray addObjectsFromArray:@[a, b, c, d]];
   
    [self addChildViewController:_navigationController];
    
    [self.containerView addSubview:_navigationController.view];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
