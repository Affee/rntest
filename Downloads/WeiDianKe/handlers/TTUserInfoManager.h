//
//  UserInfoManager.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTUserInfoManager : NSObject


@property(strong,nonatomic)NSMutableArray *guanggaoArray;
+ (TTUserInfoManager *)defaultManager;

+ (void)setUserInfo:(NSDictionary *)userInfo;
+ (NSDictionary *)userInfo;
+ (NSString *)token;
+(void)setToken:(NSString *)token;
+(void)setUserId:(NSString *)userId;
+(NSString *)userId;

+(void)setVip_typeid:(NSString *)vip_typeid;
+(NSString *)vip_typeid;

+(UIImage *)touxiang;

+ (void)setAccount:(NSString *)account;
+ (NSString *)account;

+ (void)setUrlArray:(NSArray *)array;

+(NSMutableArray *)urlArray;

//+ (void)setPassword:(NSString *)password;
//+ (NSString *)password;

//系统是否第一次启动
+ (void)setAppHasLaunched:(BOOL)launched;
+ (BOOL)appHasLaunched;

//登录状态
+ (void)setLogined:(BOOL)logined;
+ (BOOL)logined;

//
+ (void)setPhone:(NSString *)phone;
+ (NSString *)phone;

//签到本地验证码验证
+ (void)setSignAuthCode:(NSString *)code;
+ (NSString *)signAuthCode;

@end
