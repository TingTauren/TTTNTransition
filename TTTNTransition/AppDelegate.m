//
//  AppDelegate.m
//  TTTNTransition
//
//  Created by jiudun on 2020/4/26.
//  Copyright © 2020 jiudun. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow new];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.frame = [UIScreen mainScreen].bounds;
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    [self.window makeKeyAndVisible];
    
    ViewController *vc = [ViewController new];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    return YES;
}

@end
