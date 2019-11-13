//
//  ADLEditImageController.h
//  lockboss
//
//  Created by Han on 2019/4/1.
//  Copyright © 2018年 Titanium. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLEditImageController : ADLBaseViewController
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL original;
@property (nonatomic, copy) void(^finishBlock) (UIImage *image);
@end
