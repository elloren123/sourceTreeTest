//
//  ADLBlockchainOpenLockController.m
//  ADEL-APP
//
//  Created by adel on 2019/8/21.
//

#import "ADLBlockchainOpenLockController.h"
#import "ADLBlockchainQueryHeadView.h"
#import "ADLBlockchainQueryView.h"
//#import "XFDaterView.h"
#import "ADLLockqueryTimeView.h"
#import "ADLBasButton.h"
#import "ADLChainlockrecordController.h"
#import "ADLBlockChainQuerylogController.h"
#import "ADLBlockchainLockModel.h"
#import "ADLBlockchainLockView.h"
#import "ADLBlockchainpriceModel.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ADLHomeDateTimeView.h"
#import "ADLTimeOrStamp.h"
#import "ADLHotelOrderPayController.h"
#import "ADLKeyboardMonitor.h"
//#import "ADLStartStopDateView.h"
//#import "YBPopupMenu.h"
@interface ADLBlockchainOpenLockController ()<ADLHomeDateTimeViewDelegate,UITextFieldDelegate>
@property (nonatomic ,strong)UIView *backheadView;
@property (nonatomic ,strong)ADLBlockchainQueryHeadView *headView;
@property (nonatomic ,strong)ADLBlockchainQueryView *queryView;
@property (nonatomic ,strong)ADLLockqueryTimeView *lockqueryTimeView;
@property (nonatomic ,weak)UIScrollView *scrollView;
@property (nonatomic ,assign)NSInteger typtag;

@property (nonatomic ,strong)ADLBlockchainLockModel *model;
@property (nonatomic , copy)NSString *deviceId;

@property (nonatomic ,strong)NSString *orderId;
@property (nonatomic ,strong) NSMutableArray *gouponsArray;
@end

@implementation ADLBlockchainOpenLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_F2F2F2;
 
 
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
      scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 700);
     scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = [UIColor clearColor];
 
    
    self.scrollView = scrollView;
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,-NAVIGATION_H - 90, SCREEN_WIDTH, 440)];
    headImage.image = [UIImage imageNamed:@"background"];
    headImage.backgroundColor =COLOR_F2F2F2;
    
    //  headImage.userInteractionEnabled = NO;
    [scrollView  addSubview:headImage];
    [scrollView addSubview:self.backheadView];
    [scrollView addSubview:self.headView];
    [scrollView addSubview:self.queryView];
    [scrollView addSubview:self.lockqueryTimeView];
    
    [self.view addSubview:scrollView];
    
    
 
    
    UIButton *blockbtn = [self.view createButtonFrame:CGRectMake(10,NAVIGATION_H - 30,50, 30) imageName:nil title:nil titleColor:COLOR_666666 font:12 target:self action:@selector(addBarButton)];
    [blockbtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    // btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:blockbtn];
    
    [self blockchainpriceinfo];
 
   
}
//用户区块链查询 - 用户端查询
-(void)blockchainpriceinfo{
    //dict[@"F0FE6BF23EBA"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] =  @(1);
      params[@"sign"] = [ADLUtils handleParamsSign:params];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_blockchain_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        ADLLog(@"%@",responseDict);
        
        [ADLToast hide];
        
        if ([responseDict[@"code"] integerValue] == 10000) {
            
            ws.gouponsArray= [ADLBlockchainLockModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            if (ws.gouponsArray.count > 0) {
                
                ws.model = ws.gouponsArray[0];
                ws.deviceId = ws.model.deviceId;
                
                [ws.headView.lockbtn setTitle:ws.model.deviceName forState:UIControlStateNormal];
           
                
//             [ws.lockqueryTimeView.starttime setTitle:[ADLDateTool dateTimeday: ws.model.startDatetime] forState:UIControlStateNormal];
                [ws.lockqueryTimeView.starttime setTitle:[ADLUtils getDateFromTimestamp:[ws.model.startDatetime doubleValue] format:@"YYYY-MM-dd HH:mm:ss"] forState:UIControlStateNormal];
                 [ws.lockqueryTimeView.endtime setTitle:[ADLUtils getDateFromTimestamp:[ws.model.endDatetime doubleValue] format:@"YYYY-MM-dd HH:mm:ss"] forState:UIControlStateNormal];
//              [ws.lockqueryTimeView.endtime setTitle:[ADLDateTool dateTimeday: ws.model.endDatetime] forState:UIControlStateNormal];
//
//                NSInteger date = [ws contrastStarTime:[ADLDateTool dateTimeday: ws.model.startDatetime] endTime:[ADLDateTool dateTimeday: ws.model.endDatetime] dateType:NSCalendarUnitDay];
                //[NSString stringWithFormat:@"%@%ld%@",ADLString(@"查询权限还剩"),date,ADLString(@"天")]
              //  ws.lockqueryTimeView.remaining.text =[NSString stringWithFormat:@"%@%ld%@",ADLString(@"查询权限还剩"),date,ADLString(@"天")];
                //  1 永久，0：否"
                if ([ws.model.permanent isEqualToString:@"1"]) {
                    
                    ws.queryView.hidden = YES;
                    ws.lockqueryTimeView.hidden = NO;
                    ws.lockqueryTimeView.remaining.text =ADLString(@"查询权限永久");
                    [ws.lockqueryTimeView.endtime setTitle:ADLString(@"永久") forState:UIControlStateNormal];
                    
                    
                }else {
                    
                    if (ws.model.endDatetime.length > 0) {
                        
                        
                        if ([self compareDatestop:[ADLUtils getDateFromTimestamp:[self.model.endDatetime doubleValue] format:@"YYYY-MM-dd HH:mm"]]) {
                            ws.queryView.hidden = YES;
                            ws.lockqueryTimeView.hidden = NO;

                        }else {
                            ws.queryView.hidden = NO;
                            ws.lockqueryTimeView.hidden = YES;
                        }
                    }else {
                        ws.queryView.hidden = NO;
                        ws.lockqueryTimeView.hidden = YES;
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
     [ADLToast hide];
    }];
}
//支付购买
-(void)userblockchainpay{
 
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   // params[@"companyId"] =@"";//公司id
    params[@"deivceId"] =self.model.deviceId;//设备id
    params[@"priceRuleId"] =self.queryView.model.id;//价格规则id
    params[@"nums"] =self.queryView.dataField.text;//购买数量
    params[@"price"] =@(self.queryView.price);//原价单价
    params[@"discountsPrice"] =@(self.queryView.discountsPrice);//优惠单价
    params[@"buyUnit"] =@(self.queryView.buyUnit);//赠送单位 1：天，2：周，3：月，4：季，5：年    ，6：永久
    params[@"giveNum"] =@(self.queryView.giveNum);//赠送数量
    params[@"giveUnit"] =@(self.queryView.giveUnit);//赠送单位 1：天，2：周，3：月，4：季，5：年    ，6：永久
    params[@"payPrice"] =self.queryView.preferentialLabel.text;//购买总价格

    ADLHotelOrderPayController *VC= [[ADLHotelOrderPayController alloc]init];
    VC.payType =1;
    VC.dict = params;
    [self.navigationController pushViewController:VC animated:YES];
    
}
//微信支付回调
-(void)WXsafepayNotification:(NSNotification *)noit{
    //用户付款成功 用户端使用
    [self PaySuccessorderId:self.orderId type:@"1" result:@"2"];
    
}

//支付宝回调
-(void)paysafepayNotification:(NSNotification *)noit{
    
    NSDictionary *dict = noit.userInfo;
    NSDictionary *paydict = [self dictionaryWithJsonString:dict[@"result"]];
    NSDictionary *orderIddict =paydict[@"alipay_trade_app_pay_response"];
    [self PaySuccessorderId:orderIddict[@"out_trade_no"] type:@"2" result:dict[@"result"]];
}
//用户付款成功 用户端使用
-(void)PaySuccessorderId:(NSString *)orderId type:(NSString *)type result:(NSString *)result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"blockchainId"] = self.orderId; //区块链订单id
    params[@"type"] = type;//1 微信 2 淘宝 3 其它（网联
    if ([type isEqualToString:@"2"]) {
        params[@"result"] = result;//返回结果（支付宝）
    }
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_blockchainpay_result parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        // ADLLog(@"%@",response);
        [ADLToast hide];
        [ADLToast showMessage:responseDict[@"msg"]];
        
        if ([responseDict[@"code"] integerValue] == 10000) {
          //  [[NSNotificationCenter defaultCenter] postNotificationName:ADELreservationNotification object:nil userInfo:nil];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [ws.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
}

-(void)addBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
     CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:textField];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
    
    
    
}
-(UIView *)backheadView {
    if (!_backheadView) {
         _backheadView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 260)];
          _backheadView.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [self.view createLabelFrame:CGRectMake(20,NAVIGATION_H-30, SCREEN_WIDTH-40, 20) font:16 text:ADLString(@"区块链开锁记录") texeColor:[UIColor whiteColor]];
        title.textAlignment = NSTextAlignmentCenter;
        [_backheadView addSubview:title];

//        UIButton *blockbtn = [self.view createButtonFrame:CGRectMake(10,NAVIGATION_H - 30,50, 30) imageName:nil title:nil titleColor:nil font:nil target:self action:@selector(addBarButton)];
//        [blockbtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
//        // btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
//        [self.backheadView addSubview:blockbtn];
        
        UIButton *btn = [self.view createButtonFrame:CGRectMake(SCREEN_WIDTH/2 - 40,title.y +40,80, 30) imageName:nil title:ADLString(@"查询日志") titleColor:COLOR_E0212A font:12 target:self action:@selector(tagbtn:)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
       // btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        btn.backgroundColor =[UIColor whiteColor];
        [_backheadView addSubview:btn];
        
    }
    return _backheadView;
}
//查询日志
-(void)tagbtn:(UIButton *)btn{
    
    if (self.model.endDatetime.length > 0) {
        ADLBlockChainQuerylogController *vc = [[ADLBlockChainQuerylogController alloc]init];
        vc.LockName = self.model.deviceName;
        vc.stardate = self.model.startDatetime;
        vc.enddate = self.model.endDatetime;             vc.deviceId = self.model.deviceId;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [ADLToast showLoadingMessage:ADLString(@"你没有查询权限")];
    }


}
-(ADLBlockchainQueryHeadView *)headView {
    if (!_headView) {
        WS(ws);
        _headView = [[ADLBlockchainQueryHeadView alloc]initWithFrame:CGRectMake(10 ,NAVIGATION_H+80, SCREEN_WIDTH - 20, 124)];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.blockBtn = ^(UIButton * _Nonnull btn) {
            NSMutableArray *titleArray = [NSMutableArray array];
            for (ADLBlockchainLockModel *model in ws.gouponsArray) {
                
                [titleArray addObject:model.deviceName];
                
            }
            
            WS(ws);
            __block ADLBlockchainLockView *fameiyLockView = [[ADLBlockchainLockView alloc]init];
            fameiyLockView.gouponsArray = ws.gouponsArray;
            fameiyLockView.frame = CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT);
            fameiyLockView.devictBlock = ^(ADLBlockchainLockModel *model) {
       
                [ws blockchainLock:model];
            };
        };
    }
    _headView.layer.masksToBounds = YES;
    _headView.layer.cornerRadius = 5;
    return _headView;
}
-(void)blockchainLock:(ADLBlockchainLockModel *)model {
  
    self.model = model;
    self.deviceId = model.deviceId;
    self.queryView.hidden = YES;

    self.lockqueryTimeView.hidden = NO;
    [self.lockqueryTimeView.starttime setTitle:[ADLUtils getDateFromTimestamp:[model.startDatetime doubleValue] format:@"YYYY-MM-dd HH:mm:ss"] forState:UIControlStateNormal];

    [self.lockqueryTimeView.endtime setTitle:[ADLUtils getDateFromTimestamp:[model.endDatetime doubleValue] format:@"YYYY-MM-dd HH:mm:ss"] forState:UIControlStateNormal];
    NSInteger date = [self contrastStarTime:[ADLUtils getDateFromTimestamp:[model.startDatetime doubleValue] format:@"YYYY-MM-dd HH:mm:ss"] endTime:[ADLUtils getDateFromTimestamp:[model.endDatetime doubleValue] format:@"YYYY-MM-dd HH:mm:ss"] dateType:NSCalendarUnitDay];
    self.lockqueryTimeView.remaining.text =[NSString stringWithFormat:@"%@%ld%@",ADLString(@"查询权限还剩"),date,ADLString(@"天")];

    //  1 永久，0：否"
    if ([self.model.permanent isEqualToString:@"1"]) {
        self.queryView.hidden = YES;
        self.lockqueryTimeView.hidden = NO;

        self.queryView.hidden = YES;
        self.lockqueryTimeView.hidden = NO;
        self.lockqueryTimeView.remaining.text =ADLString(@"查询权限永久");
        [self.lockqueryTimeView.endtime setTitle:ADLString(@"永久") forState:UIControlStateNormal];
    }else {
        if (self.model.endDatetime.length > 0) {

            if ([self compareDatestop:[ADLUtils getDateFromTimestamp:[model.endDatetime doubleValue] format:@"YYYY-MM-dd HH:mm"]]) {
                self.queryView.hidden = YES;
                self.lockqueryTimeView.hidden = NO;

            }else {
                self.queryView.hidden = NO;
                self.lockqueryTimeView.hidden = YES;
            }
        }else {
            self.queryView.hidden = NO;
            self.lockqueryTimeView.hidden = YES;
        }
    }

    [self.headView.lockbtn setTitle:model.deviceName forState:UIControlStateNormal];

}
-(ADLBlockchainQueryView *)queryView {
    if (!_queryView) {
        _queryView = [[ADLBlockchainQueryView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.headView.frame)+8, SCREEN_WIDTH - 20, 460)];
        _queryView.backgroundColor = [UIColor whiteColor];
      //  [_queryView.dataField handleKeyboardShelterWithViewController:self];
       //0按天 1按周 2按月 3按季 4按年 5永久
        WS(ws);
        _queryView.blockdate = ^(UIButton * _Nonnull btn) {
            
        };
        _queryView.blockTime = ^(UIButton * _Nonnull btn) {
            ws.typtag = btn.tag;
            //开开始时间
            if (btn.tag == 0) {
                [ws subDataViewtype:0];
             
            }else  //结束始时间
             if (btn.tag == 1) {
                 [ws subDataViewtype:1];
        
             }else
                 //立即支付
                 if (btn.tag == 2) {
           //判断选择类型 ,天,周,月,季,年,永久
                     if (self.queryView.buyUnit == 0 ) {
           
                         [ADLToast showMessage:ADLString(@"请选择类型")];
                         return ;
                     }
                     if (self.queryView.buyUnit != 6) {
                         if (self.queryView.dataField.text.length == 0 ) {
                             [ADLToast showMessage:ADLString(@"请选择数量")];
                             return ;
                         }
                     }
                   
                     [self userblockchainpay];
       
                  
                  
             }
        };
    }
    _queryView.layer.masksToBounds = YES;
    _queryView.layer.cornerRadius = 5;
    return _queryView;
}

- (void)datetimeString:(NSString *)dateString{
    
    
    NSInteger title =[ADLTimeOrStamp compareDateseconds:[ADLUtils timestampWithDateStr:dateString format:@"YYYY-MM-dd HH:mm:ss"]];

    if (title == -1) {
        [ADLToast showMessage:ADLString(@"选择时间不能小于当前时间")];
        return ;
    }else {
       
    if (self.typtag == 1) {
       [self.queryView.startBtn setTitle:dateString forState:UIControlStateNormal];
    }
    
    if (self.typtag == 1) {
        
        
        NSString *start = [ADLUtils timestampWithDateStr:self.queryView.startBtn.titleLabel.text format:@"yyyy-MM-dd HH:mm"];
        
        dateString =[ADLUtils timestampWithDateStr:dateString format:@"yyyy-MM-dd HH:mm"];
    
        if ([ADLTimeOrStamp compareDate:start stop:dateString]) {

            [self.queryView.endBtn setTitle:dateString forState:UIControlStateNormal];
        }
      
    }
        //选择开始时间
    if (self.typtag == 2) {
        
        if (self.lockqueryTimeView.endBtn.titleLabel.text.length > 0) {
            NSInteger date = [self contrastStarTime:dateString endTime:self.lockqueryTimeView.endBtn.titleLabel.text dateType:NSCalendarUnitDay];
            if (date >  366) {
           
                     [ADLToast showMessage:ADLString(@"查询时间不能大于一年")];
            }else {
//                NSString *startlockquery = [ADLUtils timestampWithDateStr:self.lockqueryTimeView.startBtn.titleLabel.text format:@"yyyy-MM-dd HH:mm"];
           NSString * date =[ADLUtils timestampWithDateStr:dateString format:@"yyyy-MM-dd HH:mm"];
                
              if ([ADLTimeOrStamp compareDate:date stop:self.lockqueryTimeView.endBtn.titleLabel.text]) {

                    [self.lockqueryTimeView.startBtn setTitle:dateString forState:UIControlStateNormal];
                }
                
            }
            
        
            
        }else {
                [self.lockqueryTimeView.startBtn setTitle:dateString forState:UIControlStateNormal];
        }
      
    }
    //选择结束时间
    if (self.typtag == 3) {
        
        if (self.lockqueryTimeView.startBtn.titleLabel.text.length > 0) {
            NSInteger date = [self contrastStarTime:self.lockqueryTimeView.startBtn.titleLabel.text endTime:dateString dateType:NSCalendarUnitDay];
            
            if (date >  366) {
                   [ADLToast showMessage:ADLString(@"查询时间不能大于一年")];
             
            }else {
             
                NSString *startlockquery = [ADLUtils timestampWithDateStr:self.lockqueryTimeView.startBtn.titleLabel.text format:@"yyyy-MM-dd HH:mm"];
              NSString * date =[ADLUtils timestampWithDateStr:dateString format:@"yyyy-MM-dd HH:mm"];
                
                if ([ADLTimeOrStamp compareDate:startlockquery stop:date]) {
                    
                    [self.lockqueryTimeView.endBtn setTitle:dateString forState:UIControlStateNormal];
                }
            }
            
        }else {
           [self.lockqueryTimeView.endBtn setTitle:dateString forState:UIControlStateNormal];
        }
      
    
    }
        
    }
}

-(ADLLockqueryTimeView *)lockqueryTimeView {
    if (!_lockqueryTimeView) {
        _lockqueryTimeView = [[ADLLockqueryTimeView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.headView.frame)+8, SCREEN_WIDTH - 20, 460)];
        _lockqueryTimeView.backgroundColor = [UIColor whiteColor];
          WS(ws);
        _lockqueryTimeView.blockTime = ^(UIButton * _Nonnull btn) {
            ws.typtag = btn.tag;
            //开开始时间
            if (btn.tag == 2) {
                [ws subDataViewtype:2];
                
            }else  //结束始时间
        if (btn.tag == 3) {
            [ws subDataViewtype:3];
            
        }
            //查看开门记录
            if (btn.tag == 5) {
                if (ws.lockqueryTimeView.startBtn.titleLabel.text.length > 0) {
                    
                    if (ws.lockqueryTimeView.endBtn.titleLabel.text.length > 0) {
                        ADLChainlockrecordController *VC=[[ADLChainlockrecordController alloc]init];
                        VC.stardate = ws.lockqueryTimeView.startBtn.titleLabel.text;
                        VC.enddate = ws.lockqueryTimeView.endBtn.titleLabel.text;
                        VC.deviceId = ws.deviceId;
                        VC.LockName = ws.model.deviceName;
                        [ws.navigationController pushViewController:VC animated:YES];
                    }else {
                              [ADLToast showMessage:ADLString(@"请选择结束时间")];
                    
                    }
                }else {
                         [ADLToast showMessage:ADLString(@"请选择开始时间")];
                  
                }
             
            }
            
        };
    }
    _lockqueryTimeView.layer.masksToBounds = YES;
    _lockqueryTimeView.layer.cornerRadius = 5;
   // _lockqueryTimeView.hidden = YES;
    return _lockqueryTimeView;
}
//0 开始时间  1结束时间
-(void)subDataViewtype:(NSInteger)type{
    self.typtag = type;
    
    ADLHomeDateTimeView *pickerView = [[ADLHomeDateTimeView alloc] init];
    
    pickerView.delegate = self;
    pickerView.pickerViewMode = DatePickerViewDateTimeMode;
    if (self.typtag == 2) {
            pickerView.titleL.text = ADLString(@"选择开始时间");
    }else {
            pickerView.titleL.text = ADLString(@"选择结束时间");
    }

    [self.view addSubview:pickerView];
    [pickerView showDateTimePickerView];
    
    
    
//    XFDaterView *dater=[[XFDaterView alloc]initWithFrame:CGRectMake(0, 0, 120, 0)];
//    dater.dateViewType = XFDateViewTypeDate;
//    dater.delegate=self;
//    [dater showInView:self.view animated:YES];
//    WS(ws);
//   // ADLFameiyUserModel *model = self.dataArray[indexPath.row];
//    ADLStartStopDateView *dater=[[ADLStartStopDateView alloc]initWithFrame:CGRectMake(0, self.navH + 20, 90, 90)];
//    dater.endDateTyp = @"3";
//    dater.dateTyp = 3;
//   //dater.startData = [ADLDateTool dateTimeday:model.startDatetime];
//    dater.stopLabel.hidden= YES;
//    dater.startLabel.hidden = YES;
//    dater.startBtn.hidden = YES;
//    dater.stopBtn.hidden = YES;
//    dater.redView.hidden = YES;
//    dater.startStopDateBlock = ^(NSString *star, NSString *stop) {
//        [ws datetimeString:stop];
//    };
//    
//    [dater showInView:self.view animated:YES];
//    
    
}
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    //  self.textL.text = date;
//    self.checkTime =[NSString stringWithFormat:@"%@ %@",self.startTime,date];
//    [self.timebtn setTitle:[NSString stringWithFormat:@"  %@%@",ADLString(@"  预计到店时间"),self.checkTime] forState:UIControlStateNormal];
    
     [self datetimeString:date];
   
}

-(void)dealloc
{
//    [self.queryView.dataField handleDealloc];
//      [self.queryView.priceField handleDealloc];
//      [self.queryView.preferentialField handleDealloc];
 
}
//NSInteger date = [self starTime:self.starttime.titleLabel.text endTime:self.endtime.titleLabel.text]
//[NSString stringWithFormat:@"%@%ld%@",KLocalizableStr(@"查询权限还剩"),date,KLocalizableStr(@"天")]

-(NSInteger)contrastStarTime:(NSString *)starTime endTime:(NSString *)endTime dateType:(NSCalendarUnit)dateType{
    
    
    //创建两个日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSDate *startDate = [dateFormatter dateFromString:starTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = dateType;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    //打印
    ADLLog(@"%@",delta);
    //获取其中的"天"
    ADLLog(@"%ld",delta.day);
    
    return delta.day;
}

//比较两个日期大小 0 日期相等 1大 -1小
- (BOOL)compareDatestop:(NSString *)stop
{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *start=[dateformatter stringFromDate:currentDate];
    
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:start];
    dtb = [dateformater dateFromString:stop];
    NSComparisonResult result = [dta compare:dtb];
    
    if (result==NSOrderedSame)
    {

        //        相等    [ADLToast showMessage:ADLString(@"开始时间和结束时间不能相等")];
        return YES;
    }else if (result==NSOrderedAscending)
    {
        
        //aDate比date大
        return YES;
    }else if (result==NSOrderedDescending)
    {
   
    //    [ADLToast showMessage:ADLString(@"开始时间不能小于当前时间")];
        //aDate比date小
        return NO;
        
    }
    return YES;
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {/*JSON解析失败*/
        
        return nil;
    }
    return dic;
}
@end
