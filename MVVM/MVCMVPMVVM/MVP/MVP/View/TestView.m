//
//  TestView.m
//  MVP
//
//  Created by 一米阳光 on 2017/11/16.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "TestView.h"

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
    }
    return self;
}

@end
