//
//  ADLDeleteImageCell.h
//  lockboss
//
//  Created by adel on 2019/6/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLDeleteImageCellDelegate <NSObject>

- (void)didClickDeleteBtn:(UIButton *)sender;

@end

@interface ADLDeleteImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, weak) id<ADLDeleteImageCellDelegate> delegate;

@end
