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
    [WXApi registerApp:@"wx179f30dc5f504ad8"];
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


-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];

    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)onResp:(BaseResp *)resp
{
    DLog(@"%@",resp);
    DLog(@"errStr %@",[resp errStr]);
    DLog(@"errCode %d",[resp errCode]);
    DLog(@"type %d",[resp type]);
    
//登录
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        /* Prevent Cross Site Request Forgery */
        switch (resp.errCode) {
            case WXSuccess:{
                NSLog(@"RESP:code:%@,state:%@\n", authResp.code, authResp.state);
                NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
                NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
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
            NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
            
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
