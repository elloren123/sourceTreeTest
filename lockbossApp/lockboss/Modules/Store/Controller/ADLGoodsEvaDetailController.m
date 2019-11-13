//
//  ADLGoodsEvaDetailController.m
//  lockboss
//
//  Created by adel on 2019/6/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsEvaDetailController.h"
#import "ADLGoodsEvaDetailView.h"
#import "ADLGoodsEvaReplyView.h"
#import "ADLTopicCommentCell.h"
#import "ADLGoodsReplyHead.h"
#import "ADLGoodsReplyFoot.h"
#import "ADLGoodsEvaModel.h"
#import "ADLBlankView.h"

@interface ADLGoodsEvaDetailController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,ADLTopicCommentCellDelegate,ADLGoodsReplyHeadDelegate,ADLGoodsReplyFootDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) ADLGoodsEvaReplyView *replyView;
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation ADLGoodsEvaDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"评价详情"];
    self.params = [[NSMutableDictionary alloc] init];
    
    __weak typeof(self)weakSelf = self;
    ADLGoodsEvaDetailView *detailView = [[NSBundle mainBundle] loadNibNamed:@"ADLGoodsEvaDetailView" owner:nil options:nil].lastObject;
    detailView.imgUrl = self.evaluateDict[@"headShot"];
    [detailView.imgView sd_setImageWithURL:[NSURL URLWithString:[self.evaluateDict[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    detailView.nickLab.text = self.evaluateDict[@"addUser"];
    detailView.dateLab.text = self.evaluateDict[@"addDatetime"];
    detailView.starImgView.image = [ADLUtils getStarImageWithCount:[self.evaluateDict[@"description"] integerValue]];
    detailView.contentLab.text = self.evaluateDict[@"evaluateInfo"];
    [detailView updateImageViewImage:self.evaluateDict[@"imgArr"] width:SCREEN_WIDTH-24];
    detailView.skuNameLab.text = self.evaluateDict[@"skuName"];
    CGFloat evaH = [ADLUtils calculateString:self.evaluateDict[@"evaluateInfo"] rectSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT) fontSize:14].height+150;
    NSArray *imgArr = self.evaluateDict[@"imgArr"];
    evaH = evaH + [self calculateEvaluateCellHeight:imgArr.count];
    detailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, evaH);
    detailView.clickImageView = ^{
        [weakSelf.replyView.textField resignFirstResponder];
    };
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-55) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = 30;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = detailView;
    tableView.tableFooterView = [UIView new];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getEvaluateReply];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    ADLGoodsEvaReplyView *replyView = [[NSBundle mainBundle] loadNibNamed:@"ADLGoodsEvaReplyView" owner:nil options:nil].lastObject;
    replyView.frame = CGRectMake(0, SCREEN_HEIGHT-BOTTOM_H-55, SCREEN_WIDTH, 55);
    [replyView.replyBtn setTitle:[NSString stringWithFormat:@"  %@",self.evaluateDict[@"replyNum"]] forState:UIControlStateNormal];
    [replyView.praiseBtn setTitle:[NSString stringWithFormat:@"  %@",self.evaluateDict[@"praiseNum"]] forState:UIControlStateNormal];
    replyView.praiseBtn.selected = [self.evaluateDict[@"isPraise"] boolValue];
    [self.view addSubview:replyView];
    self.replyView = replyView;
    replyView.clickPraiseBtn = ^{
        if ([ADLUserModel sharedModel].login) {
            if ([weakSelf.evaluateDict[@"isPraise"] boolValue]) {
                [ADLToast showMessage:@"已经点赞过了"];
            } else {
                if ([weakSelf.evaluateDict[@"buyerUserId"] isEqualToString:[ADLUserModel sharedModel].userId]) {
                    [ADLToast showMessage:@"不能点赞自己"];
                } else {
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    [params setValue:[ADLUserModel sharedModel].userId forKey:@"fromUserId"];
                    [params setValue:weakSelf.evaluateDict[@"buyerUserId"] forKey:@"toUserId"];
                    [params setValue:weakSelf.evaluateDict[@"id"] forKey:@"evaluateId"];
                    [params setValue:@(2) forKey:@"type"];
                    [ADLNetWorkManager postWithPath:k_goods_evaluate_reply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                        if ([responseDict[@"code"] integerValue] == 10000) {
                            [weakSelf.evaluateDict setValue:@(1) forKey:@"isPraise"];
                            [weakSelf.evaluateDict setValue:@([weakSelf.evaluateDict[@"praiseNum"] integerValue]+1) forKey:@"praiseNum"];
                            [weakSelf.replyView.praiseBtn setTitle:[NSString stringWithFormat:@"  %@",weakSelf.evaluateDict[@"praiseNum"]] forState:UIControlStateNormal];
                            weakSelf.replyView.praiseBtn.selected = YES;
                        }
                        if ([responseDict[@"msg"] isEqualToString:@"已经点赞过了"] && weakSelf.replyView.praiseBtn.selected == NO) {
                            [weakSelf.replyView.praiseBtn setTitle:[NSString stringWithFormat:@"  %@",weakSelf.evaluateDict[@"praiseNum"]] forState:UIControlStateNormal];
                            weakSelf.replyView.praiseBtn.selected = YES;
                            [weakSelf.evaluateDict setValue:@(1) forKey:@"isPraise"];
                        }
                    } failure:nil];
                }
            }
        } else {
            [weakSelf pushLoginViewControllerHideTabbar:NO success:nil];
        }
    };
    replyView.clickSendBtn = ^(UITextField *textField) {
        if (textField.text.length == 0) {
            [ADLToast showMessage:@"请输入评论内容"];
        } else if ([ADLUtils hasEmoji:textField.text]) {
            [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        } else {
            if (![weakSelf.replyView.textField.placeholder hasPrefix:@"回复"] && [weakSelf.evaluateDict[@"buyerUserId"] isEqualToString:[ADLUserModel sharedModel].userId]) {
                [ADLToast showMessage:@"不能回复自己的评论"];
            } else {
                [weakSelf addReplyData];
            }
        }
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [self getEvaluateReply];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyBoard)];
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ADLGoodsEvaModel *evaModel = self.dataArr[section];
    return evaModel.sReplyArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ADLGoodsEvaModel *evaModel = self.dataArr[section];
    return evaModel.headerH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ADLGoodsReplyHead *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"GoodsReplyHead"];
    if (headView == nil) {
        headView = [[NSBundle mainBundle] loadNibNamed:@"ADLGoodsReplyHead" owner:nil options:nil].lastObject;
        headView.delegate = self;
    }
    ADLGoodsEvaModel *model = self.dataArr[section];
    headView.section = section;
    headView.headShot = model.headImg;
    [headView.imgView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"user_head"]];
    headView.nameLab.text = model.fromUser;
    headView.dateLab.text = model.addDatetime;
    headView.contentLab.text = model.content;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ADLGoodsEvaModel *evaModel = self.dataArr[section];
    if (evaModel.sReplyArr.count > 1) {
        return 36;
    } else {
        return 12;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ADLGoodsReplyFoot *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (footerView == nil) {
        footerView = [[ADLGoodsReplyFoot alloc] initWithReuseIdentifier:@"footer"];
        footerView.delegate = self;
    }
    footerView.section = section;
    ADLGoodsEvaModel *evaModel = self.dataArr[section];
    if (evaModel.sReplyArr.count > 1) {
        if (evaModel.fold) {
            footerView.foldLab.text = @"展开";
            footerView.foldImg.image = [UIImage imageNamed:@"fold_down"];
        } else {
            footerView.foldLab.text = @"收起";
            footerView.foldImg.image = [UIImage imageNamed:@"fold_up"];
        }
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLGoodsEvaModel *evaModel = self.dataArr[indexPath.section];
    return [evaModel.sReplyHArr[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLTopicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLTopicCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    ADLGoodsEvaModel *evaModel = self.dataArr[indexPath.section];
    cell.contentLab.text = evaModel.sReplyArr[indexPath.row][@"commentStr"];
    return cell;
}

#pragma mark ------ UIGestureRecognizerDelegate ------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([self.replyView.textField isFirstResponder]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark ------ 键盘显示 ------
- (void)keyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (keyboardSize.height > 0) {
        self.replyView.transform = CGAffineTransformMakeTranslation(0, -keyboardSize.height);
    }
}

#pragma mark ------ 键盘隐藏 ------
- (void)keyboardWillHideNotification:(NSNotification *)notification {
    self.replyView.transform = CGAffineTransformIdentity;
    self.replyView.textField.placeholder = @"说点什么吧...";
    self.replyView.textField.text = @"";
    [self.params removeAllObjects];
}

#pragma mark ------ 点击回复内容 ------
- (void)didClickContentLab:(UILabel *)label {
    ADLGoodsReplyHead *headerView = (ADLGoodsReplyHead *)label.superview.superview;
    ADLGoodsEvaModel *selectModel = self.dataArr[headerView.section];
    self.replyView.textField.placeholder = [NSString stringWithFormat:@"回复 %@",selectModel.fromUser];
    self.replyView.textField.text = @"";
    [self.replyView.textField becomeFirstResponder];
    [self.params setValue:selectModel.fromUserId forKey:@"toUserId"];
    [self.params setValue:selectModel.replyId forKey:@"replyId"];
}

#pragma mark ------ 点击回复用户头像 ------
- (void)didClickUserIcon {
    [self.replyView.textField resignFirstResponder];
}

#pragma mark ------ 点击回复内容的回复 ------
- (void)didClickReplyLabel:(UILabel *)label {
    ADLTopicCommentCell *cell = (ADLTopicCommentCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLGoodsEvaModel *selectModel = self.dataArr[indexPath.section];
    NSString *fromUser = selectModel.sReplyArr[indexPath.row][@"fromUser"];
    self.replyView.textField.placeholder = [NSString stringWithFormat:@"回复 %@",fromUser];
    self.replyView.textField.text = @"";
    [self.replyView.textField becomeFirstResponder];
    [self.params setValue:selectModel.sReplyArr[indexPath.row][@"fromUserId"] forKey:@"toUserId"];
    [self.params setValue:selectModel.replyId forKey:@"replyId"];
}

#pragma mark ------ 查看更多回复 ------
- (void)didClickFoldLab:(UILabel *)sender {
    [self.replyView.textField resignFirstResponder];
    ADLGoodsReplyFoot *footerView = (ADLGoodsReplyFoot *)sender.superview;
    ADLGoodsEvaModel *model = self.dataArr[footerView.section];
    if (model.fold) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:model.replyId forKey:@"replyId"];
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [ADLNetWorkManager postWithPath:k_query_goods_more_reply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast hide];
                model.fold = NO;
                NSArray *resArr = responseDict[@"data"][@"rows"];
                for (NSMutableDictionary *dict in resArr) {
                    NSString *commentStr;
                    if ([dict[@"fromUserId"] isEqualToString:dict[@"toUserId"]]) {
                        commentStr = [NSString stringWithFormat:@"%@：%@",dict[@"fromUser"],dict[@"content"]];
                    } else {
                        commentStr = [NSString stringWithFormat:@"%@ 回复 %@：%@",dict[@"fromUser"],dict[@"toUser"],dict[@"content"]];
                    }
                    CGFloat commentH = [ADLUtils calculateString:commentStr rectSize:CGSizeMake(SCREEN_WIDTH-85, MAXFLOAT) fontSize:14].height+12;
                    [dict setValue:commentStr forKey:@"commentStr"];
                    [model.sReplyHArr addObject:@(commentH)];
                    [model.sReplyArr addObject:dict];
                }
                [self.tableView reloadData];
            }
        } failure:nil];
    } else {
        model.fold = YES;
        [model.sReplyArr removeObjectsInRange:NSMakeRange(2, model.sReplyArr.count-2)];
        [model.sReplyHArr removeObjectsInRange:NSMakeRange(2, model.sReplyArr.count-2)];
        [self.tableView reloadData];
    }
}

#pragma mark ------ 获取回复数据 ------
- (void)getEvaluateReply {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.evaluateDict[@"id"] forKey:@"evaluateId"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(10) forKey:@"pageSize"];
    [ADLNetWorkManager postWithPath:k_query_goods_evaluate_reply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.evaluateDict setValue:responseDict[@"data"][@"total"] forKey:@"replyNum"];
            [self.replyView.replyBtn setTitle:[NSString stringWithFormat:@"  %@",responseDict[@"data"][@"total"]] forState:UIControlStateNormal];
            
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            if (resArr.count > 0) {
                for (NSMutableDictionary *dict in resArr) {
                    ADLGoodsEvaModel *model = [[ADLGoodsEvaModel alloc] init];
                    model.replyId = dict[@"id"];
                    model.content = dict[@"content"];
                    model.fromUser = dict[@"fromUser"];
                    model.toUserId = dict[@"toUserId"];
                    model.fromUserId = dict[@"fromUserId"];
                    model.addDatetime = dict[@"addDatetime"];
                    model.headImg = [dict[@"headImg"] stringValue].length > 0 ? [dict[@"headImg"] stringValue] : @"";
                    CGFloat headerH = [ADLUtils calculateString:dict[@"content"] rectSize:CGSizeMake(SCREEN_WIDTH-78, MAXFLOAT) fontSize:14].height+62;
                    NSMutableArray *listArr = dict[@"replyVOList"];
                    if (listArr.count > 1) {
                        model.fold = YES;
                    } else {
                        model.fold = NO;
                    }
                    if (listArr.count > 0) {
                        headerH = headerH + 12;
                        for (NSMutableDictionary *sDict in listArr) {
                            NSString *commentStr;
                            if ([sDict[@"fromUserId"] isEqualToString:sDict[@"toUserId"]]) {
                                commentStr = [NSString stringWithFormat:@"%@：%@",sDict[@"fromUser"],sDict[@"content"]];
                            } else {
                                commentStr = [NSString stringWithFormat:@"%@ 回复 %@：%@",sDict[@"fromUser"],sDict[@"toUser"],sDict[@"content"]];
                            }
                            CGFloat commentH = [ADLUtils calculateString:commentStr rectSize:CGSizeMake(SCREEN_WIDTH-85, MAXFLOAT) fontSize:14].height+12;
                            [sDict setValue:commentStr forKey:@"commentStr"];
                            [model.sReplyHArr addObject:@(commentH)];
                            [model.sReplyArr addObject:sDict];
                        }
                    }
                    model.headerH = headerH;
                    [self.dataArr addObject:model];
                }
            }
            if (resArr.count < 10) {
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
    } failure:nil];
}

#pragma mark ------ 添加回复 ------
- (void)addReplyData {
    [self.params setValue:[ADLUserModel sharedModel].userId forKey:@"fromUserId"];
    [self.params setValue:self.evaluateDict[@"buyerUserId"] forKey:@"toUserId"];
    [self.params setValue:self.replyView.textField.text forKey:@"content"];
    [self.params setValue:self.evaluateDict[@"id"] forKey:@"evaluateId"];
    [self.params setValue:@(1) forKey:@"type"];
    
    NSDictionary *param = [self.params copy];
    [self.replyView.textField resignFirstResponder];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_goods_evaluate_reply parameters:param autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"回复成功"];
            self.offset = 0;
            [self getEvaluateReply];
        }
    } failure:nil];
}

#pragma mark ------ 计算评论cell高度 ------
- (CGFloat)calculateEvaluateCellHeight:(NSInteger)count {
    switch (count) {
        case 0:
            return 3;
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

#pragma mark ------ 退出编辑 ------
- (void)exitKeyBoard {
    [self.replyView.textField resignFirstResponder];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:@"blank_reply" prompt:@"暂无回复" backgroundColor:nil];
        _blankView.topMargin = 90;
    }
    return _blankView;
}

- (void)dealloc {
    if (self.finishBlock) {
        self.finishBlock(self.evaluateDict);
    }
}

@end
