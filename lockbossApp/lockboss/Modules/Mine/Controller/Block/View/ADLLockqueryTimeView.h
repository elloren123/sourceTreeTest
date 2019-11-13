//
//  ADLLockqueryTimeView.h
//  ADEL-APP
//
//  Created by adel on 2019/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLLockqueryTimeView : UIView

@property (nonatomic ,weak)UIButton *starttime;//开始时间
@property (nonatomic ,weak)UIButton *endtime;//结束时间

@property (nonatomic ,weak)UIButton *startBtn;//开始时间
@property (nonatomic ,weak)UIButton *endBtn;//结束时间

@property (nonatomic ,strong) UILabel *remaining;
@property (nonatomic ,copy)void(^blockTime)(UIButton*btn);
@end

NS_ASSUME_NONNULL_END
