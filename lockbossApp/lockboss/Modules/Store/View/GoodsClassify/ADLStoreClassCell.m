//
//  ADLStoreClassCell.m
//  lockboss
//
//  Created by adel on 2019/4/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLStoreClassCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLStoreClassCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat width = frame.size.width;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width*0.69)];
        bgView.backgroundColor = COLOR_F2F2F2;
        [self.contentView addSubview:bgView];
        
        UIImageView *imgView= [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, width-16, width*0.69-16)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.contentView addSubview:imgView];
        self.imgView = imgView;
        
        UIImageView *dxtView= [[UIImageView alloc] initWithFrame:CGRectMake(width-28, 0, 28, 28)];
        dxtView.image = [UIImage imageNamed:@"store_dxt"];
        [self.contentView addSubview:dxtView];
        self.dxtView = dxtView;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, width*0.69, width, FONT_SIZE+15)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        titleLab.textColor = COLOR_333333;
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
    }
    return self;
}

@end
