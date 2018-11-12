//
//  PersonCardDetailViewController.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/11.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCardDetailViewController : UIViewController

@property (strong,nonatomic) NSDictionary* dataDict;
@property (nonatomic) BOOL isPerson;

@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameL;
@property (weak, nonatomic) IBOutlet UILabel *wechatNumL;
@property (weak, nonatomic) IBOutlet UILabel *locationL;
@property (weak, nonatomic) IBOutlet UILabel *personNumL;
@property (weak, nonatomic) IBOutlet UITextView *descL;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeIV;
@property (weak, nonatomic) IBOutlet UIButton *cpyBtn;
@property (weak, nonatomic) IBOutlet UIButton *impBtn;

- (IBAction)cpyBtnClick:(id)sender;
- (IBAction)saveQrcodeBtnClick:(id)sender;
- (IBAction)importBookBtnClick:(id)sender;

@end
