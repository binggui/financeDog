//
//  AppDelegate.m
//  框架分析
//
//  Created by 丙贵 on 18/5/16.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "AppDelegate.h"
#import <WXApi.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化window
    [self initWindow];
    
    //微信
    [WXApi registerApp:@"wx7e76534c5f78fa8d"];
    
    //启动页
//    [self guideViewShow];
    
//    //初始化网络请求配置
//    [self NetWorkConfig];
//    
//    //UMeng初始化
//    [self initUMeng];
//    
//    //初始化app服务
//    [self initService];
//    
//    //初始化IM
//    [[IMManager sharedIMManager] initIM];
//    
//    //初始化用户系统
//    [self initUserManager];
//    
//    //网络监听
//    [self monitorNetworkStatus];
//    
//    //广告页
//    [AppManager appStart];
    //版本号检查
    

    return YES;
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options {
    return  [WXApi handleOpenURL:url delegate:self];
}



-(void)onResp:(BaseResp *)resp
{
#pragma mark - ——————— 响应 ————————

    DLog(@"%@",resp);
    DLog(@"errStr %@",[resp errStr]);
    DLog(@"errCode %d",[resp errCode]);
    DLog(@"type %d",[resp type]);
    
//登录
    if([resp isKindOfClass:[SendAuthResp class]]) {
         SendAuthResp *aresp = (SendAuthResp *)resp;
        /* Prevent Cross Site Request Forgery */
        switch (resp.errCode) {
            case WXSuccess:{
                
//                // 授权数据
//                NSLog(@" uid: %@", authResp.uid);
//                NSLog(@" openid: %@", authResp.openid);
//                NSLog(@" accessToken: %@", authResp.accessToken);
//                NSLog(@" refreshToken: %@", authResp.refreshToken);
//                NSLog(@" expiration: %@", authResp.expiration);
//
//                // 用户数据
//                NSLog(@" name: %@", authResp.name);
//                NSLog(@" iconurl: %@", authResp.iconurl);
//                NSLog(@" gender: %@", authResp.gender);
//
//                // 第三方平台SDK原始数据
//                NSLog(@" originalResponse: %@", authResp.originalResponse);
    
                
                    if (aresp.errCode== 0)
                    {
                        NSLog(@"code %@",aresp.code);
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatDidLoginNotification" object:self userInfo:@{@"code":aresp.code}];
                    }
                
            }
                break;
            case WXErrCodeAuthDeny:
               
                break;
            case WXErrCodeUserCancel:
               
            default:
                break;
        }
    }
    

    
//分享
    if([resp isKindOfClass:[SendMessageToWXResp class]] ){//微信分享
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        
        switch (response.errCode) {
            case WXSuccess: {
                
            NSString *strTitle = [NSString stringWithFormat:@"分享成功"];
                NSString *strMsg = @"金融狗时刻为您服务";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
                
            }
                break;
            default:
            {
            NSString *strTitle = [NSString stringWithFormat:@"分享失败"];
            NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
                
                break;
            }
                
        }
        
    }
    
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
