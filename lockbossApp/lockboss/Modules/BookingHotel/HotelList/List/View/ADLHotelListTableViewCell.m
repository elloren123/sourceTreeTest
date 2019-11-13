//
//  ADLHotelListTableViewCell.m
//  lockboss
//
//  Created by adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelListTableViewCell.h"

@implementation ADLHotelListTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *FamilyOpenLockCell = @"HotelListTableViewCell";
    ADLHotelListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FamilyOpenLockCell];
    if (cell == nil) {
        cell = [[ADLHotelListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FamilyOpenLockCell];
    }
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
