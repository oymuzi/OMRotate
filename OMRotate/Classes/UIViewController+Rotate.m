//
//  UIViewController+Rotate.m
//  OMRotate
//
//  Created by oymuzi on 2019/5/9.
//  Copyright © 2019 oymuzi. All rights reserved.
//

#import "UIViewController+Rotate.h"
#import <objc/runtime.h>

const NSString *ExtensionKey_SupportOrientations = @"ExtensionKey_SupportOrientations";

#pragma mark- UIViewController
@implementation UIViewController (Rotate)

#pragma mark- SET/GET
- (void)setOmSupportOrientations:(OMRotateOrientation)omSupportOrientations{
    objc_setAssociatedObject(self, &ExtensionKey_SupportOrientations, @(omSupportOrientations), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    /** 收集可支持的方向，在没有指定方向时，根据可支持的枚举值最小为进入页面时强转的方向*/
    NSMutableArray *orientationsCollections = [NSMutableArray array];
    
    if ((omSupportOrientations & OMRotateOrientationPortrait) == OMRotateOrientationPortrait ) {
        [orientationsCollections addObject:@(UIDeviceOrientationPortrait)];
    }
    if ((omSupportOrientations & OMRotateOrientationLandscapeLeft) == OMRotateOrientationLandscapeLeft) {
        [orientationsCollections addObject:@(UIDeviceOrientationLandscapeLeft)];
    }
    if ((omSupportOrientations & OMRotateOrientationLandscapeRight) == OMRotateOrientationLandscapeRight) {
        [orientationsCollections addObject:@(UIDeviceOrientationLandscapeRight)];
    }
    if ((omSupportOrientations & OMRotateOrientationLandscape) == OMRotateOrientationLandscape) {
        [orientationsCollections addObject:@(UIDeviceOrientationLandscapeLeft)];
        [orientationsCollections addObject:@(UIDeviceOrientationLandscapeRight)];
    }
    if ((omSupportOrientations & OMRotateOrientationPortraitUpsideDown) == OMRotateOrientationPortraitUpsideDown) {
        [orientationsCollections addObject:@(UIDeviceOrientationPortraitUpsideDown)];
    }
    if ((omSupportOrientations & OMRotateOrientationAll) == OMRotateOrientationAll) {
        [orientationsCollections addObject:@(UIDeviceOrientationPortrait)];
        [orientationsCollections addObject:@(UIDeviceOrientationLandscapeLeft)];
        [orientationsCollections addObject:@(UIDeviceOrientationLandscapeRight)];
        [orientationsCollections addObject:@(UIDeviceOrientationPortraitUpsideDown)];
    }
    if ((omSupportOrientations & OMRotateOrientationAllButUpsideDown)) {
        [orientationsCollections addObject:@(UIDeviceOrientationPortrait)];
        [orientationsCollections addObject:@(UIDeviceOrientationLandscapeLeft)];
        [orientationsCollections addObject:@(UIDeviceOrientationLandscapeRight)];
    }
    NSArray *orientationsArray = [orientationsCollections sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];
    UIDeviceOrientation forceOrientation = UIDeviceOrientationPortrait;
    if (![orientationsArray containsObject:@(forceOrientation)]) {
        if (orientationsArray.count == 0) {
            forceOrientation = UIDeviceOrientationPortrait;
        } else {
            forceOrientation = [orientationsArray.firstObject integerValue];
        }
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:@selector(setOrientation:)]];
    invocation.selector = NSSelectorFromString(@"setOrientation:");
    invocation.target = [UIDevice currentDevice];
    int initOrientation = forceOrientation;
    [invocation setArgument:&initOrientation atIndex:2];
    [invocation invoke];
    [UINavigationController attemptRotationToDeviceOrientation];
    [UITabBarController attemptRotationToDeviceOrientation];
}

- (OMRotateOrientation)omSupportOrientations{
    OMRotateOrientation orientations = [objc_getAssociatedObject(self, &ExtensionKey_SupportOrientations) integerValue];
    return orientations > 0 ? orientations : OMRotateOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self getInterfaceMaskFromRotateOrientation:self.omSupportOrientations];
}

- (BOOL)shouldAutorotate{
    return YES;
}

#pragma mark -Private
/** 根据设置的方向计算可支持的页面方向*/
- (UIInterfaceOrientationMask)getInterfaceMaskFromRotateOrientation: (OMRotateOrientation)rotateation{
    NSMutableArray *flags = [NSMutableArray array];
    if ((rotateation & OMRotateOrientationPortrait) == OMRotateOrientationPortrait) {
        [flags addObject:@(UIInterfaceOrientationMaskPortrait)];
    }
    if ((rotateation & OMRotateOrientationLandscapeLeft) == OMRotateOrientationLandscapeLeft) {
        [flags addObject:@(UIInterfaceOrientationMaskLandscapeRight)];
    }
    if ((rotateation & OMRotateOrientationLandscapeRight) == OMRotateOrientationLandscapeRight) {
        [flags addObject:@(UIInterfaceOrientationMaskLandscapeLeft)];
    }
    if ((rotateation & OMRotateOrientationPortraitUpsideDown) == OMRotateOrientationPortraitUpsideDown) {
        [flags addObject:@(UIInterfaceOrientationMaskPortraitUpsideDown)];
    }
    if ((rotateation & OMRotateOrientationLandscape) == OMRotateOrientationLandscape) {
        [flags addObject:@(UIInterfaceOrientationMaskLandscapeLeft)];
        [flags addObject:@(UIInterfaceOrientationMaskLandscapeRight)];
    }
    if ((rotateation & OMRotateOrientationAll) == OMRotateOrientationAll) {
        [flags addObject:@(UIInterfaceOrientationMaskPortrait)];
        [flags addObject:@(UIInterfaceOrientationMaskLandscapeRight)];
        [flags addObject:@(UIInterfaceOrientationMaskLandscapeLeft)];
        [flags addObject:@(UIInterfaceOrientationMaskPortraitUpsideDown)];
    }
    if ((rotateation & OMRotateOrientationAllButUpsideDown) == OMRotateOrientationAllButUpsideDown) {
        [flags addObject:@(UIInterfaceOrientationMaskPortrait)];
        [flags addObject:@(UIInterfaceOrientationMaskLandscapeRight)];
        [flags addObject:@(UIInterfaceOrientationMaskLandscapeLeft)];
    }
    /** 去重以及按照正常逻辑排序*/
    NSArray *distinctArray = [[NSSet setWithArray:flags] allObjects];
    NSArray *orderArray = [distinctArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [obj1 integerValue] > [obj2 integerValue];
    }];
    
    NSInteger bitResult = 0;
    for(int i = 0; i < orderArray.count; i++){
        bitResult |=  [orderArray[i] integerValue];
    }
    return bitResult;
}

@end

#pragma mark- UINavigationController

@implementation UINavigationController (Rotate)

- (BOOL)shouldAutorotate{
    return self.visibleViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.visibleViewController.supportedInterfaceOrientations;
}

@end

#pragma mark- UITabBarController

@implementation UITabBarController (Rotate)

- (BOOL)shouldAutorotate{
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)self.selectedViewController).visibleViewController.shouldAutorotate;
    }
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)self.selectedViewController).visibleViewController.supportedInterfaceOrientations;
    }
    return self.selectedViewController.supportedInterfaceOrientations;
}

@end

