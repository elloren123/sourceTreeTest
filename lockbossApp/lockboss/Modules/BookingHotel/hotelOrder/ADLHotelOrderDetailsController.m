//
//  ADLHotelOrderDetailsController.m
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelOrderDetailsController.h"
#import "ADLHotelOrderListCell.h"
#import "ADLBookingHotelModel.h"
#import "ADLHotelOrderCommentController.h"
#import "ADLHotelOrderModel.h"
#import "ADLHotelDetailsController.h"
#import "ADLHotelOrderPayController.h"

@interface ADLHotelOrderDetailsController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong)UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *imageArray;
@property (nonatomic ,strong)NSMutableArray *dateArray;
@property (nonatomic ,strong)UIView *paybottomView;

@property (nonatomic ,strong)UIView *footerView;

@property (nonatomic ,strong)ADLHotelOrderModel *orderModel;
@end

@implementation ADLHotelOrderDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationView:ADLString(@"订单详情")];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.paybottomView];
  
    WS(ws);
    self.tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [ws.array removeAllObjects];
        //重新刷新(从0开始)
        [ws HotenRoomData];
    }];
    
   [self HotenRoomData];
  //  [self HotenintroduceData];
    
}
-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
-(NSMutableArray *)array {
    if (!_array) {
        if (self.payType == 1 || self.payType == 4) {
          _array = [NSMutableArray arrayWithArray:@[@"",@"拨打客服电话"]];
        }else {
  _array = [NSMutableArray arrayWithArray:@[@"",@"拨打客服电话",@"支付方式:",@"支付时间:"]];
     
    }
    }
    return _array;
}

//#pragma mark ------ 酒店介绍-----
//- (void)HotenintroduceData {
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    params[@"companyId"] = self.model.companyId;//酒店ID
//    params[@"sign"] = [ADLUtils handleParamsSign:params];
//
//    WS(ws);
//    [ADLNetWorkManager postWithPath:@"http://129.204.67.226:8087/lockboss-api/app/introduce/company.do" parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
//        if ([responseDict[@"code"] integerValue] == 10000) {
//            self.model =  [ADLBookingHotelModel mj_objectWithKeyValues:responseDict[@"data"]];
//
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
//}
#pragma mark ------ 查询订单详情----
- (void)HotenRoomData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"roomSellOrderId"] = self.model.roomSellOrderId;//订单详情
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_roomSellOrder_info parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
           [ws.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
          self.orderModel =  [ADLHotelOrderModel mj_objectWithKeyValues:responseDict[@"data"]];
         
     
            NSDictionary *dict = [self dictionaryWithJsonString:self.orderModel.facility];
            NSMutableArray *arr = dict[@"datas"];
            for (NSDictionary *dict in arr) {
                [self.titleArray addObject:dict[@"itemName"]];
                NSString *sort = dict[@"sort"];
                [self.imageArray addObject:[ADLBookingHotelModel iconStr:[sort integerValue]]];
            }
              self.tableView.tableFooterView = self.footerView;
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
    }];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        ADLHotelOrderListCell *cell;
        WS(ws);
     //1未支付 4已取消
        if (self.payType == 1 || self.payType == 4) {
            cell = [ADLHotelOrderListCell cellWithTableView:tableView hotelOrderCell:ADLHotelOrderafterSaleCell];
        }else {
            cell = [ADLHotelOrderListCell cellWithTableView:tableView hotelOrderCell:ADLHotelOrderaPayCell];
        }
        
        cell.model = self.model;
        cell.clicBlock = ^(UIButton * _Nonnull btn) {
            [ws cellBlock:btn];
        };
        return cell;
    }else {
       static NSString *ID = @"SettingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 判断是否为nil
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        // 设置标题
        cell.textLabel.text = self.array[indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = COLOR_333333;
        if (indexPath.row == 1) {
  
          cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        if (indexPath.row == 1) {
           // cell.detailTextLabel.text = self.orderModel.addUserPhone;
        cell.detailTextLabel.text = self.orderModel.telephone;
        }  if (indexPath.row == 2) {
            if ([self.orderModel.payType isEqualToString:@"1"]) {
                 cell.detailTextLabel.text =ADLString(@"微信支付");
            }else {
                 cell.detailTextLabel.text =ADLString(@"支付宝支付");
            }
       
        }  if (indexPath.row == 3) {
            cell.detailTextLabel.text = [ADLUtils getDateFromTimestamp:self.orderModel.addDatetime format:@"YYYY-MM-dd HH:mm:ss"];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,cell.height - 0.5,SCREEN_WIDTH, 0.5)];
        line.backgroundColor = COLOR_CCCCCC;
        [cell addSubview:line];
        return cell;
    }
    return 0;
   
}
-(void)cellBlock:(UIButton *)btn{
    WS(ws);
    if ([btn.titleLabel.text isEqualToString:ADLString(@"删除")]) {
        [ADLAlertView showWithTitle:ADLString(@"你确定要删除订单吗?") message:nil confirmTitle:nil confirmAction:^{
            [ws reminderView:btn];
            
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }else {
        [ADLAlertView showWithTitle:ADLString(@"你确定要取消订单吗?") message:nil confirmTitle:nil confirmAction:^{
            [ws reminderView:btn];
            
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}
-(void)reminderView:(UIButton *)btn{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"roomSellOrderId"] = self.model.roomSellOrderId;
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    NSString *strUrl;
    if ([btn.titleLabel.text isEqualToString:ADLString(@"删除")]) {
        
        strUrl =ADEL_hotel_roomSellOrder_cancel;
    }else   if ([btn.titleLabel.text isEqualToString:ADLString(@"取消")]) {
        
        strUrl =ADEL_hotel_roomSellOrder_cancel;
    }
     WS(ws);
    [ADLNetWorkManager postWithPath:strUrl parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ws.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        //1未支付
        if (self.payType == 1) {
            return  230;
        }else {
            return  210;
        }
      
    }else {
      return  44;
      
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //,@"去评论",@"拨打客服电话",@"支付方式:",@"支付时间:"
     NSString *str = self.array[indexPath.row];
    
    if ([str isEqualToString:@"去评论"]) {
        ADLHotelOrderCommentController *vc =[[ADLHotelOrderCommentController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([str isEqualToString:@"拨打客服电话"]) {
        
    }
 
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H,SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H- 52) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // _tableView.bounces = NO;
//        _tableView.sectionHeaderHeight = 5;
//        _tableView.sectionFooterHeight = 5;
        //  _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor =[UIColor whiteColor];;
        // _tableView.alpha = 0.7;
        //   _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}
-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 100)];
        _footerView.backgroundColor =  [UIColor whiteColor];
        UILabel *policy;
        if (self.orderModel.refundAdminDes > 0) {
            CGFloat destextH = [ADLUtils calculateString:[NSString stringWithFormat:@"拒绝原因: %@",self.orderModel.refundAdminDes] rectSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) fontSize:12].height;
            UILabel *destext = [self.view createLabelFrame:CGRectMake(20,10,SCREEN_WIDTH - 40,destextH) font:12 text:[NSString stringWithFormat:@"拒绝原因: %@",self.orderModel.refundAdminDes] texeColor:COLOR_E0212A];
            destext.numberOfLines = 0;
            [_footerView addSubview:destext];
            
           UIView  *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(destext.frame)+15,SCREEN_WIDTH,5)];
            line.backgroundColor = COLOR_E5E5E5;
            [_footerView addSubview:line];
            
            policy = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(line.frame)+10,160,15) font:14 text:ADLString(@"客房设备") texeColor:COLOR_333333];
            policy.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [_footerView addSubview:policy];
        }else {
            UIView  *line = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,5)];
            line.backgroundColor = COLOR_E5E5E5;
            [_footerView addSubview:line];
            policy = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(line.frame)+10,160,15) font:14 text:ADLString(@"客房设备") texeColor:COLOR_333333];
            policy.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [_footerView addSubview:policy];
        }

     
        
        int margin = 5;//间隙
        
        int widthbtn = (SCREEN_WIDTH - 40)/7;//格子的宽
        
        int heightbtn = 60;//格子的高
        UIButton * btn;
        for (int i = 0; i < self.titleArray.count; i++) {
            int row = i/6;
            int col = i%6;
            btn = [self.view createButtonFrame:CGRectMake(25+col*(widthbtn+margin), CGRectGetMaxY(policy.frame)+10+row*(heightbtn+margin), widthbtn,  heightbtn) imageName:self.imageArray[i] title:self.titleArray[i] titleColor:COLOR_333333 font:10 target:self action:nil];
            // btn.backgroundColor  = COLOR_F7F7F7;
            
            btn.tag = i+1;
            [_footerView layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop createButton:btn imageTitleSpace:10];
            [_footerView addSubview:btn];
        }
        UILabel *attention;
        if(self.titleArray.count > 0){
        attention = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(btn.frame)+ 10,160, 15) font:14 text:ADLString(@"注意事项:") texeColor:COLOR_333333];
        }else {
         attention = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(policy.frame)+ 30,160, 15) font:14 text:ADLString(@"注意事项:") texeColor:COLOR_333333];
        }
     
        attention.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [_footerView addSubview:attention];
        
             CGFloat attentionContentH = [ADLUtils calculateString:self.orderModel.notes rectSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) fontSize:10].height;
        
        UILabel *attentionContent = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(attention.frame)+ 10,SCREEN_WIDTH - 40, attentionContentH) font:10 text:self.orderModel.notes texeColor:COLOR_666666];
        attentionContent.numberOfLines=  0;
        [_footerView addSubview:attentionContent];
        
        
        
        UILabel *book = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(attentionContent.frame)+ 10,160,15) font:14 text:ADLString(@"预订说明:") texeColor:COLOR_333333];
        book.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [_footerView addSubview:book];
        
        
        CGFloat bookContentH = [ADLUtils calculateString:self.orderModel.des rectSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) fontSize:10].height;
        UILabel *bookContent = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(book.frame)+ 10,SCREEN_WIDTH - 40,bookContentH) font:10 text:self.orderModel.des texeColor:COLOR_666666];
        bookContent.numberOfLines = 0;
        [_footerView addSubview:bookContent];
        
        CGFloat viewH;
        if (self.titleArray.count > 0) {
            
            if (self.titleArray.count % 6 == 0) {
                viewH =self.titleArray.count/6 * 60;
            }else {
                viewH =self.titleArray.count/6 * 60 + 60;
            }
        }else {
            viewH = 0;
            
        }
        if (self.array.count > 0) {
            viewH = self.array.count * 35+viewH;
        }
        
        
        _footerView.frame = CGRectMake(0, 0,SCREEN_WIDTH,btn.height +viewH+ attention.height+attentionContent.height+book.height+bookContent.height+100);
    }
    return _footerView;
}
-(UIView *)paybottomView {
    if (!_paybottomView) {
        
  
        
    
      _paybottomView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 52, SCREEN_WIDTH, 52)];
        UIButton *delete = [self.view createButtonFrame:CGRectMake(20, 10, 80,_paybottomView.height - 20) imageName:nil title:nil titleColor:COLOR_333333 font:14 target:self action:@selector(cellBlock:)];
        [_paybottomView addSubview:delete];
        delete.tag = 1;
      
   
        UIButton *addbtn = [self.view createButtonFrame:CGRectMake(_paybottomView.width - 100, 10, 80,_paybottomView.height - 20) imageName:nil title:nil titleColor:[UIColor whiteColor] font:14 target:self action:@selector(changedpaybtn:)];
        addbtn.layer.masksToBounds = YES;
        addbtn.layer.cornerRadius = 5;
         addbtn.tag = 2;
        addbtn.backgroundColor = COLOR_E0212A;
        [_paybottomView addSubview:addbtn];
        _paybottomView.backgroundColor =COLOR_F2F2F2;
        
        //payType;//1待支付  2已经支付 3已完成 4已取消 5退款处理中g
        if (self.payType == 1) {
            
              [delete setTitle:ADLString(@"取消") forState:UIControlStateNormal];
              [addbtn setTitle:ADLString(@"去支付") forState:UIControlStateNormal];
           
        }   if (self.payType == 2) {
              delete.hidden = YES;
            [addbtn setTitle:ADLString(@"退款") forState:UIControlStateNormal];
            
            
        }   if (self.payType == 3) {
        
            [delete setTitle:ADLString(@"删除") forState:UIControlStateNormal];
            [addbtn setTitle:ADLString(@"再次预订") forState:UIControlStateNormal];
        }
        if (self.payType == 4) {
            
            [delete setTitle:ADLString(@"删除订单") forState:UIControlStateNormal];
            [addbtn setTitle:ADLString(@"去支付") forState:UIControlStateNormal];
        }
        if (self.payType == 5) {
            
            if (self.orderModel.refundStatus == 1) {
          [addbtn setTitle:ADLString(@"退款完成") forState:UIControlStateNormal];
            }else
                if (self.orderModel.refundStatus == 2) {
            [addbtn setTitle:ADLString(@"退款中") forState:UIControlStateNormal];
                
                }else
                    if (self.orderModel.refundStatus == 3) {
            [addbtn setTitle:ADLString(@"拒绝退款") forState:UIControlStateNormal];
                      
                    }else {
            [addbtn setTitle:ADLString(@"退款中") forState:UIControlStateNormal];
                  
            }
             delete.hidden = YES;
           
             addbtn.backgroundColor = COLOR_CCCCCC;
            addbtn.userInteractionEnabled = NO;
            [addbtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
        
    }
    return _paybottomView;
}
#pragma  mark  --- 支付
-(void)changedpaybtn:(UIButton *)btn {
    ADLHotelOrderModel *model = self.orderModel;
    NSString *strUrl;
    WS(ws);
    if ([btn.titleLabel.text isEqualToString:ADLString(@"删除")]) {
        strUrl = ADEL_hotel_roomSellOrder_cancel;
        [ADLAlertView showWithTitle:ADLString(@"你确定要删除订单吗?") message:nil confirmTitle:nil confirmAction:^{
            [ws cancel:model strUrl:strUrl];
            
        } cancleTitle:nil cancleAction:nil showCancle:YES];
        
    }else   if ([btn.titleLabel.text isEqualToString:ADLString(@"退款")]) {
        ADLHotelOrderCommentController *vc = [[ADLHotelOrderCommentController alloc]init];
        vc.afterType = 2;
        vc.model = model;
         vc.model.roomSellOrderId= model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else   if ([btn.titleLabel.text isEqualToString:ADLString(@"取消")]) {
        strUrl =ADEL_hotel_roomSellOrder_cancel;
        
        [ADLAlertView showWithTitle:ADLString(@"你确定要取消订单吗?") message:nil confirmTitle:nil confirmAction:^{
            [ws cancel:model strUrl:strUrl];
            
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }else    if ([btn.titleLabel.text isEqualToString:ADLString(@"去支付")]) {
        ADLHotelOrderPayController *VC= [[ADLHotelOrderPayController alloc]init];
        VC.payType =2;
        VC.roomSellOrderId = self.model.roomSellOrderId;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else    if ([btn.titleLabel.text isEqualToString:ADLString(@"去评论")]) {
        
        ADLHotelOrderCommentController *VC= [[ADLHotelOrderCommentController alloc]init];
        VC.afterType = 1;
        VC.model = model;
        [self.navigationController pushViewController:VC animated:YES];
    }else    if ([btn.titleLabel.text isEqualToString:ADLString(@"再次预订")]) {
        ADLHotelDetailsController *vc = [[ADLHotelDetailsController alloc]init];
        //        NSMutableDictionary *dict = [model mj_keyValues];
        //        vc.model = [ADLBookingHotelModel mj_setKeyValues:dict];
        [self.navigationController pushViewController:vc animated:YES];
    }else    if ([btn.titleLabel.text isEqualToString:ADLString(@"处理中")]) {
        
    }
}

#pragma mark ------ 取消 -----
- (void)cancel:(ADLHotelOrderModel *)model strUrl:(NSString *)strUrl{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"roomSellOrderId"] = model.roomSellOrderId;
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
    [ADLNetWorkManager postWithPath:strUrl parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ws.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            
        }
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
        
    }];
}
@end
