//
//  TTWeiboCommentTwoCell.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/2.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "TTWeiboCommentTwoCell.h"

@implementation TTWeiboCommentTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.backgroundColor = [GFICommonTool colorWithHexString:@"#f1f5f9"];
    self.contentLabel.attributedText = [self adjustTextColor:@"爱死你124312312安达市阿士大夫" rangeText:@"按时蚊器" color:[UIColor blueColor]];
    
}
- (NSMutableAttributedString *)adjustTextColor:(NSString *)text rangeText:(NSString *)rangeText color:(UIColor *)color {
    
    NSRange range = [text rangeOfString:rangeText];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 设置NSFontAttributeName属性修改字体大小
    
    [attribute addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    
    return attribute;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
