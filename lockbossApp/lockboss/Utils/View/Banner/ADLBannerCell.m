//
//  ADLBannerCell.m
//  lockboss
//
//  Created by Adel on 2019/11/13.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBannerCell.h"

@implementation ADLBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
        self.imgView = imgView;
    }
    return self;
}

@end
