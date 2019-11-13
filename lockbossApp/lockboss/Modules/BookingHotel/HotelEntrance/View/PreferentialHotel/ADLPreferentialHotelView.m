//
//  ADLPreferentialHotelView.m
//  lockboss
//
//  Created by adel on 2019/9/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLPreferentialHotelView.h"
#import "ADLBookingHotelModel.h"
#import <UIImageView+WebCache.h>
#import "ADLPreferentialHotelViewCell.h"

@interface ADLPreferentialHotelView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, weak)UICollectionView *serviceView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@end

static NSString *MEVIEWCELLTHE = @"PreferentialHotelView";
@implementation ADLPreferentialHotelView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleBtn];
        [self addSubview:self.moreBtn];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((self.width-40)/3 , 90);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *serviceView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60,self.width , 105) collectionViewLayout:flowLayout];
        //self.flowLayout = flowLayout;
        
        serviceView.backgroundColor = [UIColor whiteColor];
        // 关闭滚动条
        serviceView.showsHorizontalScrollIndicator = NO;
        serviceView.showsVerticalScrollIndicator = NO;
        // 关闭弹簧效果
        serviceView.bounces =YES;
        
        // 1.设置数据源
        serviceView.dataSource = self;
        serviceView.delegate = self;
        [self addSubview:serviceView];
        self.serviceView = serviceView;
        // 用class来注册cell"告诉collectionView它所需要的cell如何创建"
        [self.serviceView registerClass:[ADLPreferentialHotelViewCell class] forCellWithReuseIdentifier:MEVIEWCELLTHE];
        
        UIView *lienView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(serviceView.frame)+15,self.width - 20, 1)];
        lienView.backgroundColor = COLOR_CCCCCC;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2-50, lienView.y - 7, 100, 14)];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor whiteColor];
        title.text = ADLString(@"附近推荐");
        title.textColor = COLOR_666666;
        title.font = [UIFont systemFontOfSize:12];
        [self addSubview:lienView];
        [self addSubview:title];
    }
    return self;
    
    
}
//客房中心-服务
-(void)allServiceData {

    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _array.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLPreferentialHotelViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MEVIEWCELLTHE forIndexPath:indexPath];
    
   ADLBookingHotelModel  *model=self.array[indexPath.row];
    //[cell.hotelImage sd_setImageWithURL:[NSURL URLWithString:dict[@"coverUrl"]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
      [cell.hotelImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.coverUrl]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
 
 
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(ADLPreferentialHotelVie:didSelectRowAtIndexPath:)]) {
        [self.delegate ADLPreferentialHotelVie:self didSelectRowAtIndexPath:indexPath];
    }
}

-(void)setArray:(NSMutableArray *)array {
    _array = array;
    
    [self.serviceView reloadData];
}
-(UIButton *)titleBtn {
    if (!_titleBtn) {
          _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.frame =CGRectMake(12, 20, 150, 25);
        [_titleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [_titleBtn setTitle:ADLString(@"精品优惠推荐") forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _titleBtn;
}

-(UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame =CGRectMake(self.width-62,20, 50, 30);
        [_moreBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [_moreBtn setTitle:ADLString(@"更多") forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
          [_moreBtn setImage:[UIImage imageNamed:@"tableView_indicator"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:_moreBtn imageTitleSpace:10];
      //  _moreBtn.backgroundColor = [UIColor redColor];
    }
    return _moreBtn;
}
-(void)moreBtn:(UIButton *)btn{
    if (self.moreBlock) {
        self.moreBlock(btn);
    }
}

@end
