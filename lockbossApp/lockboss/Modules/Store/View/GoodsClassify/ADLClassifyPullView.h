//
//  ADLClassifyPullView.h
//  lockboss
//
//  Created by adel on 2019/5/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLClassifyPullView : UIView

+ (instancetype)pullViewWithFrameY:(CGFloat)frameY
                           dataArr:(NSArray *)dataArr
                     confirmAction:(void(^)(NSString *brandId, NSString *classifyId, NSString *proValueId))confirmAction;

- (instancetype)initWithFrame:(CGRect)frame
                      dataArr:(NSArray *)dataArr
                confirmAction:(void(^)(NSString *brandId, NSString *classifyId, NSString *proValueId))confirmAction;

@end
