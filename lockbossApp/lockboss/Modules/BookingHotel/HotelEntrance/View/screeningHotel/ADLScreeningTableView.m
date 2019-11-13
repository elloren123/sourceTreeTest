//
//  ADLScreeningTableView.m
//  lockboss
//
//  Created by adel on 2019/9/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLScreeningTableView.h"
#import "ADLScreeningableViewCell.h"
#import "ADLUtils.h"
#import "ADLLocationManager.h"
#import "ADLUserModel.h"
@interface ADLScreeningTableView ()<UITableViewDelegate,UITableViewDataSource,ADLLocationManagerDelegate>

@property (nonatomic ,strong)UIView *headView;



@property (nonatomic ,weak) UIButton *inlandBtn;
@property (nonatomic ,weak) UIButton *foreignBtn;
@property (nonatomic ,weak) UIView *lineView1;
@property (nonatomic ,weak) UIView *lineView2;

@property (nonatomic ,strong)ADLLocationManager *locationManager;
@end


@implementation ADLScreeningTableView

- (instancetype)initWithFrame:(CGRect)frame
{
self = [super initWithFrame:frame];
if (self) {
    [self datestr:1];
    [self addSubview:self.tableView];
 //   self.tableView.tableHeaderView = self.headView;
    
    ADLUserModel *model = [ADLUserModel readUserModel];
    if (model.city.length > 0) {
        self.contArray[0] = model.city;
    }else {
        [self autoLocate];
    }

}
return self;
}
-(UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
        _headView.backgroundColor = [UIColor whiteColor];
        UIButton *inlandBtn = [self createButtonFrame:CGRectMake(0, 10, self.width/2, 30) imageName:nil title:ADLString(@"国内酒店") titleColor:COLOR_333333 font:16 target:self action:@selector(inlandBtn:)];
           inlandBtn.tag = 1;
        inlandBtn.selected = YES;
        UIView *lineView1 =[[UIView alloc]init];
        lineView1.width =60;
        lineView1.centerX =inlandBtn.centerX;
        lineView1.y = CGRectGetMaxY(inlandBtn.frame)+2;
        lineView1.height  = 3;
        lineView1.backgroundColor = [UIColor redColor];
        [_headView addSubview:lineView1];
        [_headView addSubview:inlandBtn];
        self.inlandBtn = inlandBtn;
          self.lineView1 = lineView1;
        UIButton *foreignBtn = [self createButtonFrame:CGRectMake(self.width/2, 10,self.width/2, 30) imageName:nil title:ADLString(@"国外酒店") titleColor:COLOR_333333 font:16 target:self action:@selector(inlandBtn:)];
        foreignBtn.tag = 2;
        UIView *lineView2 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        lineView2.width =60;
        lineView2.centerX =foreignBtn.centerX;
        lineView2.y = CGRectGetMaxY(foreignBtn.frame)+2;
        lineView2.height  = 3;
        lineView2.backgroundColor = COLOR_F7F7F7;
        [_headView addSubview:lineView2];
        [_headView addSubview:foreignBtn];
        self.foreignBtn.selected = NO;
        self.foreignBtn = foreignBtn;
        self.lineView2 = lineView2;

  
       
    }
    return _headView;
}

-(void)inlandBtn:(UIButton *)btn {
    
    if (btn.tag == 1) {
      //  self.inlandBtn = btn;
        self.lineView1.backgroundColor = [UIColor redColor];
        self.lineView2.backgroundColor = COLOR_F7F7F7;
        self.inlandBtn.selected = NO;
        self.foreignBtn.selected = YES;
    }
    if (btn.tag == 2) {
      ///  self.foreignBtn = btn;
        self.lineView2.backgroundColor = [UIColor redColor];
        self.lineView1.backgroundColor = COLOR_F7F7F7;
        self.inlandBtn.selected = NO;
        self.foreignBtn.selected = YES;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLScreeningableViewCell *cell = [ADLScreeningableViewCell cellWithTableView:tableView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell titlestr:self.titleArray[indexPath.row] content:self.contArray[indexPath.row]];
    if (indexPath.row == 0) {
    [cell.locationBtn setImage:[UIImage imageNamed:@"dizhi"] forState:UIControlStateNormal];
    cell.changedaddbtnBack = ^{
        [self autoLocate];
    };
    }else {
    [cell.locationBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    if (indexPath.row == 1) {
        cell.startTime.hidden = NO;
        cell.endTime.hidden = NO;
        if (self.startTime.length > 0) {
           cell.startTime.text = self.self.startTime;
        }
        if (self.endTime.length > 0) {
        cell.endTime.text = self.endTime;
        }
     
     
    }else {
      cell.startTime.hidden = YES;
      cell.endTime.hidden = YES;
    }
 
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
    return  60;
    }else {
    return  44;
    }
 
}
//自动定位
-(void)autoLocate{
    self.locationManager = [ADLLocationManager sharedInstance];
    self.locationManager.delegate = self;
    [self.locationManager autoLocate];
}

#pragma mark - LocationManagerDelegate
-(void)locationManager:(ADLLocationManager *)locationManager didGotLocation:(NSString *)location{
    //    self.conditionView.cityName = location;
    //    self.city = location;
    //    [self preData];
    self.contArray[0] = location;
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(screeningTableView:didSelectRowAtIndexPath:)]) {
      [self.delegate screeningTableView:self didSelectRowAtIndexPath:indexPath];
    }
    
   
}
-(NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithArray:@[ADLString(@"城市"),[ADLUtils getCurrentTime:@"EEEE"],ADLString(@"房价/星级")]];
    }
    return _titleArray;
}
-(NSMutableArray *)contArray {
    if (!_contArray) {
        _contArray = [NSMutableArray arrayWithArray:@[@"北京市",[ADLUtils getCurrentTime:@"EEEE"],ADLString(@"¥0-¥2000")]];
    }
    return _contArray;
}
//1天  --  7天
-(void)datestr:(NSInteger)date {
    NSInteger dis = date; //前后的天数
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEEE"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    
    self.titleArray[1] = currentString;
    
    NSDate* theDate;
    
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        
        theDate = [currentDate initWithTimeIntervalSinceNow: +oneDay*dis ];
        //or
        // theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
    }
    else
    {
        theDate = currentDate;
    }
    //yyyy-MM-dd hh:mm:ss
    NSDateFormatter *theDateformatter = [[NSDateFormatter alloc] init];
    [theDateformatter setDateFormat:@"EEEE"];
    NSString *string=[theDateformatter stringFromDate:theDate];
    
    self.contArray[1] = string;
    
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.width, self.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        // _tableView.alpha = 0.7;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.width,120)];
        footerView.backgroundColor  = [UIColor whiteColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:ADLString(@"开始搜索") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0,20, self.width, 45);
        btn.backgroundColor  = [UIColor redColor];
        btn.layer.masksToBounds = YES;
           btn.tag = 0;
//        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        [footerView addSubview:btn];
        
        UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recordBtn.frame = CGRectMake(0, CGRectGetMaxY(btn.frame)+15, self.width/2, 25);
        [recordBtn setTitle:ADLString(@"浏览记录/收藏夹") forState:UIControlStateNormal];
        [recordBtn setImage:[UIImage imageNamed:@"icon_shoucangj"] forState:UIControlStateNormal];
        recordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        recordBtn.tag = 1;
        recordBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [recordBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
         [recordBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [footerView addSubview:recordBtn];
        
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(CGRectGetMaxX(recordBtn.frame)+10, recordBtn.y, self.width/2, 25);
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        orderBtn.tag = 2;
         [orderBtn setImage:[UIImage imageNamed:@"icon_dingdan"] forState:UIControlStateNormal];
        [orderBtn setTitle:ADLString(@"我的订单") forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [orderBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [footerView addSubview:orderBtn];
          orderBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        _tableView.tableFooterView = footerView;
     
    }
    return _tableView;
}
-(void)clickBtn:(UIButton *)btn {
    if (self.blockBtn) {
        self.blockBtn(btn);
    }
 
}


@end
