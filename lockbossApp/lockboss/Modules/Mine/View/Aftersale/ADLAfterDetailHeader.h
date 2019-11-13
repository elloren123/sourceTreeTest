//
//  ADLAftersaleProView.h
//  lockboss
//
//  Created by adel on 2019/7/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADLAftersaleProViewDelegate <NSObject>

- (void)didClickProgressDetailBtn;

- (void)didClickSubmitExpBtn;

@end

@interface ADLAfterDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *receiverLab;
@property (weak, nonatomic) IBOutlet UILabel *postLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *expLab;
@property (weak, nonatomic) IBOutlet UIButton *expBtn;
@property (weak, nonatomic) IBOutlet UITextField *expTF;
@property (weak, nonatomic) IBOutlet UIView *expView1;
@property (weak, nonatomic) IBOutlet UIView *expView2;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *listTitLab;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) NSArray *expArr;
@property (nonatomic, strong) NSDictionary *expDict;
@property (nonatomic, weak) id<ADLAftersaleProViewDelegate> delegate;
- (void)addProgressViewWithTitles:(NSArray *)titles progress:(NSInteger)progress;
@end

