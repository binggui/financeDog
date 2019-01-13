//
//  FDHomeTableViewCell.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/19.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "FDHomeTableViewCell.h"
#import "UILabel+VerticalAlign.h"

@interface FDHomeTableViewCell ()
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIImageView *imgView;
@property (strong, nonatomic) UIButton * readBtn;
@property (strong, nonatomic) UIButton * messageBtn;
@property (strong, nonatomic) UIButton * collectionBtn;
@property (strong, nonatomic) UIButton * shareBtn;
@end

@implementation FDHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
   
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setUpUI{
    
    //左边图片
    self.leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 180/2, 180/2)];
    self.leftImg.contentMode = UIViewContentModeScaleToFill;
    self.leftImg.clipsToBounds = YES;
    self.leftImg.image = [UIImage imageNamed:@"头像"];
//    if(![GFICommonTool isBlankString:[dic objectForKey:@"iconurl"]]){
//        [self.leftImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"iconurl"]] placeholderImage:[UIImage imageNamed:@"placeholder_default"]];
//    }
    [self.contentView addSubview:self.leftImg];
    
    //描述
    self.desLab = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImg.right+12, self.leftImg.top - 10, kScreenWidth-5-15-self.leftImg.width-15, 65)];
    self.desLab.backgroundColor = [UIColor clearColor];
    self.desLab.font = [UIFont systemFontOfSize:16.0];
    self.desLab.textColor = [GFICommonTool colorWithHexString:@"#383838"];
    
    [self.contentView addSubview:self.desLab];
    self.desLab.text = @"商量看都解封了市解放路口水巾案例可使肌肤卢卡斯九分裤按时发顺丰";
    self.desLab.numberOfLines = 0;
    
    if(self.desLab.height > 75){
        self.desLab.height = 75;
    }
    NSInteger btnWidth = 60;
    NSInteger marginNum = (kScreenWidth - 30 - self.leftImg.width - 12 - 3*btnWidth - 21) / 3;
    
    //搜索  source
    _sourceTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.leftImg.right + 13, self.leftImg.bottom - 23, btnWidth, 21)];
    _sourceTitle.backgroundColor = [UIColor clearColor];
    _sourceTitle.font = [UIFont systemFontOfSize:14.0];
    _sourceTitle.textColor = [GFICommonTool colorWithHexString:@"#383838"];
    [self.contentView  addSubview:_sourceTitle];
    
    //发布时间
    _publishTime = [[UILabel alloc]initWithFrame:CGRectMake(self.sourceTitle.right + 20, self.leftImg.bottom - 23, 120, 21)];
    _publishTime.backgroundColor = [UIColor clearColor];
    _publishTime.font = [UIFont systemFontOfSize:14.0];
    _publishTime.textColor = [GFICommonTool colorWithHexString:@"#383838"];
    [self.contentView  addSubview:_publishTime];
    
    
    //阅读量
    _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _readBtn.frame = CGRectMake(self.leftImg.right + 13, self.leftImg.bottom - 23, btnWidth, 21);
    [_readBtn setImage:[UIImage imageNamed:@"阅读量1"] forState:UIControlStateNormal];
    [_readBtn setTitle:@"999+" forState:UIControlStateNormal];
    [_readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    _readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
    _readBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.contentView  addSubview:_readBtn];

    //回复人数
    _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageBtn.frame = CGRectMake(_readBtn.right + marginNum, self.leftImg.bottom - 23, btnWidth, 21);
    [_messageBtn setImage:[UIImage imageNamed:@"评论1"] forState:UIControlStateNormal];
    [_messageBtn setTitle:@"30" forState:UIControlStateNormal];
    [_messageBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    _messageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
    _messageBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [self.contentView  addSubview:_messageBtn];
    
    //收藏人数
    _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionBtn.frame = CGRectMake(_messageBtn.right + marginNum, self.leftImg.bottom - 23, btnWidth, 21);
    [_collectionBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
    [_collectionBtn setTitle:@"12" forState:UIControlStateNormal];
    [_collectionBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    _collectionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
    _collectionBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [self.contentView  addSubview:_collectionBtn];
    
    //分享按钮
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(kScreenWidth - 21 - 15, self.leftImg.bottom - 23, 21, 21);
    [_shareBtn setImage:[UIImage imageNamed:@"分享1"] forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    _shareBtn.hidden = YES;
    [self.contentView  addSubview:_shareBtn];

    //底线
    self.bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, self.leftImg.bottom+15, kScreenWidth, 1/2.0)];
    self.bottomline.backgroundColor = [GFICommonTool colorWithHexString:@"#e7e7e7"];
    [self.contentView addSubview:self.bottomline];
    
    self.height = self.bottomline.bottom;
//    //button文字的偏移量
//    self.clickbtn.titleEdgeInsets = UIEdgeInsetsMake(0,  -(self.clickbtn.imageView.frame.origin.x+self.clickbtn.imageView.frame.size.width), 0, 0);
//    //button图片的偏移量
//    self.clickbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -(self.clickbtn.imageView.frame.origin.x ), 0, self.clickbtn.imageView.frame.origin.x);
    
  
    
}
-(void)setModel:(FDHomeModel *)model{
    _model = model;
    //    _imgView.backgroundColor=[UIColor colorWithHexString:personModel.imageAve];
    _leftImg.backgroundColor=KWhiteColor;
    [_leftImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"头像"]];
    _desLab.text = model.des;
    NSString *str =  model.des;

    if (model.source !=nil && model.source.length != 0) {
        _readBtn.hidden = YES;
        _messageBtn.hidden = YES;
        _collectionBtn.hidden = YES;
        _shareBtn.hidden = YES;
        _publishTime.hidden = NO;
        _sourceTitle.hidden = NO;
        _sourceTitle.text = model.source;
        _publishTime.text =  [self returndate:model.publishTime];
        
    }else{
        _readBtn.hidden = NO;
        _messageBtn.hidden = NO;
        _collectionBtn.hidden = NO;
        _publishTime.hidden = YES;
        _sourceTitle.hidden = YES;
        [_readBtn setTitle:model.readCount forState:UIControlStateNormal];
        [_messageBtn setTitle:model.messageCount forState:UIControlStateNormal];
        [_collectionBtn setTitle:model.collectionCount forState:UIControlStateNormal];
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
