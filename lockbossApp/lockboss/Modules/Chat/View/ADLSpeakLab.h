//
//  ADLSpeakLab.h
//  lockboss
//
//  Created by adel on 2019/8/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLSpeakLabDelegate <NSObject>

- (void)startRecording;

- (void)cancleRecording;

- (void)endRecording;

@end

@interface ADLSpeakLab : UILabel

@property (nonatomic, strong) UIView *recordView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *voiceLab;

@property (nonatomic, weak) id<ADLSpeakLabDelegate> delegate;

@end
