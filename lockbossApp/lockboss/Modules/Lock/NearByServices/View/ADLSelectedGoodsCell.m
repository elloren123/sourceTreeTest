//
//  ADLSelectedGoodsCell.m
//  lockboss
//
//  Created by bailun91 on 2019/9/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectedGoodsCell.h"

@implementation ADLSelectedGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *goodName = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, SCREEN_WIDTH/2, 44)];
        goodName.font = [UIFont systemFontOfSize:15];
        goodName.textAlignment = NSTextAlignmentLeft;
        goodName.textColor = [UIColor blackColor];
        [self.contentView addSubview:goodName];
        goodName.text = @"牛肉水饺";
        self.goodName = goodName;
        
        
        UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, 0, SCREEN_WIDTH/4, 44)];
        moneyLbl.font = [UIFont systemFontOfSize:15];
        moneyLbl.textAlignment = NSTextAlignmentLeft;
        moneyLbl.textColor = COLOR_E0212A;
        [self.contentView addSubview:moneyLbl];
        moneyLbl.text = @"￥0";
        self.priceLbl = moneyLbl;
        
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44, 10, 24, 24)];
        [addButton setImage:[UIImage imageNamed:@"icon_jiahao"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addButton];
        self.addButton = addButton;
        
        
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-74, 10, 30, 24)];
        number.font = [UIFont systemFontOfSize:15];
        number.textAlignment = NSTextAlignmentCenter;
        number.textColor = [UIColor blackColor];
        [self.contentView addSubview:number];
        number.text = @"0";
        self.goodNum = number;
        
        
        UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-98, 10, 24, 24)];
        [delButton setImage:[UIImage imageNamed:@"icon_jianhao"] forState:UIControlStateNormal];
        [delButton addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delButton];
        self.deleteBtn = delButton;
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)cellBtnAction:(UIButton *)sender {
    NSLog(@"cellBtn: %zd", sender.tag);
    
    self.addOrDleBtnClickedBlock(sender.tag);
}

@end
