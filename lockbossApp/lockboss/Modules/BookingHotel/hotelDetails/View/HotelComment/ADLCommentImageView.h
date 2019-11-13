//
//  ADLCommentImageView.h
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLCommentImageView : UIView

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *BigImagArra;
@property (nonatomic, strong) NSArray *smallImagArra;

@property (nonatomic, assign, getter=isOpen) BOOL isSmall;
//计算相册的尺寸
+ (CGSize)sizeWithCount:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
