//
//  ADLAttributeFlowLayout.m
//  lockboss
//
//  Created by adel on 2019/5/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAttributeFlowLayout.h"

@implementation ADLAttributeFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *superAttrArr = [super layoutAttributesForElementsInRect:rect];
    NSArray *layoutArr = [[NSArray alloc] initWithArray:superAttrArr copyItems:YES];
    NSMutableArray *tempAttrArr = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < layoutArr.count; index++) {
        UICollectionViewLayoutAttributes *currentAttr = layoutArr[index];
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutArr[index-1];
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutArr.count ?
        nil : layoutArr[index+1];
        [tempAttrArr addObject:currentAttr];
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        if (currentY != previousY && currentY != nextY) {
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] || [currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
                [tempAttrArr removeAllObjects];
            } else {
                [self setItemFrameWith:tempAttrArr];
            }
        } else if ( currentY != nextY) {
            [self setItemFrameWith:tempAttrArr];
        } else {}
    }
    return layoutArr;
}

- (void)setItemFrameWith:(NSMutableArray *)attributesArr {
    CGFloat nowWidth = self.sectionInset.left;
    for (UICollectionViewLayoutAttributes * attributes in attributesArr) {
        CGRect nowFrame = attributes.frame;
        nowFrame.origin.x = nowWidth;
        attributes.frame = nowFrame;
        nowWidth += nowFrame.size.width + self.minimumInteritemSpacing;
    }
    [attributesArr removeAllObjects];
}

@end
