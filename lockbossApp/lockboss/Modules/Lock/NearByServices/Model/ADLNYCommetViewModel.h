//
//  ADLNYCommetViewModel.h
//  lockboss
//
//  Created by bailun91 on 2019/10/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLNYCommetViewModel : NSObject

@property (nonatomic,   copy) NSString *userHeadImgUrl; //用户头像地址
@property (nonatomic,   copy) NSString *userName;       //用户名
@property (nonatomic,   copy) NSString *cmtDate;        //评论日期
@property (nonatomic,   copy) NSString *cmtScore;       //评论分数
@property (nonatomic,   copy) NSString *userMsg;        //评论信息
@property (nonatomic,   copy) NSString *cmtImgUrl;      //截图地址
@property (nonatomic,   copy) NSString *replyMsg;       //商家回复信息
@property (nonatomic, assign) int      anonymousFlag;   //是否匿名: 0正常 1匿名
@property (nonatomic, assign) CGFloat  userMsgHeight;   //用户评价信息高度
@property (nonatomic, assign) CGFloat  cmtImgHeight;    //用户评价截图高度
@property (nonatomic, assign) CGFloat  replyHeight;     //商家回复信息高度

@end

NS_ASSUME_NONNULL_END
