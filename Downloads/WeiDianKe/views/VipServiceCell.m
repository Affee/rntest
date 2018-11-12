//
//  VipServiceCell.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/11.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "VipServiceCell.h"

@implementation VipServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithDict:(NSDictionary *)dict isShop:(BOOL)isShop forRow:(NSInteger)row{
    self.getBtn.hidden = !isShop;
    self.driL.hidden = isShop;
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:dict[@"serviceImg"]]];
    [self.titleL setText:dict[@"serviceName"]];
    [self.introL setText:dict[@"description"]];

}

@end
