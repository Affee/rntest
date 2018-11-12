//
//  DDAliPayManager.m
//  Unity-iPhone
//
//  Created by zichenfang on 16/1/7.
//
//

//url scheme
#define aliPayUrlScheme             @"alipayforweidianke"
//合作者id
#define aliPayPartnerID             @"2088421552709955"
//支付宝账户
//#define aliPaySellerAliPayAccount   @"1013630675@qq.com"
#define aliPaySellerAliPayAccount   @"qq2577428994@163.com"


//私钥
#define aliPayPrivateKey            @"MIICXAIBAAKBgQDv5QrgUs5+uhoSBNyq3wCF0MtI2crgIQMJrOIYNGjIMr/gGVGhCYthM7CZsoqDJ88w9lYxFe9T/bnq5NNC9ZMZN7GXDXtjRzzeGgdq03i8stpbzzgFbxSmzeeSdHHKJ4GUpCwCkVcX+MO9ef+Y1qLqBX/ho5Jx4u0VH5+JdPpBTQIDAQABAoGBAIbGJBUhEHfr8AediafJv05unjagfTTr9vvxj9hPYWrP8DJjpxOU/CQw2Q+QWfcTX3i/fG75RsrmKhRIWFQvCWMz/4r8daBwzU5ytnhCqj9Qzxt/m3CmouLkRMQel9GtYmOKyyK+bn6XFvD+tKzqdDKvWIk8dSmOBzV1H8TlkMNBAkEA/NVAFdpavWTuoKC9FzJHtvEMo7RtKdDEKpiBBCXTikN7WS3uI5lN/UdndxMgJz/J8V91eRLYsh0Y4e1fa35cEQJBAPLmTaoNCLA9Rc8DWzB2TqNiOb424Z3T8H55f8lAwqH4WPWs4TWdmo1nNl7/Kd2jJ2VyVLpL06gT5e8Fnr8jfX0CQGqyb9YJDOwKUS3WR5YncN5CQYxAUyUnZfF35FJkyC38JmzPFkVNp/zwCjjVCGen4sgK+d87VdlssBh//Rm2/JECQHt14d3gWB00V6o8G3qLd7cF8zGitZTCKAgw+2mw1/z5vUXKRII7BFaBMpqgeYglKJ4gub4jUoao7oNKSQEAKgUCQFscYPPM8VAbw6Xx+FkO4kByPLc7GAKaC4A9/MVwPjZ4lg1TIoupJMz758XLcfXnMpXH6DBuU4kmN2z7/iIAEuo="


#import "DDAliPayManager.h"

#import "AliPayOrder.h"
#import "DataSigner.h"
//#import "AliPayAuthV2Info.h"

@implementation DDAliPayManager

+(instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static DDAliPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[DDAliPayManager alloc] init];
    });
    return instance;
}


+ (void)payOrderWithOrderID :(NSString *)orderID
                      Title :(NSString *)title
                Description :(NSString *)description
                      Price :(float)price
                  NotifyURL :(NSString *)notifyURL
                      Block :(AliPayFinishedHandler)block

{

    [DDAliPayManager defaultManager].block =block;
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AliPayOrder *order = [[AliPayOrder alloc] init];
    order.partner = [DDAliPayManager defaultManager].partnerId;
    order.sellerID = [DDAliPayManager defaultManager].sellerAcount;
    order.outTradeNO = orderID; //订单ID（由商家自行制定）
    order.subject = title; //商品标题
    order.body = description; //商品描述
//    order.totalFee = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    order.totalFee = [NSString stringWithFormat:@"%.2f",price];
    order.notifyURL =  notifyURL; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = aliPayUrlScheme;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner([DDAliPayManager defaultManager].privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"rrrreslut = %@",resultDic);
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                [DDAliPayManager defaultManager].block(YES);
            }
            else
            {
                [DDAliPayManager defaultManager].block(NO);
            }
            
            
        }];
        
    }
    else
    {
        [ProgressHUD showError:@"订单信息错误！"];
    }
}
@end
