//
//  MainFooterCollectionReusableView.m
//  WeiDianKe
//
//  Created by flappybird on 16/11/10.
//  Copyright © 2016年 zichenfang. All rights reserved.
//
#import "ChakanGuanggaoViewController.h"
#import "MainFooterCollectionReusableView.h"
#import "UIColor+MyColor.h"

@interface MainFooterCollectionReusableView()<UITableViewDelegate,UITableViewDataSource>
//appconfig
@property (strong, nonatomic) IBOutlet UIButton *inviteBtn;
@property (strong, nonatomic) IBOutlet UIButton *openVIPBtn;
@property (strong, nonatomic) IBOutlet UILabel *vipBoundsCountDesLabel;
@property(strong,nonatomic) NSString *youHaoHuo;
@property (strong, nonatomic) IBOutlet UILabel *superVipBoundsCountDesLabel;
@property (strong,nonatomic) UILabel* marqueeL;

@property (weak, nonatomic) IBOutlet UIButton *btnForOne;
@property (weak, nonatomic) IBOutlet UIButton *btnForTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnForThree;
@property (weak, nonatomic) IBOutlet UIButton *rentOutBtn;

//user config
@property (strong, nonatomic) IBOutlet UILabel *fansLeftCountLabel;//客源名额
@property (strong, nonatomic) IBOutlet UILabel *invite_desLabel;
@property (strong, nonatomic) IBOutlet UILabel *payvip_desLabel;
//@property (strong, nonatomic) IBOutlet UIButton *incomeListBtn;
//@property (strong, nonatomic) IBOutlet UILabel *incomeLabel;

//@property (strong, nonatomic) IBOutlet UIButton *inviteHistoryListBtn;
//@property (strong, nonatomic) IBOutlet UILabel *inviteCountLabel;

//@property (strong, nonatomic) IBOutlet UILabel *remainLabel;
//@property (strong, nonatomic) IBOutlet UIButton *cashBtn;

@property (weak, nonatomic) IBOutlet UIView *marqueeView;

@property (strong,nonatomic) NSString* marqueeLink;

@property (strong,nonatomic) NSTimer* timer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic) NSArray *guanggaoArray;

@end
@implementation MainFooterCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect frame = self.frame;
    frame.size.height = 300;
    self.frame = frame;
    
    self.youHaoHuo = @"2";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.bounces = NO;
    self.midDesView.layer.borderWidth =2;
    self.midDesView.layer.borderColor = [UIColor redColor].CGColor;
    self.midDesView.layer.cornerRadius = 6;
    // 邀请好友
    [self.inviteBtn addTarget:self.target action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    //开通会员
    [self.openVIPBtn addTarget:self.target action:@selector(showVipView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rentOutBtn addTarget:self.target action:@selector(resentOutAdvertisement) forControlEvents:UIControlEventTouchUpInside];
    
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryAllAdver" Parameters:@{} Success:^(NSDictionary *responseJsonObject) {
        NSDictionary *dic = responseJsonObject[@"result"];
        self.guanggaoArray = dic[@"items"];
        
        [TTUserInfoManager setUrlArray:self.guanggaoArray];
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    //收入
//    [self.incomeListBtn addTarget:self.target action:@selector(incomeList) forControlEvents:UIControlEventTouchUpInside];
    //邀请记录
//    [self.inviteHistoryListBtn addTarget:self.target action:@selector(inviteHistoryList) forControlEvents:UIControlEventTouchUpInside];
    //提现
//    [self.cashBtn addTarget:self.target action:@selector(cashAliPay) forControlEvents:UIControlEventTouchUpInside];

    [self.btnForOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btnForOne setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];


}

#pragma mark tableView delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];

//    NSDictionary *dataDic = self.guanggaoArray[indexPath.row];
    NSDictionary *dataDic = [[NSDictionary alloc]init];
    if ([self.youHaoHuo isEqualToString:@"1"]) {
        dataDic = self.guanggaoArray[indexPath.row * 3];
    }
    else if ([self.youHaoHuo isEqualToString:@"2"]){
        dataDic = self.guanggaoArray[indexPath.row * 3 + 1];
    }else{
        dataDic = self.guanggaoArray[indexPath.row * 3 + 2];
    }
    
    UIImageView *cellImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 64.5, 64.5)];
    [cellImg sd_setImageWithURL:[NSURL URLWithString:dataDic[@"userImg"]]];
    [cell addSubview:cellImg];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(cellImg.frame.origin.x + cellImg.bounds.size.width + 15, 10,self.tableView.bounds.size.width - cellImg.frame.origin.x - cellImg.bounds.size.width - 105, 17)];

    titleLab.text = dataDic[@"title"];
    [cell addSubview:titleLab];
    
    UILabel *introduceLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y + titleLab.bounds.size.height  , self.tableView.bounds.size.width - titleLab.frame.origin.x - 90,38)];
    introduceLab.font = [UIFont systemFontOfSize:10];
//    introduceLab.text = dataDic[@"content"];
    introduceLab.textAlignment = 0;
//    introduceLab.attributedText = [self setHtmlStr:dataDic[@"content"]];
    introduceLab.text = [self filterImage:dataDic[@"content"]][0];
    introduceLab.numberOfLines = 2;
//    NSString *theStr = [self filterImage:dataDic[@"content"]][0];
//    NSLog(@"%@",dataDic[@"content"]);
//    NSLog(@"%@",theStr);
    introduceLab.textColor = [UIColor colorWithRed:210/255.8f green:210/255.8f blue:210/255.8f alpha:1];
    [cell addSubview:introduceLab];
    
    if ([dataDic[@"top"] isEqualToString:@"1"]) {
        UILabel *dabiaoLab = [[UILabel alloc]initWithFrame:CGRectMake(cellImg.frame.origin.x, cellImg.frame.origin.y + cellImg.bounds.size.height - 16, cellImg.bounds.size.width , 16)];
        dabiaoLab.text = @"超级推广";
        dabiaoLab.font = [UIFont systemFontOfSize:9];
        dabiaoLab.textColor = [UIColor whiteColor];
        dabiaoLab.adjustsFontSizeToFitWidth = YES;
        dabiaoLab.backgroundColor = [UIColor colorWithRed:255/255 green:42/255.8f blue:5/255.8f alpha:1];
        dabiaoLab.textAlignment = 1;
        dabiaoLab.layer.cornerRadius = 3;
        dabiaoLab.layer.masksToBounds = YES;
        [cell addSubview:dabiaoLab];
    }
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.bounds.size.width - 85, 30, 75, 40)];
    [btn setBackgroundColor:[UIColor redColor]];
    
    [btn setTitle:@"查看" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    [btn addTarget:self.target action:@selector(chakanguanggao:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.youHaoHuo isEqualToString:@"1"]) {
        btn.tag = indexPath.row * 3;
    }
    else if ([self.youHaoHuo isEqualToString:@"2"]){
        btn.tag = indexPath.row * 3 + 1;
    }else{
        btn.tag = indexPath.row * 3 + 2;
    }
    [cell addSubview:btn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSArray *)filterImage:(NSString *)html
{
    NSArray *array = [html componentsSeparatedByString:@"<p>"];
    return array;
}


- (NSMutableAttributedString *)setHtmlStr:(NSString *)html
{
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr setAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:222/255.8f green:224/255.8f blue:224/255.8f alpha:1]}  range:NSMakeRange(0, attr.length)];
//    [attr setAttributes:@{NSForegroundColorAttributeName :[UIColor clearColor]}  range:NSMakeRange(10,attr.length - 10)];
//    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} range:NSMakeRange(0, attr.string.length)];
    
    return attr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGFloat num = 0.0;
    if ([self.youHaoHuo isEqualToString:@"1"]) {
        if (self.guanggaoArray.count % (3) == 1 || self.guanggaoArray.count % (3) == 2) {
             num = self.guanggaoArray.count / 3 + 1;
        }else{
             num = self.guanggaoArray.count / 3;
        }
    }else if ([self.youHaoHuo isEqualToString:@"2"]){
        if (self.guanggaoArray.count % (3) == 2) {
             num = self.guanggaoArray.count / 3 + 1;
        }else{
             num = self.guanggaoArray.count / 3;
        }
    }else{
         num = self.guanggaoArray.count / 3;
    }
    if ([self.delegate respondsToSelector:@selector(footerClick:Int:)]) {
        [self.delegate footerClick:self.youHaoHuo Int:(num)];
    }
    return num;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}


#pragma mark - 好货1
- (IBAction)goodOneBtn:(UIButton *)sender {
    [ProgressHUD show:@"加载中"];
    self.youHaoHuo = @"1";
    [self.btnForOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnForThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnForTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnForOne setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    [self.btnForTwo setBackgroundColor:[UIColor colorWithRed:216/255.8f green:218/255.8f blue:218/255.8f alpha:1]];
    [self.btnForThree setBackgroundColor:[UIColor colorWithRed:216/255.8f green:218/255.8f blue:218/255.8f alpha:1]];
    
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryAllAdver" Parameters:@{} Success:^(NSDictionary *responseJsonObject) {
        NSDictionary *dic = responseJsonObject[@"result"];
        NSLog(@"%@",dic);
        self.guanggaoArray = dic[@"items"];
        [TTUserInfoManager setUrlArray:self.guanggaoArray];
        [self.tableView reloadData];
        [ProgressHUD dismiss];
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
        [ProgressHUD dismiss];
    }];
}


#pragma mark - 好货2

- (IBAction)goodTwoBtn:(UIButton *)sender {
    [ProgressHUD show:@"加载中"];
    self.youHaoHuo = @"2";
    [self.btnForTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnForThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnForOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnForTwo setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    [self.btnForThree setBackgroundColor:[UIColor colorWithRed:216/255.8f green:218/255.8f blue:218/255.8f alpha:1]];
    [self.btnForOne setBackgroundColor:[UIColor colorWithRed:216/255.8f green:218/255.8f blue:218/255.8f alpha:1]];
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryAllAdver" Parameters:@{} Success:^(NSDictionary *responseJsonObject) {
        NSDictionary *dic = responseJsonObject[@"result"];
        NSLog(@"%@",dic);
        self.guanggaoArray = dic[@"items"];
        [TTUserInfoManager setUrlArray:self.guanggaoArray];
        [self.tableView reloadData];
        [ProgressHUD dismiss];
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
        [ProgressHUD dismiss];
    }];
}

#pragma mark - 好货3
- (IBAction)goodThreeBtn:(UIButton *)sender {
    [ProgressHUD show:@"加载中"];
    self.youHaoHuo = @"3";
    [self.btnForThree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnForOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnForTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnForThree setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    [self.btnForTwo setBackgroundColor:[UIColor colorWithRed:216/255.8f green:218/255.8f blue:218/255.8f alpha:1]];
    [self.btnForOne setBackgroundColor:[UIColor colorWithRed:216/255.8f green:218/255.8f blue:218/255.8f alpha:1]];
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryAllAdver" Parameters:@{} Success:^(NSDictionary *responseJsonObject) {
        NSDictionary *dic = responseJsonObject[@"result"];
        NSLog(@"%@",dic);
        self.guanggaoArray = dic[@"items"];
        [TTUserInfoManager setUrlArray:self.guanggaoArray];
        [self.tableView reloadData];
        [ProgressHUD dismiss];
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
        [ProgressHUD dismiss];
    }];
}


//APP配置信息赋值
- (void)setAppConfigInfo:(NSDictionary *)info{
    self.invite_desLabel.text = [info string_ForKey:@"invite_des"];
    self.payvip_desLabel.text = [info string_ForKey:@"payvip_des"];
    ///
    //邀请好友，黄金会员奖励
    NSString *vipbonus_invites_count = [info string_ForKey:@"vipbonus_invites_count"];
    NSString *vipbonus_invites_des = [NSString stringWithFormat:@"5：每邀请%@个好友，奖励黄金会员1天",vipbonus_invites_count];
    NSMutableAttributedString *vipbonus_invites_des_attri = [[NSMutableAttributedString alloc]initWithString:vipbonus_invites_des];
    [vipbonus_invites_des_attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[vipbonus_invites_des rangeOfString:vipbonus_invites_count]];
    [vipbonus_invites_des_attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(vipbonus_invites_des.length-2, 1)];

    self.vipBoundsCountDesLabel.attributedText = vipbonus_invites_des_attri;
    //邀请好友，钻石会员奖励
    NSString *supervipbonus_invites_count = [info string_ForKey:@"supervipbonus_invites_count"];
    NSString *supervipbonus_invites_des = [NSString stringWithFormat:@"6：每邀请%@个好友，奖励钻石会员1天",supervipbonus_invites_count];
    NSMutableAttributedString *supervipbonus_invites_des_attri = [[NSMutableAttributedString alloc]initWithString:supervipbonus_invites_des];
    [supervipbonus_invites_des_attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[supervipbonus_invites_des rangeOfString:supervipbonus_invites_count]];
    [supervipbonus_invites_des_attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(supervipbonus_invites_des.length-2, 1)];
    self.superVipBoundsCountDesLabel.attributedText = supervipbonus_invites_des_attri;
    [self.marqueeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.marqueeL = [[UILabel alloc]init];
    [self.marqueeL setUserInteractionEnabled:YES];
    self.marqueeL.text = info[@"marquee"][@"content"];
    [self.marqueeL setFont:[UIFont systemFontOfSize:14]];
    [self.marqueeL setTextColor:[UIColor colorWithHexString:@"d04443"]];
    self.marqueeLink = info[@"marquee"][@"link"];
    [self.marqueeL sizeToFit];
    
    CGRect frame = self.marqueeL.frame;
    frame.origin.x = -CGRectGetWidth(self.marqueeView.bounds);
    frame.origin.y = 0;
    frame.size.height = CGRectGetHeight(self.marqueeView.bounds);
    [self.marqueeL setFrame:frame];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(marqueeLTap)];
    [self.marqueeL addGestureRecognizer:tap];
    
    [self.marqueeView addSubview:self.marqueeL];
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            CGRect f = self.marqueeL.frame;
            if (f.origin.x <= -CGRectGetWidth(self.marqueeL.bounds)) {
                f.origin.x = CGRectGetWidth(self.marqueeView.bounds);
            }else{
                f.origin.x -= 2;
            }
            [self.marqueeL setFrame:f];
        }];
    }
}

-(void)marqueeLTap{
    self.clickMarquee(self.marqueeLink);
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
//    //收入
//    self.incomeLabel.text = [info string_ForKey:@"incomes"];
//    //邀请好友数
//    self.inviteCountLabel.text = [info string_ForKey:@"invites"];
//    //余额
//    self.remainLabel.text = [info string_ForKey:@"remains"];
    
    
}
//
- (void)setIsReadyForSale:(BOOL)isReadyForSale{
    if (isReadyForSale ==YES) {
        self.openVIPBtn.superview.hidden = NO;
    }else{
        self.openVIPBtn.superview.hidden = YES;
    }
}
@end
