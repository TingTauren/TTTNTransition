//
//  UIViewController+TTTNTransition.h
//  THTestTransition
//
//  Created by jiudun on 2019/11/19.
//  Copyright © 2019 jiudun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTTNTransitionManager.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const k_TTTNManagerKey; // 管理类关联key
extern NSString * const k_TTTNToInteractiveKey; // 手势动画关联key

@interface UIViewController (TTTNTransition)

/**
 *  通过指定的转场animator来present控制器
 *
 *  @param viewController 被modal出的控制器
 *  @param animator       转场animator
 */
- (void)tttn_presentViewController:(UIViewController *)viewController withAnimator:(TTTNTransitionManager *)animator;

/**
 注册跳转动画手势
 * direction 手势方向
 * eventConfig 开始手势响应(调用跳转方法)
 */
- (void)tttn_registerToInteractiveTransitionWithDirection:(TTTNInteractiveGestureDirection)direction withEvent:(dispatch_block_t)eventConfig;

/**
 注册返回动画手势
 * direction 手势方向
 * eventConfig 开始手势响应(调用跳转方法)
 */
- (void)tttn_registerBackInteractiveTransitionWithDirection:(TTTNInteractiveGestureDirection)direction withEvent:(dispatch_block_t)eventConfig;

@end

NS_ASSUME_NONNULL_END
