//
//  ADLShareView.h
//  lockboss
//
//  Created by Han on 2019/4/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ADLShareType) {
    ADLShareTypeUrl,
    ADLShareTypeText,
    ADLShareTypeImage
};

@interface ADLShareView : UIView

+ (instancetype)showWithTitle:(NSString *)title
                         desc:(NSString *)desc
                    imageData:(NSData *)imageData
                    targetStr:(NSString *)targetStr
                    shareType:(ADLShareType)shareType;

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                         desc:(NSString *)desc
                    imageData:(NSData *)imageData
                    targetStr:(NSString *)targetStr
                    shareType:(ADLShareType)shareType;

@property (nonatomic, strong) NSData *imageData;

@end

