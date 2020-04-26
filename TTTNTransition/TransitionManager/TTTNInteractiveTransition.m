//
//  TTTNInteractiveTransition.m
//  THTestTransition
//
//  Created by jiudun on 2019/11/19.
//  Copyright © 2019 jiudun. All rights reserved.
//

#import "TTTNInteractiveTransition.h"

@interface TTTNInteractiveTransition()<UIGestureRecognizerDelegate>
/** 手势视图 */
@property (nonatomic, weak) UIView *panView;
/** 滑动方向 */
@property (nonatomic, assign) TTTNInteractiveGestureDirection direction;
@end

@implementation TTTNInteractiveTransition

#pragma mark ----- Public Method
/**
 添加侧滑手势

 @param view 添加手势的view
 @param direction 手势的方向
 */
- (void)tttn_addEdgePageGestureWithView:(UIView *)view direction:(TTTNInteractiveGestureDirection)direction {
    _panView = view;
    _direction = direction;
    
    UIPanGestureRecognizer *panGestrue = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestrueClick:)];
    panGestrue.delegate = self;
    [view addGestureRecognizer:panGestrue];
}

#pragma mark ----- UIGestureRecognizerDelegate
// 共存  A手势或者B手势 代理方法里shouldRecognizeSimultaneouslyWithGestureRecognizer   有一个是返回YES，就能共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
// 判断是否响应手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_edgeSpacing <= 0) {
        return YES;
    }
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    BOOL should = NO;
    switch (_direction) {
        case TTTNInteractiveGestureDirectionLeft: {
            should = (point.x >= (gestureRecognizer.view.frame.size.width - _edgeSpacing));
            break;
        }
        case TTTNInteractiveGestureDirectionRight: {
            should = (point.x <= _edgeSpacing);
            break;
        }
        case TTTNInteractiveGestureDirectionTop: {
            should = (point.y >= (gestureRecognizer.view.frame.size.height - _edgeSpacing));
            break;
        }
        case TTTNInteractiveGestureDirectionBottom: {
            should = (point.y <= _edgeSpacing);
            break;
        }
    }
    return should;
}

#pragma mark ----- Click Method
static CGPoint _checkDirection;
static BOOL _isChange = NO;
- (void)panGestrueClick:(UIPanGestureRecognizer *)gesturen {
    // 计算用户手指划了多远
    CGPoint gesturenPoint = [gesturen translationInView:self.panView];
    CGFloat spacing = 0.0;
    switch (_direction) {
        case TTTNInteractiveGestureDirectionLeft:
        case TTTNInteractiveGestureDirectionRight:
            spacing = gesturenPoint.x;
            break;
        case TTTNInteractiveGestureDirectionTop:
        case TTTNInteractiveGestureDirectionBottom:
            spacing = gesturenPoint.y;
            break;
        default:
            break;
    }
    CGFloat progress = fabs(spacing) / (self.panView.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    switch (gesturen.state) {
        case UIGestureRecognizerStateBegan: {
            _checkDirection = gesturenPoint;
            _isInteration = YES;
            if (self.eventBlcok) {
                self.eventBlcok();
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // 更新 interactive transition 的进度
            _isChange = [self _tttn_checkDirectionWithX:gesturenPoint];
            if (_isChange) {
                [self updateInteractiveTransition:progress];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 完成或者取消过渡
            if (_isChange) {
                if (progress > 0.5) {
                    [self finishInteractiveTransition];
                } else {
                    [self cancelInteractiveTransition];
                }
            } else {
                [self cancelInteractiveTransition];
            }
            _isChange = NO;
            _checkDirection = CGPointZero;
            _isInteration = NO;
            break;
        }
        default:
            break;
    }
}

#pragma mark ----- Private Methods
- (BOOL)_tttn_checkDirectionWithX:(CGPoint)point {
    BOOL isSuccess = NO;
    switch (_direction) {
        case TTTNInteractiveGestureDirectionLeft:{
            if (point.x > _checkDirection.x) {
                isSuccess = YES;
            }
        }
            break;
        case TTTNInteractiveGestureDirectionRight:{
            if (point.x < _checkDirection.x) {
                isSuccess = YES;
            }
        }
            break;
        case TTTNInteractiveGestureDirectionTop:{
            if (point.y > _checkDirection.y) {
                isSuccess = YES;
            }
        }
            break;
        case TTTNInteractiveGestureDirectionBottom:{
            if (point.y < _checkDirection.y) {
                isSuccess = YES;
            }
        }
            break;
        default:
            break;
    }
    return isSuccess;
}

@end
