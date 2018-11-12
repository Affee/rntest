//
//  SignView.h
//  weishang_vip
//
//  Created by zichenfang on 16/6/27.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignView : UIView
@property (strong, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UIButton *vipBtn;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (strong, nonatomic) IBOutlet UILabel *label_3;
@property (strong, nonatomic) IBOutlet UIView *openVipView;


@end
