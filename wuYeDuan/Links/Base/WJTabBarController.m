//
//  WJTabBarController.m
//  TextOne
//
//  Created by Mac on 16/6/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "WJTabBarController.h"
#import "TooBox.h"
#import "WJNaviController.h"

#import "HomeViewController.h"
#import "ReleaseViewController.h"
#import "MainViewController.h"
@interface WJTabBarController ()<UITabBarControllerDelegate> {
    UIImageView *billImageView;
}

@end

@implementation WJTabBarController


- (instancetype)init {
    
    if (self = [super init]) {
        
        self.delegate = self;
        [self.tabBar insertSubview:[self drawTabbarBgImageView] atIndex:0];
        [self.tabBar setShadowImage:[[UIImage alloc]init]];
        
        [self.tabBar setBackgroundImage:[TooBox imageWithColor:[UIColor whiteColor] size:CGSizeMake(100, 50)]];
        self.tabBar.barStyle = UIBarStyleBlackOpaque;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.delegate = self;
    
    [self setUpAllChildVc];
    
}

- (void)setUpAllChildVc
{
    HomeViewController *HomeVC = [[HomeViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"menu_index" selectedImage:@"menu_index_tabbar" title:@"首页" tag:0];
    
    ReleaseViewController *ReleaseVC = [[ReleaseViewController alloc]init];
    [self setUpOneChildVcWithVc:ReleaseVC Image:@"asd" selectedImage:@"" title:@"" tag:1];
    
    MainViewController *MineVC = [[MainViewController alloc] init];
    [self setUpOneChildVcWithVc:MineVC Image:@"menu_my" selectedImage:@"menu_my_tabbar" title:@"我的" tag:2];
}
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title tag:(NSInteger)tag
{
    WJNaviController *nav = [[WJNaviController alloc] initWithRootViewController:Vc];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
    Vc.tabBarItem.title = title;
    
    Vc.tabBarItem.tag = tag;
    
    Vc.navigationItem.title = title;
    
    if (tag == 1) {
        billImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-57/2.0, -15, 57, 57)];
        [billImageView setImage:[UIImage imageNamed:@"button_find_coal_bg"]];
        [self.tabBar insertSubview:billImageView atIndex:0];
        [Vc.tabBarItem setImageInsets:UIEdgeInsetsMake(-5, 0, 5, 0)];
        Vc.tabBarItem.tag = 1;
    }
    
    [self addChildViewController:nav];
    
}


- (UIImageView *)drawTabbarBgImageView
{
    CGFloat tabBarHeight = self.tabBar.frame.size.height;
    CGFloat standOutHeight = 18;
    
    NSLog(@"tabBarHeight：  %f" , tabBarHeight);// 设备tabBar高度 一般49
    CGFloat radius = 35;// 圆半径
    CGFloat allFloat= (pow(radius, 2)-pow((radius-standOutHeight), 2));// standOutHeight 突出高度 12
    CGFloat ww = sqrtf(allFloat);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -standOutHeight,self.view.frame.size.width , tabBarHeight +standOutHeight)];// ScreenW设备的宽
    //    imageView.backgroundColor = [UIColor redColor];
    CGSize size = imageView.frame.size;
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(size.width/2 - ww, standOutHeight)];
    NSLog(@"ww: %f", ww);
    NSLog(@"ww11: %f", 0.5*((radius-ww)/radius));
    CGFloat angleH = 0.5*((radius-standOutHeight)/radius);
    NSLog(@"angleH：%f", angleH);
    CGFloat startAngle = (1+angleH)*((float)M_PI); // 开始弧度
    CGFloat endAngle = (2-angleH)*((float)M_PI);//结束弧度
    // 开始画弧：CGPointMake：弧的圆心  radius：弧半径 startAngle：开始弧度 endAngle：介绍弧度 clockwise：YES为顺时针，No为逆时针
    [path addArcWithCenter:CGPointMake((size.width)/2, radius) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    // 开始画弧以外的部分
    [path addLineToPoint:CGPointMake(size.width/2+ww, standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width, standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width,size.height)];
    [path addLineToPoint:CGPointMake(0,size.height)];
    [path addLineToPoint:CGPointMake(0,standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width/2-ww, standOutHeight)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;// 整个背景的颜色
    layer.strokeColor = [UIColor groupTableViewBackgroundColor].CGColor;//边框线条的颜色
    layer.lineWidth = 0.5;//边框线条的宽
    // 在要画背景的view上 addSublayer:
    [imageView.layer addSublayer:layer];
    return imageView;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 1) {
        [billImageView setImage:[UIImage imageNamed:@"button_find_coal_bg_tabbar"]];
    }else {
        [billImageView setImage:[UIImage imageNamed:@"button_find_coal_bg"]];
    }
   
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSInteger tag = viewController.tabBarItem.tag;
//    if (tag == 3 || tag == 2 || tag == 4) {
//        if (![UserManager isLogin]) {
//            [UserManager loginInCompletionHandler:^(BOOL loginIn) {
//                if (loginIn) {
//                    self.selectedIndex = tag;
//                }
//            }];
//            return NO;
//        }else {
//            return YES;
//        }
//    }
    WBLog(@"%ld",tag);
    
    return YES;
}

@end
