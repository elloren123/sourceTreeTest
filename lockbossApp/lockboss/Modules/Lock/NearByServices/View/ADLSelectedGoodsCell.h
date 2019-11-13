//
//  ADLSelectedGoodsCellTableViewCell.h
//  lockboss
//
//  Created by bailun91 on 2019/9/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLSelectedGoodsCell : UITableViewCell

@property (nonatomic, strong) UILabel       *goodName;  //商品名label
@property (nonatomic, strong) UILabel       *priceLbl;  //金额label
@property (nonatomic, strong) UIButton      *addButton; //添加btn
@property (nonatomic, strong) UILabel       *goodNum;   //商品数量label
@property (nonatomic, strong) UIButton      *deleteBtn; // 删除btn

//选择条目时
@property (nonatomic, copy) void(^addOrDleBtnClickedBlock) (NSInteger tag);

@end

NS_ASSUME_NONNULL_END
