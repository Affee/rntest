//
//  AdvertisementPayViewController.m
//  WeiDianKe
//
//  Created by lqz on 2017/7/1.
//  Copyright © 2017年 zichenfang. All rights reserved.
//
#import "XuFeiGGTableViewController.h"
#import "PayMentSelectViewController.h"
#import "AdvertisementPayViewController.h"
#import "AddAdvertisementViewController.h"
@interface AdvertisementPayViewController ()<meDelegateViewController>

@property (weak, nonatomic) IBOutlet UIView *renewView;
@property (weak, nonatomic) IBOutlet UIView *theNewView;
@property(strong,nonatomic)NSMutableArray *moneyArray;

@property (weak, nonatomic) IBOutlet UIImageView *NewImgView;
@property (weak, nonatomic) IBOutlet UIImageView *renewImgView;
@property (weak, nonatomic) IBOutlet UIButton *payOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *payTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *payThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *payFourBtn;
@property (weak, nonatomic) IBOutlet UIButton *payFiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *paySixBtn;
@property(strong,nonatomic)NSMutableDictionary *payDic;
@property(strong,nonatomic) NSMutableArray *dataArray;

@property (assign,nonatomic) NSInteger newOrRenew; //新广告还是续费广告  0 新广告 1 续费广告
@property (strong, nonatomic) IBOutlet UILabel *oneDay;
@property (strong, nonatomic) IBOutlet UILabel *oneMoney;
@property (strong, nonatomic) IBOutlet UILabel *twoDay;
@property (strong, nonatomic) IBOutlet UILabel *twoMoney;
@property (strong, nonatomic) IBOutlet UILabel *threeDay;
@property (strong, nonatomic) IBOutlet UILabel *threeMoner;
@property (strong, nonatomic) IBOutlet UILabel *fourDay;
@property (strong, nonatomic) IBOutlet UILabel *fourMoney;
@property (strong, nonatomic) NSArray *payBtnArray; //价格按钮数组
@property(strong,nonatomic) NSArray *selectMoneyArray;
@property(strong,nonatomic)NSArray *selectDayArray;
@property (strong, nonatomic) IBOutlet UILabel *fiveDay;
@property (strong, nonatomic) IBOutlet UILabel *fiveMoney;
@property (strong, nonatomic) IBOutlet UILabel *sixDay;
@property (strong, nonatomic) IBOutlet UILabel *sixMoney;

@property (strong, nonatomic) NSArray *viewArray;
@property (strong, nonatomic) IBOutlet UIImageView *oneView;
@property (strong, nonatomic) IBOutlet UIImageView *twoView;
@property (strong, nonatomic) IBOutlet UIImageView *threeView;
@property (strong, nonatomic) IBOutlet UIImageView *fourView;
@property (strong, nonatomic) IBOutlet UIImageView *fiveView;
@property (strong, nonatomic) IBOutlet UIImageView *sixView;

@end

@implementation AdvertisementPayViewController

-(void)delegateClick:(NSString *)meStr{
    [self.navigationController popViewControllerAnimated:YES];
        AddAdvertisementViewController *vc = [[AddAdvertisementViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
    vc.guangGaoId = meStr;
    vc.day = self.payDic[@"day"];
    vc.money = self.payDic[@"money"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.payBtnArray = [NSArray arrayWithObjects:self.payOneBtn,self.payTwoBtn,self.payThreeBtn,self.payFourBtn,self.payFiveBtn,self.paySixBtn, nil];
    self.selectDayArray = [NSArray arrayWithObjects:self.oneDay,self.twoDay,self.threeDay,self.fourDay,self.fiveDay,self.sixDay, nil];
    self.selectMoneyArray = [NSArray arrayWithObjects:self.oneMoney,self.twoMoney,self.threeMoner,self.fourMoney,self.fiveMoney,self.sixMoney, nil];
    self.viewArray = [NSArray arrayWithObjects:self.oneView,self.twoView,self.threeView,self.fourView,self.fiveView,self.sixView, nil];
    
    for (UIImageView *img in self.viewArray) {
        img.image = [UIImage imageNamed:@"圆角矩形-3-拷贝-2"];
    }
    
    self.navigationItem.title = @"广告位出租";
    
    self.haveRenew = @"0";
    
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/AdvertPrice/queryAll" Parameters:@{} Success:^(NSDictionary *responseJsonObject) {
        if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
            self.moneyArray = responseJsonObject[@"result"][@"items"];
            
            for (UIButton *btn in self.payBtnArray) {
                if (btn.tag > self.moneyArray.count ) {
                    btn.superview.hidden = YES;
                }else{
                    UILabel *lab = self.selectDayArray[btn.tag - 1];
                    lab.text = [NSString stringWithFormat:@"%@",self.moneyArray[btn.tag - 1][@"content"]];
                    UILabel *moneyLab = self.selectMoneyArray[btn.tag - 1];

                    NSInteger mon = [self.moneyArray[btn.tag - 1][@"money"] integerValue];
                    if (mon < [self.moneyArray[btn.tag - 1][@"money"] doubleValue]) {
                        moneyLab.text = [NSString stringWithFormat:@"%@元",self.moneyArray[btn.tag - 1][@"money"]];
                    }else{
                        moneyLab.text = [NSString stringWithFormat:@"%ld元",mon];
                    }
                    [btn addTarget:self action:@selector(selectPayMoney:) forControlEvents:UIControlEventTouchUpInside];
//                    btn.layer.borderWidth = 1;
//                    btn.layer.borderColor = [UIColor redColor].CGColor;
                }
            }
        }
    } Failure:^(NSError *error) {
    }];
    
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryWhere" Parameters:@{@"userId":[TTUserInfoManager userId]} Success:^(NSDictionary *responseJsonObject) {
        if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
            self.haveRenew =@"1";
//            self.dataArray = [NSMutableArray array];
            self.dataArray = responseJsonObject[@"result"][@"items"];
        }else{
            self.haveRenew = @"0";
        }
        [self jiazaijiemian];
    } Failure:^(NSError *error) {
        [ProgressHUD showError:@"网络错误"];
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)jiazaijiemian{
    if ([self.haveRenew isEqualToString:@"0"]) {
        
        self.renewView.hidden = YES;
        self.NewImgView.image = [UIImage imageNamed:@"勾"];
        self.newOrRenew = 0;
        
    }else{
        
        self.renewImgView.image = [UIImage imageNamed:@"勾"];
        self.newOrRenew = 1;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 确认支付
- (IBAction)payNow:(UIButton *)sender {
    if (self.payDic == nil) {
        [ProgressHUD showError:@"请选择时间"];
    }else{
        if (self.newOrRenew == 1) {
            XuFeiGGTableViewController *vc = [[XuFeiGGTableViewController alloc]init];
            vc.payDic = self.payDic;
//            vc.DataArray = self.dataArray;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
        PayMentSelectViewController *vc = [[PayMentSelectViewController alloc]init];
        vc.delegate = self;
        vc.orderDes = [NSString stringWithFormat:@"购买广告:%@天",self.payDic[@"day"]];
        vc.day = self.payDic[@"day"];
        vc.orderPrice = self.payDic[@"money"];
//        vc.goodsId = self.payDic[@"id"];
        vc.buyServicesType = BuyGuangGao;
        vc.guanggao = self.payDic[@"id"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

        }
    }
//                [self delegateClick:@"1"];

}



#pragma mark - 续费广告
- (IBAction)renewBtn:(UIButton *)sender {
    self.renewImgView.image = [UIImage imageNamed:@"勾"];
    self.NewImgView.image = [UIImage imageNamed:@"椭圆-1"];
    self.newOrRenew = 1;
}

#pragma mark - 新广告
- (IBAction)newBtn:(UIButton *)sender {
    self.renewImgView.image = [UIImage imageNamed:@"椭圆-1"];
    self.NewImgView.image = [UIImage imageNamed:@"勾"];
    self.newOrRenew = 0;

}

#pragma mark - 选择时间
- (void)selectPayMoney:(UIButton *)sender {
    for (UIImageView *btn in self.viewArray) {
        if (btn.tag == sender.tag + 1000) {
            btn.image = [UIImage imageNamed:@"圆角矩形-3-拷贝"];
            self.payDic = self.moneyArray[sender.tag - 1];
            
            for (UILabel *moneyLab in self.selectMoneyArray) {
                if (moneyLab.tag == sender.tag + 100) {
                    moneyLab.textColor = [UIColor whiteColor];
                }
            }
            
        }else{
            btn.image = [UIImage imageNamed:@"圆角矩形-3-拷贝-2"];
            for (UILabel *moneyLab in self.selectMoneyArray) {
                if (moneyLab.tag != sender.tag + 100) {
                    moneyLab.textColor = [UIColor redColor];
                }
            }
        }
    }
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
