//
//  SendQrCodeViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "SendQrCodeViewController.h"
#import "UIColor+MyColor.h"
#import "PayMentSelectViewController.h"
#import <QiniuSDK.h>
#import "AreaSelectViewController.h"
#import "ShareViewController.h"
#import "CpyImgViewController.h"
#import "UserMsgSetViewController.h"

@interface SendQrCodeViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic) NSInteger nowCodeIndex;
@property (strong,nonatomic) NSDictionary* nowDict;
@property (strong,nonatomic) NSString* selectArea;
@property (nonatomic) BOOL isRefreshMoney;

@end

@implementation SendQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isFromPersonCenter = YES;
    
    self.title = @"发布二维码";
    
    NSMutableAttributedString* jf = [[NSMutableAttributedString alloc]initWithString:@"获取积分"];
    NSMutableAttributedString* cz = [[NSMutableAttributedString alloc]initWithString:@"充值"];
    
    [jf addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, jf.length)];
    [cz addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, cz.length)];
    
    [self.getJfBtn setAttributedTitle:jf forState:UIControlStateNormal];
    [self.wGetJfBtn setAttributedTitle:jf forState:UIControlStateNormal];
    [self.gGetJfBtn setAttributedTitle:jf forState:UIControlStateNormal];
    
    [self.getMoneyBtn setAttributedTitle:cz forState:UIControlStateNormal];
    [self.wGetMoneyBtn setAttributedTitle:cz forState:UIControlStateNormal];
    [self.gGetMoneyBtn setAttributedTitle:cz forState:UIControlStateNormal];
    
    
    UITapGestureRecognizer* codeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(codeImgTag)];
    [self.codeView addGestureRecognizer:codeTap];
    
    UITapGestureRecognizer* wCodeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wCodeImgTag)];
    [self.wCodeView addGestureRecognizer:wCodeTap];
    
    UITapGestureRecognizer* gCodeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gCodeImgTag)];
    [self.gCodeView addGestureRecognizer:gCodeTap];
    
    UITapGestureRecognizer* areaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(areaTapGest)];
    [self.areaView addGestureRecognizer:areaTap];
    
    self.wechatNumTF.delegate = self;
    self.descrTF.delegate = self;
    self.wIntroTV.delegate = self;
    self.gIntroTV.delegate = self;
    
    [self.descrTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)textFieldDidChange:(UITextField*)textField{
    if (textField == self.descrTF && textField.text.length > 50) {
        textField.text = [textField.text substringToIndex:50];
    }
}

-(void)areaTapGest{
    AreaSelectViewController*vc = [[AreaSelectViewController alloc]init];
    [vc setFinishSelect:^(NSString * location) {
        self.selectArea = location;
        self.areaL.text = location;
    }];
    [self.navigationController pushViewController:vc animated:YES];
    self.isRefreshMoney = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.beginIndex != -1) {
        if (self.beginIndex == 0) {
            [self personCarBtnClick:nil];
        }else if (self.beginIndex == 1){
            [self wechatBtnClick:nil];
        }else {
            [self gzhBtnClick:nil];
        }
        self.beginIndex = -1;
    }else{
        int nowIndex = self.mainSV.contentOffset.x / CGRectGetWidth(self.mainSV.bounds);
        [self getBeforeChange:[NSString stringWithFormat:@"%d",nowIndex+1]];
    }
    
}

-(void)makeSubmitBtnTitle:(Boolean)isUpdate{
    [self.submitBtn setTitle:isUpdate?@"更新":@"确认发布" forState:UIControlStateNormal];
}

-(void)makeNoHeadImgAlert{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"检测到您未设置昵称或头像，请先设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UserMsgSetViewController* vc = [[UserMsgSetViewController alloc]init];
        vc.isFromSendCode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)getBeforeChange:(NSString*)type{
    
    [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getUserInfo",
                                             @"token":[TTUserInfoManager token]}
                  Success:^(NSDictionary *responseJsonObject) {
                      if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                          NSDictionary* dict = responseJsonObject[@"result"];
                          if (dict[@"userImg"] == [NSNull null] || dict[@"nickname"] == [NSNull null] || [dict[@"userImg"] length] == 0 || [dict[@"nickname"] length] == 0) {
                              [self makeNoHeadImgAlert];
                          }
                      }else{
                        
                      }
                  } Failure:^(NSError *error) {
                  }];

    
    self.nowDict = nil;
    if (self.isFromPersonCenter && self.beginIndex != -1) {
        int nowIndex = self.mainSV.contentOffset.x / CGRectGetWidth(self.mainSV.bounds);
        if (nowIndex == 0) {
            [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getSelfPerson",
                                                     @"token":[TTUserInfoManager token]}
                          Success:^(NSDictionary *responseJsonObject) {
                              if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                                  NSDictionary* dict = responseJsonObject[@"result"];
                                  if ([dict[@"userId"] length] == 0) {
                                      [self makeSubmitBtnTitle:NO];
                                  }else{
                                      [self.codeIV sd_setImageWithURL:[NSURL URLWithString:dict[@"qrcode"]]];
                                      self.wechatNumTF.text = dict[@"wechatName"];
                                      self.descrTF.text = dict[@"description"];
                                      [self.sexSC setSelectedSegmentIndex:[dict[@"sex"] isEqualToString:@"男"]?0:1];
                                      self.areaL.text = dict[@"userArea"];
                                      [self makeSubmitBtnTitle:YES];
                                  }
                              }else{
                                  //                                      [ProgressHUD showError:responseJsonObject[@"msg"]];
                                  [self makeSubmitBtnTitle:NO];
                              }
                          } Failure:^(NSError *error) {
                              
                          }];
        }else if (nowIndex == 1){
            [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getSelfGroup",
                                                     @"token":[TTUserInfoManager token]}
                          Success:^(NSDictionary *responseJsonObject) {
                              if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                                  NSDictionary* dict = responseJsonObject[@"result"];
                                  if ([dict[@"userId"] length] == 0) {
                                      [self makeSubmitBtnTitle:NO];
                                  }else{
                                      [self.wCodeIV sd_setImageWithURL:[NSURL URLWithString:dict[@"qrcode"]]];
                                      self.wIntroTV.text = dict[@"description"];
                                      [self makeSubmitBtnTitle:YES];
                                  }
                              }else{
                                  //                                      [ProgressHUD showError:responseJsonObject[@"msg"]];
                                  [self makeSubmitBtnTitle:NO];
                              }
                          } Failure:^(NSError *error) {
                              
                          }];
        }else{
            [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getSelfPublic",
                                                     @"token":[TTUserInfoManager token]}
                          Success:^(NSDictionary *responseJsonObject) {
                              if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                                  NSDictionary* dict = responseJsonObject[@"result"];
                                  if ([dict[@"userId"] length] == 0) {
                                      [self makeSubmitBtnTitle:NO];
                                  }else{
                                      [self.gCodeIV sd_setImageWithURL:[NSURL URLWithString:dict[@"qrcode"]]];
                                      self.gIntroTV.text = dict[@"description"];
                                      [self makeSubmitBtnTitle:YES];
                                  }
                              }else{
                                  //                                      [ProgressHUD showError:responseJsonObject[@"msg"]];
                                  [self makeSubmitBtnTitle:NO];
                              }
                          } Failure:^(NSError *error) {
                              
                          }];
        }
        self.isRefreshMoney = NO;
    }

    
    [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/createInfo",
                                             @"token":[TTUserInfoManager token],
                                             @"type":type}
                  Success:^(NSDictionary *responseJsonObject) {
                      if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                          self.nowDict = responseJsonObject[@"result"];
                          if ([type isEqualToString:@"1"]) {
                              NSDictionary* result = responseJsonObject[@"result"];
                              if ([result[@"pay"] integerValue] == 1) {
                                  [self.freeView removeFromSuperview];
                                  [self.nowJFL setText:[NSString stringWithFormat:@"积分发布,需要%d积分,剩余%d积分",[result[@"payScore"] intValue],[result[@"userScore"] intValue]]];
                                  [self.nowMoney setText:[NSString stringWithFormat:@"付费发布,需要%.2f元,剩余%.2f元",[result[@"payMoney"] floatValue],[result[@"qrcodeRemains"] floatValue]]];
                              }else{
                                  [self.jfView removeFromSuperview];
                                  [self.moneyView removeFromSuperview];
                              }
                          }else if ([type isEqualToString:@"2"]) {
                              NSDictionary* result = responseJsonObject[@"result"];
                              if ([result[@"pay"] integerValue] == 1) {
                                  [self.wFreeView removeFromSuperview];
                                  [self.wNowJfL setText:[NSString stringWithFormat:@"积分发布,需要%d积分,剩余%d积分",[result[@"payScore"] intValue],[result[@"userScore"] intValue]]];
                                  [self.wNowMoneyL setText:[NSString stringWithFormat:@"付费发布,需要%.2f元,剩余%.2f元",[result[@"payMoney"] floatValue],[result[@"qrcodeRemains"] floatValue]]];
                              }else{
                                  [self.wJFView removeFromSuperview];
                                  [self.wMoneyView removeFromSuperview];
                              }
                          }else if ([type isEqualToString:@"3"]) {
                              NSDictionary* result = responseJsonObject[@"result"];
                              if ([result[@"pay"] integerValue] == 1) {
                                  [self.gFreeView removeFromSuperview];
                                  [self.gNowJFL setText:[NSString stringWithFormat:@"积分发布,需要%d积分,剩余%d积分",[result[@"payScore"] intValue],[result[@"userScore"] intValue]]];
                                  [self.gNowMoneyL setText:[NSString stringWithFormat:@"付费发布,需要%.2f元,剩余%.2f元",[result[@"payMoney"] floatValue],[result[@"qrcodeRemains"] floatValue]]];
                              }else{
                                  [self.gJFView removeFromSuperview];
                                  [self.gMoneyView removeFromSuperview];
                              }
                          }
                      }else{
                          [ProgressHUD showError:responseJsonObject[@"msg"]];
                      }
                  } Failure:^(NSError *error) {
                      
                  }];

    
}


-(void)codeImgTag{
    self.nowCodeIndex = 0;
    [self showImgPicker];
}

-(void)wCodeImgTag{
    self.nowCodeIndex = 1;
    [self showImgPicker];
}

-(void)gCodeImgTag{
    self.nowCodeIndex = 2;
    [self showImgPicker];
}

-(void)showImgPicker{
    UIImagePickerController* vc = [[UIImagePickerController alloc]init];
    vc.navigationBar.tintColor = [UIColor redColor];
    vc.navigationBar.barTintColor = [UIColor redColor];
    
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"您最多可输入100个字"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length < 1) {
        textView.text = @"您最多可输入100个字";
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (textView.text.length >= 100) {
        return NO;
    }
    return YES;
}

#pragma mark - UITextfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* img = info[UIImagePickerControllerOriginalImage];
    if (self.nowCodeIndex == 0) {
        self.codeIV.image = img;
    }else if (self.nowCodeIndex == 1){
        self.wCodeIV.image = img;
    }else if (self.nowCodeIndex == 2){
        self.gCodeIV.image = img;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSDictionary *attributes_nulltitle = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                           
                                           NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [viewController.navigationItem.rightBarButtonItem setTitleTextAttributes:attributes_nulltitle forState:UIControlStateNormal];
}

-(void)dismissBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)personCarBtnClick:(id)sender {
    [self.personCarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gzhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.personCarBtn setTitleColor:[UIColor colorWithHexString:@"ef5350"] forState:UIControlStateNormal];
    
    [self.nowIndexTipL setFrame:CGRectMake(CGRectGetMinX(self.personCarBtn.frame), CGRectGetMaxY(self.personCarBtn.bounds) - 2, CGRectGetWidth(self.personCarBtn.bounds), 2)];
    [self.mainSV setContentOffset:CGPointMake(0, 0) animated:NO];
    
    [self getBeforeChange:@"1"];
}

- (IBAction)wechatBtnClick:(id)sender {
    [self.personCarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gzhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:[UIColor colorWithHexString:@"ef5350"] forState:UIControlStateNormal];
    [self.nowIndexTipL setFrame:CGRectMake(CGRectGetMinX(self.wechatBtn.frame), CGRectGetMaxY(self.personCarBtn.bounds) - 2, CGRectGetWidth(self.personCarBtn.bounds), 2)];
    [self.mainSV setContentOffset:CGPointMake(CGRectGetWidth(self.mainSV.bounds), 0) animated:NO];
    
    [self getBeforeChange:@"2"];
}

- (IBAction)gzhBtnClick:(id)sender {
    [self.personCarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gzhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gzhBtn setTitleColor:[UIColor colorWithHexString:@"ef5350"] forState:UIControlStateNormal];
    [self.nowIndexTipL setFrame:CGRectMake(CGRectGetMinX(self.gzhBtn.frame), CGRectGetMaxY(self.personCarBtn.bounds) - 2, CGRectGetWidth(self.personCarBtn.bounds), 2)];
    [self.mainSV setContentOffset:CGPointMake(CGRectGetWidth(self.mainSV.bounds)*2, 0) animated:NO];
    
    [self getBeforeChange:@"3"];

}
- (IBAction)getJFBtnClick:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"如何获取积分" message:@"任意添加一个好友获得积分\n通过每天签到获取积分\n通过邀请好友，分享获取积分" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* getAction = [UIAlertAction actionWithTitle:@"我要赚积分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getUserInfo",
                                                 @"token":[TTUserInfoManager token]}
                      Success:^(NSDictionary *responseJsonObject) {
                          if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                              ShareViewController* vc = [[ShareViewController alloc]init];
                              [vc setClickCpyImg:^{
                                  CpyImgViewController* cvc = [[CpyImgViewController alloc]init];
                                  cvc.hidesBottomBarWhenPushed = YES;
                                  [self.navigationController pushViewController:cvc animated:YES];
                                  self.isRefreshMoney = NO;
                              }];
                              vc.sharelink = responseJsonObject[@"result"][@"share_link"];
                              vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                              [self presentViewController:vc animated:NO completion:nil];
                          }else{
                              [ProgressHUD showError:responseJsonObject[@"msg"]];
                          }
                      } Failure:^(NSError *error) {
                          
                      }];
    }];
    
    [alert addAction:getAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)getMoneyBtnClick:(id)sender {
    PayMentSelectViewController* vc = [[PayMentSelectViewController alloc]init];
    vc.buyServicesType = BuyMoney;
    vc.orderDes = @"充值";
    self.isRefreshMoney = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)jfSelectBtnClick:(id)sender {
    int nowIndex = self.mainSV.contentOffset.x / CGRectGetWidth(self.mainSV.bounds);
    if (nowIndex == 0) {
        [self.jfBtn setBackgroundImage:[UIImage imageNamed:@"Select"] forState:UIControlStateNormal];
        self.jfBtn.tag = 1001;
        
        [self.moneyBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        self.moneyBtn.tag = 0;
    }else if (nowIndex == 1) {
        [self.wJFBtn setBackgroundImage:[UIImage imageNamed:@"Select"] forState:UIControlStateNormal];
        self.wJFBtn.tag = 1001;
        
        [self.wMoneyBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        self.wMoneyBtn.tag = 0;
    }else if (nowIndex == 2) {
        [self.gJFBtn setBackgroundImage:[UIImage imageNamed:@"Select"] forState:UIControlStateNormal];
        self.gJFBtn.tag = 1001;
        
        [self.gMoneyBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        self.gMoneyBtn.tag = 0;
    }
}

- (IBAction)moneySelectBtnClick:(id)sender {
    int nowIndex = self.mainSV.contentOffset.x / CGRectGetWidth(self.mainSV.bounds);
    if (nowIndex == 0) {
        [self.moneyBtn setBackgroundImage:[UIImage imageNamed:@"Select"] forState:UIControlStateNormal];
        self.moneyBtn.tag = 1001;
        
        [self.jfBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        self.jfBtn.tag = 0;
    }else if (nowIndex == 1) {
        [self.wMoneyBtn setBackgroundImage:[UIImage imageNamed:@"Select"] forState:UIControlStateNormal];
        self.wMoneyBtn.tag = 1001;
        
        [self.wJFBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        self.wJFBtn.tag = 0;
    }else if (nowIndex == 2) {
        [self.gMoneyBtn setBackgroundImage:[UIImage imageNamed:@"Select"] forState:UIControlStateNormal];
        self.gMoneyBtn.tag = 1001;
        
        [self.gJFBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        self.gJFBtn.tag = 0;
    }
}
- (IBAction)sendBtnClick:(id)sender {
    if (self.nowDict == nil) {
        [ProgressHUD showError:@"获取基本信息种，请稍等"];
    }else{
        int nowIndex = self.mainSV.contentOffset.x / CGRectGetWidth(self.mainSV.bounds);
        if (nowIndex == 0) {
            if (self.codeIV.image == nil || self.wechatNumTF.text.length == 0 || self.descrTF.text.length == 0 || self.areaL.text.length == 0) {
                [ProgressHUD showError:@"请填写信息完整"];
            }else{
                [self submitDataWithType:nowIndex];
            }
        }else if (nowIndex == 1){
            if (self.wCodeIV.image == nil || self.wIntroTV.text.length == 0) {
                [ProgressHUD showError:@"请填写信息完整"];
            }else{
                [self submitDataWithType:nowIndex];
            }
        }else if (nowIndex == 2){
            if (self.gCodeIV.image == nil || self.gIntroTV.text.length == 0) {
                [ProgressHUD showError:@"请填写信息完整"];
            }else{
                [self submitDataWithType:nowIndex];
            }
        }
    }
}

-(void)submitDataWithType:(NSInteger)type{
    [ProgressHUD show:@"请求中..."];
    [TTRequestManager GET:[NSString stringWithFormat:@"%@?r=api/Qrcode/GetImgCode",kHTTP] Parameters:@{@"token":[TTUserInfoManager token]} Success:^(NSDictionary *responseJsonObject) {
        if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
            NSString* keyToken = responseJsonObject[@"result"];
            QNConfiguration* config = [QNConfiguration build:^(QNConfigurationBuilder* builder){
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:[QNResolver systemResolver]];
                builder.zone = [QNZone zone0];
            }];
                                       
            QNUploadManager* uploadManager = [[QNUploadManager alloc]initWithConfiguration:config];
            NSData* imgData = nil;
            if (type == 0) {
                imgData = UIImageJPEGRepresentation(self.codeIV.image,0.5);
            }else if (type == 1){
                imgData = UIImageJPEGRepresentation(self.wCodeIV.image,0.5);
            }else if (type == 2){
                imgData = UIImageJPEGRepresentation(self.gCodeIV.image,0.5);
            }
            
            [uploadManager putData:imgData key:[NSString stringWithFormat:@"%@_%.0f",[TTUserInfoManager token],[[NSDate date] timeIntervalSince1970]*1000*1000] token:keyToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                NSLog(@"info ===%@",info);
                NSLog(@"resp ===%@",resp);
                
                NSString* url = [NSString stringWithFormat:@"http://oqwhwbs1c.bkt.clouddn.com/%@",key];
                
                NSMutableDictionary* dataDict = [NSMutableDictionary new];
                [dataDict setObject:@"api/qrcode/updateInfo" forKey:@"r"];
                [dataDict setObject:[TTUserInfoManager token] forKey:@"token"];
                [dataDict setObject:[NSString stringWithFormat:@"%ld",(long)type + 1] forKey:@"type"];
                [dataDict setObject:url forKey:@"qrcode"];
                
                
                if (type == 0) {
                    if ([self.nowDict[@"pay"] integerValue] == 1) {
                        [dataDict setObject:self.moneyBtn.tag == 1001?@"2":@"1" forKey:@"payType"];
                    }
                    [dataDict setObject:self.wechatNumTF.text forKey:@"wechatName"];
                    [dataDict setObject:self.sexSC.selectedSegmentIndex==0?@"男":@"女" forKey:@"sex"];
                    [dataDict setObject:self.areaL.text forKey:@"userArea"];
                    [dataDict setObject:self.descrTF.text forKey:@"description"];
                }else if (type == 1){
                    if ([self.nowDict[@"pay"] integerValue] == 1) {
                        [dataDict setObject:self.wMoneyBtn.tag == 1001?@"2":@"1" forKey:@"payType"];
                    }
                    [dataDict setObject:self.wIntroTV.text forKey:@"description"];
                }else if (type == 2){
                    if ([self.nowDict[@"pay"] integerValue] == 1) {
                        [dataDict setObject:self.gMoneyBtn.tag == 1001?@"2":@"1" forKey:@"payType"];
                    }
                    [dataDict setObject:self.gIntroTV.text forKey:@"description"];
                }
                
                [TTRequestManager POST:kHTTP Parameters:dataDict Success:^(NSDictionary *responseJsonObject) {
                    if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [ProgressHUD dismiss];
                    }else{
                        [ProgressHUD showError:responseJsonObject[@"msg"]];
                    }
                } Failure:^(NSError *error) {
                    [ProgressHUD dismiss];
                }];

                
            } option:nil];
        }else{
            [ProgressHUD showError:responseJsonObject[@"msg"]];
        }
    } Failure:^(NSError *error) {
        [ProgressHUD dismiss];
    }];
    
}
@end
