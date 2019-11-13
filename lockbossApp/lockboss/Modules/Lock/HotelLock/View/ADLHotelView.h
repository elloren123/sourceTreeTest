//
//  ADLHotelView.h
//  lockboss
//
//  Created by Adel on 2019/8/27.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADLDeviceModel;
@class ADLHotelServiceModel;
@class ADLGuestRoomsModel;
NS_ASSUME_NONNULL_BEGIN

@protocol ADLHotelViewDelegate <NSObject>

@optional
-(void)bannelImgClickWith:(NSString *)urlString; //广告图点击

-(void)moreHotelRoomsDeivicesWithcheckingInId:(NSString *)checkingInId;//酒店设备,更多操作

-(void)deviceClickWith:(ADLDeviceModel *)deviceModel checkID:(NSString *)checkingInId;//点击某个设备,非433

-(void)deviceFTTClick;//点击433设备

-(void)moreHotelRoomsServicesWithcheckingInId:(ADLGuestRoomsModel *)model;//酒店服务,更多操作

-(void)serviceClickWith:(ADLHotelServiceModel *)serviceModel guestRoomsModel:(ADLGuestRoomsModel *)model;//点击某项服务

-(void)roomCellClick;//入住的房间点击

@end



@interface ADLHotelView : UIView

@property (nonatomic, weak) id<ADLHotelViewDelegate> delegate;

-(void)selectHotel;

@end

NS_ASSUME_NONNULL_END
