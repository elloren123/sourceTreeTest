//
//  ADLVideoPreviewCell.m
//  lockboss
//
//  Created by adel on 2019/7/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLVideoPreviewCell.h"

@implementation ADLVideoPreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat wid = [UIScreen mainScreen].bounds.size.width;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, wid-24, (wid-24)*0.56)];
        bgView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:bgView];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [bgView addSubview:imgView];
        self.imgView = imgView;
        
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [bgView addSubview:coverView];
        self.coverView = coverView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickVideoPreView)];
        [coverView addGestureRecognizer:tap];
        
        UIImageView *playView = [[UIImageView alloc] initWithFrame:CGRectMake(wid/2-20, ((wid-24)*0.56-40)/2, 40, 40)];
        playView.image = [UIImage imageNamed:@"goods_play"];
        [self.contentView addSubview:playView];
        
        UILabel *durationLab = [[UILabel alloc] init];
        durationLab.font = [UIFont systemFontOfSize:12];
        durationLab.textColor = [UIColor whiteColor];
        durationLab.textAlignment = NSTextAlignmentRight;
        [coverView addSubview:durationLab];
        self.durationLab = durationLab;
    }
    return self;
}

- (void)setImgSize:(CGSize)imgSize {
    if (self.imgView.frame.size.height == 0) {
        _imgSize = imgSize;
        CGFloat wid = [UIScreen mainScreen].bounds.size.width-24;
        CGFloat hei = wid*0.56;
        CGFloat imgW = wid;
        CGFloat imgH = hei;
        if (imgSize.height != 0) {
            imgW = hei*imgSize.width/imgSize.height;
            imgH = hei;
        }
        if (imgW > wid) {
            imgW = wid;
            imgH = wid*imgSize.height/imgSize.width;
        }
        self.imgView.frame = CGRectMake((wid-imgW)/2, (hei-imgH)/2, imgW, imgH);
        self.coverView.frame = CGRectMake((wid-imgW)/2, (hei-imgH)/2, imgW, imgH);
        self.durationLab.frame = CGRectMake(0, imgH-21, imgW-8, 15);
    }
}

- (void)clickVideoPreView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickVideoPreView)]) {
        [self.delegate didClickVideoPreView];
    }
}

@end
