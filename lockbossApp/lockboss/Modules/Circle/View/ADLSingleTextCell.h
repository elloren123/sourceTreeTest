//
//  ADLSingleTextCell.h
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSingleTextCell : UITableViewCell

@property (nonatomic, strong) UILabel *titLab;

@property (nonatomic, strong) UIView *spView;

@property (nonatomic, assign) CGFloat leftMargin;

@property (nonatomic, assign) BOOL top;

@end
