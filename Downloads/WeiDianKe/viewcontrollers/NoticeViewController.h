//
//  NoticeViewController.h
//  WeiDianKe
//
//  Created by lqz on 2017/7/4.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)NSArray *dataArray;
@end
