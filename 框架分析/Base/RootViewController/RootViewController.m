//
//  RootViewController.m
//  框架分析
//
//  Created by 丙贵 on 18/5/17.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "RootViewController.h"
#import "BGLoginViewController.h"

@interface RootViewController ()

@property (nonatomic,strong) UIImageView* noDataView;

@end

@implementation RootViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}
//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =KWhiteColor;
    //是否显示返回按钮
    self.isShowLiftBack = YES;
    //防止滚动按钮偏移
    self.extendedLayoutIncludesOpaqueBars = YES;
    //默认导航栏样式：黑字
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (AppDelegate *)appDelegate{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return  appDelegate;
}

//用第三方插件显示网络加载提示
#pragma mark - MBProgress
- (void)showHUDLoading:(NSString *)title{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = RGBACOLOR(LOADING_BACK_RED_COLOR, LOADING_BACK_GREEN_COLOR, LOADING_BACK_BULE_COLOR, LODING_BACK_ALPHPA);
    self.hud.labelColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
    UIImageView* rotationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 51, 51)];
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 1; i <= 16; i++) {
        UIImage* qqImage = [UIImage imageNamed:[NSString stringWithFormat:@"rotation_action_%d.png",i]];
        [array addObject:qqImage];
    }
    [rotationView setAnimationImages:array];
    //设置播放时间(在多少秒之内完成)
    [rotationView setAnimationDuration:CHANGE_PICK_TIME];
    //设置播放次数 0:无限
    [rotationView setAnimationRepeatCount:0];
    //开始播放动画
    [rotationView startAnimating];
    self.hud.detailsLabelText = @"  请稍后...   ";
    self.hud.detailsLabelColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
    self.hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    self.hud.customView = rotationView;
    
    self.hud.mode = MBProgressHUDModeCustomView;
    [self.hud show:YES];
    if (title != nil) {
        self.hud.labelText = title;
    }
}

- (void)hideHUDLoading{
    if (self.hud) {
        //         self.hud.hidden = YES;
        
        [self.hud removeFromSuperview];
        self.hud = nil;
    }
}

- (void)showHUDComplete:(NSString *)title{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.color = RGBACOLOR(LOADING_BACK_RED_COLOR, LOADING_BACK_GREEN_COLOR, LOADING_BACK_BULE_COLOR, LODING_BACK_ALPHPA);
    self.hud.labelColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
    self.hud.mode = MBProgressHUDModeCustomView;
    
    if (title != nil) {
        self.hud.labelText = title;
    }
    if (![self.hud.detailsLabelText isEqualToString:@""]) {
        self.hud.detailsLabelText = @"";
    }
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:1.7];
}

- (void)showHUDTip:(NSString *)title duration:(CGFloat)duration{
    if (!self.hud) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.color = RGBACOLOR(LOADING_BACK_RED_COLOR, LOADING_BACK_GREEN_COLOR, LOADING_BACK_BULE_COLOR, LODING_BACK_ALPHPA);
        self.hud.labelColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
    }
    
    self.hud.mode = MBProgressHUDModeCustomView;
    if (![self.hud.detailsLabelText isEqualToString:@""]) {
        self.hud.detailsLabelText = @"";
    }
    if (self.hud.customView) {
        self.hud.customView = nil;
    }
    if (title != nil) {
        // self.hud.labelText = title;
        UILabel *ejectLabel = [[UILabel alloc]init];
        UIFont *fnt = [UIFont boldSystemFontOfSize:16];
        ejectLabel.font = fnt;
        CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        
        ejectLabel.numberOfLines = 2;
        if (title.length >= 15) {
            ejectLabel.frame = CGRectMake(0, 0, size.width, 65);
            ejectLabel.numberOfLines = 3;
        }else if(title.length >= 10 && title.length < 15){
            ejectLabel.frame = CGRectMake(0, 0, size.width, 22);
        }else {
            ejectLabel.frame = CGRectMake(0, 0, 180, 22);
        }
        
        ejectLabel.text = title;
        ejectLabel.textColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
        ejectLabel.textAlignment = NSTextAlignmentCenter;
        ejectLabel.text = title;
        self.hud.customView = ejectLabel;
    }
    
    //    self.hud.dimBackground = NO;
    [self.hud show:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUDLoading];
    });
    
}
- (void)showHUDTip:(NSString *)title{
    if (!self.hud) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.color = RGBACOLOR(LOADING_BACK_RED_COLOR, LOADING_BACK_GREEN_COLOR, LOADING_BACK_BULE_COLOR, LODING_BACK_ALPHPA);
        self.hud.labelColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
    }
    
    self.hud.mode = MBProgressHUDModeCustomView;
    if (![self.hud.detailsLabelText isEqualToString:@""]) {
        self.hud.detailsLabelText = @"";
    }
    if (self.hud.customView) {
        self.hud.customView = nil;
    }
    if (title != nil) {
        // self.hud.labelText = title;
        UILabel *ejectLabel = [[UILabel alloc]init];
        UIFont *fnt = [UIFont boldSystemFontOfSize:16];
        ejectLabel.font = fnt;
        CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        
        ejectLabel.numberOfLines = 2;
        if (title.length >= 15) {
            ejectLabel.frame = CGRectMake(0, 0, size.width, 65);
            ejectLabel.numberOfLines = 3;
        }else if(title.length >= 10 && title.length < 15){
            ejectLabel.frame = CGRectMake(0, 0, size.width, 22);
        }else {
            ejectLabel.frame = CGRectMake(0, 0, 180, 22);
        }
        
        ejectLabel.text = title;
        ejectLabel.textColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
        ejectLabel.textAlignment = NSTextAlignmentCenter;
        ejectLabel.text = title;
        self.hud.customView = ejectLabel;
    }
    
    //    self.hud.dimBackground = NO;
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:1.7];

}

- (void)showHUDTipAfterFiveM:(NSString *)title{
    if (!self.hud) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.color = RGBACOLOR(LOADING_BACK_RED_COLOR, LOADING_BACK_GREEN_COLOR, LOADING_BACK_BULE_COLOR, LODING_BACK_ALPHPA);
        self.hud.labelColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
    }
    
    self.hud.mode = MBProgressHUDModeCustomView;
    if (![self.hud.detailsLabelText isEqualToString:@""]) {
        self.hud.detailsLabelText = @"";
    }
    if (self.hud.customView) {
        self.hud.customView = nil;
    }
    if (title != nil) {
        // self.hud.labelText = title;
        UILabel *ejectLabel = [[UILabel alloc]init];
        UIFont *fnt = [UIFont boldSystemFontOfSize:16];
        ejectLabel.font = fnt;
        CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        
        ejectLabel.numberOfLines = 2;
        if (title.length >= 15) {
            ejectLabel.frame = CGRectMake(0, 0, size.width, 65);
            ejectLabel.numberOfLines = 3;
        }else if(title.length >= 10 && title.length < 15){
            ejectLabel.frame = CGRectMake(0, 0, size.width, 22);
        }else {
            ejectLabel.frame = CGRectMake(0, 0, 180, 22);
        }
        
        ejectLabel.text = title;
        ejectLabel.textColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
        ejectLabel.textAlignment = NSTextAlignmentCenter;
        ejectLabel.text = title;
        self.hud.customView = ejectLabel;
    }
    
    //    self.hud.dimBackground = NO;
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:3.5];
}


- (void)showHUDTipWithInit:(NSString *)title{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = RGBACOLOR(LOADING_BACK_RED_COLOR, LOADING_BACK_GREEN_COLOR, LOADING_BACK_BULE_COLOR, LODING_BACK_ALPHPA);
    self.hud.labelColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
    self.hud.mode = MBProgressHUDModeCustomView;
    
    if (title != nil) {
        UILabel *ejectLabel = [[UILabel alloc]init];
        UIFont *fnt = [UIFont boldSystemFontOfSize:16];
        ejectLabel.font = fnt;
        CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        
        ejectLabel.numberOfLines = 2;
        if (title.length >= 15) {
            ejectLabel.frame = CGRectMake(0, 0, size.width, 65);
            ejectLabel.numberOfLines = 3;
        }else if(title.length >= 10 && title.length < 15){
            ejectLabel.frame = CGRectMake(0, 0, size.width, 22);
        }else {
            ejectLabel.frame = CGRectMake(0, 0, 180, 22);
        }
        
        ejectLabel.text = title;
        ejectLabel.textColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
        ejectLabel.textAlignment = NSTextAlignmentCenter;
        ejectLabel.text = title;
        self.hud.customView = ejectLabel;
    }
    //    self.hud.dimBackground = NO;
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:1.7];
}
- (void)showHUDTipCannotFindAppWithInit:(NSString *)title{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = RGBACOLOR(LOADING_BACK_RED_COLOR, LOADING_BACK_GREEN_COLOR, LOADING_BACK_BULE_COLOR, LODING_BACK_ALPHPA);
    self.hud.labelColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
    self.hud.mode = MBProgressHUDModeCustomView;
    
    if (title != nil) {
        UILabel *ejectLabel = [[UILabel alloc]init];
        UIFont *fnt = [UIFont boldSystemFontOfSize:16];
        ejectLabel.font = fnt;
        CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        
        ejectLabel.numberOfLines = 2;
        if (title.length >= 15) {
            ejectLabel.frame = CGRectMake(0, 0, size.width, 65);
            ejectLabel.numberOfLines = 3;
        }else if(title.length >= 10 && title.length < 15){
            ejectLabel.frame = CGRectMake(0, 0, size.width, 22);
        }else {
            ejectLabel.frame = CGRectMake(0, 0, 180, 22);
        }
        
        ejectLabel.text = title;
        ejectLabel.textColor = RGBCOLOR(LOADING_TEXT_RED_COLOR, LOADING_TEXT_GREEN_COLOR, LOADING_TEXT_BULE_COLOR);
        ejectLabel.textAlignment = NSTextAlignmentCenter;
        ejectLabel.text = title;
        self.hud.customView = ejectLabel;
    }
    //    self.hud.dimBackground = NO;
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:1.7];
}


- (void)showLoadingAnimation
{
    
}

- (void)stopLoadingAnimation
{
    
}

-(void)showNoDataImage
{
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"generl_nodata"]];
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            [_noDataView setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
            [obj addSubview:_noDataView];
        }
    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}
+ (void)login:(UIViewController *)controller{
    
    BGLoginViewController* loginViewController = [[BGLoginViewController alloc]init];
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:loginViewController];
    nvc.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [controller presentViewController:loginViewController animated:YES completion:nil];
}

/**
 *  首页单独写的,没有底部加载
 *
 *  @return UITableView
 */
- (UITableView *)tableHomeView
{
    if (_tableHomeView == nil) {
        _tableHomeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - TAB_HEIGHT) style:UITableViewStylePlain];
        _tableHomeView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //        _tableView.estimatedRowHeight = 0;
        //        _tableView.estimatedSectionHeaderHeight = 0;
        //        _tableView.estimatedSectionFooterHeight = 0;
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableHomeView.mj_header = header;
        
        _tableHomeView.backgroundColor=CViewBgColor;
        _tableHomeView.scrollsToTop = YES;
        _tableHomeView.tableFooterView = [[UIView alloc] init];
    }
    return _tableHomeView;
}
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableCommentView
{
    if (_tableCommentView == nil) {
        _tableCommentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - TAB_HEIGHT) style:UITableViewStyleGrouped];
        _tableCommentView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //        _tableView.estimatedRowHeight = 0;
        //        _tableView.estimatedSectionHeaderHeight = 0;
        //        _tableView.estimatedSectionFooterHeight = 0;
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableCommentView.mj_header = header;
        
        //底部刷新
        _tableCommentView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        //        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        //        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
        
        _tableCommentView.backgroundColor=CViewBgColor;
        _tableCommentView.scrollsToTop = YES;
        _tableCommentView.tableFooterView = [[UIView alloc] init];
    }
    return _tableCommentView;
}
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - TAB_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableView.mj_header = header;
        
        //底部刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        //        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        //        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
        
        _tableView.backgroundColor=CViewBgColor;
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
/**
 *  返回上面
 *
 *  @return
 */

-(UIImageView *)robotImageView{
    if (_robotImageView == nil) {

    UIImage *imgRobot = [UIImage imageNamed:@"置顶"];
    _robotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-62, kScreenHeight -TAB_HEIGHT - 75, 42, 42)];
//    ViewRadius(_robotImageView, 21);
    _robotImageView.image = imgRobot;
    _robotImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRobotAction:)];
    [_robotImageView addGestureRecognizer:singleTap];
    
    }
    return _robotImageView;
}
- (void) singleTapRobotAction:(UIGestureRecognizer *) gesture
{
    
    NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];


}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , KScreenHeight - kTopHeight - kTabBarHeight) collectionViewLayout:flow];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _collectionView.mj_header = header;

        //底部刷新
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        
        //#ifdef kiOS11Before
        //
        //#else
        //        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        _collectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        //        _collectionView.scrollIndicatorInsets = _collectionView.contentInset;
        //#endif
        
        _collectionView.backgroundColor=CViewBgColor;
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}
-(void)headerRereshing{
    
}

-(void)footerRereshing{
    
}

/**
 *  是否显示返回按钮
 */
- (void) setIsShowLiftBack:(BOOL)isShowLiftBack
{
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        [self addNavigationItemWithImageNames:@[@"back_icon"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
- (void)backBtnClicked
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark ————— 导航栏 添加图片按钮 —————
/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

#pragma mark ————— 导航栏 添加文字按钮 —————
- (NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = SYSTEMFONT(16);
        [btn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        //设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    return buttonArray;
}

//取消请求
- (void)cancelRequest
{
    
}

- (void)dealloc
{
    [self cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSMutableDictionary*)getDataFromPlist {
    //沙盒获取路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePatch = [path stringByAppendingPathComponent:@"PersonList.plist"];//没有会自动创建
    NSLog(@"file patch%@",filePatch);
    NSMutableDictionary *sandBoxDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePatch];

    NSLog(@"sandBox %@",sandBoxDataDic);//直接打印数据
    return sandBoxDataDic;
}

- (void)writeDataToPlist:(NSMutableDictionary *)dic {
    //这里使用位于沙盒的plist（程序会自动新建的那一个）
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePatch = [path stringByAppendingPathComponent:@"PersonList.plist"];

    [dic writeToFile:filePatch atomically:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
