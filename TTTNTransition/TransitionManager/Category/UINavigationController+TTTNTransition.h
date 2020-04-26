//
//  UINavigationController+TTTNTransition.h
//  THTestTransition
//
//  Created by jiudun on 2019/11/19.
//  Copyright © 2019 jiudun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTTNTransitionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (TTTNTransition)

/**
 *  通过指定的转场animator来push控制器，达到不同的转场效果
 *
 *  @param viewController 被push的控制器
 *  @param animator       转场Animator
 */
- (void)tttn_pushViewController:(UIViewController *)viewController withAnimator:(TTTNTransitionManager *)animator;

@end

NS_ASSUME_NONNULL_END
