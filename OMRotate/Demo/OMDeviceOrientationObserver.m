//
//  OMDeviceOrientationObserver.m
//  OMRotate
//
//  Created by ios on 2019/5/10.
//  Copyright © 2019 oymuzi. All rights reserved.
//

#import "OMDeviceOrientationObserver.h"

@interface OMDeviceOrientationObserver()

@property (copy, nonatomic) OMDeviceOrientationObserverBlock observerBlock;
@property (copy, nonatomic) OMDeviceOrientationObserverDescriptionBlock obeserverDescriptionBlock;

@end

@implementation OMDeviceOrientationObserver

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)changeOrientation{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    NSString *description = @"";
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            description = @"设备处于竖的状态";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            description = @"设备处于倒竖的状态";
            break;
        case UIDeviceOrientationLandscapeLeft:
            description = @"设备处于横屏状态，且home键在右侧";
            break;
        case UIDeviceOrientationLandscapeRight:
            description = @"设备处于横屏状态，且home键做左侧";
            break;
        case UIDeviceOrientationFaceUp:
            description = @"设备处于屏幕朝上的状态";
            break;
        case UIDeviceOrientationFaceDown:
            description = @"设备处于屏幕朝下的状态";
            break;
        case UIDeviceOrientationUnknown:
            description = @"设备处于未知状态";
        default:
            break;
    }
    if (self.observerBlock) {
        self.observerBlock(orientation);
    }
    if (self.obeserverDescriptionBlock) {
        self.obeserverDescriptionBlock(description);
    }
}

- (void)startOrientationObserverChangeWithBlock:(OMDeviceOrientationObserverBlock)orientationBlock{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    self.observerBlock = orientationBlock;
}

- (void)startOrientationObserverChangeWithDescriptionBlock:(OMDeviceOrientationObserverDescriptionBlock)orientationBlock{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    self.obeserverDescriptionBlock = orientationBlock;
}

- (void)removeOrientationObserver{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.observerBlock = nil;
    self.obeserverDescriptionBlock = nil;
}

@end
