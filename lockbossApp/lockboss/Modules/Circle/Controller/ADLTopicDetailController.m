//
//  ADLTopicDetailController.m
//  lockboss
//
//  Created by adel on 2019/6/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTopicDetailController.h"
#import "ADLTopicReportController.h"
#import "ADLWriteTopicController.h"

#import "ADLTopicDetailHeadView.h"
#import "ADLTopicCommentHeader.h"
#import "ADLTopicCommentCell.h"
#import "ADLKeyboardMonitor.h"
#import "ADLImagePreView.h"
#import "ADLCommentView.h"
#import "ADLTopicModel.h"
#import "ADLBottomView.h"
#import "ADLBlankView.h"

@interface ADLTopicDetailController ()<UITableViewDelegate,UITableViewDataSource,ADLTopicCommentHeaderDelegate,ADLTopicDetailHeadViewDelegate,ADLTopicCommentCellDelegate>
@property (nonatomic, strong) ADLTopicDetailHeadView *headView;
@property (nonatomic, strong) NSMutableDictionary *topicDict;
@property (nonatomic, strong) ADLCommentView *commentView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, assign) BOOL delete;

@end

@implementation ADLTopicDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"话题详情"];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.publisherId isEqualToString:[ADLUserModel sharedModel].userId]) {
        [self addRightButtonWithImageName:@"topic_delete" action:@selector(clickDeleteTopicBtn:)];
    } else {
        [self addRightButtonWithImageName:@"topic_write" action:@selector(clickWriteTopicBtn:)];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-50) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.tableFooterView = [UIView new];
    __weak typeof(self)weakSelf = self;
    
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf getTopicData];
        [weakSelf getCommentData:weakSelf.pageSize];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getCommentData:weakSelf.pageSize];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_H-51, SCREEN_WIDTH, 51)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_H-51, SCREEN_WIDTH, 0.5)];
    spView.backgroundColor = SEPARATOR_COLOR;
    [self.view addSubview:spView];
    
    UIButton *inputBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, SCREEN_HEIGHT-BOTTOM_H-42, SCREEN_WIDTH-90, 34)];
    [inputBtn setTitleColor:PLACEHOLDER_COLOR forState:UIControlStateNormal];
    inputBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    inputBtn.backgroundColor = COLOR_F2F2F2;
    inputBtn.layer.cornerRadius = 3;
    inputBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [inputBtn setTitle:@"  留下你的评论..." forState:UIControlStateNormal];
    [inputBtn addTarget:self action:@selector(clickTopicCommentBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputBtn];
    
    UIButton *praiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-76, SCREEN_HEIGHT-BOTTOM_H-42, 64, 34)];
    praiseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    praiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [praiseBtn setTitle:@"  点赞" forState:UIControlStateNormal];
    [praiseBtn setTitle:@"  已赞" forState:UIControlStateSelected];
    [praiseBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"dz_bottom_n"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"dz_bottom_s"] forState:UIControlStateSelected];
    [praiseBtn addTarget:self action:@selector(clickTopicPraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:praiseBtn];
    self.praiseBtn = praiseBtn;
    if (self.praise) {
        praiseBtn.selected = YES;
    }
    self.delete = NO;
    [self getTopicData];
    [self getCommentData:10];
    [[ADLKeyboardMonitor monitor] setGap:0];
    [[ADLKeyboardMonitor monitor] setEnable:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[ADLKeyboardMonitor monitor] setEnable:NO];
}

#pragma mark ------ UITableView Delegate && dataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ADLTopicModel *model = self.dataArr[section];
    return model.headerH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ADLTopicCommentHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (headerView == nil) {
        headerView = [[NSBundle mainBundle] loadNibNamed:@"ADLTopicCommentHeader" owner:nil options:nil].lastObject;
        headerView.delegate = self;
    }
    ADLTopicModel *model = self.dataArr[section];
    [headerView.imgView sd_setImageWithURL:[NSURL URLWithString:model.headShot] placeholderImage:[UIImage imageNamed:@"user_head"]];
    headerView.nickLab.text = model.userName;
    headerView.contentLab.text = model.content;
    [headerView.praiseBtn setTitle:[NSString stringWithFormat:@"  %@",model.fabulousNums] forState:UIControlStateNormal];
    [headerView.commentBtn setTitle:[NSString stringWithFormat:@"  %@",model.commentNums] forState:UIControlStateNormal];
    if ([model.fabulousFlag integerValue] == 2) {
        headerView.praiseBtn.selected = YES;
    } else {
        headerView.praiseBtn.selected = NO;
    }
    if (model.replys.count > 0) {
        headerView.spView.hidden = YES;
    } else {
        headerView.spView.hidden = NO;
    }
    headerView.section = section;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ADLTopicModel *model = self.dataArr[section];
    if (model.replys.count > 0) {
        return 12;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (footerView == nil) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footer"];
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(12, 11.5, SCREEN_WIDTH-12, 0.5)];
        spView.backgroundColor = SEPARATOR_COLOR;
        [footerView.contentView addSubview:spView];
        footerView.clipsToBounds = YES;
    }
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ADLTopicModel *model = self.dataArr[section];
    return model.replys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLTopicModel *model = self.dataArr[indexPath.section];
    return [model.cellHArr[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLTopicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLTopicCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    ADLTopicModel *mode = self.dataArr[indexPath.section];
    cell.contentLab.attributedText = mode.replys[indexPath.row][@"attributeText"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.commentView isEditing]) {
        [self.commentView endEditing];
    }
}

#pragma mark ------ 话题评论 ------
- (void)clickTopicCommentBtn {
    self.commentView.placeHolder = @"请输入评论";
    self.commentView.tag = 3;
    [self.commentView beginEditing];
}

#pragma mark ------ 话题点赞 ------
- (void)clickTopicPraiseBtn:(UIButton *)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.topicId forKey:@"topicId"];
    sender.enabled = NO;
    if (sender.selected) {
        [ADLNetWorkManager postWithPath:k_topic_cancle_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSInteger praiseCount = [self.topicDict[@"fabulousNums"] integerValue]-1;
                [self.topicDict setValue:@(praiseCount) forKey:@"fabulousNums"];
                [self.topicDict setValue:@(1) forKey:@"fabulousFlag"];
                self.headView.praiseLab.text = [NSString stringWithFormat:@"点赞  %@",self.topicDict[@"fabulousNums"]];
                self.praise = NO;
                sender.selected = NO;
            }
            sender.enabled = YES;
        } failure:^(NSError *error) {
            sender.enabled = YES;
        }];
    } else {
        [params setValue:@(2) forKey:@"type"];
        [ADLNetWorkManager postWithPath:k_topic_comment_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSInteger praiseCount = [self.topicDict[@"fabulousNums"] integerValue]+1;
                [self.topicDict setValue:@(praiseCount) forKey:@"fabulousNums"];
                [self.topicDict setValue:@(2) forKey:@"fabulousFlag"];
                self.headView.praiseLab.text = [NSString stringWithFormat:@"点赞  %@",self.topicDict[@"fabulousNums"]];
                self.praise = YES;
                sender.selected = YES;
            }
            sender.enabled = YES;
        } failure:^(NSError *error) {
            sender.enabled = YES;
        }];
    }
}

#pragma mark ------ 点击话题头像 ------
- (void)didClickTopicHeaderImageView:(UIImageView *)imageView {
    if (self.topicDict[@"headShot"]) {
        [ADLImagePreView showWithImageViews:@[imageView] urlArray:@[self.topicDict[@"headShot"]] currentIndex:0];
    }
}

#pragma mark ------ 点击话题内容 ------
- (void)didClickTopicContentLab:(UILabel *)contentLab {
    [ADLBottomView showWithTitles:@[@"举报",@"复制"] finish:^(NSInteger index) {
        contentLab.textColor = COLOR_666666;
        [UIView animateWithDuration:0.3 animations:^{
            contentLab.alpha = 1;
        }];
        if (index == 0) {
            ADLTopicReportController *reportVC = [[ADLTopicReportController alloc] init];
            reportVC.reportId = self.topicId;
            reportVC.reportType = 2;
            [self.navigationController pushViewController:reportVC animated:YES];
        }
        if (index == 1) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = contentLab.text;
            [ADLToast showMessage:@"复制成功"];
        }
    }];
}

#pragma mark ------ 点击话题图片 ------
- (void)didClickTopicImageView:(UIImageView *)imageView {
    [ADLImagePreView showWithImageViews:self.headView.imageViewArr urlArray:self.topicDict[@"imageUrls"] currentIndex:imageView.tag];
}

#pragma mark ------ 点击评论头像 ------
- (void)didClickCommentHeadImage:(UIImageView *)imageView {
    ADLTopicCommentHeader *header = (ADLTopicCommentHeader *)imageView.superview.superview;
    ADLTopicModel *model = self.dataArr[header.section];
    if (model.headShot) {
        if ([self.commentView isEditing]) {
            [self.commentView endEditing];
        }
        [ADLImagePreView showWithImageViews:@[imageView] urlArray:@[model.headShot] currentIndex:0];
    }
}

#pragma mark ------ 点击评论内容 ------
- (void)didClickCommentContentLab:(UILabel *)contentLab {
    if ([self.commentView isEditing]) {
        [self.commentView endEditing];
    }
    
    ADLTopicCommentHeader *header = (ADLTopicCommentHeader *)contentLab.superview.superview;
    ADLTopicModel *model = self.dataArr[header.section];
    NSArray *titleArr;
    if ([model.createUser isEqualToString:[ADLUserModel sharedModel].userId]) {
        titleArr = @[@"举报",@"复制",@"回复",@"删除"];
    } else {
        titleArr = @[@"举报",@"复制",@"回复"];
    }
    [ADLBottomView showWithTitles:titleArr finish:^(NSInteger index) {
        contentLab.textColor = COLOR_666666;
        [UIView animateWithDuration:0.3 animations:^{
            contentLab.alpha = 1;
        }];
        if (index >= 0) {
            if (index == 0) {
                ADLTopicReportController *reportVC = [[ADLTopicReportController alloc] init];
                reportVC.reportId = model.commentId;
                reportVC.reportType = 3;
                [self.navigationController pushViewController:reportVC animated:YES];
            } else if (index == 1) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = contentLab.text;
                [ADLToast showMessage:@"复制成功"];
            } else if (index == 2) {
                
                CGFloat offsetY = self.tableView.contentOffset.y;
                CGFloat bottomH = [ADLUtils convertRectWithView:contentLab]-56;
                __weak typeof(self)weakSelf = self;
                [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
                    if (keyboardH == 0) {
                        [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
                    } else {
                        if (bottomH < keyboardH) {
                            [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
                        }
                    }
                };
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setValue:model.commentId forKey:@"commentId"];
                [params setValue:@(1) forKey:@"type"];
                [params setValue:model.createUser forKey:@"toUserId"];
                [params setValue:@(header.section) forKey:@"section"];
                
                self.commentView.placeHolder = [NSString stringWithFormat:@"回复 %@",model.userName];
                self.commentView.tag = 6;
                self.commentView.params = params;
                [self.commentView beginEditing];
            } else {
                [self deleteComment:header.section commentId:model.commentId];
            }
        }
    }];
}

#pragma mark ------ 评论点赞 ------
- (void)didClickCommentPraiseBtn:(UIButton *)sender {
    ADLTopicCommentHeader *header = (ADLTopicCommentHeader *)sender.superview.superview;
    ADLTopicModel *model = self.dataArr[header.section];
    sender.enabled = NO;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:model.commentId forKey:@"commentId"];
    
    if (sender.selected) {
        [ADLNetWorkManager postWithPath:k_comment_cancle_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                model.fabulousFlag = @(1);
                model.fabulousNums = @([model.fabulousNums integerValue]-1);
                [self.tableView reloadData];
            }
            sender.enabled = YES;
        } failure:^(NSError *error) {
            sender.enabled = YES;
        }];
    } else {
        [params setValue:model.createUser forKey:@"toUserId"];
        [params setValue:@(2) forKey:@"type"];
        [ADLNetWorkManager postWithPath:k_comment_reply_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                model.fabulousFlag = @(2);
                model.fabulousNums = @([model.fabulousNums integerValue]+1);
                [self.tableView reloadData];
            }
            sender.enabled = YES;
        } failure:^(NSError *error) {
            sender.enabled = YES;
        }];
    }
}

#pragma mark ------ 评论回复 ------
- (void)didClickCommentReplyBtn:(UIButton *)sender contentLab:(UILabel *)contentLab {
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:contentLab]-56;
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            CGFloat maxOffset = weakSelf.tableView.contentSize.height-weakSelf.tableView.frame.size.height;
            if (offsetY > maxOffset && maxOffset > 0) {
                [weakSelf.tableView setContentOffset:CGPointMake(0, maxOffset) animated:YES];
            } else {
                [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
            }
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
    
    ADLTopicCommentHeader *header = (ADLTopicCommentHeader *)sender.superview.superview;
    ADLTopicModel *model = self.dataArr[header.section];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:model.commentId forKey:@"commentId"];
    [params setValue:@(1) forKey:@"type"];
    [params setValue:model.createUser forKey:@"toUserId"];
    [params setValue:@(header.section) forKey:@"section"];
    
    self.commentView.placeHolder = [NSString stringWithFormat:@"回复 %@",model.userName];
    self.commentView.tag = 6;
    self.commentView.params = params;
    [self.commentView beginEditing];
}

#pragma mark ------ 点击回复 ------
- (void)didClickReplyLabel:(UILabel *)label {
    ADLTopicCommentCell *cell = (ADLTopicCommentCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([self.commentView isEditing]) {
        [self.commentView endEditing];
    }
    
    ADLTopicModel *model = self.dataArr[indexPath.section];
    NSMutableDictionary *dict = model.replys[indexPath.row];
    if (dict[@"content"]) {
        NSMutableAttributedString *mutableStr = dict[@"attributeText"];
        NSString *commentStr = [mutableStr string];
        NSRange range = [commentStr rangeOfString:dict[@"content"]];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:range];
        [UIView animateWithDuration:0.3 animations:^{
            label.alpha = 0.5;
        } completion:^(BOOL finished) {
            label.attributedText = mutableStr;
        }];
        
        NSArray *titleArr;
        if ([dict[@"fromUserId"] isEqualToString:[ADLUserModel sharedModel].userId]) {
            titleArr = @[@"举报",@"复制",@"回复",@"删除"];
        } else {
            titleArr = @[@"举报",@"复制",@"回复"];
        }
        
        [ADLBottomView showWithTitles:titleArr finish:^(NSInteger index) {
            [mutableStr removeAttribute:NSForegroundColorAttributeName range:range];
            label.attributedText = mutableStr;
            [UIView animateWithDuration:0.3 animations:^{
                label.alpha = 1;
            }];
            if (index >= 0) {
                if (index == 0) {
                    ADLTopicReportController *reportVC = [[ADLTopicReportController alloc] init];
                    reportVC.reportType = 4;
                    reportVC.reportId = dict[@"id"];
                    [self.navigationController pushViewController:reportVC animated:YES];
                    
                } else if (index == 1) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = dict[@"content"];
                    [ADLToast showMessage:@"复制成功"];
                    
                } else if (index == 2) {
                    
                    CGFloat offsetY = self.tableView.contentOffset.y;
                    CGFloat bottomH = [ADLUtils convertRectWithView:label]-53;
                    __weak typeof(self)weakSelf = self;
                    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
                        if (keyboardH == 0) {
                            [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
                        } else {
                            if (bottomH < keyboardH) {
                                [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
                            }
                        }
                    };
                    
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    [params setValue:model.commentId forKey:@"commentId"];
                    [params setValue:@(1) forKey:@"type"];
                    [params setValue:dict[@"fromUserId"] forKey:@"toUserId"];
                    [params setValue:@(indexPath.section) forKey:@"section"];
                    
                    self.commentView.placeHolder = [NSString stringWithFormat:@"回复 %@",dict[@"fromUserName"]];
                    self.commentView.tag = 6;
                    self.commentView.params = params;
                    [self.commentView beginEditing];
                } else {
                    [self deleteReply:indexPath replyId:dict[@"id"]];
                }
            }
        }];
    }
}

#pragma mark ------ 删除评论 ------
- (void)deleteComment:(NSInteger)section commentId:(NSString *)commentId {
    [ADLAlertView showWithTitle:@"提示" message:@"确认删除此条评论？" confirmTitle:nil confirmAction:^{
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:commentId forKey:@"commentId"];
        [ADLNetWorkManager postWithPath:k_comment_delete parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            [ADLToast showMessage:@"删除成功"];
            NSInteger commentCount = [self.topicDict[@"commentNums"] integerValue]-1;
            [self.topicDict setValue:@(commentCount) forKey:@"commentNums"];
            self.headView.evaluateLab.text = [NSString stringWithFormat:@"评论  %ld",commentCount];
            [self.dataArr removeObjectAtIndex:section];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            self.offset = self.dataArr.count;
            if (self.dataArr.count == 0) {
                [self getCommentData:10];
            }
        } failure:nil];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

#pragma mark ------ 删除回复 ------
- (void)deleteReply:(NSIndexPath *)indexPath replyId:(NSString *)replyId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:replyId forKey:@"replyId"];
    [ADLNetWorkManager postWithPath:k_reply_delete parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"删除成功"];
            ADLTopicModel *model = self.dataArr[indexPath.section];
            [model.replys removeObjectAtIndex:indexPath.row];
            [model.cellHArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if (model.replys.count == 0) {
                [self queryCommentReply:model.commentId model:model];
            }
        }
    } failure:nil];
}

#pragma mark ------ 删除话题 ------
- (void)clickDeleteTopicBtn:(UIButton *)sender {
    [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"确定删除我的话题？" confirmTitle:nil confirmAction:^{
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.topicId forKey:@"topicId"];
        [ADLNetWorkManager postWithPath:k_topic_delete parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"删除成功"];
                self.delete = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:nil];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

#pragma mark ------ 发表话题 ------
- (void)clickWriteTopicBtn:(UIButton *)sender {
    ADLWriteTopicController *writeVC = [[ADLWriteTopicController alloc] init];
    writeVC.circleId = self.circleId;
    [self.navigationController pushViewController:writeVC animated:YES];
}

#pragma mark ------ 获取话题详情 ------
- (void)getTopicData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.topicId forKey:@"topicId"];
    [ADLNetWorkManager postWithPath:k_topic_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSMutableDictionary *dict = responseDict[@"data"];
            [self.headView.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
            if ([dict[@"userName"] stringValue].length == 0) {
                [dict setValue:@" " forKey:@"userName"];
            }
            self.headView.nickLab.text = dict[@"userName"];
            NSString *content = dict[@"content"];
            self.headView.contentLab.text = content;
            CGFloat contentH = [ADLUtils calculateString:content rectSize:CGSizeMake(SCREEN_WIDTH-76, MAXFLOAT) fontSize:14].height;
            NSArray *imgArr = [dict[@"imgs"] componentsSeparatedByString:@","];
            CGFloat imageH = [self calculateCellHeightWithImageCount:imgArr.count content:content.length>0];
            [self.headView updateImageViewImage:imgArr content:content.length>0 width:SCREEN_WIDTH-128];
            NSInteger second = [ADLUtils getSecondFromStartTimestamp:[dict[@"createTime"] doubleValue] endTimestamp:0];
            self.headView.timeLab.text = [self dealwithTime:second timestamp:[dict[@"createTime"] doubleValue]];
            self.headView.praiseLab.text = [NSString stringWithFormat:@"点赞  %@",dict[@"fabulousNums"]];
            self.headView.evaluateLab.text = [NSString stringWithFormat:@"评论  %@",dict[@"commentNums"]];
            self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentH+imageH);
            self.tableView.tableHeaderView = self.headView;
            self.topicDict = dict;
            [self.topicDict setValue:imgArr forKey:@"imageUrls"];
            if (self.praise) {
                [self.topicDict setValue:@(2) forKey:@"fabulousFlag"];
            } else {
                [self.topicDict setValue:@(1) forKey:@"fabulousFlag"];
            }
        }
    } failure:nil];
}

#pragma mark ------ 获取评论 ------
- (void)getCommentData:(NSInteger)pageSize {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(pageSize) forKey:@"pageSize"];
    [params setValue:self.topicId forKey:@"topicId"];
    
    [ADLNetWorkManager postWithPath:k_topic_evaluate_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr.count > 0) {
                for (NSDictionary *dict in resArr) {
                    ADLTopicModel *model = [[ADLTopicModel alloc] init];
                    model.headShot = dict[@"headShot"];
                    model.userName = dict[@"userName"];
                    model.content = dict[@"content"];
                    model.fabulousNums = dict[@"fabulousNums"];
                    model.commentNums = dict[@"commentNums"];
                    model.fabulousFlag = dict[@"fabulousFlag"];
                    model.commentId = dict[@"id"];
                    model.createUser = dict[@"createUser"];
                    CGFloat contentH = [ADLUtils calculateString:dict[@"content"] rectSize:CGSizeMake(SCREEN_WIDTH-78, MAXFLOAT) fontSize:14].height;
                    model.headerH = contentH+50;
                    NSMutableArray *replyArr = dict[@"replys"];
                    if (replyArr.count > 0) {
                        NSMutableArray *muArr = [[NSMutableArray alloc] init];
                        for (NSMutableDictionary *replyDict in replyArr) {
                            NSString *contentStr = @"";
                            NSMutableAttributedString *attributeStr;
                            if ([replyDict[@"fromUserId"] isEqualToString:replyDict[@"toUserId"]]) {
                                contentStr = [NSString stringWithFormat:@"%@：%@",replyDict[@"toUserName"],replyDict[@"content"]];
                                attributeStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
                                [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_333333 range:NSMakeRange(0, [replyDict[@"fromUserName"] stringValue].length+1)];
                            } else {
                                contentStr = [NSString stringWithFormat:@"%@ 回复 %@：%@",replyDict[@"fromUserName"],replyDict[@"toUserName"],replyDict[@"content"]];
                                attributeStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
                                [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_333333 range:NSMakeRange(0, [replyDict[@"fromUserName"] stringValue].length)];
                                [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_333333 range:NSMakeRange([replyDict[@"fromUserName"] stringValue].length+4, [replyDict[@"toUserName"] stringValue].length+1)];
                            }
                            
                            [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attributeStr.length)];
                            CGFloat commentH = [ADLUtils calculateAttributeString:attributeStr rectSize:CGSizeMake(SCREEN_WIDTH-85, MAXFLOAT)].height+12;
                            [replyDict setValue:attributeStr forKey:@"attributeText"];
                            [muArr addObject:@(commentH)];
                        }
                        model.replys = replyArr;
                        model.cellHArr = muArr;
                    }
                    [self.dataArr addObject:model];
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

#pragma mark ------ 发表话题评论 ------
- (void)postTopicComment:(NSString *)content {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:content forKey:@"content"];
    [params setValue:self.topicId forKey:@"topicId"];
    [params setValue:@(1) forKey:@"type"];
    
    [ADLNetWorkManager postWithPath:k_topic_comment_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"评论成功"];
            NSInteger commentCount = [self.topicDict[@"commentNums"] integerValue]+1;
            [self.topicDict setValue:@(commentCount) forKey:@"commentNums"];
            self.headView.evaluateLab.text = [NSString stringWithFormat:@"评论  %ld",commentCount];
            self.offset = 0;
            [self getCommentData:10];
        }
    } failure:nil];
}

#pragma mark ------ 发表评论回复 ------
- (void)postCommentReply:(NSDictionary *)params {
    [ADLNetWorkManager postWithPath:k_comment_reply_praise parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"回复成功"];
            NSInteger section = [params[@"section"] integerValue];
            ADLTopicModel *model = self.dataArr[section];
            [self queryCommentReply:model.commentId model:model];
        }
    } failure:nil];
}

#pragma mark ------ 查询某个评论的回复 ------
- (void)queryCommentReply:(NSString *)commentId model:(ADLTopicModel *)model {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(model.replys.count) forKey:@"offset"];
    [params setValue:@(5) forKey:@"pageSize"];
    [params setValue:commentId forKey:@"commentId"];
    
    [ADLNetWorkManager postWithPath:k_comment_reply parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *replyArr = responseDict[@"data"][@"rows"];
            for (NSMutableDictionary *replyDict in replyArr) {
                NSString *contentStr = @"";
                NSMutableAttributedString *attributeStr;
                if ([replyDict[@"fromUserId"] isEqualToString:replyDict[@"toUserId"]]) {
                    contentStr = [NSString stringWithFormat:@"%@：%@",replyDict[@"fromUserName"],replyDict[@"content"]];
                    attributeStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
                    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_333333 range:NSMakeRange(0, [replyDict[@"fromUserName"] stringValue].length+1)];
                } else {
                    contentStr = [NSString stringWithFormat:@"%@ 回复 %@：%@",replyDict[@"fromUserName"],replyDict[@"toUserName"],replyDict[@"content"]];
                    attributeStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
                    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_333333 range:NSMakeRange(0, [replyDict[@"fromUserName"] stringValue].length)];
                    [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_333333 range:NSMakeRange([replyDict[@"fromUserName"] stringValue].length+4, [replyDict[@"toUserName"] stringValue].length+1)];
                }
                
                [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attributeStr.length)];
                CGFloat commentH = [ADLUtils calculateAttributeString:attributeStr rectSize:CGSizeMake(SCREEN_WIDTH-85, MAXFLOAT)].height;
                [replyDict setValue:attributeStr forKey:@"attributeText"];
                [model.replys addObject:replyDict];
                [model.cellHArr addObject:@(commentH+12)];
            }
            [self.tableView reloadData];
        }
    } failure:nil];
}

#pragma mark ------ 计算Header高度 ------
- (CGFloat)calculateCellHeightWithImageCount:(NSInteger)count content:(BOOL)content {
    CGFloat imgTop = 0;
    if (!content) {
        imgTop = -12;
    }
    switch (count) {
        case 0:
            return 128;
            break;
        case 1:
            return 275+imgTop;
            break;
        case 2:
            return (SCREEN_WIDTH-132)/2+145+imgTop;
            break;
        case 3:
            return (SCREEN_WIDTH-136)/3+145+imgTop;
            break;
        case 5:
        case 6:
            return (SCREEN_WIDTH-136)/3*2+149+imgTop;
            break;
        default:
            return SCREEN_WIDTH+17+imgTop;
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

#pragma mark ------ HeaderView ------
- (ADLTopicDetailHeadView *)headView {
    if (_headView == nil) {
        _headView = [[NSBundle mainBundle] loadNibNamed:@"ADLTopicDetailHeadView" owner:nil options:nil].lastObject;
        _headView.delegate = self;
    }
    return _headView;
}

#pragma mark ------ 评论框 ------
- (ADLCommentView *)commentView {
    if (_commentView == nil) {
        _commentView = [ADLCommentView commentViewWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
        [self.view addSubview:_commentView];
        __weak typeof(self)weakSelf = self;
        _commentView.clickSendBtn = ^(UIButton * _Nonnull sender, NSString * _Nonnull content) {
            if ([ADLUtils hasEmoji:content]) {
                [ADLToast showMessage:@"请不要输入表情和特殊符号"];
            } else {
                if (weakSelf.commentView.tag == 3) {
                    [weakSelf postTopicComment:content];
                } else {
                    [weakSelf.commentView.params setValue:content forKey:@"content"];
                    [weakSelf postCommentReply:weakSelf.commentView.params];
                }
            }
        };
    }
    return _commentView;
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无评论" backgroundColor:nil];
        _blankView.topMargin = 90;
    }
    return _blankView;
}

#pragma mark ------ 销毁 ------
- (void)dealloc {
    if (self.delete) {
        self.topicDict = nil;
    }
    if (self.finish) {
        self.finish(self.topicDict);
    }
}

@end
