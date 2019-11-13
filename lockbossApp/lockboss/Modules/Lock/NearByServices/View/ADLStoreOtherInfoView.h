//
//  ADLStoreOtherInfoView.h
//  lockboss
//
//  Created by bailun91 on 2019/10/15.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLStoreOtherInfoView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;//厨房照片imgV
@property (nonatomic, strong) NSMutableArray   *imgUrlArr;
@property (nonatomic, strong) UILabel     *workTimeLab; //营业时间Label
@property (nonatomic, strong) UIImageView *licenseImgV; //营业执照imgV

@end

NS_ASSUME_NONNULL_END
