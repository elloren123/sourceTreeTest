//
//  ADLAccHistoryCell.m
//  lockboss
//
//  Created by Adel on 2019/9/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAccHistoryCell.h"

@implementation ADLAccHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *accountLab = [[UILabel alloc] init];
        accountLab.font = [UIFont systemFontOfSize:15];
        accountLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        accountLab.numberOfLines = 2;
        [self.contentView addSubview:accountLab];
        self.accountLab = accountLab;
        
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"history_delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        
        UIView *spView = [[UIView alloc] init];
        spView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self.contentView addSubview:spView];
        self.spView = spView;
    }
    return self;
}

#pragma mark ------ 删除 ------
- (void)clickDeleteBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDeleteBtn:)]) {
        [self.delegate didClickDeleteBtn:self.deleteBtn];
    }
}

- (void)layoutSubviews {
    CGFloat wid = self.frame.size.width;
    self.accountLab.frame = CGRectMake(12, 0, wid-60, 44);
    self.deleteBtn.frame = CGRectMake(wid-40, 0, 40, 44);
    self.spView.frame = CGRectMake(12, 43.5, wid-12, 0.5);
}

@end
