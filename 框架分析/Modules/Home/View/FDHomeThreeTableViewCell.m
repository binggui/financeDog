//
//  FDHomeThreeTableViewCell.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/15.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "FDHomeThreeTableViewCell.h"

@interface FDHomeThreeTableViewCell()
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIImageView *imgView;
@property (strong, nonatomic) UIButton * readBtn;
@property (strong, nonatomic) UIButton * messageBtn;
@property (strong, nonatomic) UIButton * collectionBtn;
@property (strong, nonatomic) UIButton * shareBtn;
@end

@implementation FDHomeThreeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setUpUI{
    
    //描述
    self.desLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth-30, 30)];
    self.desLab.backgroundColor = [UIColor clearColor];
    self.desLab.font = [UIFont systemFontOfSize:16.0];
    self.desLab.textColor = [GFICommonTool colorWithHexString:@"#383838"];
    
    [self.contentView addSubview:self.desLab];
    self.desLab.text = @"商量看都解封了市解放路口水巾案例可使肌肤卢卡斯九分裤按时发顺丰";
    self.desLab.numberOfLines = 0;
    
    if(self.desLab.height > 75){
        self.desLab.height = 75;
    }
    
    NSInteger imgWidth = 5;
    NSInteger imgNum = (kScreenWidth - 30 - 2*imgWidth) / 3;
    //左边图片
    self.leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.desLab.bottom + 5, imgNum, 150/2)];
    self.leftImg.contentMode = UIViewContentModeScaleToFill;
    self.leftImg.clipsToBounds = YES;
    self.leftImg.image = [UIImage imageNamed:@"头像"];
    [self.contentView addSubview:self.leftImg];
    //中间图片
    self.middleImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.leftImg.right + imgWidth, self.leftImg.top , imgNum, 150/2)];
    self.middleImg.contentMode = UIViewContentModeScaleToFill;
    self.middleImg.clipsToBounds = YES;
    self.middleImg.image = [UIImage imageNamed:@"头像"];
    [self.contentView addSubview:self.middleImg];
    //右面图片
    self.rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.middleImg.right + imgWidth, self.leftImg.top , imgNum, 150/2)];
    self.rightImg.contentMode = UIViewContentModeScaleToFill;
    self.rightImg.clipsToBounds = YES;
    self.rightImg.image = [UIImage imageNamed:@"头像"];
    [self.contentView addSubview:self.rightImg];
    
    
    NSInteger btnWidth = 60;
    NSInteger marginNum = (kScreenWidth - 30 - 3*btnWidth) / 2;
    
    
    //阅读量
    _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _readBtn.frame = CGRectMake(15, self.leftImg.bottom + 10, btnWidth, 21);
    [_readBtn setImage:[UIImage imageNamed:@"阅读量1"] forState:UIControlStateNormal];
    [_readBtn setTitle:@"999+" forState:UIControlStateNormal];
    [_readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    _readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
    _readBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.contentView  addSubview:_readBtn];
    
    //回复人数
    _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageBtn.frame = CGRectMake(_readBtn.right + marginNum, self.leftImg.bottom + 10, btnWidth, 21);
    [_messageBtn setImage:[UIImage imageNamed:@"评论1"] forState:UIControlStateNormal];
    [_messageBtn setTitle:@"30" forState:UIControlStateNormal];
    [_messageBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    _messageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
    _messageBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [self.contentView  addSubview:_messageBtn];
    
    //收藏人数
    _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionBtn.frame = CGRectMake(_messageBtn.right + marginNum, self.leftImg.bottom + 10, btnWidth, 21);
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
    self.bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, _readBtn.bottom + 5, kScreenWidth, 1/2.0)];
    self.bottomline.backgroundColor = [GFICommonTool colorWithHexString:@"#e7e7e7"];
    [self.contentView addSubview:self.bottomline];
    
    self.height = self.bottomline.bottom;
    
}
-(void)setModel:(FDHomeModel *)model{
    _model = model;
    //    _imgView.backgroundColor=[UIColor colorWithHexString:personModel.imageAve];
    _leftImg.backgroundColor=KWhiteColor;
    _middleImg.backgroundColor=KWhiteColor;
    _rightImg.backgroundColor=KWhiteColor;
    _desLab.text = model.des;
    
    NSDictionary *left = model.photos[0];
    NSDictionary *middle = model.photos[1];
    NSDictionary *right = model.photos[2];
    
    [_leftImg sd_setImageWithURL:[NSURL URLWithString:left[@"url"]] placeholderImage:[UIImage imageNamed:@"头像"]];
    [_middleImg sd_setImageWithURL:[NSURL URLWithString:middle[@"url"]] placeholderImage:[UIImage imageNamed:@"头像"]];
    [_rightImg sd_setImageWithURL:[NSURL URLWithString:right[@"url"]] placeholderImage:[UIImage imageNamed:@"头像"]];
    
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
