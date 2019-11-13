//
//  ADLSearchAnimateView.h
//  lockboss
//
//  Created by Han on 2019/5/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLSearchAnimateViewDelegate <NSObject>

@optional

- (void)didClickCancleButton;

- (void)textFieldDidBeginEdit:(UITextField *)textField;

- (void)textFieldTextDidChanged:(NSString *)text;

- (void)didClickSearchDoneButton:(UITextField *)textField;

@end

@interface ADLSearchAnimateView : UIView

+ (instancetype)searchAnimateViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder verticalMargin:(CGFloat)verticalMargin instant:(BOOL)instant;

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder verticalMargin:(CGFloat)verticalMargin instant:(BOOL)instant;

- (void)cancleSearch;

- (BOOL)editing;

- (void)endEditing;

@property (nonatomic, weak) id<ADLSearchAnimateViewDelegate> delegate;

@property (nonatomic, assign) BOOL hideBottomView;

@end
