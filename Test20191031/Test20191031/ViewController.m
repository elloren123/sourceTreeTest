//
//  ViewController.m
//  Test20191031
//
//  Created by adel on 2019/10/31.
//  Copyright © 2019 adel. All rights reserved.
//1111111111111111111

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     
     测试更改后提交到新的w分支上
     
     */
    
    [self test1];
    
    [self test2];
}

-(void)test1{
    NSLog(@"我们是打标签之前的代码");
}

-(void)test2 {
    NSLog(@"打过一个标签后,我才提交的`````");
}

@end
