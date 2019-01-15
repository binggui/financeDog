
//  FDHomeTableViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/19.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "FDHomeTableViewController.h"
#import "FDHomeModel.h"
#import "FDHomeTableViewCell.h"
#import "WGAdvertisementView.h"
#import "PersonDetailViewController.h"
#import "BGLoginViewController.h"
#import "BGMessageHistoryTableViewController.h"
#import "CXSearchController.h"
#import "BGSearchTableViewController.h"
#import "HRHTTPToolWithSID.h"
#import "FDHomeListLogic.h"
#import "CommonViewController.h"
#import "LSDetainViewController.h"
#import "WGAdvertisementModel.h"
#import "PersonMoreListViewController.h"



@interface FDHomeTableViewController ()<UITableViewDelegate,UITableViewDataSource,CXSearchControllerDelegate,FDHomeListLogicDelegate,WGAdvertisementViewDelegate>{
    
    WGAdvertisementView *_adview;
    NSMutableArray *_ads;
}
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray * dataNewsArr;
@property (strong, nonatomic) NSMutableArray * sectionDataArr;
//@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic ,strong) UIView *topView;
@property(nonatomic,strong) FDHomeListLogic *logic;//逻辑层
@end

@implementation FDHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求主页轮播图图片
    [self getPics:1 andUrl:kJRG_index_info andId:0 andJumpUrl:nil];
    [self getPics:3 andUrl:kJRG_getversion_info andId:0 andJumpUrl:nil];
    
    //开始第一次数据拉取
    [self.tableHomeView.mj_header beginRefreshing];
    [self setupNavigation];
    //初始化逻辑类
    _logic = [FDHomeListLogic new];
    _logic.delegagte = self;
    [self setupUI];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)setupUI{
    self.dataNewsArr = [NSMutableArray array];
    self.sectionDataArr = [NSMutableArray array];
//    self.robotImageView.hidden = NO;
    self.tableHomeView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - TAB_HEIGHT);
    self.tableHomeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableHomeView.backgroundColor = [UIColor whiteColor];
    self.tableHomeView.sectionFooterHeight = 0;
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 219)];
    backImg.image = [UIImage imageNamed:@"背景1"];
    [self.view addSubview:backImg];
//    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableHomeView];
//     [self.view addSubview:self.robotImageView];
    self.tableHomeView.rowHeight = 126;
    _topView = [[UIView alloc]init];
    _topView.userInteractionEnabled = YES;
//    _topView.alpha = 0;
//    UIImageView *backImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, -NAV_HEIGHT, kScreenWidth, KCurrentWidths(368/2))];
//    backImageVIew.image = [UIImage imageNamed:@"背景"];
//    [_topView addSubview:backImageVIew];
    if(isRetina || isiPhone5){
        _adview = [[WGAdvertisementView alloc]initWithFrame:CGRectMake(KCurrentWidths(10/2), KCurrentWidths(10/2), KScreenWidth - KCurrentWidths(10/2)*2, KCurrentHeights(300/2))];
        _topView.frame = CGRectMake(0, 0, KScreenWidth, KCurrentHeights(368/2));
    }else{
        _adview = [[WGAdvertisementView alloc]initWithFrame:CGRectMake(KCurrentWidths(10/2), KCurrentWidths(10/2), KScreenWidth - KCurrentWidths(10/2)*2, KCurrentHeights(300/2))];
        _topView.frame = CGRectMake(0, 0, KScreenWidth, KCurrentHeights(368/2));
    }
    
//    _topView.backgroundColor = [GFICommonTool colorWithHexString:@"#00486b"];
    
    //设置圆角边框
    ViewRadius(_adview, 8);

    _adview.delegate = self;
    
    self.tableHomeView.dataSource = self;
    self.tableHomeView.delegate = self;
    [_topView addSubview:_adview];
    _topView.hidden = YES;
    
    UIView *pointVIew = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.bottom - 10, kScreenWidth, 5)];
    pointVIew.backgroundColor = [GFICommonTool colorWithHexString:@"#f1f5f9"];
    [_topView addSubview:pointVIew];
    self.tableHomeView.tableHeaderView = _topView;
}

//网络请求
- (void)getPics:(NSInteger)type andUrl:(NSString *)url andId:(NSInteger)ID andJumpUrl:(NSString *)jumpUrl{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (type ==1) {
        params = nil;
    }else if(type == 2){
        [params setObject:@(ID) forKey:@"portal_id"];
        
    }else if(type == 3){
        NSString *version = @"1";
        [params setObject:version forKey:@"version"];
        
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
                }else if (type ==2){
                   
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
                }else if (type == 3){
//                    [self updateVersion];
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

- (void) updateVersion {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认注销吗？" preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    UIAlertAction *_okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        // 跳转appStore 页面
       
    }];
    UIAlertAction * _cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:_okAction];
    [alert addAction:_cancelAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
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

    [self.tableHomeView.mj_header endRefreshing];
    _topView.hidden = NO;
    [self.tableHomeView reloadData];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.logic.dataArraySection.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArr = self.logic.dataArray[section];
    return tempArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FDHomeModel *model = self.dataArr[indexPath.row];
    FDHomeTableViewCell *cell;
    //普通咨询
    static NSString *normalNewID = @"normalNew";
    cell = [tableView dequeueReusableCellWithIdentifier:normalNewID];
    if (cell == nil) {
        cell = [[FDHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalNewID];
    }
    NSMutableArray *tempNewsArr = [NSMutableArray array];
    NSArray *tempArr = self.logic.dataArray[indexPath.section];
    for (NSDictionary *dict in tempArr) {

        FDHomeModel *model = [FDHomeModel mj_objectWithKeyValues:dict];
        [tempNewsArr addObject:model];
        
    }
    NSArray *cellarr = tempNewsArr.copy;
    cell.model = cellarr[indexPath.row];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *pointVIew = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 3, 20)];
    pointVIew.backgroundColor = [GFICommonTool colorWithHexString:appColorDefault];
    [headerView addSubview:pointVIew];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointVIew.right + 5, 5, 150, 20)];
    UIButton *moreListButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 110, 0, 100, 30)];
    [moreListButton setTitle:@"查看更多>>" forState:UIControlStateNormal];
    [moreListButton setTitleColor:[GFICommonTool colorWithHexString:appColorDefault] forState:UIControlStateNormal];
    moreListButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    moreListButton.titleLabel.font = [UIFont systemFontOfSize:14];
    moreListButton.tag = section;
    [moreListButton addTarget:self action:@selector(moreListAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:moreListButton];
    titleLabel.text = [self.logic.dataArraySection[section] objectForKey:@"name"] ;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    [headerView addSubview:titleLabel];
    return headerView;
}
- (void)moreListAction:(UIButton *)button{

    NSInteger type = 0;
    if (button.tag == 0) {
        type = 1;
        CommonViewController *moreC = [[CommonViewController alloc]init];
        moreC.title = [self.logic.dataArraySection[button.tag] objectForKey:@"name"];
        moreC.type = type;
        [self.navigationController pushViewController:moreC animated:YES];
    }else if (button.tag == 1){
        type = 2;
        CommonViewController *moreC = [[CommonViewController alloc]init];
        moreC.title = [self.logic.dataArraySection[button.tag] objectForKey:@"name"];
        moreC.type = type;
        [self.navigationController pushViewController:moreC animated:YES];
    }else if (button.tag == 2){
        type = 3;
        PersonMoreListViewController *vc = [[PersonMoreListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录

        NSMutableArray *tempNewsArr = [NSMutableArray array];
        NSArray *tempArr = self.logic.dataArray[indexPath.section];
        for (NSDictionary *dict in tempArr) {
            
            FDHomeModel *model = [FDHomeModel mj_objectWithKeyValues:dict];
            [tempNewsArr addObject:model];
            
        }
        NSArray *cellarr = tempNewsArr.copy;
 
        FDHomeModel *didSelectedModel = cellarr[indexPath.row];
        LSDetainViewController *VC=[[LSDetainViewController alloc]init];
        VC.URLString = didSelectedModel.url;
        VC.firstConfigute=YES;
        VC.model = cellarr[indexPath.row];
        VC.title = @"详情";
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
