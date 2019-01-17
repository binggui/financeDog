//
//  TTWeiboCommentCell.m
//  HighCopyTodayNews
//
//  Created by hack on 2017/8/17.
//  Copyright © 2017年 hack. All rights reserved.
//

#import "TTWeiboCommentCell.h"
#import "WeiboCommentModel.h"
#import "UIImageView+WebCache.h"
#import "NSDate+YYAdd.h"
@implementation TTWeiboCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _goodFlag = NO;
    self.txImg.image = [UIImage imageNamed:@"头像"];
    [self.nameShow setTitle:@"按实际开发了" forState:0];
    [self.goodButton setTitle:[NSString stringWithFormat:@" %d",12] forState:UIControlStateNormal];
    self.contentLable.text = @"老卡机是风口浪尖案例开始放假啊看来解放路卡就是放假奥拉夫卡死弗兰克静安寺";
    self.timeShowLabelNew.text = @"刚刚";
    self.timeShowLable.text = @"  ";
    self.goodButton.hidden = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)recallRecommendButton:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(didSelectPeople:)]) {
        [_delegate didSelectPeople:self.cellIndexPath];
    }
    
}
- (IBAction)changeGoogButtonAction:(id)sender {
    NSLog(@"点赞");
    _goodFlag = !_goodFlag;
    if(_goodFlag){
        [self.goodButton setTitle:[NSString stringWithFormat:@"%ld",_model.comment_like + 1] forState:UIControlStateNormal];
        [self.goodButton setImage:[UIImage imageNamed:@"点赞选中3"] forState:UIControlStateNormal];
    
    }else{
        [self.goodButton setTitle:[NSString stringWithFormat:@"%ld",_model.comment_like] forState:UIControlStateNormal];
        [self.goodButton setImage:[UIImage imageNamed:@"点赞3"] forState:UIControlStateNormal];

    }
}
- (void)setModel:(BGCommentModel *)model{
    if (model.comment_activity_id != nil ) {
        self.remmentButton.hidden = YES;
    }else{
        self.remmentButton.hidden = NO;
    }
    [self.txImg sd_setImageWithURL:[NSURL URLWithString:model.comment_avatal]];
    [self.nameShow setTitle:model.comment_name forState:0];
    [self.goodButton setTitle:[NSString stringWithFormat:@"%ld",model.comment_like] forState:UIControlStateNormal];

    self.contentLable.text=model.comment_content;
    
    long long time = model.comment_time;
    NSDate *timedate=[NSDate dateFromTimeInterval:time];
    NSString *timeStr=[NSDate detailTimeAgoString:timedate];
    self.timeShowLabelNew.text=[self returndate: [NSString stringWithFormat:@"%ld",model.comment_time ]];
    
    [self.txImg  sd_setImageWithURL:[NSURL URLWithString:model.comment_avatal] placeholderImage:[UIImage imageNamed:@"头像"]];

}
- (NSString *)returndate:(NSString *)str1
{
    int x=[str1  intValue];
    NSDate  *date1 = [NSDate dateWithTimeIntervalSince1970:x];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    return [dateformatter stringFromDate:date1];
    
}
@end
