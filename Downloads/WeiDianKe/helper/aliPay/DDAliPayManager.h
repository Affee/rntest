//
//  DDAliPayManager.h
//  Unity-iPhone
//
//  Created by zichenfang on 16/1/7.
//
//

/*
 
 Alipay接口主要为商户提供订单支付功能。接口所提供的方法，如下表所示：
 
 方法名称	方法描述
 +(Alipay *)defaultService;	获取服务实例。
 -(BOOL)isLogined;	检测本地是否曾登录使用过。
 -(void)payOrder:(NSString *)orderStr fromScheme:(NSString *)schemeStr callback:(CompletionBlock)completionBlock;
 
 */
#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
typedef void (^AliPayFinishedHandler)(BOOL whether);

@interface DDAliPayManager : NSObject
@property(strong)AliPayFinishedHandler block;

@property (strong,nonatomic) NSString* partnerId;
@property (strong,nonatomic) NSString* sellerAcount;
@property (strong,nonatomic) NSString* privateKey;


+(instancetype)defaultManager;

+ (void)payOrderWithOrderID :(NSString *)orderID
                      Title :(NSString *)title
                Description :(NSString *)description
                      Price :(float)price
                      NotifyURL :(NSString *)notifyURL
                      Block :(AliPayFinishedHandler)block;
@end
