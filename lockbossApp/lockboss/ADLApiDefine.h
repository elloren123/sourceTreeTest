//
//  ADLApiDefine.h
//  lockboss
//
//  Created by Han on 2019/4/14.
//  Copyright © 2019 adel. All rights reserved.
//

#ifndef ADLApiDefine_h
#define ADLApiDefine_h

//锁老大商城下载地址
static NSString *const k_lockboss_download_string          = @"https://itunes.apple.com/cn/app/id1460566050?mt=8";

//微信下载地址
static NSString *const k_wechat_download_string            = @"https://itunes.apple.com/cn/app/id414478124?mt=8";

//iPhone_QQ下载地址
static NSString *const k_qq_download_string                = @"https://itunes.apple.com/cn/app/id444934666?mt=8";

//iPad_QQ下载地址
static NSString *const k_qqipad_download_string            = @"https://itunes.apple.com/cn/app/id453718989?mt=8";

//APP分享地址
static NSString *const k_app_share_string                  = @"http://www.adellock.com";

//发送手机验证码
static NSString *const k_send_msg_code                     = @"shop-app/merchantEntry/sendSmsCode";

//商城
static NSString *const k_store_page                        = @"shop-app/mall/shopIndex";

//首页公告
static NSString *const k_query_announcement                = @"shop-app/message/queryALLAnnouncement";

//搜索商品
static NSString *const k_search_goods                      = @"shop-app/search/searchGoods";

//修改头像
static NSString *const k_modify_headshot                   = @"shop-api/adelUser/updateHeadShot";

//修改昵称
static NSString *const k_modify_nickname                   = @"shop-api/adelUser/updateNickName";

//修改手机
static NSString *const k_update_phone                      = @"shop-api/adelUser/updatePhone";

//发送邮箱验证码
static NSString *const k_send_email_code                   = @"shop-app/merchantEntry/sendEmailCode";

//修改邮箱
static NSString *const k_update_email                      = @"shop-api/adelUser/updateEmail";

//添加增票资质
static NSString *const k_add_qualification                 = @"shop-app/invoice/addInvoiceQualification";

//查询增票资质
static NSString *const k_query_qualification               = @"shop-app/invoice/queryInvoiceQualification";

//修改增票资质
static NSString *const k_modify_qualification              = @"shop-app/invoice/editInvoiceQualification";

//添加发票
static NSString *const k_add_invoice                       = @"shop-app/invoice/addInvoice";

//查询发票
static NSString *const k_query_invoice                     = @"shop-app/invoice/queryInvoiceByUser";

//修改发票
static NSString *const k_modify_invoice                    = @"shop-app/invoice/updateInvoice";

//添加购物车
static NSString *const k_add_car                           = @"shop-app/car/add";

//修改购物车
static NSString *const k_modify_car                        = @"shop-app/car/update";

//删除购物车
static NSString *const k_delete_car                        = @"shop-app/car/delete";

//查询购物车
static NSString *const k_query_car_list                    = @"shop-app/car/list";

//查询收货地址列表
static NSString *const k_query_address_list                = @"shop-app/address/queryByUserId";

//查询单个收货地址详情
static NSString *const k_query_address_detail              = @"shop-app/address/queryById";

//添加收货地址
static NSString *const k_add_address                       = @"shop-app/address/save";

//修改收货地址
static NSString *const k_modify_address                    = @"shop-app/address/update";

//删除收货地址
static NSString *const k_delete_address                    = @"shop-app/address/deleteById";

//Banner
static NSString *const k_query_banner                      = @"shop-app/bannerImg/queryBannerInfo";

//商城早报
static NSString *const k_discovery_list                    = @"shop-app/morningPaper/list";

//查询是否有未读消息
static NSString *const k_query_unread_msg                  = @"shop-app/message/queryNotRead";

//查询消息中心列表
static NSString *const k_query_all_msg                     = @"shop-app/message/queryALLMsgType";

//查询消息设置
static NSString *const k_query_msg_setting                 = @"shop-app/message/querySetByUserId";

//用户是否接收消息
static NSString *const k_update_msg_setting                = @"shop-app/message/setMessageReceive";

//查询对应消息类型列表
static NSString *const k_query_msg_type                    = @"shop-app/message/queryMsgByType";

//删除消息
static NSString *const k_delete_msg                        = @"shop-app/message/removeMessage";

//设置消息类型为已读
static NSString *const k_set_msg_read                      = @"shop-app/message/setMessageRead";

//抢购商品
static NSString *const k_panic_list                        = @"shop-app/activity/getPurchasingList";

//查询活动列表
static NSString *const k_query_activity_list               = @"shop-app/activity/getActivityList";

//查询新人专享优惠券
static NSString *const k_new_user_coupon                   = @"shop-app/coupon/queryNewUserCoupon";

//早报详情
static NSString *const k_morning_detail                    = @"shop-app/morningPaper/selectById";

//添加早报评论
static NSString *const k_morning_add_comment               = @"shop-app/morningPaper/saveEvaluate";

//获取早报评论
static NSString *const k_morning_comment                   = @"shop-app/morningPaper/queryEvaluateList";

//早报点赞
static NSString *const k_morning_praise                    = @"shop-app/morningPaper/praiseMorningPaper";

//早报评论点赞
static NSString *const k_morning_comment_praise            = @"shop-app/morningPaper/praiseEvaluate";

//查询优惠券数量
static NSString *const k_query_coupon_count                = @"shop-app/coupon/queryUserCouponCount";

//查询优惠券
static NSString *const k_query_coupon                      = @"shop-app/coupon/queryUserCouponByStatus";

//删除优惠券
static NSString *const k_delete_coupon                     = @"shop-app/coupon/deleteUserCoupon";

//领券中心
static NSString *const k_query_coupon_center               = @"shop-app/coupon/queryCouponCore";

//领取优惠券
static NSString *const k_draw_coupon                       = @"shop-app/coupon/getUserCoupon";

//查询活动商品
static NSString *const k_query_activity_goods              = @"shop-app/activity/getGoodsListByActivityId";

//查询商品信息
static NSString *const k_goods_information                 = @"shop-app/goods/searchGoods";

//收藏商品
static NSString *const k_collect_goods                     = @"shop-app/goods/usersCollectGoods";

//商品评价
static NSString *const k_goods_evaluate_list               = @"shop-app/evaluate/list";

//商品各个评价类型数量
static NSString *const k_goods_evaluate_count              = @"shop-app/evaluate/queryForType";

//商品评价回复、点赞
static NSString *const k_goods_evaluate_reply              = @"shop-app/evaluate/saveReply";

//商品详情图片
static NSString *const k_goods_detail_image                = @"shop-app/goods/getDetailImg";

//商品详情里面根据所选的sku查询商品规格
static NSString *const k_goods_sku_detail                  = @"shop-app/goods/searchDetail";

//查询商品LS-10认证信息接口
static NSString *const k_goods_ls_information              = @"shop-app/goods/getGoodsCertification";

//查询收藏的商品
static NSString *const k_goods_collection                  = @"shop-app/goods/queryUserCollect";

//查询推荐的商品
static NSString *const k_goods_relevant                    = @"shop-app/goods/searchRelevantGoods";

//查询地区门锁安装费
static NSString *const k_install_lock_cost                 = @"shop-app/goods/queryInstallCost";

//资料库文件夹列表
static NSString *const k_datum_folder_list                 = @"shop-app/datum/list";

//资料库单个文件夹文件列表
static NSString *const k_datum_file_list                   = @"shop-app/datum/childInfo";

//文件信息
static NSString *const k_datum_file_detail                 = @"shop-app/datum/detail";

//购买商品待评价、已评价列表
static NSString *const k_goods_my_evaluate_list            = @"shop-app/evaluate/selectEvaluateList";

//提交订单，查询物流公司
static NSString *const k_order_express_company             = @"shop-app/express/getExpressCompany";

//提交订单，查询可用优惠券
static NSString *const k_order_coupon                      = @"shop-app/coupon/queryCouponForOrder";

//提交订单，查询商品运费
static NSString *const k_order_express_fee                 = @"shop-app/express/countExpressFee";

//提交订单
static NSString *const k_submit_order                      = @"shop-app/order/add";

//修改订单
static NSString *const k_update_order                      = @"shop-app/order/update";

//取消订单
static NSString *const k_order_cancle                      = @"shop-app/order/orderCancle";

//支付订单
static NSString *const k_order_pay                         = @"shop-app/order/orderPay";

//圈子首页
static NSString *const k_circle_homepage                   = @"shop-app/circle/index";

//创建圈子
static NSString *const k_circle_create                     = @"shop-app/circle/save";

//退出圈子
static NSString *const k_delete_circle                     = @"shop-app/groupMember/quit";

//解散圈子
static NSString *const k_disband_circle                    = @"shop-app/circle/disband";

//搜索圈子
static NSString *const k_search_circle                     = @"shop-app/circle/search";

//圈子详情
static NSString *const k_circle_detail                     = @"shop-app/circle/details";

//申请加入圈子
static NSString *const k_circle_apply_join                 = @"shop-app/applyJoin/save";

//进群审核列表
static NSString *const k_circle_review_list                = @"shop-app/applyJoin/list";

//删除进群审核申请
static NSString *const k_circle_review_delete              = @"shop-app/applyJoin/delete";

//进群审核
static NSString *const k_circle_review_join                = @"shop-app/applyJoin/verify";

//话题列表
static NSString *const k_topic_list                        = @"shop-app/topic/list";

//话题详情
static NSString *const k_topic_detail                      = @"shop-app/topic/details";

//发表话题
static NSString *const k_topic_publish                     = @"shop-app/topic/save";

//删除话题
static NSString *const k_topic_delete                      = @"shop-app/topic/deleteTopic";

//话题点赞、评论
static NSString *const k_topic_comment_praise              = @"shop-app/topicComment/save";

//话题取消点赞
static NSString *const k_topic_cancle_praise               = @"shop-app/topicComment/cancelFabulous";

//话题取消点赞
static NSString *const k_topic_evaluate_list               = @"shop-app/topicComment/list";

//评论点赞、回复
static NSString *const k_comment_reply_praise              = @"shop-app/commentReply/save";

//评论取消点赞
static NSString *const k_comment_cancle_praise             = @"shop-app/commentReply/cancelFabulous";

//删除评论
static NSString *const k_comment_delete                    = @"shop-app/topicComment/delete";

//评论回复
static NSString *const k_comment_reply                     = @"shop-app/commentReply/list";

//删除回复
static NSString *const k_reply_delete                      = @"shop-app/commentReply/delete";

//举报
static NSString *const k_topic_report                      = @"shop-app/report/save";

//上传图片
static NSString *const k_upload_image                      = @"shop-app/imgs/upload";

//商家入驻资费
static NSString *const k_settle_tariff                     = @"shop-app/platformTariff/selectAll";

//添加商家入驻申请
static NSString *const k_settle_add_apply                  = @"shop-app/merchantEntry/save";

//我的商家入驻申请
static NSString *const k_settle_my_apply                   = @"shop-app/merchantEntry/selectByUserId";

//撤销商家入驻申请
static NSString *const k_settle_revocation_apply           = @"shop-app/merchantEntry/changeStatus";

//支付商家入驻保证金
static NSString *const k_settle_pay                        = @"shop-app/merchantEntry/payMoney";

//招商加盟
static NSString *const k_league_city                       = @"shop-app/recordInfo/queryByStatus";

//备案城市坐标
static NSString *const k_league_coordinate                 = @"shop-app/recordInfo/queryLocation";

//添加备案人
static NSString *const k_record_add_person                 = @"shop-app/recordInfo/addRecordMan";

//我的备案人申请
static NSString *const k_record_my_apply                   = @"shop-app/recordInfo/queryRecordMan";

//我的备案
static NSString *const k_record_my_project                 = @"shop-app/projectRecord/queryByStatus";

//项目备案
static NSString *const k_record_project                    = @"shop-app/projectRecord/addProject";

//支付备案人保证金
static NSString *const k_recorder_pay                      = @"shop-app/recordInfo/payMoney";

//取消项目备案
static NSString *const k_cancle_project_record             = @"shop-app/projectRecord/changeStatus";

//查询项目备案信息
static NSString *const k_query_project_record              = @"shop-app/projectRecord/queryById";

//项目备案信息审核之前修改
static NSString *const k_modify_project_record             = @"shop-app/projectRecord/editProject";

//再次提交项目备案信息
static NSString *const k_submit_project_record             = @"shop-app/projectRecord/againSubmitProject";

//查询所有服务
static NSString *const k_query_all_service                 = @"shop-app/goods/queryALLService";

//查询所有服务费用
static NSString *const k_query_service_price               = @"shop-app/goods/queryServiceByAreaId";

//查询锁匠列表
static NSString *const k_query_locker_list                 = @"shop-app/serviceArtisanInfo/queryLocksmith";

//查询锁匠详情
static NSString *const k_query_locker_detail               = @"shop-app/serviceArtisanInfo/queryArtisanDetail";

//查询锁匠评价列表
static NSString *const k_query_locker_evaluate             = @"shop-app/serviceEvaluate/selectByArtisanId";

//确认服务完成
static NSString *const k_service_confirm_finish            = @"shop-app/order/confirmServiceReceipt";

//我的订单
static NSString *const k_query_my_order                    = @"shop-app/order/list";

//提醒发货
static NSString *const k_remind_shipment                   = @"shop-app/reminderShipment/save";

//订单详情
static NSString *const k_order_detail                      = @"shop-app/order/orderDetails";

//确认收货
static NSString *const k_order_confirm_receipt             = @"shop-app/order/confirmReceipt";

//商品评价
static NSString *const k_goods_add_evaluate                = @"shop-app/evaluate/saveEvaluate";

//备案人评价列表
static NSString *const k_recorder_evaluate_list            = @"shop-app/evaluate/queryServiceEvaluate";

//备案人信息
static NSString *const k_recorder_detail                   = @"shop-app/recordInfo/queryRecordList";

//拨打电话添加备案人服务记录
static NSString *const k_recorder_phone_call               = @"shop-app/serviceRecord/save";

//添加备案人服务评价
static NSString *const k_recorder_add_evaluate             = @"shop-app/evaluate/saveServiceEvaluate";

//添加服务评价
static NSString *const k_service_add_evaluate              = @"shop-app/serviceEvaluate/save";

//查询备案人信息
static NSString *const k_query_recorder_detail             = @"shop-app/recordInfo/queryByIdForApp";

//查询售后订单列表
static NSString *const k_query_after_sale_list             = @"shop-app/customerService/list";

//查询商品评价回复
static NSString *const k_query_goods_evaluate_reply        = @"shop-app/evaluate/replyList";

//查询商品评价回复
static NSString *const k_query_goods_more_reply            = @"shop-app/evaluate/queryMoreReply";

//添加售后订单
static NSString *const k_add_after_sale                    = @"shop-app/customerService/save";

//售后订单详情
static NSString *const k_query_after_sale_detail           = @"shop-app/customerService/queryCustomerDetail";

//售后订单详情获取快递公司
static NSString *const k_query_after_sale_exp              = @"shop-app/express/queryExpressCompanyInfo";

//售后订单换货确认收货
static NSString *const k_after_sale_confirm_ship           = @"shop-app/customerService/deliverGoods";

//售后订单添加物流信息
static NSString *const k_after_sale_add_express            = @"shop-app/customerService/saveCustomerExpress";

//查询物流
static NSString *const k_query_logistics                   = @"shop-app/express/queryExpressInfo";

//修改订单发票
static NSString *const k_update_order_invoice              = @"shop-app/order/updateReceiptInfo";

//用户反馈
static NSString *const k_user_feedback                     = @"shop-app/feedback/save";

//申请备案人修改手机号
static NSString *const k_recorder_modify_phone             = @"shop-api/smsCode/checkPhoneAndCode";

//商家入驻修改手机号
static NSString *const k_settle_modify_phone               = @"shop-app/merchantEntry/updatePhone";

//商家入驻修改邮箱
static NSString *const k_settle_modify_email               = @"shop-app/merchantEntry/updateEmail";

//获取用户IM账号密码
static NSString *const k_user_im_info                      = @"shop-app/im/getImInfo";

//获取在线客服用户名
static NSString *const k_merchant_im_info                  = @"shop-app/im/getAdminUserName";

//验证Token
static NSString *const k_verify_token                      = @"shop-api/adelUser/saveToken";

//用户--酒店--banner
static NSString *const k_hotel_banner                      = @"hotel-around/bannerImg/queryBannerInfo.do";

#endif
