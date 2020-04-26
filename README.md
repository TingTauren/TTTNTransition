# TTTNTransition
转场动画封装

自定义转场动画封装
继承动画类TTTNTransitionManager只需要实现动画逻辑；
使用[self tttn_presentViewController:"跳转视图" withAnimator:"动画对象"]
或者[self.navigationController tttn_pushViewController:"跳转视图" withAnimator:"动画对象"]方法实现跳转
就能实现自定义转场动画
也可以注册手势动画管理
在跳转视图中注册跳转手势控制[self tttn_registerToInteractiveTransitionWithDirection:TTTNInteractiveGestureDirectionRight withEvent:^{}]; 
在返回视图中注册返回[self tttn_registerBackInteractiveTransitionWithDirection:TTTNInteractiveGestureDirectionLeft withEvent:^{}]; 
具体实现参考demo
封装逻辑借鉴于https://github.com/wazrx/XWTransition
