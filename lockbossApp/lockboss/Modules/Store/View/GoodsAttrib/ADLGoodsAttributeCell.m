//
//  ADLGoodsAttributeCell.m
//  lockboss
//
//  Created by adel on 2019/4/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsAttributeCell.h"

@implementation ADLGoodsAttributeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *attrLab = [[UILabel alloc] initWithFrame:self.bounds];
        attrLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        attrLab.textAlignment = NSTextAlignmentCenter;
        attrLab.font = [UIFont systemFontOfSize:13];
        attrLab.layer.borderWidth = 0.5;
        attrLab.layer.cornerRadius = 3;
        attrLab.layer.borderColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1].CGColor;
        [self.contentView addSubview:attrLab];
        attrLab.clipsToBounds = YES;
        self.attrLab = attrLab;
    }
    return self;
}

- (void)setText:(NSString *)text {
    _attrLab.frame = self.bounds;
    _attrLab.text = text;
}

- (NSString *)text {
    return _attrLab.text;
}

@end
