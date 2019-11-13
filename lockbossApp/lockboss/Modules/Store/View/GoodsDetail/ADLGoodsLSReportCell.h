//
//  ADLGoodsLSReportCell.h
//  lockboss
//
//  Created by adel on 2019/7/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLGoodsLSReportCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imgSize:(CGSize)imgSize;

@property (nonatomic, strong) NSArray *urlArr;

@end
