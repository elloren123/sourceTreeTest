//
//  ADLSearchFakeView.h
//  lockboss
//
//  Created by Han on 2019/5/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSearchFakeView : UIView

+ (instancetype)searchFakeViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

@property (nonatomic, copy) void (^clickSearch) (void);

@end
