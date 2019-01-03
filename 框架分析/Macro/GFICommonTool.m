//
//  GFICommonTool.m
//  hrhs
//
//  Created by Yang on 11/12/14.
//  Copyright (c) 2014 Yang. All rights reserved.
//

#import "GFICommonTool.h"
#import "BGLoginViewController.h"

@implementation GFICommonTool

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//登录状态
+ (NSInteger)isLogin{
    NSInteger flag = interInitErrorCode;
    NSUserDefaults *defaults = USER_DEFAULT;
//    if([defaults stringForKey:kEncodePhoneNum] && [defaults stringForKey:kEncodePW]){
        if ([defaults boolForKey:kIsLoginScuu]) {
            flag = finishLogin;//已登录
        }else{
            flag = autoLogin;//自动登录
        }
//    }
    
    return flag;
}

+ (void)login:(UIViewController *)controller{
    
    BGLoginViewController* loginViewController = [[BGLoginViewController alloc]init];
    loginViewController.showFlag = 1;
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:loginViewController];
    nvc.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [controller presentViewController:nvc animated:YES completion:nil];

}

//去掉发表文字前的空格或者回车符
+(NSString *)DelbeforeBlankAndEnter:(NSString *)str1
{
    //    BOOL isStringtoSpace=YES;//是否是空格
    NSString *newstr = @"";
    NSString *strSpace =@" ";
    NSString *strEnter =@"\n";
    NSString *string;
    for(int i =0;i<[str1 length];i++)    {
        string = [str1 substringWithRange:NSMakeRange(i, 1)];//抽取子字符
        if((![string isEqualToString:strSpace])&&(![string isEqualToString:strEnter])){//判断是否为空格
            newstr = [str1 substringFromIndex:i];
            //            isStringtoSpace=NO; //如果是则改变 状态
            break;//结束循环
        }
    }
    return newstr;
    
}


//设置label高度
+(float)getNeededHeight:(NSString*)str andSize:(CGSize)labelSize andFont:(CGFloat)font
{
    CGSize size = CGSizeMake(labelSize.width,MAXFLOAT);
    
    NSMutableString *s = [NSMutableString stringWithFormat:@"%@",str];
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    
    CGSize retSize = [s boundingRectWithSize:size
                                     options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil].size;
    //清空
    [s setString:@""];
    return retSize.height;
}

//绘制虚线
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
+(BOOL)isValidObject:(id)object class:(Class)aClass{
    BOOL isValid = NO;
    if (object
        &&[object isKindOfClass:aClass]) {
        isValid = YES;
    }
    return isValid;
}


+ (NSString *)getShowRedBeanCountWithCount:(NSString *)count{
    //100w以上显示万
    int beanCount = [count intValue];
    return beanCount >= 1000000 ? [NSString stringWithFormat:@"%d万",beanCount/10000] : count;
}

//字符串判空
+(BOOL) isBlankString:(NSString *)string {
    
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    //    if (string.length==0) {
    //        return YES;
    //    }
    return NO;
}

+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+ (BOOL)checkActivityName:(NSString *) name
{
    NSString *pattern = @"^[A-Za-z\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:name];
    return isMatch;
}

+ (NSString *)decodeEmoji:(NSString *)tepStr1 {
    
    NSString *decodeStr = tepStr1;
    if ([decodeStr containsString:@"\\\\u"]) {
        decodeStr = [decodeStr stringByReplacingOccurrencesOfString:@"\\\\u"withString:@"\\U"];
    }else if([decodeStr containsString:@"\\u"]){
        decodeStr = [decodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
        NSString *tepStr2 = [decodeStr stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
        NSString *tepStr3 = [[@"\"" stringByAppendingString:tepStr2]stringByAppendingString:@"\""];
        NSData *tepData = [tepStr3  dataUsingEncoding:NSUTF8StringEncoding];
        NSString *axiba = [NSPropertyListSerialization  propertyListWithData:tepData options:NSPropertyListMutableContainers format:NULL error:NULL];
        return  [axiba stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    }
    
    return tepStr1;
}

+ (NSString *)encodeEmoji:(NSString *)encodeStr {
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:encodeStr];
    
    NSRange range;
    for(int i=0; i<att.length; i+=range.length){
        range = [att.string rangeOfComposedCharacterSequenceAtIndex:i];
        NSAttributedString *attS =[att attributedSubstringFromRange:range];
        if ([GFICommonTool judgeEmoji:attS.string]) {
            for (int i = 0; i < attS.string.length; i++) {
                [s appendFormat:@"\\"];
                [s appendFormat:@"u%x",[attS.string characterAtIndex:i]];
            }
        }else{
            [s appendFormat:@"%@",attS.string];
        }
    }
    
    return s;
    
}

#pragma mark - 判断字符串中是否存emoji在表情
+ (BOOL)judgeEmoji:(NSString *)text
{
    __block BOOL returnValue = NO;
    
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar high = [substring characterAtIndex: 0];
                              
                              // Surrogate pair (U+1D000-1F9FF)
                              if (0xD800 <= high && high <= 0xDBFF) {
                                  const unichar low = [substring characterAtIndex: 1];
                                  const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                  
                                  if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                      returnValue = YES;
                                  }
                                  
                                  // Not surrogate pair (U+2100-27BF)
                              } else {
                                  if (0x2100 <= high && high <= 0x27BF){
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}

// iOS 11 判断
+ (void)contentInsetTabelView:(UITableView *)tableView topMargin:(CGFloat)top downMargin:(CGFloat)downMargin{
    
    if (@available(iOS 11.0, *)) {
        if ([tableView respondsToSelector:@selector(contentInsetAdjustmentBehavior)]) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.contentInset =UIEdgeInsetsMake(top,0,downMargin,0);
            tableView.scrollIndicatorInsets = tableView.contentInset;
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
        }
    }
}


@end
