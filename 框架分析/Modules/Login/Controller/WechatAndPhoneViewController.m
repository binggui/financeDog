//
//  WechatAndPhoneViewController.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/12.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "WechatAndPhoneViewController.h"

@interface WechatAndPhoneViewController (){
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UITextField *userTextfield;
@property (weak, nonatomic) IBOutlet UITextField *sendCodeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

@implementation WechatAndPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //导航栏闪白条
    [self.navigationController.navigationBar.subviews objectAtIndex:0].hidden = YES;
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [self wr_setNavBarBackgroundAlpha:0];
    [self addNavigationItemWithImageNames:@[@"返回1"] isLeft:YES target:self action:@selector(backPreController) tags:@[@999]];
}
- (void)backPreController{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sure:(id)sender {
    [self postUrl:kJRG_bindwx andType:2];
    
    
}
- (IBAction)sendCode:(id)sender {
    [self postUrl:kJRG_phoneverify_info andType:1];
}
- (void)countDown
{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    /////////////添加倒计时
    __block int timeout= 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //置空，防止内存泄露，在dealloc里也进行了设置
            _timer = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                _sendCodeButton.enabled = YES;
                _sendCodeButton.alpha = 1.0;
            });
            
        }else{
            NSString *strTime = [NSString stringWithFormat:@"(%d)秒后获取",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                _sendCodeButton.enabled = NO;
                //设置界面的按钮显示 根据自己需求设置
                _sendCodeButton.titleLabel.text = strTime;
                [_sendCodeButton setTitle:strTime forState:UIControlStateNormal];
                _sendCodeButton.alpha = 1;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    /////////////
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}
//网络请求
- (void)postUrl:(NSString *)URl andType:(NSInteger )type{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (type == 1) {//验证码
        [params setObject:self.userTextfield.text forKey:@"phone"];
        
    }else if (type == 2){//绑定手机号
        
        [params setObject:self.openID forKey:@"openid"];
        [params setObject:self.passwordTextfield.text forKey:@"password"];
        [params setObject:self.userTextfield.text forKey:@"phone"];
        [params setObject:self.sendCodeTextfield.text forKey:@"verify"];
        
    }
    [HRHTTPTool postWithURL:URl parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            
            if ([json isKindOfClass:[NSDictionary class]]) {
                
                if (type == 1) {//验证码
                    [OMGToast showWithText:@"验证码已下发" topOffset:KScreenHeight/2 duration:2.0];
                    [self countDown];
                    
                }else if (type == 2){//绑定成功返回的数据
                    //登录成功,本地保存
                    NSUserDefaults *defaults = USER_DEFAULT;
                    [defaults setBool:YES forKey:kIsLoginScuu];
                    NSString *str = [json objectForKey:KTokenMark] ;
                    [defaults setObject:str forKey:KTokenMark];
                    NSString *strTemp = [[json objectForKey:@"result"]  objectForKey:KidMark];
                    [defaults setObject:strTemp forKey:KidMark];
                    
                    NSDictionary *personData = [json objectForKey:@"result"];
                    //个人数据保存
                    [defaults setInteger:[personData[@"sex"]  integerValue]  forKey:@"sex"];
                    [defaults setObject:personData[@"user_nickname"] forKey:@"user_nickname"];
                    [defaults setObject:personData[@"avatar"] forKey:@"avatar"];
                    [defaults setObject:personData[@"mobile"] forKey:@"mobile"];
                    [defaults setObject:self.userTextfield.text forKey:@"user_name'"];
                    [defaults setObject:[GFICommonTool encodeData:self.passwordTextfield.text] forKey:@"user_password"];

                    //                    [super writeDataToPlist:[json objectForKey:@"result"]];
                    //2.1立即同步
                    [defaults synchronize];
                    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                }

            }
        }else{
            [super showHUDTip:[json objectForKey:@"error_msg"] duration:1.7];
        }
    } failure:^(NSError *error) {
        [super showHUDTip:@"网络错误" duration:1.7];
        NSLog(@"error == %@",error);
    }];
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
