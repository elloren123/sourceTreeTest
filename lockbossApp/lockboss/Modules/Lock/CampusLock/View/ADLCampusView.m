//
//  ADLCampusView.m
//  lockboss
//
//  Created by Adel on 2019/8/27.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCampusView.h"

@interface ADLCampusView ()

@property (nonatomic, strong) UIImageView *unlockView;
@property (nonatomic, strong) UIImageView *lockView;
@property (nonatomic, strong) UILabel     *promptLab;
@property (nonatomic, strong) UIButton    *batteryBtn;
@property (nonatomic, strong) UILabel     *roomNumLab;
@property (nonatomic, strong) UILabel     *numberLab;
@property (nonatomic, strong) UIButton    *managerBtn;

//@property (nonatomic, strong) UIImageView *deviceImgView;//增加一个储物箱和燃气阀的图片显示
//
//
//@property (nonatomic, strong) UILabel *deviceNameLab;//添加一个当前操作的设备的名称
//
//
//@property (nonatomic, strong) UILabel *isOpenOrCloseLab;//增加一个储物箱与燃气阀的当前打开关闭状态显示;不准确,因为后台没有设备打开关闭的状态返回
//@property (nonatomic, strong) UISegmentedControl *onOffSegmentC;//增加一个燃气阀和储物箱的开关控制
//@property (nonatomic, strong) UIView *bottomView;
//@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, assign) BOOL RMQLock;

@end

@implementation ADLCampusView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    //背景图片
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3)];
    backView.image = [UIImage imageNamed:@"lock_home_bg"];
    [self addSubview:backView];
    
    
    //************解锁图片************
    //白圈
    UIImageView *unlockView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, NAVIGATION_H+50, 160, 160)];
    unlockView.image = [UIImage imageNamed:@"unlock_bg"];
    unlockView.userInteractionEnabled = YES;
    [self addSubview:unlockView];
    self.unlockView = unlockView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUnlockImgview)];
    [unlockView addGestureRecognizer:tap];
    
    //当前锁的状态ImageView
    //锁的图片/打开的/关闭的
    UIImageView *lockView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, NAVIGATION_H+95, 60, 60)];
    lockView.image = [UIImage imageNamed:@"lock_status"];
    [self addSubview:lockView];
    self.lockView = lockView;
    
    //当前状态提示label
    //锁的打开和关闭/点击开锁,开锁中...,开锁成功,开锁失败
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, NAVIGATION_H+163, 80, 16)];
    promptLab.textAlignment = NSTextAlignmentCenter;
    promptLab.font = [UIFont boldSystemFontOfSize:12];
    promptLab.textColor = [UIColor whiteColor];
    promptLab.text = ADLString(@"tap_unlock");
    [self addSubview:promptLab];
    self.promptLab = promptLab;
    
    
    //电池Button
    UIButton *batteryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3-100, SCREEN_WIDTH, 40)];
    batteryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    batteryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [batteryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    batteryBtn.tag = 101;
    [self addSubview:batteryBtn];
    [batteryBtn setImage:[UIImage imageNamed:@"battery_100"] forState:UIControlStateNormal];
    [batteryBtn setTitle:@"100%" forState:UIControlStateNormal];
    self.batteryBtn = batteryBtn;
    
    
    
    //************ btns ************
    UIImageView *btnBgView = [[UIImageView alloc] initWithFrame:CGRectMake(4, SCREEN_HEIGHT*2/3-45, SCREEN_WIDTH-8, 90)];
    btnBgView.image = [UIImage imageNamed:@"bg_other_lock"];
    btnBgView.userInteractionEnabled = YES;
    [self addSubview:btnBgView];
    
    for (int i = 0 ; i < 4; i++) {
        //电池Button
        UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(21+60*i+(SCREEN_WIDTH-290)*i/3, 7, 60, 80)];
        Btn.tag = 201+i;
        [Btn addTarget:self action:@selector(btnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:Btn];
        
        
        UIImageView *btnImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [Btn addSubview:btnImg];
        
        
        UILabel *btnLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 51, 60, 24)];
        btnLab.textAlignment = NSTextAlignmentCenter;
        btnLab.font = [UIFont systemFontOfSize:12.5];
        btnLab.textColor = [UIColor blackColor];
        [Btn addSubview:btnLab];
        
        if (0 == i) {
            btnImg.image = [UIImage imageNamed:@"icon_school_card"];
            btnLab.text  = @"门卡";
        } else if (1 == i) {
            btnImg.image = [UIImage imageNamed:@"icon_school_record"];
            btnLab.text  = @"开锁记录";
        } else if (2 == i) {
            btnImg.image = [UIImage imageNamed:@"icon_school_service"];
            btnLab.text  = @"设备报修";
        } else if (3 == i) {
            btnImg.image = [UIImage imageNamed:@"icon_school_message"];
            btnLab.text  = @"消息通知";
        }
    }
    
    
    
    
    //************ infosImgView ************
    UIImageView *InfoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(4, SCREEN_HEIGHT*2/3+40, SCREEN_WIDTH-8, SCREEN_HEIGHT/3-40)];
    InfoImgView.image = [UIImage imageNamed:@"bg_other_lock"];
    InfoImgView.userInteractionEnabled = YES;
    [self addSubview:InfoImgView];
    
    
    UIImageView *proImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4-4, 5, SCREEN_WIDTH/2, 50)];
    proImgView.image = [UIImage imageNamed:@"icon_school_num"];
    [InfoImgView addSubview:proImgView];
    
    
    //'phone' Img
    UIImageView *phoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 15, 25, 25)];
    phoneImgView.image = [UIImage imageNamed:@"icon_school_phone"];
    phoneImgView.userInteractionEnabled = YES;
    [InfoImgView addSubview:phoneImgView];
    
    UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoneImgView)];
    [phoneImgView addGestureRecognizer:phonetap];
    
    
    
    UILabel *roomLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4-4, 5, SCREEN_WIDTH/2, 50)];
    roomLab.textAlignment = NSTextAlignmentCenter;
    roomLab.font = [UIFont boldSystemFontOfSize:18];
    roomLab.textColor = [UIColor whiteColor];
    roomLab.text = @"202";
    [InfoImgView addSubview:roomLab];
    self.roomNumLab = roomLab;
    
    
    UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH-8, SCREEN_HEIGHT/3-140-BOTTOM_H)];
    numberLab.textAlignment = NSTextAlignmentCenter;
    numberLab.font = [UIFont systemFontOfSize:14];
    numberLab.textColor = [UIColor blackColor];
    numberLab.text = @"人数: 3/6";
    [InfoImgView addSubview:numberLab];
    self.numberLab = numberLab;
    
    
    UIButton *manaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3-85-BOTTOM_H, SCREEN_WIDTH-8, 40)];
    manaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    manaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [manaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [manaBtn setImage:[UIImage imageNamed:@"icon_school_admin"] forState:UIControlStateNormal];
    [manaBtn setTitle:@"管理员: 张三" forState:UIControlStateNormal];
    [InfoImgView addSubview:manaBtn];
    self.managerBtn = manaBtn;
}

#pragma mark ------ 按钮点击事件 ------
- (void)btnClickedAction:(UIButton *)sender {
    NSLog(@"sender.tag = %zd", sender.tag);
    switch (sender.tag) {
        case 201://'门卡'btn
            
            break;
            
        case 202://'开锁记录'btn
            
            break;
            
        case 203://'设备报修'btn
            
            break;
            
        case 204://'消息通知'btn
            
            break;
            
            
        default:
            break;
    }
}

#pragma mark ------ 手势识别 ------
- (void)clickUnlockImgview {
    
}
- (void)clickPhoneImgView {
    
}
   
@end

