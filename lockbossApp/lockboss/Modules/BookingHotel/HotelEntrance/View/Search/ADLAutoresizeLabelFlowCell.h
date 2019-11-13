//
//  ADLAutoresizeLabelFlowCell.h
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLAutoresizeLabelFlowCell : UICollectionViewCell
/** 是否选中 */
@property (nonatomic, assign) BOOL beSelected;

- (void)configCellWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
