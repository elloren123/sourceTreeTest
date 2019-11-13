//
//  ADLRecordDataView.h
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADLTextView;

@protocol ADLRecordDataViewDelegate <NSObject>

- (void)inputViewDidBeginEditing:(UIView *)inputView;

- (void)didClikImageViewWithIndex:(NSInteger)index;

- (void)didClickSubmitBtn:(NSMutableDictionary *)params;

@end

@interface ADLRecordDataView : UIView
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIView *briefView;
@property (weak, nonatomic) IBOutlet UIView *situationView;

@property (weak, nonatomic) IBOutlet UITextField *contactNameTF;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *contactEmailTF;

@property (weak, nonatomic) IBOutlet UILabel *licenseTypeLab;
@property (weak, nonatomic) IBOutlet UIButton *licenseTypeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *licenseImgView;
@property (weak, nonatomic) IBOutlet UIButton *licenseImgBtn;

@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;
@property (weak, nonatomic) IBOutlet UITextField *creditCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *licenseAreaLab;
@property (weak, nonatomic) IBOutlet UIButton *licenseAreaBtn;
@property (weak, nonatomic) IBOutlet UITextField *licenseAddressTF;
@property (weak, nonatomic) IBOutlet UILabel *establishDateLab;
@property (weak, nonatomic) IBOutlet UIButton *establishDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *openDueLab;
@property (weak, nonatomic) IBOutlet UIButton *openDueBtn;
@property (weak, nonatomic) IBOutlet UITextField *registerMoneyTF;
@property (weak, nonatomic) IBOutlet UIView *rangeView;
@property (weak, nonatomic) IBOutlet UILabel *idTypeLab;
@property (weak, nonatomic) IBOutlet UIButton *idTypeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *idImgView1;
@property (weak, nonatomic) IBOutlet UIButton *idImgBtn1;
@property (weak, nonatomic) IBOutlet UIImageView *idImgView2;
@property (weak, nonatomic) IBOutlet UIButton *idImgBtn2;

@property (weak, nonatomic) IBOutlet UITextField *cropNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cropIdNumTF;
@property (weak, nonatomic) IBOutlet UILabel *cropEffectDateLab;
@property (weak, nonatomic) IBOutlet UIButton *cropEffectDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *companyAreaLab;
@property (weak, nonatomic) IBOutlet UIButton *companyAreaBtn;
@property (weak, nonatomic) IBOutlet UITextField *companyAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *companyPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *personNameTF;
@property (weak, nonatomic) IBOutlet UITextField *personPhoneTF;

@property (weak, nonatomic) IBOutlet UIImageView *bankImgView;
@property (weak, nonatomic) IBOutlet UIButton *bankImgBtn;
@property (weak, nonatomic) IBOutlet UITextField *bankNumberTF;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, weak) id<ADLRecordDataViewDelegate> delegate;
@property (nonatomic, strong) ADLTextView *briefTV;
@property (nonatomic, strong) ADLTextView *situationTV;
@property (nonatomic, strong) ADLTextView *rangeTV;

///是否更新UIScrollView偏移
@property (nonatomic, assign) BOOL updateOffset;
///执照类型
@property (nonatomic, assign) NSInteger licenseType;
///证件类型
@property (nonatomic, assign) NSInteger documentType;
///项目所在地地区Id
@property (nonatomic, strong) NSString *projectAreaId;
///执照所在地地区Id
@property (nonatomic, strong) NSString *licenseAreaId;
///公司所在地地区Id
@property (nonatomic, strong) NSString *companyAreaId;
///成立日期
@property (nonatomic, strong) NSString *createTime;
///执照开始时间
@property (nonatomic, strong) NSString *licenseStartTime;
///执照结束时间
@property (nonatomic, strong) NSString *licenseEndTime;
///证件开始时间
@property (nonatomic, strong) NSString *legalPersonStartTime;
///证件结束时间
@property (nonatomic, strong) NSString *legalPersonEndTime;

@property (nonatomic, strong) UIImage *licenseImage;
@property (nonatomic, strong) UIImage *idImage1;
@property (nonatomic, strong) UIImage *idImage2;
@property (nonatomic, strong) UIImage *bankImage;
@property (nonatomic, strong) NSString *licenseImageUrl;
@property (nonatomic, strong) NSString *idImage1Url;
@property (nonatomic, strong) NSString *idImage2Url;
@property (nonatomic, strong) NSString *bankImageUrl;

- (void)updateInputWithDictionary:(NSDictionary *)dict;

- (void)setInputViewUneditable;

@end

