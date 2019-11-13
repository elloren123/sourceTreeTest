//
//  ADLPersonalInfoController.m
//  lockboss
//
//  Created by adel on 2019/4/18.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLPersonalInfoController.h"
#import "ADLEditImageController.h"
#import "ADLNicknameController.h"
#import "ADLImagePreView.h"
#import "ADLSheetView.h"

#import <JMessage/JMSGUser.h>

@interface ADLPersonalInfoController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *nickLab;
@property (nonatomic, strong) UILabel *emailLab;
@end

@implementation ADLPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"个人资料"];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, ROW_HEIGHT+12)];
    lab1.font = [UIFont systemFontOfSize:FONT_SIZE];
    lab1.textColor = COLOR_333333;
    lab1.text = @"头像";
    [bgView addSubview:lab1];
    
    UIImageView *idView1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, ROW_HEIGHT/2-1, 8, 14)];
    idView1.image = [UIImage imageNamed:@"tableView_indicator"];
    [bgView addSubview:idView1];
    
    UIButton *avaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROW_HEIGHT+12)];
    [avaBtn addTarget:self action:@selector(clickAvatarImageView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:avaBtn];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-28-ROW_HEIGHT+8, 10, ROW_HEIGHT-8, ROW_HEIGHT-8)];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.layer.cornerRadius = ROW_HEIGHT/2-4;
    iconView.userInteractionEnabled = YES;
    iconView.clipsToBounds = YES;
    [bgView addSubview:iconView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatarImageView)];
    [iconView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAvaterImageView:)];
    [iconView addGestureRecognizer:longPress];
    self.iconView = iconView;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(12, ROW_HEIGHT+12, SCREEN_WIDTH-12, 0.5)];
    line1.backgroundColor = SEPARATOR_COLOR;
    [bgView addSubview:line1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(12, ROW_HEIGHT+13, 100, ROW_HEIGHT)];
    lab2.font = [UIFont systemFontOfSize:FONT_SIZE];
    lab2.text = ADLString(@"nickname");
    lab2.textColor = COLOR_333333;
    [bgView addSubview:lab2];
    
    UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(122, ROW_HEIGHT+13, SCREEN_WIDTH-150, ROW_HEIGHT)];
    nickLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    nickLab.textAlignment = NSTextAlignmentRight;
    nickLab.textColor = COLOR_666666;
    [bgView addSubview:nickLab];
    self.nickLab = nickLab;
    
    UIImageView *idView2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, ROW_HEIGHT*1.5+6, 8, 14)];
    idView2.image = [UIImage imageNamed:@"tableView_indicator"];
    [bgView addSubview:idView2];
    
    UIButton *nickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ROW_HEIGHT+13, SCREEN_WIDTH, ROW_HEIGHT)];
    [nickBtn addTarget:self action:@selector(clickNickNameBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:nickBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(12, ROW_HEIGHT*2+13, SCREEN_WIDTH-12, 0.5)];
    line2.backgroundColor = SEPARATOR_COLOR;
    [bgView addSubview:line2];
    
    UILabel *lab3 = [[UILabel alloc] init];
    lab3.font = [UIFont systemFontOfSize:FONT_SIZE];
    lab3.textColor = COLOR_333333;
    lab3.text = @"账号";
    [bgView addSubview:lab3];
    
    UILabel *accLab = [[UILabel alloc] init];
    accLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    accLab.text = [ADLUserModel sharedModel].phone;
    accLab.textAlignment = NSTextAlignmentRight;
    accLab.textColor = COLOR_666666;
    [bgView addSubview:accLab];
    
    if ([ADLUserModel sharedModel].email.length > 1) {
        UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(12, ROW_HEIGHT*2+14, 100, ROW_HEIGHT)];
        lab4.font = [UIFont systemFontOfSize:FONT_SIZE];
        lab4.textColor = COLOR_333333;
        lab4.text = @"邮箱";
        [bgView addSubview:lab4];
        
        UILabel *emailLab = [[UILabel alloc] initWithFrame:CGRectMake(122, ROW_HEIGHT*2+14, SCREEN_WIDTH-134, ROW_HEIGHT)];
        emailLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        emailLab.text = [ADLUserModel sharedModel].email;
        emailLab.textAlignment = NSTextAlignmentRight;
        emailLab.textColor = COLOR_666666;
        [bgView addSubview:emailLab];
        self.emailLab = emailLab;
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(12, ROW_HEIGHT*3+14, SCREEN_WIDTH-12, 0.5)];
        line3.backgroundColor = SEPARATOR_COLOR;
        [bgView addSubview:line3];
        
        accLab.frame = CGRectMake(122, ROW_HEIGHT*3+15, SCREEN_WIDTH-134, ROW_HEIGHT);
        bgView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, ROW_HEIGHT*4+15);
        lab3.frame = CGRectMake(12, ROW_HEIGHT*3+15, 100, ROW_HEIGHT);
    } else {
        accLab.frame = CGRectMake(122, ROW_HEIGHT*2+14, SCREEN_WIDTH-134, ROW_HEIGHT);
        bgView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, ROW_HEIGHT*3+14);
        lab3.frame = CGRectMake(12, ROW_HEIGHT*2+14, 100, ROW_HEIGHT);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[ADLUserModel sharedModel].headShot] placeholderImage:[UIImage imageNamed:@"user_head"]];
    self.nickLab.text = [ADLUserModel sharedModel].nickName;
}

#pragma mark ------ 点击头像 ------
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
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerVC.navigationBar.tintColor = [UIColor blackColor];
        pickerVC.delegate = self;
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    [sheetView show];
}

#pragma mark ------ UIImagePickerControllerDelegate ------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    ADLEditImageController *editVC = [[ADLEditImageController alloc] init];
    editVC.image = image;
    editVC.finishBlock = ^(UIImage *image) {
        [ADLToast showLoadingMessage:@"头像上传中..."];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
        NSData *data = [ADLUtils compressImageQuality:image maxLength:IMAGE_MAX_LENGTH];
        
        [ADLNetWorkManager postImagePath:k_modify_headshot parameters:params imageDataArr:@[data] imageName:@"img" autoToast:YES progress:^(NSProgress *progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                double pro = progress.fractionCompleted*100;
                if (pro == 100) {
                    pro = 99;
                }
                [ADLToast showLoadingMessage:[NSString stringWithFormat:@"头像上传中(%d%%)",(int)pro]];
            });
        } success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"头像修改成功"];
                self.iconView.image = [UIImage imageWithData:data];
                ADLUserModel *model = [ADLUserModel sharedModel];
                model.headShot = responseDict[@"data"];
                [ADLUserModel saveUserModel:model];
                [JMSGUser updateMyAvatarWithData:data avatarFormat:@"jpg" completionHandler:^(id resultObject, NSError *error) {
                    
                }];
            }
        } failure:nil];
    };
    [picker pushViewController:editVC animated:NO];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIView *view = viewController.view;
    for (int i = 0; i < view.subviews.count; i++) {
        if ([[view.subviews[i] description] containsString:@"PLCropOverlay"]) {
            UIView *plView = view.subviews[i];
            [plView setValue:@"编辑"forKey:@"_defaultOKButtonTitle"];
        }
    }
}

#pragma mark ------ 长按头像 ------
- (void)longPressAvaterImageView:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan && [ADLUserModel sharedModel].headShot.length > 0) {
        [ADLImagePreView showWithImageViews:@[longPress.view]
                                   urlArray:@[[ADLUserModel sharedModel].headShot]
                               currentIndex:0];
    }
}

#pragma mark ------ 昵称 ------
- (void)clickNickNameBtn {
    ADLNicknameController *userNameVc = [[ADLNicknameController alloc] init];
    [self.navigationController pushViewController:userNameVc animated:YES];
}

@end
