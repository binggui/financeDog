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

#define itemWidthHeight ((kScreenWidth-30)/2)

@interface PersonListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterFlowLayoutDelegate,XYTransitionProtocol,PersonListLogicDelegate,WGAdvertisementViewDelegate>{
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
    //轮播图
    [self getPics];
    [self setupUI];
    //开始第一次数据拉取
    [self.collectionView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
}
//网络请求
- (void)getPics{
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setObject:@"12334555" forKey:@"APPID"];
    //    [params setObject:@"JINRONGGOU" forKey:@"APPSERCERT"];
    //    [params setObject:@"15860005125" forKey:@"phone"];
    
    [HRHTTPTool postWithURL:kJRG_exampleapi_info parameters:nil success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                
                NSMutableArray *tempArr = [NSMutableArray array];
                NSArray *picList = [json objectForKey:@"advert"];
                for (NSDictionary *dict in picList) {
                    WGAdvertisementModel *model = [WGAdvertisementModel mj_objectWithKeyValues:dict];
                    [tempArr addObject:model];
                }
                
                if(tempArr.count > 0){
                    [_adview setImageInfos:tempArr];
                }
                
                
                //                //零时存储
                //                NSMutableArray *tempArr = [NSMutableArray array];
                //                NSArray *picList = [json objectForKey:@"advert"];
                //
                //                if(picList.count > 0){
                //                    [_adview setImageInfos:picList];
                //                }
            }
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


-(void)naviBtnClick:(UIButton *)btn{
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起,尚未开发!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - WGProductImageView Delegate推出顶部广告条的链接

- (void)pushAdVc:(LSDetainViewController *)vc withloginFlag:(NSNumber *)mustlogin openWay:(NSNumber *)loadbybrowser desc:(NSNumber *)desc
{
    
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录不做处理
        vc.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else {
        [GFICommonTool login:self];
    }
}

@end
