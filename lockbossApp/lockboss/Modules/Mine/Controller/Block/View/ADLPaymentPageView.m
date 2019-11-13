//
//  ADLPaymentPageView.m
//  lockboss
//
//  Created by adel on 2019/11/6.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLPaymentPageView.h"
#import "ADLHotelOrderPayCell.h"


@interface ADLPaymentPageView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak)UIVisualEffectView * effe;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic ,strong)NSArray *titleArray;

@end

@implementation ADLPaymentPageView

-(NSArray *)imageArray {
    
    if (!_imageArray) {
        _imageArray = @[@"icon_pay_zfb",@"icon_pay_weixin"];
    }
    return _imageArray;
}
-(NSArray *)titleArray {
    
    if (!_titleArray) {
        
        _titleArray = @[@"支付宝",@"微信"];
    }
    return _titleArray;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.7;
        //  backView.frame = CGRectMake(18, lognViewY, screenWidth-36, 300, 300);
        //backView.backgroundColor = [UIColor blackColor];
        //backView.hidden = YES;
        [self addSubview:backView];
        self.backView = backView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [backView addGestureRecognizer:tap];
        
        UIView *titleView = [[UIView alloc] init];
        titleView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2+50);
        titleView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:titleView];
        self.titleView = titleView;
        
        UILabel *titleLock = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, SCREEN_WIDTH - 160, 30)];
        titleLock.textAlignment = NSTextAlignmentCenter;
        titleLock.font = [UIFont systemFontOfSize:14];
        titleLock.textColor = COLOR_333333;
        titleLock.text = ADLString(@"选择支付方式");
        [self.titleView addSubview:titleLock];
        
        UIButton *btn = [self createButtonFrame:CGRectMake(SCREEN_WIDTH - 40, 5, 30, 30) imageName:nil title:nil titleColor:nil font:nil target:self action:@selector(btnout)];
        [btn setImage:[UIImage imageNamed:@"icon_switck_lock_out"] forState:UIControlStateNormal];
        
        //UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 34, 10, 24, 24)];
        //icon.contentMode = UIViewContentModeScaleAspectFit;
        //icon.image = [UIImage imageNamed:@"icon_switck_lock_out"];
        [self.titleView addSubview:btn];
        
        UITableView *tableView = [[UITableView alloc]init];
        tableView.frame  = CGRectMake(0,40, SCREEN_WIDTH,SCREEN_HEIGHT/2);
        // tableView.backgroundColor = Coloreeeeee;
        // tableView.backgroundColor = [UIColor whiteColor];
        tableView.alpha = 0.98;
        // tableView.bounces = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.tableFooterView = [UIView new];
        [self.titleView addSubview:tableView];
        self.tableView = tableView;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.titleView.frame = CGRectMake(0,SCREEN_HEIGHT/2 - 40, SCREEN_WIDTH,SCREEN_HEIGHT/2+40);
            //  self.tableView.frame  =  CGRectMake(0,50, screenWidth,screenHeight/2);
            
        } completion:nil];
        
    }
    return self;
}

-(void)btnout {
    [self remove];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ADLHotelOrderPayCell *cell = [ADLHotelOrderPayCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.iconImage.image = [UIImage imageNamed:@"icon_pay_weixin"];
        cell.name.text = ADLString(@"微信支付");
        cell.title.text = ADLString(@"推荐微信用户使用");
    }else  if(indexPath.row == 1) {
        cell.iconImage.image = [UIImage imageNamed:@"icon_pay_zfb"];
        cell.name.text = ADLString(@"支付宝支付");
        cell.title.text = ADLString(@"推荐支付宝用户使用");
    }
    return cell;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.devictBlock) {
        self.devictBlock(indexPath.row);
    }
    [self remove];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([touches.anyObject.view isKindOfClass:[self class]]) {
        
        [self remove];
        
    }
}

- (void)remove
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.titleView.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH,0);
        //self.tableView.frame  = CGRectMake(0,screenHeight, screenWidth, 0);
        //_backView.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
