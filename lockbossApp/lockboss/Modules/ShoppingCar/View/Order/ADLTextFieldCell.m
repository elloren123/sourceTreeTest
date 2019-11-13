//
//  ADLTextFieldCell.m
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTextFieldCell.h"

@interface ADLTextFieldCell ()<UITextFieldDelegate>

@end

@implementation ADLTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidBeginEdit:)]) {
        [self.delegate textFieldDidBeginEdit:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidEndEdit:)]) {
        [self.delegate textFieldDidEndEdit:textField];
    }
}

@end
