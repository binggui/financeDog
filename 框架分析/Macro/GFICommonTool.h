//
//  GFICommonTool.h
//  hrhs
//
//  Created by Yang on 11/12/14.
//  Copyright (c) 2014 Yang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface GFICommonTool : NSObject

/**
 *设置色值的方法
 *
 **/
+ (UIColor *) colorWithHexString: (NSString *)color;
/**
 *去掉发表文字前的空格或者回车符
 *
 *
 */
+(NSString *)DelbeforeBlankAndEnter:(NSString *)str1;

// 返回字体大小
+(UIFont *)fontSizeByScreenWithPx:(float)px;

//设置label高度
+(float)getNeededHeight:(NSString*)str andSize:(CGSize)labelSize andFont:(CGFloat)font;

+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
+(BOOL)isValidObject:(id)object class:(Class)aClass;

/**功能性方法
 *对未登录的情况的处理
 */
+ (void)jumpTOLoginView;

/**
 *对红豆数进行处理
 */
+ (NSString *)getShowRedBeanCountWithCount :(NSString *)count;


/**
 * 字符串判空
 */
+(BOOL) isBlankString:(NSString *)string;

//登录判断
+ (NSInteger)isLogin;
/**
 *  弹出登录界面
 *
 *  @param controller 登录界面
 */
+ (void)login:(UIViewController *)controller;
/**
 * 检验字符只允许26个字母和数字

 */
+ (BOOL)checkTelNumber:(NSString *)telNumber;

+ (BOOL)checkActivityName:(NSString *) name;

+ (NSString *)decodeEmoji:(NSString *)tepStr1;

+ (NSString *)encodeEmoji:(NSString *)encodeStr;

+ (void)contentInsetTabelView:(UITableView *)tableView topMargin:(CGFloat)top downMargin:(CGFloat)downMargin;
@end
