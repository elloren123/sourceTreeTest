//
//  ADLMoreInputView.h
//  lockboss
//
//  Created by adel on 2019/8/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLMoreInputViewDelegate <NSObject>

- (void)didClickCamera;

- (void)didClickPhoto;

- (void)didClickVideo;

@end

@interface ADLMoreInputView : UIView

+ (instancetype)moreViewWithDelegate:(id)delegate;

@property (nonatomic, weak) id<ADLMoreInputViewDelegate> delegate;

@end
