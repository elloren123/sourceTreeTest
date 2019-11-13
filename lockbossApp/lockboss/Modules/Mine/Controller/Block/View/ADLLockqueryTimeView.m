//
//  ADLLockqueryTimeView.m
//  ADEL-APP
//
//  Created by adel on 2019/8/28.
//

#import "ADLLockqueryTimeView.h"
@interface ADLLockqueryTimeView ()

@property (nonatomic ,strong)UIButton * okBtn;

@property (nonatomic ,strong)UIView * subView;
@end


@implementation ADLLockqueryTimeView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addsubView];
        [self addSubview:self.okBtn];
        [self addSubview:self.subView];
        
    }
    return self;
}
-(void)addsubView
{
    UILabel *title = [self createLabelFrame:CGRectMake(20, 10, 100, 18) font:14 text:ADLString(@"查询权限") texeColor:COLOR_333333];
    [self addSubview:title];
    
    int width =SCREEN_WIDTH / 2;//格子的宽
    
    int height = 30;//格子的高
    UIButton *btn;
    for (int i= 0;i<4;i++) {
        btn = [self createButtonFrame:CGRectMake(80, 40+i*(height+5),width, height) imageName:nil title:nil titleColor:COLOR_E0212A font:12 target:self action:@selector(messageBtn:)];
        
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
          btn.tag = i;
            [self addSubview:btn];
        if (i > 1) {
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = COLOR_CCCCCC.CGColor;
            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 2;
        }else {
        [btn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            btn.frame =CGRectMake(80, 40+i*(20)+5,width, 15);
            btn.enabled = NO;
        }
        
        if (i==0) {
            UILabel *title = [self createLabelFrame:CGRectMake(12, 40+i*(height+5),60, height) font:12 text:ADLString(@"权限时间:") texeColor:COLOR_333333];
            [self addSubview:title];
            self.starttime = btn;
           // title.backgroundColor = [UIColor redColor];
    
        }
        if (i==1) {
           self.endtime = btn;
        }
        if (i==2) {
            UILabel *title = [self createLabelFrame:CGRectMake(12, 40+i*(height+5),60, height) font:12 text:ADLString(@"查询时间:") texeColor:COLOR_333333];
            [self addSubview:title];
            UILabel * least= [self createLabelFrame:CGRectMake(CGRectGetMaxX(btn.frame)+5, 40+i*(height+5),50, height) font:12 text:ADLString(@"至") texeColor:COLOR_333333];
            [self addSubview:least];
            
            self.startBtn = btn;
            [self.startBtn setTitle:nil forState:UIControlStateNormal];
        }
        
        if (i==3) {
            UILabel *title = [self createLabelFrame:CGRectMake(CGRectGetMaxX(btn.frame)+5, 40+i*(height+5),80, height) font:12 text:ADLString(@"*必填") texeColor:COLOR_E0212A];
            [self addSubview:title];
            
              self.endBtn = btn;
               [self.endBtn setTitle:nil forState:UIControlStateNormal];
        }
    }
    //NSInteger date = [self starTime:self.starttime.titleLabel.text endTime:self.endtime.titleLabel.text];
    
    UILabel *remaining = [self createLabelFrame:CGRectMake(20, CGRectGetMaxY(btn.frame)+30,self.width - 40, 12) font:10 text:nil texeColor:COLOR_333333];
    remaining.textAlignment = NSTextAlignmentCenter;
    [self addSubview:remaining];
    self.remaining =remaining;
    
}


-(UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [self createButtonFrame:CGRectMake(20,CGRectGetMaxY(self.remaining.frame)+10, self.width - 40, 45) imageName:@"" title:ADLString(@"查询") titleColor:[UIColor whiteColor] font:12 target:self action:@selector(messageBtn:)];
           _okBtn.tag = 5;
        _okBtn.backgroundColor =COLOR_E0212A;
        _okBtn.layer.masksToBounds = YES;
        //        _okBtn.layer.borderColor = Colorad2f2d.CGColor;
        //        _okBtn.layer.borderWidth = 1;
        _okBtn.layer.cornerRadius = 5;
    }
    return _okBtn;
}
-(void)messageBtn:(UIButton *)btn {
    if (self.blockTime) {
        self.blockTime(btn);
    }
}
-(UIView *)subView {
    if (!_subView) {
        _subView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.okBtn.frame)+10, self.width, 80)];
        
        UILabel *title = [self createLabelFrame:CGRectMake(0, 10,_subView.width, 18)  font:16 text:ADLString(@"区块链应用说明") texeColor:COLOR_333333];
        title.textAlignment = NSTextAlignmentCenter;
        [_subView addSubview:title];
        
        UILabel *cont = [self createLabelFrame:CGRectMake(20,title.y+20,_subView.width-40, 60) font: 8 text:ADLString(@"10 袁") texeColor:COLOR_666666];
        cont.text = @"    锁老大产品采用区块链账本写入门锁信息,区块链是去中心化,分布式加密账本,应用其写入的历史信息不可篡改的特性,并实时公布信息加密s后的特征码给用户,广大用户都可以通过特征码j验证账本的历史数据的正确性,极大的提升锁老大产品的数据信息的可靠性和可信度";
        cont.numberOfLines = 0;
        [_subView addSubview:cont];
        
    }
    return _subView;
}

@end
