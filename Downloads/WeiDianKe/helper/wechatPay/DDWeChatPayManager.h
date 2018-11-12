//
//  DDWeiChatPayManager.h
//  Unity-iPhone
//
//  Created by zichenfang on 16/1/7.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
typedef void (^WechatPayFinishedHandler)(BOOL whether);

@interface DDWeChatPayManager : NSObject<WXApiDelegate>
@property(strong)WechatPayFinishedHandler block;

@property (strong,nonatomic) NSString* appId;
@property (strong,nonatomic) NSString* mchId;
@property (strong,nonatomic) NSString* kkey;

+(instancetype)defaultManager ;

+ (BOOL)payWithDescription :(NSString *)description
                    Detail :(NSString *)detail
                  Trade_no :(NSString *)out_trade_no
                  Total_fee: (float)total_fee
                 NotifyURL :(NSString *)notifyURL
                     Block :(WechatPayFinishedHandler)block;
@end
