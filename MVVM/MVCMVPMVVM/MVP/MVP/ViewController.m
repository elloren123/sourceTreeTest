//
//  ViewController.m
//  MVP
//
//  Created by 一米阳光 on 2017/11/16.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "ViewController.h"
#import "PersonViewProtocol.h"
#import "Presenter.h"
#import "TestView.h"

@interface ViewController ()<PersonViewProtocol>

@property (nonatomic, strong) TestView *testView;
@property (nonatomic, strong) Presenter *presenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    self.presenter = [Presenter new];
    [self.presenter attachView:self];
    [self.presenter fetchData];
}

- (void)setupViews {
    self.testView = [[TestView alloc] initWithFrame:CGRectMake(100, 100, CGRectGetWidth(self.view.bounds)-200, 50)];
    [self.view addSubview:self.testView];

}

#pragma PersonViewProtocol
- (void)setNameText:(NSString *)nameText {
    self.testView.nameLabel.text = nameText;
}

@end
