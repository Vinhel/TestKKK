//
//  NewAlertController.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/12.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "NewAlertController.h"
#import "SPCIndicatorWindow.h"
#import "PopAlertViewController.h"

@interface NewAlertController ()
@property (nonatomic) NSMutableArray *pool;
@end

@implementation NewAlertController

static NewAlertController *sharedData_ = nil;
+ (NewAlertController *)sharedManager {
    if (!sharedData_) {
        sharedData_ = [NewAlertController new];
        sharedData_.pool = [[NSMutableArray alloc] init];
    }
    return sharedData_;
}

- (void)commonAlertControllerWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)())block_Ok{
    
//    PopAlertViewController *alertController = [];
}

//- (PopAlertViewController *)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSArray *)buttonTitle cancelCompletion:(void(^)())block_Cancel  okCompletion:(void(^)())block_Ok{
//    
////    PopAlertViewController *alertController = [PopAlertViewController alloc]
//    
//}


+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message {
    if (self == [super init]) {
        
    }
    return self;
}

//- (id)initWithTarget:(id)target

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
