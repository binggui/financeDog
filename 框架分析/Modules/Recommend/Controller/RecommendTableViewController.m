//
//  RecommendTableViewController.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/20.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "RecommendTableViewController.h"
#import "FDHomeTableViewCell.h"
#import "RecommendLogic.h"
#import "DOPScrollableActionSheet.h"
#import <WXApi.h>
#import "BGShareModel.h"
#import "CommonModel.h"
#import "CommonListLogic.h"

@interface RecommendTableViewController ()<UITableViewDelegate,UITableViewDataSource,CommonListLogicDelegate>{
    DOPAction *_shareWeixin;
    DOPAction *_shareFriends;
}
@property (strong, nonatomic) UIView * headerView;
@property(nonatomic,strong) CommonListLogic *logic;//逻辑层
@property (strong, nonatomic) NSDictionary * topDic;

@property (strong, nonatomic) UIImageView * headImg;
@property (strong, nonatomic) UILabel * timeLabel;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * desLabel;
@property (strong, nonatomic) UIButton * readBtn;
@property (strong, nonatomic) UIButton * messageBtn;
@property (strong, nonatomic) UIButton * collectionBtn;
@end

@implementation RecommendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPics];
    [self setupUI];
    [self setupHeaderVIew];
    
    //开始第一次数据拉取
    [self.tableView.mj_header beginRefreshing];
    //初始化逻辑类
    _logic = [CommonListLogic new];
    _logic.type = 2;
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
    self.headerView.hidden = YES;
    
}
-(void)setupHeaderVIew{
    //图片
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth - 20 , 180)];
    ViewRadius(self.headImg, 10);
    
    self.headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *headImgGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToDetailViewcontroller)];
    [self.headImg addGestureRecognizer:headImgGesture];
    [self.headerView addSubview:self.headImg];
    //点
    UIView *pointVIew = [[UIView alloc]initWithFrame:CGRectMake(15, self.headImg.bottom + 5, 3, 21)];
    pointVIew.backgroundColor = [GFICommonTool colorWithHexString:@"#03486c"];
    [self.headerView addSubview:pointVIew];
    //时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointVIew.right + 5 , pointVIew.top, 250, 21)];
    self.timeLabel.textColor = [GFICommonTool colorWithHexString:@"#c8c8c8"];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:self.timeLabel];
    //标题
   self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointVIew.left , pointVIew.bottom + 5, KScreenWidth - 30, 21)];
    self.titleLabel.text = self.topDic[@"post_title"];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.headerView addSubview:self.titleLabel];
//    详情
    self.desLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.left , self.titleLabel.bottom + 5, KScreenWidth - 30, 21)];
    self.desLabel.textColor = [GFICommonTool colorWithHexString:@"#c8c8c8"];
    self.desLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:self.desLabel];
    
    //按钮
    NSInteger btnWidth = 60;
    NSInteger marginNum = 20;
    //阅读量
    self.readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.readBtn.frame = CGRectMake(self.desLabel.left , self.desLabel.bottom + 10, btnWidth, 21);
    [self.readBtn setImage:[UIImage imageNamed:@"阅读量1"] forState:UIControlStateNormal];
    [self.readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    self.readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.readBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.headerView addSubview:self.readBtn];
    
    //回复人数
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageBtn.frame = CGRectMake(self.readBtn.right + marginNum, self.readBtn.top, btnWidth, 21);
    [self.messageBtn setImage:[UIImage imageNamed:@"评论1"] forState:UIControlStateNormal];
    [self.messageBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    self.messageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.headerView addSubview:self.messageBtn];
    
    //收藏人数
    self.collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionBtn.frame = CGRectMake(_messageBtn.right + marginNum, _readBtn.top, btnWidth, 21);
    [self.collectionBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:[GFICommonTool colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
    self.collectionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.collectionBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.headerView  addSubview:self.collectionBtn];
    
    //分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kScreenWidth - 21 - 15, _readBtn.top, 21, 21);
    [shareBtn addTarget:self action:@selector(sharedButton) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"分享1"] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
//    shareBtn.hidden = YES;
    [self.headerView  addSubview:shareBtn];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerView.bottom - 10, kScreenWidth, 10)];
    bottomView.backgroundColor = [GFICommonTool colorWithHexString:@"#f1f5f9"];
    [self.headerView addSubview:bottomView];
    
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
    //先判断是否登录
    NSInteger flag = [GFICommonTool isLogin];
    
    if (flag == finishLogin) {//已登录
        [as show];
        
    }else{//未登录
        //为了显示未登录布局，不弹出登录框
        
        [GFICommonTool login:self];
        
    }
    
}
- (void)goToDetailViewcontroller{
    
    
    [self getPicsCount:[_topDic[@"id"] intValue]];
    

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
    [self.tableView.mj_header endRefreshing];
    
    if (_logic.dataArray.count % 10 == 0 && _logic.dataArray.count !=0) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
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
        FDHomeModel *model = _logic.dataArray[indexPath.row];
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
    message.title = @"分享标题";
    message.description = _topDic[@"post_excerpt"];
    [message setThumbImage:[UIImage imageNamed:@"DefaultImg"]];
    
    WXWebpageObject * webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = _topDic[@"url"];
//    webPageObject.webpageUrl = @"这是一个链接";
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq * req1 = [[SendMessageToWXReq alloc]init];
    req1.bText = NO;
    req1.message = message;
    //设置分享到朋友圈(WXSceneTimeline)、好友回话(WXSceneSession)、收藏(WXSceneFavorite)
    req1.scene = scene;
    [WXApi sendReq:req1];

    
}

//网络请求
- (void)getPics{
    
    [HRHTTPTool postWithURL:kJRG_pushnew_info parameters:nil success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *picList = [json objectForKey:@"top"];

                if(picList.count > 0){
                    
                    _topDic = picList.copy;
                    [_headImg sd_setImageWithURL:[NSURL URLWithString:_topDic[@"thumbnail"]] placeholderImage:[UIImage imageNamed:@"头像"]];
////                    self.timeLabel.text = _topDic[@"published_time"];
                    self.titleLabel.text = _topDic[@"post_title"];
                    self.desLabel.text = _topDic[@"post_excerpt"];
                    self.timeLabel.text = [self returndate:_topDic[@"published_time"]];
                    [self.collectionBtn setTitle:[NSString stringWithFormat:@"%@",_topDic[@"post_favorites"]]   forState:UIControlStateNormal];
                    [self.readBtn setTitle:[NSString stringWithFormat:@"%@",_topDic[@"post_hits"]]   forState:UIControlStateNormal];
                    [self.messageBtn setTitle:[NSString stringWithFormat:@"%@",_topDic[@"comment_count"]]   forState:UIControlStateNormal];
                    
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

//网络请求
- (void)getPicsCount:(NSInteger)ID{
    NSMutableDictionary *params = [NSMutableDictionary new];
  
    [params setObject:@(ID) forKey:@"portal_id"];
        
  
    [HRHTTPTool postWithURL:kJRG_getparam_info parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dict = [json objectForKey:@"result"];
                FDHomeModel *model = [FDHomeModel mj_objectWithKeyValues:dict];
                
                NSInteger flag = [GFICommonTool isLogin];
                if (flag == finishLogin) {//已登录不做处理
                    LSDetainViewController *vc = [[LSDetainViewController alloc]init];
                    vc.model = model;
                    vc.URLString = _topDic[@"url"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }else {
                    [GFICommonTool login:self];
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
- (NSString *)returndate:(NSString *)str1
{
    int x=[str1  intValue];
    NSDate  *date1 = [NSDate dateWithTimeIntervalSince1970:x];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    return [dateformatter stringFromDate:date1];
    
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
