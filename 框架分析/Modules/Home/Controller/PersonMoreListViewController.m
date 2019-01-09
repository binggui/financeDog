//
//  PersonListViewController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/7/14.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "PersonMoreListViewController.h"
#import "PersonListLogic.h"
#import "WaterFlowLayout.h"
#import "PersonListCollectionViewCell.h"
#import "UICollectionView+IndexPath.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "PersonModel.h"

#define itemWidthHeight ((kScreenWidth-30)/2)

@interface PersonMoreListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterFlowLayoutDelegate,PersonListLogicDelegate>

@property(nonatomic,strong) PersonListLogic *logic;//逻辑层
@property(nonatomic,strong) UIView *topView;//置顶View

@end

@implementation PersonMoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"案例"];
    
    //初始化逻辑类
    _logic = [PersonListLogic new];
    _logic.delegagte = self;
    
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
    

    self.collectionView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = CViewBgColor;
    [self.collectionView registerClass:[PersonListCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PersonListCollectionViewCell class])];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
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
    PersonModel *personModel = _logic.dataArray[indexPath.row];
    if (personModel.hobbys && personModel.hobbysHeight == 0) {
        //计算hobby的高度 并缓存
        CGFloat hobbyH=[personModel.hobbys heightForFont:FFont1 width:(KScreenWidth-30)/2-20];
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
    //标记cell
    [self.collectionView setCurrentIndexPath:indexPath];
    
    PersonListCollectionViewCell *cell =(PersonListCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    ProfileViewController *profileVC = [ProfileViewController new];
    profileVC.headerImage = cell.imgView.image;
    profileVC.isTransition = YES;
    [self.navigationController pushViewController:profileVC animated:YES];
    
}

-(void)naviBtnClick:(UIButton *)btn{
    DLog(@"点击了筛选按钮");
    RootViewController *v = [RootViewController new];
    v.isHidenNaviBar = YES;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -  上下滑动隐藏/显示导航栏

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
//    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
//    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
//    CGFloat velocity = [pan velocityInView:scrollView].y;
//    NSLog(@"滑动速度 %.f",velocity);
//    if (velocity <- 50) {
//        //向上拖动，隐藏导航栏
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        [UIView animateWithDuration:0.2 animations:^{
//            self.topView.bottom = 0;
//        }];
//    }else if (velocity > 50) {
//        //向下拖动，显示导航栏
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [UIView animateWithDuration:0.2 animations:^{
//            self.topView.top = 64+10;
//        }];
//    }else if(velocity == 0){
//        //停止拖拽
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
