//
//  PersonListViewController.m
//  框架分析
//
//  Created by 丙贵 on 18/5/17.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "PersonListViewController.h"
#import "PersonListLogic.h"
#import "WaterFlowLayout.h"
#import "PersonListCollectionViewCell.h"
#import "XYTransitionProtocol.h"
#import "UICollectionView+IndexPath.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "WGAdvertisementView.h"
#import "CommonModel.h"
#import "FDHomeModel.h"
#import "CXSearchController.h"
#import "PersonDetailViewController.h"
#import "BGMessageHistoryTableViewController.h"
#import "BGSearchTableViewController.h"

#define itemWidthHeight ((kScreenWidth-30)/2)

@interface PersonListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterFlowLayoutDelegate,XYTransitionProtocol,PersonListLogicDelegate,WGAdvertisementViewDelegate,CXSearchControllerDelegate>{
    WGAdvertisementView *_adview;
    NSMutableArray *_ads;
}

@property(nonatomic,strong) PersonListLogic *logic;//逻辑层
@property(nonatomic,strong) UIView *topView;//置顶View

@end

@implementation PersonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    
    //初始化逻辑类
    _logic = [PersonListLogic new];
    _logic.delegagte = self;
    //请求主页轮播图图片
    [self getPics:1 andUrl:kJRG_exampleapi_info andId:0 andJumpUrl:nil];
    [self setupUI];
    [self setupNavigation];
    //开始第一次数据拉取
    [self.collectionView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)setupNavigation{
    //    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    //    [self wr_setNavBarBackgroundAlpha:0];
    //    self.tableView.contentInset = UIEdgeInsetsMake( - NAV_HEIGHT, 0, 0, 0);
    [self addNavigationItemWithImageNames:@[@"个人"] isLeft:YES target:self action:@selector(personClickedOKbtn:) tags:@[@999]];
    [self addNavigationItemWithImageNames:@[@"消息"] isLeft:NO target:self action:@selector(naviBtnClick:) tags:@[@1000]];
    
    UIView *backgroundV = [[UIView alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth - 100, 30)];
    backgroundV.backgroundColor = [UIColor whiteColor];
    ViewRadius(backgroundV, 15);
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, kScreenWidth - 100, 30);
    [backgroundV addSubview:button];
    [button setTitle:@"搜内容/标题/咨询" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showAllQuestions) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    
    UIView *pointVIew = [[UIView alloc]initWithFrame:CGRectMake(backgroundV.width - 45, 7, 2, 16)];
    pointVIew.backgroundColor = [UIColor grayColor];
    [backgroundV addSubview:pointVIew];
    
    UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(backgroundV.width - 40, 0, 40, 30)];
    searchLabel.text = @"搜索";
    searchLabel.textColor = [UIColor grayColor];
    searchLabel.font = [UIFont systemFontOfSize:13];
    [backgroundV addSubview:searchLabel];
    self.navigationItem.titleView =backgroundV;
    
    
}
-(void)showAllQuestions{
    
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"CXShearchStoryboard" bundle:nil];
        
        CXSearchController * searchC = [sb instantiateViewControllerWithIdentifier:@"CXSearch"];
        searchC.delegate = self;
        [self.navigationController presentViewController:searchC animated:NO completion:nil];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
    
    
    
}
-(void)personClickedOKbtn:(UIButton *)btn{
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录
        PersonDetailViewController *personC = [[PersonDetailViewController alloc]init];
        [self.navigationController pushViewController:personC animated:YES];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
    
    //    [self.navigationController presentModalViewController:personC animated:YES];
    
}
-(void)naviBtnClick:(UIButton *)btn{
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录
        BGMessageHistoryTableViewController *messageHistoryC = [[BGMessageHistoryTableViewController alloc]init];
        [self.navigationController pushViewController:messageHistoryC animated:YES];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
    
}
-(void)goToSearchView:(NSString*)typeString{
    
    
    BGSearchTableViewController *searchResultC = [[BGSearchTableViewController alloc]init];
    searchResultC.searchText = typeString;
    [self.navigationController pushViewController:searchResultC animated:NO];
    
}
#pragma mark ————— 初始化页面 —————
-(void)setupUI{
    
    //添加导航栏按钮
//    [self addNavigationItemWithTitles
//     :@[@"筛选"] isLeft:NO target:self action:@selector(naviBtnClick:) tags:@[@1000]];
    
    //设置瀑布流布局
    WaterFlowLayout *layout = [WaterFlowLayout new];
    layout.columnCount = 2;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);;
    layout.rowMargin = 10;
    layout.columnMargin = 10;
    layout.delegate = self;
    
    
    self.collectionView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight );
    //给collectionView添加子控件 这里是作为头部 记得设置y轴为负值
    if(isRetina || isiPhone5){
        _adview = [[WGAdvertisementView alloc]initWithFrame:CGRectMake(KCurrentWidths(10/2), KCurrentHeights(-185), KScreenWidth - KCurrentWidths(10/2)*2, KCurrentHeights(170))];
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(KCurrentHeights(190), 0, 0, 0);
        self.collectionView.contentInset = UIEdgeInsetsMake(KCurrentHeights(190), 0, 0, 0);
    }else{
        _adview = [[WGAdvertisementView alloc]initWithFrame:CGRectMake(KCurrentWidths(10/2), -185, KScreenWidth - KCurrentWidths(10/2)*2, 170)];
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(190, 0, 0, 0);
        self.collectionView.contentInset = UIEdgeInsetsMake(190, 0, 0, 0);
    }
    

    //设置圆角边框
    ViewRadius(_adview, 10);
    _adview.hidden = YES;
    _adview.delegate = self;

    [self.collectionView addSubview:_adview];

    
    //添加内容到视图上
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = CViewBgColor;
    [self.collectionView registerClass:[PersonListCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PersonListCollectionViewCell class])];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.robotImageView];
    self.robotImageView.hidden=YES;
    
}
//网络请求
- (void)getPics:(NSInteger)type andUrl:(NSString *)url andId:(NSInteger)ID andJumpUrl:(NSString *)jumpUrl{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (type ==1) {
        params = nil;
    }else{
        [params setObject:@(ID) forKey:@"portal_id"];
        
    }
    
    [HRHTTPTool postWithURL:url parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                if (type ==1) {
                    
                    NSMutableArray *tempArr = [NSMutableArray array];
                    NSArray *picList = [json objectForKey:@"advert"];
                    for (NSDictionary *dict in picList) {
                        WGAdvertisementModel *model = [WGAdvertisementModel mj_objectWithKeyValues:dict];
                        [tempArr addObject:model];
                    }
                    if(tempArr.count > 0){
                        [_adview setImageInfos:tempArr];
                        self.tableHomeView.tableHeaderView = _topView;
                        [_topView addSubview:_adview];
                    }else{
                        self.tableHomeView.tableHeaderView = [[UIView alloc]init];
                    }
                }else{
                    
                    NSDictionary *dict = [json objectForKey:@"result"];
                    FDHomeModel *model = [FDHomeModel mj_objectWithKeyValues:dict];
                    
                    NSInteger flag = [GFICommonTool isLogin];
                    if (flag == finishLogin) {//已登录不做处理
                        LSDetainViewController *vc = [[LSDetainViewController alloc]init];
                        vc.model = model;
                        vc.URLString = jumpUrl;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        return;
                    }else {
                        [GFICommonTool login:self];
                    }
                }
                
            }
        }else if ([result intValue] == 251 || [result intValue] == 253){
            NSUserDefaults *defaults = USER_DEFAULT;
            [defaults removeObjectForKey:kIsLoginScuu];
            [defaults synchronize];
            [super showHUDTip:[json objectForKey:@"error_msg"]];
            
        }else{
            [super showHUDTip:[json objectForKey:@"error_msg"]];
        }
    } failure:^(NSError *error) {
        [super showHUDTip:@"网络错误"];
        NSLog(@"error == %@",error);
    }];
    
}

//滚到最顶
- (void) singleTapRobotAction:(UIGestureRecognizer *) gesture
{


    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y >= scrollHeightDefault) {
        self.robotImageView.hidden=NO;
    }else{
        self.robotImageView.hidden=YES;
    }
}
#pragma mark ————— 下拉刷新 —————
-(void)headerRereshing{
    [_logic loadData];
}

#pragma mark ————— 上拉刷新 —————
-(void)footerRereshing{
    _logic.page+=1;
    [_logic loadData];
}

#pragma mark ————— 数据拉取完成 渲染页面 —————
-(void)requestDataCompleted{
    
    if (_logic.dataArray.count % 10 == 0 && _logic.dataArray.count !=0) {
        [self.collectionView.mj_footer endRefreshing];
    }else{
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.collectionView.mj_header endRefreshing];
    
    [self.collectionView reloadData];
    
    _adview.hidden = NO;

    
}


#pragma mark ————— collection代理方法 —————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _logic.dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PersonListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PersonListCollectionViewCell class]) forIndexPath:indexPath];
    cell.personModel = _logic.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark ————— layout 代理 —————
-(CGFloat)waterFlowLayout:(WaterFlowLayout *)WaterFlowLayout heightForWidth:(CGFloat)width andIndexPath:(NSIndexPath *)indexPath{
    FDHomeModel *personModel = _logic.dataArray[indexPath.row];
    if (personModel.des && personModel.hobbysHeight == 0) {
        //计算hobby的高度 并缓存
        CGFloat hobbyH=[personModel.des heightForFont:FFont1 width:(KScreenWidth-30)/2-20];
        if (hobbyH>43) {
            hobbyH=43;
        }
        personModel.hobbysHeight = hobbyH;
    }
    CGFloat imgH = personModel.height * itemWidthHeight / personModel.width;
    
    return imgH + 60 - waterHeightChange + personModel.hobbysHeight;
    
}

//*******重写的时候需要走一句话
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    //标记cell
//    [self.collectionView setCurrentIndexPath:indexPath];
//
//    PersonListCollectionViewCell *cell =(PersonListCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//
//    ProfileViewController *profileVC = [ProfileViewController new];
//    profileVC.headerImage = cell.imgView.image;
//    profileVC.isTransition = YES;
//
//    [self.navigationController pushViewController:profileVC animated:YES];
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录
        FDHomeModel *model = _logic.dataArray[indexPath.row];
        LSDetainViewController *VC=[[LSDetainViewController alloc]init];
        VC.URLString = model.url;
        VC.firstConfigute=YES;
        VC.model = model;
        VC.title = @"详情";
        [self.navigationController pushViewController:VC animated:YES];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
    
}
#pragma mark ————— 转场动画起始View —————
-(UIView *)targetTransitionView{
    NSIndexPath * indexPath = [self.collectionView currentIndexPath];
    PersonListCollectionViewCell *cell =(PersonListCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.imgView;
}

-(BOOL)isNeedTransition{
    return YES;
}

#pragma mark - WGProductImageView Delegate推出顶部广告条的链接

- (void)pushAdVc:(LSDetainViewController *)vc withloginFlag:(NSNumber *)mustlogin openWay:(NSString *)loadbybrowser desc:(NSInteger)desc
{
    
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录不做处理
        [self getPics:2 andUrl:kJRG_getparam_info andId:desc andJumpUrl:loadbybrowser];
        return;
    }else {
        [GFICommonTool login:self];
    }
}

@end
