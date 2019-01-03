//
//  BGMoreCommenViewController.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/3.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "BGMoreCommenViewController.h"
#import "TTWeiboCommentTwoCell.h"
#import "TTWeiboCommentCell.h"

static NSString *const cellfidf=@"TTWeiboCommentCell";

@interface BGMoreCommenViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BGMoreCommenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
    //开始第一次数据拉取
//    [self.tableView.mj_header beginRefreshing];
    //初始化逻辑类
//    _logic = [CommonListLogic new];
//    _logic.delegagte = self;
}
-(void)setupUI{
    [self.navigationItem setTitle:self.title];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight );
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TTWeiboCommentCell" bundle:nil] forCellReuseIdentifier:cellfidf];
    self.tableView.rowHeight = 126;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark ————— 下拉刷新 —————
//-(void)headerRereshing{
//    [_logic loadData];
//}
//
//#pragma mark ————— 上拉刷新 —————
//-(void)footerRereshing{
//    _logic.page+=1;
//    [_logic loadData];
//}
//
//#pragma mark ————— 数据拉取完成 渲染页面 —————
//-(void)requestDataCompleted{
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView reloadData];
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTWeiboCommentCell *cell= nil;
    if (cell==nil) {
        cell=[tableView dequeueReusableCellWithIdentifier:cellfidf];
    }
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 126;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    if (flag == finishLogin) {//已登录
        LSDetainViewController *VC=[[LSDetainViewController alloc]init];
        VC.URLString=kWebTestUrl;
        VC.firstConfigute=YES;
        VC.title = @"详情";
        [self.navigationController pushViewController:VC animated:YES];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
}

@end
