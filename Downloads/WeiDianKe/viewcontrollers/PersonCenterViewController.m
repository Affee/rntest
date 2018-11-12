//
//  PersonCenterViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#define LINECORLOR       [UIColor colorWithRed:233 / 255.8f green:233 / 255.8f blue:233 / 255.8f alpha:233 / 255.8f]
#import "LetAdvertisementViewController.h"
#import "PersonCenterViewController.h"
#import "WebViewController.h"
#import "SendQrCodeViewController.h"
#import "ShareViewController.h"
#import "CpyImgViewController.h"
#import "VipListViewController.h"
#import "MainViewController.h"
#import "JFShopViewController.h"
#import "AliCashViewController.h"
#import "VipServiceViewController.h"
#import "UserMsgSetViewController.h"
#import <MJRefresh.h>
#import "IncomeListViewController.h"
#import "InviteListViewController.h"
#import "GuanLiGGTableViewController.h"
@interface PersonCenterViewController ()
@property (strong, nonatomic) IBOutlet UIView *MyGuanggao;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@property(strong,nonatomic) NSDictionary* userDatas;
@property (strong , nonatomic) NSArray *noticeDataArray;
@end

@implementation PersonCenterViewController

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;

}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.title = @"会员中心";
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    self.scrollView.contentInset = UIEdgeInsetsMake(0,0,self.explainView.bounds.size.height - 45,0);

    self.midDesView.layer.borderWidth =2;
    self.midDesView.layer.borderColor = [UIColor redColor].CGColor;
    self.midDesView.layer.cornerRadius = 6;
    
    self.MyGuanggao.layer.borderWidth = 0.52f;
    self.MyGuanggao.layer.borderColor = LINECORLOR.CGColor;
    self.makeMoneyView.layer.borderWidth = 0.52f;
    self.makeMoneyView.layer.borderColor = LINECORLOR.CGColor;
    self.jfView.layer.borderWidth = 0.52f;
    self.jfView.layer.borderColor = LINECORLOR.CGColor;
    self.moneyView.layer.borderWidth = 0.52f;
    self.moneyView.layer.borderColor = LINECORLOR.CGColor;
    self.personCardView.layer.borderWidth = 0.52f;
    self.personCardView.layer.borderColor = LINECORLOR.CGColor;
    self.wechatView.layer.borderWidth = 0.52f;
    self.wechatView.layer.borderColor = LINECORLOR.CGColor;
    self.gzhView.layer.borderWidth = 0.52f;
    self.gzhView.layer.borderColor = LINECORLOR.CGColor;
    self.bookView.layer.borderWidth = 0.52f;
    self.bookView.layer.borderColor = LINECORLOR.CGColor;
    [self setupGest];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getUserInfo",@"token":[TTUserInfoManager token]} Success:^(NSDictionary *responseJsonObject) {
            self.userDatas = responseJsonObject[@"result"];
            if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                [self setupBaseMsg];
                [self.scrollView.header endRefreshing];
            }else{
                [ProgressHUD showError:responseJsonObject[@"msg"]];
                [self.scrollView.header endRefreshing];
                
            }
        } Failure:^(NSError *error) {
            [self.scrollView.header endRefreshing];
        }];

    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.scrollView.header = header;
//    [self.scrollView.header beginRefreshing];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getUserInfo",@"token":[TTUserInfoManager token]} Success:^(NSDictionary *responseJsonObject) {
                      self.userDatas = responseJsonObject[@"result"];
                      if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                          [self setupBaseMsg];
                      }else{
                          [ProgressHUD showError:responseJsonObject[@"msg"]];
                      }
                  } Failure:^(NSError *error) {
                      
                  }];
    
}

-(void)setupGest{
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MyGuangGWei)];
    [self.MyGuanggao addGestureRecognizer:myTap];
    
    UITapGestureRecognizer *noticeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeTapGest)];
    [self.noticeView addGestureRecognizer:noticeTap];
    
    UITapGestureRecognizer* jfTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jfTapGest)];
    [self.jfView addGestureRecognizer:jfTap];
    
    UITapGestureRecognizer* yeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yeTapGest)];
    [self.moneyView addGestureRecognizer:yeTap];
    
    UITapGestureRecognizer* vipTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipTapGest)];
    [self.vipView addGestureRecognizer:vipTap];
    
    UITapGestureRecognizer* pVipTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pVipTapGest)];
    [self.puperVipView addGestureRecognizer:pVipTap];
    
    UITapGestureRecognizer* personTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personCarTapGest)];
    [self.personCardView addGestureRecognizer:personTap];
    
    UITapGestureRecognizer* wechatTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wechatTapGest)];
    [self.wechatView addGestureRecognizer:wechatTap];
    
    UITapGestureRecognizer* gzhTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gzhTapGest)];
    [self.gzhView addGestureRecognizer:gzhTap];
    
    UITapGestureRecognizer* bookTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bookTapGest)];
    [self.bookView addGestureRecognizer:bookTap];
    
    UITapGestureRecognizer* moneyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeMoneyTapGest)];
    [self.makeMoneyView addGestureRecognizer:moneyTap];
    
    UITapGestureRecognizer* headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapGest)];
    [self.userHeadIV addGestureRecognizer:headerTap];
    
    if ([TTUserInfoManager logined] ==YES&&[TTUserInfoManager userInfo]) {
        [self setUserInfo:[TTUserInfoManager userInfo]];
    }
    else
    {
        [self setUserInfo:@{@"available_fans_count":@"0",@"incomes":@"0",@"invites":@"0",@"remains":@"0"}];
    }
}
-(void)MyGuangGWei{
    LetAdvertisementViewController *vc = [[LetAdvertisementViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noticeTapGest{
    NoticeViewController *vc = [[NoticeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.dataArray = self.noticeDataArray;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)headerTapGest{
    UserMsgSetViewController* vc = [[UserMsgSetViewController alloc]init];
    vc.data = self.userDatas;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)jfTapGest{
    if (self.navigationController.viewControllers.count == 1) {
        [self.tabBarController setSelectedIndex:2];
    }else{
        JFShopViewController* vc = [[JFShopViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)yeTapGest{
    AliCashViewController* vc = [[AliCashViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)vipTapGest{
    VipListViewController* vc = [[VipListViewController alloc]init];
    MainViewController* mainVC = [(UINavigationController*)kAPPDelegate.mainTab.viewControllers[0] viewControllers][0];
    vc.datas = mainVC.appConfigInfo[@"vip_types_new"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pVipTapGest{
    if (self.navigationController.viewControllers.count == 1) {
        [self.tabBarController setSelectedIndex:1];
    }else{
        VipServiceViewController* vc = [[VipServiceViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)personCarTapGest{
    SendQrCodeViewController* vc = [[SendQrCodeViewController alloc]init];
    vc.isFromPersonCenter = YES;
    vc.beginIndex = 0;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)touchBack:(UIButton *)sender {
    if ([self.backS isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)wechatTapGest{
    SendQrCodeViewController* vc = [[SendQrCodeViewController alloc]init];
    vc.isFromPersonCenter = YES;
    vc.beginIndex = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gzhTapGest{
    SendQrCodeViewController* vc = [[SendQrCodeViewController alloc]init];
    vc.isFromPersonCenter = YES;
    vc.beginIndex = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)bookTapGest{
    WebViewController* vc = [[WebViewController alloc]init];
    vc.url = [NSURL URLWithString:@"http://weidianke.qb1611.cn/app-nav/2"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)makeMoneyTapGest{
    ShareViewController* vc = [[ShareViewController alloc]init];
    [vc setClickCpyImg:^{
        CpyImgViewController* cvc = [[CpyImgViewController alloc]init];
        cvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cvc animated:YES];
    }];
    vc.sharelink = self.userDatas[@"share_link"];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    if (self.navigationController.viewControllers.count == 1) {
        [kAPPDelegate.secondTab presentViewController:vc animated:NO completion:nil];
    }else{
        [kAPPDelegate.mainTab presentViewController:vc animated:NO completion:nil];
    }
}

-(void)setupBaseMsg{
    [self setNotice];
    
    [self.userHeadIV sd_setImageWithURL:[NSURL URLWithString:self.userDatas[@"userImg"]]];
    [self.noticeImg sd_setImageWithURL:[NSURL URLWithString:self.userDatas[@"userImg"]]];
    [self.usernameL setText:self.userDatas[@"mobile"]];
    [self.myJFL setText:[NSString stringWithFormat:@"剩余：%d",[self.userDatas[@"score"] intValue]]];
    [self.myMoneyL setText:[NSString stringWithFormat:@"余额：%.2f",[self.userDatas[@"remains"] floatValue]]];
    if ([self.userDatas[@"nickname"] isEqualToString:@""]) {
        self.userNameLab.text = @"(您未设置账号昵称)";
    }else{
        [self.userNameLab setText:self.userDatas[@"nickname"]];
    }
    int vipType = [self.userDatas[@"vip_types"] intValue];
//    int pVipType = [self.userDatas[@"qrcode_type"] intValue];
    
    if (vipType == 0){
        [self.vipTipL setText:@"未开通会员"];
    }else if (vipType == 2){
        int day = ([self.userDatas[@"expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24);
        [self.vipTipL setText:[NSString stringWithFormat:@"钻石会员:剩余%d天",day]];
    }else if (vipType == 1){
        int day = ([self.userDatas[@"expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24);
        [self.vipTipL setText:[NSString stringWithFormat:@"黄金会员:剩余%d天",day]];
    }

    if (ceil(([self.userDatas[@"gr_purple_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0 || ceil(([self.userDatas[@"wx_purple_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0  || ceil(([self.userDatas[@"gzh_purple_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0 ) {
        int day;
        if (ceil(([self.userDatas[@"gr_purple_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0) {
            day = ceil(([self.userDatas[@"gr_purple_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24));
            [self.pVipTipL setText:[NSString stringWithFormat:@"个人紫钻:剩余%d天",day]];
        }else if (ceil(([self.userDatas[@"wx_purple_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0){
            day = ceil(([self.userDatas[@"wx_purple_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24));
            [self.pVipTipL setText:[NSString stringWithFormat:@"微信紫钻:剩余%d天",day]];
        }else{
            day = ceil(([self.userDatas[@"gzh_purple_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24));
            [self.pVipTipL setText:[NSString stringWithFormat:@"公众号紫钻:剩余%d天",day]];
        }
    }else if (ceil(([self.userDatas[@"gr_vip_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0 || ceil(([self.userDatas[@"wx_vip_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0 || ceil(([self.userDatas[@"gzh_vip_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0){
        int day;
        if (ceil(([self.userDatas[@"gr_vip_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0) {
            day = ceil(([self.userDatas[@"gr_vip_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24));
            [self.pVipTipL setText:[NSString stringWithFormat:@"个人Vip:剩余%d天",day]];
        }else if (ceil(([self.userDatas[@"wx_vip_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0){
            day = ceil(([self.userDatas[@"wx_vip_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24));
            [self.pVipTipL setText:[NSString stringWithFormat:@"微信Vip:剩余%d天",day]];
        }else{
            day = ceil(([self.userDatas[@"gzh_vip_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24));
            [self.pVipTipL setText:[NSString stringWithFormat:@"公众号Vip:剩余%d天",day]];
        }
    }else if (ceil(([self.userDatas[@"gr_red_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0 || ceil(([self.userDatas[@"wx_red_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0 || ceil(([self.userDatas[@"gzh_red_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0){
        int day;
        if (ceil(([self.userDatas[@"gr_red_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0) {
            day = ceil(([self.userDatas[@"gr_red_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24));
            [self.pVipTipL setText:[NSString stringWithFormat:@"个人红钻:剩余%d天",day]];
        }else if (ceil(([self.userDatas[@"wx_red_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24)) > 0){
            day = ceil(([self.userDatas[@"wx_red_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24));
            [self.pVipTipL setText:[NSString stringWithFormat:@"微信红钻:剩余%d天",day]];
        }else{
            day = ceil(([self.userDatas[@"gzh_red_expiration"] intValue] - [[NSDate date]timeIntervalSince1970]) / (60*60*24));
            [self.pVipTipL setText:[NSString stringWithFormat:@"公众号红钻:剩余%d天",day]];
        }
    }else{
        [self.pVipTipL setText:@"未开通会员"];
    }
}

- (void)setNotice{
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Notice/queryAllNotices" Parameters:@{} Success:^(NSDictionary *responseJsonObject) {
        if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseJsonObject[@"result"][@"items"][0];
            self.noticeDataArray = responseJsonObject[@"result"][@"items"];
            [self noticeText:dic];
        }

    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)noticeText:(NSDictionary *) dic{
    NSString *noticeText = dic[@"title"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"会员公告 ：%@",noticeText]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];       //NSMakeRange（0，3） 0代表从哪个开始   3表示几个字符
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:182/255.8f green:181/255.8f blue:181/255.8f alpha:1] range:NSMakeRange(5, str.length - 5)];
    self.noticeLab.attributedText = str;
    
    [self.noticeImg sd_setImageWithURL:[NSURL URLWithString:dic[@"picture"]]];
}

- (IBAction)lookIncome:(UIButton *)sender {
    
    IncomeListViewController *vc = [[IncomeListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)lookInvite:(id)sender {
    
    InviteListViewController *vc = [[InviteListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)cashAliPay:(UIButton *)sender {
    AliCashViewController *vc = [[AliCashViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

//用户信息赋值
- (void)setUserInfo:(NSDictionary *)info
{
    //客源名额
    NSString *available_fans_count = [info string_ForKey:@"available_fans_count"];
    NSString *leftFansStr = [NSString stringWithFormat:@"您还有%@个客源名额",available_fans_count];
    NSMutableAttributedString *leftFansAttriStr = [[NSMutableAttributedString alloc]initWithString:leftFansStr];
    [leftFansAttriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[leftFansStr rangeOfString:available_fans_count]];
//    self.fansLeftCountLabel.attributedText = leftFansAttriStr;
    //收入
    self.incomeLabel.text = [info string_ForKey:@"incomes"];
    //邀请好友数
    self.inviteCountLabel.text = [info string_ForKey:@"invites"];
    //余额
    self.remainLabel.text = [info string_ForKey:@"remains"];
    
    
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

@end
