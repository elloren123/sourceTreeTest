//
//  ADLDinnerTableCell.h
//  lockboss
//
//  Created by bailun91 on 2019/9/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLDinnerTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView   *dinnerImg;   //菜品Icon
@property (nonatomic, strong) UILabel       *dinnerName;  //店铺名
@property (nonatomic, strong) UILabel       *soldLbl;     //卖出数量label
@property (nonatomic, strong) UILabel       *leadLbl;     //说明label
@property (nonatomic, strong) UILabel       *priceLbl;    //价格label
@property (nonatomic, strong) UIButton      *addButton;   //添加btn
@property (nonatomic, strong) UILabel       *dinnerNum;   //数量label
@property (nonatomic, strong) UIButton      *deleteBtn;   // 删除btn

@end

NS_ASSUME_NONNULL_END
