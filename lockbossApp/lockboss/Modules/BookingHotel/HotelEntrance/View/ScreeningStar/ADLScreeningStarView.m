//
//  ADLScreeningStarView.m
//  lockboss
//
//  Created by adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLScreeningStarView.h"
#import "DoubleSlider.h"

@interface ADLScreeningStarView ()
@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UIView *subView;
@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UILabel *rightLabel;
@property (nonatomic ,strong)NSArray *array;
@property (nonatomic ,strong)UIButton *resetBtn;
@property (nonatomic ,strong)UIButton *completeBtn;

@property (nonatomic ,strong)UIButton *starBtn;
@property (nonatomic ,strong)UIButton *limitBtn;
@property(nonatomic,weak)DoubleSliderConfig *config;
@property(nonatomic,weak)DoubleSlider *slider;

@end

@implementation ADLScreeningStarView

- (instancetype)initWithFrame:(CGRect)frame
{
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
        _backView = backView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [backView addGestureRecognizer:tap];
        
        UIView *subView = [[UIView alloc] init];
        subView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        subView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:subView];
        self.subView = subView;
        // 通过动画设置
        [UIView animateWithDuration:0.25 animations:^{
     
           self.subView.frame  = CGRectMake(0,SCREEN_HEIGHT-400, SCREEN_WIDTH,400);
            
        } completion:nil];
        UILabel *title = [self createLabelFrame:CGRectMake(30, 20, SCREEN_WIDTH - 100, 20) font:16 text:ADLString(@"房价") texeColor:COLOR_333333];
        [self.subView addSubview:title];
        DoubleSlider *slider = [[DoubleSlider alloc]initWithFrame:CGRectMake(30, 80, SCREEN_WIDTH - 60, 50)];
        self.slider = slider;
        DoubleSliderConfig *config = [[DoubleSliderConfig alloc]init];
        self.config = config;
        config.minValue = 0;
        config.maxValue = 2000;
        config.defaultLeftValue = 2000;
       // config.defaultRightValue = 1000;
        slider.config = config;
        [self.subView addSubview:slider];
        __weak __typeof(&*self)weakSelf = self;
        slider.panResponse = ^(CGFloat leftValue, CGFloat rightValue, CGPoint leftCenter, CGPoint rightCenter) {
            NSLog(@"currentValue -- %lf---%lf --%lf--%lf",leftValue,rightValue,leftCenter.x,rightCenter.x);
            weakSelf.leftLabel.centerX = 30 + leftCenter.x;
            weakSelf.leftLabel.text = [NSString stringWithFormat:@"¥%.0f",leftValue];
            weakSelf.rightLabel.centerX = 30 + rightCenter.x;
            weakSelf.rightLabel.text = [NSString stringWithFormat:@"¥%.0f",rightValue];
        };
        
        self.leftLabel = [[UILabel alloc]init];
        self.leftLabel.font = [UIFont systemFontOfSize:14];
        self.leftLabel.text = @"¥0";
        self.leftLabel.textColor = COLOR_E0212A;
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        [self.subView addSubview:self.leftLabel];
        self.leftLabel.size = CGSizeMake(70, 20);
        self.leftLabel.centerY = slider.y-self.leftLabel.height/2;
        self.leftLabel.centerX = 30+(config.defaultRightValue-config.minValue)/(config.maxValue-config.minValue)*slider.width;
        
        self.rightLabel = [[UILabel alloc]init];
         self.rightLabel.textColor = COLOR_E0212A;
        self.rightLabel.font = [UIFont systemFontOfSize:14];
        self.rightLabel.text = @"¥2000";
        self.rightLabel.textAlignment = NSTextAlignmentCenter;
        [self.subView addSubview:self.rightLabel];
        self.rightLabel.size = CGSizeMake(70, 20);
        self.rightLabel.centerY = slider.y-self.rightLabel.height/2;
        self.rightLabel.centerX = 20 + (config.defaultLeftValue-config.minValue)/(config.maxValue-config.minValue)*slider.width;
        [self addsubView];
        
        [self.subView addSubview:self.resetBtn];
        [self.subView addSubview:self.completeBtn];
    }
    return self;
}
-(NSArray *)array {
    if (!_array) {
        _array = @[@"不限",@"1星级",@"2星级",@"3星级",@"4星级",@"5星级",@"6星级",@"7星级"];
    }
    return _array;
}
-(void)addsubView
{
    
    UILabel *title = [self createLabelFrame:CGRectMake(30, 150, SCREEN_WIDTH - 100, 20) font:16 text:ADLString(@"星级") texeColor:COLOR_333333];
    [self.subView addSubview:title];
    
    int margin = 10;//间隙
    
    int width = (SCREEN_WIDTH - 110)/4;//格子的宽
    
    int height = 40;//格子的高
    
    for (int i = 0; i < self.array.count; i++) {
        int row = i/4;
        int col = i%4;
        UIButton * btn = [self createButtonFrame:CGRectMake(40+col*(width+margin), title.y + 50+row*(height+margin), width,  height) imageName:nil title:self.array[i] titleColor:COLOR_333333 font:12 target:self action:@selector(Clicktagbtn:)];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_hui"] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_E0212A forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_biankuang"] forState:UIControlStateSelected];
        
        [self.subView addSubview:btn];
        if (i == 0) {
          
            btn.selected = YES;
            self.starBtn = btn;
            self.limitBtn = btn;
        }
        btn.tag = i;
    }
}
-(void)Clicktagbtn:(UIButton *)btn {
    self.starBtn.selected = NO;
       btn.selected = !btn.isSelected;
    self.starBtn =btn;
   //[btn setSelected:YES];
}
-(UIButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [self createButtonFrame:CGRectMake(0, self.subView.height - 60, self.subView.width/2, 60) imageName:ADLString(@"重置") title:ADLString(@"重置") titleColor:COLOR_333333 font:14 target:self action:@selector(TouchUpInsideBtn:)];
        // [_resetBtn setBackgroundImage:[UIImage imageNamed:@"icon_hui"] forState:UIControlStateNormal];
        _resetBtn.tag = 1;
        _resetBtn.layer.masksToBounds = YES;
        _resetBtn.layer.borderColor = COLOR_999999.CGColor;
        _resetBtn.layer.borderWidth = 1;
       // _resetBtn.layer.cornerRadius = 5;
    }
    return _resetBtn;
}
-(UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [self createButtonFrame:CGRectMake(self.subView.width/2,self.resetBtn.y, self.subView.width/2, 60) imageName:ADLString(@"完成") title:ADLString(@"完成") titleColor:[UIColor whiteColor] font:14 target:self action:@selector(TouchUpInsideBtn:)];
        _completeBtn.backgroundColor = COLOR_E0212A;
        _completeBtn.tag = 1;
    }
    return _completeBtn;
}
-(void)TouchUpInsideBtn:(UIButton *)btn {
    if (btn.tag == 1) {
        WS(ws);
        if (self.screeningStarBlock) {
            ws.screeningStarBlock(ws.leftLabel.text, ws.rightLabel.text, ws.starBtn.titleLabel.text);
        }
    [self remove];
    }else {
        
        self.rightLabel.text = @"¥0";
        self.leftLabel.text = @"¥2000";
        self.leftLabel.centerX = 20 + (self.config.defaultLeftValue-self.config.minValue)/(self.config.maxValue-self.config.minValue)*self.slider.width;
        self.rightLabel.centerX = 30 + (self.config.defaultRightValue-self.config.minValue)/(self.config.maxValue-self.config.minValue)*self.slider.width;
        
        self.slider.leftButton.frame = CGRectMake(-10, self.slider.sliderOffsetY+self.slider.height/2-10, 20, 20);
        self.slider.rightButton.frame = CGRectMake(self.slider.width-10, self.slider.sliderOffsetY+self.slider.height/2-10, 20, 20);;
        self.starBtn.selected = NO;
        self.starBtn = nil;
        
 
    }
    
}

- (void)remove
{
    [UIView animateWithDuration:0.2 animations:^{
        self.subView.frame  =  CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
