//
//  PayMentTableViewCell.m
//  WeiDianKe
//
//  Created by flappybird on 16/11/14.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "PayMentTableViewCell.h"

@implementation PayMentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUnionLHidden:(BOOL)hide{
    self.unionL.text = hide?@"":@"信用卡.银行卡支付，无需开通网银";
}

@end
