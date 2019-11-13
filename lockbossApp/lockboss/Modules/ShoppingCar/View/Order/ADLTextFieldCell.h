//
//  ADLTextFieldCell.h
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLTextFieldCellDelegate <NSObject>

- (void)textFieldDidEndEdit:(UITextField *)textField;

- (void)textFieldDidBeginEdit:(UITextField *)textField;

@end

@interface ADLTextFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIView *spView;

@property (nonatomic, weak) id<ADLTextFieldCellDelegate> delegate;

@end

