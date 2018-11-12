//
//  MyNetWork.h
//  DressIn3D
//
//  Created by Timo on 15/9/19.
//  Copyright (c) 2015年 Timo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

//数据请求地址
//#define kHTTP @"http://119.23.66.37/zhuanfa_jiafen/index.php?"
//#define kHTTP @"http://192.168.3.16/zhuanfa_jiafen/admin.php?"
//#define kHTTP @"http://weike.qb1611.cn/zhuanfa_jiafen/index.php?"

@interface TTRequestManager : NSObject
+ (id)defaultManager;
//普通的POST传参方式
+ (void)POST:(NSString *)URLString Parameters:(NSDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;
//get
+ (void)GET:(NSString *)URLString Parameters:(NSDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;


//上传data的post方法
+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;

//将字典序列化成字符串  根据参数名称（将所有请求参数按照字母先后顺序排序:key + value .... key + value，然后MD5加密
+ (NSString *)serializeDictionary :(NSDictionary *)dic;

@end
