//
//  BGSearchTableViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/24.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGSearchTableViewController.h"
#import "FDHomeModel.h"
#import "FDHomeTableViewCell.h"
#import "CXSearchController.h"
#import "BGSearchListLogic.h"

@interface BGSearchTableViewController ()<UITableViewDelegate,UITableViewDataSource,CXSearchControllerDelegate,BGSearchListLogicDelegate>
@property (strong, nonatomic) UIButton * SearchButton;
@property(nonatomic,strong) BGSearchListLogic *logic;//逻辑层
@end

@implementation BGSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    //初始化逻辑类
    _logic = [BGSearchListLogic new];
    _logic.delegagte = self;
    _logic.searchText = self.searchText;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)setupUI{
    [self searchHar];
    [self.navigationItem setTitle:self.title];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight );
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    self.tableView.rowHeight = 126;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchHar{
    
    UIView *backgroundV = [[UIView alloc]initWithFrame:CGRectMake(-20, 0, kScreenWidth - 50, 30)];
    backgroundV.backgroundColor = [UIColor whiteColor];
    _SearchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 50, 30)];
    
    ViewRadius(backgroundV, 15);
    [_SearchButton setTitle:self.searchText forState:UIControlStateNormal];
    [_SearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _SearchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _SearchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_SearchButton addTarget:self action:@selector(presentSearchController) forControlEvents:UIControlEventTouchUpInside];
    [backgroundV addSubview:_SearchButton];
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc]initWithCustomView:backgroundV];
    self.navigationItem.rightBarButtonItem = searchButton;
    
}
-(void)goToSearchView:(NSString*)typeString{
    [_SearchButton setTitle:typeString forState:UIControlStateNormal];
    //开始第一次数据拉取
    [self.tableView.mj_header beginRefreshing];
    
}
-(void)presentSearchController{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"CXShearchStoryboard" bundle:nil];
    CXSearchController * searchC = [sb instantiateViewControllerWithIdentifier:@"CXSearch"];
    searchC.delegate = self;
//    searchC.textfieldText = _searchText;
    [self.navigationController presentViewController:searchC animated:NO completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _logic.dataArray.count;;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDHomeTableViewCell *cell;
    //普通咨询
    static NSString *normalNewID = @"normalNew";
    cell = [tableView dequeueReusableCellWithIdentifier:normalNewID];
    if (cell == nil) {
        cell = [[FDHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalNewID];
    }
    cell.model = _logic.dataArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
    [self.tableView.mj_header endRefreshing];
    if (_logic.dataArray.count % 10 == 0 && _logic.dataArray.count !=0) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    if (_logic.dataArray.count == 0) {
        [OMGToast showWithText:@"亲,没有相关的咨询内容" topOffset:KScreenHeight/2 duration:3.0];
    }else{
         [self.tableView reloadData];
    }

   
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
