//
//  ADLLeagueDataView.h
//  lockboss
//
//  Created by adel on 2019/6/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADLTextView;

@protocol ADLLeagueDataViewDelegate <NSObject>

- (void)leagueInputViewDidBeginEditing:(UIView *)inputView;

- (void)didClickSubmitBtn:(NSMutableDictionary *)params;

- (void)updateScrollViewContentOffset;

@end

@interface ADLLeagueDataView : UIView

@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *personTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UITextField *businessTF;
@property (weak, nonatomic) IBOutlet UITextField *taxTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *faxTF;
@property (weak, nonatomic) IBOutlet UITextField *mailTF;
@property (weak, nonatomic) IBOutlet UILabel *lockTypeLab;
@property (weak, nonatomic) IBOutlet UIButton *lockTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UILabel *energyLab;
@property (weak, nonatomic) IBOutlet UIButton *energyBtn;
@property (weak, nonatomic) IBOutlet UILabel *fundLab;
@property (weak, nonatomic) IBOutlet UIButton *fundBtn;
@property (weak, nonatomic) IBOutlet UIButton *haveBtn;
@property (weak, nonatomic) IBOutlet UIButton *rentBtn;
@property (weak, nonatomic) IBOutlet UITextField *meterTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *totalTF;
@property (weak, nonatomic) IBOutlet UITextField *salesmanTF;
@property (weak, nonatomic) IBOutlet UITextField *techniqueTF;
@property (weak, nonatomic) IBOutlet UITextField *otherTF;
@property (weak, nonatomic) IBOutlet UILabel *meritLab;
@property (weak, nonatomic) IBOutlet UIButton *meritBtn;
@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

///备案人申请Id
@property (nonatomic, strong) NSString *leagueId;

///申请原因TextView
@property (nonatomic, strong) ADLTextView *textView;

///申请行业
@property (nonatomic, assign) NSInteger industry;

///申请地区
@property (nonatomic, strong) NSString *areaId;

///投入精力
@property (nonatomic, assign) NSInteger type;

///投资规模
@property (nonatomic, assign) NSInteger money;

///公司优势
@property (nonatomic, assign) NSInteger advantage;

///是否更新UIScrollView偏移
@property (nonatomic, assign) BOOL updateOffset;

///代理
@property (nonatomic, weak) id<ADLLeagueDataViewDelegate> delegate;

///更新输入信息
- (void)updateInputViewWithDictionary:(NSDictionary *)dict;

///设置不可编辑
- (void)setInputViewUneditable;

@end

