//
//  ADLRecorderDetailView.m
//  lockboss
//
//  Created by adel on 2019/6/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLRecorderDetailView.h"

@interface ADLRecorderDetailView ()
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *personalLab;
@property (weak, nonatomic) IBOutlet UILabel *businessNumLab;
@property (weak, nonatomic) IBOutlet UILabel *taxNumLab;
@property (weak, nonatomic) IBOutlet UILabel *industryLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *satisfyLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *abstractBtn;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorView;
@end

@implementation ADLRecorderDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.abstractBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
}

- (IBAction)clickAbstractBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCompanyAbstractBtn)]) {
        [self.delegate didClickCompanyAbstractBtn];
    }
}

- (IBAction)clickCallPhoneBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickContactPhoneBtn)]) {
        [self.delegate didClickContactPhoneBtn];
    }
}

- (void)updateContentWithDict:(NSDictionary *)dict {
    self.companyLab.text = dict[@"company"];
    self.personalLab.text = dict[@"responsibleMen"];
    self.businessNumLab.text = dict[@"businessRegisterNumber"];
    self.taxNumLab.text = dict[@"taxRegisterNumber"];
    NSInteger industry = [dict[@"industry"] integerValue];
    if (industry == 0) {
        self.industryLab.text = @"酒店门锁";
    } else {
        self.industryLab.text = @"家庭门锁";
    }
    self.areaLab.text = dict[@"location"];
    self.satisfyLab.text = [NSString stringWithFormat:@"%d%%",[dict[@"evaluationScore"] intValue]];
    self.phoneLab.text = dict[@"companyPhone"];
    if ([[dict[@"companyAbstract"] stringValue] hasPrefix:@"http"]) {
        self.abstractBtn.hidden = NO;
        self.indicatorView.hidden = NO;
    } else {
        self.abstractBtn.hidden = YES;
        self.indicatorView.hidden = YES;
    }
}

@end
