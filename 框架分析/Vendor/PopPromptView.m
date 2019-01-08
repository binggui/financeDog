//
//  PopPromptView.m
//  ZGHR
//
//  Created by WDX on 17/5/9.
//  Copyright © 2017年 aspire. All rights reserved.
//

#define kStr @"注:立即关联可进行点赞,评论,分享,手机账号登录等更多惊喜!"
#import "PopPromptView.h"
#import "UILabel+VerticalAlign.h"
#define kPopViewFrame CGRectMake(40, (KScreenHeight-180)/2, KScreenWidth-80, 180)
@interface PopPromptView ()
- (instancetype)initWithTitle :(NSString *)title;
@end

@implementation PopPromptView

- (instancetype)initWithTitle :(NSString *)title{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self setupUIWithTitle:title];
    }
    return self;
}

- (void)setupUIWithTitle :(NSString *)title{
    
    
    UIView *popView = [[UIView alloc]initWithFrame:kPopViewFrame];
    popView.height = 180;
    popView.backgroundColor = [UIColor whiteColor];
    UIColor *color = kColorWithAlpha(0, 0, 0, 0.5);
    self.backgroundColor = color;
    [self addSubview:popView];
    popView.layer.masksToBounds = YES;
    popView.layer.cornerRadius = 10;
    
    float height = [self getNeededHeight:kStr andSize:CGSizeMake(popView.width - 60, 0) andFont:14] + 10;

    popView.height += height;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 77/2, popView.width - 70, 17)];
    
    titleLab.text = title;
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:16.0];
    titleLab.textColor = [GFICommonTool colorWithHexString:@"#333333"];
    [popView addSubview:titleLab];
    titleLab.height = [self getNeededHeight:title andSize:titleLab.size andFont:16];
    
    
    UILabel *contentlabel = [[UILabel alloc] initWithFrame:(CGRectMake(30, titleLab.bottom + 15, popView.width - 60, 0))];
    contentlabel.height = height;
    contentlabel.numberOfLines = 0;
//    contentlabel.backgroundColor = [UIColor redColor];
//    contentlabel.text = kStr;
    contentlabel.font = [UIFont systemFontOfSize:13.0];
    contentlabel.textColor = kColor(151, 152, 153);
    [popView addSubview:contentlabel];
  contentlabel.attributedText =  [contentlabel getAttributedStringWithString:kStr lineSpace:3];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentlabel.bottom+10, popView.width, 1)];
    lineView.backgroundColor = [GFICommonTool colorWithHexString:@"#e8e8e8"];
    [popView addSubview:lineView];
    lineView.hidden = YES;
    
    UIView *vertailLine = [[UIView alloc] initWithFrame:CGRectMake((popView.width-1)/2, lineView.bottom, 1, popView.height-lineView.bottom - 1)];
    vertailLine.backgroundColor = [GFICommonTool colorWithHexString:@"#e8e8e8"];
    [popView addSubview:vertailLine];
    vertailLine.hidden = YES;
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, lineView.bottom + 10, (popView.width - 90)/2 , 40)];
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:cancelBtn];
    cancelBtn.backgroundColor = kColor(152, 153, 154);
    
    
    UILabel *cancelLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cancelBtn.width, cancelBtn.height)];
    cancelLab.text = @"放弃关联";
    cancelLab.textAlignment = NSTextAlignmentCenter;
    cancelLab.font = [UIFont  boldSystemFontOfSize:17.0];
    [cancelBtn addSubview:cancelLab];
    
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtn.right + 30, cancelBtn.top, cancelBtn.width, 40)];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.backgroundColor = kColor(39, 167, 243);
    [popView addSubview:bottomBtn];
    
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bottomBtn.width, bottomBtn.height)];
    bottomLab.text = @"立即关联";
    bottomLab.textAlignment = NSTextAlignmentCenter;
   cancelLab.textColor = bottomLab.textColor = [GFICommonTool colorWithHexString:@"#ffffff"];
    bottomLab.font = [UIFont boldSystemFontOfSize:17.0];
    [bottomBtn addSubview:bottomLab];
    
    [self clipLayer:bottomBtn];
    [self clipLayer:cancelBtn];
    
  
}

- (void)clipLayer:(UIButton *)sender {
    
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 10.0;
    
}

- (void)bottomBtnClick{
    if (self.delegate
        &&[self.delegate respondsToSelector:@selector(popPromptViewCheckBtnCallBackWithTag:)]) {
        [self.delegate popPromptViewCheckBtnCallBackWithTag:self.tag];
    }
    [self removeFromSuperview];
}

- (void)cancelBtn{
    if (self.delegate
        &&[self.delegate respondsToSelector:@selector(popPromptViewCancelBtnCallBackWithTag:)]) {
        [self.delegate popPromptViewCancelBtnCallBackWithTag:self.tag];
    }
    [self removeFromSuperview];
}

//设置label高度
-(float)getNeededHeight:(NSString*)str andSize:(CGSize)labelSize andFont:(CGFloat)font
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


+(void)showWithTag:(NSInteger)tag target:(id<PopPromptViewDelegate>)target title:(NSString *)title{
   PopPromptView *promptView = [[PopPromptView alloc]initWithTitle:title];
    promptView.tag = tag;
   promptView.delegate = target;
   [[UIApplication sharedApplication].keyWindow addSubview:promptView];
}
@end
