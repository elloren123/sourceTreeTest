//
//  ADLHotelOrderController.m
//  lockboss
//
//  Created by adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelOrderController.h"
#import "ADLHotelOrderTableViewCell.h"
#import "ADLBookingHotelModel.h"
#import "ADLKeyboardMonitor.h"
#import "HZCalendarViewController.h"
#import "ADLHotelOrderPayController.h"
#import "ADLSelectDateView.h"
#import "ADLHomeDateTimeView.h"

@interface ADLHotelOrderController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ADLHomeDateTimeViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,strong)NSMutableArray *titleArray;
//@property (nonatomic ,strong)NSArray *addArray;
@property (nonatomic ,strong)NSMutableArray *placeholderArray;
@property (nonatomic ,strong)UITextField *teleField;
@property (nonatomic ,strong)UIView *paybottomView;
@property (nonatomic ,strong)NSMutableArray *teleFieldArray;
@property (nonatomic ,strong)UIView *footerView;

@property (nonatomic ,assign)NSInteger numberDate;
@property (nonatomic ,copy)NSString *startTime;//选择时间
@property (nonatomic ,copy)NSString *endTime;//离开
@property (nonatomic ,copy)NSString *checkTime;//到店时间
@property (nonatomic ,weak)UILabel *payLabel;

@property (nonatomic, weak) UILabel *textL;
@property (nonatomic, strong) ADLHomeDateTimeView *datePickerView;

@property (nonatomic ,weak)UIButton *timebtn;

@end

@implementation ADLHotelOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self datestr:1];
    [self addNavigationView:ADLString(@"确认订单")];
   //  self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.paybottomView];
    [[ADLKeyboardMonitor monitor] setEnable:YES];
    
}

#pragma mark ------ 按照条件搜索酒店-----
//- (void)changedpaybtn {
//       NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    params[@"roomSellTypeId"] =self.mode.roomSellTypeId;//销售房型id
//    params[@"payPrice"] =@(self.mode.discountsPrice*self.numberDate);//付款价格 该处填入 是优惠价*天数
//    params[@"startDatetime"] =self.startTime;//开始时间
//    params[@"endDatetime"] =self.endTime;//结束时间
//    params[@"expectCheckInDatetime"] =self.startTime;//预计入住时间
//    params[@"guests"] =@"endDatetime";//入住客人,必须有一个
//    NSString* str = [self dictionaryToJsonString:self.teleFieldArray];
//    [params setValue:str forKey:@"guests"];
//    params[@"sign"] = [ADLUtils handleParamsSign:params];
//
//   // WS(ws);
//    [ADLNetWorkManager postWithPath:@"http://129.204.67.226:8087/lockboss-api/app/roomSellOrder/add.do" parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
//        if ([responseDict[@"code"] integerValue] == 10000) {
//
//
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
//}
- (NSString *)dictionaryToJsonString:(NSMutableArray *)arr{
       NSMutableArray *tempArr = [NSMutableArray array];
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSMutableArray *guests = [NSMutableArray arrayWithArray:@[@"phone",@"userName",@"idCard",@"loginAccount",@"email",@"type"]];
    for (int i = 0; i < arr.count; i++) {
        NSMutableArray *array =arr[i];
        for (int f = 0; f < array.count; f++) {
        [dic setValue:array[f] forKey:guests[f]];
        }
        NSLog(@"%@ -- %d",dic,i);
   
         [tempArr addObject:dic.mutableCopy];
       
       
    }

    [tempArr removeObjectAtIndex:0];
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tempArr options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 100)];
       _footerView.backgroundColor = COLOR_F2F2F2;
        
        UIButton *timebtn = [self.view createButtonFrame:CGRectMake(0, 10,_footerView.width,44) imageName:nil title:[NSString stringWithFormat:@"     %@: %@ 18:00",ADLString(@" 预计到店时间"),self.startTime] titleColor:COLOR_333333 font:14 target:self action:@selector(changedTimebtn:)];
        self.checkTime =[NSString stringWithFormat:@"%@ 18:00",self.startTime];
        timebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        timebtn.backgroundColor = [UIColor whiteColor];
        self.timebtn = timebtn;
        [_footerView addSubview:timebtn];
        
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(_footerView.width - 35,timebtn.y + 14.5,15, 15)];
        iconView.image = [UIImage imageNamed:@"tableView_indicator"];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [_footerView addSubview:iconView];
        
        UILabel *policy = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(timebtn.frame)+ 20,160,15) font:14 text:ADLString(@"酒店政策:") texeColor:COLOR_333333];
        policy.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [_footerView addSubview:policy];
        
           CGFloat policyContentH = [ADLUtils calculateString:self.mode.policyDes rectSize:CGSizeMake(SCREEN_WIDTH - 40,MAXFLOAT) fontSize:10].height+5;//计算字体长度
        
        UILabel *policyContent = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(policy.frame)+ 10,SCREEN_WIDTH - 40,policyContentH) font:10 text:[NSString stringWithFormat:@"    %@",self.mode.policyDes] texeColor:COLOR_666666];
        policyContent.numberOfLines = 0;
        [_footerView addSubview:policyContent];
        
        

        UILabel *attention = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(policyContent.frame)+ 10,160, 15) font:14 text:ADLString(@"注意事项:") texeColor:COLOR_333333];
          attention.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [_footerView addSubview:attention];
        
        
             CGFloat desH = [ADLUtils calculateString:self.mode.notes rectSize:CGSizeMake(SCREEN_WIDTH - 40,MAXFLOAT) fontSize:10].height+5;//计算字体长度
        UILabel *attentionContent = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(attention.frame)+ 10,SCREEN_WIDTH - 40, desH) font:10 text:[NSString stringWithFormat:@"    %@",self.mode.notes] texeColor:COLOR_666666];
            attentionContent.numberOfLines = 0;
        [_footerView addSubview:attentionContent];
        
        
        
        UILabel *book = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(attentionContent.frame)+ 10,160,15) font:14 text:ADLString(@"预订说明:") texeColor:COLOR_333333];
            book.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [_footerView addSubview:book];
        
           CGFloat bookContentH = [ADLUtils calculateString:self.mode.reserveDes rectSize:CGSizeMake(SCREEN_WIDTH - 40,MAXFLOAT) fontSize:10].height+5;//计算字体长度
        UILabel *bookContent = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(book.frame)+ 10,SCREEN_WIDTH - 40,bookContentH) font:10 text:[NSString stringWithFormat:@"    %@",self.mode.reserveDes] texeColor:COLOR_666666];
        [_footerView addSubview:bookContent];
           bookContent.numberOfLines = 0;
        
        _footerView.frame = CGRectMake(0, 0,SCREEN_WIDTH,timebtn.height+policy.height +policyContent.height + attention.height+attentionContent.height+book.height+bookContent.height+100);
    }
    return _footerView;
}
-(void)changedTimebtn:(UIButton *)btn {
    ADLHomeDateTimeView *pickerView = [[ADLHomeDateTimeView alloc] init];
 
    pickerView.delegate = self;
    pickerView.pickerViewMode = DatePickerViewTimeMode;
    pickerView.titleL.text =self.startTime;
    [self.view addSubview:pickerView];
    [pickerView showDateTimePickerView];
    
  // self.datePickerView = pickerView;
}
- (void)didClickFinishDateTimePickerView:(NSString *)date{
  //  self.textL.text = date;
    self.checkTime =[NSString stringWithFormat:@"%@ %@",self.startTime,date];
    [self.timebtn setTitle:[NSString stringWithFormat:@"  %@%@",ADLString(@"  预计到店时间"),self.checkTime] forState:UIControlStateNormal];
    
}

#pragma mark ------ 查询酒店客房-----
- (void)HotenRoomData {

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.array[section]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        static NSString *ID = @"SettingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 判断是否为nil
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            
        }
        // 设置标题
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        cell.textLabel.textColor = COLOR_333333;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,cell.height - 0.5,SCREEN_WIDTH, 0.5)];
        line.backgroundColor = COLOR_CCCCCC;
        [cell addSubview:line];
        return cell;
    }else {

    
    ADLHotelOrderTableViewCell *cell = [ADLHotelOrderTableViewCell cellWithTableView:tableView];
    cell.textField.delegate = self;
    if (indexPath.row == 0) {
        cell.phoneCode.frame = CGRectMake(70,0, 60, cell.height);
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
          cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else {
      cell.phoneCode.frame = CGRectMake(80,0, 0, 0);
    }
        if (indexPath.row == 0 || indexPath.row == 1) {
            cell.iocn.hidden = NO;
            
        }else {
            cell.iocn.hidden = YES;
    }
        
    WS(ws);
    cell.titleFieldBlock = ^(UITextField * _Nonnull title) {
        [ws titleFieldTarget:title selectRowAtIndexPat:indexPath];
    };
         [cell title:self.array[indexPath.section][indexPath.row] placeholder:self.placeholderArray[indexPath.section][indexPath.row] titleField:self.teleFieldArray[indexPath.section][indexPath.row]];
        return cell;
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WS(ws);
    [self.tableView endEditing:YES];
    
    if (indexPath.section == 0) {
        //跳转日期
        if (indexPath.row == 0) {
            WS(ws);
            HZCalendarViewController *vc = [HZCalendarViewController getVcWithDayNumber:365 FromDateforString:nil Selectdate:nil selectBlock:^(HZCalenderDayModel *goDay,HZCalenderDayModel *backDay) {
                //                ws.screeningView.startTime =[goDay toString];
                //                ws.screeningView.endTime =[backDay toString];
             
                ws.numberDate =[ADLUtils fateDifferenceWithStartTime:[goDay date] endTime:[backDay date]];
                
                ws.array[indexPath.section][indexPath.row] =[NSString stringWithFormat:@"%@: %@ - %@          共%ld天",ADLString(@"入住时间"),[goDay toString],[backDay toString],ws.numberDate];
                   ws.startTime =[goDay toString];
                   ws.endTime =[backDay toString];
                
                ws.payLabel.text = [NSString stringWithFormat:@"%@:%.2f",ADLString(@"支付费用"),ws.mode.discountsPrice*ws.numberDate];
                            // ws.screeningView.contArray[1] =[backDay getWeek];
                           //    ws.screeningView.titleArray[1] =[goDay getWeek];
                
                
                [self.timebtn setTitle:[NSString stringWithFormat:@"  %@: %@ 18:00",ADLString(@"  预计到店时间"),ws.startTime] forState:UIControlStateNormal];
                [ws.tableView reloadData];
                
            }];
            vc.showImageIndex = 30;
            vc.isGoBack = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:textField];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
    
    NSString *toBeString = textField.text;
    if (![self isInputRuleAndBlank:toBeString]) {
        textField.text = [self disable_emoji:toBeString];
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 70;
    }else  if (section == 1) {
        return 44;
    }else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 0;
    }else {
        return 44;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 70)];
        sectionView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [self.view createLabelFrame:CGRectMake(20,10,SCREEN_WIDTH - 24, 18) font:16 text:self.mode.companyName texeColor:COLOR_333333];
            nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [sectionView addSubview:nameLabel];
        
        UILabel *roomName = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(nameLabel.frame)+10,SCREEN_WIDTH - 24, 12) font:12 text:self.mode.name texeColor:COLOR_333333];
        [sectionView addSubview:roomName];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,sectionView.height - 0.5, sectionView.width, 0.5)];
        line.backgroundColor = COLOR_CCCCCC;
        [sectionView addSubview:line];
    
        return sectionView;
    }
    if (section == 1) {

    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 44)];
    sectionView.backgroundColor = [UIColor whiteColor];
         UILabel *nameLabel = [self.view createLabelFrame:CGRectMake(20,0,60, sectionView.height) font:12 text:ADLString(@"入住信息") texeColor:COLOR_333333];
    [sectionView addSubview:nameLabel];
    
        UIButton *addbtn = [self.view createButtonFrame:CGRectMake(sectionView.width - 74, 0, 60, sectionView.height) imageName:@"icon_jiahao" title:ADLString(@"添加") titleColor:COLOR_E0212A font:12 target:self action:@selector(changedaddbtn:)];
        addbtn.tag = section;
    [self.view layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft createButton:addbtn imageTitleSpace:12];
      [sectionView addSubview:addbtn];
    
  
         UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,sectionView.height - 0.5, sectionView.width, 0.5)];
            line.backgroundColor = COLOR_CCCCCC;
      [sectionView addSubview:line];
    
    
    
    return sectionView;
    }
       return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
     if (section == 0 || section == 1) {
        return nil;
     }else {
         UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 44)];
         sectionView.backgroundColor = [UIColor whiteColor];
      
         UIButton *delete = [self.view createButtonFrame:CGRectMake(sectionView.width - 74, 0, 60, sectionView.height) imageName:@"icon_jianhao" title:ADLString(@"删除") titleColor:COLOR_E0212A font:12 target:self action:@selector(changeddeletebtn:)];
         delete.tag = section;
         [self.view layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft createButton:delete imageTitleSpace:12];
         [sectionView addSubview:delete];
    
         
         return sectionView;
     }
    return nil;
}

-(void)changedaddbtn:(UIButton *)btn{
    //guestNum 入住人数
    //添加
    if ( self.mode.guestNum > self.array.count - 1) {
      
        NSMutableArray  *array =[NSMutableArray arrayWithArray: @[ADLString(@"手机号:"),ADLString(@"姓名:"),ADLString(@"身份证号:"),ADLString(@"账号:"),ADLString(@"邮箱:")]];
        [self.array addObject:array];
        
        NSMutableArray *arr =[NSMutableArray arrayWithArray:@[ADLString(@"请输入手机号"),ADLString(@"请输入姓名"),ADLString(@"请输入身份证号"),ADLString(@"请输入账号"),ADLString(@"请输入邮箱")]];
        // [self.placeholderArray addObjectsFromArray:arr];
        
        [self.placeholderArray addObject:arr];
        [self.teleFieldArray addObject:[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"0"]]];
        [self.tableView reloadData];
    }else {
               [ADLToast showMessage:[NSString stringWithFormat:@"%@%d%@",ADLString(@"最多添加"),self.mode.guestNum,ADLString(@"位客人信息")]];
    }
}
-(void)changeddeletebtn:(UIButton *)btn{
    [self.array removeObjectAtIndex:btn.tag];
    [self.placeholderArray removeObjectAtIndex:btn.tag];
    [self.teleFieldArray removeObjectAtIndex:btn.tag];
    
    [self.tableView reloadData];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   // NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    
    //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
    
//    if([lang isEqualToString:@"zh-Hans"]) {
//
//    return YES;
//
//    } else{
//
//    return NO;
//
//    }
    
return YES;
}

- (void)titleFieldTarget:(UITextField *)textField selectRowAtIndexPat:(NSIndexPath *)indexPath{
    NSString *toBeString = textField.text;

   // self.teleFieldArray[indexPath.section][indexPath.row] = textField.text;
   // NSMutableArray *array =[NSMutableArray arrayWithObject:self.teleFieldArray[indexPath.section]];
  
    
    if ([self isInputRuleAndBlank:toBeString]) {
     self.teleFieldArray[indexPath.section][indexPath.row] = textField.text;
    }else {
//           textField.text = [self disable_emoji:toBeString];
//         self.teleFieldArray[indexPath.section][indexPath.row] =textField.text;
    }
// [array replaceObjectAtIndex:indexPath.row withObject:textField.text];
    
  //  [self.teleFieldArray insertObject:array atIndex:indexPath.section];
}

- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
//判断是否输入emoji
- (NSString *)disable_emoji:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
   [self.tableView endEditing:YES];
 
    
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H,SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H- 52) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // _tableView.bounces = NO;
       _tableView.sectionHeaderHeight = 5;
       _tableView.sectionFooterHeight = 5;
      //  _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor =COLOR_F2F2F2;
        // _tableView.alpha = 0.7;
     //   _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}
-(UIView *)paybottomView {
    if (!_paybottomView) {
        
        _paybottomView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 52, SCREEN_WIDTH, 52)];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,0, _paybottomView.width, 0.5)];
        line.backgroundColor = COLOR_CCCCCC;
        [_paybottomView addSubview:line];
        UILabel *payLabel = [self.view createLabelFrame:CGRectMake(20,10,_paybottomView.width - 200,_paybottomView.height - 20) font:16 text:[NSString stringWithFormat:@"%@:%.2f",ADLString(@"支付费用"),self.mode.discountsPrice] texeColor:COLOR_333333];
        [_paybottomView addSubview:payLabel];
        self.payLabel = payLabel;
        UIButton *addbtn = [self.view createButtonFrame:CGRectMake(_paybottomView.width - 100, 10, 80,_paybottomView.height - 20) imageName:nil title:ADLString(@"确认支付") titleColor:[UIColor whiteColor] font:14 target:self action:@selector(changedpaybtn)];
        addbtn.layer.masksToBounds = YES;
        addbtn.layer.cornerRadius = 5;
        addbtn.backgroundColor = COLOR_E0212A;
        [_paybottomView addSubview:addbtn];
        _paybottomView.backgroundColor = [UIColor whiteColor];
    }
    return _paybottomView;
}


#pragma mark ------ 支付------
-(void)changedpaybtn {
    
    
  
    for (int i= 1; i < self.teleFieldArray.count; i++) {
        NSArray *array = self.teleFieldArray[i];
        for (int j = 0; j<array.count; j++) {
            NSString *str = array[j];
            
            if (j == 0) {
                if (str.length == 0) {
                    [ADLToast showMessage:[NSString stringWithFormat:@"%@%d%@",ADLString(@"请填写第"),i,ADLString(@"位客人手机号")]];
                    return ;
                }else    if (str.length > 16 || str.length < 6){
                    [ADLToast showMessage:[NSString stringWithFormat:@"%@%d%@",ADLString(@"第"),i,ADLString(@"位客人手机格式不正确")]];
                       return ;
                }
            }else if(j == 1){
                if (str.length == 0) {
                    [ADLToast showMessage:[NSString stringWithFormat:@"%@%d%@",ADLString(@"请填写第"),i,ADLString(@"位客人姓名")]];
                       return ;
                }
            }else if(j == 2){
             
            }else if(j == 3){
               
            }else if(j == 4){
                if (str.length > 0) {
                    if (![ADLUtils verifyEmailAddress:str]) {
                        [ADLToast showMessage:@"请输入正确的邮箱账号"];
                        return;
                    }
                }
            }
            
            
           
          
        }
     
    }
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"roomSellTypeId"] =self.mode.roomSellTypeId;//销售房型id
    params[@"payPrice"] =@(self.mode.discountsPrice*self.numberDate);//付款价格 该处填入 是优惠价*天数
    params[@"startDatetime"] = [ADLUtils timestampWithDateStr:self.startTime format:@"YYYY-MM-dd"];//开始时间
    params[@"endDatetime"] =[ADLUtils timestampWithDateStr:self.endTime format:@"YYYY-MM-dd"];//结束时间
    params[@"expectCheckInDatetime"] =[ADLUtils timestampWithDateStr:self.checkTime format:@"YYYY-MM-dd HH:mm"];//预计入住时间
    NSString* str = [self dictionaryToJsonString:self.teleFieldArray];
    [params setValue:str forKey:@"guests"];//入住客人,必须有一个
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    // WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_roomSellOrder_add parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            
           
            ADLHotelOrderPayController *VC= [[ADLHotelOrderPayController alloc]init];
            VC.payType =2;
           // VC.dict = responseDict[@"data"];
            VC.roomSellOrderId = responseDict[@"data"][@"roomSellOrderId"];
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        
    } failure:^(NSError *error) {
        
    }];


}
-(NSMutableArray *)titleArray {
    if (!_titleArray) {
        NSMutableArray *titleArray = [NSMutableArray array];
        NSDictionary *dict = [self dictionaryWithJsonString:self.mode.facility];
        NSMutableArray *arr = dict[@"datas"];
        for (int i = 0; i < arr.count; i++) {
            for (NSDictionary *dict in arr) {
                [titleArray addObject:dict[@"itemName"]];
            }
        }
        _titleArray =[NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%@",ADLString(@"入住时间")],
                                                      [NSString stringWithFormat:@"%@:%@",ADLString(@"房间设备"),[titleArray componentsJoinedByString:@","]],
                                                      [NSString stringWithFormat:@"%@; %@",ADLString(@"地址"),self.mode.address],
                                                      [NSString stringWithFormat:@"%@:1",ADLString(@"房间数量")]]];
    }
    return _titleArray;
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
-(NSMutableArray *)teleFieldArray {
    if (!_teleFieldArray) {
        _teleFieldArray = [NSMutableArray array];
        [_teleFieldArray addObject:[NSMutableArray arrayWithArray:@[@"",@"",@"",@""]]];
        [_teleFieldArray addObject:[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"0"]]];
    }
    return _teleFieldArray;
}
-(NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[ADLString(@"手机号:"),ADLString(@"姓名:"),ADLString(@"身份证号:"),ADLString(@"账号:"),ADLString(@"邮箱:")]];
        [_array addObject:self.titleArray];
        [_array addObject:array];
    }
    return _array;
}

-(NSMutableArray *)placeholderArray {
    if (!_placeholderArray) {
        _placeholderArray = [NSMutableArray array];
        
        NSMutableArray *arr =[NSMutableArray arrayWithArray:@[ADLString(@"请输入手机号"),ADLString(@"请输入姓名"),ADLString(@"请输入身份证号"),ADLString(@"请输入账号"),ADLString(@"请输入邮箱")]];
        
        [_placeholderArray addObject:[NSMutableArray arrayWithArray:@[@"",@"",@"",@""]]];
        [_placeholderArray addObject:arr];
    }
    return _placeholderArray;
}
-(void)dealloc {
       [[ADLKeyboardMonitor monitor] setEnable:NO];
}



//1天  --  7天
-(void)datestr:(NSInteger)date {
    NSInteger dis = 1; //前后的天数
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    
    self.startTime = currentString;
    
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
    //yyyy-MM-dd hh:mm:ss
    NSDateFormatter *theDateformatter = [[NSDateFormatter alloc] init];
    [theDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string=[theDateformatter stringFromDate:theDate];
    
    self.endTime = string;
    
  self.numberDate =[ADLUtils fateDifferenceWithStartTime:[self timestampWithDateStr:self.startTime format:@"YYYY-MM-dd"] endTime:[self timestampWithDateStr:self.endTime format:@"YYYY-MM-dd"]];
    
             self.array[0][0] =[NSString stringWithFormat:@"%@: %@ - %@          共%ld天",ADLString(@"入住时间"),self.startTime,self.endTime,self.numberDate];
}

#pragma mark ------ 时间字符串转时间戳 ------
- (NSData *)timestampWithDateStr:(NSString *)dateStr format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}
@end
