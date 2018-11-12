//
//  LoginView.h
//  weishang_vip
//
//  Created by zichenfang on 16/6/27.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) IBOutlet UIButton *okBtn;
@property (strong, nonatomic) IBOutlet UITextField *invitePhoneTF;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@end
