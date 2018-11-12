//
//  AppDelegate.h
//  WeiDianKe
//
//  Created by flappybird on 16/11/9.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL isReadyForSale;//0：审核中，1：审核通过
@property (assign, nonatomic) BOOL isShowNotiWebVC;//
@property (strong, nonatomic) WebViewController *notiWebVC;//
@property (strong,nonatomic) UITabBarController* secondTab;
@property (strong,nonatomic) UITabBarController* mainTab;
@end

