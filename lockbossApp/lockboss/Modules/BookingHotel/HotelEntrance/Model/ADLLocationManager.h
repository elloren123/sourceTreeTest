//
//  ADLLocationManager.h
//  lockboss
//
//  Created by adel on 2019/10/30.
//  Copyright © 2019 adel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ADLLocationManager;
@protocol ADLLocationManagerDelegate <NSObject>

-(void)locationManager:(ADLLocationManager *)locationManager didGotLocation:(NSString *)location;

@end

@interface ADLLocationManager : NSObject

@property (nonatomic, assign) id<ADLLocationManagerDelegate> delegate;

/**
 * 单例模式实例化对象
 */
+(ADLLocationManager *)sharedInstance;
/**
 * 开始定位
 */
-(void)autoLocate;
@end
