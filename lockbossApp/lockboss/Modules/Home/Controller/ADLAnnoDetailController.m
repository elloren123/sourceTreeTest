//
//  ADLAnnoDetailController.m
//  lockboss
//
//  Created by adel on 2019/4/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAnnoDetailController.h"

@interface ADLAnnoDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *conLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@end

@implementation ADLAnnoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"公告详情"];
    self.top.constant = NAVIGATION_H+25;
    self.titLab.text = self.dict[@"title"];
    self.conLab.text = self.dict[@"content"];
    self.dateLab.text = [ADLUtils getDateFromTimestamp:[self.dict[@"addDatetime"] doubleValue] format:@"yyyy-MM-dd"];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressContentText:)];
    [self.conLab addGestureRecognizer:longPress];
}

#pragma mark ------ 复制 ------
- (void)longPressContentText:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [ADLAlertView showWithTitle:@"提示" message:@"复制文本" confirmTitle:@"复制" confirmAction:^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.conLab.text;
            [ADLToast showMessage:@"复制成功"];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

@end
