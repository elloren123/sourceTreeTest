//
//  ADLGatewayAddDeviceCell.m
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLGatewayAddDeviceCell.h"

#import "ADLDeviceModel.h"

#import "ADLUtils.h"

@interface ADLGatewayAddDeviceCell ()

@property (nonatomic ,strong) UIImageView *deviceImgView;//设备图片
@property (nonatomic ,strong) UILabel *nameLab;//设备名称
@property (nonatomic ,strong) UILabel *onOffLine;//在线离线
@property (nonatomic ,strong) UIView *lineView;//分割线
@property (nonatomic ,strong) UIImageView *rigimgView;

@end

static NSString * ADLGatewayAddDeviceCellId = @"gatewayChildrenDeviceCell";

@implementation ADLGatewayAddDeviceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ADLGatewayAddDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ADLGatewayAddDeviceCellId];
    if (cell == nil) {
        cell = [[ADLGatewayAddDeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ADLGatewayAddDeviceCellId];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         [self setSubVeiws];
    }
    return self;
    
}

-(void)setSubVeiws {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.deviceImgView];
    [self addSubview:self.nameLab];
    [self addSubview:self.onOffLine];
    [self addSubview:self.lineView];
    [self addSubview:self.rigimgView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.deviceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.deviceImgView.mas_right).offset(20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    [self.onOffLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(0);
        make.left.mas_equalTo(self.deviceImgView.mas_right).offset(20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.rigimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-18);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(16);
    }];
}

#pragma mark ------ 懒加载 ------
-(UIImageView *)deviceImgView {
    if (!_deviceImgView) {
        _deviceImgView = [[UIImageView alloc]init];
    }
    return _deviceImgView;
}
-(UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.font = [UIFont boldSystemFontOfSize:14];
        _nameLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _nameLab.text = @"储物箱";//TODO
    }
    return _nameLab;
}
-(UILabel *)onOffLine {
    if (!_onOffLine) {
        _onOffLine = [[UILabel alloc] initWithFrame:CGRectZero];
        _onOffLine.font = [UIFont systemFontOfSize:12];
        _onOffLine.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _onOffLine.text = @"设备在线";//TODO
    }
    return _onOffLine;
}
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    }
    return _lineView;
}

-(UIImageView *)rigimgView {
    if (!_rigimgView) {
        _rigimgView = [[UIImageView alloc] init];
        _rigimgView.image = [UIImage imageNamed:@"icon_xiao"];
    }
    return _rigimgView;
}

#pragma mark ------ 数据源 ------
-(void)setModel:(ADLDeviceModel *)model {
    _model  = model;
    if ([_model.deviceType isEqualToString:@"51"]) {//储物箱
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_boxoff"];
    }else if([_model.deviceType isEqualToString:@"41"]){//燃气阀,TODO
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_gason"];
    }else {
        self.deviceImgView.image = [ADLUtils lockImageWithType:_model.deviceType];
    }
    self.nameLab.text = _model.name?_model.name:@"";
    self.onOffLine.text = [_model.isFirstConnection isEqualToString:@"1"]?@"设备在线":@"设备离线";
    
    
}


@end
