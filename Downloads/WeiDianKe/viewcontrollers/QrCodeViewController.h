//
//  QrCodeViewController.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QrCodeViewController : SSViewController

@property (weak, nonatomic) IBOutlet UIButton *personCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *gzhBtn;
@property (weak, nonatomic) IBOutlet UILabel *nowIndexTipL;

- (IBAction)personCarBtnClick:(id)sender;
- (IBAction)wechatBtnClick:(id)sender;
- (IBAction)gzhBtnClick:(id)sender;

- (IBAction)sendQrCodeBtnClick:(id)sender;
- (IBAction)upServiceBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
