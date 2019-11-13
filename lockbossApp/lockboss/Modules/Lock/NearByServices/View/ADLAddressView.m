//
//  ADLAddressView.m
//  lockboss
//
//  Created by bailun91 on 2019/10/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAddressView.h"
#import "ADLToast.h"
#import "ADLNetWorkManager.h"
#import "ADLUtils.h"
#import "ADLAlertView.h"

@interface ADLAddressView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSInteger   btnTag;

@end

@implementation ADLAddressView

-(void)dealloc {
    NSLog(@"ADLAddressView dealloc !!!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)finishedEditAddressAction:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    NSLog(@"地址信息: dict = %@", dict);
    if (self.btnTag%10000 == 101) { //添加地址
        [self.itemArray addObject:dict];
        [self.table reloadData];
        
    } else if (self.btnTag%10000 == 1) {
        NSInteger row = self.btnTag/10000;
        [self.itemArray replaceObjectAtIndex:row withObject:dict];
        
        //刷新cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedEditAddressAction:) name:@"FINISHED_EDIT_ADDRESS_NOTICATION" object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        [self addNotifications];
    }
    return self;
}

#pragma mark ------ 按钮点击事件 ------
- (void)addressViewBtnAction:(UIButton *)sender {
    self.btnTag = sender.tag;
    switch (sender.tag) {
        case 101:   //'添加'按钮
            if (self.itemArray.count >= 5) {
                [ADLToast showMessage:@"最多添加5个收货地址 !" duration:2.0];
            } else {
                self.addressViewBtnClickedBlock(sender.tag, @{});
            }
            break;
            
        case 102:   //'取消'按钮
            self.addressViewBtnClickedBlock(sender.tag, @{});
            break;
            
        default:
            if (sender.tag%10000 == 2) {    //删除地址
                [ADLAlertView showWithTitle:nil message:@"确定删除该地址吗?" confirmTitle:@"确定" confirmAction:^{
                    NSInteger row = sender.tag/10000;
                    [self deleteAddressData:row];
                    
                } cancleTitle:@"取消" cancleAction:nil showCancle:YES];
                
            } else {    //修改地址
                self.addressViewBtnClickedBlock(sender.tag, self.itemArray[self.btnTag/10000]);
            }
            break;
    }
}
- (void)setupSubviews {
    
    //title
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/2, 40)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:15];
    titLab.textColor = [UIColor blackColor];
    titLab.text = @"选择收货地址";
    [self addSubview:titLab];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4, 0, SCREEN_WIDTH/4, 40)];
    [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addBtn setImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addressViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = 101;
    [self addSubview:addBtn];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 38.8, SCREEN_WIDTH, 1.2)];
    line.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self addSubview:line];
    
    
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 300)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 60;
    [self addSubview:tableView];
    self.table = tableView;
    
    
    
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 340, SCREEN_WIDTH, 40+BOTTOM_H)];
    grayView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    [self addSubview:grayView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(addressViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 102;
    [grayView addSubview:cancelBtn];
}
#pragma mark --- 刷新view
- (void)updateViewInfos {
    [self.table reloadData];
}


#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (orderCell == nil) {
        orderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        while ([orderCell.contentView.subviews lastObject] != nil) {
            [(UIView*)[orderCell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    //自定义view
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH*2/3, 24)];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:14.5];
    titleLab.textColor = [UIColor darkGrayColor];
    [content addSubview:titleLab];
    
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH*2/3, 16)];
    infoLab.textAlignment = NSTextAlignmentLeft;
    infoLab.font = [UIFont systemFontOfSize:13];
    infoLab.textColor = [UIColor lightGrayColor];
    [content addSubview:infoLab];
    
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-95, 15, 32, 32)];
    [editBtn setImage:[UIImage imageNamed:@"icon_bianji"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(addressViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.tag = 1+indexPath.row*10000;
    [content addSubview:editBtn];
    
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 14, 35, 33)];
    [deleteBtn setImage:[UIImage imageNamed:@"icon_shanchu"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(addressViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.tag = 2+indexPath.row*10000;
    [content addSubview:deleteBtn];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 59.2, SCREEN_WIDTH-15, 0.8)];
    line.backgroundColor = SEPARATOR_COLOR;
    [content addSubview:line];
    
    
    //更新信息
    NSDictionary *dict = self.itemArray[indexPath.row];
    titleLab.text = [NSString stringWithFormat:@"%@%@", dict[@"area"], dict[@"address"]];
    if ([dict[@"sex"] intValue] == 2) {
        infoLab.text = [NSString stringWithFormat:@"%@ (先生)    %@", dict[@"consignee"], dict[@"phone"]];
    } else {
        infoLab.text = [NSString stringWithFormat:@"%@ (女士)    %@", dict[@"consignee"], dict[@"phone"]];
    }
    
    
    [orderCell.contentView addSubview:content];
    
    return orderCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.didSelectedRowBlock(self.itemArray[indexPath.row]);
}

#pragma mark ------ 删除地址 ------
- (void)deleteAddressData:(NSInteger)row {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[self.itemArray[row] objectForKey:@"id"] forKey:@"id"];
    
    
    __weak typeof(self)WeakSelf = self;
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/address/delete.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"删除收货地址返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [WeakSelf.itemArray removeObjectAtIndex:row];
            [WeakSelf.table reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FINISHED_ADD_OR_DELETE_ADDRESS_NOTICATION" object:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时!" duration:2.0];
        }
    }];
}

@end
