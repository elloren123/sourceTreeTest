//
//  ViewController.m
//  001---RAC初探
//
//  Created by Cooci on 2018/4/17.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, copy) NSString *name;

// 到底RAC做了什么,如此牛逼?请继续关注我 抖音:1279575961(Cooci)
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //函数式编程 + 响应式编程
    
    //最基本的用法
//    [self testBase];
    
    //替代KVO
//    [self testKVO];
    
     //替代代理
//    [self testDelegate];
    
    //替代通知
//    [self testNoti];
    
    //替代UI target
//    [self testUI];
    
    //数据结构
//    [self testSequence];
    
    //代替timer
    
//    NSLog(@"%@",[NSThread currentThread]);
//
//    [self testTmer];
    
    
    [self testBase];
    
}

- (void)testTmer{

    [[RACSignal interval:1 onScheduler:[RACScheduler schedulerWithPriority:(RACSchedulerPriorityHigh) name:@" com.ReactiveCocoa.RACScheduler.mainThreadScheduler"]] subscribeNext:^(NSDate * _Nullable x) {
       
        NSLog(@"%@",[NSThread currentThread]);
    }];

}

- (void)testSequence{

    //数组
    NSArray *array = @[@"Cooci",@"123",@"18"];
    
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
       
        NSLog(@"%@",x);
    }];
    
    
    NSDictionary *dict = @{@"key":@"Cooci",@"age":@"18",@"gender":@"1"};
    
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
       //元祖
        NSLog(@"%@",x);
        
        RACTwoTuple *tuple = (RACTwoTuple *)x;
        
        NSLog(@"key == %@ , value = %@",tuple[0],tuple[1]);
        
    }];
    
    
}

- (void)testUI{
    
    //Button
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {

        NSLog(@"%@",x);
    }];

    self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {

        NSLog(@"%@",input);

        return [RACSignal empty];

    }];
    
    //textField
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {

        NSLog(@"%@",x);
    }];

    
    //UITapGestureRecognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    self.label.userInteractionEnabled = YES;
    [self.label addGestureRecognizer:tap];

    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {

        NSLog(@"%@",x);
    }];

    
}

- (void)testNoti{
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
       
        NSLog(@"%@",x);
    }];
}


- (void)testDelegate{
    
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    self.textField.delegate = self;
}


- (void)testKVO{
    
    [RACObserve(self, name) subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        
    }];
    
    self.name = @"Cooci";
}



- (void)testBase{
    
    //1:创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        //subscriber 对象不是一个对象
        //3:发送信号
        [subscriber sendNext:@"Cooci"];
        
        //请求网络 失败 error
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:10086 userInfo:@{@"key":@"10086错误"}];
        
        [subscriber sendError:error];
//        [subscriber sendCompleted];
        
        //RACDisposable 销毁
        
        return [RACDisposable disposableWithBlock:^{
           
            NSLog(@"销毁了");
        }];
    }];
    
    
    //2:订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
       
        NSLog(@"%@",x);
    }];
    
    //订阅错误信号
    
    [signal subscribeError:^(NSError * _Nullable error) {
       
        NSLog(@"%@",error);
    }];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.name = [NSString stringWithFormat:@"%@+",self.name];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
