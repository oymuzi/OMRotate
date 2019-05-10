//
//  AppDelegate.m
//  OMRotate
//
//  Created by oymuzi on 2019/5/9.
//  Copyright © 2019 oymuzi. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LandscapeLeftViewController.h"
#import "LandscapeRightViewController.h"
#import "LandscapeViewController.h"
#import "AllOrientationsViewController.h"
#import "UIViewController+Rotate.h"
#import "OMTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 第一种导航push子页面，在子页面设置方向OK
//    ViewController *vc = [ViewController new];
//    UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:vc];
//    self.window.rootViewController = rootVC;
//    [self.window makeKeyAndVisible];
    
    
    // 第二种方式 只有tabbar
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    OMTabBarController *tabBar = [[OMTabBarController alloc] init];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
