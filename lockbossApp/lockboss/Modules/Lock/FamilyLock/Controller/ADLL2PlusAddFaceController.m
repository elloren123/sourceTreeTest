//
//  ADLL2PlusAddFaceController.m
//  lockboss
//
//  Created by adel on 2019/11/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLL2PlusAddFaceController.h"
#import "ADLL2PlusFaceView.h"
#import "ADLAddPlusFacePresent.h"
@interface ADLL2PlusAddFaceController ()

@property (nonatomic ,strong) ADLL2PlusFaceView *plusView;
@property (nonatomic ,strong) ADLAddPlusFacePresent *pt;
@end

@implementation ADLL2PlusAddFaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"人脸识别"];
    
    self.pt = [[ADLAddPlusFacePresent alloc] init];
    self.plusView = [[ADLL2PlusFaceView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_H-NAVIGATION_H)];
    __weak typeof(self) weakSelf = self;
    self.plusView.clickBtn = ^{
        __strong typeof(self)StrongSelf = weakSelf;
        [StrongSelf startAddFace];
    };
    [self.view addSubview:self.plusView];
    //TODO  添加MQ的监听
    
}

-(void)startAddFace{
    ADLLog(@"\n---开始添加人脸---\n");
    [self.pt sendAddFaceAFWithSuccess:^(id  _Nonnull response) {
        //成功
        
    } Fial:^{
        //失败
        
    }];
}


#pragma mark ------ MQ ------




@end
