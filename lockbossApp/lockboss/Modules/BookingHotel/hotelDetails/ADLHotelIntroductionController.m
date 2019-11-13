//
//  ADLHotelIntroductionController.m
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelIntroductionController.h"
#import "ADLHotelIntroductionHeadView.h"
#import "ADLHotelIntroductionMiddleView.h"
#import "ADLHotelIntroductionBottomView.h"
#import "ADLBookingHotelModel.h"

@interface ADLHotelIntroductionController ()
@property (nonatomic ,strong)ADLHotelIntroductionHeadView *headview;
@property (nonatomic ,strong)ADLHotelIntroductionMiddleView *middleview;
@property (nonatomic ,strong)ADLHotelIntroductionBottomView *bottomview;
@property (nonatomic ,strong)NSMutableArray *imageArray;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@property (nonatomic ,weak)UIScrollView *scrollView;
@end

@implementation ADLHotelIntroductionController

- (void)viewDidLoad {
    [super viewDidLoad];

 
  
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollView.showsHorizontalScrollIndicator = YES;
//    scrollView.showsVerticalScrollIndicator = YES;
    
    scrollView.alwaysBounceVertical = YES;

    //scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [self addNavigationView:ADLString(@"酒店简介")];
   
    


    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,self.headview.height +self.middleview.height + self.bottomview.height+NAVIGATION_H+20);

    NSDictionary *dict = [self dictionaryWithJsonString:self.model.facility];
    NSMutableArray *arr = dict[@"datas"];
    for (NSDictionary *dict in arr) {
        [self.titleArray addObject:dict[@"itemName"]];
        NSString *sort = dict[@"sort"];
        [self.imageArray addObject:[ADLBookingHotelModel iconStr:[sort integerValue]]];
    }
    [self.scrollView addSubview:self.headview];
    [self.scrollView addSubview:self.middleview];
    [self.scrollView addSubview:self.bottomview];
  
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {/*JSON解析失败*/
        
        return nil;
    }
    return dic;
}
-(ADLHotelIntroductionHeadView *)headview {
    if (!_headview) {
    CGFloat titleH = [ADLUtils calculateString:self.model.des rectSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) fontSize:12].height;
        _headview = [[ADLHotelIntroductionHeadView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H, SCREEN_WIDTH,200+titleH)];
     //  _headview.backgroundColor = [UIColor yellowColor];
        
        _headview.model = self.model;
    }
    return _headview;
}
-(ADLHotelIntroductionMiddleView *)middleview {
    if (!_middleview) {
        CGFloat viewH;
        if (self.imageArray.count > 0) {
        
            if (self.titleArray.count % 2 == 0) {
                viewH =self.titleArray.count/2 * 30;
            }else {
             viewH =self.titleArray.count/2 * 30 + 30;
            }
        }else {
            viewH = 0;
            _middleview.hidden = YES;
        }
        _middleview = [[ADLHotelIntroductionMiddleView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headview.frame)+5, SCREEN_WIDTH, viewH+65)];
       
        if (self.imageArray.count > 0) {
             _middleview.model = self.model;
            _middleview.imageArray = self.imageArray;//设备图片
            _middleview.titleArray = self.titleArray;//设备名称
    
        }
     
    }
    return _middleview;
}

-(ADLHotelIntroductionBottomView *)bottomview {
    if (!_bottomview) {
        CGFloat titleH = [ADLUtils calculateString:self.model.policyDes rectSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) fontSize:12].height;
        _bottomview = [[ADLHotelIntroductionBottomView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.middleview.frame)+5, SCREEN_WIDTH, titleH+75)];
        _bottomview.policyDes =self.model.policyDes;
    }
    return _bottomview;
}
-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
-(NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
-(NSString *)iconStr:(NSInteger)number{
    
    switch (number) {
        case 1://热水器
            return @"reshuiqi";
            break;
        case 2://吹风机
            return @"chuifengji";
            break;
        case 3://热水壶
            return @"reshuihu";
            break;
        case 4://电话
            return @"dianhua";
            break;
        case 5://房间wifi
            return @"WIFI";
            break;
        case 6://全天热水
            return @"xishu";
            break;
        case 7://电视
            return @"dianshi";
            break;
        case 8://空调
            return @"kongtiao";
            break;
        case 9:
            return @"";
            break;
        case 10:
            return @"";
            break;
        default:
            break;
    }
    return nil;
    //kongtiao
    //mensuo
}
@end
