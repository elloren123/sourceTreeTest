//
//  ADLBlockchainQueryHeadView.m
//  ADEL-APP
//
//  Created by adel on 2019/8/23.
//

#import "ADLBlockchainQueryHeadView.h"
#import "ADLUserModel.h"
@interface ADLBlockchainQueryHeadView ()

@end

@implementation ADLBlockchainQueryHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
  
        [self addsubView];
        
    }
    return self;
}
-(void)addsubView
{
    UILabel *title = [self createLabelFrame:CGRectMake(20, 10, 100, 18) font:16 text:ADLString(@"查询权限") texeColor:COLOR_333333];
    [self addSubview:title];
    

    int width = self.width - 40;//格子的宽
    
    int height = 25;//格子的高
    
    for (int i= 0;i<2;i++) {
        
        if (i == 0) {
            
            NSString *nickName =[ADLUserModel readUserModel].phone;
            if (nickName.length == 0) {
                nickName =[ADLUserModel readUserModel].email;
            }
            UIButton *btn = [self createButtonFrame:CGRectMake(20, 40+i*(height+15),width, height) imageName:nil title:[NSString stringWithFormat:@"%@:%@",ADLString(@"账号"),nickName] titleColor:COLOR_333333 font:12 target:self action:nil];
            btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;

            [self addSubview:btn];
        }
        if (i == 1) {
            UIButton *lockbtn = [self createButtonFrame:CGRectMake(20, 40+i*(height+15),width, height) imageName:nil title:ADLString(@"选择门锁") titleColor:COLOR_333333 font:12 target:self action:@selector(tagbtn:)];
             lockbtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
            [self addSubview:lockbtn];
            self.lockbtn = lockbtn;
            UIImageView *icon = [[UIImageView alloc]init];
            icon.image = [UIImage imageNamed:@"jiantou1"];
            icon.frame =CGRectMake(self.width - 40,40+i*(height+15)+5, 10, 15);
            [self addSubview:icon];
        }
        
        UIView *lien =[[UIView alloc]initWithFrame:CGRectMake(20, 40+i*(height+15)+height, width,1)];
        lien.backgroundColor = COLOR_CCCCCC;
        [self addSubview:lien];
      
    
        
    }
    
    
}
-(void)tagbtn:(UIButton *)btn {
    
    if (self.blockBtn) {
        self.blockBtn(btn);
    }
    
}



@end
