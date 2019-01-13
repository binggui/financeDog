//
//  TTWeiboCommentCell.h
//  HighCopyTodayNews
//
//  Created by hack on 2017/8/17.
//  Copyright © 2017年 hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGCommentModel.h"

@class WeiboCommentModel;

@protocol TTWeiboCommentCellDelegate <NSObject>
@optional
- (void)didSelectPeople:(NSIndexPath *) cellIndexPath;

@end

@interface TTWeiboCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIImageView *txImg;
@property (weak, nonatomic) IBOutlet UIButton *nameShow;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeShowLable;
@property (weak, nonatomic) IBOutlet UILabel *timeShowLabelNew;
@property (weak, nonatomic) IBOutlet UIButton *remmentButton;
@property (strong, nonatomic) NSIndexPath * cellIndexPath;
@property (strong, nonatomic) NSString * likeCount;
@property (nonatomic, weak) id <TTWeiboCommentCellDelegate> delegate;
@property (assign, nonatomic) BOOL  goodFlag;
@property (strong, nonatomic) BGCommentModel * model;

-(void)setDataModel:(BGCommentModel*)model;
@end
