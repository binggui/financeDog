//
//  BGCommentTableViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/22.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "BGCommentTableViewController.h"
#import "BGCommentTableViewCell.h"
#import "FDHomeTableViewCell.h"
#import "FDHomeTableViewCell.h"
#import "FDHomeModel.h"
#import "BGMessageAndCommentLogic.h"
#import "MessageAndCommentModel.h"

@interface BGCommentTableViewController ()<UITableViewDataSource,UITableViewDelegate,BGMessageAndCommentLogicDelegate>
@property(nonatomic,strong) BGMessageAndCommentLogic *logic;//逻辑层
@property (nonatomic,strong)UILabel *desLab;
@property (nonatomic,strong)UIImageView *leftImg;
@property (strong, nonatomic) UIButton * readBtn;
@property (strong, nonatomic) UIButton * messageBtn;
@property (strong, nonatomic) UIButton * collectionBtn;
@property (strong, nonatomic) UIButton * shareBtn;
@end

@implementation BGCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.navigationItem setTitle:@"我的评论"];
    //开始第一次数据拉取
    [self.tableCommentView.mj_header beginRefreshing];
    //初始化逻辑类
    _logic = [BGMessageAndCommentLogic new];
    _logic.type = 2;
    _logic.delegagte = self;
}
- (void)setupUI{
    self.tableCommentView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight );
    self.tableCommentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableCommentView.backgroundColor = [UIColor whiteColor];
    self.tableCommentView.sectionHeaderHeight = 0;
    self.tableCommentView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    [self.view addSubview:self.tableCommentView];
    
    self.tableCommentView.rowHeight = 126;
    self.tableCommentView.dataSource = self;
    self.tableCommentView.delegate = self;
    self.tableCommentView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return _logic.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BGCommentTableViewCell *cell;
    MessageAndCommentModel *model = self.logic.dataArray[indexPath.section];
    static NSString *normalNewID = @"normalNew";
    cell = [tableView dequeueReusableCellWithIdentifier:normalNewID];
    if (cell == nil) {
        kAppDelegate.cellType = @"comment";
        cell = [[BGCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalNewID];
    }
    cell.model = model;
    return  cell;
    
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
    [self.tableCommentView.mj_header endRefreshing];
    
    if (_logic.dataArray.count % 10 == 0 && _logic.dataArray.count !=0) {
        [self.tableCommentView.mj_footer endRefreshing];
    }else{
        [self.tableCommentView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableCommentView reloadData];
}

- (void)goToDetailVc:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;

    UIView *views = (UIView*) tap.view;
    
    NSUInteger tag = views.tag;
  
    MessageAndCommentModel *model = _logic.dataArray[tag];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MessageAndCommentModel *model = _logic.dataArray[section];
    UIView *bcakView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToDetailVc:)];
    tap.view.tag = section;
    [bcakView addGestureRecognizer:tap];
    //左边图片
    self.leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 180/2, 180/2)];
    self.leftImg.contentMode = UIViewContentModeScaleToFill;
    self.leftImg.clipsToBounds = YES;
    [self.leftImg sd_setImageWithURL:model.img placeholderImage:[UIImage imageNamed:@"头像"]];
    //    if(![GFICommonTool isBlankString:[dic objectForKey:@"iconurl"]]){
    //        [self.leftImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"iconurl"]] placeholderImage:[UIImage imageNamed:@"placeholder_default"]];
    //    }
    [bcakView addSubview:self.leftImg];
    
    //描述
    self.desLab = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImg.right+12, self.leftImg.top - 10, kScreenWidth-5-15-self.leftImg.width-15, 65)];
    self.desLab.backgroundColor = [UIColor clearColor];
    self.desLab.font = [UIFont systemFontOfSize:16.0];
    self.desLab.textColor = [GFICommonTool colorWithHexString:@"#383838"];
    
    [bcakView addSubview:self.desLab];
    self.desLab.text = model.recommend_title;
    self.desLab.numberOfLines = 0;
    
    if(self.desLab.height > 75){
        self.desLab.height = 75;
    }
    NSInteger btnWidth = 60;
    NSInteger marginNum = (kScreenWidth - 30 - self.leftImg.width - 12 - 3*btnWidth - 21) / 3;
    
    
    //阅读量
    _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _readBtn.frame = CGRectMake(self.leftImg.right + 13, self.leftImg.bottom - 23, btnWidth, 21);
    [_readBtn setImage:[UIImage imageNamed:@"阅读量1"] forState:UIControlStateNormal];
    [_readBtn setTitle:model.recommend_hits forState:UIControlStateNormal];
    [_readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    _readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
    _readBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [bcakView  addSubview:_readBtn];
    
    //回复人数
    _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageBtn.frame = CGRectMake(_readBtn.right + marginNum, self.leftImg.bottom - 23, btnWidth, 21);
    [_messageBtn setImage:[UIImage imageNamed:@"评论1"] forState:UIControlStateNormal];
    [_messageBtn setTitle:model.recommend_count forState:UIControlStateNormal];
    [_messageBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    _messageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
    _messageBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [bcakView  addSubview:_messageBtn];
    
    //收藏人数
    _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionBtn.frame = CGRectMake(_messageBtn.right + marginNum, self.leftImg.bottom - 23, btnWidth, 21);
    [_collectionBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
    [_collectionBtn setTitle:model.recommend_favorites forState:UIControlStateNormal];
    [_collectionBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    _collectionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
    _collectionBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [bcakView  addSubview:_collectionBtn];
    
    //分享按钮
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(kScreenWidth - 21 - 15, self.leftImg.bottom - 23, 21, 21);
    [_shareBtn setImage:[UIImage imageNamed:@"分享1"] forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    _shareBtn.hidden = YES;
    [bcakView  addSubview:_shareBtn];
    
    //底线
    UIView *bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, self.leftImg.bottom+15, kScreenWidth, 1/2.0)];
    bottomline.backgroundColor = [GFICommonTool colorWithHexString:@"#e7e7e7"];
    [bcakView addSubview:bottomline];
    
    return bcakView;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    MessageAndCommentModel *model = _logic.dataArray[section];
//    UIView *bcakView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
//    //左边图片
//    self.leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 180/2, 180/2)];
//    self.leftImg.contentMode = UIViewContentModeScaleToFill;
//    self.leftImg.clipsToBounds = YES;
//    self.leftImg.image = [UIImage imageNamed:@"头像"];
//    //    if(![GFICommonTool isBlankString:[dic objectForKey:@"iconurl"]]){
//    //        [self.leftImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"iconurl"]] placeholderImage:[UIImage imageNamed:@"placeholder_default"]];
//    //    }
//    [bcakView addSubview:self.leftImg];
//
//    //描述
//    self.desLab = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImg.right+12, self.leftImg.top - 10, kScreenWidth-5-15-self.leftImg.width-15, 65)];
//    self.desLab.backgroundColor = [UIColor clearColor];
//    self.desLab.font = [UIFont systemFontOfSize:16.0];
//    self.desLab.textColor = [GFICommonTool colorWithHexString:@"#383838"];
//
//    [bcakView addSubview:self.desLab];
//    self.desLab.text = model.recommend_title;
//    self.desLab.numberOfLines = 0;
//
//    if(self.desLab.height > 75){
//        self.desLab.height = 75;
//    }
//    NSInteger btnWidth = 60;
//    NSInteger marginNum = (kScreenWidth - 30 - self.leftImg.width - 12 - 3*btnWidth - 21) / 3;
//
//
//    //阅读量
//    _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _readBtn.frame = CGRectMake(self.leftImg.right + 13, self.leftImg.bottom - 23, btnWidth, 21);
//    [_readBtn setImage:[UIImage imageNamed:@"阅读量1"] forState:UIControlStateNormal];
//    [_readBtn setTitle:model.recommend_hits forState:UIControlStateNormal];
//    [_readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
//    _readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
//    _readBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
//    [bcakView  addSubview:_readBtn];
//
//    //回复人数
//    _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _messageBtn.frame = CGRectMake(_readBtn.right + marginNum, self.leftImg.bottom - 23, btnWidth, 21);
//    [_messageBtn setImage:[UIImage imageNamed:@"评论1"] forState:UIControlStateNormal];
//    [_messageBtn setTitle:model.recommend_count forState:UIControlStateNormal];
//    [_messageBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
//    _messageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
//    _messageBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
//    [bcakView  addSubview:_messageBtn];
//
//    //收藏人数
//    _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _collectionBtn.frame = CGRectMake(_messageBtn.right + marginNum, self.leftImg.bottom - 23, btnWidth, 21);
//    [_collectionBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
//    [_collectionBtn setTitle:model.recommend_favorites forState:UIControlStateNormal];
//    [_collectionBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
//    _collectionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 2);
//    _collectionBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
//    [bcakView  addSubview:_collectionBtn];
//
//    //分享按钮
//    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _shareBtn.frame = CGRectMake(kScreenWidth - 21 - 15, self.leftImg.bottom - 23, 21, 21);
//    [_shareBtn setImage:[UIImage imageNamed:@"分享1"] forState:UIControlStateNormal];
//    _shareBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
//    _shareBtn.hidden = YES;
//    [bcakView  addSubview:_shareBtn];
//
//    //底线
//    UIView *bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, self.leftImg.bottom+15, kScreenWidth, 1/2.0)];
//    bottomline.backgroundColor = [GFICommonTool colorWithHexString:@"#e7e7e7"];
//    [bcakView addSubview:bottomline];
//
//    return bcakView;
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120;
}


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
