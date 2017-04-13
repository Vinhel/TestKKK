//
//  MainViewController.m
//  TestPageControlOrigin
//
//  Created by Panasonic on 2017/04/12.
//  Copyright © 2017年 Panasonic. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+UIActivityIndicatorView.h"
//#import "PopAlertView.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)LeftItemAction:(id)sender {
    [self commonAlertController:@"title" message:@"message" completion:^{
        
    }];
    
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
