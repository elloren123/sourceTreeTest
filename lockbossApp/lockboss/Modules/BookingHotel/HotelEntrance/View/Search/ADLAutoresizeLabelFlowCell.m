//
//  ADLAutoresizeLabelFlowCell.m
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAutoresizeLabelFlowCell.h"
#import "ADLAutoresizeLabelFlowConfig.h"
#define JKColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface ADLAutoresizeLabelFlowCell ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation ADLAutoresizeLabelFlowCell

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [ADLAutoresizeLabelFlowConfig shareConfig].itemColor;
        _titleLabel.textColor = [ADLAutoresizeLabelFlowConfig shareConfig].textColor;
        _titleLabel.font = [ADLAutoresizeLabelFlowConfig shareConfig].textFont;
        _titleLabel.layer.cornerRadius = [ADLAutoresizeLabelFlowConfig shareConfig].itemCornerRaius;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.borderColor = JKColor(180, 180, 180, 1.0).CGColor;
        _titleLabel.layer.borderWidth = 0.5;
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)configCellWithTitle:(NSString *)title {
    self.titleLabel.frame = CGRectMake(0, 5, self.width, self.height);
    self.titleLabel.text = title;
}

- (void)setBeSelected:(BOOL)beSelected {
   _beSelected = beSelected;
    if (beSelected) {
        self.titleLabel.backgroundColor = [ADLAutoresizeLabelFlowConfig shareConfig].itemSelectedColor;
        self.titleLabel.textColor = [ADLAutoresizeLabelFlowConfig shareConfig].textSelectedColor;
    }else {
        self.titleLabel.backgroundColor = [ADLAutoresizeLabelFlowConfig shareConfig].itemColor;
        self.titleLabel.textColor = [ADLAutoresizeLabelFlowConfig shareConfig].textColor;
    }
}
@end
