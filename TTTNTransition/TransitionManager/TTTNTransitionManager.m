//
//  TTTNTransitionManager.m
//  THTestTransition
//
//  Created by jiudun on 2019/11/18.
//  Copyright © 2019 jiudun. All rights reserved.
//

#import "TTTNTransitionManager.h"

#import <objc/runtime.h>

#pragma mark ===== TTTNTransitionObject Class
typedef void(^TTTNTransitionAnimationConfig)(id<UIViewControllerContextTransitioning>transitionContext);

@interface _TTTNTransitionObject : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)_initObjectWithDuration:(NSTimeInterval)duration animationBlock:(void(^)(id<UIViewControllerContextTransitioning> transitionContext)) config;

@end

@implementation _TTTNTransitionObject {
    NSTimeInterval _duration;
    TTTNTransitionAnimationConfig _config;
}

#pragma mark ----- init Method
- (instancetype)_initObjectWithDuration:(NSTimeInterval)duration animationBlock:(void(^)(id<UIViewControllerContextTransitioning> transitionContext)) config {
    self = [super init];
    if (self) {
        _duration = duration;
        _config = config;
    }
    return self;
}

#pragma mark ----- UIViewControllerAnimatedTransitioning 代理方法
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    if (_config) {
        _config(transitionContext);
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

@end

#pragma mark ===== TTTNTransitionManager Class
@interface TTTNTransitionManager()
/** 跳转动画对象 */
@property (nonatomic, strong) _TTTNTransitionObject *toTransition;
/** 返回动画对象 */
@property (nonatomic, strong) _TTTNTransitionObject *backTransition;

/** 跳转手势对象 */
@property (nonatomic, strong) TTTNInteractiveTransition *toInteractive;
/** 返回手势对象 */
@property (nonatomic, strong) TTTNInteractiveTransition *backInteractive;

/** 转场方式 */
@property (nonatomic, assign) UINavigationControllerOperation operation;
@end

@implementation TTTNTransitionManager

#pragma mark ----- set get
- (_TTTNTransitionObject *)toTransition {
    if (_toTransition) return _toTransition;
    __weak typeof(self) weakSelf = self;
    _toTransition = [[_TTTNTransitionObject alloc] _initObjectWithDuration:_toDuration animationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf tttn_setToAnimation:transitionContext];
    }];
    return _toTransition;
}
- (_TTTNTransitionObject *)backTransition {
    if (_backTransition) return _backTransition;
    __weak typeof(self) weakSelf = self;
    _backTransition = [[_TTTNTransitionObject alloc] _initObjectWithDuration:_backDuration animationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf tttn_setBackAnimation:transitionContext];
    }];
    return _backTransition;
}
- (void)setToInteractive:(TTTNInteractiveTransition *)toInteractive {
    _toInteractive = toInteractive;
}
- (void)setBackInteractive:(TTTNInteractiveTransition *)backInteractive {
    _backInteractive = backInteractive;
}

#pragma mark ----- init Method
- (instancetype)init {
    self = [super init];
    if (self) {
        _toDuration = _backDuration = 0.5;
    }
    return self;
}

#pragma mark ----- 动画实现方法
// 跳转动画实现方法
- (void)tttn_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}
// 返回动画实现方法
- (void)tttn_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}

#pragma mark ----- UIViewControllerTransitioningDelegate 代理方法
// 非交互式 for Present
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.toTransition;
}
// 非交互式 for Dismiss
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.backTransition;
}
// 交互式 for Present
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return _toInteractive.isInteration ? _toInteractive : nil;
}
// 交互式 for Dismiss
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _backInteractive.isInteration ? _backInteractive : nil;
}

#pragma mark ----- UINavigationControllerDelegate 代理方法
// Navigation 非交互式 for Push or Pop
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    _operation = operation;
    return (operation == UINavigationControllerOperationPush ? self.toTransition : self.backTransition);
}
// Navigation 交互式 for Push or Pop
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    TTTNInteractiveTransition *inter = _operation == UINavigationControllerOperationPush ? self.toInteractive : self.backInteractive;
    return (inter.isInteration ? inter : nil);
}

#pragma mark ----- UITabBarControllerDelegate 代理方法
// TabBar 非交互式
- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return self.toTransition;
}
// TabBar 交互式
- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController {
    return (_toInteractive.isInteration ? _toInteractive : nil);
}

@end
