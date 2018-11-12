//
//  AreaSelectViewController.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/12.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaSelectViewController : UIViewController

@property (strong,nonatomic) void(^finishSelect)(NSString* loc);

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
