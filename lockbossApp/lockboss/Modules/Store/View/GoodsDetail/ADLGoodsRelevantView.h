//
//  ADLGoodsRelevantView.h
//  lockboss
//
//  Created by adel on 2019/7/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLGoodsRelevantView : UIView

@property (nonatomic, strong) NSArray *relevantArr;

@property (nonatomic, strong) NSMutableArray *relevantHArr;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) void (^clickRelevantGoods) (NSString *goodsId);

@end
