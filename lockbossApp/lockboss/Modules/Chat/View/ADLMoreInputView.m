//
//  ADLMoreInputView.m
//  lockboss
//
//  Created by adel on 2019/8/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMoreInputView.h"
#import "ADLGlobalDefine.h"

@implementation ADLMoreInputView

+ (instancetype)moreViewWithDelegate:(id)delegate {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 255+BOTTOM_H) delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_F2F2F2;
        self.delegate = delegate;
        
        UIImageView *cameraView = [[UIImageView alloc] initWithFrame:CGRectMake(28, 24, 60, 60)];
        cameraView.image = [UIImage imageNamed:@"chat_camera"];
        cameraView.backgroundColor = [UIColor whiteColor];
        cameraView.contentMode = UIViewContentModeCenter;
        cameraView.userInteractionEnabled = YES;
        cameraView.layer.cornerRadius = 4;
        cameraView.clipsToBounds = YES;
        [self addSubview:cameraView];
        
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(116, 24, 60, 60)];
        photoView.image = [UIImage imageNamed:@"chat_album"];
        photoView.backgroundColor = [UIColor whiteColor];
        photoView.contentMode = UIViewContentModeCenter;
        photoView.userInteractionEnabled = YES;
        photoView.layer.cornerRadius = 4;
        photoView.clipsToBounds = YES;
        [self addSubview:photoView];
        
        UIImageView *videoView = [[UIImageView alloc] initWithFrame:CGRectMake(204, 24, 60, 60)];
        videoView.image = [UIImage imageNamed:@"chat_video"];
        videoView.backgroundColor = [UIColor whiteColor];
        videoView.contentMode = UIViewContentModeCenter;
        videoView.userInteractionEnabled = YES;
        videoView.layer.cornerRadius = 4;
        videoView.clipsToBounds = YES;
        [self addSubview:videoView];
        
        UILabel *cameraLab = [[UILabel alloc] initWithFrame:CGRectMake(28, 84, 60, 32)];
        cameraLab.textAlignment = NSTextAlignmentCenter;
        cameraLab.font = [UIFont systemFontOfSize:13];
        cameraLab.textColor = COLOR_333333;
        cameraLab.text = @"拍照";
        [self addSubview:cameraLab];
        
        UILabel *photoLab = [[UILabel alloc] initWithFrame:CGRectMake(116, 84, 60, 32)];
        photoLab.textAlignment = NSTextAlignmentCenter;
        photoLab.font = [UIFont systemFontOfSize:13];
        photoLab.textColor = COLOR_333333;
        photoLab.text = @"照片";
        [self addSubview:photoLab];
        
        UILabel *videoLab = [[UILabel alloc] initWithFrame:CGRectMake(204, 84, 60, 32)];
        videoLab.textAlignment = NSTextAlignmentCenter;
        videoLab.font = [UIFont systemFontOfSize:13];
        videoLab.textColor = COLOR_333333;
        videoLab.text = @"视频";
        [self addSubview:videoLab];
        
        UITapGestureRecognizer *cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCamera)];
        [cameraView addGestureRecognizer:cameraTap];
        
        UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoto)];
        [photoView addGestureRecognizer:photoTap];
        
        UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickVideo)];
        [videoView addGestureRecognizer:videoTap];
    }
    return self;
}

- (void)clickCamera {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCamera)]) {
        [self.delegate didClickCamera];
    }
}

- (void)clickPhoto {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPhoto)]) {
        [self.delegate didClickPhoto];
    }
}

- (void)clickVideo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickVideo)]) {
        [self.delegate didClickVideo];
    }
}

@end
