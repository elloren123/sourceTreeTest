//
//  ADLFUnlockRecordCell.h
//  lockboss
//
//  Created by Adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLFUnlockRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *deviceLab;

@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@property (weak, nonatomic) IBOutlet UILabel *descLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIImageView *fingerView;

@property (weak, nonatomic) IBOutlet UIImageView *mcardView;

@property (weak, nonatomic) IBOutlet UIImageView *pwdView;

@property (weak, nonatomic) IBOutlet UIImageView *phoneView;

- (void)dealwithData:(NSDictionary *)dict;

@end
