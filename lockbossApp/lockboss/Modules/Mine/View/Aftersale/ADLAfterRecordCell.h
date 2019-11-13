//
//  ADLAfterRecordCell.h
//  lockboss
//
//  Created by adel on 2019/6/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLAfterRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *identifyLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (nonatomic, strong) NSString *imgUrl;
@end

