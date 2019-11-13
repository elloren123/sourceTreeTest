//
//  ADLHotelListHeadView.h
//  lockboss
//
//  Created by adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ADLHotelListHeadView : UIView
@property (nonatomic,strong)NSArray *array;
@property (nonatomic ,copy)void(^blockBtn)(UIButton *btn);
@end


