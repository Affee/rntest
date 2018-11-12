//
//  WebViewController.h
//  weishang_vip
//
//  Created by zichenfang on 16/6/27.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "SSViewController.h"

@interface WebViewController : SSViewController
@property (strong, nonatomic) NSURL *url;
@property (assign, nonatomic) BOOL isPresent;
- (void)reloadUrl;
@end
