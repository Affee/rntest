//
//  AliCashViewController.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/25.
//  Copyright © 2016年 zichenfang. All rights reserved.
//


#import "AliCashViewController.h"

@interface AliCashViewController ()
@property (strong, nonatomic) IBOutlet UITextField *accountTF;
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *moneyTF;
@property (strong, nonatomic) IBOutlet UILabel *yuELabel;
@property (strong, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation AliCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"提现";

    self.accountTF.layer.borderWidth =1.5;
    self.accountTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.accountTF.layer.cornerRadius = 4;
    self.accountTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.accountTF.leftViewMode = UITextFieldViewModeAlways;

    self.nameTF.layer.borderWidth =1.5;
    self.nameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameTF.layer.cornerRadius = 4;
    self.nameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.moneyTF.layer.borderWidth =1.5;
    self.moneyTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.moneyTF.layer.cornerRadius = 4;
    self.moneyTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.moneyTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
    self.yuELabel.text = [NSString stringWithFormat:@"%@元",[[TTUserInfoManager userInfo] string_ForKey:@"remains"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textChanged
{
    self.okBtn.enabled = (self.accountTF.text.length>0&self.nameTF.text.length>0&self.moneyTF.text.length>0);
}

- (IBAction)ok:(id)sender {
    
    if ([[[TTUserInfoManager userInfo] string_ForKey:@"remains"] floatValue]<10.0||self.moneyTF.text.absoluteString.floatValue>[[[TTUserInfoManager userInfo] string_ForKey:@"remains"] floatValue]) {
        [ProgressHUD showError:@"账户余额不足"];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/withdraw" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:self.accountTF.text.absoluteString forKey:@"alipay_account"];
    [para setObject:self.nameTF.text.absoluteString forKey:@"real_name"];
    [para setObject:self.moneyTF.text.absoluteString forKey:@"cash_value"];

    
    
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"1"])//
        {
            [[[UIAlertView alloc] initWithTitle:@"申请已受理，系统将在3-7个工作日内回复" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
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
