//
//  ADLSystemGoodsCell.h
//  lockboss
//
//  Created by adel on 2019/5/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSystemGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property (nonatomic, strong) NSString *imgUrl;

@end

