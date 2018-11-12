//
//  PayMentSelectViewController.m
//  WeiDianKe
//
//  Created by flappybird on 16/11/14.
//  Copyright © 2016年 zichenfang. All rights reserved.
//


#import "PayMentSelectViewController.h"
#import "PayMentTableViewCell.h"
#import "DDAliPayManager.h"
#import "DDWeChatPayManager.h"
#import "UPPaymentControl.h"

@interface PayMentSelectViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger selectedPayIndex;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *czView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSString *typeData;
@end

@implementation PayMentSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.moneyTF.delegate = self;
    
    if (self.buyServicesType != BuyMoney) {
        self.czView.hidden = YES;
        self.navigationItem.title = @"请选择支付方式";
        self.orderNameLabel.text = self.orderDes;
        self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.orderPrice floatValue]];
    }else{
        UIView* headerView = self.tableView.tableHeaderView;
        [headerView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 120)];
        self.tableView.tableHeaderView = headerView;
    }
    
    
    [TTRequestManager GET:@"http://weike.qb1611.cn/index.php?r=api/Notice/yinLianState" Parameters:nil Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        
        NSLog(@"responseJsonObject---%@",responseJsonObject);
        
        if ([code isEqualToString:@"1"])//
        {
            NSString* tn = result[@"items"][@"data"];
            if ([tn  isEqualToString: @"1"]) {
                self.num = 1;
                self.typeData = @"银联和微信全部隐藏";
            }else if ([tn  isEqualToString: @"2"])
            {
                self.num = 2;
                self.typeData = @"关闭银联,开启微信";
            }else if ([tn  isEqualToString: @"3"])
            {
                self.num = 2;
                self.typeData = @"开启银联,关闭微信";
            }else if ([tn  isEqualToString: @"4"])
            {
                self.num = 3;
                self.typeData = @"开启银联,开启微信";
            }

        }
        else
        {
            [ProgressHUD showError:msg];
        }
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        //
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.buyServicesType == BuyGuangGao || self.buyServicesType == BuyXuFeiGuangGao) {
//        return 2;
//    }else{
        return self.num;
//    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi =@"pay";
    PayMentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PayMentTableViewCell" owner:self options:nil][0];
    }
    if (indexPath.row ==0) {
        cell.logoImgView.image = [UIImage imageNamed:@"alipay"];
        cell.nameLabel.text  =@"支付宝支付";
        cell.lineView.hidden = NO;
        [cell setUnionLHidden:YES];
    }
    else if (indexPath.row == 1)
    {
        if ([self.typeData isEqualToString:@"开启银联,关闭微信"]) {
            cell.logoImgView.image = [UIImage imageNamed:@"union pay"];
            cell.nameLabel.text  =@"银联支付";
            cell.lineView.hidden = NO;
            [cell setUnionLHidden:NO];
        }else
        {
            cell.logoImgView.image = [UIImage imageNamed:@"WeChat pay"];
            cell.nameLabel.text  =@"微信支付";
            cell.lineView.hidden = NO;
            [cell setUnionLHidden:YES];
        }
       
    }else{
        cell.logoImgView.image = [UIImage imageNamed:@"union pay"];
        cell.nameLabel.text  =@"银联支付";
        cell.lineView.hidden = NO;
        [cell setUnionLHidden:NO];
    }
    
    
    if (indexPath.row ==self.selectedPayIndex) {
        cell.selectImgView.image = [UIImage imageNamed:@"Select"];
    }
    else
    {
        cell.selectImgView.image = [UIImage imageNamed:@"Unchecked"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPayIndex =indexPath.row;
    [self.tableView reloadData];
}
//确认支付
- (IBAction)comfirPay:(id)sender {
    if (self.selectedPayIndex ==1) {
        if ([self.typeData isEqualToString:@"开启银联,关闭微信"]) {
            [self unionPay];
        }else
        {
           [self weixinPay];
        }
        
    }
    else if (self.selectedPayIndex == 0)
    {
        [self zhifubaoPay];
    }else {
        [self unionPay];
    }
}
//支付方式选择
-(void)unionPay{
    if (self.buyServicesType == BuyServicesVipType || self.buyServicesType == BuyServicesLuckyCodeType) {
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setObject:[TTUserInfoManager token] forKey:@"token"];
        [para setObject:@"3" forKey:@"payment"];
        
        if (self.buyServicesType ==BuyServicesVipType) {
            [para setObject:@"api/user/newopenMember" forKey:@"r"];
            [para setObject:self.goodsId forKey:@"vip_id"];
        }
        else
        {
            [para setObject:@"api/user/buyLuckycode" forKey:@"r"];
            [para setObject:self.goodsId forKey:@"lucky_code_id"];
            
        }
        
        [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
            //
            NSString *code = [responseJsonObject string_ForKey:@"code"];
            NSString *msg = [responseJsonObject string_ForKey:@"msg"];
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            if ([code isEqualToString:@"1"])//
            {
                NSString* tn = result[@"tn"];
                if ([[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo" mode:@"00" viewController:self]){

                        [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [ProgressHUD showError:@"支付失败"];

                }
                
            }
            else
            {
                [ProgressHUD showError:msg];
            }
        } Failure:^(NSError *error) {
            //
        }];
    }else if (self.buyServicesType == BuyMoney){
        if (self.moneyTF.text.length == 0) {
            [ProgressHUD showError:@"请输入充值金额"];
        }else if (![self isPureFloat:self.moneyTF.text]){
            [ProgressHUD showError:@"请输入数字"];
        }else{
            [TTRequestManager POST:kHTTP Parameters:@{@"r":@"api/user/qrcodeRecharge",
                                                      @"token":[TTUserInfoManager token],
                                                      @"payment":@"3",
                                                      @"price":[NSString stringWithFormat:@"%.2f",[self.moneyTF.text floatValue]]}
                           Success:^(NSDictionary *responseJsonObject) {
                               NSString *code = [responseJsonObject string_ForKey:@"code"];
                               NSString *msg = [responseJsonObject string_ForKey:@"msg"];
                               NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
                               if ([code isEqualToString:@"1"])//
                               {
                                   NSString* tn = result[@"tn"];
                                   if ([[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo" mode:@"00" viewController:self]){

                                           [self.navigationController popViewControllerAnimated:YES];
                                    
                                   }else{
                                       [ProgressHUD showError:@"支付失败"];
                                   }
                                   
                               }
                               else
                               {
                                   [ProgressHUD showError:msg];
                               }
                           } Failure:^(NSError *error) {
                               
                           }];
        }
    }else if(self.buyServicesType == BuyGuangGao || self.buyServicesType == BuyXuFeiGuangGao){
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        [par setObject:[TTUserInfoManager userId] forKey:@"userId"];
        [par setObject:self.day forKey:@"day"];
        [par setObject:[NSString stringWithFormat:@"%.2f",[self.orderPrice floatValue]] forKey:@"money"];
        [par setObject:@"3" forKey:@"payType"];
        if (self.buyServicesType == BuyGuangGao) {
            [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/postAdver" Parameters:par Success:^(NSDictionary *responseJsonObject) {
                NSLog(@"%@",responseJsonObject[@"result"][@"items"][@"id"]);
                if ([responseJsonObject[@"code"] isEqualToString:@"1"]){
                    NSString* tn = responseJsonObject[@"result"][@"items"][@"tn"];
                    if ([[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo" mode:@"00" viewController:self]){
                        
                        [_delegate delegateClick:responseJsonObject[@"result"][@"items"][@"id"]];
                        
                    }else{
                        [ProgressHUD showError:@"支付失败"];
                    }

                }
            } Failure:^(NSError *error) {
                
            }];
        }else{
            [par setObject:self.guanggao forKey:@"id"];
            [par setObject:@"3" forKey:@"payType"];
            [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/renewAdInfo" Parameters:par Success:^(NSDictionary *responseJsonObject) {
                NSLog(@"%@",responseJsonObject[@"result"][@"items"][@"id"]);
                if ([responseJsonObject[@"code"] isEqualToString:@"1"]){
                    NSString* tn = responseJsonObject[@"result"][@"items"][@"tn"];
                    if ([[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo" mode:@"00" viewController:self]){
                        
                        [_delegate delegateClick:responseJsonObject[@"result"][@"items"][@"id"]];
                        
                    }else{
                        [ProgressHUD showError:@"支付失败"];
                    }
                }
            } Failure:^(NSError *error) {
                
            }];
            
        }
    }else{
        [TTRequestManager POST:kHTTP Parameters:@{@"r":@"api/user/openQrcodeMember",
                                                  @"token":[TTUserInfoManager token],
                                                  @"payment":@"3",
                                                  @"serviceId":self.goodsId,
                                                  @"typeid":[TTUserInfoManager vip_typeid]}
                       Success:^(NSDictionary *responseJsonObject) {
                           NSString *code = [responseJsonObject string_ForKey:@"code"];
                           NSString *msg = [responseJsonObject string_ForKey:@"msg"];
                           NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
                           if ([code isEqualToString:@"1"])//
                           {
                               NSString* tn = result[@"tn"];
                               if ([[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo" mode:@"00" viewController:self]){

                                       [self.navigationController popViewControllerAnimated:YES];
                                   
                               }else{
                                   [ProgressHUD showError:@"支付失败"];

                               }
                           }
                           else
                           {
                               [ProgressHUD showError:msg];
                           }
                       } Failure:^(NSError *error) {
                           
                       }];
    }

}

- (void)zhifubaoPay
{
    if (self.buyServicesType == BuyServicesVipType || self.buyServicesType == BuyServicesLuckyCodeType) {
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setObject:[TTUserInfoManager token] forKey:@"token"];
        [para setObject:@"1" forKey:@"payment"];
        
        if (self.buyServicesType ==BuyServicesVipType) {
            [para setObject:@"api/user/newopenMember" forKey:@"r"];
            [para setObject:self.goodsId forKey:@"vip_id"];
        }
        else
        {
            [para setObject:@"api/user/buyLuckycode" forKey:@"r"];
            [para setObject:self.goodsId forKey:@"lucky_code_id"];
            
        }
        
        [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
            //
            NSString *code = [responseJsonObject string_ForKey:@"code"];
            NSString *msg = [responseJsonObject string_ForKey:@"msg"];
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            if ([code isEqualToString:@"1"])//
            {
                NSString *pay_sn = [result string_ForKey:@"pay_sn"];
                NSString *pay_value = [result string_ForKey:@"pay_value"];
                NSString *notifyUrl;
                if (self.buyServicesType ==BuyServicesVipType) {
//                    notifyUrl =@"http://zfjiafen.heizitech.com/index.php?r=api/common/newnotify";
                    notifyUrl =@"http://weike.qb1611.cn/index.php?r=api/common/newnotify";
                }
                else
                {
//                    notifyUrl =@"http://zfjiafen.heizitech.com/index.php?r=api/common/luckynotify";
//                    notifyUrl =@"http://119.23.66.37/zhuanfa_jiafen/index.php?r=api/common/luckynotify";
                    notifyUrl = @"http://weike.qb1611.cn/index.php?r=api/Common/luckynotify";
                }
                
                [DDAliPayManager payOrderWithOrderID:pay_sn Title:self.orderDes Description:self.orderDes Price:[pay_value floatValue] NotifyURL:notifyUrl Block:^(BOOL whether) {
                    if (whether) {
                        //刷新用户信息
                        [self loadUserInfo];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    else
                    {
                        [ProgressHUD showError:@"支付失败"];

                    }
                }];
                
            }
            else
            {
                [ProgressHUD showError:msg];
            }
        } Failure:^(NSError *error) {
            //
        }];
    }else if (self.buyServicesType == BuyMoney){
        if (self.moneyTF.text.length == 0) {
            [ProgressHUD showError:@"请输入充值金额"];
        }else if (![self isPureFloat:self.moneyTF.text]){
            [ProgressHUD showError:@"请输入数字"];
        }else{
            [TTRequestManager POST:kHTTP Parameters:@{@"r":@"api/user/qrcodeRecharge",
                                                      @"token":[TTUserInfoManager token],
                                                      @"payment":@"1",
                                                      @"price":[NSString stringWithFormat:@"%.2f",[self.moneyTF.text floatValue]]}
                           Success:^(NSDictionary *responseJsonObject) {
                               NSString *code = [responseJsonObject string_ForKey:@"code"];
                               NSString *msg = [responseJsonObject string_ForKey:@"msg"];
                               NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
                               if ([code isEqualToString:@"1"])//
                               {
                                   NSString *pay_sn = [result string_ForKey:@"pay_sn"];
                                   NSString *pay_value = [result string_ForKey:@"pay_value"];
//                                   NSString *notifyUrl = @"http://zfjiafen.heizitech.com/newwxnotify.html";
                                   NSString *notifyUrl = @"http://weike.qb1611.cn/index.php?r=api/common/newnotify";
                                
                                   
                                   [DDAliPayManager payOrderWithOrderID:pay_sn Title:self.orderDes Description:self.orderDes Price:[pay_value floatValue] NotifyURL:notifyUrl Block:^(BOOL whether) {
                                       if (whether) {
                                           //刷新用户信息
                                           [self loadUserInfo];
                                         
                                            [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }
                                       else
                                       {
                                           [ProgressHUD showError:@"支付失败"];
                                       }
                                   }];
                                   
                               }
                               else
                               {
                                   [ProgressHUD showError:msg];
                               }
                           } Failure:^(NSError *error) {
                               
                           }];
        }
    }else if(self.buyServicesType == BuyGuangGao || self.buyServicesType == BuyXuFeiGuangGao){
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        [par setObject:[TTUserInfoManager userId] forKey:@"userId"];
        [par setObject:self.day forKey:@"day"];
        [par setObject:[NSString stringWithFormat:@"%.2f",[self.orderPrice floatValue]] forKey:@"money"];
        [par setObject:@"1" forKey:@"payType"];
        if (self.buyServicesType == BuyGuangGao) {
            [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/postAdver" Parameters:par Success:^(NSDictionary *responseJsonObject) {
                NSLog(@"%@",responseJsonObject[@"result"][@"items"][@"id"]);
                if ([responseJsonObject[@"code"] isEqualToString:@"1"]){
                    float price = [responseJsonObject[@"result"][@"items"][@"money"] floatValue];
                    [DDAliPayManager payOrderWithOrderID:responseJsonObject[@"result"][@"items"][@"id"] Title:self.orderDes Description:self.orderDes Price:price NotifyURL:@"http://weike.qb1611.cn/index.php?r=api/Common/advertNotify" Block:^(BOOL whether) {
                        if (whether) {
                            [self loadUserInfo];
                            [_delegate delegateClick:responseJsonObject[@"result"][@"items"][@"id"]];
                        }else{
                            [ProgressHUD showError:@"支付失败"];
                            
                        }
                    }];
                }
            } Failure:^(NSError *error) {
                
            }];
        }else{
            [par setObject:self.guanggao forKey:@"id"];
            [par setObject:@"1" forKey:@"payType"];
            [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/renewAdInfo" Parameters:par Success:^(NSDictionary *responseJsonObject) {
                NSLog(@"%@",responseJsonObject[@"result"][@"items"][@"id"]);
                if ([responseJsonObject[@"code"] isEqualToString:@"1"]){
                    float price = [responseJsonObject[@"result"][@"items"][@"money"] floatValue];
                    [DDAliPayManager payOrderWithOrderID:responseJsonObject[@"result"][@"items"][@"id"] Title:self.orderDes Description:self.orderDes Price:price NotifyURL:@"http://weike.qb1611.cn/index.php?r=api/Common/advertNotify" Block:^(BOOL whether) {
                        if (whether) {
                            [self loadUserInfo];
                            [_delegate delegateClick:responseJsonObject[@"result"][@"items"][@"id"]];
                        }else{
                            [ProgressHUD showError:@"支付失败"];
                            
                        }
                    }];
                }
            } Failure:^(NSError *error) {
                
            }];

        }
    }else{
        [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/user/openQrcodeMember" Parameters:@{
                                                  @"token":[TTUserInfoManager token],
                                                  @"payment":@"1",
                                                  @"serviceId":self.goodsId,
                                                  @"typeid":[TTUserInfoManager vip_typeid]}
                       Success:^(NSDictionary *responseJsonObject) {
                           NSString *code = [responseJsonObject string_ForKey:@"code"];
                           NSString *msg = [responseJsonObject string_ForKey:@"msg"];
                           NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
                           if ([code isEqualToString:@"1"])//
                           {
                               NSString *pay_sn = [result string_ForKey:@"pay_sn"];
                               NSString *pay_value = [result string_ForKey:@"pay_value"];
//                               NSString *notifyUrl = @"http://zfjiafen.heizitech.com/index.php?r=api/common/newnotify";
                               NSString *notifyUrl = @"http://weike.qb1611.cn/index.php?r=api/common/newnotify";
                               
                               [DDAliPayManager payOrderWithOrderID:pay_sn Title:self.orderDes Description:self.orderDes Price:[pay_value floatValue] NotifyURL:notifyUrl Block:^(BOOL whether) {
                                   if (whether) {
                                       //刷新用户信息
                                       [self loadUserInfo];

                                           [self.navigationController popViewControllerAnimated:YES];

                                   }
                                   else
                                   {
                                       [ProgressHUD showError:@"支付失败"];

                                   }
                               }];
                               
                           }
                           else
                           {
                               [ProgressHUD showError:msg];
                           }
                       } Failure:^(NSError *error) {
                           
                       }];
    }
    
    
}
- (void)weixinPay
{
    
    if (self.buyServicesType == BuyServicesVipType || self.buyServicesType == BuyServicesLuckyCodeType) {
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setObject:[TTUserInfoManager token] forKey:@"token"];
        [para setObject:@"2" forKey:@"payment"];
        if (self.buyServicesType ==BuyServicesVipType) {
            [para setObject:@"api/user/newopenMember" forKey:@"r"];
            [para setObject:self.goodsId forKey:@"vip_id"];
        }
        else
        {
            [para setObject:@"api/user/buyLuckycode" forKey:@"r"];
            [para setObject:self.goodsId forKey:@"lucky_code_id"];
            
        }
        [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
            //
            NSString *code = [responseJsonObject string_ForKey:@"code"];
            NSString *msg = [responseJsonObject string_ForKey:@"msg"];
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            if ([code isEqualToString:@"1"])//
            {
                NSString *pay_sn = [result string_ForKey:@"pay_sn"];
                NSString *pay_value = [result string_ForKey:@"pay_value"];
                NSString *notifyUrl;
                if (self.buyServicesType ==BuyServicesVipType) {
//                    notifyUrl =@"http://zfjiafen.heizitech.com/newwxnotify.html";
                    notifyUrl =@"http://weike.qb1611.cn/newwxnotify.php";
                }
                else
                {
//                    notifyUrl =@"http://zfjiafen.heizitech.com/luckywxnotify.html";
                    notifyUrl = @"http://weike.qb1611.cn/luckywxnotify.php";
                }
                [DDWeChatPayManager payWithDescription:self.orderDes Detail:self.orderDes Trade_no:pay_sn Total_fee:[pay_value floatValue] NotifyURL:notifyUrl Block:^(BOOL whether) {
                    if (whether) {
                        //刷新用户信息
                        [self loadUserInfo];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [ProgressHUD showError:@"支付失败"];

                    }
                }];
            }
            else
            {
                [ProgressHUD showError:msg];
            }
        } Failure:^(NSError *error) {
            //
        }];
    }else if (self.buyServicesType == BuyMoney){
        if (self.moneyTF.text.length == 0) {
            [ProgressHUD showError:@"请输入充值金额"];
        }else if (![self isPureFloat:self.moneyTF.text]){
            [ProgressHUD showError:@"请输入数字"];
        }else{
            [TTRequestManager POST:kHTTP Parameters:@{@"r":@"api/user/qrcodeRecharge",
                                                      @"token":[TTUserInfoManager token],
                                                      @"payment":@"2",
                                                      @"price":[NSString stringWithFormat:@"%.2f",[self.moneyTF.text floatValue]]}
                           Success:^(NSDictionary *responseJsonObject) {
                               NSString *code = [responseJsonObject string_ForKey:@"code"];
                               NSString *msg = [responseJsonObject string_ForKey:@"msg"];
                               NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
                               if ([code isEqualToString:@"1"])//
                               {
                                   NSString *pay_sn = [result string_ForKey:@"pay_sn"];
                                   NSString *pay_value = [result string_ForKey:@"pay_value"];
                                   NSString *notifyUrl = @"http://weike.qb1611.cn/newwxnotify.php";
//                                   notifyUrl = @"http://119.23.66.37/zhuanfa_jiafen/newwxnotify.php";
                                   
                                   [DDWeChatPayManager payWithDescription:self.orderDes Detail:self.orderDes Trade_no:pay_sn Total_fee:[pay_value floatValue] NotifyURL:notifyUrl Block:^(BOOL whether) {
                                       if (whether) {
                                           //刷新用户信息
                                           [self loadUserInfo];
                                               [self.navigationController popViewControllerAnimated:YES];
                                       }
                                       else
                                       {
                                           [ProgressHUD showError:@"支付失败"];
                                       }
                                   }];
                               }
                               else
                               {
                                   [ProgressHUD showError:msg];
                               }

                           } Failure:^(NSError *error) {
                               
                           }];
        }
    }else if(self.buyServicesType == BuyGuangGao || self.buyServicesType == BuyXuFeiGuangGao){
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        [par setObject:[TTUserInfoManager userId] forKey:@"userId"];
        [par setObject:self.day forKey:@"day"];
        [par setObject:[NSString stringWithFormat:@"%.2f",[self.orderPrice floatValue]] forKey:@"money"];
        [par setObject:@"2" forKey:@"payType"];

        if (self.buyServicesType == BuyGuangGao) {
            [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/postAdver" Parameters:par Success:^(NSDictionary *responseJsonObject) {
                NSLog(@"%@",responseJsonObject);
                if ([responseJsonObject[@"code"] isEqualToString:@"1"]){
                    [DDWeChatPayManager payWithDescription:self.orderDes Detail:self.orderDes Trade_no:responseJsonObject[@"result"][@"items"][@"id"] Total_fee:[responseJsonObject[@"result"][@"items"][@"money"] floatValue] NotifyURL:@"http://weike.qb1611.cn/advertWxNotify.php" Block:^(BOOL whether) {
                        if (whether) {
                            //刷新用户信息
                            [self loadUserInfo];
                            [_delegate delegateClick:responseJsonObject[@"result"][@"items"][@"id"]];
                        }
                        else
                        {
                            [ProgressHUD showError:@"支付失败"];
                        }
                    }];
                }
            } Failure:^(NSError *error) {
                
            }];

        }else{
            [par setObject:self.guanggao forKey:@"id"];
            [par setObject:@"2" forKey:@"payType"];
            [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/renewAdInfo" Parameters:par Success:^(NSDictionary *responseJsonObject) {
                NSLog(@"%@",responseJsonObject);
                if ([responseJsonObject[@"code"] isEqualToString:@"1"]){
                    [DDWeChatPayManager payWithDescription:self.orderDes Detail:self.orderDes Trade_no:responseJsonObject[@"result"][@"items"][@"id"] Total_fee:[responseJsonObject[@"result"][@"items"][@"money"] floatValue] NotifyURL:@"http://weike.qb1611.cn/advertWxNotify.php" Block:^(BOOL whether) {
                        if (whether) {
                            //刷新用户信息
                            [self loadUserInfo];
                            [_delegate delegateClick:responseJsonObject[@"result"][@"items"][@"id"]];
                        }
                        else
                        {
                            [ProgressHUD showError:@"支付失败"];
                        }
                    }];
                }
            } Failure:^(NSError *error) {
                
            }];
        }
           }else{
        [TTRequestManager POST:kHTTP Parameters:@{@"r":@"api/user/openQrcodeMember",
                                                  @"token":[TTUserInfoManager token],
                                                  @"payment":@"2",
                                                  @"serviceId":self.goodsId,
                                                  @"typeid":[TTUserInfoManager vip_typeid]}
                       Success:^(NSDictionary *responseJsonObject) {
                           NSString *code = [responseJsonObject string_ForKey:@"code"];
                           NSString *msg = [responseJsonObject string_ForKey:@"msg"];
                           NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
                           if ([code isEqualToString:@"1"])//
                           {
                               NSString *pay_sn = [result string_ForKey:@"pay_sn"];
                               NSString *pay_value = [result string_ForKey:@"pay_value"];
                               NSString *notifyUrl = @"http://weike.qb1611.cn/newwxnotify.php";
//                               notifyUrl = @"http://119.23.66.37/zhuanfa_jiafen/newwxnotify.php";
                               
                               [DDWeChatPayManager payWithDescription:self.orderDes Detail:self.orderDes Trade_no:pay_sn Total_fee:[pay_value floatValue] NotifyURL:notifyUrl Block:^(BOOL whether) {
                                   if (whether) {
                                       //刷新用户信息
                                       [self loadUserInfo];
                                           [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   else
                                   {
                                       [ProgressHUD showError:@"支付失败"];
                                   }
                               }];
                               
                           }
                           else
                           {
                               [ProgressHUD showError:msg];
                           }
                       } Failure:^(NSError *error) {
                           
                       }];
    }
    
}

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (void)loadUserInfo
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/getUserInfo" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"1"])//
        {
            [TTUserInfoManager setUserInfo:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:userInfoDidUpdated object:nil];

                [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } Failure:^(NSError *error) {
    }];
}
@end
