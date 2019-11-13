//
//  ADLGatewayHelpController.m
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLGatewayHelpController.h"


@interface ADLGatewayHelpCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UIView *lineView;//分割线
@property (nonatomic ,strong) UIImageView *rigimgView;

@end

@implementation ADLGatewayHelpCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ADLGatewayHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADLGatewayHelpCellIdentifier"];
    if (cell == nil) {
        cell = [[ADLGatewayHelpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ADLGatewayHelpCellIdentifier"];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubVeiws];
    }
    return self;
    
}

-(void)setSubVeiws {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nameLab];
    [self addSubview:self.lineView];
    [self addSubview:self.rigimgView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
   
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.rigimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-18);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(16);
    }];
}

#pragma mark ------ 懒加载 ------
-(UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.font = [UIFont boldSystemFontOfSize:14];
        _nameLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    return _nameLab;
}
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    }
    return _lineView;
}

-(UIImageView *)rigimgView {
    if (!_rigimgView) {
        _rigimgView = [[UIImageView alloc] init];
        _rigimgView.image = [UIImage imageNamed:@"icon_xiao"];
    }
    return _rigimgView;
}


@end



@interface ADLGatewayHelpController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ADLGatewayHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addRedNavigationView:@"使用帮助"];
    self.dataArr = [@[@"常见问题",
                     @"推送提醒太频繁,怎么设置勿扰模式?",
                     @"门锁回复出厂设置后无法使用?",
                     @"如何进行固件升级?",
                     @"在进行固件升级时进度条卡住怎么办?"
                     ] mutableCopy];
    [self.view addSubview:self.tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLGatewayHelpCell *cell = [ADLGatewayHelpCell cellWithTableView:tableView];
    cell.nameLab.text = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H-BOTTOM_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView.hidden = YES;
        //_tableView.rowHeight = 105;
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        
    }
    return  _tableView ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [ADLToast showMessage:@"功能完善中,敬请期待!"];
}

@end
