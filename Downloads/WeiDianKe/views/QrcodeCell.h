//
//  QrcodeCell.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QrcodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UILabel *introL;

@property (strong,nonatomic)NSString *zhonglei;
@property (weak, nonatomic) IBOutlet UILabel *bottomBackL;
@property (weak, nonatomic) IBOutlet UILabel *bottomTipL;
@property (weak, nonatomic) IBOutlet UILabel *headBottomBackL;
@property (weak, nonatomic) IBOutlet UILabel *headBottomTipL;
@property (weak, nonatomic) IBOutlet UILabel *HeaderTopBackL;
@property (weak, nonatomic) IBOutlet UILabel *headerTopTipL;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnClick:(id)sender;

@property (strong,nonatomic) void(^clickAddBtn)(NSDictionary* dict);

-(void)setupWithDictionary:(NSDictionary*)dict andType:(int)type;
@end
