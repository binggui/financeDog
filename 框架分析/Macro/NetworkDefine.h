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
#define kportal_commentUrl @"http://jrg.yunmeitiweb.com/portal/phoneapi.commentapi/"
#define kpushnewUrl @"http://jrg.yunmeitiweb.com/portal/phoneapi.pushnewapi/"
#define kdofavouriteUrl @"http://jrg.yunmeitiweb.com/portal/phoneapi.pushnewapi/"
#define kdolikeUrl @"http://jrg.yunmeitiweb.com/portal/news/"


#define kJRG_getchildcomment_info  kportal_commentUrl  @"getchildcomment"//文章获取阅读量

#define kJRG_getparam_info  kportal_commentUrl  @"getparam"//文章获取阅读量

#define kJRG_portal_addcomment_info kportal_commentUrl @"addcomment"//评论子类
#define kJRG_portal_comment_info kportal_commentUrl @"comment"//文章评论
#define kJRG_dofavourite_info kportal_commentUrl @"dofavourite"//收藏
#define kJRG_dolike_info kdolikeUrl @"dolike"//点赞


#define kJRG_comment_info kcommentUrl @"comment"//评论
#define kJRG_bindwx kBaseUrl @"bindwx"   //绑定判断
#define kJRG_isbindwx kBaseUrl @"isbindwx"   //绑定判断
#define kJRG_regeister kBaseUrl @"regeister"   //注册
#define kJRG_gettoken_info kBaseUrl @"gettoken"   //token
#define kJRG_login kBaseUrl @"login"   //登录
#define kJRG_phoneverify_info kBaseUrl @"phoneverify"   //验证码
#define kJRG_index_info kBaseportalUrl @"index"   //首页数据接口
#define kJRG_hotnew_info kBaseUrl @"hotnew"   //hotnew

#define kJRG_daynew_info kBasehotlUrl @"daynew"//日热点
#define kJRG_weeknew_info kBasehotlUrl @"weeknew"//周热点
#define kJRG_mounthnew_info kBasehotlUrl @"mounthnew"//月热点

#define kJRG_search_info kBaseportalUrl @"search"//搜索
#define kJRG_pushnew_info kpushnewUrl @"pushnew"//推荐
#define kJRG_exampleapi_info kExampleapiUrl @"index"//案例
#define kJRG_editpwd_info kEditpwdUrl @"editpwd"//修改密码
#define kJRG_editsex_info kEditpwdUrl @"editsex"//sex
#define kJRG_editnickname_info kEditpwdUrl @"editnickname"//name
#define kJRG_getavatar_info kEditpwdUrl @"getavatar"//头像地址
#define kJRG_editphone_info kEditpwdUrl @"editphone"//修改手机号
#define kJRG_sysmsg_info kEditpwdUrl @"sysmsg"//消息
#define kJRG_mymsg_info kEditpwdUrl @"mymsg"//我的评论
#define kJRG_getversion_info kEditpwdUrl @"getversion"//版本号


#define kJRG_myread_info kEditpwdUrl @"myread"//阅读记录
#define kJRG_myfavorite_info kEditpwdUrl @"myfavorite"//收藏记录mythumb
#define kJRG_mythumb_info kEditpwdUrl @"mythumb"//上传头像


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
