//
//  SCNavigationController.h
//  TestPageControlOrigin
//
//  Created by noah on 2017/04/10.
//  Copyright © 2017年 noah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCNavigationController : UINavigationController

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, strong, readonly)UIPageViewController *pageController;
@property (nonatomic) NSInteger selectedIndex;

@end
