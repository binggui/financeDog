//
//  UILabel+VerticalAlign.h
//  ZGHR
//
//  Created by 邱 德金 on 2017/4/20.
//  Copyright © 2017年 aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (VerticalAlign)
- (void)alignTop;
- (void)alignBottom;
// 行间距
- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;
@end
