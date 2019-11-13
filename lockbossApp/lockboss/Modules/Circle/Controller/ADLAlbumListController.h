//
//  ADLAlbumListController.h
//  lockboss
//
//  Created by Han on 2019/6/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLAlbumListController : ADLBaseViewController

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) NSInteger currentCount;

@property (nonatomic, copy) void (^finish) (NSArray *imageArr);

@end
