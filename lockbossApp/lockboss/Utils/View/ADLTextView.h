//
//  ADLTextView.h
//  lockboss
//
//  Created by adel on 2019/6/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLTextViewDelegate <NSObject>

@optional

- (void)textViewDidBeginEdit:(UIView *)textView;

- (void)textViewDidChangeText:(NSString *)text;

- (void)textViewDidEndEdit:(UITextView *)textView;

@end

@interface ADLTextView : UIView

/**
 初始化

 @param frame frame
 @param limitLength 输入限制长度，当为0时表示不限制，同时不显示文字长度视图
 @return ADLTextView
 */
+ (instancetype)textViewWithFrame:(CGRect)frame limitLength:(NSInteger)limitLength;

- (instancetype)initWithFrame:(CGRect)frame limitLength:(NSInteger)limitLength;

@property (nonatomic, weak) id<ADLTextViewDelegate> delegate;

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) BOOL editing;

@end
