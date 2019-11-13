//
//  ADLSearchHoterController.m
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSearchHoterController.h"
#import "ADLSearchView.h"
#import "ADLAutoresizeLabelFlow.h"
#import "ADLHotelListController.h"
@interface ADLSearchHoterController ()<ADLSearchViewDelegate>
@property (nonatomic ,strong)ADLAutoresizeLabelFlow *recordView;
@property (nonatomic, weak) ADLSearchView *searchView;
@property (nonatomic ,strong)NSMutableArray *hotarray;
//@property (nonatomic ,strong)NSArray *historyarray;


@end

@implementation ADLSearchHoterController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADLSearchView *searchView = [[ADLSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H) placeholder:@"请输入您要的商品名称" instant:YES];
    searchView.textField.placeholder = @"搜索酒店名称";
    searchView.done = NO;
    searchView.delegate = self;
    searchView.divisionView.hidden = YES;
    [self.view addSubview:searchView];
    self.searchView = searchView;
      self.hotarray = @[@[],@[]].mutableCopy;
    // 热门搜索数据
//    NSArray *hotArray = @[@"维也纳酒店",@"东井岗酒店",@"酒店",@"泡泡",@"威斯丁酒店",@"香格里拉大酒店",@"OYO",@"七天连锁酒店",@"喜来登大酒店喜来登大酒店"];
//   [self.hotarray replaceObjectAtIndex:1 withObject:hotArray];
//
//    [self.hotarray replaceObjectAtIndex:0 withObject:hotArray];
    // collectionview
//    WS(ws);
//    self.recordView = [[ADLAutoresizeLabelFlow alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.searchView.frame)-NAV_H) titles:self.hotarray sectionTitles:@[@"热门搜索",@"搜索记录"] selectedHandler:^(NSIndexPath *indexPath, NSString *title) {
//       ADLLog(@"搜索%@",title);
//           [ws.searchView.textField resignFirstResponder];
//        if (ws.PopView == NO) {
//        ADLHotelListController*vc = [[ADLHotelListController alloc]init];
//            vc.cityDict = ws.cityDict;
//            vc.searchType = @"1";
//            vc.navTitle = title;
//        [ws.navigationController pushViewController:vc animated:YES];
//        }else {
//            if (ws.searchContentBlock) {
//                ws.searchContentBlock(title);
//
//            }
//            [ws customPopViewController];
//        }
//
//
//    }];
    
    self.recordView.deleteHandler = ^(NSIndexPath *indexPath) {
     ADLLog(@"删除搜索记录");
    };
    
    [self.view addSubview:self.recordView];
}

#pragma mark ------ ADLSearchViewDelegate ------
- (void)didClickCancleButton {
       [self customPopViewController];
}
#pragma mark ------ 搜索 ------
- (void)didClickSearchButton:(UITextField *)textField {
    if (textField.text.length == 0) {
        [ADLToast showMessage:@"请输入酒店名称"];
    } else {
      [textField resignFirstResponder];
        ADLHotelListController*vc = [[ADLHotelListController alloc]init];
        vc.cityDict = self.cityDict;
        vc.searchType = @"1";
        vc.navTitle = textField.text;
        [self.navigationController pushViewController:vc animated:YES];
    
 
    }
}
@end
