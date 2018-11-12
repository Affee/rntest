//
//  VipServiceCell.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/11.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VipServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *introL;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UIImageView *driL;
@property(strong,nonatomic)UIView *lineView;
-(void)setupWithDict:(NSDictionary*)dict isShop:(BOOL)isShop forRow:(NSInteger)row;

@end
