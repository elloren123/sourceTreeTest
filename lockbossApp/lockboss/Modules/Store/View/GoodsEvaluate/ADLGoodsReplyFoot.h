//
//  ADLGoodsReplyFoot.h
//  lockboss
//
//  Created by adel on 2019/7/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLGoodsReplyFootDelegate <NSObject>

- (void)didClickFoldLab:(UILabel *)sender;

@end

@interface ADLGoodsReplyFoot : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *foldLab;

@property (nonatomic, strong) UIImageView *foldImg;

@property (nonatomic, strong) UIView *spView;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, weak) id<ADLGoodsReplyFootDelegate> delegate;

@end
