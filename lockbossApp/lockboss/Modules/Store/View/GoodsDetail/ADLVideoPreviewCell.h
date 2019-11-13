//
//  ADLVideoPreviewCell.h
//  lockboss
//
//  Created by adel on 2019/7/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLVideoPreviewCellDelegate <NSObject>

- (void)didClickVideoPreView;

@end

@interface ADLVideoPreviewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UILabel *durationLab;

@property (nonatomic, assign) CGSize imgSize;

@property (nonatomic, weak) id<ADLVideoPreviewCellDelegate> delegate;

@end
