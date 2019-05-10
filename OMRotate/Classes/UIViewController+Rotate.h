//
//  UIViewController+Rotate.h
//  OMRotate
//
//  Created by oymuzi on 2019/5/9.
//  Copyright © 2019 oymuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 设备旋转支持的方向，为了更好的进行位运算，所以未采用系统设备方向枚举

 - OMRotateOrientationPortrait: 竖屏
 - OMRotateOrientationLandscapeLeft: 横屏，home键在右侧
 - OMRotateOrientationLandscapeRight: 横屏，home键做左侧
 - OMRotateOrientationLandscape: 横屏，包括OMRotateOrientationLandscapeLeft和OMRotateOrientationLandscapeRight
 - OMRotateOrientationPortraitUpsideDown: 倒立竖屏
 - OMRotateOrientationAll: 所有状态，两种横屏和两种竖屏的状态
 - OMRotateOrientationAllButUpsideDown: 除了倒立竖屏的其他所有方向
 */
typedef NS_ENUM(NSUInteger, OMRotateOrientation) {
    OMRotateOrientationPortrait             = (1 << 0),
    OMRotateOrientationLandscapeLeft        = (1 << 1),
    OMRotateOrientationLandscapeRight       = (1 << 2),
    OMRotateOrientationLandscape            = (1 << 3),
    OMRotateOrientationPortraitUpsideDown   = (1 << 4),
    OMRotateOrientationAll                  = (1 << 5),
    OMRotateOrientationAllButUpsideDown     = (1 << 6),
};

@interface UIViewController (Rotate)

/** 支持的方向，只有一个方向时即为强转。当有多个参数时，将以 竖屏-左转-右转-倒立竖屏 顺序来优先强转第一个方向*/
@property (assign, nonatomic) OMRotateOrientation omSupportOrientations;

@end


@interface UINavigationController (Rotate)

@end

@interface UITabBarController (Rotate)

@end
