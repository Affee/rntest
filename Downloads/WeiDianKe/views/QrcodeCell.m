//
//  QrcodeCell.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "QrcodeCell.h"
#import "UIColor+MyColor.h"

@interface QrcodeCell()

@property (strong,nonatomic) NSDictionary*dict;

@end

@implementation QrcodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithDictionary:(NSDictionary *)dict andType:(int)type{
    self.dict = dict;
    self.headBottomBackL.hidden = NO;
    self.bottomBackL.hidden = NO;
    self.HeaderTopBackL.hidden = NO;
    self.bottomTipL.hidden = NO;
    self.headerTopTipL.hidden = NO;
    self.headBottomTipL.hidden = NO;
    if (type == 1) {
        self.headBottomBackL.hidden = NO;
        [self.headBottomBackL setBackgroundColor:[UIColor colorWithHexString:@"9012fe"]];
        [self.headBottomTipL setText:@"紫钻会员"];
        
        self.bottomBackL.hidden = NO;
        [self.bottomBackL setBackgroundColor:[UIColor colorWithHexString:@"#9012fe"]];

        if ([self.zhonglei isEqualToString:@"1"]) {
            [self.bottomTipL setText:[NSString stringWithFormat:@"紫钻会员置顶中.剩余%.0f秒",[dict[@"gr_purple_expiration"] intValue] - [[NSDate date] timeIntervalSince1970]]];
        }else if ([self.zhonglei isEqualToString:@"2"]){
                [self.bottomTipL setText:[NSString stringWithFormat:@"紫钻会员置顶中.剩余%.0f秒",[dict[@"wx_purple_expiration"] intValue] - [[NSDate date] timeIntervalSince1970]]];
        }else{
                [self.bottomTipL setText:[NSString stringWithFormat:@"紫钻会员置顶中.剩余%.0f秒",[dict[@"gzh_purple_expiration"] intValue] - [[NSDate date] timeIntervalSince1970]]];
        }
        
        [self.addBtn setBackgroundColor:[UIColor colorWithHexString:@"#9012fe"]];
    }else if (type == 2){
        self.headBottomBackL.hidden = YES;
        self.headBottomTipL.hidden = YES;

        self.bottomTipL.hidden = NO;
        self.bottomBackL.hidden = NO;
        [self.bottomTipL setText:@"红钻会员暴机中"];
        [self.headBottomBackL setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];
        [self.bottomBackL setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];
        [self.addBtn setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];
    }else if (type == 3){
        self.headBottomBackL.hidden = YES;
        self.headBottomTipL.hidden = YES;
        [self.bottomBackL setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];
        self.bottomTipL.hidden = YES;
        self.bottomBackL.hidden = YES;
        
        [self.addBtn setBackgroundColor:[UIColor colorWithHexString:@"4990e2"]];
    }else if (type == 4){
        self.headBottomBackL.hidden = NO;
        self.bottomTipL.hidden = YES;
        self.bottomBackL.hidden = YES;
        if ([self.zhonglei isEqualToString:@"1"]) {
            if ([dict[@"gr_red_expiration"] intValue] - [[NSDate date] timeIntervalSince1970] > 0) {
                self.bottomTipL.hidden = NO;
                self.bottomBackL.hidden = NO;
                [self.bottomTipL setText:@"红钻会员暴机中"];
                [self.bottomBackL setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];
            }
        }else if ([self.zhonglei isEqualToString:@"2"]){
            if ([dict[@"wx_red_expiration"] intValue] - [[NSDate date] timeIntervalSince1970] > 0) {
                self.bottomTipL.hidden = NO;
                self.bottomBackL.hidden = NO;
                [self.bottomTipL setText:@"红钻会员暴机中"];
                [self.bottomBackL setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];
            }
        }else{
            if ([dict[@"gzh_red_expiration"] intValue] - [[NSDate date] timeIntervalSince1970] > 0) {
                self.bottomTipL.hidden = NO;
                self.bottomBackL.hidden = NO;
                [self.bottomTipL setText:@"红钻会员暴机中"];
                [self.bottomBackL setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];
            }
        }
        
        [self.headBottomBackL setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];
        [self.headBottomTipL setText:@"VIP"];
        
        [self.bottomBackL setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];
        [self.addBtn setBackgroundColor:[UIColor colorWithHexString:@"e2333c"]];

    }

    if ([dict[@"popularity"] integerValue] == 0) {
        self.headerTopTipL.hidden = YES;
        self.HeaderTopBackL.hidden = YES;
    }else{
        self.headerTopTipL.hidden = NO;
        self.HeaderTopBackL.hidden = NO;
        self.headerTopTipL.text = dict[@"popularity"];
    }
    
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:dict[@"userImg"]]];
    [self.userNameL setText:dict[@"nickname"]];
    [self.introL setText:dict[@"description"]];
}

- (IBAction)addBtnClick:(id)sender {
    self.clickAddBtn(self.dict);
}
@end
