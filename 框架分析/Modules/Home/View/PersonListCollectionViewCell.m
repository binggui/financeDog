//
//  PersonListCollectionViewCell.m
//  MiAiApp
//
//  Created by 丙贵 on 18/7/14.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "PersonListCollectionViewCell.h"

@interface PersonListCollectionViewCell()

@property (strong, nonatomic) UILabel *lblHobby;//爱好
@property (strong, nonatomic) UIImageView *imgHead;//头像
@property (strong, nonatomic) UILabel *lblNickName;//昵称
@property (strong, nonatomic) UILabel *lblAge;//年龄
@property (strong, nonatomic) UILabel *lblFrom;//来自哪里
@property (strong, nonatomic) UILabel *juli;//距离
@property (strong, nonatomic) UIView *line1;//线1
@property (strong, nonatomic) UIView *line2;//线2
@property (strong, nonatomic) UIButton * readBtn;
@property (strong, nonatomic) UIButton * messageBtn;
@property (strong, nonatomic) UIButton * collectionBtn;
@property (strong, nonatomic) UIButton * shareBtn;
@end
@implementation PersonListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor=KWhiteColor;
        ViewRadius(self, 5);
        NSLog(@"-------");
        _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20 - waterHeightChange)];
        _imgView.contentMode=UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds=YES;
        _imgView.backgroundColor=KWhiteColor;
        //        _imgView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_imgView];
        _lblHobby=[[UILabel alloc]initWithFrame:CGRectMake(10, _imgView.bottom, frame.size.width-20, 20)];
        _lblHobby.numberOfLines=0;
        _lblHobby.textColor=CFontColor1;
        _lblHobby.font=FFont1;
        [self addSubview:_lblHobby];
        
        _line1=[[UIView alloc]initWithFrame:CGRectMake(0, _lblHobby.bottom + 10, frame.size.width, 1)];
        _line1.backgroundColor=CLineColor;
        [self addSubview:_line1];
    
        NSInteger btnWidth = 50;
        if (kISiPhone5) {
            btnWidth = 40;
        }
        NSInteger marginNum = (frame.size.width - 20 - 3*btnWidth) / 2;
        
        //阅读量
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _readBtn.frame = CGRectMake(10, _line1.bottom +10, btnWidth, 21);
        [_readBtn setImage:[UIImage imageNamed:@"阅读量1"] forState:UIControlStateNormal];
        [_readBtn setTitle:@"999+" forState:UIControlStateNormal];
        [_readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
        _readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
        _readBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [self  addSubview:_readBtn];
        
        //回复人数
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.frame = CGRectMake(_readBtn.right + marginNum, self.readBtn.top, btnWidth, 21);
        [_messageBtn setImage:[UIImage imageNamed:@"评论1"] forState:UIControlStateNormal];
        [_messageBtn setTitle:@"30" forState:UIControlStateNormal];
        [_messageBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
        _messageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        [self  addSubview:_messageBtn];
        
        //收藏人数
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.frame = CGRectMake(_messageBtn.right + marginNum, self.readBtn.top, btnWidth, 21);
        [_collectionBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
        [_collectionBtn setTitle:@"12" forState:UIControlStateNormal];
        [_collectionBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
        _collectionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        [self addSubview:_collectionBtn];
        
    }
    return self;
}
-(void)setPersonModel:(FDHomeModel *)personModel{
    _personModel=personModel;
//    _imgView.backgroundColor=[UIColor colorWithHexString:personModel.imageAve];
    _imgView.backgroundColor=KWhiteColor;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:personModel.img] placeholderImage:[UIImage imageNamed:@"头像"]];
    _lblHobby.text=personModel.des;
    _lblFrom.text=personModel.source;

    [_readBtn setTitle:personModel.readCount forState:UIControlStateNormal];

    
    
    CGFloat itemH = personModel.height * self.width / personModel.width;
    _imgView.frame=CGRectMake(0, 0, self.frame.size.width, itemH - waterHeightChange);

    _lblHobby.frame=CGRectMake(10, _imgView.bottom+10, self.frame.size.width-20, personModel.hobbysHeight);

    _line1.top=_lblHobby.bottom+10;
    _readBtn.top=_line1.bottom+10;
    _messageBtn.top = _readBtn.top;
    _collectionBtn.top = _readBtn.top;
    
}
@end
