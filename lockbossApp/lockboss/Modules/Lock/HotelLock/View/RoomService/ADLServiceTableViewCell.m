//
//  ADLServiceTableViewCell.m
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLServiceTableViewCell.h"
#import "ADLHomeServiceModel.h"
#import <UIImageView+WebCache.h>

@interface ADLServiceTableViewCell ()

@property (nonatomic, weak) UIImageView *headImage;//图片
@property (nonatomic, weak) UILabel *nameLabel;//服务名

@property (nonatomic, weak) UILabel *timeLabel;//时间

//价格
@property (nonatomic, weak) UILabel *priceLabel;
//服务描述
@property (nonatomic, weak) UILabel *describeLabel;

@property (nonatomic, weak) UILabel *stateLabel;


@property (nonatomic, strong) UIImageView *backImage;


@end



@implementation ADLServiceTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"erviceCell";
    ADLServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ADLServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    return cell;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self subView];
    }
    return self;
}
-(void)subView {
    
    [self.contentView addSubview:self.backImage];
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:@"icon_room_money"];
    self.headImage = headImage;
    [self.contentView addSubview:self.headImage];
    
    UILabel *nameLabel = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:14 text:@"服务名称" texeColor:COLOR_333333];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:self.nameLabel];
    
    UILabel *servicetype = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:14 text:@"服务名称" texeColor:COLOR_333333];
    self.servicetype = servicetype;
    self.servicetype.hidden = YES;
    [self.contentView addSubview:self.servicetype];
    
    
    UILabel *timeLabel = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:10 text:@"2011000010010" texeColor:COLOR_333333];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:self.timeLabel];
    
    
    UILabel *orderLabel = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"服务单号:1223242" texeColor:COLOR_333333];
    self.orderLabel = orderLabel;
    [self.contentView addSubview:self.orderLabel];
    
    
    
    UILabel *priceLabel = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"价格: 免费" texeColor:COLOR_666666];
    self.priceLabel = priceLabel;
    [self.contentView addSubview:self.priceLabel];
    
    UILabel *describeLabel = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"" texeColor:COLOR_333333];
    describeLabel.numberOfLines = 0;
    // describeLabel.backgroundColor  = [UIColor redColor];
    self.describeLabel = describeLabel;
    [self.contentView addSubview:self.describeLabel];
    
    
    UILabel *refundDes = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"" texeColor:COLOR_333333];
    refundDes.numberOfLines = 0;
    //  refundDes.backgroundColor  = [UIColor redColor];
    self.refundDes = refundDes;
    [self.contentView addSubview:self.refundDes];
    
    
    
    UILabel *messageLable = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"" texeColor:COLOR_333333];
    //  messageLable.textAlignment = NSTextAlignmentCenter;
    //  messageLable.backgroundColor  = [UIColor yellowColor];
    messageLable.numberOfLines = 0;
    self.messageLable = messageLable;
    [self.contentView addSubview:self.messageLable];
    
    
    
    
    UILabel *stateLabel = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"" texeColor:COLOR_333333];
    // stateLabel.backgroundColor  = [UIColor redColor];
    self.stateLabel = stateLabel;
    [self.contentView addSubview:self.stateLabel];
    
    
    
    UILabel *orderType = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"" texeColor:COLOR_333333];
    self.orderType = orderType;
    //orderType.backgroundColor  = [UIColor yellowColor];
    [self.contentView addSubview:self.orderType];
    
    
    UIView *line =[[UIView alloc]init];
    line.backgroundColor = COLOR_CCCCCC;
    self.line = line;
    [self.contentView addSubview:self.line];
    
    
    
    
    UIButton *cancelServiceBtn= [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:nil title:@"取消服务" titleColor:[UIColor whiteColor] font:12 target:self action:@selector(reminderBtn:)];
    cancelServiceBtn.layer.masksToBounds = YES;
    cancelServiceBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    cancelServiceBtn.layer.borderWidth = 0.5;
    cancelServiceBtn.layer.cornerRadius = 15;
    cancelServiceBtn.tag = 1;
    // cancelServiceBtn.backgroundColor = Colorad2f2d;
    //[cancelServiceBtn setBackgroundImage:[UIImage imageNamed:@"bg_cancel"] forState:UIControlStateNormal];
    self.cancelServiceBtn = cancelServiceBtn;
    [self.contentView addSubview:self.cancelServiceBtn];
    
    
    UIButton *reminderBtn= [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:nil title:ADLString(@"催单") titleColor:[UIColor whiteColor] font:12 target:self action:@selector(reminderBtn:)];
    reminderBtn.layer.masksToBounds = YES;
    reminderBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    reminderBtn.backgroundColor = COLOR_E0212A;
    reminderBtn.layer.borderWidth = 0.5;
    reminderBtn.layer.cornerRadius = 15;
    reminderBtn.tag = 2;
    //reminderBtn.backgroundColor = Colorad2f2d;
    //  [reminderBtn setBackgroundImage:[UIImage imageNamed:@"bg_reminders"] forState:UIControlStateNormal];
    self.reminderBtn = reminderBtn;
    [self.contentView addSubview:self.reminderBtn];
}
//-(void)setFrame:(CGRect)frame {
//    frame.origin.x = 5;
//    frame.size.width -= 10;
//    [super setFrame:frame];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    WS(ws);
    
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        
    }];
    
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12);
        make.top.mas_equalTo(@15);
        make.width.mas_equalTo(@57);
        make.height.mas_equalTo(@57);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.headImage.mas_right).offset(11);
        make.right.mas_equalTo(ws.mas_right).offset(-120);
        make.top.mas_equalTo(ws.mas_top).offset(15);
        make.height.mas_equalTo(@14);
    }];
    
    
    
    [self.servicetype mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.mas_right).offset(-10);
        make.top.mas_equalTo(ws.mas_top).offset(15);
        make.height.mas_equalTo(@14);
        make.width.mas_equalTo(@80);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.mas_right).offset(-12);
        make.top.mas_equalTo(ws.mas_top).offset(15);
        make.height.mas_equalTo(@12);
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.nameLabel.mas_left);
        make.right.mas_equalTo(ws.mas_right).offset(-12);
        make.centerY.mas_equalTo(ws.headImage);
        make.height.mas_equalTo(@12);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.nameLabel.mas_left);
        make.right.mas_equalTo(ws.mas_right).offset(-12);
        make.bottom.mas_equalTo(ws.headImage.mas_bottom);
        make.height.mas_equalTo(@12);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left).offset(10);
        make.right.mas_equalTo(ws.mas_right).offset(-10);
        make.top.mas_equalTo(ws.headImage.mas_bottom).offset(14);
    }];
    
    
    
    [self.messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left).offset(10);
        make.right.mas_equalTo(ws.mas_right).offset(-10);
        make.top.mas_equalTo(ws.describeLabel.mas_bottom).offset(10);
    }];
    
    
    
    
    [self.refundDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left).offset(10);
        make.right.mas_equalTo(ws.mas_right).offset(-10);
        make.top.mas_equalTo(ws.messageLable.mas_bottom).offset(10);
    }];
    
    
    [self.orderType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(10));
        make.bottom.mas_equalTo(ws.mas_bottom).offset(-10);
        make.height.width.mas_equalTo(CGSizeMake(200, 15));
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left).offset(10);
        make.right.mas_equalTo(ws.mas_right).offset(-10);
        make.bottom.mas_equalTo(ws.cancelServiceBtn.mas_top).offset(-5);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left);
        make.right.mas_equalTo(ws.mas_right);
        make.top.mas_equalTo(ws.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.cancelServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.mas_right).offset(-8);
        make.bottom.mas_equalTo(ws.mas_bottom).offset(-10);
        make.height.width.mas_equalTo(CGSizeMake(70, 30));
    }];
    //
    //     CGFloat cancelServiceBtnW = [ADLTool calculateTextWidthWithText:KLocalizableStr(@"催单") andFont:FontSize13]+10;
    [self.reminderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.cancelServiceBtn.mas_left).offset(-10);
        make.bottom.mas_equalTo(ws.mas_bottom).offset(-10);
        make.height.width.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    
    
    
    
    
    
}

-(UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        //  _backImage.image = [UIImage imageNamed:@"bg_other_lock"];
        // _backImage.lay
        _backImage.backgroundColor = [UIColor whiteColor];
        _backImage.alpha = 0.9;
    }
    return _backImage;
}


//取消服务催单

-(void)reminderBtn:(UIButton *)btn{
    
//    NSInteger title = [ADLDateTool compareDateseconds:[ADLEFdaluts objectForKey:ADLUSER_endDatetime]];
//
//    if (title == 1) {
//        [ADLPromptMwssage showErrorMessage:KLocalizableStr(@"你已经超出入住时间") inView:[UIApplication sharedApplication].keyWindow];
//        return;
//    }else if(title == 0){
//        [ADLPromptMwssage showErrorMessage:KLocalizableStr(@"你已经超出入住时间") inView:[UIApplication sharedApplication].keyWindow];
//        return;
//    }else if(title == -1){
//
//    }
//    if (self.serviveBlock) {
//        self.serviveBlock(btn);
//    }
}

-(void)setModel:(ADLHomeServiceModel *)model {
    _model = model;
    

    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.headShotUrl]] placeholderImage:[UIImage imageNamed:@"bg_adel_service"]];

    self.nameLabel.text =[NSString stringWithFormat:@"%@: %@",ADLString(@"名称"), _model.serviceName];;
    self.timeLabel.text = [ADLUtils timestampWithDateStr:_model.addDatetime format:@"YYYY-MM-dd HH:mm:ss"];

    self.orderLabel.text = [NSString stringWithFormat:@"%@: %@",ADLString(@"单号"),_model.serviceOrderId];


    if (_model.isCharge == 1) {

        if (_model.chargeAmount <= 0) {
            self.priceLabel.text = [NSString stringWithFormat:@"%@:%@",ADLString(@"服务费"),ADLString(@"免费")];
        }else {
            self.priceLabel.text = [NSString stringWithFormat:@"%@:%0.2f",ADLString(@"服务费"),_model.chargeAmount];
        }

    }else {
        self.priceLabel.text = [NSString stringWithFormat:@"%@:%@",ADLString(@"服务费"),ADLString(@"免费")];
    }




    if (_model.serviceDes.length == 0 || [_model.serviceDes isEqualToString:@""]) {
        self.describeLabel.text =[NSString stringWithFormat:@"%@:%@",ADLString(@"服务描述"),ADLString(@"无")];

    }else {
        self.describeLabel.text =[NSString stringWithFormat:@"%@:%@",ADLString(@"服务描述"),_model.serviceDes];
    }

    if (_model.refundDes.length == 0 || [_model.refundDes isEqualToString:@""]) {
        self.refundDes.hidden =YES;
    }else {
        self.refundDes.hidden =NO;
        self.refundDes.text =[NSString stringWithFormat:@"%@:%@",ADLString(@"驳回原因"),_model.refundDes];
    }

    if (_model.des.length == 0 || [_model.des isEqualToString:@""]) {
        self.messageLable.hidden =[NSString stringWithFormat:@"%@:%@",ADLString(@"我的描述"),ADLString(@"无")];
    }else {
        self.messageLable.text =[NSString stringWithFormat:@"%@: %@",ADLString(@"我的描述"),_model.des] ;

    }

    //status 1 正常， 2 待处理，  3 进行中， 4 已完成，5已撤销 7驳回
    CGFloat cancelServiceBtnW;
    if (_model.status == 1) {
        [self.cancelServiceBtn setTitle:ADLString(@"取消服务") forState:UIControlStateNormal];
       
        cancelServiceBtnW = [ADLUtils calculateString:ADLString(@"取消服务") rectSize:CGSizeMake(MAXFLOAT, 30) fontSize:12].width+20;
        self.cancelServiceBtn.userInteractionEnabled = YES;
        self.cancelServiceBtn.backgroundColor = COLOR_E0212A;
        self.reminderBtn.hidden = YES;
        self.cancelServiceBtn.hidden = YES;
    }else   if (_model.status == 2) {
        self.reminderBtn.hidden = NO;
        self.cancelServiceBtn.hidden = NO;
        [self.cancelServiceBtn setTitle:ADLString(@"取消服务") forState:UIControlStateNormal];
        
        cancelServiceBtnW = [ADLUtils calculateString:ADLString(@"取消服务") rectSize:CGSizeMake(MAXFLOAT, 30) fontSize:12].width+20;
        self.cancelServiceBtn.userInteractionEnabled = YES;
        self.cancelServiceBtn.backgroundColor = COLOR_E0212A;

        self.stateLabel.text = ADLString(@"订单状态:  等待接单");
    }else   if (_model.status == 3) {
        [self.cancelServiceBtn setTitle:ADLString(@"已接单") forState:UIControlStateNormal];
        cancelServiceBtnW = [ADLUtils calculateString:ADLString(@"已接单") rectSize:CGSizeMake(MAXFLOAT, 30) fontSize:12].width+20;
        self.cancelServiceBtn.titleLabel.text = ADLString(@"已接单");
        self.cancelServiceBtn.userInteractionEnabled = NO;
        self.cancelServiceBtn.backgroundColor = COLOR_CCCCCC;
        self.stateLabel.text = ADLString(@"订单状态:  已经接单");
        self.reminderBtn.hidden = NO;
        self.cancelServiceBtn.hidden = NO;
    }else   if (_model.status == 4) {
        [self.cancelServiceBtn setTitle:ADLString(@"已完成") forState:UIControlStateNormal];
           cancelServiceBtnW = [ADLUtils calculateString:ADLString(@"已完成") rectSize:CGSizeMake(MAXFLOAT, 30) fontSize:12].width+20;
        self.cancelServiceBtn.userInteractionEnabled = NO;
        self.cancelServiceBtn.backgroundColor = COLOR_CCCCCC;
        self.stateLabel.text = ADLString(@"订单状态:  订单完成");
        self.reminderBtn.hidden = YES;
        self.cancelServiceBtn.hidden = NO;
    }else   if (_model.status == 5) {

        [self.cancelServiceBtn setTitle:ADLString(@"已撤销") forState:UIControlStateNormal];
       cancelServiceBtnW = [ADLUtils calculateString:ADLString(@"已撤销") rectSize:CGSizeMake(MAXFLOAT, 30) fontSize:12].width+20;
        self.cancelServiceBtn.userInteractionEnabled = NO;
        self.cancelServiceBtn.backgroundColor = COLOR_CCCCCC;
        self.reminderBtn.hidden = YES;
        self.cancelServiceBtn.hidden = NO;
        self.stateLabel.text = ADLString(@"订单状态:  订单已取消");
    }  if (_model.status == 6) {

        [self.cancelServiceBtn setTitle:ADLString(@"已驳回") forState:UIControlStateNormal];
       cancelServiceBtnW = [ADLUtils calculateString:ADLString(@"已驳回") rectSize:CGSizeMake(MAXFLOAT, 30) fontSize:12].width+20;
        self.cancelServiceBtn.userInteractionEnabled = NO;
        self.cancelServiceBtn.backgroundColor = COLOR_CCCCCC;
        self.stateLabel.text = ADLString(@"订单状态:  已驳回");
        self.reminderBtn.hidden = YES;
        self.cancelServiceBtn.hidden = NO;


    }
    if ([_model.isPay isEqualToString:@"0"]) {

        self.orderType.text = ADLString(@"未支付");

    }else {

        self.orderType.hidden = YES;

    }


    
}

-(void)setServiceModel:(ADLHomeServiceModel *)serviceModel {
    _serviceModel = serviceModel;


    self.messageLable.hidden = YES;
    self.reminderBtn.hidden = YES;
    self.cancelServiceBtn.hidden = YES;
    self.timeLabel.hidden = YES;
    //1基础，2特色
    if (_serviceModel.type  == 1) {

        self.servicetype.text = ADLString(@"基础服务");
    }else {

        self.servicetype.text = ADLString(@"特色服务");
    }

    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_serviceModel.imageUrl]] placeholderImage:[UIImage imageNamed:@"bg_adel_service"]];

    self.nameLabel.text = [NSString stringWithFormat:@"%@: %@",ADLString(@"名称"),_serviceModel.name];
    //self.timeLabel.text = [ADLPromptMwssage dateTime:_serviceModel.updateDatetime];
    //  self.orderLabel.text = _model.serviceOrderId;

    if (_serviceModel.isCharge == 1) {

        if (_serviceModel.chargeAmount <= 0) {
            self.priceLabel.text = [NSString stringWithFormat:@"%@: %@",ADLString(@"服务费"),ADLString(@"免费")];
        }else {
            self.priceLabel.text = [NSString stringWithFormat:@"%@: %0.2f",ADLString(@"服务费"),_serviceModel.chargeAmount];
        }

    }else {
        self.priceLabel.text = [NSString stringWithFormat:@"%@: %@",ADLString(@"服务费"),ADLString(@"免费")];
    }

    self.describeLabel.hidden = YES;

    if (_model.serviceDes.length == 0 || [_model.serviceDes isEqualToString:@""]) {
        self.describeLabel.text =[NSString stringWithFormat:@"%@: %@",ADLString(@"服务描述"),ADLString(@"无")];

    }else {
        self.describeLabel.text =[NSString stringWithFormat:@"%@: %@",ADLString(@"服务描述"),_model.serviceDes];
    }
}
@end
