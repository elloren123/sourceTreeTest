//
//  ADLDropViewCell.m
//  lockboss
//
//  Created by adel on 2019/8/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDropViewCell.h"

@implementation ADLDropViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier image:(BOOL)image lightMode:(BOOL)lightMode {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.numberOfLines = 2;
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(12, 44.5, 138, 0.5)];
        [self.contentView addSubview:spView];
        self.spView = spView;
        
        if (image) {
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 21, 21)];
            [self.contentView addSubview:iconView];
            self.iconView = iconView;
            titleLab.frame = CGRectMake(45, 0, 101, 45);
        } else {
            titleLab.frame = CGRectMake(12, 0, 136, 45);
        }
        
        if (lightMode) {
            self.backgroundColor = [UIColor whiteColor];
            titleLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            spView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        } else {
            titleLab.textColor = [UIColor whiteColor];
            self.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            spView.backgroundColor = [UIColor colorWithRed:29/255.0 green:29/255.0 blue:29/255.0 alpha:0.6];
        }
    }
    return self;
}

@end
