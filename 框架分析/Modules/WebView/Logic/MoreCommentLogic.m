//
//  MoreCommentLogic.m
//  框架分析
//
//  Created by FuBG02 on 2019/1/3.
//  Copyright © 2019年 Jenocy. All rights reserved.
//

#import "MoreCommentLogic.h"
#import "BGCommentModel.h"
@interface MoreCommentLogic()

@end

@implementation MoreCommentLogic
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(self.page + 1) forKey:@"index"];
    [params setObject:@(self.parent_id) forKey:@"parent_id"];
    [params setObject:@(self.object_id) forKey:@"object_id"];
    [HRHTTPTool postWithURL:kJRG_getchildcomment_info parameters:params success:^(id json) {
        NSString *result = [json objectForKey:@"error_code"];
        if ([result intValue] == 200) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                
                NSMutableArray *tempNewsArr = [NSMutableArray array];
                NSArray *tempArr = [json objectForKey:@"result"];
                for (NSDictionary *dict in tempArr) {
                    BGCommentModel *model = [BGCommentModel mj_objectWithKeyValues:dict];
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
