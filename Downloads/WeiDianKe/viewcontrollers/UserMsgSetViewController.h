//
//  UserMsgSetViewController.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/16.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMsgSetViewController : UIViewController
@property (strong,nonatomic) NSDictionary* data;
@property (nonatomic) BOOL isFromSendCode;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)submitBtnClick:(id)sender;

@end
