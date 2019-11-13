//
//  ADLStoreOtherInfoView.m
//  lockboss
//
//  Created by bailun91 on 2019/10/15.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLStoreOtherInfoView.h"
#import "ADLLocalImgPreView.h"
#import "ADLDeleteImageCell.h"
#import <UIImageView+WebCache.h>

@implementation ADLStoreOtherInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    UILabel *weiSheng = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH/2, 40)];
    weiSheng.textAlignment = NSTextAlignmentLeft;
    weiSheng.font = [UIFont systemFontOfSize:14];
    weiSheng.textColor = [UIColor darkGrayColor];
    weiSheng.text = @"商家服务";
    [self addSubview:weiSheng];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(84, 84);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 4;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 36, SCREEN_WIDTH-24, 84) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLDeleteImageCell class] forCellWithReuseIdentifier:@"ADLDeleteImageCell"];
    
    
    
    UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 3)];
    gapView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:gapView];
    
    
    
    UILabel *workLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 128, SCREEN_WIDTH/2, 40)];
    workLab.textAlignment = NSTextAlignmentLeft;
    workLab.font = [UIFont systemFontOfSize:14];
    workLab.textColor = [UIColor darkGrayColor];
    workLab.text = @"营业时间";
    [self addSubview:workLab];
    
    UILabel *workTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3-15, 128, SCREEN_WIDTH*2/3, 40)];
    workTimeLab.textAlignment = NSTextAlignmentRight;
    workTimeLab.font = [UIFont systemFontOfSize:14];
    workTimeLab.textColor = COLOR_E0212A;
//    workTimeLab.text = @"周一至周日 08:00-23:00";
    [self addSubview:workTimeLab];
    self.workTimeLab = workTimeLab;
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 167, SCREEN_WIDTH, 1)];
    line.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:line];


    
    UILabel *lisense = [[UILabel alloc] initWithFrame:CGRectMake(15, 168, SCREEN_WIDTH/2, 40)];
    lisense.textAlignment = NSTextAlignmentLeft;
    lisense.font = [UIFont systemFontOfSize:14];
    lisense.textColor = [UIColor darkGrayColor];
    lisense.text = @"营业许可资质";
    [self addSubview:lisense];
    
    UIImageView *cardImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 206, 100, 100)];
    cardImgV.image = [UIImage imageNamed:@"icon_kong-1"];
    cardImgV.userInteractionEnabled = YES;
    [self addSubview:cardImgV];
    self.licenseImgV = cardImgV;
    
    UITapGestureRecognizer *licenseImgVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(licenseImageViewTap)];
    [cardImgV addGestureRecognizer:licenseImgVTap];
}

- (void)licenseImageViewTap {
    NSMutableArray *imgViewArr = [[NSMutableArray alloc] init];
    [imgViewArr addObject:self.licenseImgV];
    [ADLLocalImgPreView showWithImageViews:imgViewArr currentIndex:0];
}



#pragma mark ------ UICollectionView ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgUrlArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLDeleteImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADLDeleteImageCell" forIndexPath:indexPath];
    cell.deleteBtn.hidden = YES;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrlArr[indexPath.item]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *imgViewArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.imgUrlArr.count; i++) {
        ADLDeleteImageCell *cell = (ADLDeleteImageCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [imgViewArr addObject:cell.imgView];
    }
    [ADLLocalImgPreView showWithImageViews:imgViewArr currentIndex:indexPath.item];
}

@end
