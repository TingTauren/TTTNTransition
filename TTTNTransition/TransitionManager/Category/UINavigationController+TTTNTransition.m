//
//  UINavigationController+TTTNTransition.m
//  THTestTransition
//
//  Created by jiudun on 2019/11/19.
//  Copyright © 2019 jiudun. All rights reserved.
//

#import "UINavigationController+TTTNTransition.h"

#import "UIViewController+TTTNTransition.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UINavigationController (TTTNTransition)

#pragma mark ----- Load Method
+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(pushViewController:animated:)), class_getInstanceMethod([self class], @selector(_tttn_pushViewController:animated:)));
}
- (void)_tttn_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    TTTNTransitionManager *animator = objc_getAssociatedObject(viewController, &k_TTTNManagerKey);
    if (animator) {
        self.delegate = animator;
    } else if ([self.delegate isKindOfClass:[TTTNTransitionManager class]]) {
        self.delegate = nil;
    }
    [self _tttn_pushViewController:viewController animated:animated];
}

#pragma mark ----- Public Method
/**
 *  通过指定的转场animator来push控制器，达到不同的转场效果
 *
 *  @param viewController 被push的控制器
 *  @param animator       转场Animator
 */
- (void)tttn_pushViewController:(UIViewController *)viewController withAnimator:(TTTNTransitionManager *)animator {
    if (!viewController) return;
    TTTNInteractiveTransition *toInteractive = objc_getAssociatedObject(self.topViewController, &k_TTTNToInteractiveKey);
    if (toInteractive) {
        [animator setValue:toInteractive forKey:@"toInteractive"];
    }
    if (animator) {
        objc_setAssociatedObject(viewController, &k_TTTNManagerKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self pushViewController:viewController animated:YES];
#warning 暂时不知道为什么要写这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self _tttn_swizzeViewControlelrDealloc];
    });
}

#pragma mark ----- Private Method
- (void)_tttn_swizzeViewControlelrDealloc{
    Class swizzleClass = [UIViewController class];
    @synchronized(swizzleClass) {
        SEL deallocSelector = sel_registerName("dealloc");
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        __weak typeof(self)weakSelf = self;
        id newDealloc = ^(__unsafe_unretained UIViewController *objSelf){
            [weakSelf _tttn_checkDelegate];
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = objSelf,
                    .super_class = class_getSuperclass(swizzleClass)
                };
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            } else {
                originalDealloc(objSelf, deallocSelector);
            }
        };
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        if (!class_addMethod(swizzleClass, deallocSelector, newDeallocIMP, "v@:")) {
            Method deallocMethod = class_getInstanceMethod(swizzleClass, deallocSelector);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_getImplementation(deallocMethod);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_setImplementation(deallocMethod, newDeallocIMP);
        }
    }
}
- (void)_tttn_checkDelegate{
    TTTNTransitionManager *animator = objc_getAssociatedObject(self.topViewController, &k_TTTNManagerKey);
    if (animator) {
        self.delegate = animator;
    }else{
        self.delegate = nil;
    }
}

@end
