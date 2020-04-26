//
//  TTTNTestTransition.m
//  TTTNTransition
//
//  Created by jiudun on 2020/4/26.
//  Copyright © 2020 jiudun. All rights reserved.
//

#import "TTTNTestTransition.h"

@implementation TTTNTestTransition

#pragma mark ----- 实现父类方法设置动画
- (void)tttn_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //获取目标动画的VC
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView = fromVc.view;
    UIView *toView = toVc.view;
    
    //截图
    UIView *toView_snapView = [toView snapshotViewAfterScreenUpdates:YES];
    
    CGRect left_frame = CGRectMake(0, 0, CGRectGetWidth(fromView.frame) / 2.0, CGRectGetHeight(fromView.frame));
    CGRect right_frame = CGRectMake(CGRectGetWidth(fromView.frame) / 2.0, 0, CGRectGetWidth(fromView.frame) / 2.0, CGRectGetHeight(fromView.frame));
    UIView *from_left_snapView = [fromView resizableSnapshotViewFromRect:left_frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    
    UIView *from_right_snapView = [fromView resizableSnapshotViewFromRect:right_frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    
    toView_snapView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
    from_left_snapView.frame = left_frame;
    from_right_snapView.frame = right_frame;
    
    //将截图添加到 containerView 上
    [containerView addSubview:toView_snapView];
    [containerView addSubview:from_left_snapView];
    [containerView addSubview:from_right_snapView];
    
    fromView.hidden = YES;
    
    [UIView animateWithDuration:self.toDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //左移
        from_left_snapView.frame = CGRectOffset(from_left_snapView.frame, -from_left_snapView.frame.size.width, 0);
        //右移
        from_right_snapView.frame = CGRectOffset(from_right_snapView.frame, from_right_snapView.frame.size.width, 0);
        
        toView_snapView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        fromView.hidden = NO;
        
        [from_left_snapView removeFromSuperview];
        [from_right_snapView removeFromSuperview];
        [toView_snapView removeFromSuperview];
        
        if ([transitionContext transitionWasCancelled]) {
            [containerView addSubview:fromView];
        } else {
            [containerView addSubview:toView];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    /*
    // 通过viewControllerForKey取出转场前后的两个控制器，\
    这里toVC就是vc1、fromVC就是vc2
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // snapshotViewAfterScreenUpdates可以对某个视图截图，\
    我们采用对这个截图做动画代替直接对vc1做动画，\
    因为在手势过渡中直接使用vc1动画会和手势有冲突，\
    如果不需要实现手势的话，就可以不是用截图视图了，大家可以自行尝试一下
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromVC.view.frame;
    //因为对截图做动画，vc1就可以隐藏了
    fromVC.view.hidden = YES;
    // 这里有个重要的概念containerView，\
    如果要对视图做转场动画，视图就必须要加入containerView中才能进行，\
    可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    // 将截图视图和vc2的view都加入ContainerView中
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    // 设置vc2的frame，因为这里vc2present出来不是全屏，\
    且初始的时候在底部，如果不设置frame的话默认就是整个屏幕咯，\
    这里containerView的frame就是整个屏幕
    toVC.view.frame = CGRectMake(0, containerView.bounds.size.height, containerView.bounds.size.width, 400);
    // 开始动画吧，使用产生弹簧效果的动画API
    [UIView animateWithDuration:self.toDuration delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        // 首先我们让vc2向上移动
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -400);
        // 然后让截图视图缩小一点即可
        tempView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        // 使用如下代码标记整个转场过程是否正常完成\
        [transitionContext transitionWasCancelled]代表手势是否取消了，\
        如果取消了就传NO表示转场失败，反之亦然，\
        如果不用手势present的话直接传YES也是可以的，\
        但是无论如何我们都必须标记转场的状态，\
        系统才知道处理转场后的操作，\
        否者认为你一直还在转场中，会出现无法交互的情况，切记！
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        // 转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
            // 失败后，我们要把vc1显示出来
            fromVC.view.hidden = NO;
            // 然后移除截图视图，因为下次触发present会重新截图
            [tempView removeFromSuperview];
        }
        // 清除相应控制器视图的mask
        [transitionContext viewForKey:UITransitionContextFromViewKey].layer.mask = nil;
        [transitionContext viewForKey:UITransitionContextToViewKey].layer.mask = nil;
    }];
     */
}
- (void)tttn_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //获取目标动画的VC
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView = fromVc.view;
    UIView *toView = toVc.view;
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:toView];
    UIView *newToView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
    
    //截图
    UIView *fromView_snapView = [fromView snapshotViewAfterScreenUpdates:YES];
    
    
    CGRect left_frame = CGRectMake(0, 0, CGRectGetWidth(toView.frame) / 2.0, CGRectGetHeight(toView.frame));
    CGRect right_frame = CGRectMake(CGRectGetWidth(fromView.frame) / 2.0, 0, CGRectGetWidth(fromView.frame) / 2.0, CGRectGetHeight(fromView.frame));
    UIView *to_left_snapView = [toView resizableSnapshotViewFromRect:left_frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    
    UIView *to_right_snapView = [newToView resizableSnapshotViewFromRect:right_frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    
    fromView_snapView.layer.transform = CATransform3DIdentity;
    to_left_snapView.frame = CGRectOffset(left_frame, -left_frame.size.width, 0);
    to_right_snapView.frame = CGRectOffset(right_frame, right_frame.size.width, 0);
    
    //将截图添加到 containerView 上
    [containerView addSubview:fromView_snapView];
    [containerView addSubview:to_left_snapView];
    [containerView addSubview:to_right_snapView];
    
//    fromView.hidden = YES;
    
    [UIView animateWithDuration:self.backDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //右移
        to_left_snapView.frame = CGRectOffset(to_left_snapView.frame, to_left_snapView.frame.size.width, 0);
        //左移
        to_right_snapView.frame = CGRectOffset(to_right_snapView.frame, -to_right_snapView.frame.size.width, 0);
        
        
        fromView_snapView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
        
    } completion:^(BOOL finished) {
//        fromView.hidden = NO;
        [fromView removeFromSuperview];
        [to_left_snapView removeFromSuperview];
        [to_right_snapView removeFromSuperview];
        [fromView_snapView removeFromSuperview];
        
        if ([transitionContext transitionWasCancelled]) {
            [containerView addSubview:fromView];
        } else {
            [containerView addSubview:toView];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    /*
    // 注意在dismiss的时候fromVC就是vc2了，toVC才是VC1了，注意这个关系
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 参照present动画的逻辑，present成功后，\
    containerView的最后一个子视图就是截图视图，我们将其取出准备动画
    UIView *tempView = [transitionContext containerView].subviews[0];
    // 动画吧
    [UIView animateWithDuration:self.backDuration animations:^{
        // 因为present的时候都是使用的transform，\
        这里的动画只需要将transform恢复就可以了
        fromVC.view.transform = CGAffineTransformIdentity;
        tempView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            // 失败了标记失败
            [transitionContext completeTransition:NO];
        }else{
            // 如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            [tempView removeFromSuperview];
        }
        
        // 清除相应控制器视图的mask
        [transitionContext viewForKey:UITransitionContextFromViewKey].layer.mask = nil;
        [transitionContext viewForKey:UITransitionContextToViewKey].layer.mask = nil;
    }];
     */
}

@end
