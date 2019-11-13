//
//  ADLGoodsEvaModel.h
//  lockboss
//
//  Created by adel on 2019/7/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLGoodsEvaModel : NSObject

///回复添加时间
@property (nonatomic, strong) NSString *addDatetime;

///回复内容
@property (nonatomic, strong) NSString *content;

///回复人昵称
@property (nonatomic, strong) NSString *fromUser;

///回复人Id
@property (nonatomic, strong) NSString *fromUserId;

///回复人头像
@property (nonatomic, strong) NSString *headImg;

///回复Id
@property (nonatomic, strong) NSString *replyId;

///发表商品评价人Id
@property (nonatomic, strong) NSString *toUserId;

///回复Header高度
@property (nonatomic, assign) CGFloat headerH;

///是否折叠
@property (nonatomic, assign) BOOL fold;

///二级回复数组
@property (nonatomic, strong) NSMutableArray *sReplyArr;

///二级回复内容高度数组
@property (nonatomic, strong) NSMutableArray *sReplyHArr;

@end
