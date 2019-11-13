//
//  ADLAutoresizeLabelFlowHeader.h
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ADLAutoresizeLabelFlowHeader : UICollectionReusableView

@property (nonatomic, assign) BOOL haveDeleteBtn;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) NSIndexPath *indexPath;

//@property (nonatomic, weak) id <XDAutoresizeLabelFlowHeaderDelegate>delegate;
@property (nonatomic, copy) void (^deleteActionBlock)(NSIndexPath *indexPath);

@end
