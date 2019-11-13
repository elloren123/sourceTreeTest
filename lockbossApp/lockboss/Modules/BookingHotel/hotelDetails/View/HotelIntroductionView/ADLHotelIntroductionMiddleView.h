//
//  ADLHotelIntroductionMiddleView.h
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLBookingHotelModel;

@interface ADLHotelIntroductionMiddleView : UIView
@property (nonatomic ,strong)ADLBookingHotelModel *model;
@property (nonatomic ,strong)NSMutableArray *imageArray;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@end


