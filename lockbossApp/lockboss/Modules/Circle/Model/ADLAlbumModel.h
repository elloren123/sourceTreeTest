//
//  ADLAlbumModel.h
//  lockboss
//
//  Created by adel on 2019/6/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ADLAlbumModel : NSObject

///相册
@property (nonatomic, strong) PHAssetCollection *collection;

///第一张图片
@property (nonatomic, strong) UIImage *image;

///相册图片
@property (nonatomic, strong) PHFetchResult *assets;

///相册名称
@property (nonatomic, strong) NSString *albumTitle;

/// 总数
@property (nonatomic, assign) NSInteger imageNumber;

@end
