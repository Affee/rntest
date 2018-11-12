//
//  ChoujiangViewController.m
//  WeiDianKe
//
//  Created by flappybird on 16/11/15.
//  Copyright © 2016年 zichenfang. All rights reserved.
//


#import "ChoujiangViewController.h"
#import "AllBonusListViewController.h"
#import "LuckCodeListViewController.h"
#import "MyBonusListViewController.h"
#import "LoginView.h"
#import "TTUmengManager.h"
#import "MJRefresh.h"
#import "ShareViewController.h"
#import "CpyImgViewController.h"

@interface GridItemView :UIView
@property (nonatomic,strong) UIImageView *imgView;

@end
@implementation GridItemView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.imgView];
//        self.imgView.layer.masksToBounds = YES;
//        self.imgView.layer.cornerRadius =6;
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}
@end

@interface ChoujiangViewController ()<UITableViewDataSource,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UILabel *leftLuckCodeDesLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *gridContentView;
@property (strong, nonatomic) NSMutableArray *gridViews;//奖池View数组

/*
 抽到奖品的别名：（11：iPhone6；12：iPhone7；21：钻石会员1天；22：钻石会员30天；23：钻石会员永久；24：钻石会员永久；25：黄金会员1天；26：黄金会员永久；31：50个加粉名额；32：100个加粉名额；33：500个加粉名额；34：10000个加粉名额）
 */
@property (strong, nonatomic) NSArray *bounKeys;//奖池关键字数组，按照效果图排序的

@property (strong, nonatomic) UIButton *startBtn;//抽奖启动按钮
@property (assign, nonatomic) NSInteger currendGridIndex;//当前高亮grid的index
@property (assign, nonatomic) NSInteger bonusIndex;//抽到的奖品index

@property (assign, nonatomic) int lottery_left_count;//剩余抽奖次数


@property (strong, nonatomic) NSTimer *gridTimer;//抽奖循环计时器
@property (strong, nonatomic) UIView *coverView;//抽奖时，遮住控制器，阻止用户交互


@property (strong, nonatomic) IBOutlet UITableView *bounsNewsTableView;
@property (strong, nonatomic) NSArray *bounsNewsArray;//滚动的中奖骗人信息

@property (assign, nonatomic) NSInteger bounsNewsScrollIndex;


//登录
@property (strong, nonatomic) LoginView *loginView;
@property (assign, nonatomic) int leftCount;//验证码倒计时秒数

@end

@implementation ChoujiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"抽奖";
    self.contentHeightConstraint.constant = 410+(kDeviceWidth -30*2)*1.0;
       //奖池
    [self prepareAllGridItemView];

    //中奖实时信息滚动
    NSURL *fileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bonusNewsPlist" ofType:@"plist"]];
    self.bounsNewsArray = [NSArray arrayWithContentsOfURL:fileUrl];
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollBonusNews) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:userInfoDidUpdated object:nil];
    [self refreshUI];
    
    self.contentScrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUserInfo];
        
    }];
    
}
- (void)refreshUI
{
    self.lottery_left_count =[[[TTUserInfoManager userInfo] string_ForKey:@"lottery_left_count"] intValue];
    self.leftLuckCodeDesLabel.text = [NSString stringWithFormat:@"我的幸运码：%d个",self.lottery_left_count];
    
}
- (void)loadUserInfo
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/getUserInfo" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        [self.contentScrollView.header endRefreshing];
        if ([code isEqualToString:@"1"])//
        {
            [TTUserInfoManager setUserInfo:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:userInfoDidUpdated object:nil];
        }
    } Failure:^(NSError *error) {
        [self.contentScrollView.header endRefreshing];
    }];
}

- (void)prepareAllGridItemView
{
    //铺设4x4 16个view，tag值按照(行+1)*10+列+1 来定义
    float edgeRoom =8;//边距
    float itemRoom =5;//格子指间的边距itemWidth
    float itemWidth =(kDeviceWidth-30*2-edgeRoom*2-itemRoom*3)/4.0f;
    float itemHeight =itemWidth;

    for (int R=0; R<4; R++) {
        for (int L=0; L<4; L++) {
            GridItemView *itemView = [[GridItemView alloc] initWithFrame:CGRectMake(edgeRoom+L*(itemWidth+itemRoom), edgeRoom+R*(itemHeight+itemRoom), itemWidth, itemHeight)];
            [self.gridContentView addSubview:itemView];
            itemView.tag =(R+1)*10+L+1;
            itemView.hidden = YES;//全部隐藏
        }
    }
    //从左上角开始，按照顺时针方向，取其对应的tag
    NSArray *showArrayIndex = @[@11,@12,@13,@14,@24,@34,@44,@43,@42,@41,@31,@21];
    self.gridViews = [NSMutableArray arrayWithCapacity:12];
    
    //按照效果图上面的顺序，从左上角开始，顺时针安排奖品信息key数组
    self.bounKeys = @[@"11",@"21",@"12",@"25",@"23",@"34",@"24",@"33",@"32",@"22",@"26",@"31"];

    for (int i=0;i<12;i++) {
        NSNumber *tagNumber = [showArrayIndex objectAtIndex:i];
        GridItemView *itemView = [self.gridContentView viewWithTag:tagNumber.integerValue];
        [self.gridViews addObject:itemView];
        itemView.hidden = NO;

        itemView.imgView.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",self.bounKeys[i]]];
        itemView.imgView.highlightedImage =[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",self.bounKeys[i]]];

    }
    
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startBtn.frame = CGRectMake(0, 0, itemWidth*2, itemHeight*2);
    self.startBtn.center = CGPointMake((kDeviceWidth-30*2)*0.5, (kDeviceWidth-30*2)*0.5);
    [self.startBtn setImage:[UIImage imageNamed:@"马上抽奖"] forState:UIControlStateNormal];
    [self.startBtn addTarget:self action:@selector(requsetLuckNow) forControlEvents:UIControlEventTouchUpInside];
    [self.gridContentView addSubview:self.startBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollBonusNews
{
    self.bounsNewsScrollIndex+=1;
    if (self.bounsNewsScrollIndex>=self.bounsNewsArray.count) {
        self.bounsNewsScrollIndex =0;
        [self.bounsNewsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    else
    {
        [self.bounsNewsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.bounsNewsScrollIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }

    
}
#pragma mark -活动规则
- (IBAction)guize:(id)sender {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"活动规则" ofType:@"html"];
    WebViewController *vc = [[WebViewController alloc] init];
    vc.url = [NSURL fileURLWithPath:filePath];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark-我的奖品

- (IBAction)myBonusList:(id)sender {
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
    }
    else
    {
        MyBonusListViewController *vc = [[MyBonusListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -活动奖品
- (IBAction)allBounsList:(id)sender
{
    AllBonusListViewController *vc = [[AllBonusListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark-分享或者购买幸运码
- (IBAction)share_buyluck:(id)sender {

    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
    }
    else
    {
        UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享获得幸运码",@"购买幸运码", nil];
        [act showInView:self.view];

    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {//分享
//        [TTUmengManager shareContentWithTitle:@"被动加粉，3天加满5千好友！" Url:@"http://weidianke.qb1611.cn/wjb" shareText:@"免费下载.免费使用.被动加粉坐等被加为好友！突破单日加粉限制.快速建立5千好友朋友圈！" shareImage:[UIImage imageNamed:@"logo"] delegate:nil inSheetView:self];
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
    else if (buttonIndex ==1)//购买
    {
        [self goLuckGoodsList];
    }
}
#pragma mark -购买幸运码

- (void)goLuckGoodsList
{
    LuckCodeListViewController *vc = [[LuckCodeListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -分享

- (void)share
{}

#pragma mark//请求返回抽奖结果
- (void)requsetLuckNow
{
    if ([TTUserInfoManager logined] ==NO) {
        [self showLoginView];
        return;
    }
    if (self.lottery_left_count<=0) {
        [ProgressHUD showError:@"没有幸运码了，分享或者购买来获取邀请码"];
        [self performSelector:@selector(share_buyluck:) withObject:nil afterDelay:2.0];
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/choujiang" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
     [self showCoverView];
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"1"])//
        {
            //刷新下用户信息
            [self loadUserInfo];
            //奖品
            NSString *bonus_type = [result string_ForKey:@"bonus_type"];
            if ([self.bounKeys indexOfObject:bonus_type]!=NSNotFound) {
                self.bonusIndex =[self.bounKeys indexOfObject:bonus_type];
                //奖品要往下轮转，需要在上次抽奖完之后的index除余上加上4个轮转轮回，也就是12*4
                self.bonusIndex = self.bonusIndex+self.currendGridIndex/12*12+12*4;
                
                //启动抽奖
                if (self.gridTimer ==nil) {
                    self.gridTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rollingGridView) userInfo:nil repeats:YES];
                }
                else
                {
                    [self.gridTimer invalidate];
                    self.gridTimer =nil;
                    self.gridTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rollingGridView) userInfo:nil repeats:YES];
                    
                }
                
            }

            self.lottery_left_count = [[result string_ForKey:@"lottery_left_count"] intValue];
            self.leftLuckCodeDesLabel.text = [NSString stringWithFormat:@"我的幸运码：%d个",self.lottery_left_count];

        }
        else
        {
            [ProgressHUD showError:@"抽奖信息错误"];
            [self hideCoverView];
        }
    } Failure:^(NSError *error) {
        [self hideCoverView];

    }];

}
- (void)rollingGridView
{
    [UIView animateWithDuration:0.01 animations:^{
        GridItemView *lastItemView = [self.gridViews objectAtIndex:self.currendGridIndex%self.gridViews.count];
        lastItemView.imgView.highlighted = NO;
        self.currendGridIndex++;
        GridItemView *nextItemView = [self.gridViews objectAtIndex:self.currendGridIndex%self.gridViews.count];
        nextItemView.imgView.highlighted = YES;
    }];

    //轮转到中奖的index，则停住
    if (self.currendGridIndex ==self.bonusIndex) {
        [self.gridTimer invalidate];
        self.gridTimer =nil;
        [self hideCoverView];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BonusWithKeysPlist" ofType:@"plist"];
        NSDictionary *bonnusWithKeys = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:path]];
        NSString *bonusDes = [bonnusWithKeys string_ForKey:[self.bounKeys objectAtIndex:self.bonusIndex%12]];
        
        [[[UIAlertView alloc] initWithTitle:@"恭喜中奖" message:[NSString stringWithFormat:@"恭喜获得：%@",bonusDes] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];

        
        return;
    }
    //半圈减速一次
    if (self.gridTimer.timeInterval<0.5&&self.currendGridIndex%(6)==0) {
        NSTimeInterval fastTimer =(double)MIN(0.5, self.gridTimer.timeInterval*(1.2));
        [self.gridTimer invalidate];
        self.gridTimer =nil;
        self.gridTimer = [NSTimer scheduledTimerWithTimeInterval:fastTimer target:self selector:@selector(rollingGridView) userInfo:nil repeats:YES];
        
    }
    
}
- (void)showCoverView
{
    if (self.coverView ==nil) {
        self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
        self.coverView.backgroundColor = [UIColor clearColor];
        [kAPPDelegate.window addSubview:self.coverView];
    }
    self.coverView.hidden = NO;
}
- (void)hideCoverView
{
    self.coverView.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bounsNewsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi = @"phone";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
        cell.textLabel.adjustsFontSizeToFitWidth =YES;
        cell.backgroundColor = [UIColor clearColor];
    }


    cell.textLabel.text =self.bounsNewsArray[indexPath.row];
    return cell;
    
}
#pragma mark-登录处理
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
- (void)obtainCode
{
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
        }
        else
        {
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
        }
        else
        {
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
    
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        [self.loginView.phoneTF resignFirstResponder];
        [self.loginView.codeTF resignFirstResponder];
        [self.loginView.invitePhoneTF resignFirstResponder];
        
        if ([code isEqualToString:@"1"])//
        {
            [TTUserInfoManager setUserInfo:result];
            [TTUserInfoManager setLogined:YES];
            [TTUserInfoManager setPhone:self.loginView.phoneTF.text.absoluteString];
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
    
}
@end
