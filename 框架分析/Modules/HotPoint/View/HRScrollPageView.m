//
//  HRScrollPageView.m
//  ZGHR
//
//  Created by 王大侠 on 16/12/8.
//  Copyright © 2016年 aspire. All rights reserved.
//

#import "HRScrollPageView.h"

#define HEADERVIEWHEIGHT 40

@implementation HRScrollPageView

- (instancetype)initWithFrame:(CGRect)frame ViewControllers:(NSArray<UIViewController *> *)viewControllers names:(NSArray<__kindof NSString *> * _Nullable)names
{
    if (self=[super initWithFrame:frame]) {
        
        self.currentPage=0;
        self.userInteractionEnabled=YES;
        
        self.viewControllers=viewControllers;
        
        self.scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.scrollview.delegate=self;
        self.scrollview.pagingEnabled=YES;
        self.scrollview.bounces = NO;
        [self addSubview:self.scrollview];
        
        self.headerView=[[HRPageHeaderview alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, HEADERVIEWHEIGHT) names:names];
        self.headerView.delegate=self;
        self.headerView.backgroundColor = [UIColor whiteColor];
        //不添加头部视图
//        [self addSubview:self.headerView];
        self.scrollview.showsHorizontalScrollIndicator=NO;
        self.scrollview.contentSize=CGSizeMake(self.bounds.size.width*self.viewControllers.count, 0);
        
        if (viewControllers.count>0) {
            [self addSubviewWithPage:0];
        }
    }
    return self;
    
}
//添加view
-(void)addSubviewWithPage:(NSInteger)page
{
    if (self.viewControllers.count>page) {
        UIView *currentView = self.viewControllers[page].view;
        if (currentView.superview==nil) {
            CGFloat width=self.scrollview.bounds.size.width;
            CGFloat height=self.scrollview.bounds.size.height;
            currentView.frame=CGRectMake(width*page, 0, width, height);
            [self.scrollview addSubview:currentView];
            
        }
        
    }
}



#pragma mark---uiscrollView delegate
/**结束拖拽*/
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"DidEndDragging");
}

/**正在滑动*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.didScroll) {
        self.didScroll();
    }
//    CGFloat margin = kISiPhone6 ?117:(kISiPhone6Plus?124:105);
//    CGFloat rate = (KCurrentWidths(margin))/kScreenWidth;
//    CGFloat fr = (rate) * scrollView.contentOffset.x;
//    CGRect rect = _headerView.currentLayer.frame;
//    rect.origin.x = fr;
//    _headerView.currentLayer.frame = rect;
}

/**滑动结束*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPage=(NSInteger)scrollView.contentOffset.x/(NSInteger)self.scrollview.bounds.size.width;
    if (self.endScrollWithIndex) {
        self.endScrollWithIndex(_currentPage);
    }
    [self addSubviewWithPage:self.currentPage];
    NSLog(@"DidEndDecelerating:");
    
    if (self.delegate) {
        [self.delegate HRDidEndDeceleratingCurrentPage:self.currentPage];
    }
    [self.headerView setCurrentheaderbtn:self.currentPage];
    
    CGRect rect = _headerView.currentLayer.frame;
    rect.origin.x = _headerView.buttons[_currentPage].origin.x;
    _headerView.currentLayer.frame = rect;
}


#pragma mark--page header dalegate
-(void)pageCurrentBtn:(NSInteger)current
{
    self.currentPage=current;
    
    self.scrollview.contentOffset=CGPointMake(self.bounds.size.width*current, 0);
    [self addSubviewWithPage:self.currentPage];
    [self scrollViewDidEndDecelerating:self.scrollview];
}
-(void)setContentOffset:(CGPoint)contentOffset{
    _contentOffset = contentOffset;
    self.scrollview.contentOffset = contentOffset;
    self.currentPage = (NSInteger)self.scrollview.contentOffset.x/(NSInteger)self.scrollview.bounds.size.width;
    [self addSubviewWithPage:self.currentPage];
}

- (void)setIsAddHeaderV:(BOOL)isAddHeaderV
{
    _isAddHeaderV = isAddHeaderV;
    if (_isAddHeaderV) {
        // 添加
        [self addSubview:self.headerView];
        self.scrollview.origin = CGPointMake(self.scrollview.origin.x, HEADERVIEWHEIGHT) ;
    }
}


@end
