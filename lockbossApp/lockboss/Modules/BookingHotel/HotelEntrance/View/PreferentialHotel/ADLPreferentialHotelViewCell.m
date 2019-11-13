//
//  ADLPreferentialHotelViewCell.m
//  lockboss
//
//  Created by adel on 2019/9/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLPreferentialHotelViewCell.h"

@implementation ADLPreferentialHotelViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
 

        [self.contentView addSubview:self.hotelImage];
    }
    return self;
}

-(UIImageView *)hotelImage {
    if (!_hotelImage) {
        _hotelImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _hotelImage.backgroundColor = [UIColor redColor];
    }
    return _hotelImage;
}
@end
