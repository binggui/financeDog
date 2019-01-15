//
//  BGMessageAndCommentLogic.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/12.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "BGMessageAndCommentLogic.h"
#import "MessageAndCommentModel.h"

@implementation BGMessageAndCommentLogic
-(instancetype)init{
    self = [super init];
    if (self) {
        _dataArray = @[].mutableCopy;
        
    }
    return self;
}

#pragma mark ————— 拉取数据 —————
-(void)loadData{
   
    [self getPics];
   
}

//网络请求
- (void)getPics{
    //模拟成功
    if (_page == 0) {
        [_dataArray removeAllObjects];
    }
    
    NSString *urlTemp = nil;
    if (_type == 1) {//消息
        urlTemp = kJRG_sysmsg_info;
    }else if(_type == 2){//评论
        urlTemp = kJRG_mymsg_info;
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
                    MessageAndCommentModel *model = [MessageAndCommentModel mj_objectWithKeyValues:dict];
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
