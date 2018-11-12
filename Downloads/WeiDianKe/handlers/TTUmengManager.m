//
//  DDShareManager.m
//  WeiboSDKLibDemo
//
//  Created by zichenfang on 15/11/24.
//  Copyright © 2015年 SINA iOS Team. All rights reserved.
//

//友盟appkey
#define kUMAppKey                       @"5822de7e5312dd084d003520"
//

/**
 *  分享参数
 *
 
 */
#define kShareQQAppId                   @"1105616487"
#define kShareQQAppKey                  @"azdubC3iZzybxWXS"
#define kShareQQUrl                  @"http://www.google.com/"

#define kShareWeChatAppId               @"wxfc2fdeb0868877ac"
#define kShareWeChatAppSecrect          @"3da019df02117fa684be6227123d744c"



#import "TTUmengManager.h"

@implementation TTUmengManager


+ (void)setUp
{
    [UMSocialData setAppKey:kUMAppKey];

    [UMSocialQQHandler setQQWithAppId:kShareQQAppId appKey:kShareQQAppKey url:kShareQQUrl];
    [UMSocialWechatHandler setWXAppId:kShareWeChatAppId appSecret:kShareWeChatAppSecrect url:nil];
}

+(void)shareContentWithTitle:(NSString *)title
                        Url :(NSString *)url
                   shareText:(NSString *)shareText
                  shareImage:(id)shareImage
                    delegate:(id <UMSocialUIDelegate>)delegate
                 inSheetView:(UIViewController *)controller
{
    /*
     shareToSnsNames	定义列表出现的微博平台字符串构成的数组，字符变量名为UMShareToSina、UMShareToTencent、UMShareToWechatSession、UMShareToWechatTimeline、UMShareToQzone、UMShareToQQ、UMShareToRenren、UMShareToDouban、UMShareToEmail、UMShareToSms、UMShareToFacebook、UMShareToTwitter，分别代表新浪微博、腾讯微博、微信好友、微信朋友圈、QQ空间、手机QQ、人人网、豆瓣、电子邮箱、短信、Facebook、Twitter

     */
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;

    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;


    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:kUMAppKey
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,nil]
                                       delegate:delegate];
}
@end
