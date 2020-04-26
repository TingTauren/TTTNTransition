//
//  NextViewController.m
//  TTTNTransition
//
//  Created by jiudun on 2020/4/26.
//  Copyright © 2020 jiudun. All rights reserved.
//

#import "NextViewController.h"

#import "UIViewController+TTTNTransition.h"
#import "TTTNTestTransition.h"

@interface NextViewController ()
@end

@implementation NextViewController

#pragma mark ----- set get方法

#pragma mark ----- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _tttn_handleViewConfig];
    [self _tttn_handleViewModelConfig];
    
    self.view.backgroundColor = [UIColor cyanColor];
    self.view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100.0, 100.0, 100.0, 100.0);
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
#pragma mark ----- 处理回调
- (void)_tttn_handleViewConfig {
    __weak typeof(self) weakSelf = self;
    [self tttn_registerBackInteractiveTransitionWithDirection:TTTNInteractiveGestureDirectionLeft withEvent:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (void)_tttn_handleViewModelConfig {
    
}

#pragma mark ----- Click Methods
- (void)buttonClick:(UIButton *)button {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
