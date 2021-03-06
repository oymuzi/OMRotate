

谨慎能捕千秋蝉,小心驶得万年船								——《庄子语录》



### 前言

方向旋转在日常App上基本都会用到，用的时候可能会因为赶工期而以实现功能为主，认真思考了为啥去这样做有没有bug或者后续的开发中是否还会用到。不只是屏幕旋转，还有其他的东西也是这样，导致之前做的时候感觉也会了，实际开发的时候，有时就会像喝断片一样。

此文的目的是为了加深理解和巩固一下知识记忆，另外此文也附带了对屏幕旋转的一些理解和一些需要注意的地方，小心驶得万年船哇。



### 三个方向的枚举

1. UIDeviceOrientation：是描述设备的方向，含有以下值：

   ~~~objective-c
   UIDeviceOrientationUnknown,
   UIDeviceOrientationPortrait,            // 竖立
   UIDeviceOrientationPortraitUpsideDown,  // 倒竖
   UIDeviceOrientationLandscapeLeft,       // 横屏，home键在右边
   UIDeviceOrientationLandscapeRight,      // 横屏，home键在左边
   UIDeviceOrientationFaceUp,              // 屏幕朝上
   UIDeviceOrientationFaceDown             // 屏幕朝下
     
   其中UIDeviceOrientationLandscapeLeft可以这样理解：以home键或Home Indicator（下文仅用home键形容同等）为参照物，UIDeviceOrientationLandscapeRight就是设备向右旋转了，所以home键在左侧。反之亦然。
   ~~~

2. UIInterfaceOrientation：描述的是页面的方向，含有以下值：

   ~~~objective-c
   UIInterfaceOrientationUnknown            = UIDeviceOrientationUnknown,
   UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
   UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
   UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
   UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft
   
   其中之所以UIInterfaceOrientationLandscapeLeft和UIDeviceOrientationLandscapeRight等价，就是因为设备旋转后，页面需要向反方向旋转才能符合正常使用的规范。
   ~~~

3. UIInterfaceOrientationMask: 作用是在指定的视图控制器中支持的页面多种方向的集合，含有以下值：

   ~~~
   UIInterfaceOrientationMaskPortrait = (1 << UIInterfaceOrientationPortrait),
   UIInterfaceOrientationMaskLandscapeLeft = (1 << UIInterfaceOrientationLandscapeLeft),
   UIInterfaceOrientationMaskLandscapeRight = (1 << UIInterfaceOrientationLandscapeRight),
   UIInterfaceOrientationMaskPortraitUpsideDown = (1 << UIInterfaceOrientationPortraitUpsideDown),
   
   UIInterfaceOrientationMaskLandscape = (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
   
   UIInterfaceOrientationMaskAll = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown),
   
   UIInterfaceOrientationMaskAllButUpsideDown = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
   ~~~



第一个枚举是用来描述设备的方向；第二个枚举是用来描述页面的方向；第三个枚举则是用来描述页面可支持的方向集合。另外设备面朝上和朝下两种情况通常不做考虑。



### 获取设备的方向

1. 可以通过获取设备的orientation属性值来判断当前设备的方向。

2. 有些时候需要通过监听来获取设备的方向，需要通过使用通知来监听，但是有个注意的地方就是从设备方向改变的通知中获取数据前后需要调用一对方法：`beginGeneratingDeviceOrientationNotifications`和` endGeneratingDeviceOrientationNotifications`

   ~~~objective-c
   // 通过通知名：UIDeviceOrientationDidChangeNotification 来获取
   // 调用生成设备方向变化的通知方法
   [[NSNotificationCenter defaultCenter] beginGeneratingDeviceOrientationNotifications];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
   
   // ...
   
   // 移除通知前需调用结束生成设备方向变化的通知
   [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   ~~~

3. 有点需要非常注意的是：**如果用户在控制栏锁定了屏幕方向，收不到方向改变的通知，包括即使你所在的试图控制器支持多个方向，也只会强转第一个方向。**
4. 还有一点就是状态栏的问题，如果没有设置状态的样式，在强转横屏时将会隐藏状态栏。
5. 另外使用此种方式时可能会收到状态`UIDeviceOrientationUnknown`，比如第一次进入app的过程中以及只支持竖屏的情况时，但是一般跳转时会有几次的方向回调的，当出现这个状态时可以返回竖屏的状态。

### 设备旋转的设置的几种方式

1. 因为设备支持的方向旋转有几种方式
   - 项目工程的设置：在工程的General和info.plist中设置都是一样的，因为数据都存储在info.plist中
   - AppDelegate中的设置：通过在代理中- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window设置支持的方向。
   - 单个视图控制控制器的设置：需要其父控制器UITabBarController或UINavigationController也支持当前控制器的方向才行。
2. 上述方式设置可以简单理解为：**项目工程的设置为App默认设置；AppDelegate中的设置为你当前设置的，所以会覆盖项目工程的设置；而单个视图控制器的设置为当前页面设置，但是受AppDelegate中的影响。**
3. 默认创建应用将会默认勾选除 Portrait Upside down这个选项外的方向。
4. 即使你一个都不勾选，应用还是会默认以 Portrait 的方式。

### 设备的旋转的应用场景分析

##### 场景分析

1. 我们在日常开发的过程中或多或少会接触到以下几种情况：
   - 个别页面需要强制横屏，其他页面只展示竖屏
   - 个别页面需要强制横屏，另个别页面可以自动根据设备旋转，其他页面均为竖屏。
   - 页面都为竖屏或者横屏(这种不做探讨)
2. 从上述可知我们需要支持个别页面的强制方向或自动旋转的需求。



##### 强制横屏的解决方案

1. 我们已知大部分页面都是竖屏的，所以我们勾选支持的方向应只勾选 Portrait。

2. 在AppDelegate中的设置可以不进行设置或者只返回UIInterfaceOrientationMaskPortrait，将会以默认的竖屏展示。

3. 我们在需要强制竖屏或横屏的页面进行重写`shouldAutorotate`和`supportedInterfaceOrientations`，且前者的值应为**YES**，否则可能会出现无法强转的问题。

4. 下面是强制设备向左旋转后横屏的代码：

   ```
   NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:@selector(setOrientation:)]];
   invocation.selector = NSSelectorFromString(@"setOrientation:");
   invocation.target = [UIDevice currentDevice];
   int initOrientation = UIDeviceOrientationLandscapeLeft; // 这里我们需要传的值是设备方向值
   [invocation setArgument:&initOrientation atIndex:2];
   [invocation invoke];
   
   /** 下面两行代码是为了当前导航栏或底部栏旋转至设备方向*/
   [UINavigationController attemptRotationToDeviceOrientation];
   [UITabBarController attemptRotationToDeviceOrientation];
   ```

   

5. 从上述的设备旋转方式可知，如果页面在**UINavigationController**或**UITabBarController**里面，需要给导航栏或底部栏写个分类或者在自定义类里重写两个方法：`shouldAutorotate`和`supportedInterfaceOrientations`。值需当前视图控制器的值一样，可以通过`self.visibleViewController`获取当前显示的试图控制器，进一步获取所需值。

6. 如果强制横屏或者竖屏时还支持自动旋转屏幕，就需要确认手机的方向锁是否打开，如果打开将无法旋转至可支持的方向。

7. 好需要做返回之前页面的设置，否则可能出现push一个新的页面强转横屏，pop回去的时候发现之前的页面也变成了横屏。

8. 最后一点就是处理以上的问题之后，A页面是竖屏的，B页面是横屏的。A页面pushB页面后，在返回A页面的时候动画很难看，为了更好的美观度，写一个转场动画来避免这个视觉上的bug。

##### 解决方案剖析

综上，发现如果有几个页面都需要设置，那么单独设置还是很麻烦的，最好是能有一个函数或者一个属性来配置是最好不过的，但是因为每个页面的设置都是不一样的，状态是需要存储的，所以属性好点。通过分类添加一个属性，可以设置支持的方向，有时只要强转，即单独的方向，而多个方向时，让他可旋转到可支持的方向，因此只需一个属性即可，且此属性可以接受多个值，系统的的枚举UIInterfaceOrientationMask的横屏页面方向和设备方向是相反的，为了后者好区分，创建了一个位移枚举，包括组合值。

~~~objective-c
@interface UIViewController (Rotate)

/** 支持的方向，只有一个方向时即为强转。当有多个参数时，将以 竖屏-左转-右转-倒立竖屏 顺序来优先强转第一个方向*/
@property (assign, nonatomic) OMRotateOrientation omSupportOrientations;

@end
~~~



从设备旋转设置方式可知，为了使页面能够正常的旋转，必须让他的父控制器也支持当前页面的方向，可以通过分类简单重写：

~~~objective-c
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
~~~



使用的时候只需要简单的赋值即可：

```objective-c
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.omSupportOrientations = OMRotateOrientationLandscape;
}
```



使用场景中发现底部栏嵌套导航栏或其他各种嵌套，发现都没什么大问题，无论是push还是present，还是tabbar的主页面，还是新跳导航栏之类的。**只有一个bug就是只有底部栏的时候，第一个视图控制器如果写在viewWillAppear中将会导致底部栏不可见，如果只有底部的情况，可以在UITabBarControllerDelegate中的点击方法中进行设置vc的支持方向并在底部栏的第一个页面的viewDidLoad中进行设置可支持的方向，才能保证app进入的时候强转至指定方向，不过貌似一般也不会在主页面底部栏搞每个页面不同方向的吧。**



##### 实现的效果
有底部栏和导航栏的时候：
![有tabBar和naviBar时](https://raw.githubusercontent.com/oymuzi/OMRotate/master/tabBarAndNaviBar.gif)

只有底部栏的时候：
![只有tabBar](https://raw.githubusercontent.com/oymuzi/OMRotate/master/tabBarGif.gif)



demo地址：[https://github.com/oymuzi/OMRotate](https://github.com/oymuzi/OMRotate)

### 总结

该说的都说了，再哆嗦一句就是使用强转时需要写个转场动画，不然返回的时候很难看。状态栏的设置直接调用api就行，其他没啥了。



