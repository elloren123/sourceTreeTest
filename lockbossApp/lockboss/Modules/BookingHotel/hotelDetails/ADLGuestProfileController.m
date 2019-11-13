//
//  ADLGuestProfileController.m
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLGuestProfileController.h"
#import "ADLBannerView.h"
#import "ADLBookingHotelModel.h"
#import "ADLHotelOrderController.h"
@interface ADLGuestProfileController ()
@property (nonatomic ,strong)ADLBannerView *bannerView;
@property (nonatomic ,strong)UIView *centreView;
@property (nonatomic ,strong)UIView *bookView;
@property (nonatomic ,weak)UIScrollView *scrollView;
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *imageArray;
@end

@implementation ADLGuestProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = [self dictionaryWithJsonString:self.model.facility];
    NSMutableArray *arr = dict[@"datas"];
    for (NSDictionary *dict in arr) {
        [self.titleArray addObject:dict[@"itemName"]];
        NSString *sort = dict[@"sort"];
        [self.imageArray addObject:[ADLBookingHotelModel iconStr:[sort integerValue]]];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView addSubview:self.bannerView];
    [scrollView addSubview:self.centreView];
    scrollView.alwaysBounceVertical = YES;
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,self.bannerView.height + self.centreView.height+NAVIGATION_H+20);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [self addNavigationView:ADLString(@"客房简介")];
    [self.view addSubview:self.bookView];
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
-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray =[NSMutableArray array];
    }
    return _imageArray;
}
-(NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray= [NSMutableArray array];
    }
    return _titleArray;
}
-(UIView *)centreView {
    if (!_centreView) {
        _centreView = [[UIView alloc]init];
        //int margin = 10;//间隙
        int width = (SCREEN_WIDTH - 50)/2;//格子的宽
        int height = 15;//格子的高
        UILabel *name ;
        for (int i = 0; i < self.array.count; i++) {
            int row = i%self.array.count;
            //  int col = i%3;
            
            name = [self.view createLabelFrame:CGRectMake(20,20+row*(height+10), width,  height) font:12 text:self.array[i] texeColor:COLOR_333333];
            if (i == self.array.count-1) {
                name.font = [UIFont systemFontOfSize:15];
            }
            [self.centreView addSubview:name];
        }
        
        int margin = 10;//间隙
        
        int widthbtn =(SCREEN_WIDTH - 100)/6;//格子的宽
        
        int heightbtn = 50;//格子的高
        UIButton * btn;
        for (int i = 0; i <self.titleArray.count; i++) {
            int row = i/6;
            int col = i%6;
            btn = [self.view createButtonFrame:CGRectMake(25+col*(widthbtn+margin), CGRectGetMaxY(name.frame)+10+row*(heightbtn+margin), widthbtn,  heightbtn) imageName:self.imageArray[i] title:self.titleArray[i] titleColor:COLOR_666666 font:10 target:self action:nil];
            [self.scrollView addSubview:btn];
            //btn.backgroundColor  = COLOR_F7F7F7;
            
            btn.tag = i+1;
            [self.view layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop createButton:btn imageTitleSpace:10];
            [_centreView addSubview:btn];
        }
        
        
        UIView *line;
        if (self.titleArray.count > 0) {
            line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+10, SCREEN_WIDTH, 0.5)];
            
        }else {
            
            line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(name.frame)+10, SCREEN_WIDTH, 0.5)];
        }
        line.backgroundColor = COLOR_CCCCCC;
        [_centreView addSubview:line];
        //查询客房设备接口
        
        UILabel *policy = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(line.frame)+20,120, 12) font:15 text:ADLString(@"客房政策") texeColor:COLOR_333333];
        [_centreView addSubview:policy];
        
        CGFloat policyconteH = [ADLUtils calculateString:self.model.expensePolicyDes rectSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) fontSize:10].height;
        UILabel *policyconte = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(policy.frame)+12,SCREEN_WIDTH - 40, policyconteH) font:10 text:self.model.expensePolicyDes texeColor:COLOR_666666];
        policyconte.numberOfLines = 0;
        [_centreView addSubview:policyconte];
        policyconte.numberOfLines = 0;
        //[policyconte sizeToFit];
        
        CGFloat attentionH = [ADLUtils calculateString:self.model.des rectSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) fontSize:10].height+10;
        
        UILabel *attentionline = [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(policyconte.frame)+20,SCREEN_WIDTH - 40, attentionH) font:10 text:nil texeColor:COLOR_666666];
        attentionline.layer.masksToBounds = YES;
        attentionline.layer.borderColor = COLOR_CCCCCC.CGColor;
        attentionline.layer.borderWidth = 0.5;
        // attention.layer.cornerRadius = 0.5;
        
        
        [_centreView addSubview:attentionline];
        
        UILabel *attention = [self.view createLabelFrame:CGRectMake(25,CGRectGetMaxY(policyconte.frame)+25,SCREEN_WIDTH - 50, attentionH-10) font:10 text:[NSString stringWithFormat:@"%@",self.model.des] texeColor:COLOR_666666];
        attention.numberOfLines = 0;
        [_centreView addSubview:attention];
        CGFloat viewH;
        if (self.titleArray.count > 0) {
            
            if (self.titleArray.count % 6 == 0) {
                viewH =self.titleArray.count/6 * 60;
            }else {
                viewH =self.titleArray.count/6 * 60 + 60;
            }
        }else {
            viewH = 0;
            
        }
        if (self.array.count > 0) {
            viewH = self.array.count * 35+viewH;
        }
        _centreView.frame = CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), SCREEN_WIDTH, viewH+70+attentionH);
        
    }
    return _centreView;
}
//酒店政策
//价格+预订

-(UIView *)bookView {
    if (!_bookView) {
        _bookView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 100,SCREEN_WIDTH, 100)];
        _bookView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = COLOR_CCCCCC;
        [_bookView addSubview:line];
        UILabel *priceLabel = [self.view createLabelFrame:CGRectMake(20,20,120, 12) font:12 text:nil texeColor:COLOR_666666];
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%.2f",ADLString(@"原价"),_model.price] attributes:attribtDic];
        
        // 赋值
        priceLabel.attributedText = attribtStr;
        [_bookView addSubview:priceLabel];
        
        UILabel *discountsPrice= [self.view createLabelFrame:CGRectMake(20,CGRectGetMaxY(priceLabel.frame)+10,120, 12) font:12 text:[NSString stringWithFormat:@"%@:%.2f",ADLString(@"优惠价"),self.model.discountsPrice] texeColor:COLOR_E0212A];
        [_bookView addSubview:discountsPrice];
        
        UIButton *bookingBtn = [self.view createButtonFrame:CGRectMake(_bookView.width- 100,20,80, 30) imageName:nil title:ADLString(@"立即预订") titleColor:[UIColor whiteColor] font:14 target:self action:@selector(changedaddbtn:)];
        bookingBtn.backgroundColor =COLOR_E0212A;
        bookingBtn.layer.masksToBounds = YES;;
        bookingBtn.layer.cornerRadius = 5;
        [_bookView addSubview:bookingBtn];
    }
    return _bookView;
}

-(void)changedaddbtn:(UIButton *)btn{
    ADLHotelOrderController *vc = [[ADLHotelOrderController alloc]init];
    vc.mode =self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(ADLBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[ADLBannerView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 200) position:ADLPagePositionCenetr style:ADLPageStyleRound];
    }
    return _bannerView;
}

-(NSMutableArray *)array {
    if (!_array) {
        //network是否有宽带 0：无 1：有免费，2：有收费",
        // wifi 是否有wifi 0：无 1：有免费，2：有收费",
        NSString *wifi;
        if(self.model.wifi == 1){
            wifi = @"免费无线WIFI";
            if(self.model.network == 1){
                wifi = @"免费无线WIFI, 免费宽带";
            }else   if(self.model.network == 2){
                wifi = @"无线WIFI收费, 宽带收费";
            }
        }else   if(self.model.wifi == 2){
            wifi = @"无线WIFI收费";
            
            if(self.model.network == 1){
                wifi = @"无线WIFI收费, 免费宽带";
            }else   if(self.model.network == 2){
                wifi = @"无线WIFI收费, 宽带收费";
            }
        }
        
        _array = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"房型:  %@",self.model.name],
                                                  [NSString stringWithFormat:@"可住:  %d人",self.model.guestNum],
                                                  [NSString stringWithFormat:@"宽带:  %@",wifi],
                                                  [NSString stringWithFormat:@"早餐:  %d份",self.model.breakfastNum],
                                                  @"客房设施:"]
                  ];
    }
    return _array;
}
@end
