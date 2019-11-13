//
//  ADLFSharedPersonCell.m
//  lockboss
//
//  Created by Adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFSharedPersonCell.h"

@implementation ADLFSharedPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shadowView.layer.cornerRadius = 5;
    self.shadowView.layer.shadowRadius = 3;
    self.shadowView.layer.shadowOpacity = 0.2;
    self.shadowView.layer.shadowOffset = CGSizeZero;
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
}

@end
