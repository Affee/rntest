//
//  ShareViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/12.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "ShareViewController.h"
#import <UMSocial.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.borderView.layer.borderColor = [UIColor redColor].CGColor;
    self.borderView.layer.borderWidth = 2;
    self.borderView.layer.cornerRadius = 10;

    UITapGestureRecognizer* bgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTap)];
    [self.view addGestureRecognizer:bgTap];

    [self setupViewTap];
    
}

-(void)setupViewTap{
    UITapGestureRecognizer* wc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weBtnClick)];
    UITapGestureRecognizer* tl = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(friendBtnClick)];
    UITapGestureRecognizer* cl = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cpyLinkBtnClick)];
    UITapGestureRecognizer* cp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cpyPicBtnClick)];
    UITapGestureRecognizer* qz = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qqZoneBtnClick)];
    UITapGestureRecognizer* q = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qqBtnClick)];
    
    [self.wechat addGestureRecognizer:wc];
    [self.timeline addGestureRecognizer:tl];
    [self.cpylink addGestureRecognizer:cl];
    [self.cpyphoto addGestureRecognizer:cp];
    [self.qzone addGestureRecognizer:qz];
    [self.qq addGestureRecognizer:q];
}


-(void)bgTap{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)weBtnClick{
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://weidianke.qb1611.cn/wjb";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"被动加粉，3天加满5千好友！";
    [[UMSocialControllerService defaultControllerService] setShareText:@"免费下载.免费使用.被动加粉坐等被加为好友！突破单日加粉限制.快速建立5千好友朋友圈！" shareImage:[UIImage imageNamed:@"logo"] socialUIDelegate:nil];
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)friendBtnClick{
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://weidianke.qb1611.cn/wjb";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"被动加粉，3天加满5千好友！";
    [[UMSocialControllerService defaultControllerService] setShareText:@"免费下载.免费使用.被动加粉坐等被加为好友！突破单日加粉限制.快速建立5千好友朋友圈！" shareImage:[UIImage imageNamed:@"logo"] socialUIDelegate:nil];
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)cpyLinkBtnClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.sharelink;
    [ProgressHUD showSuccess:@"复制成功"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)qqBtnClick{
    [UMSocialData defaultData].extConfig.qqData.url = @"http://weidianke.qb1611.cn/wjb";
    [UMSocialData defaultData].extConfig.qqData.title = @"被动加粉，3天加满5千好友！";
    [[UMSocialControllerService defaultControllerService] setShareText:@"免费下载.免费使用.被动加粉坐等被加为好友！突破单日加粉限制.快速建立5千好友朋友圈！" shareImage:[UIImage imageNamed:@"logo"] socialUIDelegate:nil];
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)qqZoneBtnClick{
    [UMSocialData defaultData].extConfig.qqData.url = @"http://weidianke.qb1611.cn/wjb";
    [UMSocialData defaultData].extConfig.qqData.title = @"被动加粉，3天加满5千好友！";
    [[UMSocialControllerService defaultControllerService] setShareText:@"免费下载.免费使用.被动加粉坐等被加为好友！突破单日加粉限制.快速建立5千好友朋友圈！" shareImage:[UIImage imageNamed:@"logo"] socialUIDelegate:nil];
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)cpyPicBtnClick{
    self.clickCpyImg();
    [self dismissViewControllerAnimated:NO completion:nil];
}



@end
