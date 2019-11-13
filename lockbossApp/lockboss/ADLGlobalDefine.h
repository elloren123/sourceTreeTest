//
//  ADLGlobalDefine.h
//  lockboss
//
//  Created by adel on 2019/3/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#ifndef ADLGlobalDefine_h
#define ADLGlobalDefine_h

#pragma mark ------ Key ------

//QQAppId
#define QQ_APPID                                  @"101550437"

//微信AppId
#define WEACHAT_APPID                             @"wx9533173c44a31420"

//微信 secret
#define WEACHAT_SECRET                            @"f86e88604f7d2f9ea9cf6dc03b93e9fd"

//高德地图
#define AMAP_KEY                                  @"22e2e3b012f12c501276d1b921174b27"

//极光
#define JG_KEY                                    @"4c4360e6a88caa50cb4bc578"

//极光 secret
#define JG_SECRET                                 @"9ecefa67eabcfd80e569df38"

//客户端id
#define ADEL_DEVICEID                             @"8d0d1589270ea90732972a641a3ab2275fe413a0"


#pragma mark ------ 尺寸 ------

extern CGFloat ROW_HEIGHT;

extern CGFloat VIEW_HEIGHT;

extern CGFloat STATUS_HEIGHT;

extern CGFloat NAVIGATION_H;

extern CGFloat BOTTOM_H;

extern CGFloat NAV_H;

//屏幕宽度
#define SCREEN_WIDTH                              [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define SCREEN_HEIGHT                             [UIScreen mainScreen].bounds.size.height

//字体大小
#define FONT_SIZE                                 15

//圆角半径
#define CORNER_RADIUS                             4

//延时时间
#define DELAY_DURATION                            0.5

//图片压缩大小（1M）
#define IMAGE_MAX_LENGTH                          1048576

#pragma mark ------ 颜色 ------

//主体颜色#DA251C
#define APP_COLOR                                 [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1]

//#EEEEEE
#define SEPARATOR_COLOR                           [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]

//#00001A
#define PLACEHOLDER_COLOR                         [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.22]

//#E5E5E5
#define COLOR_E5E5E5                              [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1]

//#333333
#define COLOR_333333                              [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]

//#666666
#define COLOR_666666                              [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]

//#999999
#define COLOR_999999                              [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

//#F2F2F2
#define COLOR_F2F2F2                              [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]

//#F7F7F7
#define COLOR_F7F7F7                              [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]

//#CCCCCC
#define COLOR_CCCCCC                              [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]

//#D3D3D3
#define COLOR_D3D3D3                              [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1]

//0083FD
#define COLOR_0083FD                              [UIColor colorWithRed:0 green:131/255.0 blue:253/255.0 alpha:1]

//F7E4E4
#define COLOR_F7E4E4                              [UIColor colorWithRed:247/255.0 green:228/255.0 blue:228/255.0 alpha:1]

//E0212A
#define COLOR_E0212A                              [UIColor colorWithRed:224/255.0 green:33/255.0 blue:42/255.0 alpha:1]

//0AAA00
#define COLOR_0AAA00                              [UIColor colorWithRed:10/255.0 green:170/255.0 blue:0 alpha:1]

//16进制颜色 例:UIColorFromRGB(0x009FE8)
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#pragma mark ------ 通知 ------

//登录之后刷新是否有未读消息
static NSString *const REFRESH_MESSAGE                   = @"refresh_message";

//获取是否有未读消息通知
static NSString *const MESSAGE_UNREAD_CHANGED            = @"message_unread_changed";

//网络改变通知
static NSString *const NETWORK_STATUS_CHANGED            = @"network_status_changed";

//刷新购物车
static NSString *const REFRESH_SHOPPING_CAR              = @"refresh_shopping_car";

//刷新圈子
static NSString *const REFRESH_CIRCLE_DATA               = @"refresh_circle_data";

//支付结果
static NSString *const PAY_RESULT_STATUS                 = @"pay_result_status";

//支付返订单信息
static NSString *const PAY_RESULT_ORDER                = @"pay_result_Order";

//刷新订单列表
static NSString *const REFRESH_ORDER_LIST                = @"refresh_order_list";


#pragma mark ------ 其它 ------

//App设置页面URL
#define APP_SETTING_URL                           [NSURL URLWithString:UIApplicationOpenSettingsURLString]

//商品搜索历史
#define GOODS_SEARCH_HISTORY                      @"goods_search_history.plist"

//首页公告
#define HOME_ANNOUNCEMENT                         @"home_announcement.plist"

//首页轮播图
#define HOME_BANNER                               @"home_banner.plist"

//商城轮播图
#define STORE_BANNER                              @"store_banner.plist"

//商城分类列表
#define STORE_CLASS                               @"store_class.plist"

//发现轮播图
#define DISCOVERY_BANNER                          @"discovery_banner.plist"

//发现商城早报
#define DISCOVERY_MORNING                         @"discovery_morning.plist"

//手机号登录历史
#define HISTORY_PHONE                             @"history_phone.plist"

//邮箱、账号登录历史
#define HISTORY_EMAIL                             @"history_email.plist"

//设备Token
#define DEVICE_TOKEN                              @"device_token"

//开锁界面用户选择的开锁模式
#define USER_PATTERN                              @"user_pattern"

//家庭锁选中的设备
#define FAMILY_DEVICE                             @"family_device"

//选择的酒店信息
#define HOTEL_SEL_ROOM_MESSAGE                    @"hotel_select_room_message"

//酒店锁选中的设备
#define HOTEL_DEVICE_SELECT                       @"hotel_device_select"

#endif
