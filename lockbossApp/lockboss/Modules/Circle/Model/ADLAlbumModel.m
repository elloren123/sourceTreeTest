//
//  ADLAlbumModel.m
//  lockboss
//
//  Created by adel on 2019/6/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAlbumModel.h"

@implementation ADLAlbumModel

- (void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    self.albumTitle = collection.localizedTitle;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
    self.imageNumber = assetResult.count;
    self.assets = assetResult;
    
    if (assetResult.count > 0) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        __weak typeof(self) weakSelf = self;
        [[PHCachingImageManager defaultManager] requestImageForAsset:assetResult.firstObject targetSize:CGSizeMake(screenW/3, screenW/3) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakSelf.image = result;
        }];
    }
}

@end
