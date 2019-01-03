//
//  HRScrollPageView.h
//  ZGHR
//
//  Created by 王大侠 on 16/12/8.
//  Copyright © 2016年 aspire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRPageHeaderview.h"

@protocol HRScrollPageViewDelegate <NSObject>

-(void)HRDidEndDeceleratingCurrentPage:(NSInteger)currentPage;

@end

@interface HRScrollPageView : UIView<UIScrollViewDelegate,pageHeaderBtnDelegate>
//header
@property(nonatomic,strong)HRPageHeaderview *headerView;
//下面的视图
@property(nullable,nonatomic,strong) UIScrollView *scrollview;
@property(nullable,nonatomic,weak) id <HRScrollPageViewDelegate> delegate;
//当前第几个view
@property(nonatomic,assign) NSInteger currentPage;
/**加载的view的控制器viewcontroller*/
@property(nullable, nonatomic,copy) NSArray<__kindof UIViewController *> *viewControllers;

// 判断是否添加headerView
@property (nonatomic,assign) BOOL isAddHeaderV;

@property(nonatomic, assign)CGPoint contentOffset;
@property (nonatomic, copy)void (^didScroll)();
@property (nonatomic, copy)void (^endScrollWithIndex)();
- (instancetype)initWithFrame:(CGRect)frame ViewControllers:(NSArray<__kindof UIViewController *> * __nullable)viewControllers names:(NSArray<__kindof NSString *> * __nullable)names;

@end
