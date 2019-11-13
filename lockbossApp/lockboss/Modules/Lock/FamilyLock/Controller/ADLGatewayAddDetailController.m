//
//  ADLGatewayAddDetailController.m
//  lockboss
//
//  Created by adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLGatewayAddDetailController.h"

#define leftTableViewTag 1000
#define rightTableViewTag 2000

#import <UIImageView+WebCache.h>

#import "ADLGatewayAddDetailLeftCell.h"

#import "ADLGatewayAddDetailRightCell.h"

#import "ADLSearchView.h"

#import "ADLDeviceTypeModel.h"

#import "ADLAddDeviceStepOneController.h"

//static CGFloat searchViewH = 88;

@interface ADLGatewayAddDetailController ()<UITableViewDelegate ,UITableViewDataSource,ADLSearchViewDelegate>

@property (nonatomic ,strong) ADLSearchView *searchView; //搜索view

@property (nonatomic ,strong) UITableView *leftTableView; //左侧导航

@property (nonatomic ,strong) UITableView *rightTableView; //右侧内容

@property (nonatomic ,strong) NSMutableArray *leftDataArray; //左侧数据源

@property (nonatomic ,strong) NSMutableArray *rightDataArray; //右侧数据源

@property (nonatomic,assign) NSInteger currentRow;//当前选择的组,用于左右定位

@property (nonatomic ,assign) CGFloat searchViewH;

@end

@implementation ADLGatewayAddDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addRedNavigationView:@"绑定设备"];
    self.searchViewH = NAVIGATION_H;
    self.currentRow = 0;
    
    [self.view addSubview:self.searchView];
    
    [self.view bringSubviewToFront:self.navigationView];
    
    [self.view addSubview:self.leftTableView];
    
    UIView *shuxianView = [[UIView alloc] initWithFrame:CGRectMake(81,NAVIGATION_H+NAVIGATION_H-STATUS_HEIGHT, 0.5,SCREEN_HEIGHT - NAVIGATION_H-BOTTOM_H-NAVIGATION_H)];
    shuxianView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    
    [self.view addSubview:shuxianView];
    
    [self.view addSubview:self.rightTableView];
    [self getDataSource];
    
}

#pragma mark ---------------------- 搜索 ----------------------
-(ADLSearchView *)searchView {
    if (!_searchView) {
        // -40 ,40被压在navigationView下;
        _searchView = [[ADLSearchView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-STATUS_HEIGHT, SCREEN_WIDTH, NAVIGATION_H) placeholder:@"请输入需要绑定的设备名称" instant:YES];
        _searchView.done = NO;
        _searchView.delegate = self;
        _searchView.divisionView.hidden = YES;
    }
    return _searchView;
}

#pragma mark ------ ADLSearchViewDelegate ------
- (void)didClickCancleButton {
    [self customPopViewController];
}

- (void)didClickSearchButton:(UITextField *)textField {
    NSString *text = textField.text;
    if ([text isEqualToString:@""]) {
        [ADLToast showMessage:@"请输入您要的商品名称"];
        return;
    }
    if ([ADLUtils hasEmoji:text]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    
//    if ([self.historyArr containsObject:text]) {
//        [self.historyArr removeObject:text];
//    }
//    [self.historyArr insertObject:text atIndex:0];
//    [ADLUtils saveObject:self.historyArr fileName:GOODS_SEARCH_HISTORY permanent:NO];
//
//    if (self.tableView.tableHeaderView != nil) {
//        self.tableView.tableHeaderView = nil;
//        self.tableView.tableFooterView = [UIView new];
//    }
//
//    [textField resignFirstResponder];
//    self.offset = 0;
//    self.text = text;
//    [self loadData];
}

- (void)textFieldTextDidChanged:(NSString *)text {
//    if ([text isEqualToString:@""] && self.historyArr.count > 0) {
//        [self.dataArr removeAllObjects];
//        [self.rowHArr removeAllObjects];
//        [self.dataArr addObjectsFromArray:self.historyArr];
//        for (int i = 0; i < self.historyArr.count; i++) {
//            [self.rowHArr addObject:@(ROW_HEIGHT)];
//        }
//        self.tableView.tableHeaderView = self.headView;
//        self.tableView.tableFooterView = self.footView;
//        self.tableView.mj_footer.hidden = YES;
//        if (self.dataArr.count == 0) {
//            self.tableView.backgroundColor = COLOR_F2F2F2;
//        } else {
//            self.tableView.backgroundColor = [UIColor whiteColor];
//        }
//        [self.tableView reloadData];
//    }
}

#pragma mark ------ 搜索数据 ------
- (void)loadData {
//    if (self.offset == 0) {
//        [self.dataArr removeAllObjects];
//        [self.rowHArr removeAllObjects];
//        [ADLToast showLoadingMessage:@"搜索中..."];
//    }
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setValue:@(self.offset) forKey:@"offset"];
//    [params setValue:@(self.pageSize) forKey:@"pageSize"];
//    [params setValue:self.text forKey:@"goodsName"];
//    [params setValue:@"false" forKey:@"needCondition"];
//
//    [ADLNetWorkManager postWithPath:k_search_goods parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
//        if ([responseDict[@"code"] integerValue] == 10000) {
//            NSArray *resArr = responseDict[@"data"][@"pageInfo"][@"rows"];
//            if (resArr.count > 0) {
//                [self.dataArr addObjectsFromArray:resArr];
//                for (NSDictionary *dict in resArr) {
//                    NSString *str = [dict[@"goodsName"] stringValue];
//                    CGFloat strH = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil].size.height+20;
//                    if (strH < ROW_HEIGHT) {
//                        strH = ROW_HEIGHT;
//                    }
//                    [self.rowHArr addObject:@(strH)];
//                }
//                [self.tableView.mj_footer endRefreshing];
//                if (resArr.count < self.pageSize) {
//                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//                [ADLToast hide];
//            } else {
//                if (self.offset == 0) {
//                    [ADLToast showMessage:@"没有搜索到商品"];
//                } else {
//                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//            }
//            self.offset = self.dataArr.count;
//            if (self.dataArr.count >= self.pageSize) {
//                self.tableView.mj_footer.hidden = NO;
//            } else {
//                self.tableView.mj_footer.hidden = YES;
//            }
//        }
//        if (self.dataArr.count > 0) {
//            self.tableView.backgroundColor = [UIColor whiteColor];
//        } else {
//            self.tableView.backgroundColor = COLOR_F2F2F2;
//        }
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        [self.tableView.mj_footer endRefreshing];
//    }];
}

#pragma mark ------ 退出键盘 ------
- (void)exitKeyboard {
    [self.view endEditing:YES];
}


#pragma mark ---------------------- UITableVeiw ----------------------
-(NSMutableArray *)leftDataArray {
    if (!_leftDataArray) {
        _leftDataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _leftDataArray;
}
-(NSMutableArray *)rightDataArray {
    if (!_rightDataArray) {
        _rightDataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _rightDataArray;
}

-(void)getDataSource {
    
//    self.leftDataArray = [@[@"储物",@"厨电"] mutableCopy];
    
//    NSArray *rigArr = @[
//                      @{@"deviceType":@"51",
//                        @"deviceTypeName":@"储物箱",
//                        @"deviceCategoryId":@"2312",
//                        @"deviceCategoryName":@"dasdas",
//                        @"linkType":@"1"
//                        },
//                      @{@"deviceType":@"41",
//                        @"deviceTypeName":@"燃气阀",
//                        @"deviceCategoryId":@"2312",
//                        @"deviceCategoryName":@"dasdas",
//                        @"linkType":@"1"
//
//                        }];
//     NSArray *modelArray = [ADLDeviceTypeModel mj_objectArrayWithKeyValuesArray:rigArr];
//
//     self.rightDataArray = [modelArray mutableCopy];
    
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"1181857551453655040" forKey:@"deviceId"];

    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_get_deviceType_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
//        [weakself.mainCollectionView.mj_header endRefreshing];
        ADLLog(@"获取设备类型列表信息------ %@",responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *allData = responseDict[@"data"];
            if (allData && allData.count > 0) {
                for (int i=0; i<allData.count; i++) {
                    
                    //先这样写死  TODO
                    
                    NSDictionary *deviceTypeDic = allData[i];
                    
                    NSString *typeNum = (NSString *)deviceTypeDic[@"deviceType"];
                    
                    if([typeNum isEqualToString:@"41"]){
                        NSArray *modelArray = [ADLDeviceTypeModel mj_objectArrayWithKeyValuesArray:@[deviceTypeDic]];
                        [self.rightDataArray addObject:modelArray];
                        [self.leftDataArray addObject:@"厨电"];
                    }else if([typeNum isEqualToString:@"51"]){
                        NSArray *modelArray = [ADLDeviceTypeModel mj_objectArrayWithKeyValuesArray:@[deviceTypeDic]];
                        [self.rightDataArray addObject:modelArray];
                        [self.leftDataArray addObject:@"储物"];
                        
                    }
                    
                }
                
            }
            [self.leftTableView reloadData];
            [self.rightTableView reloadData];
        }
    } failure:^(NSError *error) {
//        [self.mainCollectionView.mj_header endRefreshing];
        ADLLog(@"error === %@",error);
    }];
    
}


-(UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_H+NAVIGATION_H-STATUS_HEIGHT, 80, SCREEN_HEIGHT - NAVIGATION_H-BOTTOM_H-NAVIGATION_H) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.tableFooterView.hidden = YES;
        _leftTableView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        _leftTableView.tag = leftTableViewTag;
    }
    return  _leftTableView ;
}

-(UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(80+1+10, NAVIGATION_H+NAVIGATION_H-STATUS_HEIGHT, SCREEN_WIDTH - 80-1-10, SCREEN_HEIGHT - NAVIGATION_H-BOTTOM_H-NAVIGATION_H) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView.hidden = YES;
        _rightTableView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        _rightTableView.tag = rightTableViewTag;
    }
    return  _rightTableView ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==rightTableViewTag){
        return self.rightDataArray.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==leftTableViewTag){
        return self.leftDataArray.count;
    }
    return [self.rightDataArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==leftTableViewTag){
        return 50;
    }
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==leftTableViewTag){
        ADLGatewayAddDetailLeftCell *cell = [ADLGatewayAddDetailLeftCell cellWithTableView:tableView];
        cell.titLab.text = self.leftDataArray[indexPath.row];
        if (indexPath.row == self.currentRow) {
            cell.isSelected = YES;
        }else{
            cell.isSelected = NO;
        }
        return cell;
    }else{
        ADLGatewayAddDetailRightCell *cell = [ADLGatewayAddDetailRightCell cellWithTableView:tableView];
        cell.deviceTypeModel = self.rightDataArray[indexPath.section][indexPath.row];
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag==leftTableViewTag){
        return 0;
    }
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag ==rightTableViewTag){
        UIView * headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel * label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 80, 60);
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:12];
        label.text = self.leftDataArray[section];
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headerView.mas_centerX).offset(0);
            make.centerY.mas_equalTo(headerView.mas_centerY).offset(0);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(60);
        }];
        UIView *leftLineVeiw = [self horizontalLineVeiw];
        UIView *rightLineVeiw = [self horizontalLineVeiw];
        [headerView addSubview:leftLineVeiw];
        [headerView addSubview:rightLineVeiw];
        [leftLineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(label.mas_left).offset(0);
            make.centerY.mas_equalTo(headerView.mas_centerY).offset(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(0.5);
        }];
        [rightLineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).offset(0);
            make.centerY.mas_equalTo(headerView.mas_centerY).offset(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(0.5);
        }];
        
        
        //        用中间变量记录当前显示的是哪一个区
        //        self.currentRow = section;
        //        调用系统方法，左列表会随着右列表的滑动自动切换
        //        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        //        [self.leftTableView reloadData];
        return headerView;
    }
    return nil;
}

-(UIView *)horizontalLineVeiw{
    UIView *horView = [[UIView alloc] init];
    horView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    return  horView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==leftTableViewTag){
        self.currentRow = indexPath.row;
        [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.leftTableView reloadData];
    }else{
        ADLAddDeviceStepOneController *oneStepVC = [[ ADLAddDeviceStepOneController alloc] init];
        oneStepVC.deviceTypeModel  = self.rightDataArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:oneStepVC animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableView * tableView = (UITableView*)scrollView;
    if (tableView == self.rightTableView){
        NSIndexPath * indexPath = [self.rightTableView indexPathForRowAtPoint:scrollView.contentOffset];
        _currentRow = indexPath.section;
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.leftTableView reloadData];
    }
}


@end
