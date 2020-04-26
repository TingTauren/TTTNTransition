//
//  TTTNTransitionManager.h
//  THTestTransition
//
//  Created by jiudun on 2019/11/18.
//  Copyright © 2019 jiudun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTTNInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTNTransitionManager : NSObject<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>
// Present Dismiss 转场代理 UIViewControllerTransitioningDelegate
// Push Pod 转场代理 UINavigationControllerDelegate
// Tabbar 转场代理 UITabBarControllerDelegate

// 跳转转场时间 默认0.5
@property (nonatomic, assign) NSTimeInterval toDuration;
// 返回转场时间 默认0.5
@property (nonatomic, assign) NSTimeInterval backDuration;

// 跳转动画实现方法
- (void)tttn_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
// 返回动画实现方法
- (void)tttn_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;

@end

NS_ASSUME_NONNULL_END
