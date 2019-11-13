//
//  ADLGatewayAddDetailRightCell.m
//  lockboss
//
//  Created by adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLGatewayAddDetailRightCell.h"

#import "ADLDeviceTypeModel.h"

@interface ADLGatewayAddDetailRightCell ()

@property (nonatomic ,strong) UIImageView *deviceImgView;//设备图片
@property (nonatomic ,strong) UILabel *nameLab;//设备名称

@end

static NSString * ADLGatewayAddDetailRightCellID = @"ADLGatewayAddDetailRightCellID";

@implementation ADLGatewayAddDetailRightCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ADLGatewayAddDetailRightCell *cell = [tableView dequeueReusableCellWithIdentifier:ADLGatewayAddDetailRightCellID];
    if (cell == nil) {
        cell = [[ADLGatewayAddDetailRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ADLGatewayAddDetailRightCellID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubVeiws];
    }
    return self;
}

-(void)setSubVeiws {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.deviceImgView];
    [self addSubview:self.nameLab];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.deviceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deviceImgView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark ------ 懒加载 ------
-(UIImageView *)deviceImgView {
    if (!_deviceImgView) {
        _deviceImgView = [[UIImageView alloc]init];
        _deviceImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _deviceImgView;
}
-(UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.font = [UIFont boldSystemFontOfSize:14];
        _nameLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _nameLab.text = @"";//TODO
        _nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLab;
}

-(void)setDeviceTypeModel:(ADLDeviceTypeModel *)deviceTypeModel {
    _deviceTypeModel = deviceTypeModel;
    
    //根据model设置 图片,名称; TODO
    if ([_deviceTypeModel.deviceType isEqualToString:@"51"]) {
        _nameLab.text =@"储物箱";
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_boxoff"];
    }else if([_deviceTypeModel.deviceType isEqualToString:@"41"]){
        _nameLab.text =@"燃气阀";
        self.deviceImgView.image = [UIImage imageNamed:@"icon_device_gason"];
    }
   
    
}

@end
