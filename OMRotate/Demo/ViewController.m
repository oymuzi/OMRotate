//
//  ViewController.m
//  OMRotate
//
//  Created by oymuzi on 2019/5/9.
//  Copyright © 2019 oymuzi. All rights reserved.
//

#import "ViewController.h"

#import "ViewController.h"
#import "LandscapeLeftViewController.h"
#import "LandscapeRightViewController.h"
#import "AllOrientationsViewController.h"
#import "LandscapeViewController.h"
#import "UIViewController+Rotate.h"
#import "OMDeviceOrientationObserver.h"


static NSString *kRuseIdentifier = @"reuse";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *scenes;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设备旋转的方式";
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 90);
    tipsLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    tipsLabel.font = [UIFont systemFontOfSize:15];
    tipsLabel.text = @"在用户方向锁锁定后，即使多方向也不能随设备方向旋转。如果做不到倒竖的情况，请检查工程设置或者AppDelegate中的设置，可参照文章的方式设置";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.numberOfLines = 0;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor colorWithWhite:0.9 alpha:1];
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = tipsLabel;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kRuseIdentifier];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.omSupportOrientations = OMRotateOrientationPortrait;
}


- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeOrientation {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    /************************
     1.UIDeviceOrientation为设备的方向
     2.理解UIDeviceOrientation中的方向，可以以home键或者底部的横线（下文仅用home键形容同等）为参照物，
     UIDeviceOrientationLandscapeRight就是设备向右旋转了，所以home键在左侧。
     反之UIDeviceOrientationLandscapeLeft就是设备向左旋转了，所以home键在右侧。
     *
     
     UIInterfaceOrientation为页面的方向,和UIDeviceOrientation有的一一对应：
     UIInterfaceOrientationUnknown            = UIDeviceOrientationUnknown,
     UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
     UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
     UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
     UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft
     
     其中UIInterfaceOrientationLandscapeLeft 等于 UIDeviceOrientationLandscapeRight的原因是设备向左旋转了，
     页面需要向右旋转才能和设备方向形成符合使用的场景。反之亦然。
     
     UIInterfaceOrientationMask
     UI
     
     ************************/
    
//    switch (orientation) {
//        case UIDeviceOrientationPortrait:
//            NSLog(@"设备处于竖的状态");
//            break;
//        case UIDeviceOrientationPortraitUpsideDown:
//            NSLog(@"设备处于倒竖的状态");
//            break;
//        case UIDeviceOrientationLandscapeLeft:
//            NSLog(@"设备处于横屏状态，且home键在右侧");
//            break;
//        case UIDeviceOrientationLandscapeRight:
//            NSLog(@"设备处于横屏状态，且home键做左侧");
//            break;
//        case UIDeviceOrientationFaceUp:
//            NSLog(@"设备处于屏幕朝上的状态");
//            break;
//        case UIDeviceOrientationFaceDown:
//            NSLog(@"设备处于屏幕朝下的状态");
//            break;
//        case UIDeviceOrientationUnknown:
//            NSLog(@"设备处于未知状态");
//        default:
//            break;
//    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.scenes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.scenes[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [[LandscapeLeftViewController alloc] init];
            break;
        case 1:
            vc = [[LandscapeRightViewController alloc] init];
            break;
        case 2:
            vc = [[LandscapeViewController alloc] init];
            break;
        case 3:
            vc = [[AllOrientationsViewController alloc] init];
            break;
        default:
            break;
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (NSArray *)scenes{
    if (!_scenes) {
        _scenes = @[@"强制横屏（控制键在右侧）", @"强制横屏（控制器键在左侧）", @"只支持横屏的两种情况根据设备方向切换", @"支持所有方向根据设备方向切换视图"];
    }
    return _scenes;
}



@end
