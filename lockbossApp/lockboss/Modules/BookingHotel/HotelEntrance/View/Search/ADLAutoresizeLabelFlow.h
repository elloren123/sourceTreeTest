//
//  ADLAutoresizeLabelFlow.h
//  lockboss
//
//  Created by adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLAutoresizeLabelFlow;
typedef void(^selectedHandler)(NSIndexPath *indexPath,NSString *title);
typedef void (^deleteActionHandler)(NSIndexPath *indexPath);

@interface ADLAutoresizeLabelFlow : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                sectionTitles:(NSArray *)secTitles
              selectedHandler:(selectedHandler)handler;

- (void)insertLabelWithTitle:(NSString *)title
                     atIndex:(NSUInteger)index
                    animated:(BOOL)animated;

- (void)insertLabelsWithTitles:(NSArray *)titles
                     atIndexes:(NSIndexSet *)indexes
                      animated:(BOOL)animated;

- (void)deleteLabelAtIndex:(NSUInteger)index
                  animated:(BOOL)animated;

- (void)deleteLabelsAtIndexes:(NSIndexSet *)indexes
                     animated:(BOOL)animated;

- (void)reloadAllWithTitles:(NSArray *)titles;

@property (nonatomic, assign) BOOL selectMark;  // 选中标记
@property (nonatomic, copy) deleteActionHandler deleteHandler;//删除block

@end
