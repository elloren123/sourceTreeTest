//
//  ADLMerchantPayView.h
//  lockboss
//
//  Created by adel on 2019/6/11.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLMerchantPayViewDelegate <NSObject>

- (void)didClickPayBtn:(UIButton *)sender;

- (void)contractPeriodDidChanged:(NSInteger)period;

@end

@interface ADLMerchantPayView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *depositLab;
@property (weak, nonatomic) IBOutlet UILabel *dueLab;
@property (weak, nonatomic) IBOutlet UITextField *dueTF;
@property (weak, nonatomic) IBOutlet UILabel *platformMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (nonatomic, weak) id<ADLMerchantPayViewDelegate> delegate;

@end

