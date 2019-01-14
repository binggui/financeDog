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

    
}


- (void)setModel:(BGCommentModel *)model{
    
    self.contentLabel.text = [NSString stringWithFormat:@"共%ld条互动评论 > ",(long)model.comment_more];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
