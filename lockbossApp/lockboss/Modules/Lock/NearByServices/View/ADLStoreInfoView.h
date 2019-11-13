//
//  ADLStoreInfoView.h
//  lockboss
//
//  Created by bailun91 on 2019/10/15.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLStoreInfoView : UIView

@property (nonatomic, strong) UIImageView   *storeImg;
@property (nonatomic, strong) UILabel       *storeName;
@property (nonatomic, strong) UILabel       *wsLabel;
@property (nonatomic, strong) UIImageView   *star1;
@property (nonatomic, strong) UIImageView   *star2;
@property (nonatomic, strong) UIImageView   *star3;
@property (nonatomic, strong) UIImageView   *star4;
@property (nonatomic, strong) UIImageView   *star5;
@property (nonatomic, strong) UILabel       *stoScore;
@property (nonatomic, strong) UILabel       *stoAddress;


- (void)updateStoreInfoView:(NSMutableDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
