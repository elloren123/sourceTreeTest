//
//  ADLWaterFlowLayout.m
//  lockboss
//
//  Created by adel on 2019/5/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLWaterFlowLayout.h"

@interface ADLWaterFlowLayout ()

@property (strong, nonatomic) NSMutableArray *attrsArray;
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, assign) CGFloat maxColumnHeight;

@end

@implementation ADLWaterFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.maxColumnHeight = 0;
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.sectionInset.top)];
    }
    [self.attrsArray removeAllObjects];
    
    NSInteger sectionCount =  [self.collectionView numberOfSections];
    for (int section = 0; section < sectionCount; section++){
        if(self.delegate && [self.delegate respondsToSelector:@selector(sizeForHeaderViewInSection:)]){
            UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attrsArray addObject:headerAttrs];
        }
        
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < rowCount; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attrs];
        }
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(sizeForFooterViewInSection:)]){
            UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attrsArray addObject:footerAttrs];
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self itemFrameOfVerticalWaterFlow:indexPath];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes;
    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        attributes.frame = [self headerViewFrameOfVerticalWaterFlow:indexPath];
    } else {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        attributes.frame = [self footerViewFrameOfVerticalWaterFlow:indexPath];
    }
    return attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.maxColumnHeight + self.sectionInset.bottom);
}

- (CGRect)itemFrameOfVerticalWaterFlow:(NSIndexPath *)indexPath {
    CGFloat collectionW = self.collectionView.frame.size.width;
    CGFloat w = (collectionW-self.sectionInset.left-self.sectionInset.right-(self.columnCount-1)*self.minimumInteritemSpacing)/self.columnCount;
    CGFloat h = [self.delegate sizeForItemAtIndexPath:indexPath].height;
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.sectionInset.left + destColumn * (w + self.minimumInteritemSpacing);
    CGFloat y = minColumnHeight;
    if (y != self.sectionInset.top) {
        y += self.minimumLineSpacing;
    }
    
    self.columnHeights[destColumn] = @(CGRectGetMaxY(CGRectMake(x, y, w, h)));
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.maxColumnHeight < columnHeight) {
        self.maxColumnHeight = columnHeight;
    }
    return CGRectMake(x, y, w, h);
}

- (CGRect)headerViewFrameOfVerticalWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForHeaderViewInSection:)]){
        size = [self.delegate sizeForHeaderViewInSection:indexPath.section];
    }
    
    CGFloat x = 0;
    CGFloat y = self.maxColumnHeight == 0 ? self.sectionInset.top : self.maxColumnHeight;
    if (![self.delegate respondsToSelector:@selector(sizeForFooterViewInSection:)] || [self.delegate sizeForFooterViewInSection:indexPath.section].height == 0) {
        y = self.maxColumnHeight == 0 ? self.sectionInset.top : self.maxColumnHeight + self.minimumLineSpacing;
    }
    self.maxColumnHeight = y + size.height;
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.maxColumnHeight)];
    }
    return CGRectMake(x , y, self.collectionView.frame.size.width, size.height);
}

- (CGRect)footerViewFrameOfVerticalWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForFooterViewInSection:)]){
        size = [self.delegate sizeForFooterViewInSection:indexPath.section];
    }
    
    CGFloat x = 0;
    CGFloat y = size.height == 0 ? self.maxColumnHeight : self.maxColumnHeight + self.minimumLineSpacing;
    self.maxColumnHeight = y + size.height;
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.maxColumnHeight)];
    }
    return CGRectMake(x , y, self.collectionView.frame.size.width, size.height);
}

#pragma mark ------ 懒加载 ------
- (NSMutableArray *)attrsArray {
    if (_attrsArray == nil) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeights {
    if (_columnHeights == nil) {
        _columnHeights = [[NSMutableArray alloc] init];
    }
    return _columnHeights;
}

@end
