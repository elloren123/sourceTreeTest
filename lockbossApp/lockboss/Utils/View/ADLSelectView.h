//
//  ADLSelectView.h
//  lockboss
//
//  Created by adel on 2019/5/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLSelectViewDelegate <NSObject>

- (void)didClickSelectAllBtn:(UIButton *)sender;

- (void)didClickTitleBtn:(UIButton *)sender;

@end

@interface ADLSelectView : UIView

///初始化
+ (instancetype)selectViewWithFrame:(CGRect)frame title:(NSString *)title buttonH:(CGFloat)buttonH;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title buttonH:(CGFloat)buttonH;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic, strong) NSString *money;

@property (nonatomic, weak) id<ADLSelectViewDelegate> delegate;

@end

