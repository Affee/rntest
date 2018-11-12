//
//  MainViewController.h
//  weishang_vip
//
//  Created by zichenfang on 16/6/21.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "SSViewController.h"

@interface MainViewController : SSViewController
@property (strong, nonatomic) NSDictionary *appConfigInfo;//APP配置信息
@property (strong, nonatomic) NSMutableArray *guanggaoArray;
- (void)showLoginView;
@end
