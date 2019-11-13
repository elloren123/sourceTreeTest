//
//  ADLLockerEvaluateCell.m
//  lockboss
//
//  Created by adel on 2019/6/19.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLockerEvaluateCell.h"
#import <UIImageView+WebCache.h>
#import "ADLImagePreView.h"

@interface ADLLockerEvaluateCell ()
@property (nonatomic, strong) NSMutableArray *imageViewArr;
@property (nonatomic, strong) NSMutableArray *imageUrlArr;
@end

@implementation ADLLockerEvaluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.cornerRadius = 3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserIcon:)];
    [self.imgView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView2 addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView3 addGestureRecognizer:tap3];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView4 addGestureRecognizer:tap4];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView5 addGestureRecognizer:tap5];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView6 addGestureRecognizer:tap6];
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView7 addGestureRecognizer:tap7];
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView8 addGestureRecognizer:tap8];
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView9 addGestureRecognizer:tap9];
}

- (void)clickUserIcon:(UITapGestureRecognizer *)tap {
    if (self.headShot) {
        [ADLImagePreView showWithImageViews:@[tap.view] urlArray:@[self.headShot] currentIndex:0];
    }
}

- (void)clickImageView:(UITapGestureRecognizer *)tap {
  [ADLImagePreView showWithImageViews:self.imageViewArr urlArray:self.imageUrlArr currentIndex:tap.view.tag];
}

- (void)updateImageViewImage:(NSArray *)urlArr width:(CGFloat)wid {
    NSInteger imgCount = urlArr.count > 9 ? 9 : urlArr.count;
    CGFloat imgW = 0;
    [self.imageViewArr removeAllObjects];
    [self.imageUrlArr removeAllObjects];
    switch (imgCount) {
        case 0:
            self.imgH.constant = 1;
            break;
        case 1: {
            self.imgH.constant = 150;
            self.imgView1.frame = CGRectMake(0, 10, 130, 130);
            __weak typeof(self)weakSelf = self;
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"img_square"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image != nil) {
                    CGFloat imageW = image.size.width/image.size.height*130;
                    if (imageW < 100) imageW = 100;
                    if (imageW > wid) imageW = wid;
                    weakSelf.imgView1.frame = CGRectMake(0, 10, imageW, 130);
                }
            }];
            self.imgView2.frame = CGRectZero;
            self.imgView3.frame = CGRectZero;
            self.imgView4.frame = CGRectZero;
            self.imgView5.frame = CGRectZero;
            self.imgView6.frame = CGRectZero;
            [self.imageViewArr addObject:self.imgView1];
            [self.imageUrlArr addObject:urlArr[0]];
        }
            break;
        case 2:
            imgW = (wid-4)/2;
            self.imgH.constant = imgW+20;
            self.imgView1.frame = CGRectMake(0, 10, imgW, imgW);
            self.imgView2.frame = CGRectMake(imgW+4, 10, imgW, imgW);
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            self.imgView3.frame = CGRectZero;
            self.imgView4.frame = CGRectZero;
            self.imgView5.frame = CGRectZero;
            self.imgView6.frame = CGRectZero;
            [self.imageViewArr addObject:self.imgView1];
            [self.imageViewArr addObject:self.imgView2];
            [self.imageUrlArr addObject:urlArr[0]];
            [self.imageUrlArr addObject:urlArr[1]];
            break;
        case 3:
            imgW = (wid-8)/3;
            self.imgH.constant = imgW+20;
            self.imgView1.frame = CGRectMake(0, 10, imgW, imgW);
            self.imgView2.frame = CGRectMake(imgW+4, 10, imgW, imgW);
            self.imgView3.frame = CGRectMake(imgW*2+8, 10, imgW, imgW);
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:urlArr[2]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            self.imgView4.frame = CGRectZero;
            self.imgView5.frame = CGRectZero;
            self.imgView6.frame = CGRectZero;
            [self.imageViewArr addObject:self.imgView1];
            [self.imageViewArr addObject:self.imgView2];
            [self.imageViewArr addObject:self.imgView3];
            [self.imageUrlArr addObject:urlArr[0]];
            [self.imageUrlArr addObject:urlArr[1]];
            [self.imageUrlArr addObject:urlArr[2]];
            break;
        case 4:
            imgW = (wid-4)/2;
            self.imgH.constant = imgW*2+24;
            self.imgView1.frame = CGRectMake(0, 10, imgW, imgW);
            self.imgView2.frame = CGRectMake(imgW+4, 10, imgW, imgW);
            self.imgView3.frame = CGRectMake(0, imgW+14, imgW, imgW);
            self.imgView4.frame = CGRectMake(imgW+4, imgW+14, imgW, imgW);
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:urlArr[2]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView4 sd_setImageWithURL:[NSURL URLWithString:urlArr[3]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            self.imgView5.frame = CGRectZero;
            self.imgView6.frame = CGRectZero;
            self.imgView7.frame = CGRectZero;
            self.imgView8.frame = CGRectZero;
            self.imgView9.frame = CGRectZero;
            [self.imageViewArr addObject:self.imgView1];
            [self.imageViewArr addObject:self.imgView2];
            [self.imageViewArr addObject:self.imgView3];
            [self.imageViewArr addObject:self.imgView4];
            [self.imageUrlArr addObject:urlArr[0]];
            [self.imageUrlArr addObject:urlArr[1]];
            [self.imageUrlArr addObject:urlArr[2]];
            [self.imageUrlArr addObject:urlArr[3]];
            break;
        case 5:
            imgW = (wid-8)/3;
            self.imgH.constant = imgW*2+24;
            self.imgView1.frame = CGRectMake(0, 10, imgW, imgW);
            self.imgView2.frame = CGRectMake(imgW+4, 10, imgW, imgW);
            self.imgView3.frame = CGRectMake(imgW*2+8, 10, imgW, imgW);
            self.imgView4.frame = CGRectMake(0, imgW+14, imgW, imgW);
            self.imgView5.frame = CGRectMake(imgW+4, imgW+14, imgW, imgW);
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:urlArr[2]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView4 sd_setImageWithURL:[NSURL URLWithString:urlArr[3]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView5 sd_setImageWithURL:[NSURL URLWithString:urlArr[4]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            self.imgView6.frame = CGRectZero;
            self.imgView7.frame = CGRectZero;
            self.imgView8.frame = CGRectZero;
            self.imgView9.frame = CGRectZero;
            [self.imageViewArr addObject:self.imgView1];
            [self.imageViewArr addObject:self.imgView2];
            [self.imageViewArr addObject:self.imgView3];
            [self.imageViewArr addObject:self.imgView4];
            [self.imageViewArr addObject:self.imgView5];
            [self.imageUrlArr addObject:urlArr[0]];
            [self.imageUrlArr addObject:urlArr[1]];
            [self.imageUrlArr addObject:urlArr[2]];
            [self.imageUrlArr addObject:urlArr[3]];
            [self.imageUrlArr addObject:urlArr[4]];
            break;
        case 6:
            imgW = (wid-8)/3;
            self.imgH.constant = imgW*2+24;
            self.imgView1.frame = CGRectMake(0, 10, imgW, imgW);
            self.imgView2.frame = CGRectMake(imgW+4, 10, imgW, imgW);
            self.imgView3.frame = CGRectMake(imgW*2+8, 10, imgW, imgW);
            self.imgView4.frame = CGRectMake(0, imgW+14, imgW, imgW);
            self.imgView5.frame = CGRectMake(imgW+4, imgW+14, imgW, imgW);
            self.imgView6.frame = CGRectMake(imgW*2+8, imgW+14, imgW, imgW);
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:urlArr[2]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView4 sd_setImageWithURL:[NSURL URLWithString:urlArr[3]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView5 sd_setImageWithURL:[NSURL URLWithString:urlArr[4]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView6 sd_setImageWithURL:[NSURL URLWithString:urlArr[5]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            self.imgView7.frame = CGRectZero;
            self.imgView8.frame = CGRectZero;
            self.imgView9.frame = CGRectZero;
            [self.imageViewArr addObject:self.imgView1];
            [self.imageViewArr addObject:self.imgView2];
            [self.imageViewArr addObject:self.imgView3];
            [self.imageViewArr addObject:self.imgView4];
            [self.imageViewArr addObject:self.imgView5];
            [self.imageViewArr addObject:self.imgView6];
            [self.imageUrlArr addObject:urlArr[0]];
            [self.imageUrlArr addObject:urlArr[1]];
            [self.imageUrlArr addObject:urlArr[2]];
            [self.imageUrlArr addObject:urlArr[3]];
            [self.imageUrlArr addObject:urlArr[4]];
            [self.imageUrlArr addObject:urlArr[5]];
            break;
        case 7:
            imgW = (wid-8)/3;
            self.imgH.constant = imgW*3+28;
            self.imgView1.frame = CGRectMake(0, 10, imgW, imgW);
            self.imgView2.frame = CGRectMake(imgW+4, 10, imgW, imgW);
            self.imgView3.frame = CGRectMake(imgW*2+8, 10, imgW, imgW);
            self.imgView4.frame = CGRectMake(0, imgW+14, imgW, imgW);
            self.imgView5.frame = CGRectMake(imgW+4, imgW+14, imgW, imgW);
            self.imgView6.frame = CGRectMake(imgW*2+8, imgW+14, imgW, imgW);
            self.imgView7.frame = CGRectMake(0, imgW*2+18, imgW, imgW);
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:urlArr[2]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView4 sd_setImageWithURL:[NSURL URLWithString:urlArr[3]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView5 sd_setImageWithURL:[NSURL URLWithString:urlArr[4]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView6 sd_setImageWithURL:[NSURL URLWithString:urlArr[5]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView7 sd_setImageWithURL:[NSURL URLWithString:urlArr[6]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            self.imgView8.frame = CGRectZero;
            self.imgView9.frame = CGRectZero;
            [self.imageViewArr addObject:self.imgView1];
            [self.imageViewArr addObject:self.imgView2];
            [self.imageViewArr addObject:self.imgView3];
            [self.imageViewArr addObject:self.imgView4];
            [self.imageViewArr addObject:self.imgView5];
            [self.imageViewArr addObject:self.imgView6];
            [self.imageViewArr addObject:self.imgView7];
            [self.imageUrlArr addObject:urlArr[0]];
            [self.imageUrlArr addObject:urlArr[1]];
            [self.imageUrlArr addObject:urlArr[2]];
            [self.imageUrlArr addObject:urlArr[3]];
            [self.imageUrlArr addObject:urlArr[4]];
            [self.imageUrlArr addObject:urlArr[5]];
            [self.imageUrlArr addObject:urlArr[6]];
            break;
        case 8:
            imgW = (wid-8)/3;
            self.imgH.constant = imgW*3+28;
            self.imgView1.frame = CGRectMake(0, 10, imgW, imgW);
            self.imgView2.frame = CGRectMake(imgW+4, 10, imgW, imgW);
            self.imgView3.frame = CGRectMake(imgW*2+8, 10, imgW, imgW);
            self.imgView4.frame = CGRectMake(0, imgW+14, imgW, imgW);
            self.imgView5.frame = CGRectMake(imgW+4, imgW+14, imgW, imgW);
            self.imgView6.frame = CGRectMake(imgW*2+8, imgW+14, imgW, imgW);
            self.imgView7.frame = CGRectMake(0, imgW*2+18, imgW, imgW);
            self.imgView8.frame = CGRectMake(imgW+4, imgW*2+18, imgW, imgW);
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:urlArr[2]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView4 sd_setImageWithURL:[NSURL URLWithString:urlArr[3]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView5 sd_setImageWithURL:[NSURL URLWithString:urlArr[4]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView6 sd_setImageWithURL:[NSURL URLWithString:urlArr[5]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView7 sd_setImageWithURL:[NSURL URLWithString:urlArr[6]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView8 sd_setImageWithURL:[NSURL URLWithString:urlArr[7]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            self.imgView9.frame = CGRectZero;
            [self.imageViewArr addObject:self.imgView1];
            [self.imageViewArr addObject:self.imgView2];
            [self.imageViewArr addObject:self.imgView3];
            [self.imageViewArr addObject:self.imgView4];
            [self.imageViewArr addObject:self.imgView5];
            [self.imageViewArr addObject:self.imgView6];
            [self.imageViewArr addObject:self.imgView7];
            [self.imageViewArr addObject:self.imgView8];
            [self.imageUrlArr addObject:urlArr[0]];
            [self.imageUrlArr addObject:urlArr[1]];
            [self.imageUrlArr addObject:urlArr[2]];
            [self.imageUrlArr addObject:urlArr[3]];
            [self.imageUrlArr addObject:urlArr[4]];
            [self.imageUrlArr addObject:urlArr[5]];
            [self.imageUrlArr addObject:urlArr[6]];
            [self.imageUrlArr addObject:urlArr[7]];
            break;
        case 9:
            imgW = (wid-8)/3;
            self.imgH.constant = imgW*3+28;
            self.imgView1.frame = CGRectMake(0, 10, imgW, imgW);
            self.imgView2.frame = CGRectMake(imgW+4, 10, imgW, imgW);
            self.imgView3.frame = CGRectMake(imgW*2+8, 10, imgW, imgW);
            self.imgView4.frame = CGRectMake(0, imgW+14, imgW, imgW);
            self.imgView5.frame = CGRectMake(imgW+4, imgW+14, imgW, imgW);
            self.imgView6.frame = CGRectMake(imgW*2+8, imgW+14, imgW, imgW);
            self.imgView7.frame = CGRectMake(0, imgW*2+18, imgW, imgW);
            self.imgView8.frame = CGRectMake(imgW+4, imgW*2+18, imgW, imgW);
            self.imgView9.frame = CGRectMake(imgW*2+8, imgW*2+18, imgW, imgW);
            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:urlArr[2]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView4 sd_setImageWithURL:[NSURL URLWithString:urlArr[3]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView5 sd_setImageWithURL:[NSURL URLWithString:urlArr[4]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView6 sd_setImageWithURL:[NSURL URLWithString:urlArr[5]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView7 sd_setImageWithURL:[NSURL URLWithString:urlArr[6]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView8 sd_setImageWithURL:[NSURL URLWithString:urlArr[7]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imgView9 sd_setImageWithURL:[NSURL URLWithString:urlArr[8]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            [self.imageViewArr addObject:self.imgView1];
            [self.imageViewArr addObject:self.imgView2];
            [self.imageViewArr addObject:self.imgView3];
            [self.imageViewArr addObject:self.imgView4];
            [self.imageViewArr addObject:self.imgView5];
            [self.imageViewArr addObject:self.imgView6];
            [self.imageViewArr addObject:self.imgView7];
            [self.imageViewArr addObject:self.imgView8];
            [self.imageViewArr addObject:self.imgView9];
            [self.imageUrlArr addObject:urlArr[0]];
            [self.imageUrlArr addObject:urlArr[1]];
            [self.imageUrlArr addObject:urlArr[2]];
            [self.imageUrlArr addObject:urlArr[3]];
            [self.imageUrlArr addObject:urlArr[4]];
            [self.imageUrlArr addObject:urlArr[5]];
            [self.imageUrlArr addObject:urlArr[6]];
            [self.imageUrlArr addObject:urlArr[7]];
            [self.imageUrlArr addObject:urlArr[8]];
            break;
    }
}

- (NSMutableArray *)imageViewArr {
    if (_imageViewArr == nil) {
        _imageViewArr = [NSMutableArray array];
    }
    return _imageViewArr;
}

- (NSMutableArray *)imageUrlArr {
    if (_imageUrlArr == nil) {
        _imageUrlArr = [NSMutableArray array];
    }
    return _imageUrlArr;
}

@end
