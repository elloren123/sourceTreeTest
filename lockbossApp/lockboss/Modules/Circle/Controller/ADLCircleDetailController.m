//
//  ADLCircleDetailController.m
//  lockboss
//
//  Created by Han on 2019/6/1.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCircleDetailController.h"
#import "ADLWriteTopicController.h"
#import "ADLTopicDetailController.h"
#import "ADLTopicReportController.h"

#import "ADLCircleDetailHeadView.h"
#import "ADLTopicListCell.h"
#import "ADLImagePreView.h"
#import "ADLBottomView.h"
#import "ADLShareView.h"
#import "ADLBlankView.h"

@interface ADLCircleDetailController ()<UITableViewDelegate,UITableViewDataSource,ADLCircleDetailDelegate,ADLTopicListCellDelegate>
@property (nonatomic, strong) ADLCircleDetailHeadView *headerView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *circleDict;
@property (nonatomic, strong) NSMutableArray *rowHArr;
@end

@implementation ADLCircleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"群组详情"];
    [self addRightButtonWithImageName:@"nav_add" action:@selector(clickAddBtn)];
    
    self.rowHArr = [[NSMutableArray alloc] init];
    ADLCircleDetailHeadView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ADLCircleDetailHeadView" owner:nil options:nil].lastObject;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 108);
    headerView.delegate = self;
    self.headerView = headerView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [UIView new];
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf getTopicDataWithPageSize:10];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getTopicDataWithPageSize:weakSelf.pageSize];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getCircleData];
    [self getTopicDataWithPageSize:10];
}

#pragma mark ------ UITableView ------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.rowHArr[indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicListCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLTopicListCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    cell.nickLab.text = dict[@"userName"];
    cell.timeLab.text = dict[@"timeStr"];
    cell.contentLab.text = dict[@"content"];
    [cell updateImageViewImage:dict[@"imageArr"] content:[dict[@"content"] stringValue].length>0 width:SCREEN_WIDTH-128];
    [cell.praiseBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"fabulousNums"]] forState:UIControlStateNormal];
    [cell.evaluateBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"commentNums"]] forState:UIControlStateNormal];
    if ([dict[@"fabulousFlag"] integerValue] == 2) {
        cell.praiseBtn.selected = YES;
    } else {
        cell.praiseBtn.selected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    ADLTopicDetailController *detailVC = [[ADLTopicDetailController alloc] init];
    detailVC.topicId = dict[@"id"];
    detailVC.circleId = self.circleId;
    detailVC.publisherId = dict[@"userId"];
    detailVC.praise = [dict[@"fabulousFlag"] integerValue] == 2 ? YES : NO;
    detailVC.finish = ^(NSDictionary *dict) {
        if (dict == nil) {
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.rowHArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.offset = self.dataArr.count;
            if (self.dataArr.count == 0) {
                [self getTopicDataWithPageSize:10];
            }
        } else {
            NSMutableDictionary *muDict = self.dataArr[indexPath.row];
            [muDict setValue:dict[@"fabulousNums"] forKey:@"fabulousNums"];
            [muDict setValue:dict[@"commentNums"] forKey:@"commentNums"];
            [muDict setValue:dict[@"fabulousFlag"] forKey:@"fabulousFlag"];
            [self.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 退出/解散群组 ------
- (void)clickAddBtn {
    NSString *titStr = @"退出群组";
    NSString *toastStr = @"退出成功";
    NSString *msgStr = @"确定退出群组？";
    NSString *path = k_delete_circle;
    if ([self.circleDict[@"createUserId"] isEqualToString:[ADLUserModel sharedModel].userId]) {
        path = k_disband_circle;
        titStr = @"解散群组";
        toastStr = @"解散成功";
        msgStr = @"确定解散群组？";
    }
    
    [ADLBottomView showWithTitles:@[titStr] finish:^(NSInteger index) {
        if (index == 0) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:self.circleId forKey:@"groupId"];
            [ADLAlertView showWithTitle:nil message:msgStr confirmTitle:nil confirmAction:^{
                [ADLToast showLoadingMessage:ADLString(@"loading")];
                [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                    if ([responseDict[@"code"] integerValue] == 10000) {
                        [ADLToast showMessage:toastStr];
                        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_CIRCLE_DATA object:nil userInfo:nil];
                        if ([toastStr isEqualToString:@"退出成功"]) {
                            [self getCircleData];
                        } else {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        }
                    }
                } failure:nil];
            } cancleTitle:nil cancleAction:nil showCancle:YES];
        }
    }];
}

#pragma mark ------ 点击用户头像 ------
- (void)didClickUserIcon:(UIImageView *)imageView {
    ADLTopicListCell *cell = (ADLTopicListCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"headShot"] stringValue].length > 0) {
        [ADLImagePreView showWithImageViews:@[imageView] urlArray:@[dict[@"headShot"]] currentIndex:0];
    }
}

#pragma mark ------ 点击话题图片 ------
- (void)didClickImageView:(UIImageView *)imageView {
    ADLTopicListCell *cell = (ADLTopicListCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    [ADLImagePreView showWithImageViews:cell.imageViewArr urlArray:dict[@"imageArr"] currentIndex:imageView.tag];
}

#pragma mark ------ 话题点赞 ------
- (void)didClickPraiseBtn:(UIButton *)sender {
    ADLTopicListCell *cell = (ADLTopicListCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:dict[@"id"] forKey:@"topicId"];
    
    sender.enabled = NO;
    if (sender.selected) {
        [ADLNetWorkManager postWithPath:k_topic_cancle_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSInteger praiseCount = [dict[@"fabulousNums"] integerValue]-1;
                [dict setValue:@(praiseCount) forKey:@"fabulousNums"];
                [dict setValue:@(1) forKey:@"fabulousFlag"];
                cell.praiseBtn.selected = NO;
                [cell.praiseBtn setTitle:[NSString stringWithFormat:@"  %ld",praiseCount] forState:UIControlStateNormal];
            }
            sender.enabled = YES;
        } failure:^(NSError *error) {
            sender.enabled = YES;
        }];
    } else {
        [params setValue:@(2) forKey:@"type"];
        [ADLNetWorkManager postWithPath:k_topic_comment_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSInteger praiseCount = [dict[@"fabulousNums"] integerValue]+1;
                [dict setValue:@(praiseCount) forKey:@"fabulousNums"];
                [dict setValue:@(2) forKey:@"fabulousFlag"];
                cell.praiseBtn.selected = YES;
                [cell.praiseBtn setTitle:[NSString stringWithFormat:@"  %ld",praiseCount] forState:UIControlStateNormal];
            }
            sender.enabled = YES;
        } failure:^(NSError *error) {
            sender.enabled = YES;
        }];
    }
}

#pragma mark ------ 点击圈子图片 ------
- (void)didClickGroupImageView:(UIImageView *)imageView {
    if ([self.circleDict[@"img"] stringValue].length > 0) {
        [ADLImagePreView showWithImageViews:@[imageView] urlArray:@[self.circleDict[@"img"]] currentIndex:0];
    }
}

#pragma mark ------ 点击Action按钮 ------
- (void)didClickActionBtn:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"发表话题"]) {
        ADLWriteTopicController *writeVC = [[ADLWriteTopicController alloc] init];
        writeVC.circleId = self.circleId;
        writeVC.publishAction = ^{
            self.offset = 0;
            [self getTopicDataWithPageSize:10];
        };
        [self.navigationController pushViewController:writeVC animated:YES];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.circleId forKey:@"groupId"];
        [params setValue:@"" forKey:@"content"];
        [ADLNetWorkManager postWithPath:k_circle_apply_join parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"申请成功，请耐心等待审核！"];
            }
        } failure:nil];
    }
}

#pragma mark ------ 获取圈子数据 ------
- (void)getCircleData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.circleId forKey:@"groupId"];
    [ADLNetWorkManager postWithPath:k_circle_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.circleDict = responseDict[@"data"];
            [self.headerView.imgView sd_setImageWithURL:[NSURL URLWithString:self.circleDict[@"img"]] placeholderImage:[UIImage imageNamed:@"group_head"]];
            self.headerView.nameLab.text = [NSString stringWithFormat:@"群组名称：%@",self.circleDict[@"name"]];
            self.headerView.numLab.text = [NSString stringWithFormat:@"群组人数：%@",self.circleDict[@"userNums"]];
            if (self.circleDict[@"createUserName"]) {
                self.headerView.authorLab.text = [NSString stringWithFormat:@"创建人：%@",self.circleDict[@"createUserName"]];
            } else {
                self.headerView.authorLab.text = @" ";
            }
            self.headerView.actionBtn.hidden = NO;
            if (![self.circleDict[@"memberStatus"] boolValue]) {
                [self.headerView.actionBtn setTitle:@"申请加入" forState:UIControlStateNormal];
            }
        }
    } failure:nil];
}

#pragma mark ------ 获取话题数据 ------
- (void)getTopicDataWithPageSize:(NSInteger)pageSize {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(pageSize) forKey:@"pageSize"];
    [params setValue:self.circleId forKey:@"groupId"];
    
    [ADLNetWorkManager postWithPath:k_topic_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
                [self.rowHArr removeAllObjects];
            }
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr.count > 0) {
                for (NSMutableDictionary *dict in resArr) {
                    NSString *content = dict[@"content"];
                    CGFloat contentH = [ADLUtils calculateString:content rectSize:CGSizeMake(SCREEN_WIDTH-76, MAXFLOAT) fontSize:14].height;
                    NSArray *imageArr = [dict[@"imgs"] componentsSeparatedByString:@","];
                    CGFloat imageH = 0;
                    if (imageArr.count > 0) {
                        [dict setValue:imageArr forKey:@"imageArr"];
                    }
                    imageH = [self calculateCellHeightWithImageCount:imageArr.count content:content.length > 0];
                    NSInteger second = [ADLUtils getSecondFromStartTimestamp:[dict[@"createTime"] doubleValue] endTimestamp:0];
                    NSString *timeStr = [self dealwithTime:second timestamp:[dict[@"createTime"] doubleValue]];
                    if ([dict[@"userName"] stringValue].length == 0) {
                        [dict setValue:@" " forKey:@"userName"];
                    }
                    [dict setValue:timeStr forKey:@"timeStr"];
                    [self.dataArr addObject:dict];
                    [self.rowHArr addObject:@(contentH+imageH)];
                }
            }
            if (resArr.count < pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            self.offset = self.dataArr.count;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ 计算cell高度 ------
- (CGFloat)calculateCellHeightWithImageCount:(NSInteger)count content:(BOOL)content {
    CGFloat imgTop = 0;
    if (!content) {
        imgTop = -12;
    }
    switch (count) {
        case 0:
            return 79;
            break;
        case 1:
            return 222+imgTop;
            break;
        case 2:
            return (SCREEN_WIDTH-132)/2+92+imgTop;
            break;
        case 3:
            return (SCREEN_WIDTH-136)/3+92+imgTop;
            break;
        case 5:
        case 6:
            return (SCREEN_WIDTH-136)/3*2+96+imgTop;
            break;
        default:
            return SCREEN_WIDTH-36+imgTop;
            break;
    }
}

#pragma mark ------ 处理时间 ------
- (NSString *)dealwithTime:(NSInteger)second timestamp:(double)timestamp {
    if (second < 60) {
        return @"刚刚";
    } else if (second < 3600) {
        return [NSString stringWithFormat:@"%ld分钟前",second/60];
    } else if (second < 86400) {
        return [NSString stringWithFormat:@"%ld小时前",second/3600];
    } else {
        NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [formatter stringFromDate:fromDate];
    }
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) imageName:nil prompt:@"暂时还没有话题哦！" backgroundColor:nil];
    }
    return _blankView;
}

@end
