//
//  PersonCenterViewController.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeViewController.h"
@interface PersonCenterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *explainView;
@property (weak, nonatomic) IBOutlet UIView *midDesView;
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;
@property (weak, nonatomic) IBOutlet UIImageView *noticeImg;
@property(strong,nonatomic) NSString *backS;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadIV;
@property (weak, nonatomic) IBOutlet UILabel *usernameL;
@property (weak, nonatomic) IBOutlet UILabel *myJFL;
@property (weak, nonatomic) IBOutlet UILabel *myMoneyL;
@property (weak, nonatomic) IBOutlet UIView *jfView;
@property (weak, nonatomic) IBOutlet UIView *moneyView;

@property (weak, nonatomic) IBOutlet UILabel *vipTipL;
@property (weak, nonatomic) IBOutlet UILabel *pVipTipL;

@property (weak, nonatomic) IBOutlet UIView *vipView;
@property (weak, nonatomic) IBOutlet UIView *puperVipView;
@property (weak, nonatomic) IBOutlet UIView *personCardView;
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIView *gzhView;
@property (weak, nonatomic) IBOutlet UIView *bookView;
@property (weak, nonatomic) IBOutlet UIView *makeMoneyView;
@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;

@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@end
