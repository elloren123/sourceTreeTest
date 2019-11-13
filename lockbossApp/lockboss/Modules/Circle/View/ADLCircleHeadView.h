//
//  ADLCircleHeadView.h
//  lockboss
//
//  Created by Han on 2019/6/1.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLCircleHeadViewDelegate <NSObject>

- (void)didClickSearchView;

- (void)didClickImageView:(NSDictionary *)dataDict;

@end

@interface ADLCircleHeadView : UIView

+ (instancetype)groupHeadViewWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<ADLCircleHeadViewDelegate> delegate;

@property (nonatomic, strong) NSArray *dataArr;

@end

