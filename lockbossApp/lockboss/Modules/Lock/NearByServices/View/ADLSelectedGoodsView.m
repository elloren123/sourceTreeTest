//
//  ADLSelectedGoodsView.m
//  lockboss
//
//  Created by bailun91 on 2019/9/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectedGoodsView.h"
#import "ADLSelectedGoodsCell.h"
#import "ADLDinnerModel.h"
#import "ADLGlobalDefine.h"
#import "ADLToast.h"

@interface ADLSelectedGoodsView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;

@end

@implementation ADLSelectedGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 40)];
    titLab.textAlignment = NSTextAlignmentLeft;
    titLab.font = [UIFont systemFontOfSize:14];
    titLab.textColor = [UIColor whiteColor];
    titLab.text = @"已选商品";
    [self addSubview:titLab];
    
    
    UIButton *cleanBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-66, 0, 66, 40)];
    cleanBtn.tag = 100;
    cleanBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cleanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cleanBtn setTitle:@"清空" forState:UIControlStateNormal];
    [cleanBtn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cleanBtn];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 180)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 45;
    [self addSubview:tableView];
    self.table = tableView;
}
#pragma mark ------ '清空' 按钮点击事件 ------
- (void)clickButtonAction:(UIButton *)sender {
    if (self.itemArray.count == 0) {
        [ADLToast showMessage:@"还未添加商品到购物车!"];
    } else {
        self.didCleanAllBlock(0);
    }
}

- (void)updateUI {
    NSLog(@"更新UI !!! itemCount: %d", (int)self.itemArray.count);
    [self.table reloadData];
}


#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSelectedGoodsCell *goodCell = [tableView dequeueReusableCellWithIdentifier:@"goodCell"];
    if (goodCell == nil) {
        goodCell = [[ADLSelectedGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodCell"];
        goodCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    goodCell.addButton.tag = 10000+indexPath.row;
    goodCell.deleteBtn.tag = 100+indexPath.row;
    
    //更新信息
    NSDictionary *model = self.itemArray[indexPath.row];
    goodCell.goodName.text = model[@"goodName"];
    goodCell.priceLbl.text = [NSString stringWithFormat:@"￥%.2f", [model[@"goodPrice"] floatValue]*[model[@"goodNumber"] integerValue]];
    goodCell.goodNum.text = model[@"goodNumber"];
    
    __weak typeof(self)WeakSelf = self;
    goodCell.addOrDleBtnClickedBlock = ^(NSInteger tag) {
//        NSLog(@"tag = %zd", tag);
        [WeakSelf reloadGoodsView:tag];
    };


    return goodCell;
}
- (void)reloadGoodsView:(NSInteger)index {
    if (index/10000 > 0) {  //添加商品
        NSInteger row = index%10000;
        NSMutableDictionary *model = [NSMutableDictionary dictionaryWithDictionary:self.itemArray[row]];
//        NSString *number = model[@"goodNumber"];
//        number = [NSString stringWithFormat:@"%zd", number.integerValue+1];
//        [model setObject:number forKey:@"goodNumber"];
//        [self.itemArray replaceObjectAtIndex:row withObject:model];
//
//        //刷新cell
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//        [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        
        self.goodNumChangedBlock(model[@"goodName"], YES);
    
    } else {  //删除商品
        NSInteger row = index%100;
        NSMutableDictionary *model = [NSMutableDictionary dictionaryWithDictionary:self.itemArray[row]];
//        NSString *number = model[@"goodNumber"];
//        if (number.integerValue == 1) {
//            [self.itemArray removeObjectAtIndex:row];
//            [self.table reloadData];
//
//        } else {
//            number = [NSString stringWithFormat:@"%zd", number.integerValue-1];
//            [model setObject:number forKey:@"goodNumber"];
//            [self.itemArray replaceObjectAtIndex:row withObject:model];
//
//            //刷新cell
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//            [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
//        }
        
        self.goodNumChangedBlock(model[@"goodName"], NO);
    }
}

- (void)updateTableView:(NSInteger)row flag:(BOOL)flag {
    
}

@end
