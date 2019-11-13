//
//  ADLBlockchainLockView.m
//  lockboss
//
//  Created by adel on 2019/11/1.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBlockchainLockView.h"
#import "ADLBlockchainLockModel.h"
#import "ADLNetWorkManager.h"
#import "ADELUrlpath.h"
//#import "ADLADLFameiyListDataCell.h"
@interface ADLBlockchainLockView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak)UIVisualEffectView * effe;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@end

@implementation ADLBlockchainLockView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.7;
        //  backView.frame = CGRectMake(18, lognViewY, screenWidth-36, 300, 300);
        //backView.backgroundColor = [UIColor blackColor];
        //backView.hidden = YES;
        [self addSubview:backView];
        _backView = backView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [backView addGestureRecognizer:tap];
        
        UIView *titleView = [[UIView alloc] init];
        titleView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2+50);
        titleView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:titleView];
        self.titleView = titleView;
        UILabel *titleLock = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, SCREEN_WIDTH - 160, 30)];
        titleLock.textAlignment = NSTextAlignmentCenter;
        titleLock.font = [UIFont systemFontOfSize:14];
        titleLock.textColor = COLOR_333333;
        titleLock.text = ADLString(@"我的门锁");
        [self.titleView addSubview:titleLock];
        
        UIButton *btn = [self createButtonFrame:CGRectMake(SCREEN_WIDTH - 40, 5, 30, 30) imageName:nil title:nil titleColor:nil font:12 target:self action:@selector(btnout)];
        [btn setImage:[UIImage imageNamed:@"icon_switck_lock_out"] forState:UIControlStateNormal];
        
        //UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 34, 10, 24, 24)];
        //icon.contentMode = UIViewContentModeScaleAspectFit;
        //icon.image = [UIImage imageNamed:@"icon_switck_lock_out"];
        [self.titleView addSubview:btn];
        
        UITableView *tableView = [[UITableView alloc]init];
        tableView.frame  = CGRectMake(0,40, SCREEN_WIDTH,SCREEN_HEIGHT/2);
        // tableView.backgroundColor = Coloreeeeee;
        // tableView.backgroundColor = [UIColor whiteColor];
        tableView.alpha = 0.98;
        // tableView.bounces = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.tableFooterView = [UIView new];
        [self.titleView addSubview:tableView];
        self.tableView = tableView;
        
       // [self dataSelectEquipment];
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.titleView.frame = CGRectMake(0,SCREEN_HEIGHT/2 - 40, SCREEN_WIDTH,SCREEN_HEIGHT/2+40);
            //  self.tableView.frame  =  CGRectMake(0,50, screenWidth,screenHeight/2);
            
        } completion:nil];
        
        WS(ws);
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //客房信息接口
            [ws dataSelectEquipment];
            
        } ];
        
    }
    return self;
}
//查询用户设备信息
-(void)dataSelectEquipment{
  
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] =  @(1);
    params[@"sign"] = [ADLUtils handleParamsSign:params];
   [ADLToast showLoadingMessage:ADLString(@"loading")];
     WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_blockchain_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                    [ADLToast hide];
                [ws.gouponsArray removeAllObjects];
         if ([responseDict[@"code"] integerValue] == 10000) {
        self.gouponsArray = [ADLBlockchainLockModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
                [ws.tableView reloadData];
                }
        
    } failure:^(NSError *error) {
        
     [ADLToast hide];
        
    }];
}

-(void)setGouponsArray:(NSMutableArray *)gouponsArray{
    
    _gouponsArray = gouponsArray;
    
    [self.tableView  reloadData];
}
-(void)btnout {
    [self remove];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.gouponsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"BlockChainQuerylogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    ADLBlockchainLockModel *model =self.gouponsArray[indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"门锁名称:%@",model.deviceName];
  //  cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,cell.height - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = COLOR_CCCCCC;
    [cell addSubview:line];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ADLBlockchainLockModel *serviceModel = self.gouponsArray[indexPath.row];
    
    if (self.devictBlock) {
        self.devictBlock(serviceModel);
    }
    [self remove];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([touches.anyObject.view isKindOfClass:[self class]]) {
        
        [self remove];
        
    }
}

- (void)remove
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:nil];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.titleView.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH,0);
        //self.tableView.frame  = CGRectMake(0,screenHeight, screenWidth, 0);
        //_backView.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
