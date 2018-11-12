//
//  AppDelegate.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/16.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LearnViewController.h"
#import "HuFenViewController.h"

#import "TTUmengManager.h"
#import "DDAliPayManager.h"
#import "DDWeChatPayManager.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "TTUserInfoManager.h"
//#import "ChoujiangViewController.h"
#import "QrCodeViewController.h"
#import "UIImage+MyCustomImage.h"
#import "VipServiceViewController.h"
#import "JFShopViewController.h"
#import "PersonCenterViewController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch. sssssdasdasdas
    [self loadPayMsg];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    

    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"1f470eab2684f027a8de3496"
                          channel:@""
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
    
    self.isReadyForSale =NO;//默认审核中
    //友盟分享
    [TTUmengManager setUp];
    
    [XGPush startApp:2200242583 appKey:@"I93K54F1FSGH"];
    [XGPush handleLaunching:launchOptions];
    [self registerPushForIOS8];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.mainTab = [[UITabBarController alloc] init];
    self.mainTab.delegate = self;
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    mainVC.tabBarItem.title = @"会员中心";
    mainVC.tabBarItem.image = [UIImage imageNamed:@"tabbarItemIndex"];
    [mainVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} forState:UIControlStateNormal];
    
    UIViewController* qrVc = [[UIViewController alloc]init];
    qrVc.tabBarItem.tag = -111;
    qrVc.tabBarItem.title = @"二维码平台";
    qrVc.tabBarItem.image = [UIImage imageNamed:@"二维码"];
    [qrVc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} forState:UIControlStateNormal];
    
    HuFenViewController *hufenVC = [[HuFenViewController alloc] init];
    hufenVC.tabBarItem.title = @"互粉";
    hufenVC.tabBarItem.image = [UIImage imageNamed:@"tabbarItemLearn"];
    [hufenVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} forState:UIControlStateNormal];

    LearnViewController *learnVC = [[LearnViewController alloc] init];
    learnVC.tabBarItem.title = @"新手指南";
    learnVC.tabBarItem.image = [UIImage imageNamed:@"tabbarItemLearn"];
    [learnVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} forState:UIControlStateNormal];
    

//    ChoujiangViewController *guaVC = [[ChoujiangViewController alloc] init];
//    guaVC.tabBarItem.title = @"抽奖";
//    guaVC.tabBarItem.image = [UIImage imageNamed:@"tabbarItemMid"];
    
    //    tabbarVC.tabBar.barStyle = UIBarStyleBlack;
    
    self.mainTab.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:mainVC],qrVc,/*[[UINavigationController alloc] initWithRootViewController:hufenVC],*/[[UINavigationController alloc] initWithRootViewController:learnVC]];
    self.mainTab.tabBar.translucent = NO;
    self.mainTab.tabBar.tintColor = [UIColor colorWithRed:226/255.0f green:51/255.0f blue:60/255.0f alpha:1];
    self.window.rootViewController = self.mainTab;
    [self.window makeKeyAndVisible];
    
    //杀死进程情况下的点击推送
    if(launchOptions) {
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(remoteNotification) {
            [self tappedNotification:remoteNotification];
        }
    }
    return YES;
}



-(void)loadPayMsg{
    [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/common/getpayconfig"} Success:^(NSDictionary *responseJsonObject) {
        if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary* result = responseJsonObject[@"result"];
            [[DDAliPayManager defaultManager] setPartnerId:result[@"alipay_merId"]];
            [[DDAliPayManager defaultManager] setSellerAcount:result[@"alipay_seller"]];
            [[DDAliPayManager defaultManager] setPrivateKey:result[@"alipay_rsa_private"]];
            
            [[DDWeChatPayManager defaultManager] setAppId:result[@"wechat_app_id"]];
            [[DDWeChatPayManager defaultManager] setKkey:result[@"wechat_api_key"]];
            [[DDWeChatPayManager defaultManager] setMchId:result[@"wechat_merId"]];
        }else{
            [self loadPayMsg];
        }
    } Failure:^(NSError *error) {
        [self loadPayMsg];
    }];
}

-(UINavigationController*)getBaseNavi:(UIViewController*)vc{
    UINavigationController* baseNavi = [[UINavigationController alloc]initWithRootViewController:vc];
    baseNavi.navigationBar.translucent = NO;
    baseNavi.navigationBar.backgroundColor = [UIColor colorWithRed:226/255.0f green:51/255.0f blue:60/255.0f alpha:1];
    [baseNavi.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:226/255.2f green:47/255.2f blue:39/255.2f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    baseNavi.navigationBar.tintColor = [UIColor whiteColor];
    baseNavi.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 15, 5)];
    [backBtn addTarget:self action:@selector(dismissSecondTab) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back_navi"] forState:UIControlStateNormal];
//    backBtn.transform = CGAffineTransformScale(backBtn.transform, 1, 0.5f);
    UIBarButtonItem* negSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negSpace.width = -8;
    
    vc.navigationItem.leftBarButtonItems = @[negSpace,[[UIBarButtonItem alloc]initWithCustomView:backBtn]];
    
    NSDictionary *attributes_nulltitle = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                           
                                           NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [vc.navigationItem.leftBarButtonItem setTitleTextAttributes:attributes_nulltitle forState:UIControlStateNormal];
    return baseNavi;
}


-(void)dismissSecondTab{
    [self.secondTab dismissViewControllerAnimated:YES completion:nil];
    self.secondTab = nil;
}

#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController.tabBarItem.tag == -111) {
        
        if ([TTUserInfoManager logined] ==NO) {
            [(MainViewController*)[(UINavigationController*)self.mainTab.viewControllers[0] viewControllers][0] showLoginView];
            return NO;
        }
        
        QrCodeViewController* gjbf = [[QrCodeViewController alloc]init];
        gjbf.tabBarItem.title = @"挂机爆粉";
        gjbf.tabBarItem.image = [UIImage imageNamed:@"money_tab"];
        
        VipServiceViewController* vsvc = [[VipServiceViewController alloc]init];
        vsvc.tabBarItem.title = @"会员服务";
        vsvc.tabBarItem.image = [UIImage imageNamed:@"Crown_tab"];
        
        JFShopViewController* jfvc = [[JFShopViewController alloc]init];
        jfvc.tabBarItem.title = @"积分商城";
        jfvc.tabBarItem.image = [UIImage imageNamed:@"Gift_tab"];
        
        PersonCenterViewController* pcvc = [[PersonCenterViewController alloc]init];
        pcvc.tabBarItem.title = @"会员中心";
        pcvc.tabBarItem.image = [UIImage imageNamed:@"person_tab"];
        
        
        self.secondTab = [[UITabBarController alloc]init];
        self.secondTab.viewControllers = @[[self getBaseNavi:gjbf],[self getBaseNavi:vsvc],[self getBaseNavi:jfvc],[self getBaseNavi:pcvc]];
        self.secondTab.tabBar.translucent = NO;
        self.secondTab.tabBar.tintColor = [UIColor colorWithRed:226/255.0f green:51/255.0f blue:60/255.0f alpha:1];
    
        
        [tabBarController presentViewController:self.secondTab animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}

#pragma mark -推送
- (void)registerPushForIOS8{
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}



-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    NSLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
}



//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"[XGPush Demo]%@",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //前台运行时，收到推送的通知会弹出alertview提醒
    if(application.applicationState ==UIApplicationStateActive)
    {
        NSString *alert = [[userInfo dictionary_ForKey:@"aps"] string_ForKey:@"alert"];
        NSString *mes_link = [userInfo string_ForKey:@"mes_link"];
        if (mes_link.length>1) {
            //弹窗，选择是否跳转
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"新消息" message:alert delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往查看", nil];
            ale.accessibilityValue = mes_link;
            [ale show];
        }
        else
        {
            //只弹窗展示，无选择跳转
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"新消息" message:alert delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [ale show];
            
        }
        
    }
    //    //点击推送通知进入界面的时
    else if (application.applicationState ==UIApplicationStateInactive)
    {
        [self tappedNotification:userInfo];
    }
    
    //    NSLog(@"UIApplicationState =%ld,UIApplicationStateInactive =%ld",(long)UIApplicationStateInactive,(long)UIApplicationStateInactive);
    //    NSLog(@"UIApplication sharedApplication] applicationState =%ld,application.applicationState =%ld",(long)[[UIApplication sharedApplication] applicationState],(long)application.applicationState);
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    
}



//点击推送进入APP后，根据当前用户登录情况和推送消息，判断是否进入推送详情页面
- (void)tappedNotification :(NSDictionary *)userInfo
{
    NSString *mes_link = [userInfo string_ForKey:@"mes_link"];
    if ([TTUserInfoManager logined] ==YES/*已经登录用户*/) {
        if (mes_link.length>1) {
            [self pushNotiWebVC:mes_link];
        }
        
    }
    else//不存在可跳转链接的话，则暂不操作
    {}
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.accessibilityValue.length>3) {
        if (buttonIndex ==1) {
            [self pushNotiWebVC:alertView.accessibilityValue];
        }
    }
}
//跳转到推送详情中包含的URL的web页面
- (void)pushNotiWebVC:(NSString *)url
{
    //获取到当前视图控制器
    UIViewController *currentVC = nil;
    
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
        currentVC = nextResponder;
    else
        currentVC = window.rootViewController;
    if (currentVC !=nil) {
        if (kAPPDelegate.isShowNotiWebVC ==NO) {
            kAPPDelegate.notiWebVC = [[WebViewController alloc] init];
            kAPPDelegate.notiWebVC.isPresent =YES;
            kAPPDelegate.notiWebVC.url = [NSURL URLWithString:url];
            [currentVC presentViewController:[[UINavigationController alloc] initWithRootViewController:kAPPDelegate.notiWebVC] animated:YES completion:nil];
            kAPPDelegate.isShowNotiWebVC = YES;
        }
        //正在展示推送链接web页面
        else
        {
            kAPPDelegate.notiWebVC.url = [NSURL URLWithString:url];
            [kAPPDelegate.notiWebVC reloadUrl];
        }
        
    }
    
    
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSLog(@"openUrl:%@",url);
    if ([url.host isEqualToString:@"safepay"]) {
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:[DDWeChatPayManager defaultManager]];
    }
}


- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    NSLog(@"openUrl:%@",url);
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"%s --result = %@",__func__,resultDic);
                NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                if ([resultStatus isEqualToString:@"9000"]) {
                    if ([DDAliPayManager defaultManager].block) {
                        [DDAliPayManager defaultManager].block(YES);
                    }
                }
                else
                {
                    if ([DDAliPayManager defaultManager].block) {
                        [DDAliPayManager defaultManager].block(NO);
                    }
                }
            }];
        }
        else
        {
            return [WXApi handleOpenURL:url delegate:[DDWeChatPayManager defaultManager]];
            
        }
    }
    return result;
    
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"%s --result = %@",__func__,resultDic);
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                if ([DDAliPayManager defaultManager].block) {
                    [DDAliPayManager defaultManager].block(YES);
                }
            }
            else
            {
                if ([DDAliPayManager defaultManager].block) {
                    [DDAliPayManager defaultManager].block(NO);
                }
            }

        }];
    }else{
        return [WXApi handleOpenURL:url delegate:[DDWeChatPayManager defaultManager]];
    }
    return YES;
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

@end
