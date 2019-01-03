//
//  HRPageHeaderview.h
//  ZGHR
//
//  Created by 王大侠 on 16/12/8.
//  Copyright © 2016年 aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pageHeaderBtnDelegate <NSObject>

-(void)pageCurrentBtn:(NSInteger)current;

@end

@interface HRPageHeaderview : UIView<UIScrollViewDelegate>

@property(nonatomic,weak) id <pageHeaderBtnDelegate> delegate;

@property(nullable,nonatomic,strong)UIScrollView *scrollview;
@property(nullable, nonatomic,copy) NSArray<__kindof UIButton *> *buttons;

@property(nullable,nonatomic,strong)UIButton *currentBtn;

@property (nonatomic,strong) CALayer *currentLayer;

- (instancetype)initWithFrame:(CGRect)frame names:(NSArray<__kindof NSString * > * __nullable)names;

- (void)setCurrentheaderbtn:(NSInteger)index;

@end
