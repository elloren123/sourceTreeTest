//
//  ADLLockerDetailController.m
//  lockboss
//
//  Created by adel on 2019/6/18.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLockerDetailController.h"
#import "ADLLockerEvaluateCell.h"
#import "ADLLockerDetailCell.h"
#import "ADLImagePreView.h"

@interface ADLLockerDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *synopsisArr;
@property (nonatomic, strong) NSMutableArray *synopsisHArr;
@property (nonatomic, strong) NSMutableArray *evaluateHArr;
@property (nonatomic, assign) NSInteger evaluateCount;
@property (nonatomic, strong) NSString *imageUrl;
@end

@implementation ADLLockerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"锁匠详情"];
    
    self.synopsisArr = [[NSMutableArray alloc] init];
    self.synopsisHArr = [[NSMutableArray alloc] init];
    self.evaluateHArr = [[NSMutableArray alloc] init];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getEvaluateData];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (self.hideSelBtn) {
        tableView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H);
        tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    } else {
        tableView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-VIEW_HEIGHT);
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        selectBtn.frame = CGRectMake(0, SCREEN_HEIGHT-BOTTOM_H-VIEW_HEIGHT, SCREEN_WIDTH, VIEW_HEIGHT);
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [selectBtn setTitle:@"选择锁匠" forState:UIControlStateNormal];
        selectBtn.backgroundColor = APP_COLOR;
        [selectBtn addTarget:self action:@selector(clickSelectLockerBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectBtn];
    }
    [self getLockerDetail];
    [self getEvaluateData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.synopsisArr.count;
    } else {
        return self.dataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        if (self.evaluateCount == 0) {
            return 0;
        } else {
            return VIEW_HEIGHT;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(12, (VIEW_HEIGHT-16)/2, 3, 16)];
        redView.backgroundColor = APP_COLOR;
        [headView addSubview:redView];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(21, 0, 290, VIEW_HEIGHT)];
        titLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        titLab.textColor = COLOR_333333;
        titLab.text = [NSString stringWithFormat:@"服务评价(%lu)",self.evaluateCount];
        [headView addSubview:titLab];
        
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-0.5, SCREEN_WIDTH, 0.5)];
        spView.backgroundColor = SEPARATOR_COLOR;
        [headView addSubview:spView];
        
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.synopsisHArr[indexPath.row] floatValue];
    } else {
        return [self.evaluateHArr[indexPath.row] floatValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ADLLockerDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"LockerDetailCell"];
        if (detailCell == nil) {
            detailCell = [[NSBundle mainBundle] loadNibNamed:@"ADLLockerDetailCell" owner:nil options:nil].lastObject;
            detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dict = self.synopsisArr[indexPath.row];
        detailCell.titLab.text = dict[@"name"];
        detailCell.detailLab.attributedText = dict[@"detail"];
        return detailCell;
    } else {
        ADLLockerEvaluateCell *evaluateCell = [tableView dequeueReusableCellWithIdentifier:@"LockerEvaluateCell"];
        if (evaluateCell == nil) {
            evaluateCell = [[NSBundle mainBundle] loadNibNamed:@"ADLLockerEvaluateCell" owner:nil options:nil].lastObject;
            evaluateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dict = self.dataArr[indexPath.row];
        [evaluateCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
        evaluateCell.headShot = dict[@"headShot"];
        evaluateCell.nameLab.text = dict[@"addUser"];
        evaluateCell.dateLab.text = dict[@"createTime"];
        evaluateCell.contentLab.text = dict[@"desc"];
        [evaluateCell updateImageViewImage:dict[@"imageArr"] width:SCREEN_WIDTH-128];
        return evaluateCell;
    }
}


#pragma mark ------ 选择锁匠 ------
- (void)clickSelectLockerBtn {
    [self.navigationController popViewControllerAnimated:NO];
    if (self.selectLocker) {
        self.selectLocker();
    }
}

#pragma mark ------ 获取锁匠详情 ------
- (void)getLockerDetail {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.lockerId forKey:@"artisanId"];
    [ADLNetWorkManager postWithPath:k_query_locker_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if ([responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSString *introduceStr = responseDict[@"data"][@"locksmithIntroduce"];
                if (introduceStr.length > 0) {
                    [self dealwithString:introduceStr name:@"锁匠介绍"];
                }
                
                NSString *serviceStr = responseDict[@"data"][@"serviceProvided"];
                if (serviceStr.length > 0) {
                    [self dealwithString:serviceStr name:@"提供的服务"];
                }
                
                NSString *explainStr = responseDict[@"data"][@"serviceInstructions"];
                if (explainStr.length > 0) {
                    [self dealwithString:explainStr name:@"服务说明"];
                }
                
                NSString *videoUrl = responseDict[@"data"][@"videoUrl"];
                if ([videoUrl hasPrefix:@"http"]) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.userInteractionEnabled = YES;
                    imageView.clipsToBounds = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLockerImageView:)];
                    [imageView addGestureRecognizer:tap];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:videoUrl] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
                    self.tableView.tableHeaderView = imageView;
                    self.imageUrl = videoUrl;
                }
                [self.tableView reloadData];
            }
        }
    } failure:nil];
}

#pragma mark ------ 处理字符串 ------
- (void)dealwithString:(NSString *)string name:(NSString *)name {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:name forKey:@"name"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}];
    [dict setValue:attributeStr forKey:@"detail"];
    CGFloat hei = [ADLUtils calculateAttributeString:attributeStr rectSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT)].height;
    [self.synopsisArr addObject:dict];
    if (hei < 30) {
        [self.synopsisHArr addObject:@(hei+60)];
    } else {
        [self.synopsisHArr addObject:@(hei+66)];
    }
}

#pragma mark ------ 锁匠详情图片 ------
- (void)clickLockerImageView:(UITapGestureRecognizer *)tap {
    UIImageView *imgView = (UIImageView *)tap.view;
    [ADLImagePreView showWithImageViews:@[imgView] urlArray:@[self.imageUrl] currentIndex:0];
}

#pragma mark ------ 获取评论数据 ------
- (void)getEvaluateData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.lockerId forKey:@"artisanId"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(10) forKey:@"pageSize"];
    [ADLNetWorkManager postWithPath:k_query_locker_evaluate parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.evaluateCount = [responseDict[@"data"][@"total"] integerValue];
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr.count > 0) {
                for (NSMutableDictionary *dict in resArr) {
                    [dict setValue:[dict[@"addDatetime"] componentsSeparatedByString:@" "].firstObject forKey:@"createTime"];
                    CGFloat contentH = [ADLUtils calculateString:dict[@"desc"] rectSize:CGSizeMake(SCREEN_WIDTH-76, MAXFLOAT) fontSize:13].height;
                    NSArray *imageArr = [[dict[@"evaluateImgUrls"] firstObject] componentsSeparatedByString:@","];
                    CGFloat imgH = [self calculateCellHeightWithImageCount:imageArr.count];
                    [dict setValue:imageArr forKey:@"imageArr"];
                    [self.dataArr addObject:dict];
                    [self.evaluateHArr addObject:@(contentH+imgH)];
                }
            }
            if (resArr.count < 10) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            self.offset = self.dataArr.count;
            [self.tableView reloadData];
        }
    } failure:nil];
}

#pragma mark ------ 计算cell高度 ------
- (CGFloat)calculateCellHeightWithImageCount:(NSInteger)count {
    switch (count) {
        case 0:
            return 54;
            break;
        case 1:
            return 194;
            break;
        case 2:
            return (SCREEN_WIDTH-132)/2+62;
            break;
        case 3:
            return (SCREEN_WIDTH-136)/3+62;
            break;
        case 5:
        case 6:
            return (SCREEN_WIDTH-136)/3*2+66;
            break;
        default:
            return SCREEN_WIDTH-66;
            break;
    }
}

@end
