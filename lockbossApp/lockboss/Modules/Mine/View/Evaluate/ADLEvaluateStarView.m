//
//  ADLEvaluateStarView.m
//  lockboss
//
//  Created by adel on 2019/6/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLEvaluateStarView.h"

@interface ADLEvaluateStarView ()

@property (weak, nonatomic) IBOutlet UIButton *firstBtn1;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn2;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn3;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn4;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn5;

@property (weak, nonatomic) IBOutlet UIButton *secondBtn1;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn2;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn3;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn4;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn5;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn1;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn2;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn3;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn4;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn5;

@property (nonatomic, strong) NSArray *firstArr;
@property (nonatomic, strong) NSArray *secondArr;
@property (nonatomic, strong) NSArray *thirdArr;

@end

@implementation ADLEvaluateStarView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firstStar = 0;
    self.secondStar = 0;
    self.thirdStar = 0;
    self.firstArr = @[self.firstBtn1,self.firstBtn2,self.firstBtn3,self.firstBtn4,self.firstBtn5];
    self.secondArr = @[self.secondBtn1,self.secondBtn2,self.secondBtn3,self.secondBtn4,self.secondBtn5];
    self.thirdArr = @[self.thirdBtn1,self.thirdBtn2,self.thirdBtn3,self.thirdBtn4,self.thirdBtn5];
}

- (IBAction)clickFirstBtn:(UIButton *)sender {
    self.firstStar = sender.tag;
    [self.firstArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.firstStar) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
}

- (IBAction)clickSecondBtn:(UIButton *)sender {
    self.secondStar = sender.tag;
    [self.secondArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.secondStar) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
}

- (IBAction)clickThirdBtn:(UIButton *)sender {
    self.thirdStar = sender.tag;
    [self.thirdArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.thirdStar) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
}

@end
