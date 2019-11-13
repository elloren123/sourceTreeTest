//
//  ADLAllFamilyDeviceCell.m
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAllFamilyDeviceCell.h"

#import "ADLDeviceModel.h"

#import "ADLUtils.h"

@interface ADLAllFamilyDeviceCell ()

@property (nonatomic ,strong) UIView *subView;

@property (nonatomic ,strong) UILabel * titLab;//标题

@property (nonatomic ,strong) UIImageView *deviceImgView;//设备图片

@property (nonatomic ,strong) UILabel *locationLab;//位置

@property (nonatomic ,strong) UILabel *onOffLine;//设备是否在线(客房的子设备)

@property (nonatomic ,strong) UILabel *gatewayOnOffLine;//网关是否在线

@property (nonatomic ,strong) UIButton *powerBtn;//电量 (img,btnlabel)

@property (nonatomic ,strong) UILabel *typeLabel;//设备类型 (居里富人内外机)

@end

@implementation ADLAllFamilyDeviceCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubVeiws];
    }
    return self;
}

-(void)createSubVeiws{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.subView];
    [self.subView addSubview:self.titLab];
    [self.subView addSubview:self.deviceImgView];
    [self.subView addSubview:self.locationLab];
    [self.subView addSubview:self.onOffLine];
    [self.subView addSubview:self.gatewayOnOffLine];
    [self.subView addSubview:self.powerBtn];
    [self.subView addSubview:self.typeLabel];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-8);
    }];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subView.mas_top).offset(10);
        make.left.mas_equalTo(self.subView.mas_left).offset(10);
        make.right.mas_equalTo(self.subView.mas_right).offset(-10);
        make.height.mas_equalTo(16);
    }];
    [self.deviceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titLab.mas_bottom).offset(14);
        make.left.mas_equalTo(self.subView.mas_left).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deviceImgView.mas_top).offset(0);
        make.left.mas_equalTo(self.deviceImgView.mas_right).offset(16);
        make.right.mas_equalTo(self.subView.mas_right).offset(-10);
        make.height.mas_equalTo(14);
    }];
    
    [self.onOffLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deviceImgView.mas_top).offset(0);
        make.left.mas_equalTo(self.deviceImgView.mas_right).offset(16);
        make.right.mas_equalTo(self.subView.mas_right).offset(-10);
        make.height.mas_equalTo(14);
    }];
    
    [self.gatewayOnOffLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.locationLab.mas_bottom).offset(6);
        make.left.mas_equalTo(self.deviceImgView.mas_right).offset(16);
        make.right.mas_equalTo(self.subView.mas_right).offset(-10);
        make.height.mas_equalTo(14);
    }];
    
    [self.powerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.onOffLine.mas_bottom).offset(6);
        make.left.mas_equalTo(self.deviceImgView.mas_right).offset(16);
        make.right.mas_equalTo(self.subView.mas_right).offset(-10);
        make.height.mas_equalTo(14);
    }];
    
    self.typeLabel.frame = CGRectMake(self.frame.size.width-65, 5, 40, 24);
    
}

-(UIView *)subView {
    if (!_subView) {
        _subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _subView.backgroundColor = [UIColor whiteColor];
        _subView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor;
        _subView.layer.shadowOffset = CGSizeMake(0,0);
        _subView.layer.shadowOpacity = 1;
        _subView.layer.shadowRadius = 3;
        _subView.layer.cornerRadius = 4;
    }
    return _subView;
}

-(UILabel *)titLab {
    if (!_titLab) {
        _titLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titLab.font = [UIFont boldSystemFontOfSize:14];
        _titLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _titLab.text = @"壁虎网关1号";
    }
    return _titLab;
}

- (UILabel *)locationLab {
    if (!_locationLab) {
        _locationLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLab.font = [UIFont systemFontOfSize:12];
        _locationLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _locationLab.text = @"大厅";
        //        [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]  网关的颜色
        //        [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] 子设备的颜色
        
    }
    return _locationLab;
}

-(UILabel *)gatewayOnOffLine {
    if (!_gatewayOnOffLine) {
        _gatewayOnOffLine = [[UILabel alloc] initWithFrame:CGRectZero];
        _gatewayOnOffLine.font = [UIFont systemFontOfSize:12];
        _gatewayOnOffLine.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _gatewayOnOffLine.text = @"设备在线";
    }
    return _gatewayOnOffLine;
}

-(UILabel *)onOffLine {
    if (!_onOffLine) {
        _onOffLine = [[UILabel alloc] initWithFrame:CGRectZero];
        _onOffLine.font = [UIFont systemFontOfSize:12];
        _onOffLine.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _onOffLine.text = @"设备在线";
    }
    return _onOffLine;
}

-(UIImageView *)deviceImgView {
    if (!_deviceImgView) {
        _deviceImgView = [[UIImageView alloc]init];
        _deviceImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _deviceImgView;
}

-(UIButton *)powerBtn {
    if (!_powerBtn) {
        _powerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _powerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _powerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        _powerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_powerBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    return _powerBtn;
}
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _typeLabel.layer.cornerRadius = 12;
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.textColor = [UIColor blackColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.text = @"内机";
        _typeLabel.hidden = YES;
    }
    return _typeLabel;
}

//设置数据源,其实不应该出现在这里,cell中调用model是大忌  0.0 后面改 TODO
-(void)setDevicemodel:(ADLDeviceModel *)devicemodel {
    _devicemodel = devicemodel;
    NSArray *deleteDeviceTypeArr = @[@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"233"];
    if([deleteDeviceTypeArr containsObject:_devicemodel.deviceType]){
        self.titLab.text = _devicemodel.name;
        self.onOffLine.hidden = YES;
        self.gatewayOnOffLine.hidden = NO;
        self.gatewayOnOffLine.text = [_devicemodel.isFirstConnection isEqualToString:@"1"]?@"设备在线":@"设备离线";
        self.locationLab.text = @"";//@"不清楚字段";  TODO
        self.locationLab.hidden = NO;
        self.powerBtn.hidden = YES;
    } else {
        self.onOffLine.hidden = NO;
        self.gatewayOnOffLine.hidden = YES;
        self.locationLab.hidden = YES;
        self.powerBtn.hidden = NO;
        self.titLab.text = _devicemodel.name?_devicemodel.name:_devicemodel.deviceName;
        self.onOffLine.text = [_devicemodel.isFirstConnection isEqualToString:@"1"]?@"设备在线":@"设备离线";
        
    }
    if ([_devicemodel.deviceType isEqualToString:@"51"]) {//储物箱
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_boxoff"];
    }else if([_devicemodel.deviceType isEqualToString:@"41"]){//燃气阀,TODO
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_gason"];
    }else if([_devicemodel.deviceType isEqualToString:@"30"] || [_devicemodel.deviceType isEqualToString:@"31"]){//居里防盗,TODO
        self.deviceImgView.image = [UIImage imageNamed:@"icon_airoom_juli"];
        self.powerBtn.hidden = YES;
        self.typeLabel.hidden = NO;
        self.typeLabel.text = ([_devicemodel.deviceType isEqualToString:@"30"])?@"外机":@"内机";
    }else {
        self.deviceImgView.image = [ADLUtils lockImageWithType:_devicemodel.deviceType];
    }
    
    //电量的要单独处理了  TODO
    //设备离线,电量不显示,在线,分情况处理;
    if([_devicemodel.isFirstConnection isEqualToString:@"1"]){
        
        NSInteger percent = (_devicemodel.battery-4000)*100.0f/2400;
        if (percent < 0) percent = 0;
        if (percent > 100) percent = 100;
        [self.powerBtn setTitle:[NSString stringWithFormat:@"%ld%%",(long)percent] forState:UIControlStateNormal];
        
        if (percent < 20) {
            [self.powerBtn setImage:[UIImage imageNamed:@"battery_20"] forState:UIControlStateNormal];
        } else if (percent < 40) {
            [self.powerBtn setImage:[UIImage imageNamed:@"battery_40"] forState:UIControlStateNormal];
        } else if (percent < 60) {
            [self.powerBtn setImage:[UIImage imageNamed:@"battery_60"] forState:UIControlStateNormal];
        } else if (percent < 80) {
            [self.powerBtn setImage:[UIImage imageNamed:@"battery_80"] forState:UIControlStateNormal];
        } else {
            [self.powerBtn setImage:[UIImage imageNamed:@"battery_100"] forState:UIControlStateNormal];
        }
    } else {
        self.powerBtn.hidden = YES;
    }
}

@end
