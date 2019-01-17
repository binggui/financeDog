//
//  BGCommentTableViewCell.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/22.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGCommentTableViewCell.h"
#import "UILabel+VerticalAlign.h"

@interface BGCommentTableViewCell ()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic, strong)UILabel *desLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (strong, nonatomic) UIView * bottomline;
@property (strong, nonatomic) UILabel * desBottomlabel;
@end

@implementation BGCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setUpUI{
    self.cellType = kAppDelegate.cellType;
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    _imgView.image  = [UIImage imageNamed:@"头像"];
    ViewRadius(_imgView, 20);
    [self.contentView addSubview:_imgView];
    
    //标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imgView.right+5, self.imgView.top + 10, 150, 20)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textColor = [GFICommonTool colorWithHexString:@"#383838"];
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = @"我的昵称昵称";
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 160, self.imgView.top + 10, 150, 20)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font = [UIFont systemFontOfSize:14.0];
    self.timeLabel.textColor = [GFICommonTool colorWithHexString:@"#383838"];
    self.timeLabel.textAlignment  = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.text = @"2018-12-12 09:12";
    if ([_cellType isEqualToString:@"comment"]) {
        //评论
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.imgView.bottom + 10, kScreenWidth - 15, 40)];
    }else{
        //消息
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.imgView.bottom + 5, kScreenWidth - 70, 35)];
    }
   
    self.desLabel.backgroundColor = [UIColor clearColor];
    self.desLabel.font = [UIFont systemFontOfSize:13.0];
    self.desLabel.textColor = [GFICommonTool colorWithHexString:@"#383838"];
    self.timeLabel.textAlignment  = NSTextAlignmentRight;
    [self.contentView addSubview:self.desLabel];
    self.desLabel.text = @"看都解封了市解阿斯达奥撒水电费放路口水巾案例可使肌肤卢卡斯九分裤";
    [self.desLabel alignTop];
    self.desLabel.numberOfLines = 0;

    if(self.desLabel.height > 40){
        self.desLabel.height = 40;
    }
    
    //评论
    
    self.desBottomlabel = [[UILabel alloc] initWithFrame:CGRectMake(self.desLabel.left, self.desLabel.bottom + 5, kScreenWidth - 70, 5)];
    self.desBottomlabel.backgroundColor = [UIColor clearColor];
    self.desBottomlabel.font = [UIFont systemFontOfSize:14.0];
    self.desBottomlabel.textColor = [GFICommonTool colorWithHexString:@"#383838"];
    self.desBottomlabel.font = [UIFont systemFontOfSize:13.0];
//    self.desBottomlabel.text = @"商量看都解封了市解阿斯达奥撒水电费放分裤";
    if (![_cellType isEqualToString:@"comment"]) {
        [self.contentView addSubview:self.desBottomlabel];
    }
    
    //底线
    if ([_cellType isEqualToString:@"comment"]) {

        self.bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, self.desLabel.bottom+5, KScreenWidth, 1/2.0)];
    }else{

        self.bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, self.desBottomlabel.bottom+5, KScreenWidth, 1/2.0)];
    }

    self.bottomline.backgroundColor = [GFICommonTool colorWithHexString:@"#e7e7e7"];
    [self.contentView addSubview:self.bottomline];
    
    self.height = self.bottomline.bottom;
    
}
- (void)setModel:(MessageAndCommentModel *)model{
    
    if (model.recommend_name != nil && model.recommend_name.length >0) {
        self.titleLabel.text = model.recommend_name;
        self.timeLabel.text = [self returndate: model.recommend_time];
        self.desLabel.text = model.content;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
    }else{
        self.titleLabel.text = model.name;
        self.timeLabel.text = [self returndate: model.pushTime];
        self.desLabel.text = model.content;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"金融狗"]];
    }
    

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
