//
//  ADLHotelDetailsHeadView.h
//  lockboss
//
//  Created by adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLHotelDetailsHeadView,ADLBookingHotelModel;
@protocol  ADLHotelDetailsHeadViewDelegate <NSObject>

- (void)htelDetailsHeadView :(ADLHotelDetailsHeadView *)ListsortingView  didSelectRowAtIndexPath:(UIButton *)btn;

@end
@interface ADLHotelDetailsHeadView : UIView
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,strong)ADLBookingHotelModel *model;
@property (nonatomic ,weak)id<ADLHotelDetailsHeadViewDelegate>delegate;
@property (nonatomic ,strong)UILabel *stay;
@property (nonatomic ,strong)UILabel *leave;
@property (nonatomic ,strong)UIButton *numDateBtn;//天数
@end


