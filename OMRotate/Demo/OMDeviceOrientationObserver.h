//
//  OMDeviceOrientationObserver.h
//  OMRotate
//
//  Created by ios on 2019/5/10.
//  Copyright © 2019 oymuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OMDeviceOrientationObserverBlock)(UIDeviceOrientation orientation);
typedef void(^OMDeviceOrientationObserverDescriptionBlock)(NSString *description);

@interface OMDeviceOrientationObserver : NSObject

- (void)startOrientationObserverChangeWithBlock: (OMDeviceOrientationObserverBlock)orientationBlock;
- (void)startOrientationObserverChangeWithDescriptionBlock: (OMDeviceOrientationObserverDescriptionBlock)orientationBlock;

- (void)removeOrientationObserver;

@end

NS_ASSUME_NONNULL_END
