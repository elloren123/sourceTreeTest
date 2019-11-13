//
//  ADLOrderDetailGoodsHeader.h
//  lockboss
//
//  Created by adel on 2019/7/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ADLOrderDetailHeaderDelegate <NSObject>

- (void)didClickLookLogisticsInformationBtn;

- (void)didClickLookLockerPathBtn;

@end

@interface ADLOrderDetailHeader : UIView

+ (instancetype)headerViewWithStatus:(NSInteger)status lockerDict:(NSDictionary *)lockerDict goods:(BOOL)goods;

@property (nonatomic, weak) id<ADLOrderDetailHeaderDelegate> delegate;

@end
