//
//  ADLScreeningroomView.h
//  lockboss
//
//  Created by adel on 2019/9/24.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class ADLScreeningroomView;
@protocol  ADLScreeningroomViewDelegate <NSObject>

- (void)screeningroomView :(ADLScreeningroomView *)screeningroomView array:(NSMutableArray *)arrray iphone:(UIButton *)btn;

@end

@interface ADLScreeningroomView : UIView
-(instancetype)initWithFrame:(CGRect)frame navigheight:(CGFloat)navigheight;
@property (nonatomic,weak)id<ADLScreeningroomViewDelegate>deldgate;
@property (nonatomic ,strong)NSMutableArray *nameArray;
@end

NS_ASSUME_NONNULL_END
