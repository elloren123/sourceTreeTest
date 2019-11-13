//
//  ADLAnnotationView.h
//  lockboss
//
//  Created by adel on 2019/7/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface ADLAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIView *calloutView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *distanceLab;

@end
