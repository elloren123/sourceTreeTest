//
//  ADLStoreHeaderView.h
//  lockboss
//
//  Created by adel on 2019/4/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLStoreHeaderViewDelegate <NSObject>

- (void)didClickBannerView:(NSString *)urlStr;

- (void)didClickHeadView:(NSInteger)tag;

@end

@interface ADLStoreHeaderView : UIView

+ (instancetype)headViewWithImageArr:(NSArray *)imgArr titleArr:(NSArray *)titleArr title:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame imageArr:(NSArray *)imgArr titleArr:(NSArray *)titleArr title:(NSString *)title;

- (void)updateBanner:(NSArray *)bannerArr dataArr:(NSArray *)dataArr;

@property (nonatomic, weak) id<ADLStoreHeaderViewDelegate> delegate;

@end

