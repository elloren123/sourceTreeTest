//
//  ADLChatToolView.h
//  lockboss
//
//  Created by adel on 2019/8/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLChatToolViewDelegate <NSObject>

- (void)didChangeFrame:(CGFloat)height;

- (void)didClickSendBtn:(NSString *)content;

- (void)didStartRecording;

- (void)didCancleRecording;

- (void)didEndRecording;

- (void)didClickTakePhoto;

- (void)didClickPhotoLibrary;

- (void)didClickRecordingVideo;

@end

@interface ADLChatToolView : UIView

@property (nonatomic, weak) id<ADLChatToolViewDelegate> delegate;

- (void)endEditing;

@end
