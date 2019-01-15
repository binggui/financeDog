
//
//  LSDetainViewController.m
//  LSNewsDetailWebviewContainer
//
//  Created by liusong on 2018/12/15.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "LSDetainViewController.h"
#import "LSNewsDetailWebviewContainer.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import <WebKit/WebKit.h>
#import "WJButton.h"
#import "popView.h"
#import "NSDate+YYAdd.h"
#import "WeiboCommentModel.h"
#import "TTWeiboCommentCell.h"
#import "TTWeiboCommentTwoCell.h"
#import "BGMoreCommenViewController.h"
#import "DOPScrollableActionSheet.h"
#import <WXApi.h>
#import "BGShareModel.h"
#import "BGCommentModel.h"


static NSString *const cellfidf=@"TTWeiboCommentCell";
static NSString *const cellTwofidf=@"TTWeiboCommentTwoCell";
@interface LSDetainViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,TTWeiboCommentCellDelegate,popViewDelegate>{
    DOPAction *_shareWeixin;
    DOPAction *_shareFriends;
    NSInteger indexRow;
    NSInteger page;
    
}
@property (assign, nonatomic) NSInteger  personCollection;

@property (assign, nonatomic) NSInteger  commentCount;

@property (nonatomic,strong) NSMutableArray *datas;//底部tableview的数据
@property (nonatomic,strong) NSMutableArray *cellDatas;//底部tableview的数据
@property (nonatomic,weak) LSNewsDetailWebviewContainer *detailWebviewContainer;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic,strong) UIImageView *robotImageView; //滚至顶部

@property (nonatomic, strong)popView *popview;

@property (strong, nonatomic) UIButton * collectionBtn;

@property (strong, nonatomic) UIButton * readBtn;

@property (assign, nonatomic) BOOL  collectionFlag;

@property(nonatomic,strong) NSArray *dataArrs;//评论数据

@property (strong, nonatomic) NSString * recommendCount;

@property (strong, nonatomic) UIImageView * shareImg;
@property (strong, nonatomic) UILabel * headerTitle;
@end

@implementation LSDetainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    self.datas=@[].mutableCopy;
    _shareImg = [[UIImageView alloc]init];
    [_shareImg sd_setImageWithURL:[NSURL URLWithString:self.model.img]];
    [self setupViews1];
    indexRow = 0;
    page = 1;
    _collectionFlag = NO;
    self.navigationController.title = self.title;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.view bringSubviewToFront:self.emptyView];
//    [self.view addSubview:self.robotImageView];
//    [self.view bringSubviewToFront:self.robotImageView];
}

//使用内部创建的WKWebview和UITableview
-(void)setupViews1
{
    LSNewsDetailWebviewContainer *container=[[LSNewsDetailWebviewContainer alloc]init];
    container.URLString=self.URLString;
    container.cachePolicy=NSURLRequestReturnCacheDataElseLoad;
    container.scrollview.delegate=self;
    container.tableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    container.tableview.mj_footer.automaticallyChangeAlpha=YES;
    container.tableview.dataSource=self;
    container.tableview.delegate=self;
    container.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    container.tableview.sectionHeaderHeight = 0;
    container.tableview.sectionFooterHeight = 0;
    container.tableview.backgroundColor = [UIColor whiteColor];
    [container.tableview registerNib:[UINib nibWithNibName:@"TTWeiboCommentCell" bundle:nil] forCellReuseIdentifier:cellfidf];
    [container.tableview registerNib:[UINib nibWithNibName:@"TTWeiboCommentTwoCell" bundle:nil] forCellReuseIdentifier:cellTwofidf];
    container.webview.navigationDelegate=self;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,40)];
    headerView.backgroundColor = [UIColor whiteColor];
    _headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    _recommendCount = self.model.messageCount;
    _headerTitle.text = [NSString stringWithFormat:@"全部评论 (%@)",_recommendCount];
    [headerView addSubview:_headerTitle];
    container.tableview.tableHeaderView  = headerView;
    self.detailWebviewContainer=container;
    
    [self.view addSubview:container];
    [self setupNavigation];
    
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(44);
    }];
    [self loadClick:nil];
}

-(void)setupNavigation{
    //    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    //    [self wr_setNavBarBackgroundAlpha:0];
    //    self.tableView.contentInset = UIEdgeInsetsMake( - NAV_HEIGHT, 0, 0, 0);
    [self addNavigationItemWithImageNames:@[@"个人"] isLeft:NO target:self action:@selector(gotoShared) tags:@[@999]];
}

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
#pragma mark - CircleCellDelegate,LikeUserCellDelegate

- (void)sendContentText:(NSIndexPath *)indexPath andContent: (NSString *)content{
    
    if (indexPath == nil ) {
        _recommendCount  = [NSString stringWithFormat:@"%ld",[_recommendCount integerValue] + 1 ];
        [self getPics:content andType:2 andUrl:kJRG_portal_addcomment_info];

    }else{
        if (indexPath.row == 0 ) {

            indexRow = indexPath.section ;
            [self getPics:content andType:3 andUrl:kJRG_portal_addcomment_info];
            
        }
    }
    
    
}



- (void)didSelectPeople:(NSIndexPath *) cellIndexPath; {
    
    [self alertPopView:cellIndexPath andPlaceHolderTitle:@"回复"];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.detailWebviewContainer.scrollview) {
        if (scrollView.contentOffset.y>=self.detailWebviewContainer.webview.scrollView.contentSize.height-self.view.frame.size.height+44+46) {
            self.title=@"详情";
        }else{
            self.title=@"详情";
        }
    }
}

- (IBAction)loadClick:(id)sender {

        [self.detailWebviewContainer loadRequest];

}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.emptyView.hidden=YES;
    
    self.cellDatas = [NSMutableArray array];
    //一般新闻评论每页数据都是20条
    [self getPics:nil andType:1 andUrl:kJRG_portal_comment_info];

    
    [self.cellDatas addObject:@"爱死你了开发区网络卡建档立卡请问您"];
   
    [self.detailWebviewContainer.tableview reloadData];

}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    self.emptyView.hidden=NO;

}



-(void)loadMoreData
{
    page += 1;
    [self getPics:nil andType:1 andUrl:kJRG_portal_comment_info];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 95;
    }else{
        
        BGCommentModel *model = self.datas[indexPath.section];
        if (model.comment_more >0) {
            return 30;
        }else{
            return 0;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell;
    if(indexPath.row >=1){
        TTWeiboCommentTwoCell *cellTwo= nil;
        if (cellTwo==nil) {
            cellTwo=[tableView dequeueReusableCellWithIdentifier:cellTwofidf];
        }
        
        cellTwo.model = self.datas[indexPath.section];
        
        cell = cellTwo;
    }else{
        TTWeiboCommentCell *cellOne= nil;
        
        if (cellOne==nil) {
            cellOne=[tableView dequeueReusableCellWithIdentifier:cellfidf];
        }
        //    [cell setDataModel:model];
        //    cell.textLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
        cellOne.delegate = self;
        cellOne.remmentButton.tag = indexPath.section;
        cellOne.cellIndexPath = indexPath;
        cellOne.type = 1;
        cellOne.model = self.datas[indexPath.section];
        cell = cellOne;
        
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        BGMoreCommenViewController *mooreC = [[BGMoreCommenViewController alloc]init];
        mooreC.model = self.datas[indexPath.section];
        mooreC.object_id = [self.model.ID integerValue]; 
        [self.navigationController pushViewController:mooreC animated:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupTabbar];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
    self.navigationController.navigationBar.translucent = NO;
    
}



//底部tabbar
- (void)setupTabbar{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    self.navigationController.toolbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44);
    
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil action:nil];
    //评论按钮
    WJButton *readBtn = [WJButton buttonWithType:UIButtonTypeCustom];
    //    readBtn.backgroundColor = [GFICommonTool colorWithHexString:@"#fafafa"];
    [readBtn addTarget:self action:@selector(gotoJudge) forControlEvents:UIControlEventTouchUpInside];
    [readBtn setTitle:@"表达我的看法.." forState:UIControlStateNormal];
    [readBtn setTitleColor:[GFICommonTool colorWithHexString:@"#676767"] forState:UIControlStateNormal];
    [readBtn setImage:[UIImage imageNamed:@"写评论"] forState:UIControlStateNormal];
    //    [btn1 setBackgroundColor:[UIColor blueColor]];
    //    btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    NSInteger tempWidth = 120;
    if (kISiPhone5) {
        tempWidth = 90;
    }
    readBtn.frame = CGRectMake(0, 5, tempWidth, 30);
    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc]initWithCustomView:readBtn];
    //阅读按钮
    _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_readBtn addTarget:self action:@selector(readNumber) forControlEvents:UIControlEventTouchUpInside];
    [_readBtn setTitle:self.model.readCount forState:UIControlStateNormal];
    [_readBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_readBtn setImage:[UIImage imageNamed:@"阅读量1"] forState:UIControlStateNormal];
    _readBtn.frame = CGRectMake(0, 0, 60, 40);
    _readBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self initButton:_readBtn];
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithCustomView:_readBtn];
    
    //收藏按钮
    _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_collectionBtn addTarget:self action:@selector(makeACollection) forControlEvents:UIControlEventTouchUpInside];
    [_collectionBtn setTitle:self.model.collectionCount forState:UIControlStateNormal];
    [_collectionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_collectionBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
    _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _collectionBtn.frame = CGRectMake(0, 0, 60, 40);
    [self initButton:_collectionBtn];
    UIBarButtonItem *customItem4 = [[UIBarButtonItem alloc]initWithCustomView:_collectionBtn];
    
    
    //分享按钮
    UIImage *sharedIcon = [UIImage imageNamed:@"分享1"];
    sharedIcon = [sharedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *customItem3 = [[UIBarButtonItem alloc]
                                    initWithImage:sharedIcon style:UIBarButtonItemStyleDone
                                    target:self action:@selector(gotoShared)];
    
    NSArray *arr1 = [[NSArray alloc]initWithObjects:customItem1,spaceItem,customItem2,customItem4, nil];
    self.toolbarItems = arr1;
}
//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    float  spacing = 0;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

//评论
- (void)gotoJudge{
    [self alertPopView:nil andPlaceHolderTitle:@"请输入1-200字的评论"];
}

-(void)alertPopView:(NSIndexPath *)indexPath andPlaceHolderTitle:(NSString *)title{
    self.popview = [[popView alloc] initView];
    self.popview.delegagte = self;
    self.popview.indexPath = indexPath;
    self.popview.placeHolderTitle = title;
    __weak typeof (self) weaklf = self;
    _popview.dismissPopViewBlock = ^{
        [weaklf.popview removeFromSuperview];
        weaklf.popview = nil;
    };
    //    _popview.ID = _ID;
    [_popview show];
}
//阅读量
- (void)readNumber{
    NSLog(@"阅读量");
}

//收藏
- (void)makeACollection{
    NSLog(@"点赞");
    _collectionFlag = !_collectionFlag;
    if(_collectionFlag){
        
        NSString *collection = [NSString stringWithFormat:@"%d",[self.model.collectionCount  intValue] + 1];
        [self.collectionBtn setImage:[UIImage imageNamed:@"收藏1选中"] forState:UIControlStateNormal];
        [self.collectionBtn setTitle:collection forState:UIControlStateNormal];
        _personCollection = 1;
    }else{
        [self.collectionBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
        [self.collectionBtn setTitle:self.model.collectionCount forState:UIControlStateNormal];
        _personCollection = 0;
    }
    [self postPicsCollection];
    
}
//网络请求
- (void)postPicsCollection{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.model.ID  forKey:@"portal_id"];
    [params setObject:@(_personCollection) forKey:@"status"];
    
    
    
    [HRHTTPTool postWithURL:kJRG_dofavourite_info parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                
               
                
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error == %@",error);
    }];
    
}
//分享
- (void)gotoShared{
    NSLog(@"分享");
    __block LSDetainViewController *this = self;
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



-(UIImageView *)robotImageView{
    if (_robotImageView == nil) {
        
        UIImage *imgRobot = [UIImage imageNamed:@"置顶"];
        _robotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-62, kScreenHeight - TAB_HEIGHT -NAV_HEIGHT - 75, 42, 42)];
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
    
    if ([self.detailWebviewContainer.webview subviews]){
        
        UIScrollView* scrollView = [[self.detailWebviewContainer.webview subviews] objectAtIndex:0];
        //CGPointMake(0, 0)回到顶部
        [scrollView setContentOffset:CGPointMake(0, -NAV_HEIGHT) animated:YES];
    }
    
}

//网络请求
- (void)getPics:(NSString*)content andType:(NSInteger)type andUrl:(NSString *)url{

    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (type == 1) {
        [params setObject:self.model.ID forKey:@"portal_id"];
        [params setObject:@(page) forKey:@"index"];
    }else if(type == 2){
        [params setObject:self.model.ID forKey:@"portal_id"];
        [params setObject:@(0) forKey:@"parent_id"];
        [params setObject:self.model.user_id forKey:@"to_user_id"];
        [params setObject:content forKey:@"content"];
    }else if (type == 3){
        BGCommentModel *model = self.datas [indexRow];
        [params setObject:self.model.ID forKey:@"portal_id"];
        [params setObject:@(model.comment_id) forKey:@"parent_id"];
        [params setObject:@(model.comment_beUserd_id) forKey:@"to_user_id"];
        [params setObject:content forKey:@"content"];
    }
    
    [HRHTTPTool postWithURL:url parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                if (type == 1) {
                    NSMutableArray *tempNewsArr = [NSMutableArray array];
                    NSArray *tempArr = [json objectForKey:@"result"];
                    for (NSDictionary *dict in tempArr) {
                        BGCommentModel *model = [BGCommentModel mj_objectWithKeyValues:dict];
                        [tempNewsArr addObject:model];
                        
                    }
                    
                    if(tempNewsArr.count > 0 && tempNewsArr !=nil){
                        [self.datas addObjectsFromArray:tempNewsArr];
                        
                    }
                    
                    if (self.datas.count ==0 ||  self.datas.count %10 != 0) {
                        [self.detailWebviewContainer.tableview.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.detailWebviewContainer.tableview.mj_footer endRefreshing];
                    }
                    [self.detailWebviewContainer.tableview reloadData];
                }else{
                    
                    [self.datas removeAllObjects];
                    page = 1;
                    [self getPics:nil andType:1 andUrl:kJRG_portal_comment_info];
                    _headerTitle.text = [NSString stringWithFormat:@"全部评论 (%@)",_recommendCount];
                }
               
                
                
            }
        }else{
            [OMGToast showWithText:[json objectForKey:@"error_msg"] topOffset:KScreenHeight/2 duration:1.7];
            
        }
    } failure:^(NSError *error) {
        [OMGToast showWithText:@"网络错误" topOffset:KScreenHeight/2 duration:1.7];
        NSLog(@"error == %@",error);
    }];
}

#pragma mark - fetion delegate weixin delegate
- (void)_shareWeiXin:(NSInteger)scene withData:(BGShareModel *)model{
    
    //如果没有微信客户端，提示用户
//    if ([WXApi isWXAppInstalled]) {
//    }else{
//        [OMGToast showWithText:@"您未安装微信" topOffset:KScreenHeight/2 duration:1.7];
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
    message.title = self.model.des;
    message.description = self.model.excerpt;
    UIImage *img = [UIImage imageWithData:[self imageWithImage:_shareImg.image scaledToSize:CGSizeMake(300, 300)]];
    [message setThumbImage:img];
    
    WXWebpageObject * webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = self.model.url;
//    webPageObject.webpageUrl = @"这是一个链接";
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq * req1 = [[SendMessageToWXReq alloc]init];
    req1.bText = NO;
    req1.message = message;
    //设置分享到朋友圈(WXSceneTimeline)、好友回话(WXSceneSession)、收藏(WXSceneFavorite)
    req1.scene = scene;
    [WXApi sendReq:req1];
    
    
}
// ------这种方法对图片既进行压缩，又进行裁剪
- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}





@end
