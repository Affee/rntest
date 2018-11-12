    //
//  UserInfoManager.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//




#import "TTUserInfoManager.h"
#import "NSObject+MyCustomObject.h"
#import "NSDictionary+MyCustomDictionary.h"


NSString *const UserInfo = @"UserInfo_userinfo";
//是否启动过APP
NSString *const AppHasLaunched = @"AppHasLaunched";
//登录状态
NSString *const Logined = @"Logined";
NSString *const user_phone = @"phone";
NSString *const Auth_code = @"authcode";


@interface TTUserInfoManager()
@property(nonatomic, strong)NSDictionary *userInfo;
@end
@implementation TTUserInfoManager


+ (TTUserInfoManager *)defaultManager {
    static TTUserInfoManager *manager = nil;
    if (!manager) {
        manager = [[TTUserInfoManager alloc] init]; 
        manager.userInfo =[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo];

    }
    return manager;
}
#pragma mark -用户信息
//用户信息
- (void)setUserInfo:(NSDictionary *)userInfo
{
    if (userInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo noNullObject] forKey:UserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _userInfo = userInfo;
    }
}

+(void)setToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
}

+ (void)setUserInfo:(NSDictionary *)userInfo
{
    [[TTUserInfoManager defaultManager]setUserInfo:userInfo];
}

+ (NSDictionary *)userInfo
{
    return [[TTUserInfoManager defaultManager] userInfo];
}

+(void)setUserId:(NSString *)userId{
    if (userId != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"user_id"];
    }
}

+(NSString *)userId{
    return [[[TTUserInfoManager defaultManager] userInfo] string_ForKey:@"user_id"];
}

+(NSString *)vip_typeid{
        return [[[TTUserInfoManager defaultManager] userInfo] string_ForKey:@"vip_typeid"];
}

//用户账户
- (void)setAccount:(NSString *)account
{
    if (account!=nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo]];
        [dic setObject:account forKey:@"account"];
        [TTUserInfoManager setUserInfo:dic];
    }
}
+ (void)setAccount:(NSString *)account
{
    [[TTUserInfoManager defaultManager]setAccount:account];
}
+ (NSString *)account
{
    return [[[TTUserInfoManager defaultManager] userInfo] string_ForKey:@"phone_mob"];
}
+ (NSString *)token
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
}
////用户密码
//- (void)setPassword:(NSString *)password
//{
//    if (password!=nil) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo]];
//        [dic setObject:password forKey:@"password"];
//        [TTUserInfoManager setUserInfo:dic];
//    }
//}
//+ (void)setPassword:(NSString *)password
//{
//    [[TTUserInfoManager defaultManager]setPassword:password];
//}
//+ (NSString *)password
//{
//    return [[[TTUserInfoManager defaultManager] userInfo] string_ForKey:@"password"];
//}
#pragma mark -系统信息
//系统是否第一次启动
+ (void)setAppHasLaunched:(BOOL)launched
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",launched] forKey:AppHasLaunched];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)appHasLaunched
{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:AppHasLaunched] boolValue];
}

//登录状态
+ (void)setLogined:(BOOL)logined
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",logined] forKey:Logined];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)logined
{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:Logined] boolValue];
}
//

+(void)setUrlArray:(NSArray *)array{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"urlArray"];
}

+(NSMutableArray *)urlArray{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"urlArray"];
}


+(void)setVip_typeid:(NSString *)vip_typeid{
    [TTUserInfoManager setUserInfo:@{@"vip_typeid":vip_typeid}];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setPhone:(NSString *)phone
{
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:user_phone];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)phone
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:user_phone] ;

}

//签到本地验证码验证
+ (void)setSignAuthCode:(NSString *)code
{
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:Auth_code];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)signAuthCode
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:Auth_code] ;
}
@end
