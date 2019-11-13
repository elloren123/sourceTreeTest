//
//  ORSKUDataFilter.h
//  SKUFilterfilter
//
//  Created by OrangesAL on 2017/12/3.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ORSKUDataFilter;
@class ORSKUProperty;

@protocol ORSKUDataFilterDataSource <NSObject>

@required

//属性种类个数
- (NSInteger)numberOfSectionsForPropertiesInFilter:(ORSKUDataFilter *)filter;

/*
 * 每个种类所有的的属性值
 * 这里不关心具体的值，可以是属性ID, 属性名，字典、model
 */
- (NSArray *)filter:(ORSKUDataFilter *)filter propertiesInSection:(NSInteger)section;

//满足条件 的 个数
- (NSInteger)numberOfConditionsInFilter:(ORSKUDataFilter *)filter;

/*
 * 对应的条件式
 * 这里条件式的属性值，需要和propertiesInSection里面的数据类型保持一致
 */
- (NSArray *)filter:(ORSKUDataFilter *)filter conditionForRow:(NSInteger)row;

//条件式 对应的 结果数据（库存、价格等）
- (id)filter:(ORSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row;

@end

@interface ORSKUDataFilter : NSObject

@property (nonatomic, assign) id<ORSKUDataFilterDataSource> dataSource;

//当前 选中的属性indexPath
@property (nonatomic, strong, readonly) NSArray <NSIndexPath *> *selectedIndexPaths;
//当前 可选的属性indexPath
@property (nonatomic, strong, readonly) NSSet <NSIndexPath *> *availableIndexPathsSet;
//当前 结果
@property (nonatomic, strong, readonly) id currentResult;

@property (nonatomic, assign) BOOL needDefaultValue;

//init
- (instancetype)initWithDataSource:(id<ORSKUDataFilterDataSource>)dataSource;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

//选中 属性的时候 调用
- (void)didSelectedPropertyWithIndexPath:(NSIndexPath *)indexPath;

//重新加载数据
- (void)reloadData;

@end

@interface ORSKUCondition :NSObject

@property (nonatomic, strong) NSArray<ORSKUProperty *> *properties;

@property (nonatomic, strong, readonly) NSArray<NSNumber *> *conditionIndexs;

@property (nonatomic, strong) id result;

@end

@interface ORSKUProperty :NSObject

@property (nonatomic, copy, readonly) NSIndexPath * indexPath;
@property (nonatomic, copy, readonly) id value;

- (instancetype)initWithValue:(id)value indexPath:(NSIndexPath *)indexPath;

@end

