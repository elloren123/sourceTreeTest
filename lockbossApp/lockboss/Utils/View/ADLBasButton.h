//
//  ADLBasButton.h
//  ADEL-APP
//
//  Created by bailun91 on 2018/7/3.
//

#import <UIKit/UIKit.h>

typedef void(^tapHandler)(UIButton *);

@interface ADLBasButton : UIButton
@property (nonatomic,copy)tapHandler handler;
@property (nonatomic,copy)NSDictionary *dict;

+(id)butonWithTyp:(UIButtonType)buttnType frame:(CGRect)frame image:(UIImage *)image handler:(tapHandler)handler title:(NSString *)title;

@end
