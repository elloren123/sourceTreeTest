//
//  ADLOrderListCell.m
//  lockboss
//
//  Created by adel on 2019/6/21.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLOrderListCell.h"
#import "ADLGlobalDefine.h"
#import <UIImageView+WebCache.h>

@interface ADLOrderListCell ()
@property (nonatomic, strong) UILabel *moreLab;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *imgView1;
@property (nonatomic, strong) UIImageView *imgView2;
@property (nonatomic, strong) UIImageView *imgView3;
@property (nonatomic, strong) UIImageView *imgView4;
@property (nonatomic, strong) UIImageView *imgView5;
@property (nonatomic, strong) UIImageView *imgView6;
@property (nonatomic, strong) UIImageView *imgView7;
@property (nonatomic, strong) UIImageView *imgView8;
@property (nonatomic, strong) NSArray *imageViewArr;
@end

@implementation ADLOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusBtn.layer.cornerRadius = 3;
    self.statusBtn.layer.borderWidth = 0.5;
    self.statusBtn.layer.borderColor = APP_COLOR.CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScrollView)];
    [self.scrollView addGestureRecognizer:tap];
    
    UILabel *moreLab = [[UILabel alloc] init];
    moreLab.textColor = COLOR_999999;
    moreLab.font = [UIFont systemFontOfSize:14];
    moreLab.textAlignment = NSTextAlignmentCenter;
    moreLab.text = @"...";
    [self.scrollView addSubview:moreLab];
    self.moreLab = moreLab;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [self.scrollView addSubview:imgView];
    self.imgView = imgView;
    
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.contentMode = UIViewContentModeScaleAspectFill;
    imgView1.clipsToBounds = YES;
    [self.scrollView addSubview:imgView1];
    self.imgView1 = imgView1;
    
    UIImageView *imgView2 = [[UIImageView alloc] init];
    imgView2.contentMode = UIViewContentModeScaleAspectFill;
    imgView2.clipsToBounds = YES;
    [self.scrollView addSubview:imgView2];
    self.imgView2 = imgView2;
    
    UIImageView *imgView3 = [[UIImageView alloc] init];
    imgView3.contentMode = UIViewContentModeScaleAspectFill;
    imgView3.clipsToBounds = YES;
    [self.scrollView addSubview:imgView3];
    self.imgView3 = imgView3;
    
    UIImageView *imgView4 = [[UIImageView alloc] init];
    imgView4.contentMode = UIViewContentModeScaleAspectFill;
    imgView4.clipsToBounds = YES;
    [self.scrollView addSubview:imgView4];
    self.imgView = imgView4;
    
    UIImageView *imgView5 = [[UIImageView alloc] init];
    imgView5.contentMode = UIViewContentModeScaleAspectFill;
    imgView5.clipsToBounds = YES;
    [self.scrollView addSubview:imgView5];
    self.imgView5 = imgView5;
    
    UIImageView *imgView6 = [[UIImageView alloc] init];
    imgView6.contentMode = UIViewContentModeScaleAspectFill;
    imgView6.clipsToBounds = YES;
    [self.scrollView addSubview:imgView6];
    self.imgView6 = imgView6;
    
    UIImageView *imgView7 = [[UIImageView alloc] init];
    imgView7.contentMode = UIViewContentModeScaleAspectFill;
    imgView7.clipsToBounds = YES;
    [self.scrollView addSubview:imgView7];
    self.imgView7 = imgView7;
    
    UIImageView *imgView8 = [[UIImageView alloc] init];
    imgView8.contentMode = UIViewContentModeScaleAspectFill;
    imgView8.clipsToBounds = YES;
    [self.scrollView addSubview:imgView8];
    self.imgView8 = imgView8;
    
    self.imageViewArr = @[imgView,imgView1,imgView2,imgView3,imgView4,imgView5,imgView6,imgView7,imgView8];
}

- (IBAction)clickStatusBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStatusBtn:)]) {
        [self.delegate didClickStatusBtn:sender];
    }
}

- (void)clickScrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickScrollView:)]) {
        [self.delegate didClickScrollView:self.statusBtn];
    }
}

- (void)updateImageViewWithUrlArr:(NSArray *)urlArr {
    NSInteger count = urlArr.count;
    if (count > 9) {
        self.moreLab.frame = CGRectMake(588, 0, 42, 52);
        self.scrollView.contentSize = CGSizeMake(630, 60);
    } else {
        self.moreLab.frame = CGRectZero;
        self.scrollView.contentSize = CGSizeMake(66*count+6, 60);
    }
    [self.imageViewArr enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > count-1) {
            obj.frame = CGRectZero;
        } else {
            obj.frame = CGRectMake(66*idx, 0, 60, 60);
            [obj sd_setImageWithURL:[NSURL URLWithString:urlArr[idx]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        }
    }];
}

@end
