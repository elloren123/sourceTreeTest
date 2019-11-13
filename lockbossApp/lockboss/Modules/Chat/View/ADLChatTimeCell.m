//
//  ADLChatTimeCell.m
//  lockboss
//
//  Created by adel on 2019/8/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLChatTimeCell.h"

@implementation ADLChatTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.font = [UIFont systemFontOfSize:12];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.layer.cornerRadius = 10;
        timeLab.clipsToBounds = YES;
        [self.contentView addSubview:timeLab];
        self.timeLab = timeLab;
    }
    return self;
}

@end
