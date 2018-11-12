//
//  DDShareManager.h
//  WeiboSDKLibDemo
//
//  Created by zichenfang on 15/11/24.
//  Copyright © 2015年 SINA iOS Team. All rights reserved.
//




#import <Foundation/Foundation.h>


#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"




@interface TTUmengManager : NSObject

+ (void)setUp;


+(void)shareContentWithTitle:(NSString *)title
                        Url :(NSString *)url
                   shareText:(NSString *)shareText
                    shareImage:(id)shareImage
                      delegate:(id <UMSocialUIDelegate>)delegate
                 inSheetView:(UIViewController *)controller;


@end
/*
 由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法，[UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatsession, UMShareToWechatTimeline]]; 这个接口只对默认分享面板平台有隐藏功能，自定义分享面板或登录按钮需要自己处理
 
 */


