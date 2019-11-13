//
//  ADLRegisterView.h
//  lockboss
//
//  Created by adel on 2019/4/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLRegisterViewDelegate <NSObject>

- (void)didRegistPhoneAccount:(BOOL)phone;

- (void)didClickProtocolBtn;

- (void)didClickPrivacyBtn;

@end

@interface ADLRegisterView : UIView

+ (instancetype)registerViewWithFrame:(CGRect)frame delegate:(id)delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

@property (nonatomic, weak) id<ADLRegisterViewDelegate> delegate;

@end
