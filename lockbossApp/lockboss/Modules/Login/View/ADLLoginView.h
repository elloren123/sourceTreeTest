//
//  ADLLoginView.h
//  lockboss
//
//  Created by adel on 2019/4/16.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLLoginViewDelegate <NSObject>

- (void)didClickBackBtn;

- (void)didClickRegisterBtn;

- (void)didClickForgetBtn;

- (void)didClickQQLoginBtn;

- (void)didClickWechatLoginBtn;

- (void)verifyToken:(NSMutableDictionary *)userInfo;

@end

@interface ADLLoginView : UIView

+ (instancetype)loginViewWithDelegate:(id)delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

@property (nonatomic, weak) id<ADLLoginViewDelegate> delegate;

@property (nonatomic, strong) UILabel *thirdLab;

@property (nonatomic, strong) UIButton *qqBtn;

@property (nonatomic, strong) UIButton *wechatBtn;

@end
