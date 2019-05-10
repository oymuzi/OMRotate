//
//  LandscapeRightViewController.m
//  OMRotate
//
//  Created by ios on 2019/5/9.
//  Copyright © 2019 oymuzi. All rights reserved.
//

#import "LandscapeRightViewController.h"
#import "UIViewController+Rotate.h"
#import "OMDeviceOrientationObserver.h"

@interface LandscapeRightViewController ()

@property (strong, nonatomic) OMDeviceOrientationObserver *observer;

@end

@implementation LandscapeRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"横屏";
    
    UILabel *supportOrientationLabel = [[UILabel alloc] init];
    supportOrientationLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    supportOrientationLabel.text = @"当前页面只支持横屏，且home键在左侧";
    supportOrientationLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:supportOrientationLabel];
    
    UILabel *orientationStatusLabel = [[UILabel alloc] init];
    orientationStatusLabel.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    orientationStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:orientationStatusLabel];
    
    OMDeviceOrientationObserver *observer = [[OMDeviceOrientationObserver alloc] init];
    [observer startOrientationObserverChangeWithDescriptionBlock:^(NSString * _Nonnull description) {
        orientationStatusLabel.text = description;
    }];
    self.observer = observer;
}

- (void)dealloc
{
    [self.observer removeOrientationObserver];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.omSupportOrientations = OMRotateOrientationLandscapeRight;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
