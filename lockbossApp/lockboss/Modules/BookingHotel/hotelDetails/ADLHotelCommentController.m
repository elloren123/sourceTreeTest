//
//  ADLHotelCommentController.m
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelCommentController.h"
#import "ADLHotelCommentTableViewCell.h"
#import "ADLBookingHotelModel.h"
#import "ADLCommentImageView.h"

@interface ADLHotelCommentController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *temporaryArr;
@end

@implementation ADLHotelCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self addNavigationView:ADLString(@"酒店评论")];
    [self.view addSubview:self.tableView];
    
   [self HotenCommentData:@""];

    WS(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [ws.temporaryArr  removeAllObjects];
        ws.tableView.tableFooterView.hidden = NO;
        [ws HotenCommentData:@""];
      
    } ];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (ws.temporaryArr > 0) {
            ADLBookingHotelModel *model = ws.temporaryArr.lastObject;
            [ws HotenCommentData:model.id];
        }else {
            [ws HotenCommentData:@""];
        }
    }];
    
    
}
//评论列表 -按酒店- 按房型  用户端使用
//按酒店http://129.204.67.226:8087/lockboss-api/app/company/roomSellOrder/comment/list.do
//companyId酒店id
// 按房型http://129.204.67.226:8087/lockboss-api/app/user/roomSellOrder/comment/list.do
//roomSellTypeId房型id
#pragma mark ------ 评论列表-----
- (void)HotenCommentData:(NSString *)strid {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"companyId"] = self.model.companyId;//酒店ID
    params[@"id"] = strid;//酒店ID
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_comment_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                [ws.tableView.mj_header endRefreshing];
                [ws.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
           NSArray *array =  [ADLBookingHotelModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
         
      
            if (array.count > 0) {
                  [ws.temporaryArr addObjectsFromArray:array];
      
                if (array.count < 20) {
                    ws.tableView.mj_footer.hidden = YES;
       
                }
                
            }else {
                ws.tableView.tableFooterView.hidden = YES;;
            
            }
            
        }
        [ws.tableView reloadData];
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
   return  self.temporaryArr.count;
  
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLHotelCommentTableViewCell *cell = [ADLHotelCommentTableViewCell cellWithTableView:tableView];
    cell.model = self.temporaryArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLBookingHotelModel *model = self.temporaryArr[indexPath.row];
    
    CGFloat titleH = [ADLUtils calculateString:model.gradeMessages rectSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT) fontSize:12].height+10;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    
    
    for (int i =1; i < 10; i++) {
        
        NSMutableDictionary *dict = [model mj_keyValues];
        
        NSString *str = [NSString stringWithFormat:@"gradeUrl%d",i];
        NSString *image = dict[str];
        if (image.length > 0) {
            [imageArray addObject:image];
        }
        
        
    }
    if (imageArray.count > 0) {
        CGFloat PhotosVieH = [ADLCommentImageView sizeWithCount:imageArray.count].height;
        return 88+PhotosVieH+titleH;
    }

    return 78+titleH;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



-(NSMutableArray *)temporaryArr {
    if (!_temporaryArr) {
        _temporaryArr = [NSMutableArray array];
    }
    return  _temporaryArr;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_H,SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =COLOR_F7F7F7;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //_tableView.contentInset = UIEdgeInsetsMake(438/2, 0, 0, 0);
        
    }
    return _tableView;
}
@end
