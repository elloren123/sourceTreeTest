//
//  ADLAutoresizeLabelFlowConfig.m
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAutoresizeLabelFlowConfig.h"

@implementation ADLAutoresizeLabelFlowConfig

+ (ADLAutoresizeLabelFlowConfig *)shareConfig {
    static ADLAutoresizeLabelFlowConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc]init];
    });
    return config;
}

// default

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(10, 10, 10, 2);
        self.lineSpace = 10;
        self.itemHeight = 25;
        self.itemSpace = 10;
        self.itemCornerRaius = 3;
        self.itemColor = [UIColor clearColor];
        self.itemSelectedColor = [UIColor colorWithRed:231/255.0 green:33/255.0 blue:25/255.0 alpha:1.0];
        self.textMargin = 20;
        self.textColor = [UIColor darkGrayColor];
        self.textSelectedColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:15];
        self.backgroundColor = [UIColor whiteColor];
        self.sectionHeight = 40;
    }
    return self;
}

@end


