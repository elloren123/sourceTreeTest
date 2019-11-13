//
//  ADLGoodsEvaluateView.m
//  lockboss
//
//  Created by adel on 2019/7/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsEvaluateView.h"
#import "ADLGoodsEvaluateCell.h"
#import "ADLLocalizedHelper.h"
#import "ADLNetWorkManager.h"
#import "ADLRefreshFooter.h"
#import "ADLGlobalDefine.h"
#import "ADLImagePreView.h"
#import "ADLBlankView.h"
#import "ADLUserModel.h"
#import "ADLApiDefine.h"
#import "ADLUtils.h"
#import "ADLToast.h"
#import <UIImageView+WebCache.h>

@interface ADLGoodsEvaluateView ()<UITableViewDelegate,UITableViewDataSource,ADLGoodsEvaluateCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *rowHArr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *goodBtn;
@property (nonatomic, strong) UIButton *sosoBtn;
@property (nonatomic, strong) UIButton *badBtn;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSString *goodsId;
@end

@implementation ADLGoodsEvaluateView

- (instancetype)initWithFrame:(CGRect)frame goodsId:(NSString *)goodsId {
    if (self = [super initWithFrame:frame]) {
        self.goodsId = goodsId;
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    self.type = 0;
    self.offset = 0;
    self.pageSize = 15;
    self.dataArr = [[NSMutableArray alloc] init];
    self.rowHArr = [[NSMutableArray alloc] init];
    self.btnArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        UIButton *classifyBtn = [[UIButton alloc] init];
        classifyBtn.backgroundColor = COLOR_F7E4E4;
        classifyBtn.layer.borderColor = APP_COLOR.CGColor;
        classifyBtn.layer.cornerRadius = 16;
        classifyBtn.tag = i;
        classifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [classifyBtn addTarget:self action:@selector(clickClassifyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:classifyBtn];
        [self.btnArr addObject:classifyBtn];
        switch (i) {
            case 0:
                self.allBtn = classifyBtn;
                classifyBtn.layer.borderWidth = 0.5;
                classifyBtn.userInteractionEnabled = NO;
                [classifyBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
                break;
            case 1:
                self.goodBtn = classifyBtn;
                [classifyBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
                break;
            case 2:
                self.sosoBtn = classifyBtn;
                [classifyBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
                break;
            case 3:
                self.badBtn = classifyBtn;
                [classifyBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
                break;
            case 4:
                self.imgBtn = classifyBtn;
                [classifyBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
                break;
        }
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.estimatedRowHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getGoodsEvaluateData];
    }];
    tableView.mj_footer.hidden = YES;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [self getEvaluateCount];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.rowHArr[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLGoodsEvaluateCell *evaCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsEvaluateCell"];
    if (evaCell == nil) {
        evaCell = [[NSBundle mainBundle] loadNibNamed:@"ADLGoodsEvaluateCell" owner:nil options:nil].lastObject;
        evaCell.selectionStyle = UITableViewCellSelectionStyleNone;
        evaCell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [evaCell.iconView sd_setImageWithURL:[NSURL URLWithString:[dict[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    evaCell.nickLab.text = dict[@"addUser"];
    evaCell.dateLab.text = dict[@"addDatetime"];
    evaCell.starView.image = [ADLUtils getStarImageWithCount:[dict[@"description"] integerValue]];
    evaCell.descLab.text = dict[@"evaluateInfo"];
    [evaCell updateImageViewImage:dict[@"imgArr"] width:SCREEN_WIDTH-24];
    [evaCell.evaluateBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"replyNum"]] forState:UIControlStateNormal];
    [evaCell.likeBtn setTitle:[NSString stringWithFormat:@"  %@",dict[@"praiseNum"]] forState:UIControlStateNormal];
    if ([dict[@"isPraise"] boolValue]) {
        evaCell.likeBtn.selected = YES;
    } else {
        evaCell.likeBtn.selected = NO;
    }
    evaCell.modelLab.text = dict[@"skuName"];
    return evaCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEvaluateViewCell:index:)]) {
        [self.delegate didClickEvaluateViewCell:self.dataArr[indexPath.row] index:indexPath.row];
    }
}

#pragma mark ------ 评价点赞 ------
- (void)didClickLikeBtn:(UIButton *)sender {
    if ([ADLUserModel sharedModel].login) {
        ADLGoodsEvaluateCell *cell = (ADLGoodsEvaluateCell *)sender.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSMutableDictionary *dict = self.dataArr[indexPath.row];
        if ([dict[@"isPraise"] boolValue]) {
            [ADLToast showMessage:@"已经点赞过了"];
        } else {
            if ([dict[@"buyerUserId"] isEqualToString:[ADLUserModel sharedModel].userId]) {
                [ADLToast showMessage:@"不能点赞自己"];
            } else {
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setValue:[ADLUserModel sharedModel].userId forKey:@"fromUserId"];
                [params setValue:dict[@"buyerUserId"] forKey:@"toUserId"];
                [params setValue:dict[@"id"] forKey:@"evaluateId"];
                [params setValue:@(2) forKey:@"type"];
                [ADLNetWorkManager postWithPath:k_goods_evaluate_reply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                    if ([responseDict[@"code"] integerValue] == 10000) {
                        [dict setValue:@(1) forKey:@"isPraise"];
                        [dict setValue:@([dict[@"praiseNum"] integerValue]+1) forKey:@"praiseNum"];
                        [self.tableView reloadData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEvaluateViewLikeBtn:)]) {
                            [self.delegate didClickEvaluateViewLikeBtn:dict];
                        }
                    }
                } failure:nil];
            }
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(evaluatePushLoginController)]) {
            [self.delegate evaluatePushLoginController];
        }
    }
}

#pragma mark ------ 更新数据 ------
- (void)updateEvaluateData:(NSMutableDictionary *)dict index:(NSInteger)index {
    [self.dataArr replaceObjectAtIndex:index withObject:dict];
    [self.tableView reloadData];
}

#pragma mark ------ 点击评价用户头像 ------
- (void)didClickUserIcon:(UIImageView *)imageView {
    ADLGoodsEvaluateCell *cell = (ADLGoodsEvaluateCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"headShot"] stringValue].length > 0) {
        [ADLImagePreView showWithImageViews:@[imageView] urlArray:@[dict[@"headShot"]] currentIndex:0];
    }
}

#pragma mark ------ 点击评价图片 ------
- (void)didClickImageView:(UIImageView *)imageView {
    ADLGoodsEvaluateCell *cell = (ADLGoodsEvaluateCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    [ADLImagePreView showWithImageViews:cell.imageViewArr urlArray:dict[@"imgArr"] currentIndex:imageView.tag];
}

#pragma mark ------ 点击分类按钮 ------
- (void)clickClassifyBtn:(UIButton *)sender {
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.borderWidth = 0;
        obj.userInteractionEnabled = YES;
        [obj setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    }];
    if (sender.tag == 1) {
        self.type = 3;
    } else if (sender.tag == 3) {
        self.type = 1;
    } else {
        self.type = sender.tag;
    }
    sender.layer.borderWidth = 0.5;
    sender.userInteractionEnabled = NO;
    [sender setTitleColor:APP_COLOR forState:UIControlStateNormal];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    self.offset = 0;
    [self getGoodsEvaluateData];
}

#pragma mark ------ 更新数据 ------
- (void)updateEvaluateData {
    self.offset = 0;
    [self getGoodsEvaluateData];
}

#pragma mark ------ 获取评价数量 ------
- (void)getEvaluateCount {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.goodsId forKey:@"goodsId"];
    [ADLNetWorkManager postWithPath:k_goods_evaluate_count parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            NSString *allStr = [NSString stringWithFormat:@"全部 %@",dict[@"allNum"]];
            NSString *goodStr = [NSString stringWithFormat:@"好评 %@",dict[@"goodsNum"]];
            NSString *sosoStr = [NSString stringWithFormat:@"中评 %@",dict[@"commentNum"]];
            NSString *badStr = [NSString stringWithFormat:@"差评 %@",dict[@"badNum"]];
            NSString *imgStr = [NSString stringWithFormat:@"有图 %@",dict[@"imgNum"]];
            [self.allBtn setTitle:allStr forState:UIControlStateNormal];
            [self.goodBtn setTitle:goodStr forState:UIControlStateNormal];
            [self.sosoBtn setTitle:sosoStr forState:UIControlStateNormal];
            [self.badBtn setTitle:badStr forState:UIControlStateNormal];
            [self.imgBtn setTitle:imgStr forState:UIControlStateNormal];
            
            CGFloat allW = [ADLUtils calculateString:allStr rectSize:CGSizeMake(SCREEN_WIDTH-12, 32) fontSize:13].width+30;
            CGFloat goodW = [ADLUtils calculateString:goodStr rectSize:CGSizeMake(SCREEN_WIDTH-12, 32) fontSize:13].width+30;
            CGFloat sosoW = [ADLUtils calculateString:sosoStr rectSize:CGSizeMake(SCREEN_WIDTH-12, 32) fontSize:13].width+30;
            CGFloat badW = [ADLUtils calculateString:badStr rectSize:CGSizeMake(SCREEN_WIDTH-12, 32) fontSize:13].width+30;
            CGFloat imgW = [ADLUtils calculateString:imgStr rectSize:CGSizeMake(SCREEN_WIDTH-12, 32) fontSize:13].width+30;
            
            self.allBtn.frame = CGRectMake(12, 10, allW, 32);
            self.goodBtn.frame = CGRectMake(24+allW, 10, goodW, 32);
            self.sosoBtn.frame = CGRectMake(36+allW+goodW, 10, sosoW, 32);
            if (self.sosoBtn.frame.origin.x+sosoW+badW+22 > SCREEN_HEIGHT) {
                self.badBtn.frame = CGRectMake(12, 52, badW, 32);
            } else {
                self.badBtn.frame = CGRectMake(48+allW+goodW+sosoW, 10, badW, 32);
            }
            
            if (self.badBtn.frame.origin.x+badW+22+imgW > SCREEN_WIDTH) {
                self.imgBtn.frame = CGRectMake(12, self.badBtn.frame.origin.y+42, imgW, 32);
            } else {
                self.imgBtn.frame = CGRectMake(self.badBtn.frame.origin.x+badW+12, self.badBtn.frame.origin.y, imgW, 32);
            }
            
            UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, self.imgBtn.frame.origin.y+41.5, SCREEN_WIDTH, 0.5)];
            spView.backgroundColor = SEPARATOR_COLOR;
            [self addSubview:spView];
            CGRect frame = self.tableView.frame;
            frame.origin.y = self.imgBtn.frame.origin.y+42;
            frame.size.height = frame.size.height-self.imgBtn.frame.origin.y-42;
            self.tableView.frame = frame;
        }
    } failure:nil];
}

#pragma mark ------ 商品评价列表 ------
- (void)getGoodsEvaluateData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.goodsId forKey:@"goodsId"];
    [params setValue:@(self.type) forKey:@"queryType"];
    if ([ADLUserModel sharedModel].login) {
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    }
    [ADLNetWorkManager postWithPath:k_goods_evaluate_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if (self.offset == 0) {
            [self.dataArr removeAllObjects];
            [self.rowHArr removeAllObjects];
        }
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            NSArray *evaArr = responseDict[@"data"][@"rows"];
            if (evaArr.count > 0) {
                for (NSMutableDictionary *dict in evaArr) {
                    CGFloat evaH = [ADLUtils calculateString:dict[@"evaluateInfo"] rectSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT) fontSize:14].height+100;
                    NSArray *imgArr = [dict[@"imgUrl"] componentsSeparatedByString:@","];
                    evaH = evaH + [self calculateEvaluateCellHeight:imgArr.count];
                    [dict setValue:imgArr forKey:@"imgArr"];
                    [self.dataArr addObject:dict];
                    [self.rowHArr addObject:@(evaH)];
                }
            }
            
            if (evaArr.count < self.pageSize) {
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
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ 计算评论cell高度 ------
- (CGFloat)calculateEvaluateCellHeight:(NSInteger)count {
    switch (count) {
        case 0:
            return 0;
            break;
        case 1:
        case 2:
            return 150;
            break;
        case 3:
            return 116;
            break;
        case 4:
            return 244;
            break;
        case 5:
        case 6:
            return 216;
            break;
        default:
            return 316;
            break;
    }
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无评价" backgroundColor:nil];
    }
    return _blankView;
}

@end
