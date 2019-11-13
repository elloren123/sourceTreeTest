//
//  ADLNewUserView.h
//  lockboss
//
//  Created by adel on 2019/5/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLNewUserView : UIView

+ (instancetype)nerUserViewWithArr:(NSArray *)dataArr;

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr;

@end
