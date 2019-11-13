//
//  ADLBlockchainQueryView.m
//  ADEL-APP
//
//  Created by adel on 2019/8/21.
//

#import "ADLBlockchainQueryView.h"
#import "ADLBlockchainpriceModel.h"
#import "ADLNetWorkManager.h"
#import "ADELUrlpath.h"

@interface ADLBlockchainQueryView ()<UITextFieldDelegate>

@property (nonatomic,strong)UIImageView *backImage;
@property (nonatomic ,strong)NSArray *array;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)UIButton * btn;
@property (nonatomic ,strong)UIButton * okBtn;

@property (nonatomic ,strong)UIView * subView;





@property (nonatomic ,strong)UILabel *giving;//赠送

@property (nonatomic ,strong)UILabel *dateLabel;//购买天类型

@property (nonatomic ,assign)NSInteger date;
@end

@implementation ADLBlockchainQueryView

-(NSArray *)array {
    if (!_array) {
        _array = @[@"按天",@"按周",@"按月",@"按季",@"按年",@"永久"];
    }
    return _array;
}
-(NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"购买数量",@"开始时间",@"结束时间",@"原价(元)",@"优惠价(元)"];
    }
    return _titleArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backImage];
        [self addsubView];
        [self addSubview:self.okBtn];
        [self addSubview:self.subView];
        [self blockchainpriceinfo];
    }
    return self;
}

//用户区块链查询 - 用户端查询
-(void)blockchainpriceinfo{
    //dict[@"F0FE6BF23EBA"];
    WS(ws);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
       params[@"sign"] = [ADLUtils handleParamsSign:params];
   
 
    [ADLNetWorkManager postWithPath:ADEL_blockchain_priceinfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
       
      if ([responseDict[@"code"] integerValue] == 10000) {
          
        self.model = [ADLBlockchainpriceModel mj_objectWithKeyValues:responseDict[@"data"]];
          
         
        }
    } failure:^(NSError *error) {
      
    }];
}
-(void)addsubView
{
    UILabel *title = [self createLabelFrame:CGRectMake(20, 10, 100, 30) font:16 text:ADLString(@"选择类型") texeColor:COLOR_333333];
    [self addSubview:title];
    
    int margin = 10;//间隙
    
    int width = 80;//格子的宽
    
    int height = 20;//格子的高
    
    for (int i = 0; i < self.array.count; i++) {
        int row = i/3;
        int col = i%3;
        UIButton * btn = [self createButtonFrame:CGRectMake(20+col*(width+margin), 60+row*(height+margin), width,  height) imageName:nil title:self.array[i] titleColor:COLOR_333333 font:12 target:self action:@selector(tagbtn:)];
        [btn setImage:[UIImage imageNamed:@"icon_home_normallock"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_home_selectlock"] forState:UIControlStateSelected];
        [self addSubview:btn];
        btn.tag = i;
    }

    [self titleView];
  
}

-(void)titleView {
    
    int margin = 10;//间隙
    
    int width = 80;//格子的宽
    
    int height = 20;//格子的高
    for (int i = 0; i <self.titleArray.count; i++) {
        int row = i/1;
        int col = i%1;
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(20+col*(width+margin),130+row*(height+margin), width, height);
        label.text = self.titleArray[i];
        label.textColor = COLOR_333333;
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
     
      //  UILabel *title;
            if (i == 0) {
                UITextField *dataField  = [[UITextField alloc]init];
                dataField.font = [UIFont systemFontOfSize:12];
                dataField.frame =CGRectMake(CGRectGetMaxX(label.frame) +col*(width+margin), label.y, SCREEN_WIDTH/3, height);
                // dataField.contentMode = UIViewContentModeScaleAspectFill;
//                dataField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                dataField.borderStyle = UITextFieldViewModeAlways;
                dataField.layer.masksToBounds = YES;
                dataField.layer.borderColor = COLOR_CCCCCC.CGColor;
                dataField.layer.borderWidth = 0.5;
                dataField.layer.cornerRadius = 2;
                dataField.delegate  = self;
                [self addSubview:dataField];
                
                dataField.enabled = YES;
                
                  UILabel *giving = [self createLabelFrame:CGRectMake(CGRectGetMaxX(dataField.frame)+10,label.y, SCREEN_WIDTH/3 - 30, height) font:12 text:ADLString(@"买一送一周") texeColor:COLOR_333333];
                [self addSubview:giving];
                self.giving = giving;
                self.giving.hidden = YES;
                
                
                self.dateLabel = label;
                self.dataField =dataField;
             
            }
       
      
        if (i > 2) {
            UILabel *datetLabel = [self createLabelFrame:CGRectMake(CGRectGetMaxX(label.frame) +col*(width+margin),label.y, SCREEN_WIDTH/3 - 30, height) font:12 text:@"0.00" texeColor:COLOR_666666];
            [self addSubview:datetLabel];
            if (i == 3) {
                
                self.priceLabel = datetLabel;
                self.priceLabel.textColor = COLOR_666666;
                
            }else if (i == 4) {
                //  self.preferential = datetLabel;
             
                  self.preferentialLabel = datetLabel;
            }
//            else if (i == 5) {
//
//                self.preferentialLabel = datetLabel;
//               // self.preferentialLabel.backgroundColor = [UIColor yellowColor];
//            }
      
        }else   if (i == 1 || i == 2) {
            UIButton *startBtn = [self createButtonFrame:CGRectMake(CGRectGetMaxX(label.frame) +col*(width+margin), label.y, SCREEN_WIDTH/2, height) imageName:nil title:nil titleColor:COLOR_333333 font:12 target:self action:@selector(messageBtn:)];
            startBtn.tag = 0;
            startBtn.enabled = NO;
            startBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            startBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            //startBtn.backgroundColor =Colorad2f2d;
            startBtn.layer.masksToBounds = YES;
            startBtn.layer.borderColor = COLOR_CCCCCC.CGColor;
            startBtn.layer.borderWidth = 0.5;
            startBtn.layer.cornerRadius = 2;
          //  startBtn.backgroundColor = [UIColor yellowColor];
           
            [self addSubview:startBtn];
          
            if (i == 1) {
                self.startBtn= startBtn;
            }
            if (i == 2) {
                self.endBtn= startBtn;
            }
        }
    }
  
}

-(void)tagbtn:(UIButton *)btn {
    self.btn.selected = NO;
    btn.selected = YES;
    self.btn = btn;
    
    NSString *datestr = self.dataField.text;;
    CGFloat  date = [datestr floatValue];
    
    if (self.blockdate) {
        self.blockdate(btn);
    }
       self.giving.hidden = NO;
    self.date  = 0;
    switch (btn.tag) {
        case 0: //按天
       //self.date = [datestr floatValue];
              self.date = date;
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.dayPrice];//原价
                self.preferential.text = [NSString stringWithFormat:@"%.2f",self.model.dayDiscountsPrice];//优惠价
                   self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.dayPrice - self.model.dayDiscountsPrice];//优惠后价
            self.giving.text = [NSString stringWithFormat:@"买1天送%d %@",self.model.dayGiveNum, [self weekGiveUnitnumber:self.model.dayGiveUnit date:self.model.dayGiveNum]];//买送
            self.dateLabel.text = ADLString(@"购买天");
            self.dataField.placeholder = ADLString(@"选择购买天数");
            self.date = [self.dataField.text integerValue] + self.model.dayGiveNum*1;
            
            self.price = self.model.dayPrice;
            self.discountsPrice = self.model.dayDiscountsPrice;
            
            break;
        case 1://按周
                self.date =date*7;
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice];//原价
            self.preferential.text = [NSString stringWithFormat:@"%.2f",self.model.weekDiscountsPrice];//优惠价
            self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice - self.model.weekDiscountsPrice];//优惠后价
            self.giving.text = [NSString stringWithFormat:@"买1周送%d %@",self.model.weekGiveNum,[self weekGiveUnitnumber:self.model.weekGiveUnit date:self.model.weekGiveNum]];//买送
             self.dateLabel.text = ADLString(@"购买周");
            self.dataField.placeholder = ADLString(@"选择购买几周");
               self.date = [self.dataField.text integerValue] + self.model.weekGiveNum*7;
            
            self.price = self.model.weekPrice;
            self.discountsPrice = self.model.weekDiscountsPrice;
            break;
        case 2://按月
             self.date =date*30;
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.monthPrice];//原价
            self.preferential.text = [NSString stringWithFormat:@"%.2f",self.model.monthDiscountsPrice];//优惠价
            self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice - self.model.weekDiscountsPrice];//优惠后价
            self.giving.text = [NSString stringWithFormat:@"买1月送%d %@",self.model.monthGiveNum,[self weekGiveUnitnumber:self.model.monthGiveUnit date:self.model.monthGiveNum]];//买送
              self.dateLabel.text = ADLString(@"购买月");
            self.dataField.placeholder = ADLString(@"选择购买几月");
            
                self.date = [self.dataField.text integerValue] + self.model.monthGiveNum*30;
            
            
            self.price = self.model.monthPrice;
            self.discountsPrice = self.model.monthDiscountsPrice;
            break;
        case 3://按季
               self.date =date*90;
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.seasonPrice];//原价
            self.preferential.text = [NSString stringWithFormat:@"%.2f",self.model.seasonDiscountsPrice];//优惠价
            self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice - self.model.weekDiscountsPrice];//优惠后价
            self.giving.text = [NSString stringWithFormat:@"买1季送%d %@",self.model.seasonGiveNum,[self weekGiveUnitnumber:self.model.seasonGiveUnit date:self.model.seasonGiveNum]];//买送
                 self.dateLabel.text = ADLString(@"购买季");
            self.dataField.placeholder = ADLString(@"选择购买几季");
            
               self.date = [self.dataField.text integerValue] + self.model.seasonGiveNum*120;
            
            
            self.price = self.model.seasonPrice;
            self.discountsPrice = self.model.seasonDiscountsPrice;
            break;
            
        case 4://按年
                self.date =date*365;
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.yearPrice];//原价
            self.preferential.text = [NSString stringWithFormat:@"%.2f",self.model.yearDiscountsPrice];//优惠价
            self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice - self.model.weekDiscountsPrice];//优惠后价
            self.giving.text = [NSString stringWithFormat:@"买1年送%d %@",self.model.yearGiveNum,[self weekGiveUnitnumber:self.model.yearGiveUnit date:self.model.yearGiveNum]];//买送
                   self.dateLabel.text = ADLString(@"购买年");
                     self.dataField.placeholder = ADLString(@"选择购买几年");
                self.date = [self.dataField.text integerValue] + self.model.seasonGiveNum*365;
            self.price = self.model.yearPrice;
            self.discountsPrice = self.model.yearDiscountsPrice;
            break;
        case 5://永久
//            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.permanentPrice];//原价
//            self.preferential.text = [NSString stringWithFormat:@"%.2f",self.model.permanentDiscountsPrice];//优惠价
//            self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice - self.model.weekDiscountsPrice];//优惠后价
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.permanentPrice];//原价
            self.preferential.text = [NSString stringWithFormat:@"%.2f",self.model.permanentDiscountsPrice];//优惠价
            self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice - self.model.permanentDiscountsPrice];//优惠后价
            [self.okBtn setTitle:[NSString stringWithFormat:@"   %@ \n%@",self.preferentialLabel.text,ADLString(@"立即支付")] forState:UIControlStateNormal];
            
            self.price = self.model.permanentPrice;
            self.discountsPrice = self.model.permanentDiscountsPrice;
            self.giving.text = ADLString(@"永久免费");
             self.dateLabel.text = ADLString(@"永久");
            
            self.buyUnit =6;
            self.giveUnit =0;
            break;
            
        default:
            break;
    }
    
   
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *datestr = textField.text;
    CGFloat  date = [datestr floatValue];
    [self tagbtn:self.btn];
  
}
//weekGiveUnit  类型
//date 赠送数量,
-(NSString *)weekGiveUnitnumber:(NSInteger )weekGiveUnit date:(NSInteger)date{
    
    NSString *datestr = self.dataField.text;
    CGFloat  dasy = [datestr floatValue];
    //giveUnit    int    2    购买单位 1：天，2：周，3：月，4：季，5：年    ，6：永久
    //giveNum    int    5    赠送数量
    //buyUnit    int    2    赠送单位 1：天，2：周，3：月，4：季，5：年    ，6：永久
    self.giveNum =date;
    self.buyUnit =weekGiveUnit;
    self.giveUnit = self.btn.tag + 1;

    switch (weekGiveUnit) {
        case 1:

            if (self.btn.tag == 0) {
                //购买天数*1 +  赠送天数
                self.date =dasy*1+dasy*date;
            } if (self.btn.tag == 1) {
                //购买天数*7 +  赠送天数
                self.date =dasy*7+dasy*date;
            } if (self.btn.tag == 2) {
                //购买天数*30 +  赠送天数
                self.date =dasy*30+dasy*date;
            } if (self.btn.tag == 3) {
                //购买天数*90 +  赠送天数
                self.date =dasy*90+dasy*date;
            } if (self.btn.tag == 4) {
                //购买天数*365 +  赠送天数
                self.date =dasy*90+dasy*date;
            }
           [self Calculatetheprice:self.date];
            return ADLString(@"天");
            break;
        case 2:
          
            if (self.btn.tag == 0) {
                //购买天数*1 +  赠送 周数
                self.date =dasy*1+dasy*(date*7);
            } if (self.btn.tag == 1) {
                //购买天数*7 +  赠送 周数
                self.date =dasy*7+dasy*(date*7);
            } if (self.btn.tag == 2) {
                //购买天数*30 +  赠送 周数
                self.date =dasy*30+dasy*(date*7);
            } if (self.btn.tag == 3) {
                //购买天数*90 +  赠送 周数
                self.date =dasy*90+dasy*(date*7);
            } if (self.btn.tag == 4) {
                //购买天数*365 +  赠送 周数
                self.date =dasy*90+dasy*(date*7);
            }
//            self.date =date*7+self.date;
           [self Calculatetheprice:self.date];
            return ADLString(@"周");
            break;
        case 3:
          
            if (self.btn.tag == 0) {
                //购买天数*1 +  赠送 周数
                self.date =dasy*1+dasy*(date*30);
            } if (self.btn.tag == 1) {
                //购买天数*7 +  赠送 周数
                self.date =dasy*7+dasy*(date*30);
            } if (self.btn.tag == 2) {
                //购买天数*30 +  赠送 周数
                self.date =dasy*30+dasy*(date*30);
            } if (self.btn.tag == 3) {
                //购买天数*90 +  赠送 周数
                self.date =dasy*90+dasy*(date*30);
            } if (self.btn.tag == 4) {
                //购买天数*365 +  赠送 周数
                self.date =dasy*90+dasy*(date*30);
            }
//               self.date =date*30+self.date;
               [self Calculatetheprice:self.date];
            return ADLString(@"月");
            break;
        case 4:
         
            if (self.btn.tag == 0) {
                //购买天数*1 +  赠送 周数
                self.date =dasy*1+dasy*(date*90);
            } if (self.btn.tag == 1) {
                //购买天数*7 +  赠送 周数
                self.date =dasy*7+dasy*(date*90);
            } if (self.btn.tag == 2) {
                //购买天数*30 +  赠送 周数
                self.date =dasy*30+dasy*(date*90);
            } if (self.btn.tag == 3) {
                //购买天数*90 +  赠送 周数
                self.date =dasy*90+dasy*(date*90);
            } if (self.btn.tag == 4) {
                //购买天数*365 +  赠送 周数
                self.date =dasy*90+dasy*(date*90);
            }
//                self.date =date*90+self.date;
             [self Calculatetheprice:self.date];
            return ADLString(@"季");
            break;
        case 5:
         
            if (self.btn.tag == 0) {
                //购买天数*1 +  赠送 周数
                self.date =dasy*1+dasy*(date*365);
            } if (self.btn.tag == 1) {
                //购买天数*7 +  赠送 周数
                self.date =dasy*7+dasy*(date*365);
            } if (self.btn.tag == 2) {
                //购买天数*30 +  赠送 周数
                self.date =dasy*30+dasy*(date*365);
            } if (self.btn.tag == 3) {
                //购买天数*90 +  赠送 周数
                self.date =dasy*90+dasy*(date*365);
            } if (self.btn.tag == 4) {
                //购买天数*365 +  赠送 周数
                self.date =dasy*90+dasy*(date*365);
            }

     [self Calculatetheprice:self.date];
            
            return ADLString(@"年");
            break;
            
            
        case 6:
    
         //   [self Calculatetheprice:self.date];
            return ADLString(@"永久");
            break;
        default:
            break;
    }
    return nil;
}

-(void)Calculatetheprice:(NSInteger )date {
    [self incomingDays:date];
    NSString *datestr = self.dataField.text;
    CGFloat  dasy = [datestr floatValue];
 
    switch (self.btn.tag) {
        case 0: //按天
            if (self.model.dayDiscountsPrice > 0  ) {
                self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.dayPrice*dasy];//原价
                self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.dayDiscountsPrice*dasy];//优惠价
                //   self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.dayPrice*dasy - self.model.dayDiscountsPrice*dasy];//优惠后价
            }else {
                self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.dayPrice*dasy];//原价
            }
         
            [self.okBtn setTitle:[NSString stringWithFormat:@"   %@ \n%@",self.preferentialLabel.text,ADLString(@"立即支付")] forState:UIControlStateNormal];
            
            break;
        case 1://按周
           // dasy =dasy*7;
            if (self.model.weekDiscountsPrice > 0) {
                
                self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice*dasy];//原价
                self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekDiscountsPrice*dasy];//优惠价
                // self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice*dasy - self.model.weekDiscountsPrice*dasy];//优惠后价
          
            }else {
               self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice*dasy];//原价
            }
                  [self.okBtn setTitle:[NSString stringWithFormat:@"   %@ \n%@",self.preferentialLabel.text,ADLString(@"立即支付")] forState:UIControlStateNormal];
         
            break;
        case 2://按月
           // dasy =dasy*30;
            
            if (self.model.monthDiscountsPrice > 0) {
                self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.monthPrice*dasy];//原价
                self.preferentialLabel.text= [NSString stringWithFormat:@"%.2f",self.model.monthDiscountsPrice*dasy];//优惠价
                // self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice*dasy - self.model.weekDiscountsPrice*dasy];//优惠后价
              
                
            }else {
                self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.monthPrice*dasy];//原价
            }
         [self.okBtn setTitle:[NSString stringWithFormat:@"   %@ \n%@",self.preferentialLabel.text,ADLString(@"立即支付")] forState:UIControlStateNormal];
            break;
        case 3://按季
          //  dasy =dasy*90;
            if (self.model.seasonDiscountsPrice > 0) {
                self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.seasonPrice*dasy];//原价
                self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.seasonDiscountsPrice*dasy];//优惠价
                //self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice*dasy - self.model.weekDiscountsPrice*dasy];//优惠后价
           
            }else {
                  self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.seasonPrice*dasy];//原价
            }
             [self.okBtn setTitle:[NSString stringWithFormat:@"   %@ \n%@",self.preferentialLabel.text,ADLString(@"立即支付")] forState:UIControlStateNormal];
            break;
            
        case 4://按年
           // dasy =dasy*365;
            if (self.model.yearDiscountsPrice > 0) {
                self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.yearPrice*dasy];//原价
                self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.yearDiscountsPrice*dasy];//优惠价
            }else {
                          self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.yearPrice*dasy];//原价
            }
    
           // self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.weekPrice*dasy - self.model.weekDiscountsPrice*dasy];//优惠后价
              [self.okBtn setTitle:[NSString stringWithFormat:@"   %@ \n%@",self.preferentialLabel.text,ADLString(@"立即支付")] forState:UIControlStateNormal];
            break;
        case 5://永久
            if (self.model.permanentDiscountsPrice > 0) {
                self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.permanentPrice];//原价
                self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.permanentDiscountsPrice];//优惠价
            }else {
              self.preferentialLabel.text = [NSString stringWithFormat:@"%.2f",self.model.permanentPrice];//优惠价
            }
    
              [self.okBtn setTitle:[NSString stringWithFormat:@"   %@ \n%@",self.preferentialLabel.text,ADLString(@"立即支付")] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}
-(void)messageBtn:(UIButton *)btn{
    
    if (self.blockTime) {
        self.blockTime(btn);
    }
}
-(UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [self createButtonFrame:CGRectMake(20, 320, self.width - 40, 45) imageName:@"" title:ADLString(@"立即支付") titleColor:[UIColor whiteColor] font:12 target:self action:@selector(messageBtn:)];
         _okBtn.tag = 2;
        _okBtn.backgroundColor =COLOR_E0212A;
        _okBtn.titleLabel.lineBreakMode = 0;
        _okBtn.layer.masksToBounds = YES;
//        _okBtn.layer.borderColor = Colorad2f2d.CGColor;
//        _okBtn.layer.borderWidth = 1;
        _okBtn.layer.cornerRadius = 5;
    }
    return _okBtn;
}
-(UIView *)subView {
    if (!_subView) {
        _subView = [[UIView alloc]initWithFrame:CGRectMake(0, self.okBtn.y+40, self.width, 80)];
        
        UILabel *title = [self createLabelFrame:CGRectMake(0, 10,_subView.width, 18)  font:16 text:ADLString(@"区块链应用说明") texeColor:COLOR_E0212A];
        title.textAlignment = NSTextAlignmentCenter;
        [_subView addSubview:title];
        
        UILabel *cont = [self createLabelFrame:CGRectMake(20,title.y+20,_subView.width-40, 60) font: 8 text:ADLString(@"10 袁") texeColor:COLOR_999999];
        cont.text = @"    锁老大产品采用区块链账本写入门锁信息,区块链是去中心化,分布式加密账本,应用其写入的历史信息不可篡改的特性,并实时公布信息加密s后的特征码给用户,广大用户都可以通过特征码j验证账本的历史数据的正确性,极大的提升锁老大产品的数据信息的可靠性和可信度";
        cont.numberOfLines = 0;
        [_subView addSubview:cont];
        
    }
    return _subView;
}
//1天  --  7天
-(void)datestr:(NSInteger)date {
    NSInteger dis = date; //前后的天数
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    
    self.startBtn.titleLabel.text =currentString;
    
    NSDate* theDate;
    
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        
        theDate = [currentDate initWithTimeIntervalSinceNow: +oneDay*dis ];
        //or
        // theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
    }
    else
    {
        theDate = currentDate;
    }
    
    NSDateFormatter *theDateformatter = [[NSDateFormatter alloc] init];
    [theDateformatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *string=[theDateformatter stringFromDate:theDate];
    
    self.endBtn.titleLabel.text = string;
}

//传天数返回当前时间和结束时间
-(void)incomingDays:(NSInteger)date {
    NSInteger dis = date; //前后的天数
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    
    [self.startBtn setTitle:currentString forState:UIControlStateNormal];
    
    NSDate* theDate;
    
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        
        theDate = [currentDate initWithTimeIntervalSinceNow: +oneDay*dis ];
        //or
        // theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
    }
    else
    {
        theDate = currentDate;
    }
    
    NSDateFormatter *theDateformatter = [[NSDateFormatter alloc] init];
    [theDateformatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *string=[theDateformatter stringFromDate:theDate];
     [self.endBtn setTitle:string forState:UIControlStateNormal];

}
@end
