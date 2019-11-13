//
//  ADLDownloadVideoView.h
//  lockboss
//
//  Created by Han on 2019/8/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMSGFileContent;

@interface ADLDownloadView : UIView

+ (instancetype)showWithContent:(JMSGFileContent *)content msgId:(NSString *)msgId finish:(void(^)(void))finish;

@end
