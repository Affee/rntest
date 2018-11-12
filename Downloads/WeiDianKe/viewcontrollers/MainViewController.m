//
//  MainViewController.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/21.
//  Copyright © 2016年 zichenfang. All rights reserved.
//
#import "AdvertisementExplainViewController.h"
#import "GuangGaoXiangQingViewController.h"
#import "ChakanGuanggaoViewController.h"
#import "LetAdvertisementViewController.h"
#import "MainViewController.h"
#import "XVipMenuView.h"
#import "FitPhoneViewController.h"
#import "TTUmengManager.h"
#import "IncomeListViewController.h"
#import "InviteListViewController.h"
#import "AliCashViewController.h"
#import "LoginView.h"
#import "WebViewController.h"
#import "SignView.h"
#import "BookManager.h"
#import "DDAliPayManager.h"
#import "DDWeChatPayManager.h"
#import "SelectPayView.h"
#import "MJRefresh.h"
#import "MainHeaderCollectionReusableView.h"
#import "MainFooterCollectionReusableView.h"
#import "ExtectionFunctionCollectionViewCell.h"
#import "VipListViewController.h"
#import "MJRefresh.h"
#import "ChoujiangViewController.h"
#import "PersonCenterViewController.h"
#import "ShareViewController.h"
#import "CpyImgViewController.h"


typedef NS_ENUM(NSInteger, XAlertViewType) {
    XAlertViewTypeDefault = 100,
    XAlertViewTypeJiafen = 101,
    XAlertViewTypeBeidongJiafen = 102,
    XAlertViewTypeClearnBooks = 103,
    XAlertViewTypeLoginOut = 104,
    XAlertViewTypeSign = 105
};

@interface MainViewController ()<UIAlertViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MainFooterCollectionReusableViewDelegate>
//新版
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *pentaFunctions;//5个功能标题
//登录
@property (strong, nonatomic) LoginView *loginView;
@property (assign, nonatomic) int leftCount;//验证码倒计时秒数
//签到
@property (strong, nonatomic) SignView *singView;
@property (assign, nonatomic) BOOL isFansing;//加粉状态（YES：加粉中，NO：停止加粉）
@property (assign, nonatomic) BOOL hasSigned;//是否已签到（YES：已签到，NO：未签到）
@property (strong, nonatomic) NSMutableArray *books;//加粉存放的通讯录
@property (strong,nonatomic) NSString *selectView;

@property (strong, nonatomic) NSMutableArray *numberArray;
@property(strong,nonatomic) NSString *youHaoHuo;
@property (nonatomic, assign) NSInteger num;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.youHaoHuo = @"2";
//    self.selectView = @"0";
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"首页";
    _numberArray = [NSMutableArray array];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:227/255.2f green:63/255.2f blue:60/255.2f alpha:1];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAppConfigInfo_userInfo)];//刷新APP配置信息和用户信息（若已经登录）

    self.isFansing = YES;//默认加粉中
    self.pentaFunctions =[NSMutableArray arrayWithArray:@[@"一键加粉",@"一键被加",@"高级筛选",@"个人中心",@"清理通讯录",@"签到奖励"]];
    UINib *nibHeader = [UINib nibWithNibName:@"MainHeaderCollectionReusableView" bundle:nil];
    [self.collectionView registerNib:nibHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"home"];
    
    UINib *nibFooter = [UINib nibWithNibName:@"MainFooterCollectionReusableView" bundle:nil];
    [self.collectionView registerNib:nibFooter forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"home"];
    UINib *nibCell = [UINib nibWithNibName:@"ExtectionFunctionCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nibCell forCellWithReuseIdentifier:@"home"];

    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshAppConfigInfo_userInfo];
    }];
    [self.collectionView.header beginRefreshing];
    //用在筛选加分页面，刷新用户信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAddPhoneToastView) name:@"AddPhoneSuccessed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:userInfoDidUpdated object:nil];
    
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryAllAdver" Parameters:@{} Success:^(NSDictionary *responseJsonObject) {
        NSDictionary *dic = responseJsonObject[@"result"];
        _numberArray = dic[@"items"];

        [self.collectionView reloadData];
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshUI
{
    self.isFansing =[[[TTUserInfoManager userInfo] string_ForKey:@"is_fansing"] isEqualToString:@"1"];
    self.hasSigned =[[[TTUserInfoManager userInfo] string_ForKey:@"is_signed"] isEqualToString:@"1"];
    [self.collectionView reloadData];
}

#pragma mark -collectionview
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (kAPPDelegate.isReadyForSale ==NO) {
        return 4;
    }
    if (self.appConfigInfo) {
        return self.pentaFunctions.count+[[self.appConfigInfo array_ForKey:@"extension_functions"] count];
    }
    return self.pentaFunctions.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identi = @"home";
    ExtectionFunctionCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identi forIndexPath:indexPath];
    if (indexPath.row<self.pentaFunctions.count)//固定功能
    {
        cell.nameLabel.text = self.pentaFunctions[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"static_function_cell_%d",(int)indexPath.row]];
    }else{
        NSDictionary *afunction = [[self.appConfigInfo array_ForKey:@"extension_functions"] objectAtIndex:indexPath.row-self.pentaFunctions.count];
        cell.nameLabel.text = [afunction string_ForKey:@"function_name"];
        NSString *imgUrl = [afunction string_ForKey:@"function_img"];
//        NSArray *array = [imgUrl componentsSeparatedByString:@"80"];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:kPlaceHolderImg];
    }
    if (indexPath.row ==5)//签到
    {
        //已登录
        if ([TTUserInfoManager logined] ==YES) {
            //已签到
            if ([[[TTUserInfoManager userInfo] string_ForKey:@"is_signed"] isEqualToString:@"1"]) {
                cell.nameLabel.text = @"已签到";
            }
            else
            {
                cell.nameLabel.text = @"签到奖励";
            }
        }
        else//未登录
        {
            cell.nameLabel.text = @"签到奖励";
        }
    }
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MainHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"home" forIndexPath:indexPath];
        headerView.target =self;
        //已经登录
        if ([TTUserInfoManager logined] ==YES) {
            headerView.phoneLabel.hidden = NO;
            headerView.statesBtn.hidden = NO;
            NSString *phone =[TTUserInfoManager phone];
            if (phone.length==11) {
                headerView.phoneLabel.text = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            if (self.isFansing ==YES) {
                [headerView.statesBtn setTitle:@"加粉中" forState:UIControlStateNormal];
            }
            else
            {
                [headerView.statesBtn setTitle:@"已暂停" forState:UIControlStateNormal];
            }
            [headerView.login_out_btn setTitle:@"退出" forState:UIControlStateNormal];

        }
        //未登录
        else
        {
            headerView.phoneLabel.hidden = YES;
            headerView.statesBtn.hidden = YES;
            [headerView.login_out_btn setTitle:@"请登录" forState:UIControlStateNormal];
        }

        if (self.appConfigInfo) {
            NSString *baner_image = [self.appConfigInfo string_ForKey:@"baner_image"];
            [headerView setBannerImgViewWithUrl:baner_image];
            //[headerView.bannerImgView sd_setImageWithURL:[NSURL URLWithString:baner_image] placeholderImage:kPlaceHolderImg];
        }
        
        return headerView;
    }
    else
    {
        MainFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"home" forIndexPath:indexPath];
        footerView.delegate = self;

        footerView.target = self;
        [footerView setIsReadyForSale:kAPPDelegate.isReadyForSale];
        if ([TTUserInfoManager logined] ==YES&&[TTUserInfoManager userInfo]) {
            [footerView setUserInfo:[TTUserInfoManager userInfo]];
        }
        else
        {
            [footerView setUserInfo:@{@"available_fans_count":@"0",@"incomes":@"0",@"invites":@"0",@"remains":@"0"}];
        }
        if (self.appConfigInfo) {
            [footerView setAppConfigInfo:self.appConfigInfo];
            [footerView setClickMarquee:^(NSString * url) {
                WebViewController* web = [[WebViewController alloc]init];
                web.url = [NSURL URLWithString:url];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }];
        }
        return footerView;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kDeviceWidth-30)*0.25, 90);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kDeviceWidth, 200) ;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
//    if ([self.selectView isEqualToString:@"0"]){
//        return CGSizeMake(kDeviceWidth, 300) ;
//    }else{
//        NSLog(@"%ld",(int)self.numberArray.count);
//        CGFloat num = 0.0;
//            if ([self.youHaoHuo isEqualToString:@"1"]) {
//                if (_numberArray.count % (3) == 1 || _numberArray.count % (3) == 2) {
//                    num =  _numberArray.count / 3 + 1;
//                }else{
//                    num =   _numberArray.count / 3;
//                }
//            }else if ([self.youHaoHuo isEqualToString:@"2"]){
//                if (_numberArray.count % (3) == 2) {
//                    num = _numberArray.count / 3 + 1;
//                }else{
//                    num = _numberArray.count / 3;
//                }
//            }else{
//                num = _numberArray.count / 3;
//            }
//        return CGSizeMake(kDeviceWidth,_numberArray.count==0?365:(num)*85+365);
         return CGSizeMake(kDeviceWidth,_numberArray.count==0?365:(_num)*85+365);
//    }
}
- (void)footerClick:(NSString *)type Int:(NSInteger)num
{
    _num = num;
    [self.collectionView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
    }
    else
    {
        switch (indexPath.row) {
            case 0://一键加粉
            {
                [self yijianJiafen];
            }
                break;
            case 1://被动加粉
            {
                [self beidongJiafen];
            }
                break;
            case 2://筛选
            {
                [self shaixuanJiafen];
            }
                break;
            case 3://个人中心
            {
                [self personCenter];
            }
                break;
            case 4://清理通讯录
            {
                [self clearnBooks];
            }
                break;
            case 5://签到
            {
                [self singIn];
            }
                break;
//            case 5://挂机爆粉
//            {
//                [self guajiBaofen];
//            }
//                break;
                
                
            default://web跳转
            {
                NSArray *extension_functions =[self.appConfigInfo array_ForKey:@"extension_functions"];
                WebViewController *vc = [[WebViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                NSString *url = [[extension_functions objectAtIndex:indexPath.row-self.pentaFunctions.count] string_ForKey:@"function_url"];
                vc.url = [NSURL URLWithString:url];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
    }
    
}
#pragma mark-刷新APP配置信息和用户信息（若已经登录）
- (void)refreshAppConfigInfo_userInfo
{
    [self lodAppConfigInfo];
    [self loadiTunesConfigData];

    if ([TTUserInfoManager logined] ==YES&&[TTUserInfoManager token]) {
        [self loadUserInfo];
    }
}
- (void)loadUserInfo
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/getUserInfo" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];

    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        [self.collectionView.header endRefreshing];
        if ([code isEqualToString:@"1"])//
        {
            [TTUserInfoManager setUserInfo:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:userInfoDidUpdated object:nil];
        }
    } Failure:^(NSError *error) {
        [self.collectionView.header endRefreshing];
    }];
}
#pragma mark-获取APP配置信息
- (void)lodAppConfigInfo
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/common/getappsetting" forKey:@"r"];
    
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        
        [self.collectionView.header endRefreshing];
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];

        if ([code isEqualToString:@"1"])//
        {
            self.appConfigInfo = result;
            [self.tabBarController.tabBar.items[0] setTitle:self.appConfigInfo[@"member_button"]];
            [self.tabBarController.tabBar.items[1] setTitle:self.appConfigInfo[@"qrcode_button"]];
            
            if ([self.appConfigInfo string_ForKey:@"add_fans_name"].length>1) {
                self.pentaFunctions[0]=[self.appConfigInfo string_ForKey:@"add_fans_name"];
            }
            if ([self.appConfigInfo string_ForKey:@"be_added_fans_name"].length>1) {
                self.pentaFunctions[1]=[self.appConfigInfo string_ForKey:@"be_added_fans_name"];
            }
            [self.collectionView reloadData];
        }
        else
        {
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
        [self.collectionView.header endRefreshing];
    }];

}
#pragma mark-获取版本审核控制信息
- (void)loadiTunesConfigData
{
    [TTRequestManager POST:@"https://itunes.apple.com/lookup?id=1174251517" Parameters:nil Success:^(NSDictionary *responseJsonObject) {
        //.
        NSString *resultCount = [responseJsonObject string_ForKey:@"resultCount"];
        NSArray *results = [responseJsonObject objectForKey:@"results"];
        //        NSLog(@"class =%@",[results class]);
        if ([resultCount isEqualToString:@"1"]) {
            float version_online = [[[results objectAtIndex:0] string_ForKey:@"version"] floatValue];
            NSLog(@"version_online =%f",version_online);
            float version_local =[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
            NSLog(@"version_local =%f",version_local);
            if (version_local<=version_online)//本地版本小于等于线上版本，则表示本地版本已审核通过
            {
                kAPPDelegate.isReadyForSale =YES;//
            }
            else//本地版本大于线上版本，则表示本地版本未审核通过
            {
                kAPPDelegate.isReadyForSale =NO;//
            }
        }
        else
        {
            kAPPDelegate.isReadyForSale =NO;//
        }
#warning isReadyForSale
        kAPPDelegate.isReadyForSale =YES;//
        [[NSNotificationCenter defaultCenter] postNotificationName:itunesInfoUpdated object:nil];
        [self.collectionView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}
#pragma mark-登录退出
- (void)loginOut
{
    //退出
    if ([TTUserInfoManager logined] ==YES) {
        UIAlertView *aleView = [[UIAlertView alloc] initWithTitle:@"是否退出？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        aleView.tag = XAlertViewTypeLoginOut;
        [aleView show];
    }
    //登录
    else
    {
        [self showLoginView];
    }
}
- (void)showLoginView
{
    if (self.loginView ==nil) {
        self.loginView = (LoginView *)[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil][0];
        self.loginView.frame = [[UIScreen mainScreen]bounds];
        [kAPPDelegate.window addSubview:self.loginView];
        [self.loginView.codeBtn addTarget:self action:@selector(obtainCode) forControlEvents:UIControlEventTouchUpInside];
        [self.loginView.okBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.loginView.closeBtn addTarget:self action:@selector(hideLoginView) forControlEvents:UIControlEventTouchUpInside];

        self.loginView.alpha =0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.loginView.alpha =1;
    }];
}
- (void)hideLoginView
{
    [self.loginView.phoneTF resignFirstResponder];
    [self.loginView.codeTF resignFirstResponder];
    [self.loginView.invitePhoneTF resignFirstResponder];

    [UIView animateWithDuration:0.3 animations:^{
        self.loginView.alpha =0;
    }];
}


- (void)textField_Changed
{
    if (self.loginView.alpha ==1) {
        self.loginView.okBtn.enabled = (self.loginView.phoneTF.text.length>0&&self.loginView.codeTF.text.length>0);
        if (self.leftCount<=0) {
            self.loginView.codeBtn.enabled = (self.loginView.phoneTF.text.absoluteString.length==11);
        }
    }
}


- (void)obtainCode{
    self.loginView.codeBtn.enabled = NO;
    self.leftCount = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(self.leftCount<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loginView.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.loginView.codeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
                self.loginView.codeBtn.enabled = (self.loginView.phoneTF.text.length>0);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.loginView.codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",self.leftCount] forState:UIControlStateDisabled];
            });
            self.leftCount--;
        }
    });
    dispatch_resume(_timer);
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/common/sendsms" forKey:@"r"];
    [para setObject:self.loginView.phoneTF.text.absoluteString forKey:@"phone"];
    [TTRequestManager POST:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"1"])//
        {
            [ProgressHUD showSuccess:@"验证码已发送到手机"];
            //            self.code = [result string_ForKey:@"code"];
        }else{
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
        //
    }];
    
}
- (void)login
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/common/userDo" forKey:@"r"];
    [para setObject:self.loginView.phoneTF.text.absoluteString forKey:@"phone"];
    [para setObject:self.loginView.codeTF.text.absoluteString forKey:@"code"];
    [para setObject:self.loginView.invitePhoneTF.text.absoluteString forKey:@"ref_phone"];

    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        [para setObject:registrationID forKey:@"registrationId"];
        
        [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
            //
            NSString *code = [responseJsonObject string_ForKey:@"code"];
            NSString *msg = [responseJsonObject string_ForKey:@"msg"];

            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            [self.loginView.phoneTF resignFirstResponder];
            [self.loginView.codeTF resignFirstResponder];
            [self.loginView.invitePhoneTF resignFirstResponder];
            
            if ([code isEqualToString:@"1"]){
                [TTUserInfoManager setUserInfo:result];
                [TTUserInfoManager setLogined:YES];
                [TTUserInfoManager setPhone:self.loginView.phoneTF.text.absoluteString];
                [TTUserInfoManager setToken:responseJsonObject[@"result"][@"token"]];
//                NSLog(@"%@,,,,%@ ,,,,,,%@",responseJsonObject[@"result"],result[@"result"][@"userid"],result[@"result"][@"user_id"]);
                [TTUserInfoManager setUserId:responseJsonObject[@"result"][@"user_id"]];
                
                [self.loginView.phoneTF resignFirstResponder];
                [self.loginView.codeTF resignFirstResponder];
                
                [self hideLoginView];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:userInfoDidUpdated object:nil];
                
            }
            else
            {
                [ProgressHUD showError:msg];
            }
        } Failure:^(NSError *error) {
            //
        }];

    }];
    
}
#pragma mark-切换加粉、暂停的状态
- (void)startOrPauseFansing
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/changeState" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:[NSString stringWithFormat:@"%d",!self.isFansing] forKey:@"is_fansing"];
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"1"])//
        {
            self.isFansing =!self.isFansing;
            if (self.isFansing ==YES) {
                [ProgressHUD showSuccess:@"激活成功"];
            }
            else
            {
                UIAlertView *ale =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您已经暂停了加粉，如需继续使用请点击激活！（暂停期间将不会有人加您）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"激活", nil];
                ale.tag = XAlertViewTypeJiafen;
                [ale show];
            }
        }
        else
        {
            [ProgressHUD showError:msg];
        }
        [self.collectionView reloadData];
    } Failure:^(NSError *error) {
        //
    }];
}
#pragma mark -轮播图抽奖
- (void)goBanner
{
    if (kAPPDelegate.isReadyForSale ==YES) {
        if ([TTUserInfoManager logined] ==NO) {
            [self showLoginView];
            return;
        }
        ChoujiangViewController *vc = [[ChoujiangViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -一键加粉
- (void)yijianJiafen{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    [ProgressHUD show:nil];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/jiafen" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        NSArray *items = [result array_ForKey:@"items"];
        if ([code isEqualToString:@"1"])//
        {
            if (self.books ==nil) {
                self.books = [NSMutableArray array];
            }
            [self.books removeAllObjects];
            for (int i=0; i<items.count; i++) {
                NSString *phone = [[items objectAtIndex:i] string_ForKey:@"phone"];
                [self.books addObject:phone];
            }
            if (self.books.count<=0) {
                [ProgressHUD showError:@"暂时没有加粉数据"];
            }
            else
            {
                [BookManager writeBooksInVC:self Books:self.books];
            }
            //刷新用户信息
            if ([[TTUserInfoManager userInfo] string_ForKey:@"user_lv"].intValue==0) {
                [self loadUserInfo];
            }
        }
        else
        {
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
        //
    }];
    
}
#pragma mark - 被动加粉

- (void)beidongJiafen{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    if (kAPPDelegate.isReadyForSale ==NO)//未审核通过
    {
        [self showBeidongToastView];
    }
    else
    {
        if (![[[TTUserInfoManager userInfo] string_ForKey:@"user_lv"] isEqualToString:@"2"]) {
            UIAlertView *ale =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"被动加粉功能仅限钻石会员使用，请先开通会员" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"开通", nil];
            ale.tag = XAlertViewTypeBeidongJiafen;
            [ale show];
        }
        else
        {
            [self showBeidongToastView];
        }
    }
    
}
#pragma mark- 新改的弹窗 添加50个手机号提示框（通过notifiction发送消息触发）

- (void)showAddPhoneToastView
{
    [[[UIAlertView alloc] initWithTitle:@"已添加50个好友！" message:@"打开社交软件.绑定这个手机号的社交软件账号.点击通讯录.即可看到新的好友！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];

}


#pragma mark- 新改的弹窗 被动加粉提示框
- (void)showBeidongToastView
{
    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"被动加粉中！24小时内会有新的好友添加您！打开社交软件.点击通讯录查询即可！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    
}
#pragma mark - 个人中心
-(void)personCenter{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    PersonCenterViewController* vc = [PersonCenterViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.backS = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 筛选加粉

- (void)shaixuanJiafen{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    if (kAPPDelegate.isReadyForSale ==NO) {
        FitPhoneViewController *vc = [[FitPhoneViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if ([[[TTUserInfoManager userInfo] string_ForKey:@"user_lv"] isEqualToString:@"0"]) {
            UIAlertView *ale =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"筛选加粉功能仅限黄金会员或钻石会员使用，请先开通会员" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"开通", nil];
            ale.tag = XAlertViewTypeBeidongJiafen;
            [ale show];
            
        }
        else
        {
            FitPhoneViewController *vc = [[FitPhoneViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
#pragma mark - 清理通讯录

- (void)clearnBooks{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    UIAlertView *ale =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认清理？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"清理",nil];
    ale.tag = XAlertViewTypeClearnBooks;
    [ale show];
}
- (void)deleteBooks
{
    [BookManager clearnBooks];
}
#pragma mark -挂机爆粉
- (void)guajiBaofen
{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    WebViewController *vc =[[WebViewController alloc] init];
    vc.url = [NSURL URLWithString:[[TTUserInfoManager userInfo] string_ForKey:@"weichat_contacts_url"]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -签到
- (void)singIn
{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    if ([[[TTUserInfoManager userInfo] string_ForKey:@"is_signed"] isEqualToString:@"1"]) {
        return;
    }
    if (self.appConfigInfo !=nil) {
        if ([[self.appConfigInfo string_ForKey:@"sign_auth_code"] isEqualToString:[TTUserInfoManager signAuthCode]]) {
            //通过了验证
            [self requestSign];
        }
        else//未通过验证
        {
            NSString *sign_auth_des = [self.appConfigInfo string_ForKey:@"sign_auth_des"];
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"签到验证" message:sign_auth_des delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            ale.alertViewStyle = UIAlertViewStylePlainTextInput;
            ale.tag = XAlertViewTypeSign;
            [ale show];
        }
    }

}
- (void)requestSign
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/sign" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"1"])//
        {
            [self showSignViewDays:[result string_ForKey:@"has_signed_days"] Money:[result string_ForKey:@"bonus_money"]];
            //刷新用户信息
            [self refreshAppConfigInfo_userInfo];
        }
        else
        {
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
        //
    }];

}
- (void)showSignViewDays :(NSString *)days Money:(NSString *)money
{
    if (self.singView ==nil) {
        self.singView = (SignView *)[[NSBundle mainBundle] loadNibNamed:@"SignView" owner:self options:nil][0];
        self.singView.frame = [[UIScreen mainScreen]bounds];
        [kAPPDelegate.window addSubview:self.singView];
        [self.singView.closeBtn addTarget:self action:@selector(closeSignView) forControlEvents:UIControlEventTouchUpInside];
        [self.singView.vipBtn addTarget:self action:@selector(showVipView) forControlEvents:UIControlEventTouchUpInside];
        
        self.singView.alpha =0;
    }
    self.singView.moneyLabel.text = [NSString stringWithFormat:@"+%@",money];
    self.singView.daysLabel.text = days;
    if (kAPPDelegate.isReadyForSale ==NO) {
        self.singView.openVipView.hidden = YES;
        self.singView.label_3.hidden = YES;
    }
    else
    {
        self.singView.openVipView.hidden = NO;
        self.singView.label_3.hidden = NO;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.singView.alpha =1;
    }];
}
- (void)closeSignView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.singView.alpha =0;
    }];
}

#pragma mark -邀请好友
- (void)share
{
    
    
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
//    [TTUmengManager shareContentWithTitle:@"被动加粉，3天加满5千好友！" Url:@"http://weidianke.qb1611.cn/wjb" shareText:@"免费下载.免费使用.被动加粉坐等被加为好友！突破单日加粉限制.快速建立5千好友朋友圈！" shareImage:[UIImage imageNamed:@"logo"] delegate:nil inSheetView:self];
    
    [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getUserInfo",
                                             @"token":[TTUserInfoManager token]}
                  Success:^(NSDictionary *responseJsonObject) {
                      if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                          ShareViewController* vc = [[ShareViewController alloc]init];
                          [vc setClickCpyImg:^{
                              CpyImgViewController* cvc = [[CpyImgViewController alloc]init];
                              cvc.hidesBottomBarWhenPushed = YES;
                              [self.navigationController pushViewController:cvc animated:YES];
                          }];
                          vc.sharelink = responseJsonObject[@"result"][@"share_link"];
                          vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                          [kAPPDelegate.mainTab presentViewController:vc animated:NO completion:nil];
                      }else{
                          [ProgressHUD showError:responseJsonObject[@"msg"]];
                      }
                  } Failure:^(NSError *error) {
                      
                  }];
    
}

#pragma mark-vip actions 
- (void)showVipView
{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    if (self.singView.alpha ==1) {
        [self closeSignView];
    }
    VipListViewController *vc = [[VipListViewController alloc] init];
    vc.datas = [self.appConfigInfo array_ForKey:@"vip_types_new"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -收入
- (void)incomeList
{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    IncomeListViewController *vc = [[IncomeListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -邀请记录
- (void)inviteHistoryList
{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    InviteListViewController *vc = [[InviteListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -提现
- (void)cashAliPay
{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    AliCashViewController *vc = [[AliCashViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 出租广告位

-(void)resentOutAdvertisement{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    LetAdvertisementViewController *vc = [[LetAdvertisementViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查看广告详细
-(void)chakanguanggao:(UIButton *)sender{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    NSDictionary *dic = [TTUserInfoManager urlArray][sender.tag];
    
    NSString *url = dic[@"url"];
    if (url && url.length > 0) {
        AdvertisementExplainViewController *vc = [[AdvertisementExplainViewController alloc]init];
        vc.urlStr = url;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
    
        GuangGaoXiangQingViewController *vc = [[GuangGaoXiangQingViewController alloc]init];
        vc.theTag = sender.tag;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case XAlertViewTypeJiafen:
        {
            //再次激活加粉
            if (buttonIndex ==1) {
                self.isFansing =NO;//重置加粉状态为NO
                [self startOrPauseFansing];
            }
        }
            break;
        case XAlertViewTypeBeidongJiafen:
        {
            if (buttonIndex ==1) {
                [self showVipView];
            }
        }
            break;
        case XAlertViewTypeClearnBooks:
        {
            if (buttonIndex ==1) {
                [ProgressHUD show:nil];
                [self performSelector:@selector(deleteBooks) withObject:nil afterDelay:0.2];
            }
        }
            break;
        case XAlertViewTypeLoginOut:
        {
            if (buttonIndex ==1) {
                [TTUserInfoManager setLogined:NO];
                [self.collectionView reloadData];
            }
        }
            break;
        case XAlertViewTypeSign:
        {
            if (buttonIndex ==1) {
                NSString * inputAuthCode = [[alertView textFieldAtIndex:0] text];
                if ([[self.appConfigInfo string_ForKey:@"sign_auth_code"] isEqualToString:inputAuthCode]) {
                    //通过了验证
                    [TTUserInfoManager setSignAuthCode:inputAuthCode];
                    [ProgressHUD showSuccess:@"验证通过"];
                    //request 签到
                    [self performSelector:@selector(requestSign) withObject:nil afterDelay:1.2];
                }
                else//未通过验证
                {
                    [ProgressHUD showError:@"验证码错误"];
                    [self performSelector:@selector(singIn) withObject:nil afterDelay:1.2];

                }
            }
        }
            break;

            
        default:
            break;
    }
}

@end
