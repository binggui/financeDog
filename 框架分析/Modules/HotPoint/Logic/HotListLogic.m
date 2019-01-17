//
//  HotListLogic.m
//  框架分析
//
//  Created by FuBG02 on 2018/12/28.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import "HotListLogic.h"
#import "FDHomeModel.h"

@interface HotListLogic()
@property (nonatomic,copy) NSArray * imgArray;
@property (nonatomic,copy) NSArray * desLabelArray;
@property (nonatomic,copy) NSArray * readNumberArray;
@property (nonatomic,copy) NSArray * messageNumberArray;
@property (nonatomic,copy) NSArray * collectionNumberArray;
@end

@implementation HotListLogic
-(instancetype)init{
    self = [super init];
    if (self) {
        _dataArray = @[].mutableCopy;
        _imgArray = @[@"http://d.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=76dcee959358d109c4b6a1b4e168e087/11385343fbf2b211389b08a5cb8065380dd78ea0.jpg",@"http://www.soideas.cn/uploads/allimg/110626/2126221034-5.jpg",@"http://scimg.jb51.net/touxiang/201705/2017053121043719.jpg",@"http://scimg.jb51.net/touxiang/201706/20170609172558191.jpg",@"http://www.qqleju.com/uploads/allimg/160818/18-065635_493.jpg",@"http://img1.touxiang.cn/uploads/allimg/111029/1_111029111038_26.jpg",@"http://img2.zol.com.cn/up_pic/20120705/z1vsowZWoKbr.jpg",@"http://www.soideas.cn/uploads/allimg/110524/2246442634-17.jpg",@"http://dynamic-image.yesky.com/600x-/uploadImages/upload/20140909/upload/201409/25u12gkmr3ujpg.jpg",@"http://www.qqleju.com/uploads/allimg/160213/13-053516_87.jpg",@"http://d.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=4aca31fad02a60595245e91e1d0418ad/a8773912b31bb051e3dc6e1b317adab44aede00d.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171748_BeJcN.thumb.600_0.jpeg",@"http://cdn.duitang.com/uploads/item/201312/05/20131205171746_MxNX8.thumb.600_0.jpeg"];
        _desLabelArray = @[@"我师弟阿飞啊速度快",@"放辣椒六块腹肌埃里克森",@"发牢骚的卡佛权威哦亲我",@"快枪手按时发卡;哦",@"YoYo产品经理as;饭卡; ",@"亲我一口能咋地",@"Rain"];
        _readNumberArray = @[@"654",@"687",@"123",@"215",@"153",@"30",@"987"];
        _messageNumberArray = @[@"43",@"12",@"33",@"55",@"123",@"454"];
        _collectionNumberArray = @[@"43",@"12",@"33",@"55",@"123",@"454"];
    }
    return self;
}

#pragma mark ————— 拉取数据 —————
-(void)loadData{
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //模拟成功
//        if (_page == 0) {
//            [_dataArray removeAllObjects];
//        }
//        for (int i = 0; i < 10; i++) {
//
//            FDHomeModel *model = [FDHomeModel new];
//            model.img = _imgArray[arc4random()%_imgArray.count];
//            model.collectionCount = _collectionNumberArray[arc4random()%_collectionNumberArray.count];
//            model.des = _desLabelArray[arc4random()%_desLabelArray.count];
//            model.readCount = _readNumberArray[arc4random()%_readNumberArray.count];
//
//            model.messageCount = _messageNumberArray[arc4random()%_messageNumberArray.count];
//
//            [_dataArray addObject:model];
//        }
//        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestDataCompleted)]) {
//            [self.delegagte requestDataCompleted];
//        }
//
//    });
    [self getPics];

//    NSMutableDictionary *parms = @{@"index":@(_page + 1)}.mutableCopy;
//
//        [HRHTTPTool postWithURL:kJRG_weeknew_info parameters:parms success:^(id json) {
//            NSString *result = [json objectForKey:@"error_code"];
//            if ([result intValue] == 200) {
//                if ([json isKindOfClass:[NSDictionary class]]) {
//
//                    NSMutableArray *tempArr = [NSMutableArray array];
//                    NSArray *picList = [json objectForKey:@"result"];
//                    for (NSDictionary *dict in picList) {
//                        FDHomeModel *model = [FDHomeModel mj_objectWithKeyValues:dict];
//                        [tempArr addObject:model];
//                    }
//                    if(tempArr.count > 0){
//                        _dataArray  = tempArr.mutableCopy;
//                    }
//
//                }
//            }else{
//                 [OMGToast showWithText:[json objectForKey:@"error_msg"] topOffset:KScreenHeight/2 duration:2.0];
//
//            }
//        } failure:^(NSError *error) {
//            [OMGToast showWithText:@"网络错误" topOffset:KScreenHeight/2 duration:2.0];
//            NSLog(@"error == %@",error);
//        }];
    

    
    
    
    
    //发起请求 示例
    //    GetWaterFallListAPI *req = [GetWaterFallListAPI new];
    //    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    //        NSLog(@"请求成功");
    //    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    //        NSLog(@"请求失败 %@",req.message);
    //    }];
}
//网络请求
- (void)getPics{
    //模拟成功
    if (_page == 0) {
        [_dataArray removeAllObjects];
    }
    NSString *urlTemp = nil;
    if (_type == 1) {
        urlTemp = kJRG_daynew_info;
    }else if(_type == 2){
        urlTemp = kJRG_weeknew_info;
    }else if(_type == 3){
        urlTemp = kJRG_mounthnew_info;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(self.page + 1) forKey:@"index"];
    
    [HRHTTPTool postWithURL:urlTemp parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                
                NSMutableArray *tempNewsArr = [NSMutableArray array];
                NSArray *tempArr = [json objectForKey:@"result"];
                for (NSDictionary *dict in tempArr) {
                  FDHomeModel *model = [FDHomeModel mj_objectWithKeyValues:dict];
                    [tempNewsArr addObject:model];
                }
                
                if(tempNewsArr.count > 0){
                    
                    [self.dataArray addObjectsFromArray:tempNewsArr];
                  
                }
                if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestDataCompleted)]) {
                    
                    [self.delegagte requestDataCompleted];
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

@end
