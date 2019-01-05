//
//  AppDelegate.h
//  框架分析
//
//  Created by 丙贵 on 18/5/16.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"


/**
 这里面只做调用，具体实现放到 AppDelegate+AppService 或者Manager里面，防止代码过多不清晰
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    dispatch_source_t _forgetPasswordTimer;
    dispatch_source_t _registUserTimer;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainTabBarController *mainTabBar;
@property (strong, nonatomic) NSDictionary * personArr;
@property (strong, nonatomic) NSString * cellType;

@property (strong, nonatomic) dispatch_source_t  forgetPasswordTimer;
@property (strong, nonatomic) dispatch_source_t  registUserTimer;

@end

