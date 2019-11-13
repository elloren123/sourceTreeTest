//
//  ADLAddNotesController.m
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAddNotesController.h"

@interface ADLAddNotesController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView   *textview;
@property (nonatomic, strong) UILabel      *leadLbl;
@property (nonatomic, strong) UIButton     *labButton1;
@property (nonatomic, strong) UIButton     *labButton2;
@property (nonatomic, strong) UIButton     *labButton3;
@property (nonatomic, strong) UIButton     *labButton4;
@property (nonatomic, strong) UIButton     *labButton5;
@property (nonatomic, strong) UIButton     *labButton6;
@property (nonatomic, strong) UIButton     *labButton7;

@end

@implementation ADLAddNotesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationView];
    [self createContentViews];
}

- (void)createNavigationView {
    //导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navView.backgroundColor = COLOR_E0212A;
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    backBtn.tag = 101;
    [backBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
        
    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, STATUS_HEIGHT, SCREEN_WIDTH/2, NAV_H)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor whiteColor];
    titLab.text = @"添加备注";
    [navView addSubview:titLab];
    
    
    //完成按钮
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5, STATUS_HEIGHT, SCREEN_WIDTH/5, NAV_H)];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:14.5];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.tag = 102;
    [navView addSubview:doneBtn];
    
    
    //灰色背景
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    grayView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:grayView];
    
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(20, NAVIGATION_H+15, SCREEN_WIDTH-40, SCREEN_WIDTH/2-30)];
    txtView.backgroundColor = [UIColor whiteColor];
    txtView.font = [UIFont systemFontOfSize:14];
    txtView.textColor = [UIColor lightGrayColor];
    txtView.delegate = self;
    txtView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:txtView];
    txtView.text = @"请输入口味，偏好等要求...";
    self.textview = txtView;
    
    
    
    UILabel *leadLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4-48, SCREEN_WIDTH/2-60, SCREEN_WIDTH/4, 30)];
    leadLab.textAlignment = NSTextAlignmentRight;
    leadLab.font = [UIFont systemFontOfSize:14];
    leadLab.textColor = [UIColor lightGrayColor];
    leadLab.text = @"0/50";
    [self.textview addSubview:leadLab];
    self.leadLbl = leadLab;
}
- (void)clickBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 102:
            [self doneBtnAction];
            break;
            
        case 201:
        case 202:
        case 203:
        case 204:
        case 205:
        case 206:
        case 207:
            sender.selected = !sender.selected;
            if (sender.selected) {
                sender.layer.borderColor = COLOR_E0212A.CGColor;
                [sender setTitleColor:COLOR_E0212A forState:UIControlStateNormal];
            } else {
                sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
}
- (void)doneBtnAction {
    NSString *text = @"";
    if (![self.textview.text isEqualToString:@"请输入口味，偏好等要求..."]) {
        text = self.textview.text;
    }
    
    //拼接字符串 (快捷标签)
    if (self.labButton1.selected) {
        text = [NSString stringWithFormat:@"%@ %@", text, @"不吃辣"];
    }
    if (self.labButton2.selected) {
        text = [NSString stringWithFormat:@"%@ %@", text, @"少放辣"];
    }
    if (self.labButton3.selected) {
        text = [NSString stringWithFormat:@"%@ %@", text, @"多放辣"];
    }
    if (self.labButton4.selected) {
        text = [NSString stringWithFormat:@"%@ %@", text, @"不吃蒜"];
    }
    if (self.labButton5.selected) {
        text = [NSString stringWithFormat:@"%@ %@", text, @"不吃香菜"];
    }
    if (self.labButton6.selected) {
        text = [NSString stringWithFormat:@"%@ %@", text, @"不吃葱"];
    }
    if (self.labButton7.selected) {
        text = [NSString stringWithFormat:@"%@ %@", text, @"不吃芹菜"];
    }
    
    
    NSMutableArray *markArr = [NSMutableArray array];
    self.addNotesInfoBlock(text, markArr);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createContentViews {
    UILabel *leadLab = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_WIDTH/2+NAVIGATION_H, SCREEN_WIDTH/2, 48)];
    leadLab.textAlignment = NSTextAlignmentLeft;
    leadLab.font = [UIFont systemFontOfSize:14.5];
    leadLab.textColor = [UIColor lightGrayColor];
    leadLab.text = @"快捷标签";
    [self.view addSubview:leadLab];
    
    
    NSArray *txtArray = @[@"不吃辣", @"少放辣", @"多放辣", @"不吃蒜", @"不吃香菜", @"不吃葱", @"不吃芹菜"];
    for (int i = 0 ; i < 7; i++) {
        UIButton *labBtn = [[UIButton alloc] initWithFrame:CGRectMake(20+(15+(SCREEN_WIDTH-85)/4)*(i%4), SCREEN_WIDTH/2+NAVIGATION_H+48+(i/4)*48, (SCREEN_WIDTH-85)/4, 36)];
        labBtn.layer.cornerRadius = 4.0;
        labBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        labBtn.layer.borderWidth = 1.0;
        [labBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        labBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [labBtn setTitle:txtArray[i] forState:UIControlStateNormal];
        [labBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        labBtn.tag = 201+i;
        labBtn.selected = NO;
        [self.view addSubview:labBtn];
        
        if (i == 0) {
            self.labButton1 = labBtn;
        } else if (i == 1) {
            self.labButton2 = labBtn;
        } else if (i == 2) {
            self.labButton3 = labBtn;
        } else if (i == 3) {
            self.labButton4 = labBtn;
        } else if (i == 4) {
            self.labButton5 = labBtn;
        } else if (i == 5) {
            self.labButton6 = labBtn;
        } else if (i == 6) {
            self.labButton7 = labBtn;
        }
    }
}
#pragma mark ------ UITextViewDelegate functions ------
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.textview.text isEqualToString:@"请输入口味，偏好等要求..."]) {
        self.textview.text = @"";
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView.text.length > 49 && range.length == 0) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        if (textView.text.length == 0) {
            self.textview.text = @"请输入口味，偏好等要求...";
            self.leadLbl.text = @"0/50";
        }
        
        return NO;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
//    NSLog(@"text changed: %@", textView.text);
    self.leadLbl.text = [NSString stringWithFormat:@"%d/50", (int)textView.text.length];
}

@end
