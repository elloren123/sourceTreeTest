//
//  ADLDinnerSizeView.m
//  lockboss
//
//  Created by bailun91 on 2019/9/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDinnerSizeView.h"
#import "ADLGlobalDefine.h"

@implementation ADLDinnerSizeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:17];
    titLab.textColor = [UIColor blackColor];
    titLab.text = @"选择规格";
    [self addSubview:titLab];
    
    
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-30, 10, 20, 20)];
    dismissBtn.tag = 101;
    dismissBtn.layer.cornerRadius = 4.0;
    [dismissBtn setImage:[UIImage imageNamed:@"icon_quxiao"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissBtn];
    
    
    UILabel *leadLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, self.frame.size.width-30, 30)];
    leadLab.textAlignment = NSTextAlignmentLeft;
    leadLab.font = [UIFont systemFontOfSize:15.5];
    leadLab.textColor = [UIColor lightGrayColor];
    leadLab.text = @"分量";
    [self addSubview:leadLab];
    
    
    self.btnTag = 2;
    NSArray *titleArr = @[@"大份", @"中份", @"小份"];
    for (int i = 0 ; i < 3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20*(i+1)+(self.frame.size.width-80)*(i)/3, 75, (self.frame.size.width-80)/3, 30)];
        button.tag = 201+i;
        button.layer.cornerRadius = 4.0;
        button.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i == 0) {
            button.backgroundColor = SEPARATOR_COLOR;
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.sizeBtn1 = button;
            
        } else if (i == 1) {
            button.backgroundColor = COLOR_E0212A;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.sizeBtn2 = button;
            
        } else if (i == 2) {
            button.backgroundColor = SEPARATOR_COLOR;
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.sizeBtn3 = button;
        }
    }
    
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, self.frame.size.width-30, 30)];
    priceLab.textAlignment = NSTextAlignmentLeft;
    priceLab.font = [UIFont systemFontOfSize:15.5];
    priceLab.textColor = COLOR_E0212A;
    priceLab.text = @"总计: ￥30";
    [self addSubview:priceLab];
    self.priceLbl = priceLab;
    
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/3.0, 155, self.frame.size.width/3.0, 35)];
    confirmBtn.tag = 301;
    confirmBtn.layer.cornerRadius = 4.0;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = COLOR_E0212A;
    [confirmBtn setTitle:@"选好了" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
}
- (void)clickButtonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
            self.dismissBtnAction(sender.tag, @"");
            break;
            
        case 201:
        case 202:
        case 203:
            if (self.btnTag != sender.tag-200) {
                self.btnTag = sender.tag-200;
                [self updateButtonUI];
            }
            break;
        
        case 301:
            [self selectBtnClicked];
            break;
            
        default:
            break;
    }
}
- (void)updateButtonUI {
    if (self.btnTag == 1) { //大份
        self.sizeBtn1.backgroundColor = COLOR_E0212A;
        [self.sizeBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sizeBtn2.backgroundColor = SEPARATOR_COLOR;
        [self.sizeBtn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.sizeBtn3.backgroundColor = SEPARATOR_COLOR;
        [self.sizeBtn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.priceLbl.text = @"总计: ￥40";
   
    } else if (self.btnTag == 2) { //中份
        self.sizeBtn1.backgroundColor = SEPARATOR_COLOR;
        [self.sizeBtn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.sizeBtn2.backgroundColor = COLOR_E0212A;
        [self.sizeBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sizeBtn3.backgroundColor = SEPARATOR_COLOR;
        [self.sizeBtn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.priceLbl.text = @"总计: ￥30";
    
    } else if (self.btnTag == 3) { //小份
        self.sizeBtn1.backgroundColor = SEPARATOR_COLOR;
        [self.sizeBtn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.sizeBtn2.backgroundColor = SEPARATOR_COLOR;
        [self.sizeBtn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.sizeBtn3.backgroundColor = COLOR_E0212A;
        [self.sizeBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.priceLbl.text = @"总计: ￥20";
    }
}

- (void)selectBtnClicked {
    NSString *price = @"30";
    if (self.btnTag == 1) {
        price  =@"40";
    } else if (self.btnTag == 3) {
        price = @"20";
    }
    self.didSelectedBlock(self.dinnerIndex, self.btnTag, price);
}


@end
