//
//  ADLLockerEvaluateCell.h
//  lockboss
//
//  Created by adel on 2019/6/19.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLLockerEvaluateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (weak, nonatomic) IBOutlet UIImageView *imgView6;
@property (weak, nonatomic) IBOutlet UIImageView *imgView7;
@property (weak, nonatomic) IBOutlet UIImageView *imgView8;
@property (weak, nonatomic) IBOutlet UIImageView *imgView9;
@property (nonatomic, strong) NSString *headShot;
- (void)updateImageViewImage:(NSArray *)urlArr width:(CGFloat)wid;
@end
