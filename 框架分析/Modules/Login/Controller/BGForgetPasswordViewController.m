//
//  BGForgetPasswordViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/20.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGForgetPasswordViewController.h"
@interface BGForgetPasswordViewController (){
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UIButton *isLookPassword;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *userTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *sendCodeTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureButtonConstrait;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImg;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;

@end

@implementation BGForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLookPassword.hidden = YES;
    if (self.type == 1) {
        self.sureButtonConstrait.constant = 30;
        self.passwordTextfield.hidden = YES;
        self.passwordImg.hidden = YES;
        _topTitleLabel.text = @"修改手机号";
    }else{
        self.sureButtonConstrait.constant = 100;
        self.passwordTextfield.hidden = NO;
        self.passwordImg.hidden = NO;
        _topTitleLabel.text = @"忘记密码";
    }
    
    // Do any additional setup after loading the view from its nib.
    //导航栏闪白条
    [self.navigationController.navigationBar.subviews objectAtIndex:0].hidden = YES;
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [self wr_setNavBarBackgroundAlpha:0];
    [self customBackButton];
}
// 自定义返回按钮
- (void)customBackButton{

    [self addNavigationItemWithImageNames:@[@"返回1"] isLeft:YES target:self action:@selector(backPreController) tags:@[@999]];
}
- (void)backPreController{
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
    
    
    if (self.type == 1) {
        [self postUrl:kJRG_editphone_info andType:3];
        
    }else{
        [self postUrl:kJRG_editpwd_info andType:2];
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

   [self.view endEditing:YES];

}


//网络请求
- (void)postUrl:(NSString *)URl andType:(NSInteger )type{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (type == 1) {//验证码
        [params setObject:self.userTextfield.text forKey:@"phone"];
 
    }else if (type == 2){//修改密码
        
        [params setObject:self.passwordTextfield.text forKey:@"password"];
        [params setObject:self.userTextfield.text forKey:@"phone"];
        [params setObject:self.sendCodeTextfield.text forKey:@"verify"];

    }else if (type == 3){//修改手机号

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
                    [defaults setObject:[GFICommonTool encodeData:self.passwordTextfield.text] forKey:@"user_password"];
                    [defaults synchronize];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else if (type == 3){
                    [USER_DEFAULT setObject:self.userTextfield.text forKey:@"mobile"];
                    [USER_DEFAULT synchronize];
                    if (self.backMobileBlock) {
                        self.backMobileBlock(self.userTextfield.text);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
              
            }
        }else if ([result intValue] == 251 || [result intValue] == 253){
            NSUserDefaults *defaults = USER_DEFAULT;
            [defaults removeObjectForKey:kIsLoginScuu];
            [defaults synchronize];
            [super showHUDTip:[json objectForKey:@"error_msg"]];
            
        }else{
            [super showHUDTip:[json objectForKey:@"error_msg"]];
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
