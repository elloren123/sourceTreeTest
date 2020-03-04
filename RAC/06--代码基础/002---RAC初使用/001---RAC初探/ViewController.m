//
//  ViewController.m
//  001---RAC初探
//
//  Created by Cooci on 2018/4/17.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import <RACReturnSignal.h>

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, copy) NSString *name;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
