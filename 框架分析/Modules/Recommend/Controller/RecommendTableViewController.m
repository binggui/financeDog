//
//  RecommendTableViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/20.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "RecommendTableViewController.h"
#import "FDHomeModel.h"
#import "FDHomeTableViewCell.h"
#import "RecommendLogic.h"
#import "DOPScrollableActionSheet.h"
#import <WXApi.h>
#import "BGShareModel.h"

@interface RecommendTableViewController ()<UITableViewDelegate,UITableViewDataSource,RecommendLogicDelegate>{
    DOPAction *_shareWeixin;
    DOPAction *_shareFriends;
}
@property (strong, nonatomic) UIView * headerView;
@property(nonatomic,strong) RecommendLogic *logic;//逻辑层
@end

@implementation RecommendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupHeaderVIew];
    //开始第一次数据拉取
    [self.tableView.mj_header beginRefreshing];
    //初始化逻辑类
    _logic = [RecommendLogic new];
    _logic.delegagte = self;

}
-(void)setupUI{
    
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - TAB_HEIGHT);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.robotImageView];
    self.tableView.rowHeight = 126;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 315)];
    self.tableView.tableHeaderView = _headerView;
    
}
-(void)setupHeaderVIew{
    //图片
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth - 20 , 180)];
    ViewRadius(headImg, 10);
    headImg.image = [UIImage imageNamed:@"DefaultImg"];
    headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *headImgGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToDetailViewcontroller)];
    [headImg addGestureRecognizer:headImgGesture];
    [self.headerView addSubview:headImg];
    //点
    UIView *pointVIew = [[UIView alloc]initWithFrame:CGRectMake(15, headImg.bottom + 5, 3, 21)];
    pointVIew.backgroundColor = [GFICommonTool colorWithHexString:@"#03486c"];
    [self.headerView addSubview:pointVIew];
    //时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointVIew.right + 5 , pointVIew.top, 250, 21)];
    timeLabel.text = @"2018-12-02 08:10";
    timeLabel.textColor = [GFICommonTool colorWithHexString:@"#c8c8c8"];
    timeLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:timeLabel];
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointVIew.left , pointVIew.bottom + 5, 250, 21)];
    titleLabel.text = @"互联网金融的现状与未来";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.headerView addSubview:titleLabel];
//    详情
    UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left , titleLabel.bottom + 5, 250, 21)];
    desLabel.text = @"会计核算电话费会计师的咖啡店?";
    desLabel.textColor = [GFICommonTool colorWithHexString:@"#c8c8c8"];
    desLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:desLabel];
    
    //按钮
    NSInteger btnWidth = 60;
    NSInteger marginNum = 20;
    //阅读量
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(desLabel.left , desLabel.bottom + 10, btnWidth, 21);
    [readBtn setImage:[UIImage imageNamed:@"阅读量"] forState:UIControlStateNormal];
    [readBtn setTitle:@"999+" forState:UIControlStateNormal];
    [readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    readBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.headerView addSubview:readBtn];
    
    //回复人数
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake(readBtn.right + marginNum, readBtn.top, btnWidth, 21);
    [messageBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    [messageBtn setTitle:@"30" forState:UIControlStateNormal];
    [messageBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    messageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    messageBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.headerView addSubview:messageBtn];
    
    //收藏人数
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(messageBtn.right + marginNum, readBtn.top, btnWidth, 21);
    [collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [collectionBtn setTitle:@"12" forState:UIControlStateNormal];
    [collectionBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    collectionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    collectionBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.headerView  addSubview:collectionBtn];
    
    //分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kScreenWidth - 21 - 15, readBtn.top, 21, 21);
    [shareBtn addTarget:self action:@selector(sharedButton) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
//    shareBtn.hidden = YES;
    [self.headerView  addSubview:shareBtn];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerView.bottom - 10, kScreenWidth, 10)];
    bottomView.backgroundColor = [GFICommonTool colorWithHexString:@"#f1f5f9"];
    [self.headerView addSubview:bottomView];
    self.headerView.hidden = YES;
}
#pragma mark - ——————— 分享 ————————

- (void)sharedButton{
    __block RecommendTableViewController *this = self;
    _shareWeixin = [[DOPAction alloc] initWithName:@"微信好友" iconName:@"微信" handler:^{
        //
        [this _shareWeiXin:WXSceneSession withData:nil];
    }];
    _shareFriends = [[DOPAction alloc] initWithName:@"朋友圈" iconName:@"朋友圈" handler:^{
        //
        [this _shareWeiXin:WXSceneTimeline withData:nil];
    }];
    NSArray *actions = @[@"分享给好友", @[_shareWeixin, _shareFriends]];
    //    NSArray *actions = @[@"分享到", @[_shareWeixin, _shareFriends, _shareQQFriend, _shareQQZone]];
    
    DOPScrollableActionSheet *as = [[DOPScrollableActionSheet alloc] initWithActionArray:actions];
    [as show];
}
- (void)goToDetailViewcontroller{
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    self.headerView.hidden = NO;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _logic.dataArray.count;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


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

#pragma mark - fetion delegate weixin delegate
- (void)_shareWeiXin:(NSInteger)scene withData:(BGShareModel *)model{

    //如果没有微信客户端，提示用户
//    if ([WXApi isWXAppInstalled]) {
//    }else{
//        [super showHUDTipCannotFindAppWithInit:@"您未安装微信"];
//        return;
//    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ) {
        [OMGToast showWithText:@"您尚未安装微信客户端" topOffset:180.0f duration:1.0];
        return;
    }
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = model.title;
//    message.description = model.message;
//
//    [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:model.shareimgurl]]];
//
//    WXWebpageObject *ext = [WXWebpageObject object];
//
//    if (scene == WXSceneSession) {
//        ext.webpageUrl = [model.weburl absoluteString];//微信分享给好友
//
//    }else if(scene == WXSceneTimeline){
//        ext.webpageUrl = [model.weburl absoluteString];//微信分享朋友圈
//
//    }
//
//
//    message.mediaObject = ext;
//    //    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
//
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = scene;
//    [WXApi sendReq:req];
    
    
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = @"这是一个分享标题";
    message.description = @"我是分享内容";
    [message setThumbImage:[UIImage imageNamed:@"DefaultImg"]];
    
    WXWebpageObject * webPageObject = [WXWebpageObject object];
    //webPageObject.webpageUrl = @"https://douban.fm/?from_=shire_top_nav#/channel/153";
    webPageObject.webpageUrl = @"这是一个链接";
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq * req1 = [[SendMessageToWXReq alloc]init];
    req1.bText = NO;
    req1.message = message;
    //设置分享到朋友圈(WXSceneTimeline)、好友回话(WXSceneSession)、收藏(WXSceneFavorite)
    req1.scene = scene;
    [WXApi sendReq:req1];

    
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
