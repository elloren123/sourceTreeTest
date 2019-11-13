//
//  ADLAutoresizeLabelFlowHeader.m
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAutoresizeLabelFlowHeader.h"
@interface ADLAutoresizeLabelFlowHeader ()
@property (nonatomic, strong) UIImageView *leftIV;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation ADLAutoresizeLabelFlowHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_F7F7F7;
        [self createInterface];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setConstraints];
}

#pragma mark - 内部逻辑实现
- (void)deleteButtonClicked:(UIButton *)btn {
    //    if ([self.delegate respondsToSelector:@selector(XDAutoresizeLabelFlowHeaderDeleteAction)]) {
    //        [self.delegate XDAutoresizeLabelFlowHeaderDeleteAction];
    //    }
    if (self.deleteActionBlock) {
        self.deleteActionBlock(self.indexPath);
    }
}


#pragma mark - 代理协议
#pragma mark - 数据请求 / 数据处理
- (void)setHaveDeleteBtn:(BOOL)haveDeleteBtn {
    _haveDeleteBtn = haveDeleteBtn;
    if (haveDeleteBtn) {
        self.deleteBtn.hidden = false;
    }else {
        self.deleteBtn.hidden = true;
    }
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    _title.text = titleString;
}

#pragma mark - 视图布局
- (void)createInterface {
    // 图片
    self.leftIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fire_icon"]];
    [self addSubview:self.leftIV];
    
    // 标题
    self.title = [self  createLabelFrame:CGRectMake(0, 0, 0, 0) font:15 text:@"" texeColor:[UIColor blackColor]];
    [self addSubview:self.title];
    
    // 右上角 删除按钮
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setImage:[UIImage imageNamed:@"topic_delete"] forState:UIControlStateNormal];
    self.deleteBtn.frame = CGRectMake(self.width - 60, 5, 50, self.height - 10);
    [self.deleteBtn addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.deleteBtn];
}

- (void)setConstraints {
    [self.leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(6);
        make.centerY.equalTo(self);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(28);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-80);
    }];
}

#pragma mark - 懒加载
@end
