//
//  AlertViewController.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/12.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()
@property (nonatomic) NSMutableArray *pool;
@end

static AlertViewController *sharedData_ = nil;
@implementation AlertViewController

+ (AlertViewController *)sharedManager
{
    if (!sharedData_) {
        sharedData_ = [AlertViewController new];
        sharedData_.pool = [[NSMutableArray alloc] init];
    }
    return sharedData_;
}




@end
