//
//  ADLGoodsAddressView.h
//  lockboss
//
//  Created by adel on 2019/5/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLGoodsAddressView : UIView

+ (instancetype)addressViewWithArray:(NSMutableArray *)addressArr
                           addressId:(NSString *)addressId
                              finish:(void(^)(NSMutableDictionary *selectDict, BOOL addAddress))finish;

- (instancetype)initWithFrame:(CGRect)frame
                   addressArr:(NSMutableArray *)addressArr
                    addressId:(NSString *)addressId
                       finish:(void(^)(NSMutableDictionary *selectDict, BOOL addAddress))finish;

@end

