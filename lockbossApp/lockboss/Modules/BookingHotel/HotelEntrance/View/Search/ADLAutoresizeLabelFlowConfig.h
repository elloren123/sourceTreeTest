//
//  ADLAutoresizeLabelFlowConfig.h
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ADLAutoresizeLabelFlowConfig : NSObject

+ (ADLAutoresizeLabelFlowConfig *)  shareConfig;

@property (nonatomic) UIEdgeInsets  contentInsets;
@property (nonatomic) CGFloat       textMargin;
@property (nonatomic) CGFloat       lineSpace;
@property (nonatomic) CGFloat       sectionHeight;
@property (nonatomic) CGFloat       itemHeight;
@property (nonatomic) CGFloat       itemSpace;
@property (nonatomic) CGFloat       itemCornerRaius;
@property (nonatomic) UIColor       *itemColor;
@property (nonatomic) UIColor       *itemSelectedColor;
@property (nonatomic) UIColor       *textColor;
@property (nonatomic) UIColor       *textSelectedColor;
@property (nonatomic) UIFont        *textFont;
@property (nonatomic) UIColor       *backgroundColor;

@end
