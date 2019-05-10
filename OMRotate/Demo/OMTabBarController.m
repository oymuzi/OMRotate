//
//  OMTabBarController.m
//  OMRotate
//
//  Created by ios on 2019/5/9.
//  Copyright © 2019 oymuzi. All rights reserved.
//

#import "OMTabBarController.h"
#import "LandscapeLeftViewController.h"
#import "LandscapeRightViewController.h"
#import "LandscapeViewController.h"
#import "AllOrientationsViewController.h"
#import "ViewController.h"
#import "UIViewController+Rotate.h"

@interface OMTabBarController ()<UITabBarControllerDelegate>

@end

@implementation OMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setUpChildVc:[LandscapeLeftViewController new] title:@"Left" image:nil selectImage:nil tag:0];
//    [self setUpChildVc:[LandscapeRightViewController new] title:@"Right" image:nil selectImage:nil tag:0];
//    [self setUpChildVc:[LandscapeViewController new] title:@"Landscape" image:nil selectImage:nil tag:0];
    [self setUpChildVc:[ViewController new] title:@"All" image:nil selectImage:nil tag:0];
    self.delegate = self;
    
}

- (void)setUpChildVc:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage tag:(NSInteger)tag {
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectImage;
    vc.tabBarItem.tag = tag;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    switch (tabBarController.selectedIndex) {
//        case 0:
//            viewController.omSupportOrientations = OMRotateOrientationLandscapeLeft;
//            break;
//        case 1:
//            viewController.omSupportOrientations = OMRotateOrientationLandscapeRight;
//            break;
//        case 2:
//            viewController.omSupportOrientations = OMRotateOrientationLandscape;
//            break;
//        case 3:
//            viewController.omSupportOrientations = OMRotateOrientationAll;
//            break;
//        default:
//            break;
//    }
      NSLog(@"%ld点击的是%@", tabBarController.selectedIndex,viewController);
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
