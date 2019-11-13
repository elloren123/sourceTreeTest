//
//  ADLModifyView.h
//  lockboss
//
//  Created by adel on 2019/7/31.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ADLModifyType) {
    ADLModifyTypePhone,
    ADLModifyTypeEmail
};

@interface ADLModifyView : UIView

///dataDict字段 title-标题 placeholder-提示文字  code-获取验证码地址 key-获取验证码参数key path-提交地址 param-参数字典input-code
+ (instancetype)modifyViewWithType:(ADLModifyType)type
                          dataDict:(NSDictionary *)dataDict
                     confirmAction:(void(^)(NSString *input))confirmAction;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(ADLModifyType)type
                     dataDict:(NSDictionary *)dataDict
                confirmAction:(void(^)(NSString *input))confirmAction;

@end
