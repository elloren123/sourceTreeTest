//
//  ADLGoodsAttriView.h
//  lockboss
//
//  Created by adel on 2019/4/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLGoodsAttriView : UIView

+ (instancetype)goodsAttributeViewWith:(NSDictionary *)dataDict
                         confirmAction:(void (^)(NSMutableDictionary *selectDict))confirmAction;

@end
