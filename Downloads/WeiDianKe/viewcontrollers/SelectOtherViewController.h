//
//  SelectOtherViewController.h
//  weishang_vip
//
//  Created by zichenfang on 16/6/24.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "SSViewController.h"
#import "TTBlockClass.h"

@interface SelectOtherViewController : SSViewController
@property (strong, nonatomic) NSArray *menus;
@property (strong, nonatomic) TTBlockWithString block;
@property (assign, nonatomic) NSInteger selectIndex;

@end
