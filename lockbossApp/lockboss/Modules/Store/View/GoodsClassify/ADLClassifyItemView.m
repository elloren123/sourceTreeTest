//
//  ADLClassifyItemView.m
//  lockboss
//
//  Created by adel on 2019/5/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLClassifyItemView.h"

@implementation ADLClassifyItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1].CGColor;
}

@end
