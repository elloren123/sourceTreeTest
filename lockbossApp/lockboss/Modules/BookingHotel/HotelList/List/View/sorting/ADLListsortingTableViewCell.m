//
//  ADLListsortingTableViewCell.m
//  lockboss
//
//  Created by adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLListsortingTableViewCell.h"

@interface ADLListsortingTableViewCell ()

@property (nonatomic ,strong)UIImageView *iconImage;
@end

@implementation ADLListsortingTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.iconImage];
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *FamilyOpenLockCell = @"ListsortingTableViewCell";
    ADLListsortingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FamilyOpenLockCell];
    if (cell == nil) {
        cell = [[ADLListsortingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FamilyOpenLockCell];
     
    }
    
    return cell;
}

-(UILabel *)title {
    if (!_title) {
        _title = [self createLabelFrame:CGRectMake(10, 10,self.width - 100, 20) font:14 text:ADLString(@"距离优先") texeColor:COLOR_333333];
    }
    return _title;
}
-(UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 10,20, 20)];
        _iconImage.image = [UIImage imageNamed:@"queren"];
        _iconImage.hidden = YES;
    }
    return _iconImage;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected == NO) {
        self.iconImage.hidden = YES;
        self.title.textColor = COLOR_333333;
    }else {
        _iconImage.hidden = NO;
        self.title.textColor = COLOR_E0212A;
    }
}

@end
