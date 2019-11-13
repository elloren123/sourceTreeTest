//
//  ADLFamilyView.h
//  lockboss
//
//  Created by Adel on 2019/8/27.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLDeviceModel;

@protocol ADLFamilyViewDelegate <NSObject>

@optional

- (void)didClickLockItem:(NSInteger)index;

- (void)updateFamilyTitle:(NSString *)title;

- (void)refreshUserPattern;

- (void)goAllUserDeviceVC;//进入更多界面

@end

@interface ADLFamilyView : UIView

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, weak) id<ADLFamilyViewDelegate> delegate;

@property (nonatomic, strong) ADLDeviceModel *model;

@property (nonatomic ,assign)BOOL isFTT;//是否433系列,判断权重高于checkingInId;

@property (nonatomic ,strong) NSString *checkingInId;//如果有,则是酒店,请求酒店数据,没有传0,代表非酒店

- (void)updateDeviceData;

@end
