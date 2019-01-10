//
//  PersonModel.h
//  框架分析
//
//  Created by 丙贵 on 18/5/17.
//  Copyright © 2018年 Jenocy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Pictures;

@interface PersonModel : NSObject

@property (copy, nonatomic) NSString * jumpUrl;

@property (copy, nonatomic) NSString * nameText;


//id = 6;
//"post_hits" = 2;
//"post_like" = 0;
//"post_title" = "\U6210\U529f\U6848\U4f8b\U6d4b\U8bd51";

@property (nonatomic, copy) NSString *age;

@property (nonatomic, assign) NSInteger channel;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *weixin;

//@property (nonatomic, strong) NSArray<Pictures *> *pictures;
@property (nonatomic, copy) NSString *picture;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *requires;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, assign) float height;

@property (nonatomic, assign) float width;

@property (nonatomic, copy) NSString *hobbys;

@property (nonatomic,assign) float hobbysHeight;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *job;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *imageAve;

@property (nonatomic, copy) NSString *juli;

@end
@interface Pictures : NSObject

@property (nonatomic, copy) NSString *format;
@property (strong, nonatomic) NSString * collectionCount;
@property (strong, nonatomic) NSString * goodCount;
@property (strong, nonatomic) NSString * messageCount;
@property (strong, nonatomic) NSString * ID;
@property (strong, nonatomic) NSString * updateTime;
@property (strong, nonatomic) NSString * publishTime;



@property (nonatomic, assign) NSInteger height;

@property (nonatomic, copy) NSString *mimeType;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *imageAve;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, copy) NSString *pictureType;

@property (nonatomic, copy) NSString *urlWithName;

@property (nonatomic, copy) NSString *url;

@end
