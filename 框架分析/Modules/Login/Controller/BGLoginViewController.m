//
//  BGLoginViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/20.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGLoginViewController.h"
#import "BGForgetPasswordViewController.h"
#import <WXApi.h>
#import "WechatAndPhoneViewController.h"

@interface BGLoginViewController ()<UITextFieldDelegate>{
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *usersTestField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTestField;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *weTalkButton;
@property (weak, nonatomic) IBOutlet UIButton *QQBotton;
@property (weak, nonatomic) IBOutlet UILabel *topTitle;

@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VendorLoginConstraint;
@property (weak, nonatomic) IBOutlet UITextField *passwordRegistTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;
@property (weak, nonatomic) IBOutlet UIButton *isLookButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImgTopConstrait;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (assign, nonatomic) BOOL  passswordLookFlag;
@property (strong, nonatomic) NSString * openId;

@end

@implementation BGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordIcon.hidden = YES;
    self.passwordRegistTextField.hidden = YES;
    _backImgTopConstrait.constant = -NAV_HEIGHT;
    _loginConstraint.constant = 30;
    _passswordLookFlag = YES;
    self.isLookButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatDidLoginNotification" object:nil];
    
    [self setupUI];
    
    // Do any additional setup after loading the view from its nib.
}
-(void) setupUI{
    [self _initUI];
    //导航栏透明属性
    self.navigationController.navigationBar.translucent = YES;
    //导航栏闪白条
    [self.navigationController.navigationBar.subviews objectAtIndex:0].hidden = YES;
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [self wr_setNavBarBackgroundAlpha:0];

    ViewRadius(_weTalkButton, 30);
    ViewRadius(_QQBotton, 30);

    if (self.showFlag) {//登录1,注册0
        _usersTestField.placeholder = @"输入手机号/用户名";
        _passwordTestField.placeholder = @"密码至少6位";
        _passwordTestField.secureTextEntry = YES;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_registerButton setTitle:@"新用户注册账号" forState:UIControlStateNormal];
        [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        _sendCodeButton.hidden = YES;
        _forgetPasswordButton.hidden = NO;
        self.isLookButton.hidden = YES;
        

    }else{
        _usersTestField.placeholder = @"输入手机号";
        _passwordTestField.placeholder = @"输入验证码";
        [_loginButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitle:@"账号密码登录" forState:UIControlStateNormal];
        [_forgetPasswordButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendCodeButton.hidden = NO;
        _forgetPasswordButton.hidden = YES;
        self.isLookButton.hidden = NO;
    }
    self.passwordRegistTextField.tag = 100;
    self.usersTestField.tag = 200;
    self.passwordTestField.tag = 300;
    

    
    [_usersTestField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self addNavigationItemWithImageNames:@[@"返回1"] isLeft:YES target:self action:@selector(backPreController) tags:@[@999]];
}
- (void)backPreController{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self wr_setNavBarBarTintColor:[GFICommonTool colorWithHexString:appColorDefault]];
    [self wr_setNavBarBackgroundAlpha:1];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏透明属性
    self.navigationController.navigationBar.translucent = YES;
    //导航栏闪白条
    [self.navigationController.navigationBar.subviews objectAtIndex:0].hidden = YES;
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [self wr_setNavBarBackgroundAlpha:0];
}

//密码保密
- (IBAction)changeIsLook:(id)sender {
    _passswordLookFlag = !_passswordLookFlag;
    if(_passswordLookFlag){
        [self.isLookButton setImage:[UIImage imageNamed:@"密码显示1"] forState:UIControlStateNormal];
        _passwordRegistTextField.secureTextEntry = NO;
  
    }else{
        [self.isLookButton setImage:[UIImage imageNamed:@"密码隐藏"] forState:UIControlStateNormal];
        _passwordRegistTextField.secureTextEntry = YES;
        
    }
}

//发送验证码
- (IBAction)sendCodeAction:(id)sender {
    [self postUrl:kJRG_phoneverify_info andType:1];
    
}

//忘记密码
- (IBAction)forgetPasswordAction:(id)sender {

    BGForgetPasswordViewController *forgetPasswordC = [[BGForgetPasswordViewController alloc]init];
    forgetPasswordC.type = 2;
    [self.navigationController pushViewController:forgetPasswordC animated:YES];
    
}
- (void)textFieldDidChange:(UITextField *)theTextField {
    
  
    if (theTextField.tag == 200) {
        if (theTextField.text.length == 12) {
            theTextField.text = [theTextField.text substringToIndex:11];
        }
    }else if (theTextField.tag == 300){
        
        
    }else if (theTextField.tag == 100){
        if (theTextField.text.length == 5){
            //验证号码的合理性
            theTextField.text = [theTextField.text substringToIndex:4];
            if (![theTextField.text isTelephoneNum]){
                theTextField.text = @"";
            }
        }
    }
}


- (void)countDown
{
    
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

- (void)_initUI{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0 , 22, 23)];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *colseBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = colseBtn;
}

- (void)closeAction:(UIButton *)button {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
//登录 // 注册
- (IBAction)goToLogin:(id)sender {

    if (self.showFlag) {//登录1,注册0
        
        [self postUrl:kJRG_login andType:2];
//        //登录成功,本地保存
//        NSUserDefaults *defaults = USER_DEFAULT;
//        [defaults setBool:YES forKey:kIsLoginScuu];
//        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    }else{

        [self postUrl:kJRG_regeister andType:3];
    }
    
}

//注册 登录
- (IBAction)registUserAction:(id)sender {
    
    self.passwordRegistTextField.text = @"";
    self.usersTestField.text = @"";
    self.passwordTestField.text = @"";
    
    [UIView animateWithDuration:0.5 animations:^{
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        theAnimation.duration=1;
        theAnimation.removedOnCompletion = YES;
        theAnimation.fromValue = [NSNumber numberWithFloat:0];
        theAnimation.toValue = [NSNumber numberWithFloat:3.1415926 * 2];
        [self.view.layer addAnimation:theAnimation forKey:@"animateTransform"];
       
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.showFlag = !self.showFlag;
            if(self.showFlag){
                _topTitle.text = @"账号登录";
                _loginConstraint.constant = 30;
                self.passwordIcon.hidden = YES;
                self.passwordRegistTextField.hidden = YES;
                self.passwordTestField.secureTextEntry = YES;
                
            }else{
                _loginConstraint.constant = 75;
                _topTitle.text = @"账号注册";
                self.passwordIcon.hidden = NO;
                self.passwordRegistTextField.hidden = NO;
                self.passwordTestField.secureTextEntry = NO;
            }
        } completion:^(BOOL finished) {
            [self setupUI];
        }];

    }];


}
//第三方微信登录
- (IBAction)weTalkAction:(id)sender {
    
//    [PopPromptView showWithTag:100 target:self title:@"检测到您未关联手机号,\n是否立即关联"];
    NSLog(@"%s",__func__);

    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];

}

- (void)wechatDidLoginNotification:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"code"]);
    [self getWechatAccessTokenWithCode:text.userInfo[@"code"]];
    
}
- (void)getWechatAccessTokenWithCode:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    WechatAppKey,WechatSecrectKey,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                NSString *accessToken = dic[@"access_token"];
                NSString *openId = dic[@"openid"];
                
                [self getWechatUserInfoWithAccessToken:accessToken openId:openId];
            }
        });
    });
}
- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                self.openId = [dic objectForKey:@"openid"];
                [self postUrl:kJRG_isbindwx andType:4];
                
                NSString *openId = [dic objectForKey:@"openid"];
                NSString *memNickName = [dic objectForKey:@"nickname"];
                NSString *memSex = [dic objectForKey:@"sex"];
           
//                [self loginWithOpenId:openId memNickName:memNickName memSex:memSex];
            }
        });
        
    });
}

- (void)log_by_otherWithType :(NSString *)type openId :(NSString *)openId accessToken :(NSString *)token{
//    [SVProgressHUD show];
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    [parames setObject:type forKey:@"type"];
    [parames setObject:openId forKey:@"openId"];
    [parames setObject:token forKey:@"accessToken"];
    [HRHTTPTool postWithURL:kHrhs_login_by_other parameters:parames success:^(id json) {
//        [SVProgressHUD dismiss];
        id result = [json objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *value = [result objectForKey:@"value"];
            [OMGToast showWithText:[value objectForKey:@"errMsg"] topOffset:180.0f duration:1.0];
            
            return;
            
        }
        if ([result intValue] == 200) {
//          
            //给个登录类型标记
            [USER_DEFAULT setObject:type forKey:@"accounttype"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToDetailVC" object:@"nil"];
            //            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else if ([result intValue] == 251 || [result intValue] == 253){
            NSUserDefaults *defaults = USER_DEFAULT;
            [defaults removeObjectForKey:kIsLoginScuu];
            [defaults synchronize];
            [OMGToast showWithText:[json objectForKey:@"error_msg"] topOffset:KScreenHeight/2 duration:1.7];
            
        }else{
            [OMGToast showWithText:[json objectForKey:@"error_msg"] topOffset:KScreenHeight/2 duration:1.7];
            
        }
    } failure:^(NSError *error) {
        //        NSLog(@"%@",error);
//        [SVProgressHUD dismiss];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatDidLoginNotification" object:nil];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

//网络请求
- (void)postUrl:(NSString *)URl andType:(NSInteger )type{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (type == 1) {//验证码
        [params setObject:self.usersTestField.text forKey:@"phone"];

    }else if (type == 2){//登录
        
        [params setObject:self.passwordTestField.text forKey:@"password"];
        [params setObject:self.usersTestField.text forKey:@"phone"];

    }else if (type == 3){//注册
        [params setObject:self.passwordRegistTextField.text forKey:@"verify"];
        [params setObject:self.passwordTestField.text forKey:@"password"];
        [params setObject:self.usersTestField.text forKey:@"phone"];

    }else if (type == 4){//绑定判断
        
        [params setObject:self.openId forKey:@"openid"];
        
    }
    

    [HRHTTPTool postWithURL:URl parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];

        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                if (type == 1) {//验证码
                    //验证
                    [self countDown];
                   
                }else if (type == 2){//登录
                    //登录成功,本地保存
                    NSUserDefaults *defaults = USER_DEFAULT;
                    [defaults setBool:YES forKey:kIsLoginScuu];
                    NSString *str = [json objectForKey:KTokenMark] ;
                    [defaults setObject:str forKey:KTokenMark];
                    NSString *strExpire = [json objectForKey:Kexpire_timeMark] ;
                    [defaults setObject:strExpire forKey:Kexpire_timeMark];
                    
                    
                    NSString *strTemp = [[json objectForKey:@"result"]  objectForKey:KidMark];
                    [defaults setObject:strTemp forKey:KidMark];
                    
                     NSDictionary *personData = [json objectForKey:@"result"];
                    //个人数据保存
                    [defaults setInteger:[personData[@"sex"]  integerValue]  forKey:@"sex"];
                    [defaults setObject:personData[@"user_nickname"] forKey:@"user_nickname"];
                    [defaults setObject:personData[@"avatar"] forKey:@"avatar"];
                    [defaults setObject:personData[@"mobile"] forKey:@"mobile"];
                    [defaults setObject:self.usersTestField.text forKey:@"user_name'"];
                    [defaults setObject:[GFICommonTool encodeData:self.passwordTestField.text] forKey:@"user_password"];
                    
//                    [super writeDataToPlist:[json objectForKey:@"result"]];
                    //2.1立即同步
                    [defaults synchronize];
                    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

                }else if (type == 3){//注册
                    //转换登录界面
                    [self registUserAction:nil];
                    
                }else if (type == 4){
                    if ([[json objectForKey:@"is_bind"] intValue] == 1) {
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
                        [defaults setObject:self.usersTestField.text forKey:@"user_name'"];
                        [defaults setObject:[GFICommonTool encodeData:self.passwordTestField.text] forKey:@"user_password"];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        WechatAndPhoneViewController *vc = [[WechatAndPhoneViewController alloc]init];
                        vc.openID = self.openId;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }
        }else{
            [super showHUDTip:[json objectForKey:@"error_msg"] duration:2.5];
        }
    } failure:^(NSError *error) {
        [super showHUDTip:@"网络错误" duration:1.7];
        NSLog(@"error == %@",error);
    }];
}

- (void)popPromptViewCheckBtnCallBackWithTag:(NSInteger)tag {
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToRelateVC" object:nil];
    
}

- (void)popPromptViewCancelBtnCallBackWithTag:(NSInteger)tag {
    [self dismissViewControllerAnimated:YES completion:nil];
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
