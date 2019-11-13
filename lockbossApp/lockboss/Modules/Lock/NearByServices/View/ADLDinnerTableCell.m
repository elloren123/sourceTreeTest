//
//  ADLDinnerTableCell.m
//  lockboss
//
//  Created by bailun91 on 2019/9/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDinnerTableCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLDinnerTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 64, 64)];
        [self.contentView addSubview:iconImg];
        self.dinnerImg = iconImg;
        
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(84, 3, SCREEN_WIDTH/2, 20)];
        name.font = [UIFont systemFontOfSize:FONT_SIZE];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor blackColor];
        [self.contentView addSubview:name];
        self.dinnerName = name;
        
        
        UILabel *soldLbl = [[UILabel alloc] initWithFrame:CGRectMake(84, 28, SCREEN_WIDTH/2, 15)];
        soldLbl.font = [UIFont systemFontOfSize:12];
        soldLbl.textAlignment = NSTextAlignmentLeft;
        soldLbl.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:soldLbl];
        soldLbl.text = @"月售:199份";
        self.soldLbl = soldLbl;
        
        
        UILabel *leadLbl = [[UILabel alloc] initWithFrame:CGRectMake(84, 50, SCREEN_WIDTH/2, 15)];
        leadLbl.font = [UIFont systemFontOfSize:12];
        leadLbl.textAlignment = NSTextAlignmentLeft;
        leadLbl.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:leadLbl];
        leadLbl.text = @"每100克含蛋白质20克";
        self.leadLbl = leadLbl;
        
        
        UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-15, 3, SCREEN_WIDTH/4+10, 20)];
        priceLbl.font = [UIFont systemFontOfSize:13.5];
        priceLbl.textAlignment = NSTextAlignmentRight;
        priceLbl.textColor = COLOR_E0212A;
        [self.contentView addSubview:priceLbl];
        priceLbl.text = @"￥30元/份";
        self.priceLbl = priceLbl;
        
        
        //"+"按钮
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4-29, 28, 20, 20)];
        [addBtn setImage:[UIImage imageNamed:@"icon_jiahao"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addBtn];
        self.addButton = addBtn;
        
        
        UILabel *numberLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4-57, 28, 28, 20)];
        numberLbl.font = [UIFont systemFontOfSize:12];
        numberLbl.textAlignment = NSTextAlignmentCenter;
        numberLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:numberLbl];
        numberLbl.text = @"999";
        self.dinnerNum = numberLbl;
        
        
        //"-"按钮
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4-77, 28, 20, 20)];
        [deleteBtn setImage:[UIImage imageNamed:@"icon_jianhao"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
    }
    return self;
}
- (void)clickAddBtn:(UIButton *)sender {
//    NSLog(@"sender.tag = %zd", sender.tag);
    
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_OR_DELETE_ITEM_NOTICATION" object:nil userInfo:@{@"Tag":[NSNumber numberWithInteger:sender.tag], @"Flag":@"YES"}];
}
- (void)clickDeleteBtn:(UIButton *)sender {
    //    NSLog(@"sender.tag = %zd", sender.tag);
    
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_OR_DELETE_ITEM_NOTICATION" object:nil userInfo:@{@"Tag":[NSNumber numberWithInteger:sender.tag], @"Flag":@"NO"}];
}

@end
