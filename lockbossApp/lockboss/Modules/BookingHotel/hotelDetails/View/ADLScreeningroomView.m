//
//  ADLScreeningroomView.m
//  lockboss
//
//  Created by adel on 2019/9/24.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLScreeningroomView.h"

@interface ADLScreeningroomView ()
@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)UIView *subView;
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,strong)NSArray *titleArray;

@property (nonatomic ,strong)UIButton *payBtn;//支付
@property (nonatomic ,strong)UIButton *breakfastBtn;//早餐
@property (nonatomic ,strong)UIButton *bedBtn;//房型
@property (nonatomic ,strong)UIView *bottomView;
@property (nonatomic ,strong)UIButton *cancelBtn;
@property (nonatomic ,strong)UIButton *determineBtn;

@property (nonatomic ,assign)CGFloat navigheight;

@property (nonatomic ,strong)NSMutableArray *addArray;
@end

@implementation ADLScreeningroomView

-(instancetype)initWithFrame:(CGRect)frame navigheight:(CGFloat)navigheight {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.navigheight = navigheight;
        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        

     
        
        
        UIView *titleView = [[UIView alloc] init];
        titleView.frame = CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT);
        titleView.backgroundColor = [UIColor blackColor];
        titleView.alpha = 0.7;
        [self addSubview:titleView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [titleView addGestureRecognizer:tap];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 450, SCREEN_WIDTH,450)];
        //    scrollView.showsHorizontalScrollIndicator = YES;
        //    scrollView.showsVerticalScrollIndicator = YES;
        
        scrollView.alwaysBounceVertical = YES;
        
        //scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView= scrollView;
        
        UIView *subView = [[UIView alloc] init];
        subView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        subView.backgroundColor = [UIColor whiteColor];
        
        [self.scrollView addSubview:subView];
        self.subView = subView;
        
        
      //  WS(ws);
        // 通过动画设置
//        [UIView animateWithDuration:0.05 animations:^{
//
//
//        } completion:nil];
    
     
    }
    return self;
}
-(NSMutableArray *)addArray {
    if (!_addArray) {
        _addArray = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    }
    return _addArray;
}
-(void)titleView {
    int width = 80;//格子的宽
    
    int height = 20;//格子的高
    for (int i = 0; i <self.titleArray.count; i++) {
        //int row = i;
        
      //  ADLLog(@"row%d,col%d",row,col);
        UILabel *label = [self createLabelFrame:CGRectMake(40,20+i*(height+45), width, height) font:12 text: self.titleArray[i] texeColor:COLOR_333333];
          [self.subView addSubview:label];
    }
        
}
-(void)addbtnSubView
{
    int margin = 10;//间隙
    
    int width = (SCREEN_WIDTH - 110)/3;//格子的宽
    
    int height = 33;//格子的高
    
    for (int i = 0; i < self.array.count; i++) {
        int row = i/3;
        int col = i%3;
        int marginY = 45+row*66;
        

        UIButton * btn = [self createButtonFrame:CGRectMake(40+col*(width+margin), marginY, width,  height) imageName:nil title:self.array[i] titleColor:COLOR_333333 font:12 target:self action:@selector(Clicktagbtn:)];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_hui"] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_E0212A forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_biankuang"] forState:UIControlStateSelected];
        
        btn.tag = i;
        
        NSString *title =self.array[i];
        if (title.length == 0) {
            btn.hidden = YES;
        }
        
        if (i < 2) {
            self.payBtn = btn;
        }  if (i < 5 && i > 1) {
            self.breakfastBtn = btn;
        }   if (i < 9 && i > 3) {
            self.bedBtn = btn;
        }
        [self.subView addSubview:btn];
   
    }
    
}


-(NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray arrayWithArray:@[@"全部早餐",@"有早餐",@"无早餐",@"全部房型"]];
    }
    return _array;
}
-(void)setNameArray:(NSMutableArray *)nameArray {
    _nameArray = nameArray;
    [self.array addObjectsFromArray:_nameArray];
    

    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,self.array.count/3 * 66 + 300);
    self.subView.frame  = CGRectMake(0,0, SCREEN_WIDTH,self.array.count/3 * 66 + 300);
    [self titleView];
    [self addbtnSubView];
    [self addSubview:self.bottomView];
  
}
-(NSArray *)titleArray {
        if (!_titleArray) {
            _titleArray = @[@"早餐",@"房型"];
         
        }
        return _titleArray;
    }
-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,self.height -60,self.width,  60)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:self.cancelBtn];
        [_bottomView addSubview:self.determineBtn];
    }
    return _bottomView;
}
-(UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [self createButtonFrame:CGRectMake(40, 10, (self.width - 120)/2,  40) imageName:nil title:ADLString(@"取消") titleColor:COLOR_333333 font:16 target:self action:@selector(remove)];
          _cancelBtn.backgroundColor = COLOR_F7F7F7;
            _cancelBtn.layer.masksToBounds = YES;;
            _cancelBtn.layer.cornerRadius = 5;
    }
    return _cancelBtn;
}

-(UIButton *)determineBtn {
    if (!_determineBtn) {
        _determineBtn = [self createButtonFrame:CGRectMake(CGRectGetMaxX(self.cancelBtn.frame)+40, self.cancelBtn.y, (self.width - 120)/2,  40) imageName:nil title:ADLString(@"确定") titleColor:[UIColor whiteColor] font:16 target:self action:@selector(Clicktagbtn:)];
        _determineBtn.backgroundColor = COLOR_E0212A;
        _determineBtn.tag =100;
        _determineBtn.layer.masksToBounds = YES;;
        _determineBtn.layer.cornerRadius = 5;
    }
    return _determineBtn;
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self remove];
//
//}
-(void)Clicktagbtn:(UIButton *)btn {
  //  self.addArray[btn.tag] =btn.titleLabel.text;
      //早餐
    if (btn.tag <= 2) {
       
      self.payBtn.selected = NO;
        btn.selected = YES;
        self.payBtn = btn;
         self.addArray[0] =btn.titleLabel.text;
    }
   //房型
    if (btn.tag>= 3 &&  btn.tag < 100) {
      
        self.breakfastBtn.selected = NO;
          btn.selected = YES;
        self.breakfastBtn = btn;
             self.addArray[1] =btn.titleLabel.text;
    }
   
 
    if (btn.tag == 100) {
   
        for (NSUInteger i = 0; i < self.addArray.count; i++) {
            
            NSString *str  = self.addArray[i];
            if (str.length == 0) {
                [self.addArray removeObjectAtIndex:i];
                i--;
            }
        }
     
        if (self.deldgate &&[self.deldgate respondsToSelector:@selector(screeningroomView:array:iphone:)]) {
            [self.deldgate screeningroomView:self array:self.addArray iphone:btn];
        }
        [self remove];
    }
  //  [self remove];
}
- (void)remove
{
//    WS(ws);
//    [UIView animateWithDuration:0.1 animations:^{
//
//        // self.titleView.frame = CGRectMake(0,ws.navigheight,SCREEN_WIDTH,0);
//        self.subView.frame  = CGRectMake(0,ws.navigheight, SCREEN_WIDTH, 0);
//        //_backView.hidden = YES;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    [self removeFromSuperview];
}
@end
