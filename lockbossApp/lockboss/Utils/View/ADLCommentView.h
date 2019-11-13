//
//  ADLCommentView.h
//  lockboss
//
//  Created by adel on 2019/5/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLCommentView : UIView

+ (instancetype)commentViewWithFrame:(CGRect)frame;

- (void)beginEditing;

- (void)endEditing;

- (BOOL)isEditing;

@property (nonatomic, strong) NSString *placeHolder;

@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, copy) void (^clickSendBtn) (UIButton *sender, NSString *content);

@end
