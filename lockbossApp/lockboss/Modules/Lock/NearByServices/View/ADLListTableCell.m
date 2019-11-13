//
//  ADLListTableCell.m
//  lockboss
//
//  Created by bailun91 on 2019/9/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLListTableCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLListTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UILabel *listLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, 50)];
        listLbl.font = [UIFont systemFontOfSize:16];
        listLbl.textAlignment = NSTextAlignmentCenter;
        listLbl.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:listLbl];
        self.listName = listLbl;
    }
    return self;
}

//- (void)layoutSubviews {
//
//    CGFloat hei = self.frame.size.height;
//    self.titLab.frame = CGRectMake(12, 0, SCREEN_WIDTH*0.3, hei);
//    self.lineView.frame = CGRectMake(SCREEN_WIDTH*0.3+24, 0, 0.5, hei);
//    self.descLab.frame = CGRectMake(SCREEN_WIDTH*0.3+36, 0, SCREEN_WIDTH*0.7-48, hei);
//    self.spView.frame = CGRectMake(12, hei-0.5, SCREEN_WIDTH-12, 0.5);
//}

@end
