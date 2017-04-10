//
//  SCNavigationController.m
//  TestPageControlOrigin
//
//  Created by noah on 2017/04/10.
//  Copyright © 2017年 noah. All rights reserved.
//

#import "SCNavigationController.h"

@interface SCNavigationController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic, strong) UIViewController *p_displayingViewController;

@end

@implementation SCNavigationController
@synthesize viewControllerArray;
@synthesize viewControllers;
@synthesize pageController;

- (UIViewController *)curViewController
{
    if (self.viewControllers.count > self.currentPageIndex) {
        return  [self.viewControllers objectAtIndex:self.currentPageIndex];
    }else {
        return nil;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    viewControllerArray = @[].mutableCopy;
    self.currentPageIndex = 0;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!pageController) {
        [self setupPageViewController];
        [self showViewControllerOfIndex:_currentPageIndex];
    }
    
    
    for (UIView *view in self.pageController.view.subviews) {
        if ([view isKindOfClass: UIScrollView.class]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            [scrollView setScrollEnabled:NO];
        }
    }
}

- (void)setupPageViewController
{
    if ([self.topViewController isKindOfClass:[UIPageViewController class]]) {
        pageController = (UIPageViewController *)self.topViewController;
        pageController.delegate = self;
        pageController.dataSource = self;
        [pageController setViewControllers:@[[viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            
        }];
        
    }
}


#pragma mark -- PageViewController DataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    _p_displayingViewController = viewController;
    NSInteger index = [self indexOfController:_p_displayingViewController];
    if (index == NSNotFound || (index == 0)) {
        return nil;
    }
    
    index --;
    return [viewControllerArray objectAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    _p_displayingViewController = viewController;
    NSInteger index = [self indexOfController:_p_displayingViewController];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    index ++;
    return [viewControllerArray objectAtIndex:index];
}


#pragma mark -- UIPageController Delegate
　　 
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    _p_displayingViewController = nil;
    if (completed) {
        self.currentPageIndex = [self indexOfController:[pageController.viewControllers lastObject]];
    }
}


- (NSInteger)indexOfController:(UIViewController *)inputController
{
    for (int i = 0; i < self.viewControllerArray.count; i++) {
        if ([self.viewControllerArray[i] isKindOfClass:[inputController class]]) {
            return i;
        }
    }
    return NSNotFound;
}

- (void)showViewControllerOfIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    if (_selectedIndex > _currentPageIndex) {
        for (int i = (int)_currentPageIndex + 1; i <= _selectedIndex; i++) {
            [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                if (finished) {
                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    } else if (_selectedIndex < _currentPageIndex)
    {
        for (int i = (int)_currentPageIndex - 1; i >= _selectedIndex; i--) {
            [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                if (finished) {
                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    [self.viewControllerArray enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL * stop) {
        
    }];
}

- (void)updateCurrentPageIndex:(int)newIndex
{
    self.currentPageIndex = newIndex;
}


- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self showViewControllerOfIndex:selectedIndex];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
