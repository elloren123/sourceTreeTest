//
//  ADLScreeningStarView.h
//  lockboss
//
//  Created by adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//     
#import <UIKit/UIKit.h>

@interface ADLScreeningStarView : UIView
@property (nonatomic, copy) void (^screeningStarBlock) (NSString *price,NSString *price1,NSString *star);
- (void)remove;
@end

