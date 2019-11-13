//
//  ADLNicknameController.m
//  lockboss
//
//  Created by adel on 2019/4/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLNicknameController.h"

@interface ADLNicknameController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@end

@implementation ADLNicknameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"修改昵称"];
    [self addRightButtonWithTitle:@"完成" action:@selector(clickDone:)];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+12, SCREEN_WIDTH, ROW_HEIGHT)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+12, SCREEN_WIDTH-24, ROW_HEIGHT)];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:FONT_SIZE];
    NSString *nickName = [ADLUserModel sharedModel].nickName;
    textField.text = nickName;
    textField.returnKeyType = UIReturnKeyDone;
    textField.placeholder = @"请输入昵称";
    [textField becomeFirstResponder];
    [self.view addSubview:textField];
    textField.delegate = self;
    self.textField = textField;
}

#pragma mark ------ 完成 ------
- (void)clickDone:(UIButton *)sender {
    NSString *nickStr = self.textField.text;
    nickStr = [nickStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (nickStr.length > 0) {
        if ([ADLUtils hasEmoji:nickStr]) {
            [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        } else {
            sender.enabled = NO;
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:self.textField.text forKey:@"nickName"];
            [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
            [ADLNetWorkManager postWithPath:k_modify_nickname parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                if ([responseDict[@"code"] integerValue] == 10000) {
                    [ADLToast showMessage:@"修改成功"];
                    ADLUserModel *model = [ADLUserModel sharedModel];
                    model.nickName = self.textField.text;
                    [ADLUserModel saveUserModel:model];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                sender.enabled = YES;
            } failure:^(NSError *error) {
                sender.enabled = YES;
            }];
        }
        
    } else {
        [ADLToast showMessage:@"请输入昵称"];
    }
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
