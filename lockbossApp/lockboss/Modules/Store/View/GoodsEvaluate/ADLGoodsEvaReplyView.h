//
//  ADLGoodsEvaReplyView.h
//  lockboss
//
//  Created by adel on 2019/7/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLGoodsEvaReplyView : UIView

@property (weak, nonatomic) IBOutlet UIButton *replyBtn;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, copy) void (^clickPraiseBtn) (void);

@property (nonatomic, copy) void (^clickSendBtn) (UITextField *textField);

@end
