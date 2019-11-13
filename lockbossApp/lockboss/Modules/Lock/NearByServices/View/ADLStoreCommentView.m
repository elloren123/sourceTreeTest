//
//  ADLStoreCommentView.m
//  lockboss
//
//  Created by bailun91 on 2019/10/15.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLStoreCommentView.h"
#import "ADLNYCommetViewModel.h"
#import "ADLCommetViewCell.h"
#import <UIImageView+WebCache.h>
#import "ADLLocalImgPreView.h"
#import "ADLRefreshHeader.h"
#import "ADLRefreshFooter.h"


@implementation ADLStoreCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }    
    return self;
}
- (void)setupSubviews {
    UILabel *scoreLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/4, 30)];
    scoreLab.textAlignment = NSTextAlignmentCenter;
    scoreLab.font = [UIFont systemFontOfSize:25];
    scoreLab.textColor = COLOR_E0212A;
    scoreLab.text = @"--";
    [self addSubview:scoreLab];
    self.ZHScoreLab = scoreLab;
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/4, 20)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:15];
    titLab.textColor = COLOR_E0212A;
    titLab.text = @"商家评分";
    [self addSubview:titLab];
    

    // ------ *** ------
    UILabel *weiSheng = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 10, 40, 25)];
    weiSheng.textAlignment = NSTextAlignmentRight;
    weiSheng.font = [UIFont systemFontOfSize:15];
    weiSheng.textColor = [UIColor grayColor];
    weiSheng.text = @"卫生";
    [self addSubview:weiSheng];
    
    //stars
    for (int i = 0 ; i < 5; i++) {
        UIImageView *starImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4+45+18*i, 15, 16, 15)];
        starImg.image = [UIImage imageNamed:@"icon_xing1"];
        [self addSubview:starImg];
        
        if (0 == i) {
            self.wsStarImg1 = starImg;
        } else if (1 == i) {
            self.wsStarImg2 = starImg;
        } else if (2 == i) {
            self.wsStarImg3 = starImg;
        } else if (3 == i) {
            self.wsStarImg4 = starImg;
        } else if (4 == i) {
            self.wsStarImg5 = starImg;
        }
    }
    
    UILabel *wsScoreLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4+140, 10, 45, 25)];
    wsScoreLab.textAlignment = NSTextAlignmentLeft;
    wsScoreLab.font = [UIFont systemFontOfSize:15.5];
    wsScoreLab.textColor = COLOR_E0212A;
    wsScoreLab.text = @"--";
    [self addSubview:wsScoreLab];
    self.WSScoreLab = wsScoreLab;
    
    
    // ------ *** ------
    UILabel *kouWei = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 35, 40, 25)];
    kouWei.textAlignment = NSTextAlignmentRight;
    kouWei.font = [UIFont systemFontOfSize:15];
    kouWei.textColor = [UIColor grayColor];
    kouWei.text = @"口味";
    [self addSubview:kouWei];
    
    //stars
    for (int i = 0 ; i < 5; i++) {
        UIImageView *starImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4+45+18*i, 40, 16, 15)];
        starImg.image = [UIImage imageNamed:@"icon_xing1"];
        [self addSubview:starImg];
        
        if (0 == i) {
            self.kwStarImg1 = starImg;
        } else if (1 == i) {
            self.kwStarImg2 = starImg;
        } else if (2 == i) {
            self.kwStarImg3 = starImg;
        } else if (3 == i) {
            self.kwStarImg4 = starImg;
        } else if (4 == i) {
            self.kwStarImg5 = starImg;
        }
    }
    
    UILabel *kwScoreLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4+140, 35, 45, 25)];
    kwScoreLab.textAlignment = NSTextAlignmentLeft;
    kwScoreLab.font = [UIFont systemFontOfSize:15.5];
    kwScoreLab.textColor = COLOR_E0212A;
    kwScoreLab.text = @"--";
    [self addSubview:kwScoreLab];
    self.KWScoreLab = kwScoreLab;
    
    
    
    // ------ *** ------
    UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4, 10, 1, 50)];
    gapView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:gapView];
    
    
    
    UILabel *psScoreLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4, 10, SCREEN_WIDTH/4, 30)];
    psScoreLab.textAlignment = NSTextAlignmentCenter;
    psScoreLab.font = [UIFont systemFontOfSize:21];
    psScoreLab.textColor = COLOR_E0212A;
    psScoreLab.text = @"--";
    [self addSubview:psScoreLab];
    self.PSScoreLab = psScoreLab;
    
    UILabel *peiSongLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4, 40, SCREEN_WIDTH/4, 20)];
    peiSongLab.textAlignment = NSTextAlignmentCenter;
    peiSongLab.font = [UIFont systemFontOfSize:15];
    peiSongLab.textColor = COLOR_E0212A;
    peiSongLab.text = @"配送满意度";
    [self addSubview:peiSongLab];
    
    
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 5)];
    grayView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:grayView];
    
    
    
    // ------ *** ------
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-340)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.table = tableView;
    
    __weak typeof(self)WeakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        WeakSelf.blankLab.hidden = YES;
        WeakSelf.tableViewHeaderRefreshBlock();
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
//        WeakSelf.blankLab.hidden = YES;
        WeakSelf.tableViewFooterRefreshBlock();
    }];
    tableView.mj_footer.hidden = YES;
    
    
    
    UILabel *blankLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-340)];
    blankLab.textAlignment = NSTextAlignmentCenter;
    blankLab.font = [UIFont systemFontOfSize:15];
    blankLab.textColor = [UIColor lightGrayColor];
    blankLab.text = @"暂无数据";
    blankLab.hidden = YES;
    [self addSubview:blankLab];
    self.blankLab = blankLab;
}

#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLNYCommetViewModel *model = (ADLNYCommetViewModel *)self.dataArray[indexPath.row];
    return model.userMsgHeight+model.cmtImgHeight+model.replyHeight+65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLCommetViewCell *cmtCell = [tableView dequeueReusableCellWithIdentifier:@"cmtCell"];
    if (cmtCell == nil) {
        cmtCell = [[ADLCommetViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cmtCell"];
        cmtCell.selectionStyle = UITableViewCellSelectionStyleNone;
    } 
    
    ADLNYCommetViewModel *model = (ADLNYCommetViewModel *)self.dataArray[indexPath.row];
    //重新对子控件布局
    [cmtCell updateSubviewsFrame:model];
    
    //对子控件赋值
    [cmtCell.userHeadImgV sd_setImageWithURL:[NSURL URLWithString:model.userHeadImgUrl] placeholderImage:[UIImage imageNamed:@"user_head"]];
    if (model.anonymousFlag == 1) { //匿名
        cmtCell.userNameLab.text = @"*****";
    } else {
        cmtCell.userNameLab.text = model.userName;  //评价用户名
    }
    cmtCell.cmtDateLab.text  = model.cmtDate;   //评价日期
    if (model.userMsg) {
        cmtCell.cmtMsgLab.text = model.userMsg;   //评价内容
    } else {
        cmtCell.cmtMsgLab.text = @"该用户没有填写评价.";   //评价内容
    }
    if (model.cmtImgUrl.length != 0) {//评价截图
        NSArray *urlArr = [model.cmtImgUrl componentsSeparatedByString:@","];
        if (urlArr.count == 1) {
            [cmtCell.cmtImgV sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
            cmtCell.cmtImgV2.image = nil;
            cmtCell.cmtImgV3.image = nil;
            
        } else if (urlArr.count == 2) {
            [cmtCell.cmtImgV sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
            [cmtCell.cmtImgV2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
            cmtCell.cmtImgV3.image = nil;
       
        } else if (urlArr.count == 3) {
            [cmtCell.cmtImgV sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
            [cmtCell.cmtImgV2 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
            [cmtCell.cmtImgV3 sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
        }
    } else {
        cmtCell.cmtImgV.image = nil;
        cmtCell.cmtImgV2.image = nil;
        cmtCell.cmtImgV3.image = nil;
    }

    cmtCell.stoMsgLab.text = model.replyMsg;//商家回复信息
    
    if (model.cmtScore.floatValue > 4) {
        cmtCell.scoreImgV1.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV2.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV3.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV4.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV5.image = [UIImage imageNamed:@"icon_xing"];
    } else if (model.cmtScore.floatValue > 3) {
        cmtCell.scoreImgV1.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV2.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV3.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV4.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV5.image = [UIImage imageNamed:@"icon_xing1"];
    } else if (model.cmtScore.floatValue > 2) {
        cmtCell.scoreImgV1.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV2.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV3.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV4.image = [UIImage imageNamed:@"icon_xing1"];
        cmtCell.scoreImgV5.image = [UIImage imageNamed:@"icon_xing1"];
    } else if (model.cmtScore.floatValue > 1) {
        cmtCell.scoreImgV1.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV2.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV3.image = [UIImage imageNamed:@"icon_xing1"];
        cmtCell.scoreImgV4.image = [UIImage imageNamed:@"icon_xing1"];
        cmtCell.scoreImgV5.image = [UIImage imageNamed:@"icon_xing1"];
    } else {
        cmtCell.scoreImgV1.image = [UIImage imageNamed:@"icon_xing"];
        cmtCell.scoreImgV2.image = [UIImage imageNamed:@"icon_xing1"];
        cmtCell.scoreImgV3.image = [UIImage imageNamed:@"icon_xing1"];
        cmtCell.scoreImgV4.image = [UIImage imageNamed:@"icon_xing1"];
        cmtCell.scoreImgV5.image = [UIImage imageNamed:@"icon_xing1"];
    }
    
    return cmtCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLNYCommetViewModel *model = (ADLNYCommetViewModel *)self.dataArray[indexPath.row];
    if (model.cmtImgUrl.length != 0) {
        ADLCommetViewCell *cell = (ADLCommetViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSArray *urlArr = [model.cmtImgUrl componentsSeparatedByString:@","];
        NSMutableArray *imgViewArr = [[NSMutableArray alloc] init];
        if (urlArr.count == 1) {
            [imgViewArr addObject:cell.cmtImgV];
            
        } else if (urlArr.count == 2) {
            [imgViewArr addObject:cell.cmtImgV];
            [imgViewArr addObject:cell.cmtImgV2];
            
        } else if (urlArr.count >= 3) {
            [imgViewArr addObject:cell.cmtImgV];
            [imgViewArr addObject:cell.cmtImgV2];
            [imgViewArr addObject:cell.cmtImgV3];
        }
        [ADLLocalImgPreView showWithImageViews:imgViewArr currentIndex:0];
    }
}

#pragma mark ------ 刷新view ------
- (void)updateCommentView:(NSDictionary *)dict {
    self.ZHScoreLab.text = [NSString stringWithFormat:@"%.1f", [dict[@"score"] floatValue]];
    //update frames
    [self updateWSStarImgsAndLabel:dict[@"hygiene"]];
    self.WSScoreLab.text = [NSString stringWithFormat:@"%.1f", [dict[@"hygiene"] floatValue]];
    [self updateKWStarImgsAndLabel:dict[@"pack"]];
    self.KWScoreLab.text = [NSString stringWithFormat:@"%.1f", [dict[@"pack"] floatValue]];
    self.PSScoreLab.text = [NSString stringWithFormat:@"%d%%", (int)([dict[@"ship"] floatValue]*20)];
    
    
    
    
    //创建UISegmentedControl
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"全部%zd", [dict[@"praiseNum"] integerValue]+[dict[@"badNum"] integerValue]]];
    [array addObject:[NSString stringWithFormat:@"高分评价%zd", [dict[@"praiseNum"] integerValue]]];
    [array addObject:[NSString stringWithFormat:@"低分评价%zd", [dict[@"badNum"] integerValue]]];
    [array addObject:[NSString stringWithFormat:@"晒图评价%zd", [dict[@"imgNum"] integerValue]]];
    
    //UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    segmentedControl.frame = CGRectMake(10, 85, SCREEN_WIDTH-20, 40);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = COLOR_E0212A;
    [segmentedControl addTarget:self action:@selector(segmentedControlMethod:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segmentedControl];
}

- (void)updateWSStarImgsAndLabel:(NSString *)score {
    if (score.floatValue > 4) {
        self.wsStarImg1.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg2.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg3.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg4.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg5.image = [UIImage imageNamed:@"icon_xing"];
        
    } else if (score.floatValue > 3) {
        self.wsStarImg1.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg2.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg3.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg4.image = [UIImage imageNamed:@"icon_xing"];
        
    } else if (score.floatValue > 2) {
        self.wsStarImg1.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg2.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg3.image = [UIImage imageNamed:@"icon_xing"];
        
    } else if (score.floatValue > 1) {
        self.wsStarImg1.image = [UIImage imageNamed:@"icon_xing"];
        self.wsStarImg2.image = [UIImage imageNamed:@"icon_xing"];
        
    } else {
        self.wsStarImg1.image = [UIImage imageNamed:@"icon_xing"];
    }
}

- (void)updateKWStarImgsAndLabel:(NSString *)score {
    if (score.floatValue > 4) {
        self.kwStarImg1.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg2.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg3.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg4.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg5.image = [UIImage imageNamed:@"icon_xing"];
        
    } else if (score.floatValue > 3) {
        self.kwStarImg1.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg2.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg3.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg4.image = [UIImage imageNamed:@"icon_xing"];
        
    } else if (score.floatValue > 2) {
        self.kwStarImg1.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg2.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg3.image = [UIImage imageNamed:@"icon_xing"];
        
    } else if (score.floatValue > 1) {
        self.kwStarImg1.image = [UIImage imageNamed:@"icon_xing"];
        self.kwStarImg2.image = [UIImage imageNamed:@"icon_xing"];
        
    } else {
        self.kwStarImg1.image = [UIImage imageNamed:@"icon_xing"];
    }
}
- (void)segmentedControlMethod:(UISegmentedControl *)control {
    if (self.blankLab.hidden == NO) {
        self.blankLab.hidden = YES;
    }
    self.didSelectedSegmentedControl(control.selectedSegmentIndex);
}



@end

