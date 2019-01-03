//
//  UtilsDefine.h
//  框架分析
//
//  Created by 丙贵 on 18/5/17.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#ifndef UtilsDefine_h
#define UtilsDefine_h


/*
 
 快速获取
一些快捷方法和名词,如通知post\屏幕尺寸\常用的系统对象\颜色设定\字体

 */

//网络
#define KTestUrl  @"https://www.baidu.com"
#define iPhone4H     480.0
#define iPhone5H     568.0
#define iPhone6W     375.0
#define iPhone6PlusW 414.0
#define iPhone6XH     812.0
#define iPhone6H      667.0

#pragma mark - Device Information

#define isiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPhone6Plus CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kISiPhone4 ([UIScreen mainScreen].bounds.size.height == iPhone4H) //4/4s
#define kISiPhone5 ([UIScreen mainScreen].bounds.size.height == iPhone5H)
#define kISiPhone6 ([UIScreen mainScreen].bounds.size.width == iPhone6W)
#define kISiPhone6Plus ([UIScreen mainScreen].bounds.size.width == iPhone6PlusW)
#define kISiPhoneX ([UIScreen mainScreen].bounds.size.height == iPhone6XH)
#define kISiPhone6H ([UIScreen mainScreen].bounds.size.height == iPhone6H)

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define interInitErrorCode -9999//自定义网路请求初始化错误码
#define kEncodePhoneNum @"phonenum"//加密手机号
#define kEncodePW @"passwd"//加密密码
#define kIsLoginScuu @"islogin"//是否登录成功标志位
#define finishLogin 1
#define autoLogin 2

//判断是否是ios7
#define IS_IOS_7_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

//适配
#define KCurrentWidths(width)  width/375.0*KScreenWidth
#define KCurrentHeights(height)  height/667.0*KScreenHeight

//导航栏高度
#define NAV_HEIGHT (KScreenHeight == 812.0 ? 88 : 64) //导航栏的高度
#define TAB_HEIGHT (KScreenHeight == 812.0 ? 83 : 49) //tab的高度

#define SCREEN_WIDTH6plusRatio (KScreenWidth / 414.f)
#define SCREEN_WIDTH6Ratio (KScreenWidth / 375.f)
#define SCREEN_WIDTH5sRatio (KScreenWidth / 320.f)
#define kFontSziePixelRatio (72.f / 96.f)

#define Iphone6ScaleWidth KScreenWidth/375.0
#define Iphone6ScaleHeight KScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kRealValue(width) ((width)*(KScreenWidth/375.0f))
// 状态条高度
#define STATUS_HEIGHT  [UIApplication sharedApplication].statusBarFrame.size.height
// 屏幕状态条+导航栏高度
#define SUM_HEIGHT (STATUS_HEIGHT+NAV_HEIGHT)
//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
//颜色获取
#define kColor(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]
//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//property 属性快速声明 别用宏定义了，使用代码块+快捷键实现吧

// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言
#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//颜色
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//加载loading背景透明度
#define LODING_BACK_ALPHPA 0.93
//加载loading在多少秒之内完成全部图片播放
#define CHANGE_PICK_TIME 1.4
//加载loading字体颜色值
#define LOADING_TEXT_RED_COLOR 140
#define LOADING_TEXT_GREEN_COLOR 140
#define LOADING_TEXT_BULE_COLOR 140
//加载loading背景色
#define LOADING_BACK_RED_COLOR 234
#define LOADING_BACK_GREEN_COLOR 234
#define LOADING_BACK_BULE_COLOR 234

//字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


//定义UIImage对象
#define ImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define IMAGE_NAMED(name) [UIImage imageNamed:name]

//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start);
//打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)


//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}


#endif /* UtilsDefine_h */
