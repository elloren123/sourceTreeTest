//
//  ADLFUnlockRecordCell.m
//  lockboss
//
//  Created by Adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFUnlockRecordCell.h"
#import <UIImageView+WebCache.h>
#import "ADLUtils.h"

@implementation ADLFUnlockRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 5;
    self.iconView.layer.cornerRadius = 4;
}

#pragma mark ------ 赋值 ------
- (void)dealwithData:(NSDictionary *)dict {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[dict[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    self.timeLab.text = [self dealwithTime:dict[@"openDatetime"]];
    self.deviceLab.text = [dict[@"deviceName"] stringValue];
    
    NSString *userName = dict[@"userName"];
    if ([dict[@"userName"] stringValue].length > 0) {
        self.nameLab.text = dict[@"userName"];
    } else {
        userName = ADLString(@"unknown_user");
        self.nameLab.text = ADLString(@"unknown_user");
    }
    
    if ([dict[@"result"] boolValue]) {
        self.statusLab.textColor = COLOR_0AAA00;
        self.statusLab.text = ADLString(@"success");
        self.descLab.text = [NSString stringWithFormat:@"%@%@%@%@",userName,ADLString(@"present"),[ADLUtils getDateFromTimestamp:[dict[@"openDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm:ss"],ADLString(@"u_success_format")];
    } else {
        self.statusLab.textColor = COLOR_999999;
        self.statusLab.text = ADLString(@"failed");
        self.descLab.text = [NSString stringWithFormat:@"%@%@%@%@",userName,ADLString(@"present"),[ADLUtils getDateFromTimestamp:[dict[@"openDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm:ss"],ADLString(@"u_failed_format")];
    }
    
    if ([dict[@"openGroup"] boolValue]) {
        self.fingerView.hidden = NO;
        self.phoneView.hidden = NO;
        self.mcardView.hidden = NO;
        self.pwdView.hidden = NO;
        if ([dict[@"fingerprintValidation"] boolValue]) {
            self.fingerView.image = [UIImage imageNamed:@"secret_finger_s"];
        } else {
            self.fingerView.image = [UIImage imageNamed:@"secret_finger_n"];
        }
        if ([dict[@"cardValidation"] boolValue]) {
            self.mcardView.image = [UIImage imageNamed:@"secret_card_s"];
        } else {
            self.mcardView.image = [UIImage imageNamed:@"secret_card_n"];
        }
        if ([dict[@"passwordValidation"] boolValue]) {
            self.pwdView.image = [UIImage imageNamed:@"secret_pwd_s"];
        } else {
            self.pwdView.image = [UIImage imageNamed:@"secret_pwd_n"];
        }
        if ([dict[@"phoneValidation"] boolValue]) {
            self.phoneView.image = [UIImage imageNamed:@"secret_phone_s"];
        } else {
            self.phoneView.image = [UIImage imageNamed:@"secret_phone_n"];
        }
    } else {
        self.fingerView.hidden = YES;
        self.mcardView.hidden = YES;
        self.pwdView.hidden = YES;
        if ([dict[@"result"] boolValue]) {
            self.phoneView.hidden = NO;
            if ([dict[@"fingerprintValidation"] boolValue]) {
                self.phoneView.image = [UIImage imageNamed:@"secret_finger_s"];
            } else if ([dict[@"cardValidation"] boolValue]) {
                self.phoneView.image = [UIImage imageNamed:@"secret_card_s"];
            } else if ([dict[@"passwordValidation"] boolValue]) {
                self.phoneView.image = [UIImage imageNamed:@"secret_pwd_s"];
            } else {
                self.phoneView.image = [UIImage imageNamed:@"secret_phone_s"];
            }
        } else {
            self.phoneView.hidden = YES;
        }
    }
}

#pragma mark ------ 处理时间 ------
- (NSString *)dealwithTime:(NSString *)timestamp {
    NSInteger second = [ADLUtils getSecondFromStartTimestamp:[timestamp doubleValue] endTimestamp:0];
    if (second < 60) {
        return ADLString(@"just_now");
    } else if (second < 3600) {
        return [NSString stringWithFormat:@"%ld%@",second/60,ADLString(@"minute_ago")];
    } else if (second < 86400) {
        return [NSString stringWithFormat:@"%ld%@",second/3600,ADLString(@"hour_ago")];
    } else {
        return [ADLUtils getDateFromTimestamp:[timestamp doubleValue] format:@"yyyy-MM-dd HH:mm:ss"];
    }
}

@end
