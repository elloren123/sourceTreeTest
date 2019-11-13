//
//  ADLSingleImageCell.m
//  lockboss
//
//  Created by adel on 2019/5/14.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSingleImageCell.h"
#import "ADLImagePreView.h"

@implementation ADLSingleImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imgSize:(CGSize)imgSize {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat wid = [UIScreen mainScreen].bounds.size.width;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((wid-imgSize.width)/2, 0, imgSize.width, imgSize.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.userInteractionEnabled = YES;
        [self.contentView addSubview:imgView];
        imgView.clipsToBounds = YES;
        self.imgView = imgView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView)];
        [imgView addGestureRecognizer:tap];
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)clickImageView {
    if (self.imgUrl.length > 0) {
        [ADLImagePreView showWithImageViews:@[self.imgView] urlArray:@[self.imgUrl] currentIndex:0];
    }
}

@end
