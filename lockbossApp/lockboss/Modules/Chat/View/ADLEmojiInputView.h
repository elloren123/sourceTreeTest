//
//  ADLEmojiInputView.h
//  lockboss
//
//  Created by adel on 2019/8/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLEmojiInputViewDelegate <NSObject>

- (void)didClickEmoji:(NSString *)emoji;

- (void)didClickSend;

@end

@interface ADLEmojiInputView : UIView

+ (instancetype)emojiViewWithDelegate:(id)delegate;

@end
