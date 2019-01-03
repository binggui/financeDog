//
//  AppDelegate+AppService.h
//  框架分析
//
//  Created by 丙贵 on 18/5/16.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)

-(void)initWindow;
+ (AppDelegate *)shareAppDelegate;
@end
