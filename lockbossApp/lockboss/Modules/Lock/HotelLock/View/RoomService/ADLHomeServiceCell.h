//
//  ADLHomeServiceCell.h
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ADLHomeServiceModel;

@interface ADLHomeServiceCell : UICollectionViewCell

-(void)strtitle:(NSString *)title image:(NSString *)image;

@property (nonatomic, strong) ADLHomeServiceModel *model;

@property (nonatomic, strong) ADLHomeServiceModel *serviceModel;

@property (nonatomic, strong) UIImageView *icon;
@end


