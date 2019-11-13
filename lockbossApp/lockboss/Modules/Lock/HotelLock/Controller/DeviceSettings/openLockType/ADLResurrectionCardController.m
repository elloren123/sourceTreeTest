//
//  ADLResurrectionCardController.m
//  lockboss
//
//  Created by adel on 2019/11/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLResurrectionCardController.h"
//#import "ADLPromptView.h"

@interface ADLResurrectionCardController ()
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *IMname;
@property (nonatomic, strong) UIButton *resurrectionBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *backimageView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) UILabel *card;

@property (nonatomic, strong) UILabel *dateTimeLabel;

@property (nonatomic, strong) NSString *secretId;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation ADLResurrectionCardController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:ADLString(@"激活房卡")];
    [self selectSelfCheckingInfo];
    [self selectActivateRoomCrad];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self  addtimer:nil];
}
//查询入住信息
-(void)selectSelfCheckingInfo {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"checkingInId"] =self.model.checkingInId;
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    WS(ws);
    [ADLToast showLoadingMessage:ADLString(@"loafing")];
    
    [ADLNetWorkManager postWithPath:APP_selectSelfCheckingInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.dict = responseDict[@"data"];
            
            [ws.view addSubview:self.headView];
            [ws.view addSubview:self.resurrectionBtn];
            [ws.view addSubview:self.titleLabel];
            
        }else  {
            [ADLToast showMessage:responseDict[@"msg"]];
            
        }
        
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
}

//激活房卡
-(void)activateRoomCrad {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gatewayCode"] =self.model.gatewayCode;
    params[@"checkingInId"] =self.model.checkingInId;
    params[@"deviceCode"] =self.model.deviceCode;
    params[@"deviceType"] =self.model.deviceType;
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
    
    [ADLNetWorkManager postWithPath:APP_activateRoomCrad parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
      
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ws.resurrectionBtn setTitle:ADLString(@"取消") forState:UIControlStateNormal];
            ws.timer =  [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(addtimer:) userInfo:nil repeats:NO];
            ws.titleLabel.hidden = NO;
            [[NSNotificationCenter defaultCenter] addObserver:ws selector:@selector(lockActivateRoomCrad:) name:@"ADELfamilLocCardNotification" object:nil];
            [ws setSelectedYES];
        }else {
                   [ADLToast hide];
        }
    } failure:^(NSError *error) {
            [ADLToast hide];
    }];
    
}
-(void)lockActivateRoomCrad:(NSNotification*)noti{
    WS(ws);
    //2准备激活，3激活成功,4删除激活卡成功
    NSDictionary* notiDic = noti.userInfo;
    
    if ([notiDic count] > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ws  addtimer:nil];
            
            if ([notiDic[@"resultCode"] integerValue] == 10000){
                
                
                if ([notiDic[@"type"] integerValue] == 2 ) {
                    
                    
                }else
                    if ([notiDic[@"type"] integerValue] == 3 ) {
                    
                        
                           [ADLToast showMessage:ADLString(@"激活房卡成功") duration:2];
                        [ws.resurrectionBtn setTitle:ADLString(@"删除房卡") forState:0];
                        ws.resurrectionBtn.hidden = YES;
                        [ws selectActivateRoomCrad];
                        [ws setSelectedNO];
                    }else    if ([notiDic[@"type"] integerValue] == 4 ) {
                        
                    
                        
                           [ADLToast showMessage:ADLString(@"删除房卡成功") duration:2];
                        [ws.resurrectionBtn setTitle:ADLString(@"激活房卡") forState:0];
                        //查询房卡,是否删除成功
                        [ws selectActivateRoomCrad];
                    }
                
                
                
            }else {
                
                [ws setSelectedNO];
                
                
                  [ADLToast showMessage:notiDic[@"msg"] duration:2];
                
                if (self.secretId.length > 1) {
                    [ws.resurrectionBtn setTitle:ADLString(@"删除房卡") forState:0];
                    ws.resurrectionBtn.hidden = YES;
                }else {
                    [ws.resurrectionBtn setTitle:ADLString(@"激活房卡") forState:0];
                }
                
                
                
            }
        });
    }
    
    
}

-(void)addtimer:(NSTimer *)isTime{
    [ADLToast hide];
    if(isTime.valid == YES){
        if (self.secretId.length > 1) {
           [ADLToast showMessage:ADLString(@"删除房卡失败") duration:2];
        }else {
            [ADLToast showMessage:ADLString(@"激活房卡失败") duration:2];
           
        }
    }
    
    //取消定时器
    [self.timer invalidate];
    self.timer = nil;
}
//查询活的房卡
-(void)selectActivateRoomCrad {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gatewayCode"] =self.model.gatewayCode;
    params[@"checkingInId"] =self.model.checkingInId;
    params[@"deviceCode"] =self.model.deviceCode;
    params[@"deviceType"] =self.model.deviceType;
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    WS(ws);
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:APP_selectActivateRoomCrad parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSMutableArray *array = [NSDictionary mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            if (array.count > 0) {
                NSDictionary *dict =array[0];
                //secretId
                self.secretId =[NSString stringWithFormat:@"%@",dict[@"secretId"]];
                if (self.secretId.length > 0) {
                    ws.card.text = [NSString stringWithFormat:@"%@:  %@",ADLString(@"卡号"),self.secretId];
                    self.IMname.text = ADLString(@"已激活");
                }else {
                    
                    self.IMname.text = ADLString(@"未激活");
                    ws.card.text = [NSString stringWithFormat:@"%@:  %@",ADLString(@"身份证号"),ws.dict[@"idCard"]];
                }
                ws.headView.backgroundColor =COLOR_E0212A;
                [ws.resurrectionBtn setTitle:ADLString(@"删除房卡") forState:0];
                ws.resurrectionBtn.hidden = YES;
                
            }else{
                self.secretId = @"";
                [ws.resurrectionBtn setTitle:ADLString(@"激活房卡") forState:0];
                ws.headView.backgroundColor =COLOR_CCCCCC;
            }
            
            
        }else  {
            
            [ADLToast showMessage:responseDict[@"msg"]];
            
        }
        
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
    
}

//删除房卡
-(void)deleteCard {
   NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gatewayCode"] =self.model.gatewayCode;
    params[@"checkingInId"] =self.model.checkingInId;
    params[@"deviceCode"] =self.model.deviceCode;
    params[@"deviceType"] =self.model.deviceType;
    params[@"secretId"] =self.secretId;
    params[@"sign"] =  [ADLUtils handleParamsSign:params];
    WS(ws);

    
    [ADLNetWorkManager postWithPath:APP_deleteCard parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
       
        if ([responseDict[@"code"] integerValue] == 10000) {
         [[NSNotificationCenter defaultCenter] addObserver:ws selector:@selector(lockActivateRoomCrad:) name:@"ADELfamilLocCardNotification" object:nil];

        }else {
                   [ADLToast hide];
        }
        
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
    
    
}

-(UIImageView *)backimageView {
    if (!_backimageView) {
        _backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT - NAVIGATION_H-200)];
        _backimageView.image = [UIImage imageNamed:@"bg_anim"];
        UILabel  *title = [self.view createLabelFrame:CGRectMake(20,20, SCREEN_WIDTH - 40, 20)  font:16 text:ADLString(@"请把房卡对准网关激活") texeColor:COLOR_E0212A];
        title.textAlignment = NSTextAlignmentCenter;
        //  title.backgroundColor =Colorad2f2d;
        [_backimageView addSubview:self.imageView];
        [_backimageView addSubview:title];
    }
    return _backimageView;
}
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.backimageView.bounds];
        //创建一个数组，数组中按顺序添加要播放的图片（图片为静态的图片）
        //_imageView.backgroundColor = [UIColor yellowColor];
        NSMutableArray *imgArray = [NSMutableArray array];
        for (int i=1; i<13; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"lock_anim_%d",i]];
            [imgArray addObject:image];
        }
        //lock_anim_1
        //把存有UIImage的数组赋给动画图片数组
        _imageView.animationImages = imgArray;
        //设置执行一次完整动画的时长
        _imageView.animationDuration = 10*0.25;
        //动画重复次数 （0为重复播放）
        _imageView.animationRepeatCount = 0;
        //开始播放动画
        [_imageView startAnimating];
        
    }
    return _imageView;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        //  _titleLabel [UILabel createLabelFrame:CGRectMake(20, CGRectGetMaxY(self.headView.frame)+30, SCREEN_WIDTH - 40, 80) font:FontSize16 text:ADLString(@"请把房卡对准门锁,点击👇按钮激活房卡") texeColor:Colorad2f2d];
        _titleLabel = [self.view createLabelFrame:CGRectMake(20,SCREEN_HEIGHT - 180, SCREEN_WIDTH - 40, 80)  font:16 text:ADLString(@"房卡激活中~~~") texeColor:COLOR_E0212A];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}
-(UIButton *)resurrectionBtn {
    if (!_resurrectionBtn) {
        _resurrectionBtn = [self.view createButtonFrame:CGRectMake(20, SCREEN_HEIGHT-NAVIGATION_H- 180, SCREEN_WIDTH - 40, 45) imageName:nil title:ADLString(@"激活房卡") titleColor:[UIColor whiteColor] font:16 target:self action:@selector(resurrectionBtn:)];
        _resurrectionBtn.backgroundColor = COLOR_E0212A;
        _resurrectionBtn.layer.masksToBounds = YES;
        //        _headView.layer.borderColor = Colorffffff.CGColor;
        //        _headView.layer.borderWidth = 0.5;
        _resurrectionBtn.layer.cornerRadius = 5;
        
        // [_resurrectionBtn setTitle:ADLString(@"删除房卡") forState:UIControlStateNormal];
    }
    return _resurrectionBtn;
}


-(void)resurrectionBtn:(UIButton *)btn {
    if ([_resurrectionBtn.titleLabel.text isEqualToString:ADLString(@"删除房卡")]) {
        
        [self footerBtn];

    }else     if ([_resurrectionBtn.titleLabel.text isEqualToString:ADLString(@"取消")]){
        [self.resurrectionBtn setTitle:ADLString(@"激活房卡") forState:0];
        [self setSelectedNO];
        
    }else {
        //激活房卡
        [self activateRoomCrad];
        
    }
    
    
}
-(void)footerBtn {
    WS(ws);
//    ADLPromptView *promptView = [[ADLPromptView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [promptView ADLPromptView:ADLString(@"温馨提示") conttitle:ADLString(@"你确定要删除房卡吗?") NOBtn:ADLString(@"取消") YESBtn:ADLString(@"确定")];
//    promptView.YESBtnBlock = ^{
//        [ws deleteCard];
//
//    };
    //    self.promptView = promptView;
    
    [ADLAlertView showWithTitle:ADLString(@"温馨提示") message:ADLString(@"你确定要删除房卡吗?") confirmTitle:ADLString(@"确定") confirmAction:^{
      [ws deleteCard];
    } cancleTitle:ADLString(@"取消") cancleAction:nil showCancle:YES];
    
}
-(void)setSelectedYES {
    [ADLToast hide];
    [self.resurrectionBtn setSelected:YES];
    [self.headView removeFromSuperview];
    self.titleLabel.hidden = NO;
    [self.view addSubview:self.backimageView];
}
//guanbi
-(void)setSelectedNO {
    
    [ADLToast hide];
    [self.resurrectionBtn setSelected:NO];
    [self.view addSubview:self.headView];
    self.titleLabel.hidden = YES;
    [self.backimageView removeFromSuperview];
}


-(UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(10, NAVIGATION_H+30, SCREEN_WIDTH - 20, 220)];
        //  _headView.backgroundColor =Colorad2f2d;
        _headView.backgroundColor =COLOR_CCCCCC;
        // _headView.layer.contents =
        _headView.layer.masksToBounds = YES;
        //        _headView.layer.borderColor = Colorffffff.CGColor;
        //        _headView.layer.borderWidth = 0.5;
        _headView.layer.cornerRadius = 5;
        
        UILabel *IMname = [self.view createLabelFrame:CGRectMake(10, 20, 60, 30) font:16 text:ADLString(@"未激活") texeColor:nil];
        IMname.textAlignment = NSTextAlignmentCenter;
        IMname.layer.masksToBounds = YES;
        IMname.layer.cornerRadius = 15;
        IMname.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:IMname];
        self.IMname = IMname;
        
        UILabel *name = [self.view createLabelFrame:CGRectMake(CGRectGetMaxX(IMname.frame)+10, 20, 150, 30) font:14 text:self.dict[@"userName"] texeColor:[UIColor whiteColor]];
        //name.textAlignment = NSTextAlignmentLeft;
        [_headView addSubview:name];
        NSString *idCard =[NSString stringWithFormat:@"%@:  %@",ADLString(@"身份证号"),self.dict[@"idCard"]];
        
        UILabel *card = [self.view createLabelFrame:CGRectMake(10, CGRectGetMaxY(IMname.frame)+30, _headView.width - 20, 20) font:14 text:idCard texeColor:[UIColor whiteColor]];
        card.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:card];
        self.card =card;
        //        UILabel *dateTimeLabel = [UILabel createLabelFrame:CGRectMake(CGRectGetMaxX(card.frame)+10, 20, 150, 20) font:FontSize14 text:ADLString(@"发卡") texeColor:Colorffffff];
        //        [_headView addSubview:dateTimeLabel];
        
        UILabel *day = [self.view createLabelFrame:CGRectMake(10, CGRectGetMaxY(card.frame)+50, (_headView.width - 50)/4, 20) font:14 text:ADLString(@"入住时间") texeColor:[UIColor whiteColor]];
        day.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:day];
        
        
        //          NSDate *startDatetime =[ADLPromptMwssage dateTime:];
        //          NSDate *endDatetime =[ADLPromptMwssage dateTime:];
        // NSString *dateNumber = [self numberOfDaysWithFromDate:self.dict[@"startDatetime"] toDate:self.dict[@"endDatetime"]];
        
        UILabel *dayNumber = [self.view createLabelFrame:CGRectMake(10, CGRectGetMaxY(day.frame)+10, day.width,20) font:14 text:[self timeStampToTime:self.dict[@"startDatetime"]] texeColor:[UIColor whiteColor]];
        dayNumber.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:dayNumber];
        
        
        
        UILabel *date = [self.view createLabelFrame:CGRectMake(CGRectGetMaxX(dayNumber.frame)+10, CGRectGetMaxY(card.frame)+50,day.width, 20) font:14 text:ADLString(@"离店时间") texeColor:[UIColor whiteColor]];
        date.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:date];
        
        UILabel *dateNumberLabel = [self.view createLabelFrame:CGRectMake(date.x, CGRectGetMaxY(date.frame)+10, day.width,20) font:14 text:[self timeStampToTime:self.dict[@"endDatetime"]] texeColor:[UIColor whiteColor]];
        dateNumberLabel.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:dateNumberLabel];
        
        
        
        UILabel *room = [self.view  createLabelFrame:CGRectMake(CGRectGetMaxX(dateNumberLabel.frame)+10, CGRectGetMaxY(card.frame)+50,day.width, 20) font:14 text:ADLString(@"房型") texeColor:[UIColor whiteColor]];
        room.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:room];
        
        UILabel *roomLabel = [self.view  createLabelFrame:CGRectMake(room.x, CGRectGetMaxY(room.frame)+10,day.width,20) font:14 text:self.dict[@"roomTypeName"] texeColor:[UIColor whiteColor]];
        roomLabel.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:roomLabel];
        //roomLabel.backgroundColor = Colorad2f2d;
        
        
        UILabel *breakfast = [self.view  createLabelFrame:CGRectMake(CGRectGetMaxX(room.frame)+10, CGRectGetMaxY(card.frame)+50,day.width, 20) font:14 text:ADLString(@"早餐") texeColor:[UIColor whiteColor]];
        breakfast.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:breakfast];
        
        UILabel *breakfastLabel = [self.view  createLabelFrame:CGRectMake(breakfast.x, CGRectGetMaxY(breakfast.frame)+10,day.width,20) font:14 text:ADLString(@"有") texeColor:[UIColor whiteColor]];
        if ([self.dict[@"breakfastAmount"] integerValue] > 0) {
            breakfastLabel.text =[NSString stringWithFormat:@"%@份",self.dict[@"breakfastAmount"]];
        }else {
            breakfastLabel.text= ADLString(@"无");
        }
        breakfastLabel.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:breakfastLabel];
        
    }
    return _headView;
}

-(NSString *)numberOfDaysWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate{
    //创建两个日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [dateFormatter dateFromString:[ADLUtils getDateFromTimestamp:[fromDate integerValue] format:@"yyyy-MM-dd HH:mm"]];
    NSDate *endDate = [dateFormatter dateFromString:[ADLUtils getDateFromTimestamp:[toDate integerValue] format:@"yyyy-MM-dd HH:mm"]];
    
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
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    //打印
    //    NSLog(@"%@",delta);
    //    //获取其中的"天"
    //    NSLog(@"%ld",delta.day);
    return [NSString stringWithFormat:@"%ld",delta.day];
}
/** 时间戳转化日期*/
- (NSString *)timeStampToTime:(NSString *)timestr {
    
    NSTimeInterval interval    =[timestr doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *dateString = [formatter stringFromDate: date];
    
    return dateString;
    
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
