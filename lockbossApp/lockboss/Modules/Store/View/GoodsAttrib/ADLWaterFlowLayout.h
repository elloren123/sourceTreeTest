//
//  ADLWaterFlowLayout.h
//  lockboss
//
//  Created by adel on 2019/5/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ADLWaterFlowLayoutDelegate <NSObject>

@optional

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForHeaderViewInSection:(NSInteger)section;

- (CGSize)sizeForFooterViewInSection:(NSInteger)section;

@end

@interface ADLWaterFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<ADLWaterFlowLayoutDelegate> delegate;

@property (nonatomic, assign) NSInteger columnCount;

@end
