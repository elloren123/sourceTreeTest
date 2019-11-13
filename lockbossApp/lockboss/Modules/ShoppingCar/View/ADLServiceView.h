//
//  ADLServiceView.h
//  lockboss
//
//  Created by adel on 2019/5/21.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLServiceView : UIView

+ (instancetype)serviceViewWithServiceArr:(NSArray *)serviceArr
                                selectStr:(NSString *)selectStr
                            confirmAction:(void (^)(NSMutableDictionary *selectDict))confirmAction;

- (instancetype)initWithFrame:(CGRect)frame
                   serviceArr:(NSArray *)serviceArr
                    selectStr:(NSString *)selectStr
                confirmAction:(void (^)(NSMutableDictionary *selectDict))confirmAction;

@end

