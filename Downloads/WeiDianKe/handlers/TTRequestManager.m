//
//  MyNetWork.m
//  DressIn3D
//
//  Created by Timo on 15/9/19.
//  Copyright (c) 2015年 Timo. All rights reserved.
//

#import "TTRequestManager.h"
#import "NSString+MyCustomString.h"
#import "NSDictionary+MyCustomDictionary.h"
#import "NSObject+MyCustomObject.h"
#import "ProgressHUD.h"


//API协议版本
#define kApiVersion @"v1"
//API传的参数 appkey
#define kAppKeyForApi @"12605981"
//API传的参数 appSecrect
#define kAppSecrectForApi @"42a198cd868a9e5a9e9c73a0fc45bfaf"
//API传的参数 平台
#define kAppPlatform @"ios"


@interface TTRequestManager()
@end

@implementation TTRequestManager
+ (id)defaultManager
{
    static TTRequestManager *manager;
    if (manager ==nil) {
        manager = [[TTRequestManager alloc] init];
    }
    return manager;
}
//普通的POST传参方式
+ (void)POST:(NSString *)URLString Parameters:(NSDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval =10.0f;
    NSMutableDictionary *paraAll = [NSMutableDictionary dictionary];
    if (parameters) {
        [paraAll setDictionary:parameters];
    }
//    /*系统的公共参数集中在这里*/
//    //设备平台
//    [paraAll setObject:@"ios" forKey:@"client"];
//    //时间戳  API服务端允许客户端请求时间误差为6分钟
//    [paraAll setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
//    //app_key  AppKey
//    [paraAll setObject:kAppKeyForApi forKey:@"app_key"];
//    //v  API协议版本
//    [paraAll setObject:kApiVersion forKey:@"v"];
//    //sign_method 参数的加密方法选择，可选值是：md5
//    [paraAll setObject:@"md5" forKey:@"sign_method"];
//    // sign 对 API 调用参数（除sign外）进行 md5 加密获得。
//    [paraAll setObject:[TTRequestManager serializeDictionary:paraAll].absoluteString.md5_32Bit_String forKey:@"sign"];
    NSLog(@"URLString =%@ \n paraAll =%@ \n ",URLString,paraAll);
    [TTRequestManager currentVC].view.userInteractionEnabled = NO;
    [TTRequestManager currentVC].navigationController.view.userInteractionEnabled = NO;
    [manager POST:URLString parameters:paraAll progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [TTRequestManager currentVC].view.userInteractionEnabled = YES;
        [TTRequestManager currentVC].navigationController.view.userInteractionEnabled = YES;
        NSDictionary *cacheDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//        NSLog(@" cacheDic  =%@\n ",cacheDic);
        mySuccess(cacheDic.noNullObject);
//        NSString *ret = [cacheDic.noNullObject objectForKey:@"ret"];
//        if (ret.intValue ==100) {
//            [[[UIAlertView alloc] initWithTitle:@"用户错误，请重新登录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [TTRequestManager currentVC].view.userInteractionEnabled = YES;
        [TTRequestManager currentVC].navigationController.view.userInteractionEnabled = YES;
        [ProgressHUD showError:@"网络不可用"];
        NSLog(@"%@",error);
        myFailure(error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;

    }];
    
}
//普通的传参方式GET
+ (void)GET:(NSString *)URLString Parameters:(NSDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval =10.0f;
    NSMutableDictionary *paraAll = [NSMutableDictionary dictionary];
    if (parameters) {
        [paraAll setDictionary:parameters];
    }
//    /*系统的公共参数集中在这里*/
//    //设备平台
//    [paraAll setObject:@"ios" forKey:@"client"];
//    //时间戳  API服务端允许客户端请求时间误差为6分钟
//    [paraAll setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
//    //app_key  AppKey
//    [paraAll setObject:kAppKeyForApi forKey:@"app_key"];
//    //v  API协议版本
//    [paraAll setObject:kApiVersion forKey:@"v"];
//    //sign_method 参数的加密方法选择，可选值是：md5
//    [paraAll setObject:@"md5" forKey:@"sign_method"];
//    // sign 对 API 调用参数（除sign外）进行 md5 加密获得。
//    [paraAll setObject:[TTRequestManager serializeDictionary:paraAll].absoluteString.md5_32Bit_String forKey:@"sign"];
    NSLog(@"URLString =%@ \n paraAll =%@ \n ",URLString,paraAll);
    [TTRequestManager currentVC].view.userInteractionEnabled = NO;
    [TTRequestManager currentVC].navigationController.view.userInteractionEnabled = NO;
    [manager GET:URLString parameters:paraAll progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [TTRequestManager currentVC].view.userInteractionEnabled = YES;
        [TTRequestManager currentVC].navigationController.view.userInteractionEnabled = YES;
        NSDictionary *cacheDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@" cacheDic  =%@\n ",cacheDic);
        mySuccess(cacheDic.noNullObject);
//        NSString *ret = [cacheDic.noNullObject objectForKey:@"ret"];
//        if (ret.intValue ==100) {
//            [[[UIAlertView alloc] initWithTitle:@"用户错误，请重新登录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [TTRequestManager currentVC].view.userInteractionEnabled = YES;
        [TTRequestManager currentVC].navigationController.view.userInteractionEnabled = YES;
        [ProgressHUD showError:@"网络不可用"];
        NSLog(@"%@",error);
        myFailure(error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    }];
}
//上传data的post方法
+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval =10.0f;
    NSMutableDictionary *paraAll = [NSMutableDictionary dictionary];
    if (parameters) {
        [paraAll setDictionary:parameters];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
//    /*系统的公共参数集中在这里*/
//    //设备平台
//    [paraAll setObject:@"ios" forKey:@"client"];
//    //时间戳  API服务端允许客户端请求时间误差为6分钟
//    [paraAll setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
//    //app_key  AppKey
//    [paraAll setObject:kAppKeyForApi forKey:@"app_key"];
//    //v  API协议版本
//    [paraAll setObject:kApiVersion forKey:@"v"];
//    //sign_method 参数的加密方法选择，可选值是：md5
//    [paraAll setObject:@"md5" forKey:@"sign_method"];
//    // sign 对 API 调用参数（除sign外）进行 md5 加密获得。
//    [paraAll setObject:[TTRequestManager serializeDictionary:paraAll].absoluteString.md5_32Bit_String forKey:@"sign"];
    NSLog(@"URLString =%@ \n paraAll =%@ \n ",URLString,paraAll);
    [TTRequestManager currentVC].view.userInteractionEnabled = NO;
    [TTRequestManager currentVC].navigationController.view.userInteractionEnabled = NO;
    [manager POST:URLString parameters:paraAll constructingBodyWithBlock:block progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [TTRequestManager currentVC].view.userInteractionEnabled = YES;
        [TTRequestManager currentVC].navigationController.view.userInteractionEnabled = YES;
        NSDictionary *cacheDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@" cacheDic  =%@\n ",cacheDic);
        mySuccess(cacheDic.noNullObject);
//        NSString *ret = [cacheDic.noNullObject objectForKey:@"ret"];
//        if (ret.intValue ==100) {
//            [[[UIAlertView alloc] initWithTitle:@"用户错误，请重新登录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [TTRequestManager currentVC].view.userInteractionEnabled = YES;
        [TTRequestManager currentVC].navigationController.view.userInteractionEnabled = YES;
        [ProgressHUD showError:@"网络不可用"];
        NSLog(@"%@",error);
        myFailure(error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    }];
}






//将字典序列化成字符串  根据参数名称,将所有请求参数按照字母先后顺序排序:key + value .... key + value,然后首尾拼接appsecrect
+ (NSString *)serializeDictionary :(NSDictionary *)dic
{
    if (dic ==nil||dic.allKeys.count==0) {
        return @"";
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:[dic allKeys]];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 localizedCompare:obj2];
    }];
    NSMutableString *str = [NSMutableString string];
    [str appendString:kAppKeyForApi];
    for (int i=0; i<array.count; i++) {
        NSString *akey = [array objectAtIndex:i];
        NSString *value =[dic string_ForKey:akey];
        if (value ==nil||value.length<=0)//过滤掉value为空的键值对
        {
            continue;
        }
        [str appendFormat:@"%@%@",akey,[dic string_ForKey:akey]];
    }
    [str appendString:kAppSecrectForApi];
    NSLog(@"序列化后的字符串= %@",str);
    return str;
}

+ (UIViewController *)currentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
