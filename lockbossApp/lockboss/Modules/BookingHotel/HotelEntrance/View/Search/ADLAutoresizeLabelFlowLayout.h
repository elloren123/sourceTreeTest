//
//  ADLAutoresizeLabelFlowLayout.h
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLAutoresizeLabelFlowLayoutDataSource <NSObject>

- (NSString *)titleForLabelAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ADLAutoresizeLabelFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id <ADLAutoresizeLabelFlowLayoutDataSource> dataSource;

@end


