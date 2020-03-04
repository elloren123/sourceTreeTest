//
//  ViewController.m
//  MVVM
//
//  Created by 一米阳光 on 2017/11/16.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "ViewController.h"
#import "PersonViewModel.h"
#import "TestView.h"

@interface ViewController ()

@property (nonatomic, strong) TestView *testView;
@property (nonatomic, strong) PersonViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    self.testView.nameLabel.text = self.viewModel.nameText;
    
}

- (void)setupViews {
    Person *person = [[Person alloc] initWithFirstName:@"" lastName:@"胡歌"];
    self.viewModel = [[PersonViewModel alloc] initWithPerson:person];
    self.testView = [[TestView alloc] initWithFrame:CGRectMake(100, 100, CGRectGetWidth(self.view.bounds)-200, 50)];
    [self.view addSubview:self.testView];
}

@end
