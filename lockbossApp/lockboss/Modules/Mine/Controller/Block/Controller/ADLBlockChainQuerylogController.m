//
//  ADLBlockChainQuerylogController.m
//  ADEL-APP
//
//  Created by adel on 2019/8/29.
//

#import "ADLBlockChainQuerylogController.h"
#import "ADLBlockChainQuerylogCell.h"

#import "ADLBlockchainLockModel.h"
@interface ADLBlockChainQuerylogController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UIView *backheadView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic ,assign)NSInteger page;
@end

@implementation ADLBlockChainQuerylogController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView =self.backheadView;
    

 
    WS(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.array removeAllObjects];
        ws.tableView.mj_footer.hidden = NO;
        [ws blockchainsearc:@""];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (ws.array > 0) {
            ADLBlockchainLockModel *model = ws.array.lastObject;
            [ws blockchainsearc:model.id];
        }else {
            [ws blockchainsearc:@""];
            ws.tableView.mj_footer.hidden = NO;
        }
        
   
    }];
    
    [self blockchainsearc:@""];
   [self addRedNavigationView:ADLString(@"查询日志")];
}

//查询日志列表
-(void)blockchainsearc:(NSString *)logID{
    //dict[@"F0FE6BF23EBA"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (logID.length > 0) {
        params[@"id"] =logID;//主键，不传默认第一页 倒排序
    }
    params[@"deviceId"] = self.deviceId;//设备ID
     params[@"type"] = @(1);//1：个人，2：企业
    params[@"sign"] = [ADLUtils handleParamsSign:params];

    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_blockchain_recordlist parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
       [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        ADLLog(@"%@",responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
            //     NSDictionary *dict = response[@"data"];
            NSMutableArray *array = [ADLBlockchainLockModel mj_objectArrayWithKeyValuesArray: responseDict[@"data"]];
            
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
           // [ADLPromptMwssage showErrorMessage:response[@"msg"] inView:ws.view];
        }
    } failure:^(NSError *error) {
        
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        
    }];
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
    ADLBlockChainQuerylogCell *cell = [ADLBlockChainQuerylogCell cellWithTableView:tableView];
    cell.number.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.model = self.array[indexPath.row];
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return  110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(UIView *)backheadView {
    if (!_backheadView) {
        _backheadView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 100)];
        _backheadView.backgroundColor = COLOR_E0212A;
        
        
//        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 120)];
//
//        backView.backgroundColor = Colorad2f2d;
//
//        [_backheadView addSubview:backView];
        NSString *nickName =[ADLUserModel readUserModel].phone;
        if (nickName.length == 0) {
            nickName =[ADLUserModel readUserModel].email;
        }
        
        UILabel *title = [self.view createLabelFrame:CGRectMake(40,20, SCREEN_WIDTH-60, 13) font:13 text:[NSString stringWithFormat:@"%@:%@",ADLString(@"账号"),nickName] texeColor:[UIColor whiteColor]];
        [self.backheadView addSubview:title];
        
        NSString *strtime= [NSString stringWithFormat:@"%@: %@ %@",ADLString(@"查询权限"),ADLString(@"截止"),[ADLUtils timestampWithDateStr:self.enddate format:@"YYYY-MM-dd HH:mm:ss"]];
        
        UILabel *time = [self.view createLabelFrame:CGRectMake(40,CGRectGetMaxY(title.frame)+20, SCREEN_WIDTH-60, 14) font:12 text:strtime texeColor:[UIColor whiteColor]];
        [_backheadView addSubview:time];
        
        
//        UIView *lien = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40,CGRectGetMaxY(time.frame)+20,80, 2)];
//        lien.backgroundColor = [UIColor whiteColor];
//        [_backheadView addSubview:lien];
//
//        UILabel *stardate= [self createLabelFrame:CGRectMake(10,CGRectGetMaxY(time.frame)+15,SCREEN_WIDTH /2 - 80, 14) font:FontSize13 text:KLocalizableStr(@"开始日期") texeColor:Colorefefef];
//        stardate.textAlignment = NSTextAlignmentRight;
//        [_backheadView addSubview:stardate];
//
//        UILabel *enddate = [self createLabelFrame:CGRectMake(CGRectGetMaxX(lien.frame)+30,stardate.y, SCREEN_WIDTH /2 - 80, 13) font:FontSize13 text:KLocalizableStr(@"结束日期") texeColor:Colorefefef];
//        [_backheadView addSubview:enddate];
//
//
//        UILabel *startime = [self createLabelFrame:CGRectMake(0,CGRectGetMaxY(enddate.frame)+10, SCREEN_WIDTH/2, 13) font:FontSize10 text:[ADLDateTool dateTimeday:self.stardate] texeColor:Colorefefef];
//        startime.textAlignment = NSTextAlignmentCenter;
//        [_backheadView addSubview:startime];
//
//        UILabel *endtime = [self createLabelFrame:CGRectMake(SCREEN_WIDTH- startime.width,startime.y, SCREEN_WIDTH/2, 13) font:FontSize10 text:[ADLDateTool dateTimeday:self.enddate] texeColor:Colorefefef];
//        endtime.textAlignment = NSTextAlignmentCenter;
//        [_backheadView addSubview:endtime];
        
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
