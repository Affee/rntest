//
//  SendQrCodeViewController.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QNResolver.h>
#import <QNNetworkInfo.h>
#import <QNDnsManager.h>

@interface SendQrCodeViewController : UIViewController
@property (nonatomic) bool isFromPersonCenter;
@property (nonatomic) NSInteger beginIndex;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIButton *personCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *gzhBtn;
@property (weak, nonatomic) IBOutlet UILabel *nowIndexTipL;

@property (weak, nonatomic) IBOutlet UIScrollView *mainSV;

- (IBAction)personCarBtnClick:(id)sender;
- (IBAction)wechatBtnClick:(id)sender;
- (IBAction)gzhBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIImageView *codeIV;
@property (weak, nonatomic) IBOutlet UITextField *wechatNumTF;
@property (weak, nonatomic) IBOutlet UITextField *descrTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSC;
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UILabel *nowJFL;
@property (weak, nonatomic) IBOutlet UIButton *jfBtn;
@property (weak, nonatomic) IBOutlet UILabel *areaL;

@property (weak, nonatomic) IBOutlet UILabel *nowMoney;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIView *jfView;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UIView *freeView;
@property (weak, nonatomic) IBOutlet UIButton *getJfBtn;
@property (weak, nonatomic) IBOutlet UIButton *getMoneyBtn;




- (IBAction)getJFBtnClick:(id)sender;
- (IBAction)getMoneyBtnClick:(id)sender;
- (IBAction)jfSelectBtnClick:(id)sender;
- (IBAction)moneySelectBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *wJFView;
@property (weak, nonatomic) IBOutlet UIView *wMoneyView;
@property (weak, nonatomic) IBOutlet UILabel *wNowMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *wNowJfL;
@property (weak, nonatomic) IBOutlet UITextView *wIntroTV;
@property (weak, nonatomic) IBOutlet UIImageView *wCodeIV;
@property (weak, nonatomic) IBOutlet UIView *wCodeView;
@property (weak, nonatomic) IBOutlet UIView *wFreeView;
@property (weak, nonatomic) IBOutlet UIButton *wJFBtn;
@property (weak, nonatomic) IBOutlet UIButton *wMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *wGetJfBtn;
@property (weak, nonatomic) IBOutlet UIButton *wGetMoneyBtn;

@property (weak, nonatomic) IBOutlet UIView *gCodeView;
@property (weak, nonatomic) IBOutlet UITextView *gIntroTV;
@property (weak, nonatomic) IBOutlet UIView *gJFView;
@property (weak, nonatomic) IBOutlet UIView *gFreeView;
@property (weak, nonatomic) IBOutlet UIView *gMoneyView;
@property (weak, nonatomic) IBOutlet UILabel *gNowMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *gNowJFL;
@property (weak, nonatomic) IBOutlet UIImageView *gCodeIV;
@property (weak, nonatomic) IBOutlet UIButton *gJFBtn;
@property (weak, nonatomic) IBOutlet UIButton *gMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *gGetJfBtn;
@property (weak, nonatomic) IBOutlet UIButton *gGetMoneyBtn;

- (IBAction)sendBtnClick:(id)sender;

@end
