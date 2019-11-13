//
//  ADLChainlockrecordController.m
//  ADEL-APP
//
//  Created by adel on 2019/8/28.
//

#import "ADLChainlockrecordController.h"
#import "ADLChainlockrecordCell.h"
#import "ADLBlockchainLockModel.h"

@interface ADLChainlockrecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UIView *backheadView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic ,assign)NSInteger page;
@end

@implementation ADLChainlockrecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    self.view.backgroundColor = [UIColor whiteColor];
    
   self.tableView.tableHeaderView =self.backheadView;
  
   [self.view addSubview:self.tableView];
   
    [self blockchainsearc];
    WS(ws);
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.array removeAllObjects];
        ws.page = 1;
        ws.tableView.mj_footer.hidden = NO;
        [ws blockchainsearc];
    }];
    //  [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.page ++;
        [ws blockchainsearc];
    }];

   [self addRedNavigationView:ADLString(@"区块链查询结果")];
    
}
//用户区块链查询 - 用户端查询
-(void)blockchainsearc{
    //dict[@"F0FE6BF23EBA"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
     params[@"userId"] = [ADLUserModel readUserModel].userId;//设备id
    params[@"deviceId"] = self.deviceId;//设备id
    params[@"startTime"] =[self dateStr:[NSString stringWithFormat:@"%@:00",self.stardate]];//开始时间
    params[@"endTime"] = [self dateStr:[NSString stringWithFormat:@"%@:00",self.enddate]];//开始时间
     params[@"page"] = @(self.page);//查询的页数 默认1
    params[@"terminal"] =[ADLBlockchainLockModel getIphoneType];//手机终端：华为P30，PC终端：QQ浏览器,phone：huawei P30，PC：QQBrowser
       params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
    //进行POST请求
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ADLNetWorkManager postWithPath:ADEL_blockchain_searc parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
        ADLLog(@"%@",responseDict);
    //    [MBProgressHUD hideHUDForView:ws.view animated:YES];
        
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            NSMutableArray *array = [ADLBlockchainLockModel mj_objectArrayWithKeyValuesArray:dict[@"info"]];
            
            if (array.count > 0) {
                [self.array addObjectsFromArray:array];
                //                "currentPage": "int 当前页码",
                //                "totalPage": "int 总页数"
                if (ws.array.count == [responseDict[@"totalPage"] integerValue]) {
                    ws.tableView.mj_footer.hidden = YES;
               
                }
                
            }else {
              
                ws.tableView.mj_footer.hidden = YES;
            }
            [ws.tableView reloadData];
        }else {
          //  [ADLPromptMwssage showErrorMessage:response[@"msg"] inView:ws.view];
        }
    } failure:^(NSError *error) {
        
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
      //  [MBProgressHUD hideHUDForView:ws.view animated:YES];
    }];
}
-(NSString *)dateStr:(NSString *)str {
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(为了转换成功)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:str];
    
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
    
    
}
-(NSMutableArray *)array {
    
    if (!_array) {
    _array = [NSMutableArray array]; 
    }
    return _array;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLChainlockrecordCell *cell = [ADLChainlockrecordCell cellWithTableView:tableView];
    cell.model = self.array[indexPath.row];
    cell.lockName.text = self.LockName;
    cell.number.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    return  125;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//查询线下客房
-(void)queryOfflineroom{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyId"] =  @"";//酒店ID
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    WS(ws);
    //查询线上,
    [ADLNetWorkManager postWithPath:ADEL_roomTypeManage_search parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        // ADLLog(@"%@",response);
      //  [MBProgressHUD hideHUDForView:ws.view animated:YES];
        if ([responseDict[@"code"] integerValue] == 10000) {
            
        }else {
           // [ADLPromptMwssage showErrorMessage:response[@"msg"] inView:ws.view];
        }
    } failure:^(NSError *error) {
          //   [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}


-(UIView *)backheadView {
    if (!_backheadView) {
        _backheadView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 130)];
         _backheadView.backgroundColor = [UIColor clearColor];
       
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 130)];
        
        backView.backgroundColor = COLOR_E0212A;
        
        [_backheadView addSubview:backView];
        
        NSString *nickName =[ADLUserModel readUserModel].phone;
        if (nickName.length == 0) {
         nickName =[ADLUserModel readUserModel].email;
        }
        
        UILabel *title = [self.view createLabelFrame:CGRectMake(40,10, SCREEN_WIDTH-60, 13) font:13 text:[NSString stringWithFormat:@"%@:%@",ADLString(@"账号"),nickName] texeColor:[UIColor whiteColor]];
        [_backheadView addSubview:title];
        
        UILabel *loackType = [self.view  createLabelFrame:CGRectMake(40,CGRectGetMaxY(title.frame)+10, SCREEN_WIDTH-60, 13) font:13 text:[NSString stringWithFormat:@"%@:%@",ADLString(@"锁"),self.LockName] texeColor:[UIColor whiteColor]];
        [_backheadView addSubview:loackType];
        
        UILabel *time = [self.view  createLabelFrame:CGRectMake(40,CGRectGetMaxY(loackType.frame)+10, SCREEN_WIDTH-60, 14) font:14 text:ADLString(@"查询时间:") texeColor:[UIColor whiteColor]];
        [_backheadView addSubview:time];
        
        
        UIView *lien = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40,CGRectGetMaxY(time.frame)+20,80, 2)];
        lien.backgroundColor = [UIColor whiteColor];
        [_backheadView addSubview:lien];
        
        UILabel *stardate= [self.view  createLabelFrame:CGRectMake(10,CGRectGetMaxY(time.frame)+15,SCREEN_WIDTH /2 - 80, 14) font:13 text:ADLString(@"开始日期") texeColor:[UIColor whiteColor]];
        stardate.textAlignment = NSTextAlignmentRight;
        [_backheadView addSubview:stardate];
        
        UILabel *enddate = [self.view  createLabelFrame:CGRectMake(CGRectGetMaxX(lien.frame)+30,stardate.y, SCREEN_WIDTH /2 - 80, 13) font:13 text:ADLString(@"结束日期") texeColor:[UIColor whiteColor]];
        [_backheadView addSubview:enddate];
        
        
        UILabel *startime = [self.view  createLabelFrame:CGRectMake(0,CGRectGetMaxY(enddate.frame)+10, SCREEN_WIDTH/2, 13) font:10 text:self.stardate texeColor:[UIColor whiteColor]];
            startime.textAlignment = NSTextAlignmentCenter;
        [_backheadView addSubview:startime];
         
         UILabel *endtime = [self.view createLabelFrame:CGRectMake(SCREEN_WIDTH- startime.width,startime.y, SCREEN_WIDTH/2, 13) font:10 text:self.enddate texeColor:[UIColor whiteColor]];
            endtime.textAlignment = NSTextAlignmentCenter;
         [_backheadView addSubview:endtime];
        
    }
    return _backheadView;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

@end
