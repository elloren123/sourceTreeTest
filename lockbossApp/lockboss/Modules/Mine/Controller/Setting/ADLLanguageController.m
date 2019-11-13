//
//  ADLLanguageController.m
//  lockboss
//
//  Created by adel on 2019/4/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLanguageController.h"

@interface ADLLanguageController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *pullView;
@property (nonatomic, strong) UILabel *languageLab;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLLanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"切换语言"];
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+20, SCREEN_WIDTH-24, ROW_HEIGHT)];
    borderView.backgroundColor = [UIColor whiteColor];
    borderView.layer.cornerRadius = CORNER_RADIUS;
    borderView.layer.borderWidth = 0.5;
    borderView.layer.borderColor = COLOR_D3D3D3.CGColor;
    [self.view addSubview:borderView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBorderView)];
    [borderView addGestureRecognizer:tap];
    
    UILabel *languageLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, ROW_HEIGHT)];
    languageLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    languageLab.textColor = COLOR_333333;
    languageLab.text = @"中文";
    [borderView addSubview:languageLab];
    self.languageLab = languageLab;
    
    UIImageView *pullView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, ROW_HEIGHT/2-4, 14, 8)];
    pullView.image = [UIImage imageNamed:@"pull_down"];
    [borderView addSubview:pullView];
    self.pullView = pullView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+ROW_HEIGHT+28, SCREEN_WIDTH-24, ROW_HEIGHT)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = ROW_HEIGHT;
    tableView.tableFooterView = [UIView new];
    tableView.alpha = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)clickBorderView {
    if (self.tableView.alpha == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 1;
            self.pullView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 0;
            self.pullView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        cell.textLabel.textColor = COLOR_333333;
    }
    cell.textLabel.text = @"中文";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.3 animations:^{
        tableView.alpha = 0;
        self.pullView.transform = CGAffineTransformIdentity;
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
