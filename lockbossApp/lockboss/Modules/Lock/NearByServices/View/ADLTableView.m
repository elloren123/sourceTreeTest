//
//  ADLTableView.m
//  lockboss
//
//  Created by bailun91 on 2019/9/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTableView.h"
#import "ADLOrderDinnerCell.h"
#import "ADLRefreshHeader.h"
#import "ADLRefreshFooter.h"
#import "ADLGlobalDefine.h"

#import <UIImageView+WebCache.h>

@interface ADLTableView () 

@property (nonatomic, strong) UIButton *titleBtn1;  //全部美食btn
@property (nonatomic, strong) UIButton *titleBtn2;  //距离btn
@property (nonatomic, strong) UIButton *titleBtn3;  //评价btn
@property (nonatomic, strong) UIButton *titleBtn4;  //人气btn
@property (nonatomic, assign) int      btnTag;

@end

@implementation ADLTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {

    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor blackColor];
    titLab.text = @"附近商家";
    [self addSubview:titLab];
    
    for (int i = 0 ; i < 2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39+i*30, self.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        [self addSubview:line];
    }
    
    for (int i = 1 ; i < 4; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*i/4, 41.5, 1, 26)];
        line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        [self addSubview:line];
    }
    
    self.btnTag = 0;
    NSArray *titleArr = @[@"全部", @"距离", @"评价", @"人气"];
    for (int i = 0 ; i < 4; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*(i)/4, 40, self.frame.size.width/4, 30)];
        button.tag = 100+i;
        button.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:224/255.0 green:33/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
            self.titleBtn1 = button;
            
        } else if (i == 1) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.titleBtn2 = button;
            
        } else if (i == 2) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.titleBtn3 = button;
            
        } else if (i == 3) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.titleBtn4 = button;
        }
    }
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height-70)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 100;
    [self addSubview:tableView];
    self.table = tableView;
    
    
    __weak typeof(self)WeakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        //下拉刷新
        WeakSelf.tableViewHeaderRefreshBlock();
    }];
    
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        WeakSelf.scrollToBottom();
    }];
    tableView.mj_footer.hidden = YES;
}
#pragma mark ------ 按钮点击事件 ------
- (void)clickButtonAction:(UIButton *)sender {
    self.btnTag = (int)sender.tag - 100;
    [self updateUIWith:self.btnTag];
    self.didClickbtnBlock(self.btnTag);
}
- (void)updateUIWith:(int)tag {
    switch (tag) {
        case 0:
            [self.titleBtn1 setTitleColor:[UIColor colorWithRed:224/255.0 green:33/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
            [self.titleBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleBtn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 1:
            [self.titleBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleBtn2 setTitleColor:[UIColor colorWithRed:224/255.0 green:33/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
            [self.titleBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleBtn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 2:
            [self.titleBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleBtn3 setTitleColor:[UIColor colorWithRed:224/255.0 green:33/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
            [self.titleBtn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 3:
            [self.titleBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleBtn4 setTitleColor:[UIColor colorWithRed:224/255.0 green:33/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}


#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLOrderDinnerCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if (orderCell == nil) {
        orderCell = [[ADLOrderDinnerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = self.itemArray[indexPath.row];
    NSLog(@"商家信息table: dict = %@", dict);
    [orderCell.iconImg sd_setImageWithURL:[NSURL URLWithString:[dict[@"storeLogo"] stringValue]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
    orderCell.shopName.text = dict[@"name"];
    orderCell.renQiLbl.text = [NSString stringWithFormat:@"人气:%@", dict[@"popularity"]];
    orderCell.juLiLbl.text = [NSString stringWithFormat:@"%zd分钟 | %.1fkm", [dict[@"drivingTime"] integerValue]/60+1, [dict[@"distance"] floatValue]/1000.0];
    orderCell.workLbl.text = [NSString stringWithFormat:@"营业时间:\n\n%@", dict[@"businessTime"]];

    if ([dict[@"score"] floatValue] > 8) {
        orderCell.starImg1.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg2.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg3.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg4.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg5.image = [UIImage imageNamed:@"icon_xing"];
    } else if ([dict[@"score"] floatValue] > 6) {
        orderCell.starImg1.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg2.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg3.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg4.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg5.image = [UIImage imageNamed:@"icon_xing1"];
    } else if ([dict[@"score"] floatValue] > 4) {
        orderCell.starImg1.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg2.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg3.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg4.image = [UIImage imageNamed:@"icon_xing1"];
        orderCell.starImg5.image = [UIImage imageNamed:@"icon_xing1"];
    } else if ([dict[@"score"] floatValue] > 2) {
        orderCell.starImg1.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg2.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg3.image = [UIImage imageNamed:@"icon_xing1"];
        orderCell.starImg4.image = [UIImage imageNamed:@"icon_xing1"];
        orderCell.starImg5.image = [UIImage imageNamed:@"icon_xing1"];
    } else {
        orderCell.starImg1.image = [UIImage imageNamed:@"icon_xing"];
        orderCell.starImg2.image = [UIImage imageNamed:@"icon_xing1"];
        orderCell.starImg3.image = [UIImage imageNamed:@"icon_xing1"];
        orderCell.starImg4.image = [UIImage imageNamed:@"icon_xing1"];
        orderCell.starImg5.image = [UIImage imageNamed:@"icon_xing1"];
    }

    return orderCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.didSelectedRow(indexPath.row);
}

#pragma mark ------ 刷新数据 ------
- (void)updateViewInfos {
    [self.table reloadData];
}

@end
