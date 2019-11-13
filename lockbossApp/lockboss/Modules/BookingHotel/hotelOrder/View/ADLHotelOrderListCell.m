//
//  ADLHotelOrderListCell.m
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelOrderListCell.h"
#import "ADLHotelOrderModel.h"
#import "UIImageView+WebCache.h"
@interface ADLHotelOrderListCell ()
@property (nonatomic ,strong)UIButton *hotelNameBtn;
@property (nonatomic ,strong)UILabel *payType;
@property (nonatomic ,strong)UIImageView *roomImage;
@property (nonatomic ,strong)UIView *line1;
@property (nonatomic ,strong)UILabel *roomeName;
@property (nonatomic ,strong)UILabel *priceLabel;
@property (nonatomic ,strong)UILabel *startTime;
@property (nonatomic ,strong)UILabel *endTime;
@property (nonatomic ,strong)UILabel *address;
@property (nonatomic ,strong)UIButton *payBtn;
@property (nonatomic ,strong)UIButton *cancelBtn;
@property (nonatomic ,strong)UIView *line2;
@property (nonatomic ,strong)UIView *line3;
@property (nonatomic ,strong)UIView *subBtnView;
//订单详情
@property (nonatomic ,strong)UILabel *payLabel;//房间价格
@property (nonatomic ,strong)UILabel *actualPrice;//实付价格

@end
@implementation ADLHotelOrderListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self.contentView addSubview:self.hotelNameBtn];
        [self.contentView addSubview:self.payType];
        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.roomImage];
        [self.contentView addSubview:self.roomeName];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.startTime];
        [self.contentView addSubview:self.endTime];
        [self.contentView addSubview:self.address];
        [self.contentView addSubview:self.payBtn];
      //  [self.contentView addSubview:self.cancelBtn];
        [self.contentView addSubview:self.line2];
        [self.contentView addSubview:self.line3];
        [self.contentView addSubview:self.subBtnView];
   
        
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView hotelOrderCell:(ADLHotelOrderCell)Cell{
    static NSString *FamilyOpenLockCell = @"ADLHotelOrderPayCell";
    ADLHotelOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:FamilyOpenLockCell];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [[ADLHotelOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FamilyOpenLockCell];
        cell.hotelOrderCell = Cell;
    }
    
    return cell;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    //订单列表
    if (self.hotelOrderCell == ADLHotelOrderistCell) {
        
    }else
        //详情cell订单列表
        if (self.hotelOrderCell == ADLHotelOrderDetailsCell) {

        }else
            //未支付订单详情
            if (self.hotelOrderCell == ADLHotelOrderafterSaleCell) {
                [self.subBtnView addSubview:self.actualPrice];
                [self.subBtnView addSubview:self.payLabel];
            
            }else
                //已支付订单详情
                if (self.hotelOrderCell == ADLHotelOrderaPayCell) {
                    [self.subBtnView addSubview:self.payLabel];
                    [self.subBtnView addSubview:self.actualPrice];
                }
    
    
    WS(ws);
    
    
    [self.hotelNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(ws.mas_right).offset(-160);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(@13);
      
    }];
    
    [self.payType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.hotelNameBtn.mas_top);
        make.height.mas_equalTo(@13);
       // make.width.mas_equalTo(@120);
        make.right.mas_equalTo(-20);
    }];
    
    //线条
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.hotelNameBtn.mas_bottom).offset(14);
        make.left.mas_equalTo(ws);
        make.right.mas_equalTo(ws);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.roomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.line1.mas_bottom).offset(14);
        make.left.mas_equalTo(ws.hotelNameBtn.mas_left);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(95);
    }];
    
    [self.roomeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.roomImage.mas_right).offset(10);
        make.right.mas_equalTo(ws.mas_right).offset(-150);
        make.top.mas_equalTo(ws.roomImage.mas_top).offset(5);
        make.height.mas_equalTo(16);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.roomeName.mas_top);
        make.height.mas_equalTo(@13);
        make.width.mas_equalTo(@120);
        make.right.mas_equalTo(-20);
    }];
    
    
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.roomeName.mas_left);
        make.right.mas_equalTo(ws.mas_right).offset(-20);
        make.top.mas_equalTo(ws.roomeName.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.roomeName.mas_left);
        make.right.mas_equalTo(ws.mas_right).offset(-20);
        make.top.mas_equalTo(ws.startTime.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.roomeName.mas_left);
        make.right.mas_equalTo(ws.mas_right).offset(-13);
        make.top.mas_equalTo(ws.endTime.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
//    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(ws.mas_bottom).offset(-10);
//        make.right.mas_equalTo(ws.mas_right).offset(-20);
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(30);
//    }];
//    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(ws.payBtn.mas_bottom);
//        make.right.mas_equalTo(ws.payBtn.mas_left).offset(-10);
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(30);
//    }];
    //线条
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ws.payBtn.mas_top).offset(-8);
        make.left.mas_equalTo(ws);
        make.right.mas_equalTo(ws);
        make.height.mas_equalTo(0.5);
    }];
    //线条
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ws.mas_bottom).offset(-2);
        make.left.mas_equalTo(ws);
        make.right.mas_equalTo(ws);
        make.height.mas_equalTo(2);
    }];
    [self.subBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ws.mas_bottom).offset(-10);
        make.left.mas_equalTo(ws);
        make.right.mas_equalTo(ws.mas_right);
     //   make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
 
    
    
    //已支付订单详情
    if (self.hotelOrderCell == ADLHotelOrderaPayCell) {
        [self.payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(ws.subBtnView.mas_bottom).offset(-10);
            make.left.mas_equalTo(ws.subBtnView.mas_left).offset(20);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(20);
        }];
        [self.actualPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(ws.subBtnView.mas_bottom).offset(-10);
            make.right.mas_equalTo(ws.subBtnView.mas_right).offset(-10);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(20);
        }];
    
    }else   //待支付订单详情
    if (self.hotelOrderCell == ADLHotelOrderafterSaleCell) {
        [self.actualPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(ws.subBtnView.mas_bottom).offset(0);
            make.left.mas_equalTo(ws.subBtnView.mas_left).offset(20);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(15);
        }];
        [self.payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(ws.actualPrice.mas_top).offset(-5);
            make.left.mas_equalTo(ws.subBtnView.mas_left).offset(20);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(12);
        }];
       
        }
   
 
}
-(UILabel *)payLabel {
    if (!_payLabel) {
        _payLabel = [self createLabelFrame:CGRectMake(0, 0,0, 0) font:10 text:ADLString(@"待支付") texeColor:COLOR_666666];
        //_payLabel.textAlignment = NSTextAlignmentRight;
    }
    return _payLabel;
}

-(UILabel *)actualPrice {
    if (!_actualPrice) {
        _actualPrice = [self createLabelFrame:CGRectMake(0, 0,0, 0) font:15 text:ADLString(@"待支付") texeColor:COLOR_E0212A];
        
   _actualPrice.textAlignment = NSTextAlignmentRight;
    }
    return _actualPrice;
}


-(UIButton *)hotelNameBtn {
    if (!_hotelNameBtn) {
        _hotelNameBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:@"jiantou1" title:@"酒店名称" titleColor:COLOR_333333 font:13 target:self action:@selector(numDateBtn:)];
        [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:_hotelNameBtn imageTitleSpace:10];
        _hotelNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
           _hotelNameBtn.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    }
    return _hotelNameBtn;
}
-(UILabel *)payType {
    if (!_payType) {
        _payType = [self createLabelFrame:CGRectMake(105, 10, SCREEN_WIDTH - 105 - 140, 30) font:12 text:ADLString(@"待支付") texeColor:COLOR_666666];
        _payType.textAlignment = NSTextAlignmentRight;
    }
    return _payType;
}
-(UIImageView *)roomImage {
    if (!_roomImage) {
        _roomImage = [[UIImageView alloc]init];
       // _roomImage.contentMode = UIViewContentModeScaleAspectFill;
       _roomImage.image = [UIImage imageNamed:@"jiudian2"];
    }
    return _roomImage;
}
-(UILabel *)roomeName {
    if (!_roomeName) {
        _roomeName = [self createLabelFrame:CGRectMake(105, 10, SCREEN_WIDTH - 105 - 140, 30) font:16 text:ADLString(@"维也纳酒店") texeColor:COLOR_333333];
        _roomeName.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    }
    return _roomeName;
}
-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [self createLabelFrame:CGRectMake(0, 0,0, 0) font:12 text:ADLString(@"100") texeColor:COLOR_666666];
               _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
-(UILabel *)startTime {
    if (!_startTime) {
        _startTime = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"入住时间:") texeColor:COLOR_666666];
    }
    return _startTime;
}
-(UILabel *)endTime {
    if (!_endTime) {
        _endTime = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"离开时间:") texeColor:COLOR_666666];
    }
    return _endTime;
}
-(UILabel *)address {
    if (!_address) {
        _address = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"离开时间:") texeColor:COLOR_666666];
    }
    return _address;
}
-(UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:@"" title:ADLString(@"去支付") titleColor:COLOR_333333 font:12 target:self action:@selector(numDateBtn:)];
        //[_payBtn setImage:[UIImage imageNamed:@"icon_hui"] forState:UIControlStateSelected];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"icon_hui"] forState:UIControlStateNormal];
    }
    return _payBtn;
}
-(UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:nil title:ADLString(@"取消") titleColor:COLOR_333333 font:12 target:self action:@selector(numDateBtn:)];
      [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"icon_hui"] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}
-(UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc]init];
        _line1.backgroundColor = COLOR_F7F7F7;
    }
    return _line1;
}
-(UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc]init];
        _line2.backgroundColor = COLOR_F7F7F7;
    }
    return _line2;
}
-(UIView *)line3 {
    if (!_line3) {
        _line3 = [[UIView alloc]init];
        _line3.backgroundColor = COLOR_F7F7F7;
    }
    return _line3;
}-(UIView *)subBtnView {
    if (!_subBtnView) {
        _subBtnView = [[UIView alloc]init];
    }
    return _subBtnView;
}
-(void)numDateBtn:(UIButton *)btn {
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
-(void)setModel:(ADLHotelOrderModel *)model {
    _model = model;
  [self.subBtnView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.hotelNameBtn setTitle:_model.companyName forState:UIControlStateNormal];
    if (self.hotelOrderCell == ADLHotelOrderistCell) {
     self.payType.text =[_model status:_model.status];
    }else {
        self.payType.text =[NSString stringWithFormat:@"%@: %@",ADLString(@"订单号"),model.roomSellOrderId];
        [self.payType sizeToFit];
    }
   
    [self.roomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.coverUrl]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    self.roomeName.text = _model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ :%@",ADLString(@"价格"),_model.payPrice];
    self.startTime.text = [NSString stringWithFormat:@"入住时间:%@",[ADLUtils getDateFromTimestamp:_model.startDatetime format:@"YYYY-MM-dd"]];
    self.endTime.text = [NSString stringWithFormat:@"离开时间:%@",[ADLUtils getDateFromTimestamp:_model.endDatetime format:@"YYYY-MM-dd"]];
    self.address.text = _model.address;
    
    //status:1.正常(完成)、2：取消（取消订单）(完成)，3：退款(完成)，4：待处理，5：待入住，6：售后，7 代付款，8 待分配房 9支付失败",
   // "isPay": "int 是否付款，0：未付款，1：已付款"
    // 0：全部，1：待支付（7 代付款），2：已支付（is_pay = 1：已付款），3：已完成（1：正常(完成)、3：退款(完成)），4：已取消（2：取消（取消订单））
    if (self.hotelOrderCell == ADLHotelOrderistCell) {
        [self addScoreView:[_model arraystatusType:_model.status isGrade:_model.isGrade refundStatus:_model.refundStatus]];
        
    }else  if (self.hotelOrderCell == ADLHotelOrderDetailsCell) {
        self.payType.hidden = YES;

        
    }else  if (self.hotelOrderCell == ADLHotelOrderaPayCell) {
        self.payLabel.text = [NSString stringWithFormat:@"%@:%@",ADLString(@"房间价格"),_model.payPrice];
        self.actualPrice.text = [NSString stringWithFormat:@"%@:%@",ADLString(@"实付价格"),_model.payPrice];
                _actualPrice.textAlignment = NSTextAlignmentLeft;
        
    }
    
    if (self.hotelOrderCell == ADLHotelOrderafterSaleCell) {
        [self addScoreView:[_model arraystatusType:10 isGrade:0 refundStatus:_model.refundStatus]];
    self.payLabel.text = [NSString stringWithFormat:@"%@:%@",ADLString(@"房间价格"),_model.payPrice];
    self.actualPrice.text = [NSString stringWithFormat:@"%@:%@",ADLString(@"实付价格"),_model.payPrice];
         _actualPrice.textAlignment = NSTextAlignmentLeft;
    }
    
}


-(void)addScoreView:(NSArray *)array{
    
    int margin = 10;//间隙
    int width = (SCREEN_WIDTH - 90)/5;;//格子的宽
    int height = 30;//格子的高
    int btnX =SCREEN_WIDTH - array.count*(margin+width);
    for (int i = 0; i <array.count; i++) {
        // int row = i/1;
        int col = i%array.count;
        UIButton * btn = [self createButtonFrame:CGRectMake(btnX + col*(width+margin), 0, width,  height) imageName:nil title:array[i] titleColor:COLOR_333333 font:12 target:self action:@selector(clicktagbtn:)];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_hui"] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_E0212A forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_biankuang"] forState:UIControlStateSelected];
        [self.subBtnView addSubview:btn];
        
    }
}
-(void)clicktagbtn:(UIButton *)btn {
    if (self.clicBlock) {
        self.clicBlock(btn);
    }
}
@end
