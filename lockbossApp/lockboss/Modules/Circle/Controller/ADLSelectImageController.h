//
//  ADLSelectImageController.h
//  lockboss
//
//  Created by adel on 2019/6/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"
#import "ADLImageModel.h"

@interface ADLSelectImageController : ADLBaseViewController

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, strong) NSString *albumName;

@property (nonatomic, strong) PHFetchResult *assets;

@property (nonatomic, assign) NSInteger currentCount;

@property (nonatomic, copy) void (^finish) (NSArray *images);

@end

