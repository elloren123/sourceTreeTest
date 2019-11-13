//
//  ADLFoterServiceView.m
//  lockboss
//
//  Created by adel on 2019/11/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFoterServiceView.h"
#define MAX_LIMIT_NUMS 200
@interface ADLFoterServiceView ()<UITextViewDelegate>


@end
@implementation ADLFoterServiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubview:self.leiveLabel];
        [self addSubview:self.leiveTime];
        [self addSubview:self.leiveNowLabel];
        [self addSubview:self.leiveNowTimeBtn];
        [self addSubview:self.dataLabel];
        [self addSubview:self.data];
        
        [self addSubview:self.makeMoneyLabel];
        [self addSubview:self.makeMoney];
        
        [self addSubview:self.priceLabel];
        [self addSubview:self.price];
        [self addSubview:self.textView];
        [self addSubview:self.placehoderLabel];
        [self addSubview:self.number];
        [self addSubview:self.submitBtn];
    }
    return self;
}

-(UILabel *)leiveLabel {
    if (!_leiveLabel) {
        _leiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(12,10,80, 30)];
        _leiveLabel.text = ADLString(@"离店时间");
        _leiveLabel.textColor = COLOR_333333;
        _leiveLabel.font =  [UIFont systemFontOfSize:14];
        _leiveLabel.hidden = YES;
    }
    return _leiveLabel;
}
-(UILabel *)leiveTime {
    if (!_leiveTime) {
        _leiveTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leiveLabel.frame)+10,10,80, 30)];
        //_leiveTime.text = ADLString(@"离店时间");
        _leiveTime.textColor = COLOR_333333;
        _leiveTime.font = [UIFont systemFontOfSize:14];
        _leiveTime.hidden = YES;
    }
    return _leiveTime;
}

-(UILabel *)leiveNowLabel {
    if (!_leiveNowLabel) {
        _leiveNowLabel = [[UILabel alloc]initWithFrame:CGRectMake(12,CGRectGetMaxY(self.leiveLabel.frame)+15,80, 30)];
        _leiveNowLabel.text = ADLString(@"现离店时间");
        _leiveNowLabel.textColor = COLOR_333333;
        _leiveNowLabel.font = [UIFont systemFontOfSize:14];
        _leiveNowLabel.hidden = YES;
    }
    return _leiveNowLabel;
}
-(UIButton *)leiveNowTimeBtn {
    if (!_leiveNowTimeBtn) {
        _leiveNowTimeBtn = [self createButtonFrame:CGRectMake(CGRectGetMaxX(self.leiveLabel.frame)+10,self.leiveNowLabel.y,80, 30) imageName:@"" title:ADLString(@"2019-12-12") titleColor:[UIColor whiteColor] font:16 target:self action:@selector(submitBtn:)];
        _leiveNowTimeBtn.backgroundColor =COLOR_E0212A;
        _leiveNowTimeBtn.layer.masksToBounds = YES;
        _leiveNowTimeBtn.layer.borderColor = COLOR_E0212A.CGColor;
        _leiveNowTimeBtn.layer.borderWidth = 1;
        _leiveNowTimeBtn.layer.cornerRadius = 5;
        _leiveNowTimeBtn.hidden = YES;
    }
    return _submitBtn;
}
-(UILabel *)dataLabel {
    if (!_dataLabel) {
        _dataLabel =  [[UILabel alloc]initWithFrame:CGRectMake(12,CGRectGetMaxY(self.leiveNowLabel.frame)+15,80, 30)];
        _dataLabel.text = ADLString(@"离店时间");
        _dataLabel.textColor = COLOR_333333;
        _dataLabel.font = [UIFont systemFontOfSize:14];
        _dataLabel.hidden = YES;
    }
    return _dataLabel;
}

-(UILabel *)data {
    if (!_data) {
        _data =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dataLabel.frame)+10,self.dataLabel.y,80, 30)];
        // _data.text = ADLString(@2");
        _data.textColor = COLOR_333333;
        _data.font = [UIFont systemFontOfSize:14];
        _data.hidden = YES;
    }
    return _data;
}

-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel =  [[UILabel alloc]initWithFrame:CGRectMake(12,CGRectGetMaxY(self.dataLabel.frame)+15,80, 30)];
        _priceLabel.text = ADLString(@"房价");
        _priceLabel.textColor = COLOR_333333;
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.hidden = YES;
    }
    return _priceLabel;
}

-(UILabel *)price {
    if (!_price) {
        _price =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame)+10,self.priceLabel.y,80, 30)];
        // _data.text = ADLString(@2");
        _price.textColor = COLOR_333333;
        _price.font =[UIFont systemFontOfSize:14];
        _price.hidden = YES;
    }
    return _price;
}
-(UILabel *)makeMoneyLabel {
    if (!_makeMoneyLabel) {
        _makeMoneyLabel =  [[UILabel alloc]initWithFrame:CGRectMake(12,CGRectGetMaxY(self.priceLabel.frame)+15,80, 30)];
        _makeMoneyLabel.text = ADLString(@"应补差价");
        _makeMoneyLabel.textColor = COLOR_333333;
        _makeMoneyLabel.font = [UIFont systemFontOfSize:14];
        _makeMoneyLabel.hidden = YES;
    }
    return _makeMoneyLabel;
}

-(UILabel *)makeMoney {
    if (!_makeMoney) {
        _makeMoney =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.makeMoneyLabel.frame)+10,self.makeMoneyLabel.y,80, 30)];
        // _data.text = ADLString(@2");
        _makeMoney.textColor = COLOR_333333;
        _makeMoney.font = [UIFont systemFontOfSize:14];
        _makeMoney.hidden = YES;
    }
    return _makeMoney;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    
    
    if (comcatstr.length <= MAX_LIMIT_NUMS)
    {
        self.number.text = [NSString stringWithFormat:@"%ld/200 %@",comcatstr.length,ADLString(@"描述限200字")];
        return YES;
    }
    if (caninputlen >= 0)
    {
        
        return YES;
    }
    else
    {
        
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum == 0) {
        self.placehoderLabel.hidden = NO;
        
    }
    else {
        self.placehoderLabel.hidden = YES;
        //不让显示负数
        
    }
    
//    if (![ADLPromptMwssage isInputRuleAndBlank:textView.text]) {
//        // textView.text = [ADLPromptMwssage disable_emoji:textView.text];
//        return;
//    }
//
//    if ([ADLPromptMwssage stringContainsEmoji:textView.text]) {
//        return ;
//    }
//
//    if (existTextNum >= MAX_LIMIT_NUMS)
//    {
//        //截取到最大位置的字符
//        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
//
//        [textView setText:s];
//        [ADLPromptMwssage showErrorMessage:ADLString(@"描述限200字") inView:self];
//    }
//
    
}

-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(12,10, self.width - 24, 120)];
        _textView.backgroundColor =COLOR_F2F2F2;
        _textView.font = [UIFont systemFontOfSize:14];;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.textColor= COLOR_333333;
    }
    return _textView;
}
-(UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [self createButtonFrame:CGRectMake(20, CGRectGetMaxY(self.textView.frame)+40, self.width- 40, 50) imageName:@"" title:ADLString(@"提交") titleColor:[UIColor whiteColor] font:16 target:self action:@selector(submitBtn:)];
        _submitBtn.backgroundColor =COLOR_E0212A;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.borderColor = COLOR_E0212A.CGColor;
        _submitBtn.layer.borderWidth = 1;
        _submitBtn.layer.cornerRadius = 5;
    }
    return _submitBtn;
}
-(void)submitBtn:(UIButton *)btn {
    if (self.blockBtn) {
        self.blockBtn(btn);
    }
    //  [self reservartionService];
}
-(UILabel *)placehoderLabel {
    if (!_placehoderLabel) {
        _placehoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.x+3, self.textView.y+10, self.textView.width, 15)];
        _placehoderLabel.text = ADLString(@"留言...");
        _placehoderLabel.textColor =COLOR_333333;
        _placehoderLabel.font = [UIFont systemFontOfSize:14];
        //        _placehoderLabel.textAlignment = NSTextAlignmentRight;
    }
    return _placehoderLabel;
}

-(UILabel *)number {
    if (!_number) {
        _number = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.x, CGRectGetMaxY(self.textView.frame) - 17, self.textView.width-10, 15)];
        _number.text = [NSString stringWithFormat:@"0/200 %@",ADLString(@"描述限200字")];;
        _number.textColor = COLOR_333333;
        _number.font = [UIFont systemFontOfSize:12];
        _number.textAlignment = NSTextAlignmentRight;
    }
    return _number;
}
@end
