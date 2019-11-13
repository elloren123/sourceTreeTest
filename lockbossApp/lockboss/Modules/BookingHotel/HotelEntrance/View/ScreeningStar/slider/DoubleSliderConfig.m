//
//  DoubleSliderConfig.m
//  DoubleSlider
//
//  Created by huangjian on 2019/6/26.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "DoubleSliderConfig.h"

@implementation DoubleSliderConfig

-(instancetype)init
{
    if (self=[super init]) {
        self.leftLineColor = COLOR_E0212A;
        self.middleLineColor = COLOR_E0212A;
        self.rightLineColor = COLOR_E0212A;
        self.sliderSize = CGSizeMake(20, 20);
        self.leftSliderColor =[UIColor whiteColor];
        self.rightSliderColor = [UIColor whiteColor];
        self.lineHeight = 5;
        self.sliderOffsetY = 0;
//        self.minValue = 0;
//        self.maxValue = 2000;
        self.defaultLeftValue = self.minValue;
        self.defaultRightValue = self.maxValue;

    }
    return self;
}

@end
