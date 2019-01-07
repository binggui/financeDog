//
//  BGForgetPasswordViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/20.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGForgetPasswordViewController.h"
#import "ModifyPasswordViewController.h"
@interface BGForgetPasswordViewController (){
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UIButton *isLookPassword;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *userTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *sendCodeTextfield;

@end

@implementation BGForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLookPassword.hidden = YES;
    self.navigationController.title = @"忘记密码";
    // Do any additional setup after loading the view from its nib.
//    [self customBackButton];
}
// 自定义返回按钮
- (void)customBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(-20, 0, 60, 40);
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}
// 返回按钮按下
- (void)backBtnClicked:(UIButton *)sender{
    // pop
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)isLookAction:(id)sender {
}

//发送验证码
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
//确定
- (IBAction)goToModifiedPassword:(id)sender {
    
    [self postUrl:kJRG_editpwd_info andType:2];
    

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

   [self.view endEditing:YES];

}


//网络请求
- (void)postUrl:(NSString *)URl andType:(NSInteger )type{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *urlTemp = nil;
    if (type == 1) {//验证码
        [params setObject:self.userTextfield.text forKey:@"phone"];
 
    }else if (type == 2){//修改密码
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
                    
                }else if (type == 2){//修改密码
                    NSUserDefaults *defaults = USER_DEFAULT;
                    [defaults removeObjectForKey:kIsLoginScuu];
                    [defaults synchronize];
                    [self.navigationController popToRootViewControllerAnimated:YES];
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
