//
//  UIViewController+TTTNTransition.m
//  THTestTransition
//
//  Created by jiudun on 2019/11/19.
//  Copyright © 2019 jiudun. All rights reserved.
//

#import "UIViewController+TTTNTransition.h"

#import "TTTNInteractiveTransition.h"

#import <objc/runtime.h>

NSString *const k_TTTNManagerKey =
@"TTTNManagerKey"; // 管理类关联key
NSString *const k_TTTNToInteractiveKey =
@"TTTNToInteractiveKey"; // 手势动画关联key

@implementation UIViewController (TTTNTransition)

#pragma mark ----- Public Methods
/**
*  通过指定的转场animator来present控制器
*
*  @param viewController 被modal出的控制器
*  @param animator       转场animator
*/
- (void)tttn_presentViewController:(UIViewController *)viewController withAnimator:(TTTNTransitionManager *)animator {
    if (!viewController) return;
    if (!animator) animator = [TTTNTransitionManager new];
    viewController.transitioningDelegate = animator;
    TTTNInteractiveTransition *toInteractive = objc_getAssociatedObject(self, &k_TTTNToInteractiveKey);
    if (toInteractive) { // 注册了手势管理对象
        // KVO设置跳转手势动画属性值
        [animator setValue:toInteractive forKey:@"toInteractive"];
    }
    objc_setAssociatedObject(viewController, &k_TTTNManagerKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC); // 设置属性关联,把管理类关联到跳转过后的VC,方便跳转VC获取管理类管理转场动画
    [self presentViewController:viewController animated:YES completion:nil];
}

/**
 注册跳转动画手势
 * direction 手势方向
 * eventConfig 开始手势响应(调用跳转方法)
 */
- (void)tttn_registerToInteractiveTransitionWithDirection:(TTTNInteractiveGestureDirection)direction withEvent:(dispatch_block_t)eventConfig {
    if (!eventConfig) return;
    TTTNInteractiveTransition *interactive = [TTTNInteractiveTransition new];
    interactive.eventBlcok = eventConfig;
    [interactive tttn_addEdgePageGestureWithView:self.view direction:direction];
    // 设置属性关联,把手势对象关联到VC,方便获取对象是指给管理类管理转场动画
    objc_setAssociatedObject(self, &k_TTTNToInteractiveKey, interactive, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/**
 注册返回动画手势
 * direction 手势方向
 * eventConfig 开始手势响应(调用跳转方法)
 */
- (void)tttn_registerBackInteractiveTransitionWithDirection:(TTTNInteractiveGestureDirection)direction withEvent:(dispatch_block_t)eventConfig {
    if (!eventConfig) return;
    TTTNInteractiveTransition *interactive = [TTTNInteractiveTransition new];
    interactive.eventBlcok = eventConfig;
    [interactive tttn_addEdgePageGestureWithView:self.view direction:direction];
    TTTNTransitionManager *animator = objc_getAssociatedObject(self, &k_TTTNManagerKey);
    if (animator) {
        // KVO设置返回手势动画属性值
        [animator setValue:interactive forKey:@"backInteractive"];
    }
}

@end
