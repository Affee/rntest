//
//  ShareViewController.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/12.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController

@property (strong,nonatomic) NSString* sharelink;
@property (strong,nonatomic) void(^clickCpyImg)();

@property (weak, nonatomic) IBOutlet UIView *wechat;
@property (weak, nonatomic) IBOutlet UIView *timeline;
@property (weak, nonatomic) IBOutlet UIView *cpylink;
@property (weak, nonatomic) IBOutlet UIView *cpyphoto;
@property (weak, nonatomic) IBOutlet UIView *qzone;
@property (weak, nonatomic) IBOutlet UIView *qq;

@property (weak, nonatomic) IBOutlet UIView *borderView;




@end
