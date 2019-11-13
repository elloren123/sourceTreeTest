//
//  ADLSearchGoodsCell.m
//  lockboss
//
//  Created by adel on 2019/4/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSearchGoodsCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLSearchGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titLab = [[UILabel alloc] init];
        titLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        titLab.textColor = COLOR_999999;
        titLab.numberOfLines = 0;
        [self.contentView addSubview:titLab];
        self.titLab = titLab;
        
        UIView *spView = [[UIView alloc] init];
        spView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:spView];
        self.spView = spView;
    }
    return self;
}

- (void)layoutSubviews {
    self.titLab.frame = CGRectMake(12, 0, SCREEN_WIDTH-24, self.frame.size.height);
    self.spView.frame = CGRectMake(12, self.frame.size.height-0.5, SCREEN_WIDTH-12, 0.5);
}

@end
