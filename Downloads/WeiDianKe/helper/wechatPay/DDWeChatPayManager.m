//
//  DDWeiChatPayManager.m
//  Unity-iPhone
//
//  Created by zichenfang on 16/1/7.
//
//

#warning wetchat pay config

//公众账号ID	appid	是	String(32)	wx8888888888888888	微信分配的公众账号ID（企业号corpid即为此appId）wxfc2fdeb0868877ac
#define kAppId               @"wxfc2fdeb0868877ac"
//商户号	mch_id	是	String(32)	1230000109	微信支付分配的商户号
#define kMch_id               @"1441756802"
//微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置(套套的秘钥啊，日了狗了)
#define kKey               @"8C92E4E1B417D0EB297EDF29AA716666"


#import "DDWeChatPayManager.h"
#import "XMLDictionary.h"
#import "NSDictionary+MyCustomDictionary.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "NSString+MyCustomString.h"
#import "NSObject+MyCustomObject.h"

@implementation DDWeChatPayManager

+(instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static DDWeChatPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[DDWeChatPayManager alloc] init];
        [WXApi registerApp:instance.appId];
    });
    return instance;
}

//微信原支付金额单位是分，这里做了统一，转换成了元。
+ (BOOL)payWithDescription :(NSString *)description
                          Detail :(NSString *)detail
                        Trade_no :(NSString *)out_trade_no
                        Total_fee: (float)total_fee
                       NotifyURL :(NSString *)notifyURL
                           Block :(WechatPayFinishedHandler)block

{
    [DDWeChatPayManager defaultManager].block = block;
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setObject:[DDWeChatPayManager defaultManager].appId forKey:@"appid"];//    公众账号ID	appid	是	String(32)	wxd678efh567hg6787	微信分配的公众账号ID（企业号corpid即为此appId）
    [para setObject:[DDWeChatPayManager defaultManager].mchId forKey:@"mch_id"];//    商户号	mch_id	是	String(32)	1230000109	微信支付分配的商户号
    [para setObject:[NSString random32bitString] forKey:@"nonce_str"];//    随机字符串	nonce_str	是	String(32)	5K8264ILTKCH16CQ2502SI8ZNMTM67VS	随机字符串，不长于32位。推荐随机数生成算法
    [para setObject:description forKey:@"body"];//    商品描述	body	是	String(128)	Ipad mini  16G  白色	商品或支付单简要描述
    [para setObject:out_trade_no forKey:@"out_trade_no"];//    商户订单号	out_trade_no	是	String(32)	20150806125346	商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号
    [para setObject:[NSString stringWithFormat:@"%d",(int)(total_fee*100)] forKey:@"total_fee"];//    总金额	total_fee	是	Int	888	订单总金额，单位为分，详见支付金额
    [para setObject:[DDWeChatPayManager localIP] forKey:@"spbill_create_ip"]; //    终端IP	spbill_create_ip	是	String(16)	123.12.12.123	APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
    [para setObject:notifyURL forKey:@"notify_url"];//接收微信支付异步通知回调地址，通知url必须为直接可访问的url，不能携带参数。
    [para setObject:@"APP" forKey:@"trade_type"];//    交易类型	trade_type	是	String(16)	JSAPI	取值如下：JSAPI，NATIVE，APP，详细说明见参数规定
    NSString *sign =[NSString stringWithFormat:@"%@&key=%@",[self keyAndValueInAscendingWithDic:para],[DDWeChatPayManager defaultManager].kkey].md5_32Bit_String.uppercaseString;
    [para setObject:sign forKey:@"sign"];//    签名	sign	是	String(32)	C380BEC2BFD727A4B6845133519F3AD6	签名，详见签名生成算法
    NSLog(@"para =%@",para);
    NSString *prePayUrl = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:prePayUrl]];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:para.xmlPostData];
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSDictionary *dict = [NSDictionary dictionaryWithXMLData:responseData];
    NSLog(@"微信预付单返回数据: %@", dict);
    NSString *result_code = [dict string_ForKey:@"result_code"];
    if ([result_code isEqualToString:@"SUCCESS"]) {
        //调起微信支付
        PayReq* req = [[PayReq alloc] init];

        req.openID = [DDWeChatPayManager defaultManager].appId;//        公众账号ID	``appid	String(32)	是	wx8888888888888888	微信分配的公众账号ID
        req.partnerId  =[DDWeChatPayManager defaultManager].mchId;//        商户号	``partnerid	String(32)	是	1900000109	微信支付分配的商户号
        req.prepayId            = [dict objectForKey:@"prepay_id"];//        预支付交易会话ID	``prepayid	String(32)	是	WX1217752501201407033233368018	微信返回的支付交易会话ID

        req.package             = @"Sign=WXPay";//        扩展字段	``package	String(128)	是	Sign=WXPay	暂填写固定值Sign=WXPay

        req.nonceStr            = [dict objectForKey:@"nonce_str"];//        随机字符串	``noncestr	String(32)	是	5K8264ILTKCH16CQ2502SI8ZNMTM67VS	随机字符串，不长于32位。推荐随机数生成算法
        req.timeStamp           = (int)[[NSDate date] timeIntervalSince1970];//        时间戳	``timestamp	String(10)	是	1412000000	时间戳，请见接口规则-参数规定
        req.sign                = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%d&key=%@",req.openID,req.nonceStr,req.package,req.partnerId,req.prepayId,req.timeStamp,[DDWeChatPayManager defaultManager].kkey].md5_32Bit_String.uppercaseString;//        签名	``sign	String(32)	是	C380BEC2BFD727A4B6845133519F3AD6	签名，详见签名生成算法
        [WXApi sendReq:req];
        return YES;

    }
    else
    {
        return NO;
    }
}


-(void)onResp:(BaseResp*)resp{
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                self.block(YES);
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);

            }
                break;
                
            default:
            {
                self.block(NO);
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            }
                break;
        }
 
    }

}
/*设所有发送或者接收到的数据为集合M，将集合M内非空参数值的参数按照参数名ASCII码从小到大排序（字典序），使用URL键值对的格式（即key1=value1&key2=value2…）拼接成字符串stringA。
 特别注意以下重要规则：
 ◆ 参数名ASCII码从小到大排序（字典序）；
 ◆ 如果参数的值为空不参与签名；
 ◆ 参数名区分大小写；
 ◆ 验证调用返回或微信主动通知签名时，传送的sign参数不参与签名，将生成的签名与该sign值作校验。
 ◆ 微信接口可能增加字段，验证签名时必须支持增加的扩展字段
 */
//升序
+ (NSString *)keyAndValueInAscendingWithDic :(NSDictionary *)dic
{
    if (dic ==nil||dic.allKeys.count==0) {
        return @"";
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:[dic allKeys]];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 localizedCompare:obj2];
    }];
    NSMutableString *str = [NSMutableString string];
    for (int i=0; i<array.count; i++) {
        NSString *akey = [array objectAtIndex:i];
        NSString *value =[dic string_ForKey:akey];
        if (value ==nil||value.length<=0)//过滤掉value为空的键值对
        {
            continue;
        }
        [str appendFormat:@"&%@=%@",akey,[dic string_ForKey:akey]];
    }
    [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    return str;
}

+ (NSString *)localIP
{
    NSString *localAddress = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    localAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return localAddress;
}
@end
