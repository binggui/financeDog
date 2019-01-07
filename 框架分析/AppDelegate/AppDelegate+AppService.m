//
//  AppDelegate+AppService.m
//  框架分析
//
//  Created by 丙贵 on 18/5/16.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "WRNavigationBar.h"

UIColor *MainNavBarColor = nil;
UIColor *MainViewColor = nil;

@implementation AppDelegate (AppService)


-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
    self.mainTabBar = [MainTabBarController new];
    self.window.rootViewController = self.mainTabBar;
    
    MainNavBarColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    MainViewColor   = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1];
    
    // 设置导航栏默认的背景颜色
    [UIColor wr_setDefaultNavBarBarTintColor:[GFICommonTool colorWithHexString:@"#00486b"]];
    // 设置导航栏所有按钮的默认颜色
    [UIColor wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [UIColor wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    // 统一设置状态栏样式
    [UIColor wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
     [UIColor wr_setDefaultNavBarShadowImageHidden:YES];
  
    //状态栏
    [UIColor wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


@end
