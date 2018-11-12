//
//  PayMentSelectViewController.h
//  WeiDianKe
//
//  Created by flappybird on 16/11/14.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "SSViewController.h"
//购买类型
typedef NS_ENUM(NSInteger, BuyServicesType) {
    BuyServicesVipType = 0,//购买VIP
    BuyServicesLuckyCodeType = 1,//购买幸运码
    BuyMoney = 2,//充值
    BuyZizuan = 3,//购买紫钻
    BuyGuangGao = 4,//购买广告
    BuyXuFeiGuangGao = 5
};
@protocol meDelegateViewController <NSObject>

-(void)delegateClick:(NSString *)meStr;

@end


@interface PayMentSelectViewController : SSViewController
@property(nonatomic,assign)BuyServicesType buyServicesType;
@property(nonatomic,strong)NSString *guanggao;
@property(nonatomic,strong)NSString *day;
@property(nonatomic,strong)NSString *orderDes;//订单描述
@property(nonatomic,strong)NSString *orderPrice;//订单价格
@property(nonatomic,strong)NSString *goodsId;//VIP ID或者幸运码的ID
@property(strong,nonatomic)id<meDelegateViewController>delegate;
@end
