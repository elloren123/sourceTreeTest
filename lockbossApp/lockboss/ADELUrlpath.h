//
//  ADELUrlpath.h
//  ADEL-APP
//
//  Created by bailun91 on 2018/3/23.
//

#ifndef ADELUrlpath_h
#define ADELUrlpath_h

//正式外网
//#define ADELMain_UrlSan @"http://www.isod-ai.com:8087"
//测试外网
#define ADELMain_UrlSan @"http://129.204.67.226:8087"
//#define ADELMain_UrlSan @"http://test.isod-ai.com:8087"

//李翼
//#define ADELMain_UrlSan @"http://192.168.168.43:8080"
//李翼
//#define ADELMain_UrlSan @"https://192.168.168.43:443"
//周伟
//#define ADELMain_UrlSan @"http://192.168.168.45:8080"
//李桂
//#define ADELMain_UrlSan @"http://192.168.168.65:8080"
//加辣
//#define ADELMain_UrlSan @"http://192.168.168.48:8080"
//马路遥
//#define ADELMain_UrlSan @"http://192.168.168.49:8080"
//黎海波
//#define ADELMain_UrlSan @"http://192.168.168.57:8080"
//内网测试环境
//#define ADELMain_UrlSan @"http://172.18.0.215:8080"

//MQTT 设备控制 测试
//#define ADL_DEVICE_MQTT @"http://192.168.168.45:8183"

#define ADL_DEVICE_MQTT @"http://129.204.67.226:8183"

//正式的-------我也不知道  TODO


#pragma mark  -----家庭版
//正式环境外网
//#define ADELMain_Urlfamily @"http://www.isod-ai.com:8088"
//测试环境外网
#define ADELMain_Urlfamily @"http://129.204.67.226:8088"
//李翼
//#define ADELMain_Urlfamily @"http://192.168.168.43:8088"
//周伟
//#define ADELMain_Urlfamily @"http://192.168.168.45:8088"
//李桂
//#define ADELMain_Urlfamily @"http://192.168.168.65:8088"
//马路遥
//#define ADELMain_Urlfamily @"http://192.168.168.49:8088"
//内网测试环境
//#define ADELMain_Urlfamily @"http://172.18.0.215:8088"

#pragma mark  -----校园版
//正式环境外网
//#define ADELMain_UrlCampus @"http://www.isod-ai.com:9001"
//测试环境外网
#define ADELMain_UrlCampus @"http://129.204.67.226:9001"
//马路遥
//#define ADELMain_UrlCampus @"http://192.168.168.49:9001"
//李桂
//#define ADELMain_UrlCampus @"http://192.168.168.65:9001"
//内网测试环境
//#define ADELMain_UrlCampus @"http://172.18.0.215:9001"

#pragma mark  -----设备

//正式环境外网
//#define ADELMain_UrlSanSevice @"http://www.isod-ai.com:8086"
//测试外网
#define ADELMain_UrlSanSevice @"http://129.204.67.226:8086"
//李翼
//#define ADELMain_UrlSanSevice @"http://192.168.168.43:8081"
//周伟
//#define ADELMain_UrlSanSevice @"http://192.168.168.45:8081"
//李桂
//#define ADELMain_UrlSanSevice @"http://192.168.168.65:8081"
//马路遥
//#define ADELMain_UrlSanSevice @"http://192.168.168.49:8081"
//内网测试环境
//#define ADELMain_UrlSanSevice @"http://172.18.0.215:8080"


#pragma mark  -----RMO
///RMO外网
//#define RMQCURL @"amqp://admin:AI_lockrabbitmqadmin123@isod-ai.com:5672"
//测试外网
#define RMQCURL @"amqp://admin:AI_lockrabbitmqadmin123@129.204.67.226:5672"
//内网RMO
//#define RMQCURL @"amqp://admin:AI_lockrabbitmqadmin123@172.18.0.215:5672"



#pragma mark  -----433 网络锁接口
#define ADELMain_UrlSan433 [[ADLEFdaluts objectForKey:ADLUSER_version] isEqualToString:@"former"] ? @"http://adelcloud.com" : @"http://adelshop.com"
//#define ADELMain_UrlSan433 @"http://adelcloud.com"
//#define ADELMain_UrlSan433 @"http://adelshop.com"
//内网RMO
//#define ADELMain_UrlSan433 @"http://192.168.168.52:8092"
//#define ADELMain_UrlSan433 @"http://5mrf2w.natappfree.cc"

//发现
#define APP_433_getFinds (ADELMain_UrlSan433@"/adel-admin/app/member/getFinds.do?")
//常开常闭
#define APP_433_openClosed (ADELMain_UrlSan433@"/adel-admin/app/member/openClosed.do?")
//远程退房
#define APP_433_remotelyCheckOut (ADELMain_UrlSan433@"/adel-admin/app/member/remotelyCheckOut.do?")
//开锁
#define APP_433_openByQRCode (ADELMain_UrlSan433@"/adel-admin/app/member/openByQRCode.do?")
//查询是否退房
#define APP_433_bluetoothOpenDoor (ADELMain_UrlSan433@"/adel-admin/app/member/bluetoothOpenDoor.do?")

#pragma mark  -----  接口

//https://itunes.apple.com/cn/app/id1190174347?mt=8
//注册1.获取短信验证码   无 type 0 注册 1登录 2 找回密码
#define ADEL_getCode (ADELMain_UrlSan@"/lockboss-api/app/register/getMessageVerificationCode.do?")


//校验短信验证码lockboss-api/app/register/verifyMessageVerificationCode.do
#define ADEL_verifyMessageVerificationCode (ADELMain_UrlSan@"/lockboss-api/app/register/verifyMessageVerificationCode.do")

//短信验证码登录http://10.1.1.96:8081/lockboss-api/app/register/phoneLoginAndRegister
#define ADEL_LOGI (ADELMain_UrlSan@"/lockboss-api/app/register/phoneLoginAndRegister.do?")


//1.常规登录
//http://10.1.1.96:8081/lockboss-api/app/register/login.do
#define ADEL_registerLogin (ADELMain_UrlSan@"/lockboss-api/app/register/login.do?")

//1.退出登录/lockboss-api/app/register/logout.do (App)
#define ADEL_logoutn (ADELMain_UrlSan@"/lockboss-api/app/register/logout.do?")


//邮箱注册
//http://10.1.1.96:8081/lockboss-api/app/register/email.do
#define ADEL_email (ADELMain_UrlSan@"/lockboss-api/app/register/email.do?")


//忘记密码-发送邮件（邮箱模式）
//http://10.1.1.96:8081/lockboss-api/app/register/modifyPasswordSendEmail.do
#define ADEL_modifyPasswordSendEmail (ADELMain_UrlSan@"/lockboss-api/app/register/modifyPasswordSendEmail.do?")


//校验邮箱验证码
//http://10.1.1.96:8081/lockboss-api/app/register/validateEmailCode.d
#define ADEL_validateEmailCode (ADELMain_UrlSan@"/lockboss-api/app/register/validateEmailCode.do?")

//6.忘记密码-修改密码（邮箱模式）
//http://10.1.1.96:8081/lockboss-api/app/register/modifyPasswordByEmail.do
#define ADEL_modifyPasswordByEmail (ADELMain_UrlSan@"/lockboss-api/app/register/modifyPasswordByEmail.do?")


//上传图片 http://10.1.1.130:8080/lockboss-api/app/userInfo/uploadImage.do

#define ADEL_uploadImage (ADELMain_UrlSan@"/lockboss-api/app/userInfo/uploadImage.do?")

//修改用户信息/lockboss-api/app/userInfo/update.do

//token  用户token
//headShot  头像
//sex  头性别
//nickName 昵称
#define ADEL_update (ADELMain_UrlSan@"/lockboss-api/app/userInfo/update.do")

//修改登录帐号 lockboss-api/app/userInfo/updateLoginAccount.do

//token  用户token
//loginAccount
#define ADEL_register (ADELMain_UrlSan@"/lockboss-api/app/userInfo/updateLoginAccount.do")
//3. 检测是否修改过帐号 lockboss-api/app/userInfo/checkModifyLoginAccount.do
//token  用户token
//loginAccount
#define ADEL_checkModifyLoginAccount (ADELMain_UrlSan@"/lockboss-api/app/userInfo/checkModifyLoginAccount.do")


//查询用户 个人信息 lockboss-api/app/employeeManage/searchUser.do
#define ADEL_searchUser (ADELMain_UrlSan@"/lockboss-api/app/employeeManage/searchUser.do")

//精确查询用户 lockboss-api/app/employeeManage/preciseSearchUser.do
#define ADEL_preciseSearchUser (ADELMain_UrlSan@"/lockboss-api/app/employeeManage/preciseSearchUser.do")

//第三方登录 lockboss-api/app/register/thirdPartyLogin.do
#define ADEL_thirdPartyLogin (ADELMain_UrlSan@"/lockboss-api/app/register/thirdPartyLogin.do")


//第三方绑定-验证码绑定 lockboss-api/app/register/bindThirdPartyByPhoneVerificationCode.do
#define ADEL_bindThirdPartyCode (ADELMain_UrlSan@"/lockboss-api/app/register/bindThirdPartyByPhoneVerificationCode.do")


//第三方绑定-帐号绑定lockboss-api/app/register/bindThirdPartyByLoginAccount.do
#define ADEL_bindThirdPartyByLoginAccoun (ADELMain_UrlSan@"/lockboss-api/app/register/bindThirdPartyByLoginAccount.do")


//第三方绑定http://10.1.1.96:8081/lockboss-api/app/register/thirdPartyBind.do
#define ADEL_thirdPartyBind (ADELMain_UrlSan@"/lockboss-api/app/register/thirdPartyBind.do")

//第三方绑定-帐号解绑 /lockboss-api/app/register/unbind.do
#define ADEL_removeunbind (ADELMain_UrlSan@"/lockboss-api/app/register/unbind.do")


//第三方关联帐号注册-邮箱注册lockboss-api/app/register/thirdPartyEmail.do
#define ADEL_thirdPartyEmail (ADELMain_UrlSan@"/lockboss-api/app/register/thirdPartyEmail.do")


//第三方关联帐号注册-手机注册 lockboss-api/app/register/thirdPartyPhone.do
#define ADEL_thirdPartyPhone (ADELMain_UrlSan@"/lockboss-api/app/register/thirdPartyPhone.do")


//校验第三方key lockboss-api/app/register/verificationThirdPartyKey.do  (App)
#define ADEL_verificationThirdPartyKey (ADELMain_UrlSan@"/lockboss-api/app/register/verificationThirdPartyKey.do")


//手机号注册
//http://10.1.1.96:8081/lockboss-api/app/register/phone.do  (App)
#define ADEL_registerPhone (ADELMain_UrlSan@"/lockboss-api/app/register/phone.do")

//1.修改密码-手机模式/lockboss-api/app/register/modifyPasswordByPhone.do
#define ADEL_modifyPasswordByPhone (ADELMain_UrlSan@"/lockboss-api/app/register/modifyPasswordByPhone.do")



//验证跟新token /lockboss-api/app/userInfo/verifyToken.do
#define ADEL_verifyToken (ADELMain_UrlSan@"/lockboss-api/app/userInfo/verifyToken.do")



//查询用户信息 adel.lockBoss.api/userInfo/search.do
//token  用户token
#define ADEL_userInfo (ADELMain_UrlSan@"/lockboss-api/app/userInfo/search.do")

//家庭,储物箱开箱
#define ADEL_Family_StorageBox_Open (ADELMain_UrlSan@"/lockboss-mqtt/family/storageBox/open.do")
//家庭,燃气阀开
#define ADEL_Family_GasValve_Open (ADELMain_UrlSan@"/lockboss-mqtt/family/gasValve/open.do")

#pragma mark  ------客房中心
//客房中心-设备信息  /lockboss-api/app/user/roomManage/centre/getDeviceInfo.do
#define ADEL_getDeviceInfo (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/centre/getDeviceInfo.do")

//客房中心-服务 /lockboss-api/app/user/roomManage/centre/getServices.do
#define ADEL_getServices (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/centre/getServices.do")
//当前用户入住的销售房型 lockboss-api/app/user/roomSellType/current.do
#define ADEL_roomSellType_current (ADELMain_UrlSan@"/lockboss-api/app/user/roomSellType/current.do")

//1.4 客房中心-服务订单 /lockboss-api/app/user/roomManage/centre/getServiceOrders.do
#define ADEL_getServiceOrders (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/centre/getServiceOrders.do")
//1.5 客房中心-服务订单-催单/lockboss-api/app/user/roomManage/centre/isUrgeServiceOrder.do
#define ADEL_isUrgeServiceOrder (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/centre/isUrgeServiceOrder.do?")
//1.6 客房中心-服务订单-取消订单/lockboss-api/app/user/roomManage/centre/cancelServiceOrder.do
#define ADEL_cancelServiceOrder (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/centre/cancelServiceOrder.do")


//用户付款 用户端使用lockboss-api/app/roomSellOrder/pay.do
#define ADEL_roomSellOrder_pay (ADELMain_UrlSan@"/lockboss-api/app/roomSellOrder/pay.do")

//用户取消订单 用户端使用lockboss-api/app/roomSellOrder/cancel.do
#define ADEL_roomSellOrder_cancelt (ADELMain_UrlSan@"/lockboss-api/app/roomSellOrder/cancel.do")

//用户付款成功 用户端使用lockboss-api/app/roomServiceManage/pay/result.do
#define ADEL_pay_result (ADELMain_UrlSan@"/lockboss-api/app/roomServiceManage/pay/result.do")

//线上 销售房型列表 /lockboss-api/app/user/roomSellType/list.do
#define ADEL_roomSellType_list (ADELMain_UrlSan@"/lockboss-api/app/user/roomSellType/list.do")
//线下用户房型 /lockboss-api/app/user/roomSellType/list.do
#define ADEL_roomTypeManage_search (ADELMain_UrlSan@"/lockboss-api/app/user/roomTypeManage/search.do")


//开锁 /lockboss-dev/lock/user/openLock.do
#define ADEL_openLock (ADELMain_UrlSanSevice@"/lockboss-dev/lock/user/openLock.do")

//开锁L3 类型deviceType = 30 /lockboss-api/l3/user/openLock.do
#define ADEL_openLockL3 (ADELMain_UrlSan@"/lockboss-api/l3/user/openLock.do")

//开锁记录 /lockboss-api/app/user/roomManage/openLockRecord.do
#define ADEL_openLockRecord (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/openLockRecord.do")

//重置密码 /lockboss-dev/lock/user/resetPassword.do

#define ADEL_resetPassword (ADELMain_UrlSanSevice@"/lockboss-dev/lock/user/resetPassword.do")

//重置密码L3 /lockboss-api/l3/user/resetPassword.do
#define ADEL_resetPasswordL3 (ADELMain_UrlSan@"/lockboss-api/l3/user/resetPassword.do")

//客房信息 /lockboss-api/app/user/roomManage/centre/getRoomInfo.do
#define ADEL_getRoomInfo (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/centre/getRoomInfo.do")

//4. 购买客房服务--下单客房服务 /lockboss-api/app/user/roomManage/buyRoomService.do
#define ADEL_buyRoomService (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/buyRoomService.do")


//7.酒店体验反馈中批量上传图片 /lockboss-api/app/user/feedback/batchUploadImage.do
#define ADEL_batchUploadImage (ADELMain_UrlSan@"/lockboss-api/app/user/feedback/batchUploadImage.do")


//9.开门方式管理/lockboss-api/app/user/roomManage/openType.do
//app
#define ADEL_openType (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/openType.do")

//10.开门方式管理/lockboss-dev/lock/user/secretManage.do?
#define ADEL_secretManage (ADELMain_UrlSanSevice@"/lockboss-dev/lock/user/secretManage.do")

//开门方式管理 L3 /lockboss-api/l3/user/setOpenType.do
#define ADEL_setOpenTypeL3 (ADELMain_UrlSan@"/lockboss-api/l3/user/setOpenType.do")


//7.酒店体验反馈 /lockboss-api/app/user/roomManage/feedbackMessage.do
#define ADEL_feedbackMessage (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/feedbackMessage.do")

//查询当前入住信/lockboss-api/app/user/selectSelfCheckingInfo.do
#define APP_selectSelfCheckingInfo (ADELMain_UrlSan@"/lockboss-api/app/user/selectSelfCheckingInfo.do")

//激活房卡lockboss-dev/lock/user/activateRoomCrad.do
#define APP_activateRoomCrad (ADELMain_UrlSanSevice@"/lockboss-dev/lock/user/activateRoomCrad.do")

// 查询设备密钥 http://172.18.0.215:8080/lockboss-api/app/user/selectSecret.do
#define ADEL_selectSecret (ADELMain_UrlSan@"/lockboss-api/app/user/selectSecret.do?")

//开门方式查询 http://172.18.0.215:8080/lockboss-api/app/user/roomManage/getOpenType.do
#define ADEL_getOpenTyp (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/getOpenType.do")

//删除房卡lockboss-dev/lock/user/deleteCard.do
#define APP_deleteCard (ADELMain_UrlSanSevice@"/lockboss-dev/lock/user/deleteCard.do?")
//查询激活的房卡/lockboss-api/app/user/selectActivateRoomCrad.do
#define APP_selectActivateRoomCrad (ADELMain_UrlSan@"/lockboss-api/app/user/selectActivateRoomCrad.do")


//本地添加指纹http://10.1.1.96:8081/lockboss-dev/lock/user/addSecretFingerprint.do
#define APP_addSecretFingerprint (ADELMain_UrlSanSevice@"/lockboss-dev/lock/user/addSecretFingerprint.do")

//8.软件体验反馈 /lockboss-api/app/user/feedback/appMessage.do

#define ADEL_appMessage (ADELMain_UrlSan@"/lockboss-api/app/user/feedback/appMessage.do")



//获取开门方式http://10.1.1.96:8081/lockboss-api/app/user/getOpenType.do
#define ADEL_getOpenType (ADELMain_UrlSan@"/lockboss-api/app/user/getOpenType.do")

//组合开门方式管理http://10.1.1.96:8081/lockboss-dev/lock/user/setOpenType.do
#define ADEL_setOpenType (ADELMain_UrlSanSevice@"/lockboss-dev/lock/user/setOpenType.do")


// 酒店查询秘钥情况 lockboss-family/dev/selectSecretCase.do
#define ADEL_selectSecretCase (ADELMain_UrlSan@"/lockboss-api/app/user/selectSecretCase.do")


//11. 查询入住记录/lockboss-api/app/user/record/getCheckingIns.do

#define ADEL_getCheckingIns (ADELMain_UrlSan@"/lockboss-api/app/user/record/getCheckingIns.do")


//12. 删除入住记录/lockboss-api/app/user/record/deleteCheckingIns.do

#define ADEL_deleteCheckingIns (ADELMain_UrlSan@"/lockboss-api/app/user/record/deleteCheckingIns.do")


//app版本检测升级http://172.18.0.215:8080/lockboss-api/app/user/upgrade.do (App)

#define ADEL_upgrade (ADELMain_UrlSan@"/lockboss-api/app/user/upgrade.do")

#pragma mark  ------个人指纹卡
//1.查询个人指纹库lockboss-api/app/userInfo/searchMyFingers.do (App)
#define ADEL_searchMyFingers (ADELMain_UrlSan@"/lockboss-api/app/userInfo/searchMyFingers.do")

//2.修改个人指纹名称/lockboss-api/app/userInfo/updateMyFingerName.do (App)
#define ADEL_updateMyFingerName (ADELMain_UrlSan@"/lockboss-api/app/userInfo/updateMyFingerName.do")

//3. 删除个人指纹/lockboss-api/app/userInfo/deleteMyFingerName.do (App)
#define ADEL_deleteMyFingerName (ADELMain_UrlSan@"/lockboss-api/app/userInfo/deleteMyFingerName.do")


//3. 11.消息推送数量-减少/lockboss-api/app/user/message/unread/num/decrease.do (App)
#define ADEL_decrease (ADELMain_UrlSan@"/lockboss-api/app/user/message/unread/num/decrease.do")
//获取消息推送数量
#define ADEL_unreadsum (ADELMain_UrlSan@"/lockboss-api/app/user/message/unread/sum.do")

//校验是否存在密码 http://172.18.0.215:8080/lockboss-api/app/userInfo/verifyIsPasswrod.do
#define ADEL_verifyIsPasswrod (ADELMain_UrlSan@"/lockboss-api/app/userInfo/verifyIsPasswrod.do")

//校验密码 http://172.18.0.215:8080/lockboss-api/app/userInfo/verifyPasswrod.do
#define ADEL_verifyPasswrod (ADELMain_UrlSan@"/lockboss-api/app/userInfo/verifyPasswrod.do")

//查询用户模式lockboss-api/app/user/getUserPattern.do
#define ADEL_getUserPattern (ADELMain_UrlSan@"/lockboss-api/app/user/getUserPattern.do")

#pragma mark  ------家庭版接口

//添加设备-打开网络 打开zigbee
#define ADEL_family_zigbee_open (ADL_DEVICE_MQTT@"/lockboss-mqtt/gecko2/zigbee/open.do")

//添加设备http://10.1.1.96:8081/lockboss-family/dev/add.do
#define ADEL_familydev_add (ADELMain_Urlfamily@"/lockboss-family/family/add.do")

//添加配网信息http://10.1.1.96:8081/lockboss-family/app/wifi/add.do (App)
#define ADEL_familydev_Changwifi (ADELMain_Urlfamily@"/lockboss-family/app/wifi/add.do")

//查询用户设备信息http://10.1.1.96:8081/lockboss-family/app/family/getUserDeviceInfo.do (App)
#define ADEL_family_getUserDeviceInfo (ADELMain_Urlfamily@"/lockboss-family/family/getUserDeviceInfo.do")
//设置共享人lockboss-family/family/setShareCrew.do
#define ADEL_family_setShareCrew (ADELMain_Urlfamily@"/lockboss-family/family/setShareCrew.do")

// 设备人员信息查询lockboss-family/family/getDeviceCrew.do
#define ADEL_family_getDeviceCrew (ADELMain_Urlfamily@"/lockboss-family/family/getDeviceCrew.do")

// 33. 查询网关下设备lockboss-family/dev/getGatewayDevice.do
#define ADEL_family_getGatewayDevice (ADELMain_Urlfamily@"/lockboss-family/dev/getGatewayDevice.do")
//删除设备http://10.1.1.96:8081/lockboss-dev/family/deleteDevice.do
#define ADEL_family_deleteDevice (ADELMain_UrlSanSevice@"/lockboss-dev/family/deleteDevice.do")

//恢复出厂设置http://10.1.1.96:8081/lockboss-dev/family/factoryReset.do (App)
#define ADEL_family_factoryReset (ADELMain_UrlSanSevice@"/lockboss-dev/family/factoryReset.do")
//获取设备类型列表,sb名字,完全看不出干嘛用的
#define ADEL_family_get_deviceType_list (ADELMain_UrlSan@"/lockboss-api/dev/type/list.do")
//删除共享人http://10.1.1.96:8080/lockboss-family/dev/relieveShare.do (App)

#define ADEL_family_relieveShare (ADELMain_Urlfamily@"/lockboss-family/dev/relieveShare.do")


//查询设备信息http://10.1.1.96:8080/lockboss-family/dev/getDeviceInfo.do   (App)
#define ADEL_family_getDeviceInfo (ADELMain_Urlfamily@"/lockboss-family/dev/getDeviceInfo.do")

//检测版本号-检测设备http://10.1.1.96:8080/lockboss-family/dev/checkFirmwareVersion.do   (App)
#define ADEL_family_checkFirmwareVersion (ADELMain_Urlfamily@"/lockboss-family/dev/checkFirmwareVersion.do")

//获取最新版本号http://10.1.1.96:8080/lockboss-dev/family/gainFirmwareVersion.do   (App)
#define ADEL_family_gainFirmwareVersion (ADELMain_UrlSanSevice@"/lockboss-dev/family/gainFirmwareVersion.do")

//获取壁虎最新版本号 http://10.1.1.96:8080/lockboss-dev/family/gatewayGainFirmwareVersion.do   (App)
#define ADEL_family_gatewayGainFirmwareVersion (ADELMain_UrlSanSevice@"/lockboss-dev/family/gatewayGainFirmwareVersion.do")

//升级版本-壁虎设备 http://10.1.1.96:8080/lockboss-dev/family/gatewayUpgrade.do  (App)
#define ADEL_family_gatewayUpgrade (ADELMain_UrlSanSevice@"/lockboss-dev/family/gatewayUpgrade.do")


//检测设备是否正在升级 http://10.1.1.96:8080/lockboss-family/dev/upgradeFirmwareVersion.do  (App)
#define ADEL_family_upgradeFirmwareVersion (ADELMain_Urlfamily@"/lockboss-family/dev/upgradeFirmwareVersion.do")

//停止升级 http://10.1.1.96:8080/lockboss-dev/family/stopUpgrade.do  (App)
#define ADEL_family_stopUpgrade (ADELMain_UrlSanSevice@"/lockboss-dev/family/stopUpgrade.do")


//升级版本-设备http://10.1.1.96:8080/lockboss-dev/family/upgrade.do   (App)
#define ADEL_family_upgrade (ADELMain_UrlSanSevice@"/lockboss-dev/family/upgrade.do")

//设置时间http://10.1.1.96:8080/lockboss-dev/family/setL1Date.do  (App)
#define ADEL_family_setL1Date (ADELMain_UrlSanSevice@"/lockboss-dev/family/setL1Date.do")


//添加锁设备http://10.1.1.96:8080/lockboss-family/family/addLock.do  (App)
#define ADEL_family_addLock (ADELMain_Urlfamily@"/lockboss-family/family/addLock.do")

//添加密钥-指纹http://10.1.1.96:8080/lockboss-dev/family/addSecretFingerprint.do (App)
#define ADEL_family_addSecretFingerprint (ADELMain_UrlSanSevice@"/lockboss-dev/family/addSecretFingerprint.do")

//下发指纹到设备http://10.1.1.96:8080/lockboss-dev/family/sendHoldFingerprint.do (App)
#define ADEL_family_sendHoldFingerprint (ADELMain_UrlSanSevice@"/lockboss-dev/family/sendHoldFingerprint.do")

//本地激活卡http://10.1.1.96:8080/lockboss-dev/family/activateRoomCrad.do (App)
#define ADEL_family_activateRoomCrad (ADELMain_UrlSanSevice@"/lockboss-dev/family/activateRoomCrad.do")

//.添加密钥-密码http://10.1.1.96:8080/lockboss-dev/family/addSecretPassword.do (App)
#define ADEL_family_addSecretPassword (ADELMain_UrlSanSevice@"/lockboss-dev/family/addSecretPassword.do")

//开门/开锁http://10.1.1.96:8080/lockboss-dev/family/openLock.do (App)
#define ADEL_family_openLock (ADELMain_UrlSanSevice@"/lockboss-dev/family/openLock.do")

//转让权限http://10.1.1.96:8080/lockboss-family/family/setPermission.do  (App)
#define ADEL_family_setPermission (ADELMain_Urlfamily@"/lockboss-family/family/setPermission.do")

//查询m卡http://10.1.1.96:8080/lockboss-family/dev/searchSecretCard.do  (App)
#define ADEL_family_searchSecretCard (ADELMain_Urlfamily@"/lockboss-family/dev/searchSecretCard.do")

//查询指纹http://10.1.1.96:8080/lockboss-family/dev/searchSecretFingerprint.do  (App)
#define ADEL_family_searchSecretFingerprint (ADELMain_Urlfamily@"/lockboss-family/dev/searchSecretFingerprint.do")

//查询密码http://10.1.1.96:8080/lockboss-family/dev/searchSecretPassword.do  (App)
#define ADEL_family_searchSecretPassword (ADELMain_Urlfamily@"/lockboss-family/dev/searchSecretPassword.do")


//删除指纹http://10.1.1.96:8080/lockboss-dev/family/deleteSecretFingerprint.do  (App)
#define ADEL_family_deleteSecretFingerprint (ADELMain_UrlSanSevice@"/lockboss-dev/family/deleteSecretFingerprint.do")
//删除密码http://10.1.1.96:8080/lockboss-dev/family/deleteSecretPassword.do  (App)
#define ADEL_family_deleteSecretPassword (ADELMain_UrlSanSevice@"/lockboss-dev/family/deleteSecretPassword.do")
//删除m卡http://10.1.1.96:8080/lockboss-dev/family/deleteSecretCard.do  (App)
#define ADEL_family_deleteSecretCard (ADELMain_UrlSanSevice@"/lockboss-dev/family/deleteSecretCard.do")


// 密钥延期http://10.1.1.96:8080/lockboss-dev/family/secretDelay.do
#define ADEL_family_secretDelay (ADELMain_UrlSanSevice@"/lockboss-dev/family/secretDelay.do")



//修改设备备注http://10.1.1.96:8080/lockboss-family/dev/updateDeviceName.do  (App)
#define ADEL_family_updateDeviceName (ADELMain_Urlfamily@"/lockboss-family/dev/updateDeviceName.do")

//开锁记录 http://10.1.1.96:8080/lockboss-family/dev/openLockRecord.do  (App)
#define ADEL_family_openLockRecord (ADELMain_Urlfamily@"/lockboss-family/dev/openLockRecord.do")

//开锁记录--储物箱
#define ADEL_family_openLockStorageBox (ADELMain_Urlfamily@"/lockboss-family/storageBox/openRecord.do ")

//开锁记录--燃气阀
#define ADEL_family_openLockGasValve (ADELMain_Urlfamily@"/lockboss-family/gasValve/openRecord.do")

//查询当前用户下被共享人设备信息 http://10.1.1.96:8080/lockboss-family/family/getByDeviceCrew.do   (App)
#define ADEL_family_getByDeviceCrew (ADELMain_Urlfamily@"/lockboss-family/family/getByDeviceCrew.do")

//网络信息-壁虎连接路由器信息 http://10.1.1.96:8080/lockboss-family/dev/getInfoByGatewayId.do  (App)
#define ADEL_family_getInfoByGatewayId (ADELMain_Urlfamily@"/lockboss-family/dev/getInfoByGatewayId.do")

//删除共享锁设备- 解除锁绑定 http://10.1.1.96:8080/lockboss-family/dev/relieveShareDevice.do  (App)
#define ADEL_family_relieveShareDevice (ADELMain_Urlfamily@"/lockboss-family/dev/relieveShareDevice.do")

//普通用户解除共享锁设备http://10.1.1.96:8081/lockboss-family/dev/ordinaryRelieveShareDevice.do (App)
#define ADEL_family_ordinaryRelieveShareDevice (ADELMain_Urlfamily@"/lockboss-family/dev/ordinaryRelieveShareDevice.do")

//删除网关 http://10.1.1.96:8080/lockboss-family/dev/deleteGateway.do   (App)
#define ADEL_family_deleteGateway (ADELMain_Urlfamily@"/lockboss-family/dev/deleteGateway.do")


// 组合开门方式接口查询 http://172.18.0.215:8081/lockboss-family/dev/getGroupOpenType.do
#define ADEL_family_getGroupOpenType (ADELMain_Urlfamily@"/lockboss-family/dev/getGroupOpenType.do")

// 开门方式管理 http://172.18.0.215:8080/lockboss-dev/family/setOpenType.do
#define ADEL_family_setOpenType (ADELMain_UrlSanSevice@"/lockboss-dev/family/setOpenType.do")

// 查询秘钥情况 lockboss-family/dev/selectSecretCase.do
#define ADEL_family_selectSecretCase (ADELMain_Urlfamily@"/lockboss-family/dev/selectSecretCase.do")

//设备常开/常关 lockboss-dev/family/keepStatus.do
#define ADEL_family_keepStatus (ADELMain_UrlSanSevice@"/lockboss-dev/family/keepStatus.do")

//授权详情 http://10.1.1.96:8081/lockboss-family/dev/shareDetails.do
#define ADEL_family_shareDetails (ADELMain_Urlfamily@"/lockboss-family/dev/shareDetails.do")


//查询网关下所有共享人员 http://10.1.1.96:8081/lockboss-family/dev/getGatewayCrewUser.do
#define ADEL_family_getGatewayCrewUser (ADELMain_Urlfamily@"/lockboss-family/dev/getGatewayCrewUser.do")

//共享人延期 http://10.1.1.96:8087/lockboss-family/dev/postponeShare.do
#define ADEL_family_postponeShare (ADELMain_Urlfamily@"/lockboss-family/dev/postponeShare.do")

//查询是否共享过 http://10.1.1.96:8081/lockboss-family/family/getIsCrew.do
#define ADEL_family_getIsCrew (ADELMain_Urlfamily@"/lockboss-family/family/getIsCrew.do")


//51 设置备注名 http://10.1.1.96:8087/lockboss-family/family/setRemark.do
#define ADEL_family_setRemark (ADELMain_Urlfamily@"/lockboss-family/family/setRemark.do")


//52根据学生id 获取信息  http://10.1.1.96:9001/lockboss-school/client/student/info.do
#define ADEL_clientstudent_info (ADELMain_UrlCampus@"/lockboss-school/client/student/info.do")

//根据宿舍id 获取设备列表  http://10.1.1.96:9001/lockboss-school/client/dorm/info.do (App)
#define ADEL_student_DeviceDorm (ADELMain_UrlCampus@"/lockboss-school/client/dorm/info.do")

//设备报修:http://10.1.1.96:9001/lockboss-school/user/fix/add.do (App)
#define ADEL_student_studentMaintenanced (ADELMain_UrlCampus@"/lockboss-school/user/fix/add.do")


//设申请换宿舍:lockboss-school/exchange/record/add.do
#define ADEL_student_exchange (ADELMain_UrlCampus@"/lockboss-school/exchange/record/add.do")

//卡-挂失卡片http://10.1.1.96:8081/lockboss-dev/school/card/loss.do
#define ADEL_student_lostCard (ADELMain_UrlSanSevice@"/lockboss-dev/school/card/loss.do")

//卡-申请恢复卡片http://10.1.1.96:8081/lockboss-school/card/apply/recover.do
#define ADEL_student_recoverCard (ADELMain_UrlSanSevice@"/lockboss-school/card/apply/recover.do")

//获取个人信息 -- 学生 lockboss-school/student/info.do
#define ADEL_student_info (ADELMain_UrlCampus@"/lockboss-school/client/student/info.do")

//开锁 //10.1.1.96:8081/lockboss-dev/school/lock/open.do
#define ADEL_student_openLock (ADELMain_UrlSanSevice@"/lockboss-dev/school/lock/open.do")


//开锁记录 http://10.1.1.96:8080/lockboss-school/dev/openLockRecord.do   (App)
#define ADEL_student_openLockRecord (ADELMain_UrlCampus@"/lockboss-school/dev/openLockRecord.do")

//根据学生id 获取卡-- 学生 lockboss-school/student/card/list.do
#define ADEL_student_cardlist (ADELMain_UrlCampus@"/lockboss-school/student/card/list.do")

//在L3接口文档-app使用  - 据设备人脸列表-人脸
#define ADEL_L3_userface_list (ADELMain_UrlSan@"/lockboss-api/app/l3/face/user/list.do")


//在L3接口文档-app使用  -  录入人脸-人脸
#define ADEL_L3_face_add (ADELMain_UrlSan@"/lockboss-api/app/l3/face/add.do")

//在L3接口文档-app使用 删除人脸-个人库
#define ADEL_face_delete (ADELMain_UrlSan@"/lockboss-api/app/l3/face/delete.do")




#pragma   酒店预订
//精品推荐酒店
#define ADEL_hotel_boutiquecompan (ADELMain_UrlSan@"/lockboss-api/app/boutique/company.do")

//搜索酒店 - 用户端使用
#define ADEL_hotel_searchcompany (ADELMain_UrlSan@"/lockboss-api/app/search/company.do")

//酒店介绍
#define ADEL_hotel_introduce_company (ADELMain_UrlSan@"/lockboss-api/app/introduce/company.do")


//销售房型列表 - 用户端使用
#define ADEL_hotel_roomSellType_lis (ADELMain_UrlSan@"/lockboss-api/app/user/roomSellType/list.do")


//浏览记录列表
#define ADEL_hotel_browsing_list (ADELMain_UrlSan@"/lockboss-api/app/browsing/company/list.do")

//删除收藏
#define ADEL_hotel_favorite_delete (ADELMain_UrlSan@"/lockboss-api/app/favorite/company/delete.do")

//删除浏览记录
#define ADEL_hotel_browsing_delete (ADELMain_UrlSan@"/lockboss-api/app/browsing/company/delete.do")

//销售房型订单
#define ADEL_hotel_roomSellOrder_add (ADELMain_UrlSan@"/lockboss-api/app/roomSellOrder/add.do")

//用户付款 用户端使用
#define ADEL_hotel_roomSellOrder_pay (ADELMain_UrlSan@"/lockboss-api/app/roomSellOrder/pay.do")

//用户付款成功
#define ADEL_hotel_roomSellOrder_payresult (ADELMain_UrlSan@"/lockboss-api/app/roomSellOrder/pay/result.do")
//获取用户订单列表
#define ADEL_hotel_roomSellOrder_list (ADELMain_UrlSan@"/lockboss-api/app/user/roomSellOrder/list.do")

//用户取消/删除订单 用户端使用
#define ADEL_hotel_roomSellOrder_cancel (ADELMain_UrlSan@"/lockboss-api/app/roomSellOrder/cancel.do")

//订单详情
#define ADEL_hotel_roomSellOrder_info (ADELMain_UrlSan@"/lockboss-api/app/user/roomSellOrder/info.do")
//评论预定订单 -- 用户端使用 app
#define ADEL_hotel_roomSellOrder_comment (ADELMain_UrlSan@"/lockboss-api/app/user/roomSellOrder/comment.do")

//评论列表
#define ADEL_hotel_comment_list (ADELMain_UrlSan@"/lockboss-api/app/company/roomSellOrder/comment/list.do")

//用户退款订单 用户端使用
#define ADEL_hotel_roomSellOrder_refund (ADELMain_UrlSan@"/lockboss-api/app/roomSellOrder/refund.do")

//添加浏览记录
#define ADEL_hotel_company_add (ADELMain_UrlSan@"/lockboss-api/app/browsing/company/add.do")

//是否收藏该酒店
#define ADEL_hotel_company_this (ADELMain_UrlSan@"/lockboss-api/app/favorite/company/this.do")

//点击收藏酒店
#define ADEL_hotel_favorite_add (ADELMain_UrlSan@"/lockboss-api/app/favorite/company/add.do")


//收藏列表
#define ADEL_hotel_favorite_list (ADELMain_UrlSan@"/lockboss-api/app/favorite/company/list.do")


#pragma mark 手机开锁--酒店
//获取酒店banner图列表接口   TODO这个IP什么鬼 ??
#define ADEL_hotel_bannerlist (ADELMain_UrlSan@"/hotel-around/bannerImg/queryBannerInfo.do")

//储物箱--开箱
#define ADEL_hotel_storageBox_open (ADL_DEVICE_MQTT@"/lockboss-mqtt/company/user/storageBox/open.do")

//燃气阀-开关
#define ADEL_hotel_gasValve_open (ADL_DEVICE_MQTT@"/lockboss-mqtt/company/user/gasValve/open.do")

//查询储物箱燃气阀的设备信息--貌似不需要,酒店不存在这个操作
#define  ADEL_storageBox_gasValve_deviceInfo  (ADL_DEVICE_MQTT@"/lockboss-api/company/user/dev/info.do")
//查询箱子价格
#define ADEL_storageBox_price (ADELMain_UrlSan@"/lockboss-api/company/user/price.do")
//箱子支付
#define ADEL_storageBox_pay (ADELMain_UrlSan@"/lockboss-api/company/user/pay/qrcode.do")

#pragma mark 区块链

//查询区块链查询权限用户列表
#define ADEL_blockchain_priceinfo (ADELMain_UrlSan@"/lockboss-api/blockchain/price/info.do")

//购买区块链查询 - 用户下单
#define ADEL_userblockchain_pay (ADELMain_UrlSan@"/lockboss-api/user/blockchain/pay.do")

//用户付款成功 用户端使用lockboss-api/blockchain/pay/result.do
#define ADEL_blockchainpay_result (ADELMain_UrlSan@"/lockboss-api/blockchain/pay/result.do")
//查询用户查询权限
#define ADEL_blockchain_query (ADELMain_UrlSan@"/lockboss-api/user/own/blockchain/query.do")


//查询区块链查询权限用户列表
#define ADEL_blockchain_list (ADELMain_UrlSan@"/lockboss-api/user/own/blockchain/list.do")
//用户区块链查询 - 用户端查询
#define ADEL_blockchain_searc (ADELMain_UrlSan@"/lockboss-api/user/blockchain/search.do")

//查询日志列表
#define ADEL_blockchain_recordlist (ADELMain_UrlSan@"/lockboss-api/user/blockchain/query/record/list.do")


//添加区块链查询用户
#define ADEL_blockchain_add (ADELMain_UrlSan@"/lockboss-api/user/own/blockchain/add.do")

//删除区块链查询用户
#define ADEL_blockchain_delete (ADELMain_UrlSan@"/lockboss-api/user/own/blockchain/delete.do")

//线下用户房型 /lockboss-api/app/user/roomSellType/list.do
#define ADEL_roomTypeManage_search (ADELMain_UrlSan@"/lockboss-api/app/user/roomTypeManage/search.do")
//续房 - 用户提交续房申请/lockboss-api/app/user/roomManage/submit/renew.do
#define ADEL_submit_renew (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/submit/renew.do")
//换房 用户提交续房申请 lockboss-api/app/user/roomManage/submit/change.do
#define ADEL_submit_change (ADELMain_UrlSan@"/lockboss-api/app/user/roomManage/submit/change.do")


#endif /* ADELUrlpath_h */
