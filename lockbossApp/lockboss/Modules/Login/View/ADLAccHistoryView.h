//
//  ADLAccHistoryView.h
//  lockboss
//
//  Created by Adel on 2019/9/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLAccHistoryView : UIView

+ (instancetype)showWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr phone:(BOOL)phone finish:(void (^)(NSString *account, NSArray *history))finish;

@end
