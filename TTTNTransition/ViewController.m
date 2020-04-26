//
//  ViewController.m
//  TTTNTransition
//
//  Created by jiudun on 2020/4/26.
//  Copyright © 2020 jiudun. All rights reserved.
//

#import "ViewController.h"

#import "UINavigationController+TTTNTransition.h"
#import "UIViewController+TTTNTransition.h"
#import "TTTNTestTransition.h"

#import "NextViewController.h" // 下一页

@interface ViewController ()
@end

@implementation ViewController

#pragma mark ----- set get方法

#pragma mark ----- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100.0, 100.0, 100.0, 100.0);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self _tttn_handleViewConfig];
    [self _tttn_handleViewModelConfig];
}
#pragma mark ----- 处理回调
- (void)_tttn_handleViewConfig {
    __weak typeof(self) weakSelf = self;
    [self tttn_registerToInteractiveTransitionWithDirection:TTTNInteractiveGestureDirectionRight withEvent:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NextViewController *VC = [NextViewController new];
        VC.modalPresentationStyle = UIModalPresentationFullScreen;
//        [strongSelf.navigationController tttn_pushViewController:VC withAnimator:[TTTNTestTransition new]];
        [strongSelf tttn_presentViewController:VC withAnimator:[TTTNTestTransition new]];
    }];
}
- (void)_tttn_handleViewModelConfig {
    
}

#pragma mark ----- Click Methods
/// 按钮点击
- (void)buttonClick:(UIButton *)button {
    NextViewController *VC = [NextViewController new];
    VC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.navigationController tttn_pushViewController:VC withAnimator:[TTTNTestTransition new]];
    [self tttn_presentViewController:VC withAnimator:[TTTNTestTransition new]];
}

@end
