//
//  NetworkDefine.h
//  框架分析
//
//  Created by 丙贵 on 18/5/17.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#ifndef NetworkDefine_h
#define NetworkDefine_h


//内部版本号 每次发版递增
#define KVersionCode 1

//连接超时时间
#define RequestTimeOut 30
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    1
#define TestSever       0
#define ProductSever    0

#if DevelopSever
//状态码
//返回成功码
#define retSuccCode 200//
#define retSuccMess @"成功"

#define retUnregisterCode 201//
#define unregisterError @""

#define retMobileCode 202//非移动手机号
#define mobileError @"用户名不能为空"

#define retPWCode 203//
#define pwError @"用户名格式错误"

#define retRegisteredCode 204//
#define registeredError @"用户名不能小于6个字符！"

#define retVerifyCode 205//
#define verifyError @"密码不能为空"

#define retUnloginCode 206//
#define unloginError @"密码只能是数字、字母、下划线或破折号"

#define retExceedCode 207//
#define exceedError @"密码不能超过12个字符"

#define retVerifyExpiredCode 208//
#define verifyExpiredError @"密码不能小于6个字符"

#define retShortageCode 209//
#define shortageError @"用户名长度为11位"

#define retPWInvalidCode 210//
#define pwInvalidError @"获取手机验证码次数超出当前3次限制"

#define retShareBonusShortageCode 211
#define shareBonusShortageError @"注册用户名与获取验证码手机不匹配"

#define retExistInvalidCode 212//
#define existInvalidError @"用户已存在"

#define retExactPWDCode 213//
#define exactPWDError @"手机验证码错误"

//2015.03.25新加入返回码
#define retShareNullDataCode 214
#define shareNullDataError @"证码错误,请重试"

#define retShareMyselfCode 215
#define shareMyselfError @"注册失败,请重试!"



#define retShareBonusTotalShortageCode 217
#define shareBonusTotalShortageError @"验证码过期,请重试"


#define kBaseShareUrl @"http://dcdev.i139.cn/hrhsApp/"
#define kHrhs_login_by_other kBaseShareUrl @"login_by_other"           //第三方账号登录

#define kWebTestUrl  @"http://data.10086.cn/nmp-pps/m/?s=2&p=12&c=508"

//金融狗
#define kBaseUrl @"http://jrg.yunmeitiweb.com/user/phoneapi.loginapi/"
#define kBaseportalUrl @"http://jrg.yunmeitiweb.com/portal/phoneapi.indexapi/"
#define kBasehotlUrl @"http://jrg.yunmeitiweb.com/portal/phoneapi.hotnewapi/"
#define kExampleapiUrl @"http://jrg.yunmeitiweb.com/portal/phoneapi.exampleapi/"
#define kEditpwdUrl @"http://jrg.yunmeitiweb.com/user/phoneapi.personalapi/"
#define kcommentUrl @"http://jrg.yunmeitiweb.com/user/phoneapi.commentapi/"


#define kJRG_regeister kBaseUrl @"regeister"   //注册
#define kJRG_gettoken_info kBaseUrl @"gettoken"   //token
#define kJRG_login kBaseUrl @"login"   //登录
#define kJRG_phoneverify_info kBaseUrl @"phoneverify"   //验证码
#define kJRG_index_info kBaseportalUrl @"index"   //首页数据接口
#define kJRG_hotnew_info kBaseUrl @"hotnew"   //hotnew

#define kJRG_daynew_info kBasehotlUrl @"daynew"//周热点
#define kJRG_weeknew_info kBasehotlUrl @"weeknew"//周热点
#define kJRG_mounthnew_info kBasehotlUrl @"mounthnew"//周热点

#define kJRG_search_info kBaseportalUrl @"search"//搜索
#define kJRG_exampleapi_info kExampleapiUrl @"index"//案例
#define kJRG_editpwd_info kEditpwdUrl @"editpwd"//修改密码
#define kJRG_comment_info kcommentUrl @"comment"//修改密码
/**开发服务器*/
#define URL_main @"http://218.205.209.238/shark-miai-fubinggui"
//#define URL_main @"http://192.168.11.122:8090" //展鹏

#elif TestSever

/**测试服务器*/
#define URL_main @"http://192.168.20.31:20000/shark-miai-service"

#elif ProductSever

/**生产服务器*/
#define URL_main @"http://192.168.20.31:20000/shark-miai-service"
#endif


#pragma mark - ——————— 详细接口地址 ————————

//测试接口
//NSString *const URL_Test = @"api/recharge/price/list";
#define URL_Test @"/api/cast/home/start"


#pragma mark - ——————— 用户相关 ————————
//自动登录
#define URL_user_auto_login @"/api/autoLogin"
//登录
#define URL_user_login @"/api/login"
//用户详情
#define URL_user_info_detail @"/api/user/info/detail"
//修改头像
#define URL_user_info_change_photo @"/api/user/info/changephoto"
//注释
#define URL_user_info_change @"/api/user/info/change"

#endif /* NetworkDefine_h */
