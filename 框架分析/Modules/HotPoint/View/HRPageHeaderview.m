//
//  HRPageHeaderview.m
//  ZGHR
//
//  Created by 王大侠 on 16/12/8.
//  Copyright © 2016年 aspire. All rights reserved.
//

#import "HRPageHeaderview.h"

@interface HRPageHeaderview()
{
    CGFloat Margin;
    CGFloat BtnWidth;
}

@end

@implementation HRPageHeaderview

-(instancetype)initWithFrame:(CGRect)frame names:(NSArray<__kindof NSString *> *)names
{
    if (self=[super initWithFrame:frame]) {
        
        if (kISiPhone5) {
            Margin = 15;
            BtnWidth = 65;
        }else if (kISiPhone6){
            Margin = 20;
            BtnWidth = 75;
        }else{
            Margin = 20;
            BtnWidth = 80;
        }
        //交互
        self.userInteractionEnabled = YES;
        
        if(names.count == 0) return self;
        self.scrollview=[[UIScrollView alloc]initWithFrame:self.bounds];
        
        [self addSubview:self.scrollview];
        //关闭滚动条
        self.scrollview.showsHorizontalScrollIndicator = NO;
        self.scrollview.showsVerticalScrollIndicator = NO;
        //关闭弹簧
        self.scrollview.bounces = NO;
        
        NSMutableArray *btns=[[NSMutableArray alloc]init];
        float btnMargin = (kScreenWidth - Margin * 2 - BtnWidth*names.count)/(names.count-1);
        if (kISiPhone5) {
            btnMargin = (kScreenWidth - 15 * 2 - BtnWidth*names.count)/(names.count-1);
        }
        
        //  按钮布局
        for (NSInteger i=0; i<names.count; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:names[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            
            [self.scrollview addSubview:button];
        
            button.size = CGSizeMake(BtnWidth, self.height);
            button.origin = CGPointMake(Margin + (BtnWidth + btnMargin)*i, 0);

//            button.frame = CGRectMake((SCREEN_WIDTH/names.count)*i, 0, (SCREEN_WIDTH/names.count), self.height);

            [button setTitleColor:[GFICommonTool colorWithHexString:@"#666666"] forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button setTitleColor:[GFICommonTool colorWithHexString:@"#19a4f4"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btns addObject:button];
            
            if (!_currentLayer) {
                
                CALayer *layer = [[CALayer alloc] init];
                layer.frame = CGRectMake(button.bounds.origin.x, button.bottom-2, button.width, 2);
                layer.backgroundColor = [GFICommonTool colorWithHexString:@"#19a4f4"].CGColor;
                [self.scrollview.layer addSublayer:layer];
                self.currentLayer = layer;
            }
            
            if (i==0) {
                button.selected=YES;
                self.currentBtn=button;
            }
        }
        self.buttons=btns;
        UIButton *lastBtn=[self.buttons lastObject];
        self.scrollview.contentSize=CGSizeMake(CGRectGetMaxX(lastBtn.frame), 0);
       
    }
    return self;
}


-(void)headerBtnClick:(UIButton *)headerBtn
{
    NSInteger currentPage=[self.buttons indexOfObjectIdenticalTo:headerBtn];
    [self setCurrentheaderbtn:currentPage];
    if (self.delegate) {
        [self.delegate pageCurrentBtn:currentPage];
    }
    
}

-(void)setCurrentheaderbtn:(NSInteger)index
{
    self.currentBtn.selected=NO;
    self.currentBtn=self.buttons[index];
    self.currentBtn.selected=YES;
}


@end
