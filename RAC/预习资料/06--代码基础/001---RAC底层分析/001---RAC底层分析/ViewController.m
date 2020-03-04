//
//  ViewController.m
//  001---RAC底层分析
//
//  Created by Cooci on 2018/8/2.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
/*
 
 这里的UITextFieldDelegate 通过RAC去监听,可以不写,会给警告,但是一样可以监听到
 
 */
@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic ,strong)NSString *name;

@property (nonatomic, copy) void(^nameChangeBlock)(NSString *newName);

@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIButton *touchBtn;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UI];
    
    //sequence 序列 ---> signal信号
    
    NSArray *arr = @[@"a",@"b",@"c",@"d"];
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"arr----%@",x);
    }];
    NSDictionary *dic = @{@"key1":@"value1111",
                          @"key2":@"value122222221",
                          @"key3":@{@"seckey":@"secvalue"}
                          };
    [dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@----%@",x[0],x[1]);
    }];
    
 //**************************************************************************************************************
    
    // RAC 流程分析
    // 1: 信号产生
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        // 3:发送信号
        [subscriber sendNext:@"Cooci"];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"我们销毁了");
        }];
    }];
    // 2: 订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅到了:%@",x);
    }];
}

-(void)kvoNameChangeBlock:(void (^)(NSString *newName))nameChangeBlock{
    self.nameChangeBlock = nameChangeBlock;
    [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.name = @"A";
    [self.view endEditing:YES];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"---kvo --- %@",change);
    self.nameChangeBlock(change[@"new"]);
}


-(void)UI{
#pragma mark ------ KVO ------
    
    self.name = @"zsy";
    [self kvoNameChangeBlock:^(NSString *newName) {
        NSLog(@"newName == -------%@",newName);
    }];
    //RACObserve  遍历了self中的所有的ivarlist,所以能拿到self中的所有的属性,包括name
    //RACObserve(self, name) 这个就是一个信号
    
    [RACObserve(self, name) subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac反馈-----%@",x);
    }];
    /*
     
     RAC --->使用的注意点
     
     
     */
#pragma mark ------ 通知 ------
    //    [[NSNotificationCenter defaultCenter] addObserver:<#(nonnull id)#> selector:<#(nonnull SEL)#> name:<#(nullable NSNotificationName)#> object:<#(nullable id)#>];
    
    //RACSignal信号: [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil]
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"键盘监听-----%@",x);
    }];
    
    
#pragma mark ------ 代理  delegate ------
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"\n代理---%@\n",x);
    }];
    //必须要指明谁去响应代理,self可以不遵从代理<UITextFieldDelegate>
    self.textfield.delegate = self;
    
#pragma mark ------ Btn ------
    [[self.touchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"--------按钮被点击了");
    }];
    
    [self.textfield.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"输入的值 ==== %@",x);
    }];
    
#pragma mark ------ 手势 ------
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.lab addGestureRecognizer:tap];
    self.lab.userInteractionEnabled = YES;//这个在xib中已经设置了
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSLog(@"手势 -------- %@",x);
        NSLog(@"%@",x.view);
    }];
}


@end
