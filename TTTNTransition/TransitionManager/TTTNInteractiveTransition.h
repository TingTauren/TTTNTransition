//
//  TTTNInteractiveTransition.h
//  THTestTransition
//
//  Created by jiudun on 2019/11/19.
//  Copyright © 2019 jiudun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 手势的方向枚举
 - TTTNInteractiveGestureDirectionTop:屏幕上方
 - TTTNInteractiveGestureDirectionLeft:屏幕左侧
 - TTTNInteractiveGestureDirectionBottom: 屏幕下方
 - TTTNInteractiveGestureDirectionRight: 屏幕右侧
 */
typedef NS_ENUM(NSInteger, TTTNInteractiveGestureDirection) {
    TTTNInteractiveGestureDirectionTop    = 0,
    TTTNInteractiveGestureDirectionLeft,
    TTTNInteractiveGestureDirectionBottom,
    TTTNInteractiveGestureDirectionRight
};

@interface TTTNInteractiveTransition : UIPercentDrivenInteractiveTransition

/** 是否满足侧滑手势交互 */
@property (nonatomic,assign) BOOL isInteration;
/** 边缘间距 */
@property (nonatomic, assign) CGFloat edgeSpacing;

/**
 转场时的操作 不用传参数的block
 */
@property (nonatomic,copy) dispatch_block_t eventBlcok;

/**
 添加侧滑手势

 @param view 添加手势的view
 @param direction 手势的方向
 */
- (void)tttn_addEdgePageGestureWithView:(UIView *)view direction:(TTTNInteractiveGestureDirection)direction;

@end

NS_ASSUME_NONNULL_END
