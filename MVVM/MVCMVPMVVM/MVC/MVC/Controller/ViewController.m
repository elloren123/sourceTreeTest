//
//  ViewController.m
//  MVC
//
//  Created by 一米阳光 on 2017/11/16.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "TestView.h"

@interface ViewController ()

@property (nonatomic, strong) Person *personModel;
@property (nonatomic, strong) TestView *testView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
        
    if (self.personModel.firstName.length > 0) {
        self.testView.nameLabel.text = self.personModel.firstName;
    } else {
        self.testView.nameLabel.text = self.personModel.lastName;
    }
    
}

- (void)setupViews {
    self.personModel = [[Person alloc] initWithFirstName:@"" lastName:@"胡歌"];
    self.testView = [[TestView alloc] initWithFrame:CGRectMake(100, 100, CGRectGetWidth(self.view.bounds)-200, 50)];
    [self.view addSubview:self.testView];
}

@end























