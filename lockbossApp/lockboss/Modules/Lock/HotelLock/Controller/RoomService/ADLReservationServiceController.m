//
//  ADLReservationServiceController.m
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLReservationServiceController.h"
#import "ADLServiceTableViewCell.h"
#import "ADLReservationServiceCell.h"
#import "ADLHomeServiceModel.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ADLFoterServiceView.h"
#import "HZCalendarViewController.h"
#import "ADLPaymentPageView.h"
#import "ADLAttachView.h"
@interface ADLReservationServiceController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)NSMutableArray *modelArray;
@property (nonatomic ,strong)NSMutableArray *roomArray;
@property (nonatomic,copy)NSString *startDate;
@property (nonatomic,copy)NSString *endDate;
@property (nonatomic,weak)UILabel* label;
@property (nonatomic ,copy)NSString *online;//线上/线下房型
@property (nonatomic ,copy)NSString *orderId;//生成订单号
@property (nonatomic, assign) CGRect attachF;
@property (nonatomic ,strong)ADLFoterServiceView *footerView;
@end

@implementation ADLReservationServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.image];
    [self.view addSubview:self.tableView];
    
   [self addRedNavigationView:ADLString(@"预订服务")];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.tableHeaderView = self.titleLabel;
    
    
    //续费     //换房
    if ([self.model.templateId isEqualToString:@"2"] || [self.model.templateId isEqualToString:@"3"]) {
        [self roomSellTypecurrent];
    }
    
}
//查询当前用户入住的销售房型
-(void)roomSellTypecurrent{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"roomId"] = self.model.roomId;
    params[@"sign"] = [ADLUtils handleParamsSign:params];
//1121226186257731584
    WS(ws);
 
    [ADLNetWorkManager postWithPath:ADEL_roomSellType_current parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
      
        if ([responseDict[@"code"] integerValue] == 10000) {
            ADLHomeServiceModel *model = [ADLHomeServiceModel mj_objectWithKeyValues:responseDict[@"data"]];
            ws.model.roomTypePrice = model.roomTypePrice;
            ws.model.roomId = model.roomId;

            if (model.roomTypeId.length > 0) {
                ws.online = @"线下";
                ws.model.roomTypeId = model.roomTypeId;
            }else {
                ws.online = @"线上";
                ws.model.roomSellTypeId = model.roomSellTypeId;
            }

            //1退房 2 续费 3换房
            if ([self.model.templateId isEqualToString:@"2"] ) {
                ws.modelArray[4] = [NSString stringWithFormat:@"%.2f",model.roomTypePrice];
                ws.modelArray[5] = [NSString stringWithFormat:@"%.2f",model.roomTypePrice];
            }else  if ([self.model.templateId isEqualToString:@"3"]) {
                ws.modelArray[2] = [NSString stringWithFormat:@"%.2f",model.roomTypePrice];
                ws.modelArray[3] = [NSString stringWithFormat:@"%.2f",model.roomTypePrice];
                ws.modelArray[4] = @"0";
            }

            [ws.tableView reloadData];
        }else {
         
        }
    } failure:^(NSError *error) {
     
        
      
    }];
    
    
}


-(NSArray *)array {
    
    if (!_array) {
        if ([self.model.templateId isEqualToString:@"2"]) {
  _array =@[@"",ADLString(@"退房时间:"),ADLString(@"续房时间:"),ADLString(@"续房天数:"),ADLString(@"房价:"),ADLString(@"应补差价:"),ADLString(@"服务描述:")];
        }else   if ([self.model.templateId isEqualToString:@"3"]) {
            _array =@[@"",ADLString(@"更换房型:"),ADLString(@"房价:"),ADLString(@"原房价:"),ADLString(@"应补差价:"),ADLString(@"服务描述:")];
        }else   {
            _array =@[@"",ADLString(@"服务描述:")];
            
        }
        
    }
    return _array;
}
//1退房 2 续费 3换房
-(NSMutableArray *)modelArray {
    if (!_modelArray) {
        //_modelArray = [NSMutableArray arrayWithArray:self.array];
        
        if ([self.model.templateId isEqualToString:@"2"]) {
            NSTimeInterval second = self.model.endDatetime.longLongValue / 1000.0;
            NSDate * date =[NSDate dateWithTimeIntervalSince1970:second];
            NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
            self.endDate =[self dateString:nextDay format:@"yyyy-MM-dd"];
            _modelArray = [NSMutableArray arrayWithObjects:@" ",[ADLUtils getDateFromTimestamp:[_model.endDatetime doubleValue] format:@"YYYY-MM-dd"],[self dateString:nextDay format:@"yyyy-MM-dd"],@"1",@"",@"",self.model.des,nil];
        }else   if ([self.model.templateId isEqualToString:@"3"]) {
            
            NSString *chargeAmount =[NSString stringWithFormat:@"%0.2f",self.model.chargeAmount];
            _modelArray = [NSMutableArray arrayWithObjects:@"",self.model.roomTypeName,@"",chargeAmount,@"",self.model.des,nil];
        }else   {
            _modelArray = [NSMutableArray arrayWithObjects:@"",self.model.des,nil];
        }
    }
    return _modelArray;
}
-(NSMutableArray *)roomArray {
    if (!_roomArray) {
        _roomArray = [NSMutableArray array];
    }
    return _roomArray;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        ADLServiceTableViewCell* cell = [ADLServiceTableViewCell cellWithTableView:tableView];
        cell.orderLabel.hidden = YES;
        cell.servicetype.hidden = NO;
        cell.orderType.hidden = YES;
        cell.serviceModel = self.model;
        return cell;
    }else {
        ADLReservationServiceCell* cell = [ADLReservationServiceCell cellWithTableView:tableView];
        cell.lockName.text = self.array[indexPath.row];
        if ([self.model.templateId isEqualToString:@"3"]) {
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                NSString *title = self.modelArray[indexPath.row];
                if (title.length > 0) {
                    cell.switchBtn.hidden = YES;
                    cell.title.hidden = NO;
                    cell.title.text = title;
                [cell.switchBtn setImage:[UIImage imageNamed:@"icon_service_upate"] forState:UIControlStateNormal];
                }else {
                    cell.switchBtn.hidden = NO;
                    [cell.switchBtn setTitle:ADLString(@"选择房型") forState:UIControlStateNormal];
                    [cell.switchBtn setImage:[UIImage imageNamed:@"icon_service_upate"] forState:UIControlStateNormal];
                    cell.title.hidden = YES;
                }
                
                
            }else {
                cell.title.hidden = NO;
                cell.switchBtn.hidden = YES;
                cell.title.text = self.modelArray[indexPath.row];
            }
            if (indexPath.row == 1) {
                self.label =cell.title;
        
            }
            if (indexPath.row == 4) {
                self.attachF = CGRectMake(100, cell.y, cell.width - 100, 44);
                
            }
     
            return cell;
            
        } else {
            ADLLog(@"%@",self.modelArray[indexPath.row]);
            if (indexPath.row == 2) {
           
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                NSString *title = self.modelArray[indexPath.row];
                if (title.length > 0) {
                    
                    cell.title.hidden = YES;
                    cell.switchBtn.hidden = NO;
                    [cell.switchBtn setTitle:title forState:UIControlStateNormal];
                    
                }else {
                    cell.switchBtn.hidden = NO;
                    [cell.switchBtn setTitle:ADLString(@"选择时间") forState:UIControlStateNormal];
                    cell.title.hidden = YES;
                }
            }else {
                cell.title.hidden = NO;
                cell.switchBtn.hidden = YES;
                cell.title.text = self.modelArray[indexPath.row];
            }
            if (indexPath.row == 1) {
                self.label =cell.title;
            }
            return cell;
            //换房
        }
        
    }
    return nil;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [self.view endEditing:YES];
    if ([self.model.templateId isEqualToString:@"2"]) {
        if (indexPath.row == 2) {
            [self selectTime];
        }
    }else if([self.model.templateId isEqualToString:@"3"]){
        if (indexPath.row == 1) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"companyId"] =  self.model.companyId;
            params[@"sign"] = [ADLUtils handleParamsSign:params];
        WS(ws);
            
            //查询线上
        
        [ADLNetWorkManager postWithPath:ADEL_roomSellType_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
           [ws.roomArray  removeAllObjects];
            if ([responseDict[@"code"] integerValue] == 10000) {
                self.roomArray = [ADLHomeServiceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
                if (self.roomArray.count > 0) {
                    ws.online = @"线上";
                   
                    NSMutableArray *titleArray = [NSMutableArray array];
                    for (ADLHomeServiceModel *mode in  self.roomArray) {
                        [titleArray addObject:mode.name];
                    }
                      CGRect aframe = self.attachF;
                    aframe.size.height = titleArray.count * 44;
                    [ADLAttachView showWithFrame:aframe titleArr:titleArray finish:^(NSInteger index) {
                        [ws chooseRoomtIndex:index];
                    }];
                }else {
                    //查询线下的
                    [ws queryOfflineroom];
                }
                
                
            }else {
                
                [ADLToast showMessage:responseDict[@"msg"]];
            }
          
        } failure:^(NSError *error) {
            
            
            
        }];
        
        
        
    }
    
}
}
-(void)chooseRoomtIndex:(NSInteger)index{
    self.model =self.roomArray[index];
    self.modelArray[1] =  self.model.name;
    self.modelArray[2] = [NSString stringWithFormat:@"%.2f",[self.model.price floatValue]];
    CGFloat price =[self.model.price floatValue] - self.model.roomTypePrice;
    
    // NSTimeInterval addDatetime = self.model.startDatetime.longLongValue / 1000.0;
    NSTimeInterval endDatetime = self.model.endDatetime.longLongValue / 1000.0;
    NSInteger date = [self calcDaysFromBegin:[NSDate date] end:[NSDate dateWithTimeIntervalSince1970:endDatetime]];
    if (price > 0) {
        self.modelArray[4] =[NSString stringWithFormat:@"%.2f",price*date];
    }else {
        self.modelArray[4] =@"0.0";
    }
    
    [self.tableView reloadData];
}
//查询线下客房
-(void)queryOfflineroom{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyId"] =  self.model.companyId;
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_roomTypeManage_search parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.roomArray = [ADLHomeServiceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            if (self.roomArray.count > 0) {
                ws.online = @"线下";
                NSMutableArray *titleArray = [NSMutableArray array];
                for (ADLHomeServiceModel *mode in  self.roomArray) {
                    [titleArray addObject:mode.name];
                }
                CGRect aframe = self.attachF;
                aframe.size.height = titleArray.count * 44;
                [ADLAttachView showWithFrame:aframe titleArr:titleArray finish:^(NSInteger index) {
                [ws chooseRoomtIndex:index];
                }];
            }
            
        }else {
         [ADLToast showMessage:responseDict[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        
        
    }];
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return  90;
    }else {
        if ([self.array[indexPath.row] isEqualToString:ADLString(@"服务描述:")]) {
           return   self.model.desHeight + 44;
                   return  44;
        }else {
            return  44;
        }
    }
    
    return 0;
}

-(void)paytype{
    WS(ws);
    __block ADLPaymentPageView *fameiyLockView = [[ADLPaymentPageView alloc]init];
    fameiyLockView.frame = CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT);

    fameiyLockView.devictBlock = ^(NSInteger integer) {

        [ws integer:integer Paymenttype:0];

    };
    
}
//integer 1支付宝 2微信
//Paymenttype 支付价格
-(void)integer:(NSInteger)integer Paymenttype:(CGFloat)Paymenttype{
    //续费
    if ([self.model.templateId isEqualToString:@"2"]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"roomServiceId"] =  self.model.id;// 服务ID
        params[@"checkInId"] =  self.model.checkingInId;//入住id
        params[@"startDateTime"] = [self dateStr:[NSString stringWithFormat:@"%@",self.startDate]];//开始时间
        params[@"endDateTime"] =  [self dateStr:[NSString stringWithFormat:@"%@",self.endDate]];//结束时间
        params[@"days"] =  self.modelArray[3];//续房天数
        params[@"price"] = self.modelArray[5];//付款价格（总价)
        params[@"roomServiceName"] =self.model.name;//服务名称
        params[@"des"] = self.footerView.textView.text;//用户留言
        if (integer == 1) {
            params[@"type"] = @(2);//1 微信 2 淘宝 3 其它（网联
        }else if (integer == 0)
        {
            params[@"type"] = @(1);// 1 微信 2 淘宝 3 其它（网联
        }
        if ([self.online isEqualToString:@"线下"]) {
            params[@"roomTypeId"] = self.model.roomTypeId;//线下房型id
        }else  if ([self.online isEqualToString:@"线上"]){
            params[@"roomServiceId"] = self.model.roomSellTypeId;//线上房型id
        }
        params[@"roomTypePrice"] = self.modelArray[4];//线下房型价格
        NSString *prce = self.modelArray[5];
        [self reservartionService:ADEL_submit_renew params:params type:params[@"type"] Paymenttype:[prce floatValue]];
    }else
        //换房
        if ([self.model.templateId isEqualToString:@"3"]) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"checkInId"] =  self.model.checkingInId;//入住id
            params[@"startDateTime"] = [self getCurrentTimes];//开始时间 传当前时间
            params[@"endDateTime"] =  self.model.endDatetime;//结束时间
            params[@"roomServiceId"] =  self.model.id;//服务id
            params[@"roomServiceName"] =self.model.name;//服务名称
            //  params[@"targetRoomSellTypeId"] =  ws.model.id;//销售房型id
            if (self.model.price.length > 0) {
                params[@"targetPrice"] =self.model.price;//新的房型单价
            }else {
                params[@"targetPrice"] =@(self.model.roomTypePrice);//新的房型单价
            }
            params[@"shouldPayPrice"] = self.modelArray[4];//应该支付总价格
            params[@"des"] = self.footerView.textView.text;//用户留言
            if (integer == 0) {
                params[@"type"] = @(2);//1 微信 2 淘宝 3 其它（网联
            }else if (integer == 1)
            {
                params[@"type"] = @(1);//1 微信 2 淘宝 3 其它（网联
            }else {
                integer = 100; //等于100 免费不用走支付
            }
            if ([self.online isEqualToString:@"线下"]) {
                params[@"roomTypeId"] =self.model.roomTypeId;//原始线下房型id
                if (self.model.id.length > 0) {
                    params[@"targetRoomTypeId"] = self.model.id;//目标线下房型idid

                }else {
                    params[@"targetRoomTypeId"] = self.model.roomTypeId;//目标线下房型id
                }

            }else  if ([self.online isEqualToString:@"线上"]){
                params[@"roomSellTypeId"] =self.model.roomTypeId;//原始线上销售房型id

                if (self.model.id.length > 0) {
                    params[@"roomSellOrderId"] =self.model.id;//线x上销售房型订单id

                }else {
                    params[@"roomSellOrderId"] =self.model.roomTypeId;//线x上销售房型订单id
                }

            }
            if (self.model.price.length > 0) {
                params[@"targetRoomTypePrice"] = self.model.price;//新的线下房型单价
            }else {
                params[@"targetRoomTypePrice"] = @(self.model.roomTypePrice);//新的线下房型单价
            }
            NSString *prce = self.modelArray[4];
            [self reservartionService:ADEL_submit_change params:params type:params[@"type"] Paymenttype:[prce floatValue]];
        }
}
-(ADLFoterServiceView *)footerView {
    if (!_footerView) {
        WS(ws);
        _footerView = [[ADLFoterServiceView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height-NAVIGATION_H-300)];
        _footerView.backgroundColor = [UIColor whiteColor];
        _footerView.alpha = 0.9;
        _footerView.blockBtn = ^(UIButton * btn) {
            //续费
            if ([ws.model.templateId isEqualToString:@"2"]) {
                if (ws.footerView.textView.text.length < 1) {
                    [ADLToast showMessage:ADLString(@"留言不能为空")];
                    return;
                }

                NSString *Price =ws.modelArray[5];

                if ([Price floatValue] > 0) {
                    [ws paytype];
                }else {
                    //传价格
                    [ws integer:0 Paymenttype:[Price floatValue]];
                }


            }else

                //换房
                if ([ws.model.templateId isEqualToString:@"3"]) {
                    if (ws.footerView.textView.text.length < 1) {
                     
                        [ADLToast showMessage:ADLString(@"留言不能为空")];
                        return;
                    }

                    NSString *Price =ws.modelArray[4];

                    if ([Price floatValue] > 0) {
                        [ws paytype];
                    }else {
                        //传价格
                        [ws integer:0 Paymenttype:[Price floatValue]];
                    }


                }else {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"checkingInId"] =  ws.model.checkingInId;// 入住id
                    params[@"serviceId"] =  ws.model.id;// 服务id
                    params[@"serviceName"] =  ws.model.name;//服务名称
                    params[@"roomId"] =  ws.model.roomId;//客房id
                    params[@"roomName"] =  ws.model.roomName;//客房名称
                    params[@"des"] =  ws.footerView.textView.text;//描述
                    params[@"type"] =  @(ws.model.type);//服务类型
                    params[@"isCharge"] =  @(ws.model.isCharge);//是否收费
                    params[@"chargeAmount"] = @(ws.model.roomTypePrice);//金额
                    [ws reservartionService:ADEL_buyRoomService params:params type:nil Paymenttype:0];

                }

        };
    }
    return _footerView;
}
//type 传1支付宝 2微信
//Paymenttype  价格
-(void)reservartionService:(NSString *)url params:(NSMutableDictionary *)params type:(NSString *)type Paymenttype:(CGFloat)Paymenttype{

      NSInteger title =[ADLTimeOrStamp compareDateseconds:self.model.endDatetime];

    if (title == 1) {
    
        [ADLToast showMessage:ADLString(@"你已经超出入住时间")];
        return;
    }else if(title == 0){
        [ADLToast showMessage:ADLString(@"你已经超出入住时间")];
        return;
    }else if(title == -1){

    }

    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
     [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
    [ADLNetWorkManager postWithPath:url parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            if (Paymenttype <= 0) {
             //   [[NSNotificationCenter defaultCenter] postNotificationName:ADELreservationNotification object:nil userInfo:nil];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [ws.navigationController popViewControllerAnimated:YES];
                });
            }else {
               
                NSDictionary *dict = responseDict[@"data"];
                //[ws roomSellOrder:dict[@"orderId"] type:dict[@"type"]];
                self.orderId = dict[@"orderId"];
                //微信支付
                if ([type integerValue]== 1) {
                    //需要创建这个支付对象
                    PayReq *req   = [[PayReq alloc] init];
                    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                    req.openID = dict[@"appId"];
                    // 商家id，在注册的时候给的
                    req.partnerId = dict[@"partnerId"];
                    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                    req.prepayId  =  dict[@"prepayId"];
                    // 根据财付通文档填写的数据和签名
                    req.package  = dict[@"wxPackage"];
                    // 随机编码，为了防止重复的，在后台生成
                    req.nonceStr  =  dict[@"noncestr"];
                    // 这个是时间戳，也是在后台生成的，为了验证支付的
                    NSString * stamp =  dict[@"timestamp"];
                    req.timeStamp = stamp.intValue;
                    // 这个签名也是后台做的
                    req.sign =  dict[@"sign"];
                    //发送请求到微信，等待微信返回onResp
                    
                        [WXApi sendReq:req completion:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXsafepayNotification:) name:PAY_RESULT_STATUS object:nil];
                    
                    //支付宝支付
                }else     if ([type integerValue] == 2){
                    
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paysafepayNotification:) name:PAY_RESULT_ORDER object:nil];
                    [[AlipaySDK defaultService] payOrder:dict[@"bizContent"]  fromScheme:@"tencent1106196742" callback:^(NSDictionary *resultDic) {
                        
                        
                        if ([resultDic[@"resultStatus"]intValue] == 9000) {
                            NSDictionary *paydict = [self dictionaryWithJsonString:resultDic[@"result"]];
                            NSDictionary *orderIddict =paydict[@"alipay_trade_app_pay_response"];
                            
                            
                            
                            [self PaySuccessorderId:orderIddict[@"out_trade_no"] type:@"2" result:resultDic[@"result"]];
                            
                        } else {
                            [ADLToast showMessage:ADLString(@"支付失败")];
                        }
                    }];
                }
                
            }
            
            }

   
        
    } failure:^(NSError *error) {
        
      [ADLToast hide];
        
    }];
    

}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableLeaves
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
    params[@"orderId"] = self.orderId;
    params[@"type"] = type;
    if ([type isEqualToString:@"2"]) {
        params[@"result"] = result;
    }
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
  [ADLNetWorkManager postWithPath:ADEL_pay_result parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
          //  [[NSNotificationCenter defaultCenter] postNotificationName:ADELreservationNotification object:nil userInfo:nil];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [ws.navigationController popViewControllerAnimated:YES];
            });


        }else {

        }

    } failure:^(NSError *error) {

    }];
}
//用户取消订单 用户端使用
-(void)CancelpaymentorderId:(NSString *)orderId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"roomSellOrderId"] = orderId;
       params[@"sign"] = [ADLUtils handleParamsSign:params];

    [ADLNetWorkManager postWithPath:ADEL_roomSellOrder_cancelt parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
         
            
        }else {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//用户付款 用户端使用
-(void)roomSellOrder:(NSString *)orderId type:(NSString *)type{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"roomSellOrderId"] = orderId;
    params[@"type"] = type;//入住id
    params[@"sign"] = [ADLUtils handleParamsSign:params];
  [ADLNetWorkManager postWithPath:ADEL_roomSellOrder_pay parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            
            
        }else {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 80)];
        _titleLabel.text  =self.model.name;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    }
    return   _titleLabel;
}
-(UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0,NAVIGATION_H            , self.view.frame.size.width, 170)];
        _image.image = [UIImage imageNamed:@"bg_service_user"];
        _image.userInteractionEnabled = YES;
        // _image.backgroundColor = [UIColor yellowColor];
    }
    return _image;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(10,NAVIGATION_H, SCREEN_WIDTH-20, SCREEN_HEIGHT - NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        // _tableView.alpha = 0.7;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}
- (void)selectTime {
    WS(ws);
    HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:self.modelArray[1] Selectdate:self.modelArray[2] selectBlock:^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
        ws.startDate =[goDay toString];
        ws.endDate =[backDay toString];
        ws.modelArray[2] =[NSString stringWithFormat:@"%@ - %@",[goDay toString],[backDay toString]];
   
         NSString *days = [ws timeIntervalWithStartDate:[goDay date] endDate:[backDay date]];
        ws.modelArray[3] =days;
         CGFloat price = ws.model.roomTypePrice * [days integerValue];
          ws.modelArray[5] =[NSString stringWithFormat:@"%.2f",price];
            [ws.tableView reloadData];
     
    }];
    vc.CalendarGo.year = 2019;
      vc.CalendarGo.month = 12;
     vc.CalendarGo.day = 11;
    vc.showImageIndex = 30;
    vc.isGoBack = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSString *) dateString:(NSDate*)date format:(NSString *)format {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];//格式化
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

- (NSString *)timeIntervalWithStartDate:(NSDate *)start endDate:(NSDate *)end {
    
    NSTimeInterval time=[end timeIntervalSinceDate:start];
    
    int days=((int)time)/(3600*24);//天
    return [[NSString alloc] initWithFormat:@"%i",days];
    // int hours=((int)time)%(3600*24)/3600;//小时
    //return [[NSString alloc] initWithFormat:@"%i小时",hours];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



//时间转换
-(NSString *)dateStr:(NSString *)str {
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(为了转换成功)
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [fmt dateFromString:str];
    
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
    
}

- (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate

{
    
    //创建日期格式化对象
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //取两个日期对象的时间间隔：
    
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    int days=((int)time)/(3600*24);
    
    //int hours=((int)time)%(3600*24)/3600;
    
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    
        return days;
    
}
-(NSString*)getCurrentTimes{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}
@end


