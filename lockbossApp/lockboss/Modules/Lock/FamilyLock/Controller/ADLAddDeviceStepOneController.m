//
//  ADLAddDeviceStepOneController.m
//  lockboss
//
//  Created by adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAddDeviceStepOneController.h"
#import "ADLDeviceTypeModel.h"
#import "ADLAddDeviceStepTwoController.h"
@interface OneStepView : UIView

//+(instancetype)initWithFrame:(CGRect)rect imgName:(NSString *)imgName stepTitArr:(NSArray *)titArray;

@property (nonatomic ,strong)NSArray *mesArr;


@end
@implementation OneStepView

//+(instancetype)initWithFrame:(CGRect)rect imgName:(NSString *)imgName stepTitArr:(NSArray *)titArray{
//    ADLLog(@"%@",titArray);
//    return [self initWithFrame:rect imgName:imgName stepTitArr:titArray];
//}
//- (instancetype)initWithFrame:(CGRect)rect imgName:(NSString *)imgName stepTitArr:(NSArray *)titArray{
//    if (self = [super initWithFrame:rect]) {
////        [self setSubViewsWithImgName:imgName stepTitArr:titArray];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setSubViewsWithImgName:(NSString *)imgName stepTitArr:(NSArray *)titArray{
    UIView *subView = [[UIView alloc] init];
    [self addSubview:subView];
    
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(164);
    }];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    UIImage *img = [UIImage imageNamed:imgName];
    imgView.image = img;
    [subView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(subView.mas_left).offset(10);
        make.centerY.mas_equalTo(imgView.mas_centerY).offset(10);
        make.width.mas_equalTo(img.size.width);
        make.height.mas_equalTo(img.size.height);
    }];
    
    UILabel *oneLab =  [self createLabelFrame:CGRectZero font:16 text:titArray[0] texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
//    oneLab.text = titArray[0];
//    oneLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
//    oneLab.font = [UIFont systemFontOfSize:16];
//    [self createLabelFrame:CGRectZero font:16 text:titArray[0] texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
    
    UILabel *twoLab =  [self createLabelFrame:CGRectZero font:12 text:titArray[1] texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
    
    UILabel *ThreeLab =  [self createLabelFrame:CGRectZero font:12 text:titArray[2] texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
    [subView addSubview:oneLab];
    [subView addSubview:twoLab];
    [subView addSubview:ThreeLab];
    
    [oneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_top).offset(38);
        make.left.mas_equalTo(imgView.mas_right).offset(10);
        make.right.mas_equalTo(subView.mas_right).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [twoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oneLab.mas_bottom).offset(20);
        make.left.mas_equalTo(imgView.mas_right).offset(10);
        make.right.mas_equalTo(subView.mas_right).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [ThreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(twoLab.mas_bottom).offset(10);
        make.left.mas_equalTo(imgView.mas_right).offset(10);
        make.right.mas_equalTo(subView.mas_right).offset(0);
        make.height.mas_equalTo(20);
    }];
    
}



@end

@interface TwoStepView : UIView

@end

@implementation TwoStepView



@end



@interface ADLAddDeviceStepOneController ()

@property (nonatomic ,strong) UIView *oneStpView;

@property (nonatomic ,strong) UIButton *SureBtn;
@property (nonatomic ,strong) UIButton *nextStepBtn;
@end

@implementation ADLAddDeviceStepOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addRedNavigationView:@"配置向导"];
    [self.view addSubview:self.oneStpView];
    
    UIButton *SureBtn = [[UIButton alloc] init];//WithFrame:CGRectMake(0, NAVIGATION_H+249, SCREEN_WIDTH, 15)
    SureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    SureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [SureBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    [SureBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
    [SureBtn setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
    [SureBtn setSelected:NO];
    [SureBtn setTitle:@"已确认上述操作" forState:UIControlStateNormal];
    [SureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SureBtn];
    self.SureBtn = SureBtn;
    [self.SureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-BOTTOM_H-46-40-20);
        make.height.mas_equalTo(14);
    }];
    
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepBtn setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
    [nextStepBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    nextStepBtn.userInteractionEnabled = NO;
    [self.view addSubview:nextStepBtn];
    self.nextStepBtn = nextStepBtn;
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.top.mas_equalTo(self.SureBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    
}
-(void)clickSureBtn{
    self.SureBtn.selected = !self.SureBtn.selected;
    if (self.SureBtn.selected) {
        [self.nextStepBtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:47/255.0 blue:45/255.0 alpha:1.0]];
        self.nextStepBtn.userInteractionEnabled = YES;
    }else{
        [self.nextStepBtn setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
        self.nextStepBtn.userInteractionEnabled = NO;
    }
}
-(void)clickNextBtn{
    ADLAddDeviceStepTwoController *twoStepVC = [[ADLAddDeviceStepTwoController alloc] init];
    twoStepVC.deviceTypeModel = self.deviceTypeModel;
    [self.navigationController pushViewController:twoStepVC animated:YES];
}

-(UIView *)oneStpView {
    if (!_oneStpView) {
        _oneStpView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-120-NAVIGATION_H)];
        _oneStpView.backgroundColor = [UIColor whiteColor];
        UIView *subView = [[UIView alloc] init];
        [_oneStpView addSubview:subView];
        
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ceilf(SCREEN_HEIGHT*10/667));
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        UIImage *img = [UIImage imageNamed:@"icon_addgateway_one"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = img;
        [subView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(subView.mas_left).offset(0);
            make.top.mas_equalTo(subView.mas_top).offset(0);
            make.width.mas_equalTo(ceilf(SCREEN_WIDTH*220/375));
//            make.height.mas_equalTo(img.size.height);
        }];
        NSArray *titArray =  @[@"第一步",@"使用卡针，长按配对建5秒",@"*添加之前请确保已接通电源"];
        UILabel *oneLab =  [_oneStpView createLabelFrame:CGRectZero font:16 text:titArray[0] texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        oneLab.textAlignment = NSTextAlignmentRight;
        UILabel *twoLab =  [_oneStpView createLabelFrame:CGRectZero font:10 text:titArray[1] texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        twoLab.textAlignment = NSTextAlignmentRight;
        UILabel *ThreeLab =  [_oneStpView createLabelFrame:CGRectZero font:10 text:titArray[2] texeColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
        ThreeLab.textAlignment = NSTextAlignmentRight;
        [subView addSubview:oneLab];
        [subView addSubview:twoLab];
        [subView addSubview:ThreeLab];
        
        [oneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView.mas_top).offset(38);
            make.left.mas_equalTo(imgView.mas_right).offset(-20);
            make.right.mas_equalTo(subView.mas_right).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [twoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(oneLab.mas_bottom).offset(20);
            make.left.mas_equalTo(imgView.mas_right).offset(-20);
            make.right.mas_equalTo(subView.mas_right).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [ThreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(twoLab.mas_bottom).offset(10);
            make.left.mas_equalTo(imgView.mas_right).offset(-20);
            make.right.mas_equalTo(subView.mas_right).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        //****************
        UIImageView *imgView_two = [[UIImageView alloc]init];
        imgView_two.contentMode = UIViewContentModeScaleAspectFit;
        if ([self.deviceTypeModel.deviceType isEqualToString:@"41"]) {
           imgView_two.image = [UIImage imageNamed:@"icon_addgateway_two"];
        }else {
           imgView_two.image = [UIImage imageNamed:@"icon_addgateway_three"];
        }
        [subView addSubview:imgView_two];
        
        [imgView_two mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(subView.mas_right).offset(-10);
            make.top.mas_equalTo(imgView.mas_bottom).offset(ceilf(SCREEN_HEIGHT*60/667));
            make.width.mas_equalTo(SCREEN_WIDTH*130/375);
        }];
        
        
        NSArray *titArray_two = [NSArray array];
        if ([self.deviceTypeModel.deviceType isEqualToString:@"41"]) {
            //燃气阀
            titArray_two = @[@"第二步",@"接通燃气阀电源，使用卡针长按控制器\n右下角配对按钮3秒，指示灯为绿色闪烁"];
        }else {
            
            titArray_two = @[@"第二步",@"打开储物箱箱门，在门后面找到这 个小红按钮按一下",@"*添加之前请保证储物箱的电池已 经正确安装"];
        }
        
        UILabel *fourLab =  [_oneStpView createLabelFrame:CGRectZero font:16 text:titArray_two[0] texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        UILabel *fivelab =  [_oneStpView createLabelFrame:CGRectZero font:10 text:titArray_two[1] texeColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        fivelab.numberOfLines = 2;
        
        UILabel *sixlab =  [_oneStpView createLabelFrame:CGRectZero font:10 text:@"" texeColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
        sixlab.numberOfLines = 2;
        if ([self.deviceTypeModel.deviceType isEqualToString:@"51"]) {
            sixlab.hidden = NO;
            sixlab.text = @"*添加之前请保证储物箱的电池已 经正确安装";
        }else {
            sixlab.hidden = YES;
        }
        [subView addSubview:fourLab];
        [subView addSubview:fivelab];
        [subView addSubview:sixlab];
        
        [fourLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView_two.mas_top).offset(28);
            make.left.mas_equalTo(subView.mas_left).offset(16);
            make.right.mas_equalTo(imgView_two.mas_left).offset(0);
            make.height.mas_equalTo(20);
        }];
        
        [fivelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(fourLab.mas_bottom).offset(20);
            make.left.mas_equalTo(subView.mas_left).offset(16);
            make.right.mas_equalTo(imgView_two.mas_left).offset(0);
            make.height.mas_equalTo(40);
        }];
        [sixlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(fivelab.mas_bottom).offset(0);
            make.left.mas_equalTo(subView.mas_left).offset(16);
            make.right.mas_equalTo(imgView_two.mas_left).offset(0);
            make.height.mas_equalTo(40);
        }];
    }
    return _oneStpView;
}


@end
