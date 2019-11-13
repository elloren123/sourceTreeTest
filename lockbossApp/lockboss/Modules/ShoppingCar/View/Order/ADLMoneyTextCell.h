//
//  ADLMoneyTextCell.h
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLMoneyTextCell : UITableViewCell

@property (nonatomic, strong) UILabel *titLab;

@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, strong) UIView *spView;

@property (nonatomic, assign) CGFloat leftMargin;

@property (nonatomic, assign) BOOL top;

@end
