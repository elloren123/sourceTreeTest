//
//  ADLHomeCellView.h
//  lockboss
//
//  Created by adel on 2019/3/29.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLHomeCellViewDelegate <NSObject>

- (void)didClickCellAtIndex:(NSInteger)index;

@end

@interface ADLHomeCellView : UIView

+ (instancetype)cellViewWithFrame:(CGRect)frame gap:(CGFloat)gap cellW:(CGFloat)cellW;

- (instancetype)initWithFrame:(CGRect)frame gap:(CGFloat)gap cellW:(CGFloat)cellW;

@property (nonatomic, weak) id<ADLHomeCellViewDelegate> delegate;

@end
