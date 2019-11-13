//
//  ADLEmojiViewCell.m
//  lockboss
//
//  Created by adel on 2019/8/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLEmojiViewCell.h"

@implementation ADLEmojiViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *emojiLab = [[UILabel alloc] initWithFrame:self.bounds];
        emojiLab.textAlignment = NSTextAlignmentCenter;
        emojiLab.font = [UIFont systemFontOfSize:30];
        
        [self.contentView addSubview:emojiLab];
        self.emojiLab = emojiLab;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, frame.size.width, frame.size.height-2)];
        imgView.image = [UIImage imageNamed:@"emoji_delete"];
        imgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:imgView];
        self.imgView = imgView;
    }
    return self;
}

@end
