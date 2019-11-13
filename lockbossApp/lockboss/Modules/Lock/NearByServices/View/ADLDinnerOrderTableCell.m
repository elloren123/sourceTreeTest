//
//  ADLDinnerOrderTableCell.m
//  lockboss
//
//  Created by bailun91 on 2019/9/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDinnerOrderTableCell.h"

@implementation ADLDinnerOrderTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH/2, 40)];
        shopName.font = [UIFont systemFontOfSize:15];
        shopName.textAlignment = NSTextAlignmentLeft;
        shopName.textColor = [UIColor blackColor];
        [self.contentView addSubview:shopName];
//        shopName.text = @"商家名字";
        self.shopName = shopName;
        
        
        UILabel *statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-12, 0, SCREEN_WIDTH/2, 40)];
        statusLbl.font = [UIFont systemFontOfSize:14];
        statusLbl.textAlignment = NSTextAlignmentRight;
        statusLbl.textColor = COLOR_E0212A;
        [self.contentView addSubview:statusLbl];
//        statusLbl.text = @"已完成";
        self.orderStatus = statusLbl;
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 40, 80, 80)];
        [self.contentView addSubview:imgView];
        self.shopImgV = imgView;
        
        
        UILabel *leadTextLab = [[UILabel alloc] initWithFrame:CGRectMake(96, 40, SCREEN_WIDTH/2, 24)];
        leadTextLab.font = [UIFont systemFontOfSize:15];
        leadTextLab.textAlignment = NSTextAlignmentLeft;
        leadTextLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:leadTextLab];
//        leadTextLab.text = @"小龙虾 等2件商品";
        self.goodLeadLbl = leadTextLab;
        
        
        UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-12, 40, SCREEN_WIDTH/2, 32)];
        moneyLbl.font = [UIFont systemFontOfSize:14];
        moneyLbl.textAlignment = NSTextAlignmentRight;
        moneyLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:moneyLbl];
        self.priceLbl = moneyLbl;
        
        //scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(96, 64, SCREEN_WIDTH/2, 56)];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
        
        
        //'删除'button
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/5-30, 127, SCREEN_WIDTH/5, 34)];
        deleteBtn.layer.cornerRadius = 18.0;
        deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        deleteBtn.layer.borderWidth = 1.0;
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        
        
        //'取消'button
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/5-20, 127, SCREEN_WIDTH/5, 34)];
        cancelBtn.layer.cornerRadius = 18.0;
        cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cancelBtn.layer.borderWidth = 1.0;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        
        
        //'去支付'button
        UIButton *toPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34)];
        toPayBtn.layer.cornerRadius = 18.0;
        toPayBtn.layer.borderColor = COLOR_E0212A.CGColor;
        toPayBtn.layer.borderWidth = 1.0;
        toPayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [toPayBtn setTitleColor:COLOR_E0212A forState:UIControlStateNormal];
        [toPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [toPayBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:toPayBtn];
        self.toPayBtn = toPayBtn;
        
        
        //'再来一单'button
        UIButton *againBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34)];
        againBtn.layer.cornerRadius = 18.0;
        againBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        againBtn.layer.borderWidth = 1.0;
        againBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [againBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [againBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [againBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:againBtn];
        self.againBtn = againBtn;
        
        
        //'退款'button
        UIButton *refundBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34)];
        refundBtn.layer.cornerRadius = 18.0;
        refundBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        refundBtn.layer.borderWidth = 1.0;
        refundBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [refundBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [refundBtn setTitle:@"退款" forState:UIControlStateNormal];
        [refundBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:refundBtn];
        self.refundBtn = refundBtn;
        
        
        //'去评价'button
        UIButton *appraiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34)];
        appraiseBtn.layer.cornerRadius = 18.0;
        appraiseBtn.layer.borderColor = COLOR_E0212A.CGColor;
        appraiseBtn.layer.borderWidth = 1.0;
        appraiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [appraiseBtn setTitleColor:COLOR_E0212A forState:UIControlStateNormal];
        [appraiseBtn setTitle:@"去评价" forState:UIControlStateNormal];
        [appraiseBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:appraiseBtn];
        self.appraiseBtn = appraiseBtn;
        
    }
    return self;
}
#pragma mark ------ 按钮点击事件 ------
- (void)cellBtnAction:(UIButton *)sender {
    self.BtnClickedBlock(sender.tag);
}
- (void)updateCellSubviewFrame:(NSString *)statue {
    NSLog(@"statue : %@", statue);
    if (statue.intValue == 0) {//待支付
        self.deleteBtn.hidden = YES;
        self.cancelBtn.frame  = CGRectMake(SCREEN_WIDTH*3/5-20, 127, SCREEN_WIDTH/5, 34);
        self.toPayBtn.frame   = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        self.againBtn.hidden  = YES;
        self.refundBtn.hidden = YES;
        self.appraiseBtn.hidden = YES;
        
    } else if (statue.intValue == 1) {//待接单(已支付)
        self.deleteBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.toPayBtn.hidden  = YES;
        self.againBtn.hidden  = YES;
        self.refundBtn.frame  = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        self.appraiseBtn.hidden = YES;
        
    } else if (statue.intValue == 2) {//待处理
        self.deleteBtn.hidden = YES;
        self.cancelBtn.frame  = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        self.toPayBtn.hidden  = YES;
        self.againBtn.hidden  = YES;
        self.refundBtn.hidden = YES;
        self.appraiseBtn.hidden = YES;
        
    } else if (statue.intValue == 3) { //配送中
        self.deleteBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.toPayBtn.hidden  = YES;
        self.againBtn.frame   = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        self.refundBtn.hidden = YES;
        self.appraiseBtn.hidden = YES;
    
    } else if (statue.intValue == 4) { //已完成
        self.deleteBtn.frame  = CGRectMake(SCREEN_WIDTH*2/5-30, 127, SCREEN_WIDTH/5, 34);
        self.cancelBtn.hidden = YES;
        self.toPayBtn.hidden  = YES;
        self.againBtn.frame   = CGRectMake(SCREEN_WIDTH*3/5-20, 127, SCREEN_WIDTH/5, 34);
        self.refundBtn.hidden = YES;
        self.appraiseBtn.frame = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        
    } else if (statue.intValue == 5) { //已取消
        self.deleteBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.toPayBtn.hidden  = YES;
        self.againBtn.frame   = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        self.refundBtn.hidden = YES;
        self.appraiseBtn.hidden = YES;
        
    } else if (statue.intValue == 6) { //已关闭
        self.deleteBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.toPayBtn.hidden  = YES;
        self.againBtn.hidden  = YES;
        self.refundBtn.hidden = YES;
        self.appraiseBtn.hidden = YES;
        
    } else if (statue.intValue == 7) { //退款申请中
        self.deleteBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.toPayBtn.hidden  = YES;
        self.againBtn.frame   = CGRectMake(SCREEN_WIDTH*4/5-10, 127, SCREEN_WIDTH/5, 34);
        self.refundBtn.hidden = YES;
        self.appraiseBtn.hidden = YES;
    }
}
- (void)createCellGoodLabel:(NSArray *)goods {
    self.scrollView.contentSize = CGSizeMake(0, goods.count*20.0);
    
    for (int i = 0 ; i < goods.count; i++) {
        UILabel *goodLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*i, SCREEN_WIDTH/2, 20)];
        goodLbl.font = [UIFont systemFontOfSize:13.5];
        goodLbl.textAlignment = NSTextAlignmentLeft;
        goodLbl.textColor = [UIColor lightGrayColor];
        [self.scrollView addSubview:goodLbl];
        
        NSDictionary *dict = goods[i];
        goodLbl.text = [NSString stringWithFormat:@"%@(%@) x%@", dict[@"goodsName"], dict[@"goodsProperty"], dict[@"goodsNum"]];
    }
}

@end
