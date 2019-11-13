//
//  ADLCommentVController.m
//  lockboss
//
//  Created by bailun91 on 2019/9/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLCommentVController.h"
#import "ADLImagePreView.h"
#import "ADLSheetView.h"
#import <Photos/Photos.h>
#import "ADLAlbumListController.h"
#import "ADLTextView.h"
#import "ADLTimeOrStamp.h"
#import "ADLKeyboardMonitor.h"
#import "ADLLocalImgPreView.h"
#import "ADLDeleteImageCell.h"


@interface ADLCommentVController ()<ADLTextViewDelegate, ADLDeleteImageCellDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIButton *noPleasedBtn;
@property (nonatomic, strong) UIButton *pleasedBtn;

@property (nonatomic, assign) BOOL     anonymousFlag;   //匿名Flag
@property (nonatomic, strong) UILabel  *levelLabel;     //评价等级label
@property (nonatomic, strong) UIButton *zongHeBtn1;
@property (nonatomic, strong) UIButton *zongHeBtn2;
@property (nonatomic, strong) UIButton *zongHeBtn3;
@property (nonatomic, strong) UIButton *zongHeBtn4;
@property (nonatomic, strong) UIButton *zongHeBtn5;
@property (nonatomic, assign) NSInteger zongHeIndex;
@property (nonatomic, strong) UIButton *weiShengBtn1;
@property (nonatomic, strong) UIButton *weiShengBtn2;
@property (nonatomic, strong) UIButton *weiShengBtn3;
@property (nonatomic, strong) UIButton *weiShengBtn4;
@property (nonatomic, strong) UIButton *weiShengBtn5;
@property (nonatomic, assign) NSInteger weiShengIndex;
@property (nonatomic, strong) UIButton *kouWeiBtn1;
@property (nonatomic, strong) UIButton *kouWeiBtn2;
@property (nonatomic, strong) UIButton *kouWeiBtn3;
@property (nonatomic, strong) UIButton *kouWeiBtn4;
@property (nonatomic, strong) UIButton *kouWeiBtn5;
@property (nonatomic, assign) NSInteger kouWeiIndex;

@property (nonatomic, strong) ADLTextView  *textview;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *ImgUrlArray; //上传图片路径集合
//菜品table
@property (nonatomic, strong) UITableView *goodTable;

@end

@implementation ADLCommentVController

/*
- (void)addNotifications {
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationView];
    [self createContentView];
    [[ADLKeyboardMonitor monitor] setEnable:YES];
}

- (void)createNavigationView {
    //导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navView.backgroundColor = COLOR_E0212A;
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    backBtn.tag = 101;
    [backBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, STATUS_HEIGHT, SCREEN_WIDTH/2, NAV_H)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor whiteColor];
    titLab.text = @"评论";
    [navView addSubview:titLab];
    
    
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44-BOTTOM_H, SCREEN_WIDTH, 44)];
    payBtn.backgroundColor = COLOR_E0212A;
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [payBtn setTitle:@"提交" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.tag = 102;
    [self.view addSubview:payBtn];
    
}
#pragma mark ------ 按钮点击事件 ------
- (void)clickBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        
        case 102:   //提交
            [self submitAction];
            break;

            
        case 201:
        case 202:
            if (!sender.selected) {
                sender.selected = !sender.selected;
                [self updateTwoButton:sender.tag];
            }
            break;
        
        case 301:   //匿名评价
            self.anonymousFlag = !self.anonymousFlag;
            sender.selected = !sender.selected;
            if (sender.selected) {
                [sender setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
            } else {
                [sender setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
            }
            break;
            
        case 401:
        case 402:
        case 403:
        case 404:
        case 405:   //综合评价btn
        case 501:
        case 502:
        case 503:
        case 504:
        case 505:   //卫生评价btn
        case 601:
        case 602:
        case 603:
        case 604:
        case 605:   //口味评价btn
            [self updateLevelBtns:sender.tag];
            break;
            
            
        default:    //刷新tableview
            [self updateTableView:sender.tag];
            break;
    }
}
- (void)submitAction {
    if (self.textview.text.length == 0 && self.ImgUrlArray.count == 0) {
        [ADLToast showMessage:@"请输入评价内容或上传图片 !"];
    } else {
        [self submitComment];
    }
}
- (void)updateTwoButton:(NSInteger)tag {
    if (tag == 201) {   //不满意
        self.noPleasedBtn.selected = YES;
        self.noPleasedBtn.backgroundColor = COLOR_E0212A;
        self.noPleasedBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.noPleasedBtn setImage:[UIImage imageNamed:@"icon_smile_W"] forState:UIControlStateNormal];
        [self.noPleasedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.pleasedBtn.selected = NO;
        self.pleasedBtn.backgroundColor = [UIColor clearColor];
        self.pleasedBtn.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
        [self.pleasedBtn setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        [self.pleasedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {   //满意
        self.noPleasedBtn.selected = NO;
        self.noPleasedBtn.backgroundColor = [UIColor clearColor];
        self.noPleasedBtn.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
        [self.noPleasedBtn setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        [self.noPleasedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.pleasedBtn.selected = YES;
        self.pleasedBtn.backgroundColor = COLOR_E0212A;
        self.pleasedBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.pleasedBtn setImage:[UIImage imageNamed:@"icon_smile_W"] forState:UIControlStateNormal];
        [self.pleasedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (void)updateLevelBtns:(NSInteger)tag {
    if (tag == 405) {   //5颗星
        if (self.zongHeIndex != 5) {
            self.zongHeIndex = 5;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'无可挑剔'";
        } else {
            self.zongHeIndex = 4;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'非常满意'";
        }
    } else if (tag == 404) {   //4颗星
        if (self.zongHeIndex != 4) {
            self.zongHeIndex = 4;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'非常满意'";
        } else {
            self.zongHeIndex = 3;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'满意'";
        }
    } else if (tag == 403) {   //3颗星
        if (self.zongHeIndex != 3) {
            self.zongHeIndex = 3;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'满意'";
        } else {
            self.zongHeIndex = 2;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'一般'";
        }
    } else if (tag == 402) {   //2颗星
        if (self.zongHeIndex != 2) {
            self.zongHeIndex = 2;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'一般'";
        } else {
            self.zongHeIndex = 1;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'不满意'";
        }
    } else if (tag == 401) {   //1颗星
        if (self.zongHeIndex != 1) {
            self.zongHeIndex = 1;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_B"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'不满意'";
        } else {
            self.zongHeIndex = 0;
            [self.zongHeBtn1 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn2 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn3 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn4 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            [self.zongHeBtn5 setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
            self.levelLabel.text = @"'非常不满意'";
        }
    } else if (tag == 505) {   //5个笑脸
        if (self.weiShengIndex != 5) {
            self.weiShengIndex = 5;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
        } else {
            self.weiShengIndex = 4;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    } else if (tag == 504) {   //4个笑脸
        if (self.weiShengIndex != 4) {
            self.weiShengIndex = 4;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        } else {
            self.weiShengIndex = 3;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    } else if (tag == 503) {   //3个笑脸
        if (self.weiShengIndex != 3) {
            self.weiShengIndex = 3;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        } else {
            self.weiShengIndex = 2;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    } else if (tag == 502) {   //2个笑脸
        if (self.weiShengIndex != 2) {
            self.weiShengIndex = 2;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        } else {
            self.weiShengIndex = 1;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    } else if (tag == 501) {   //1个笑脸
        if (self.weiShengIndex != 1) {
            self.weiShengIndex = 1;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        } else {
            self.weiShengIndex = 0;
            [self.weiShengBtn1 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn2 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.weiShengBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    } else if (tag == 605) {   //5个笑脸
        if (self.kouWeiIndex != 5) {
            self.kouWeiIndex = 5;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
        } else {
            self.kouWeiIndex = 4;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    } else if (tag == 604) {   //4个笑脸
        if (self.kouWeiIndex != 4) {
            self.kouWeiIndex = 4;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        } else {
            self.kouWeiIndex = 3;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    } else if (tag == 603) {   //3个笑脸
        if (self.kouWeiIndex != 3) {
            self.kouWeiIndex = 3;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        } else {
            self.kouWeiIndex = 2;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    } else if (tag == 602) {   //2个笑脸
        if (self.kouWeiIndex != 2) {
            self.kouWeiIndex = 2;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        } else {
            self.kouWeiIndex = 1;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    } else if (tag == 601) {   //1个笑脸
        if (self.kouWeiIndex != 1) {
            self.kouWeiIndex = 1;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_R"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        } else {
            self.kouWeiIndex = 0;
            [self.kouWeiBtn1 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn2 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn3 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn4 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
            [self.kouWeiBtn5 setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        }
    }
}
- (void)updateTableView:(NSInteger)tag {
    NSInteger index = tag/1000;
    NSInteger row   = tag%1000; //'赞'或'踩'
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.orderArray[index]];
    if (row == 1) {//'赞'
        if ([dict[@"flag"] intValue] != 1) {
            [dict setValue:@"1" forKey:@"flag"];
        } else {
            [dict setValue:@"0" forKey:@"flag"];
        }
        
        [self.orderArray replaceObjectAtIndex:index withObject:dict];
    } else {//'踩'
        if ([dict[@"flag"] intValue] != 2) {
            [dict setValue:@"2" forKey:@"flag"];
        } else {
            [dict setValue:@"0" forKey:@"flag"];
        }
        
        [self.orderArray replaceObjectAtIndex:index withObject:dict];
    }
    
    //刷新cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.goodTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)initOrderArrayData {
    NSArray *orderGoods = self.orderDict[@"orderGoods"];
    if (orderGoods.count == 0) {
        return;
        
    } else {
        self.orderArray = [NSMutableArray array];
        for (int i = 0 ; i < orderGoods.count; i++) {
            [self.orderArray addObject:@{@"flag":@"0"}];
        }
    }
}
- (void)createContentView {
    //初始化数据
    [self initOrderArrayData];
    self.ImgUrlArray = [NSMutableArray array];
    
    NSInteger number = [self.orderDict[@"orderGoods"] count];
    NSLog(@"number = %zd", number);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-49-BOTTOM_H)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(0, 595+number*30);
    [self.view addSubview:scrollView];
    self.scrollview = scrollView;
    
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    headView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:headView];
    
    //headicon
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    headImg.layer.cornerRadius = 20.0;
    [headImg sd_setImageWithURL:[NSURL URLWithString:[ADLUserModel sharedModel].headShot] placeholderImage:[UIImage imageNamed:@"user_head"]];
//    headImg.clipsToBounds = YES;
    headImg.layer.masksToBounds = YES;
    [headView addSubview:headImg];
    
    
    //送达时间
    UILabel *sendTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, SCREEN_WIDTH-70, 50)];
    sendTimeLab.textAlignment = NSTextAlignmentLeft;
    sendTimeLab.font = [UIFont systemFontOfSize:14];
    sendTimeLab.textColor = [UIColor blackColor];
    sendTimeLab.text = [NSString stringWithFormat:@"%@左右送达", [ADLTimeOrStamp getTimeFromTimestamp:[self.orderDict[@"appointmentTime"] doubleValue]/1000 format:@"YYYY-MM-dd HH:mm"]];
    [headView addSubview:sendTimeLab];
    NSLog(@"预约时间戳: %@", self.orderDict[@"appointmentTime"]);
    
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    line.backgroundColor = SEPARATOR_COLOR;
    [headView addSubview:line];
    
    
    UIButton *nopleasedBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/9, 60, SCREEN_WIDTH/3, 40)];
    nopleasedBtn.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
    nopleasedBtn.layer.borderWidth = 1.0;
    nopleasedBtn.layer.cornerRadius = 20.0;
    [nopleasedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nopleasedBtn.titleLabel.font = [UIFont systemFontOfSize:15.5];
    [nopleasedBtn setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
    [nopleasedBtn setTitle:@"不满意" forState:UIControlStateNormal];
    [nopleasedBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    nopleasedBtn.tag = 201;
    [headView addSubview:nopleasedBtn];
    self.noPleasedBtn = nopleasedBtn;
    
    UIButton *pleasedBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*5/9, 60, SCREEN_WIDTH/3, 40)];
    pleasedBtn.backgroundColor = COLOR_E0212A;
    pleasedBtn.layer.borderColor = [UIColor clearColor].CGColor;
    pleasedBtn.layer.borderWidth = 1.0;
    pleasedBtn.layer.cornerRadius = 20.0;
    [pleasedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pleasedBtn.titleLabel.font = [UIFont systemFontOfSize:15.5];
    [pleasedBtn setImage:[UIImage imageNamed:@"icon_smile_W"] forState:UIControlStateNormal];
    [pleasedBtn setTitle:@"满意" forState:UIControlStateNormal];
    [pleasedBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    pleasedBtn.tag = 202;
    pleasedBtn.selected = YES;
    [headView addSubview:pleasedBtn];
    self.pleasedBtn = pleasedBtn;
    
    
    
    //------ *** ------
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, SCREEN_WIDTH, 480+number*30)];
    infoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:infoView];
    
    //商家图片
    UIImageView *shopImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    [shopImg sd_setImageWithURL:[NSURL URLWithString:self.orderDict[@"shopImg"]] placeholderImage:[UIImage imageNamed:@"icon_kong-1"]];
    [infoView addSubview:shopImg];
    
    //送达时间label
    UILabel *shopNameLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH/2, 50)];
    shopNameLab.textAlignment = NSTextAlignmentLeft;
    shopNameLab.font = [UIFont systemFontOfSize:15.5];
    shopNameLab.textColor = [UIColor blackColor];
    shopNameLab.text = self.orderDict[@"shopName"];
    [infoView addSubview:shopNameLab];
    
    
    self.anonymousFlag = NO;
    
    //匿名评价按钮
    UIButton *markBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4-10, 5, SCREEN_WIDTH/4, 40)];
    [markBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    markBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [markBtn setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
    [markBtn setTitle:@"匿名评价" forState:UIControlStateNormal];
    [markBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    markBtn.tag = 301;
    markBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [infoView addSubview:markBtn];
    
    //分割线
    UIView *infoLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    infoLine.backgroundColor = SEPARATOR_COLOR;
    [infoView addSubview:infoLine];
    
    
    //综合评价等级label
    UILabel *levelLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, SCREEN_WIDTH, 35)];
    levelLab.textAlignment = NSTextAlignmentCenter;
    levelLab.font = [UIFont systemFontOfSize:15.5];
    levelLab.textColor = [UIColor blackColor];
    levelLab.text = @"'评价等级'";
    [infoView addSubview:levelLab];
    self.levelLabel = levelLab;
    
    NSArray *txtarray = @[@"综合", @"卫生", @"口味"];
    for (int i = 0 ; i < 3; i++) {
        UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 85+35*i, SCREEN_WIDTH/4, 35)];
        txtLab.textAlignment = NSTextAlignmentRight;
        txtLab.font = [UIFont systemFontOfSize:15.5];
        txtLab.textColor = [UIColor darkGrayColor];
        txtLab.text = txtarray[i];
        [infoView addSubview:txtLab];
    }
    
    //综合评价
    self.zongHeIndex = 0;
    for (int i = 0 ; i < 5; i++) {
        UIButton *starBtn = [[UIButton alloc] initWithFrame:CGRectMake(20+SCREEN_WIDTH/4+40*i, 90, 24, 24)];
        [starBtn setImage:[UIImage imageNamed:@"icon_xing_G"] forState:UIControlStateNormal];
        [starBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        starBtn.tag = 401+i;
        [infoView addSubview:starBtn];
        
        if (i == 0) {
            self.zongHeBtn1 = starBtn;
        } else if (i == 1) {
            self.zongHeBtn2 = starBtn;
        } else if (i == 2) {
            self.zongHeBtn3 = starBtn;
        } else if (i == 3) {
            self.zongHeBtn4 = starBtn;
        } else if (i == 4) {
            self.zongHeBtn5 = starBtn;
        }
    }
    
    //卫生评价
    self.weiShengIndex = 0;
    for (int i = 0 ; i < 5; i++) {
        UIButton *weishengBtn = [[UIButton alloc] initWithFrame:CGRectMake(20+SCREEN_WIDTH/4+40*i, 125, 24, 24)];
        [weishengBtn setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        [weishengBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        weishengBtn.tag = 501+i;
        [infoView addSubview:weishengBtn];
        
        if (i == 0) {
            self.weiShengBtn1 = weishengBtn;
        } else if (i == 1) {
            self.weiShengBtn2 = weishengBtn;
        } else if (i == 2) {
            self.weiShengBtn3 = weishengBtn;
        } else if (i == 3) {
            self.weiShengBtn4 = weishengBtn;
        } else if (i == 4) {
            self.weiShengBtn5 = weishengBtn;
        }
    }
    
    //口味评价
    self.kouWeiIndex = 0;
    for (int i = 0 ; i < 5; i++) {
        UIButton *kouWeiBtn = [[UIButton alloc] initWithFrame:CGRectMake(20+SCREEN_WIDTH/4+40*i, 160, 24, 24)];
        [kouWeiBtn setImage:[UIImage imageNamed:@"icon_smile_G"] forState:UIControlStateNormal];
        [kouWeiBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        kouWeiBtn.tag = 601+i;
        [infoView addSubview:kouWeiBtn];
        
        if (i == 0) {
            self.kouWeiBtn1 = kouWeiBtn;
        } else if (i == 1) {
            self.kouWeiBtn2 = kouWeiBtn;
        } else if (i == 2) {
            self.kouWeiBtn3 = kouWeiBtn;
        } else if (i == 3) {
            self.kouWeiBtn4 = kouWeiBtn;
        } else if (i == 4) {
            self.kouWeiBtn5 = kouWeiBtn;
        }
    }
    
    
    //输入框
    ADLTextView *textView = [ADLTextView textViewWithFrame:CGRectMake(15, 190, SCREEN_WIDTH-30, 150) limitLength:200];
    textView.bgColor = SEPARATOR_COLOR;
    textView.placeholder = @"亲, 菜品口味如何, 对包装等服务还满意吗?";
    textView.delegate = self;
    [infoView addSubview:textView];
    self.textview = textView;
    
    
    //上传图片
    UILabel *loadLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 350, SCREEN_WIDTH-90, 40)];
    loadLab.textAlignment = NSTextAlignmentLeft;
    loadLab.font = [UIFont systemFontOfSize:16];
    loadLab.textColor = [UIColor darkGrayColor];
    loadLab.text = @"上传图片";
    [infoView addSubview:loadLab];
    
    
    //------ ** UICollectionView ** -------
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 80);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 4;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 390, SCREEN_WIDTH-30, 80) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [infoView addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[ADLDeleteImageCell class] forCellWithReuseIdentifier:@"ADLDeleteImageCell"];

    
    
    //商品table
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 475, SCREEN_WIDTH, 30*number)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 30;
    [infoView addSubview:tableView];
    self.goodTable = tableView;
}

- (void)clickAvatarImageView {
    ADLSheetView *sheetView = [ADLSheetView sheetViewWithTitle:nil];
    [sheetView addActionWithTitle:ADLString(@"take_photo") handler:^{
        ADLCameraStatus status = [ADLUtils getCameraStatus];
        if (status == ADLCameraStatusDenied) {
            [ADLAlertView showWithTitle:ADLString(@"cannot_photo") message:ADLString(@"camera_permission") confirmTitle:nil confirmAction:^{
                [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
            } cancleTitle:nil cancleAction:nil showCancle:YES];
        } else if (status == ADLCameraStatusAllow) {
            UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
            pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerVc.delegate = self;
            [self presentViewController:pickerVc animated:YES completion:nil];
        } else {
            [ADLAlertView showWithTitle:ADLString(@"cannot_photo") message:ADLString(@"photo_camera") confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
        }
    }];
    [sheetView addActionWithTitle:ADLString(@"select_photo") handler:^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    ADLAlbumListController *albumVC = [[ADLAlbumListController alloc] init];
                    albumVC.maxCount = 4;
                    albumVC.currentCount = self.dataArr.count;
                    albumVC.finish = ^(NSArray *imageArr) {
                        if (imageArr.count > 0) {
                            NSLog(@"count = %zd", (NSInteger)imageArr.count);
                            [self uploadImage:imageArr[0]];//上传图片
                        }
                    };
                    [self customPushViewController:albumVC];
                } else {
                    [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:ADLString(@"photo_permission") confirmTitle:nil confirmAction:^{
                        [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
                    } cancleTitle:nil cancleAction:nil showCancle:YES];
                }
            });
        }];
    }];
    [sheetView show];
}
#pragma mark ------ 开始输入 ------
- (void)textViewDidBeginEdit:(UIView *)textView {
    CGFloat offsetY = self.scrollview.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:textView];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            [weakSelf.scrollview setContentOffset:CGPointMake(0, offsetY) animated:YES];
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.scrollview setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
}
#pragma mark ------ 输入改变 ------
- (void)textViewDidChangeText:(NSString *)text {
    self.textview.text = text;
}

#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (orderCell == nil) {
        orderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        while ([orderCell.contentView.subviews lastObject] != nil) {
            [(UIView*)[orderCell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    //自定义view
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *dinnerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH/2, 30)];
    dinnerLab.textAlignment = NSTextAlignmentLeft;
    dinnerLab.font = [UIFont systemFontOfSize:15];
    dinnerLab.textColor = [UIColor darkGrayColor];
    dinnerLab.text = [[self.orderDict[@"orderGoods"] objectAtIndex:indexPath.row] objectForKey:@"goodsName"];
    [content addSubview:dinnerLab];
    
    
    UIButton *zanBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-155, 0, 68, 30)];
    [zanBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    zanBtn.tag = 1+indexPath.row*1000;
    zanBtn.selected = YES;
    [content addSubview:zanBtn];
    
    
    UIButton *caiBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 68, 30)];
    [caiBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    caiBtn.tag = 2+indexPath.row*1000;
    [content addSubview:caiBtn];
    
    NSDictionary *dict = self.orderArray[indexPath.row];
    if ([dict[@"flag"] intValue] == 0) { //不赞不踩
        [zanBtn setImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
        [caiBtn setImage:[UIImage imageNamed:@"icon_cai"] forState:UIControlStateNormal];
    } else if ([dict[@"flag"] intValue] == 1) {//赞
        [zanBtn setImage:[UIImage imageNamed:@"icon_zanxuanzh"] forState:UIControlStateNormal];
        [caiBtn setImage:[UIImage imageNamed:@"icon_cai"] forState:UIControlStateNormal];
    } else if ([dict[@"flag"] intValue] == 2) {//踩
        [zanBtn setImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
        [caiBtn setImage:[UIImage imageNamed:@"icon_caixuanzhong"] forState:UIControlStateNormal];
    }
    
    
    [orderCell.contentView addSubview:content];
    return orderCell;
}


#pragma mark ------ UICollectionView ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArr.count < 4) {
        return self.dataArr.count+1;
    } else {
        return 4;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLDeleteImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADLDeleteImageCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.item < self.dataArr.count) {
        cell.deleteBtn.hidden = NO;
        cell.imgView.image = self.dataArr[indexPath.item];
    } else {
        cell.deleteBtn.hidden = YES;
        cell.imgView.image = [UIImage imageNamed:@"img_add"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.item == self.dataArr.count) {
        if (self.dataArr.count < 3) {
            [self clickAvatarImageView];
       
        } else {
            [ADLToast showMessage:@"最多只能上传3张图片"];
        }
    } else {
        NSMutableArray *imgViewArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.dataArr.count; i++) {
            ADLDeleteImageCell *cell = (ADLDeleteImageCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [imgViewArr addObject:cell.imgView];
        }
        [ADLLocalImgPreView showWithImageViews:imgViewArr currentIndex:indexPath.item];
    }
}
#pragma mark ------ 删除图片 ------
- (void)didClickDeleteBtn:(UIButton *)sender {
    ADLDeleteImageCell *cell = (ADLDeleteImageCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.dataArr removeObjectAtIndex:indexPath.item];
    [self.collectionView reloadData];
    
    //移除照片路径
    [self.ImgUrlArray removeObjectAtIndex:indexPath.item];
    NSLog(@"照片数量: %zd", self.ImgUrlArray.count);
}

#pragma mark ------ UIImagePickerControllerDelegate ------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSLog(@"image = %@", image);
    [self uploadImage:image];//上传图片
}

#pragma mark ------ 上传图片 ------
- (void)uploadImage:(UIImage *)image {
    [ADLToast showLoadingMessage:@"图片上传中..."];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    NSData *data = [ADLUtils compressImageQuality:image maxLength:IMAGE_MAX_LENGTH];
    
    [ADLNetWorkManager postImagePath:[ADLUtils splicingPath:@"hotel-around/imgs/upload.do"] parameters:params imageDataArr:@[data] imageName:@"img" autoToast:YES progress:^(NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double pro = progress.fractionCompleted*100;
            if (pro == 100) {
                pro = 99;
            }
            [ADLToast showLoadingMessage:[NSString stringWithFormat:@"图片上传中(%d%%)",(int)pro]];
        });
    } success:^(NSDictionary *responseDict) {
        NSLog(@"上传图片返回: responseDict = %@", responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"图片上传成功"];
            NSArray *imgArr = responseDict[@"data"];
            [self.ImgUrlArray addObject:imgArr[0][@"filePath"]];
            
            [self.dataArr addObject:image];
            [self.collectionView reloadData];
            
        } else {
            [ADLToast showMessage:@"图片上传失败"];
        }
    } failure:^(NSError *error) {
        NSString *title = @"网络出错";
        if (error.code == -1004) {
            title = @"未能连接到服务器";
        } else if (error.code == -1001){
            title = @"网络超时";
        }
        [ADLToast showMessage:title];
    }];
}

#pragma mark ------ 提交评论 ------
- (void)submitComment {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.orderDict[@"id"]   forKey:@"orderId"];
    [params setValue:[self getType]          forKey:@"type"]; //类型
    [params setValue:@(self.zongHeIndex)     forKey:@"description"]; //综合得分
    [params setValue:@(self.kouWeiIndex)     forKey:@"pack"]; //口味得分
    [params setValue:@(self.weiShengIndex)   forKey:@"hygiene"]; //卫生评分
    [params setValue:self.textview.text      forKey:@"content"]; //评论内容
    [params setValue:[self getImgUrlStr]     forKey:@"imgUrl"]; //评论图片
    [params setValue:[NSString stringWithFormat:@"%d", self.anonymousFlag] forKey:@"anonymous"]; //是否匿名评价: 0否; 1是;
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    int shipValue = (self.pleasedBtn.selected == YES)?5:1;
    [params setValue:@(shipValue) forKey:@"ship"]; //配送得分
    
    NSLog(@"评价参数: %@", params);
    
    ///请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/evaluate/add.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
        NSLog(@"提交评论返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast showMessage:@"成功!"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [ADLToast showMessage:responseDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (error.code == -1001) {
            [ADLToast showMessage:@"网络请求超时!"];
        } else {
            [ADLToast hide];
        }
    }];
}
- (NSNumber *)getType {
    if (self.textview.text.length == 0) {//只有图片
        return @(2);
    } else if (self.ImgUrlArray.count == 0) {//只有文字
        return @(0);
        
    } else {
        return @(3);
    }
}
- (NSString *)getImgUrlStr {
    if (self.ImgUrlArray.count == 0) {
        return nil;
        
    } else if (self.ImgUrlArray.count == 1) {
        NSString *imgUrl = self.ImgUrlArray[0];
        return imgUrl;
        
    } else {
        NSString *imgUrl = self.ImgUrlArray[0];
        for (int i = 1 ; i < self.ImgUrlArray.count; i++) {
            imgUrl = [NSString stringWithFormat:@"%@,%@", imgUrl, self.ImgUrlArray[i]];
        }
        
        return imgUrl;
    }
}

- (void)dealloc {
     [[ADLKeyboardMonitor monitor] setEnable:NO];
}

@end
