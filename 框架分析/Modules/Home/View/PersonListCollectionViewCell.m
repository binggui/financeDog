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
        
        _line1=[[UIView alloc]initWithFrame:CGRectMake(0, _lblHobby.bottom+10, frame.size.width, 0.5)];
        _line1.backgroundColor=CLineColor;
        [self addSubview:_line1];
        
        _lblFrom=[[UILabel alloc]initWithFrame:CGRectMake(10, _line1.bottom +10, frame.size.width - 80, 21)];
        _lblFrom.textColor=CFontColor2;
        _lblFrom.font=FFont1;
        [self addSubview:_lblFrom];
        
        
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _readBtn.frame = CGRectMake(frame.size.width - 70, _lblFrom.top - 23, 60, 21);
        [_readBtn setImage:[UIImage imageNamed:@"浏览"] forState:UIControlStateNormal];
        [_readBtn setTitle:@"1600" forState:UIControlStateNormal];
        [_readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
        _readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        _readBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [self  addSubview:_readBtn];
        
//        _juli=[[UILabel alloc]initWithFrame:CGRectMake(self.width - 80, _line1.bottom +10, 70, 15)];
//        _juli.textAlignment = NSTextAlignmentRight;
//        _juli.textColor=CFontColor2;
//        _juli.font=FFont1;
//        [self addSubview:_juli];
    }
    return self;
}
-(void)setPersonModel:(FDHomeModel *)personModel{
    _personModel=personModel;
//    _imgView.backgroundColor=[UIColor colorWithHexString:personModel.imageAve];
    _imgView.backgroundColor=KWhiteColor;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:personModel.img] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    _lblHobby.text=personModel.des;
    _lblFrom.text=personModel.source;

    [_readBtn setTitle:personModel.readCount forState:UIControlStateNormal];

    
    
    CGFloat itemH = personModel.height * self.width / personModel.width;
    _imgView.frame=CGRectMake(0, 0, self.frame.size.width, itemH - waterHeightChange);

    _lblHobby.frame=CGRectMake(10, _imgView.bottom+10, self.frame.size.width-20, personModel.hobbysHeight);

    _line1.top=_lblHobby.bottom+10;
    _lblFrom.top=_line1.bottom+10;
    _readBtn.top = _lblFrom.top;
}
@end
