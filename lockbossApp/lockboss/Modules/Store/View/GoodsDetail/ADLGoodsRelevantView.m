//
//  ADLGoodsRelevantView.m
//  lockboss
//
//  Created by adel on 2019/7/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsRelevantView.h"
#import <UIImageView+WebCache.h>
#import "ADLWaterFlowLayout.h"
#import "ADLGoodsRelevantCell.h"

@interface ADLGoodsRelevantView ()<UICollectionViewDelegate,UICollectionViewDataSource,ADLWaterFlowLayoutDelegate>

@end

@implementation ADLGoodsRelevantView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        ADLWaterFlowLayout *layout = [[ADLWaterFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 4;
        layout.minimumLineSpacing = 4;
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        layout.columnCount = 2;
        layout.delegate = self;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        self.collectionView = collectionView;
        [collectionView registerNib:[UINib nibWithNibName:@"ADLGoodsRelevantCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsRelevantCell"];
        [self addSubview:collectionView];
    }
    return self;
}

#pragma mark ------ UICollectionViewDelegate && DataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.relevantArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLGoodsRelevantCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsRelevantCell" forIndexPath:indexPath];
    NSDictionary *dict = self.relevantArr[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"goodsImg"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    cell.nameLab.text = dict[@"goodsName"];
    cell.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"advicePrice"] floatValue]];
    return cell;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width/2-10, [self.relevantHArr[indexPath.item] floatValue]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickRelevantGoods) {
        self.clickRelevantGoods(self.relevantArr[indexPath.item][@"goodsId"]);
    }
}

@end
