//
//  ADLImageModel.h
//  lockboss
//
//  Created by adel on 2019/6/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ADLImageModel : NSObject

@property (nonatomic, assign) BOOL select;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) PHAsset *asset;

@end
