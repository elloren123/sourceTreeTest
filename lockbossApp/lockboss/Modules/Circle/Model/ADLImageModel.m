//
//  ADLImageModel.m
//  lockboss
//
//  Created by adel on 2019/6/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLImageModel.h"
#import "ADLGlobalDefine.h"

@implementation ADLImageModel

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    CGSize imageSize = CGSizeMake(floor(SCREEN_WIDTH/3.0), floor(SCREEN_WIDTH/3.0));
    if (SCREEN_WIDTH > 500) {
        imageSize = CGSizeMake(floor(SCREEN_WIDTH/7.0), floor(SCREEN_WIDTH/7.0));
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    __weak typeof(self) weakSelf = self;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.image = result;
    }];
}

@end
