//
//  ADLSearchCityResultView.h
//  lockboss
//
//  Created by adel on 2019/6/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSearchCityResultView : UIView

- (void)updateDataArray:(NSArray *)dataArr;

- (void)resetDataArray;

@property (nonatomic, copy) void (^willBeginDragging) (void);

@property (nonatomic, copy) void (^clickCity) (NSDictionary *dict);

@end
