//
//  MainFooterCollectionReusableView.h
//  WeiDianKe
//
//  Created by flappybird on 16/11/10.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainFooterCollectionReusableViewDelegate <NSObject>
@optional
- (void)footerClick:(NSString *)type Int:(NSInteger)num;
@end
@interface MainFooterCollectionReusableView : UICollectionReusableView

@property (strong, nonatomic) id target;
@property (weak, nonatomic) IBOutlet UIView *midDesView;
@property (strong,nonatomic) void(^clickMarquee)(NSString* url);



//APP配置信息赋值
- (void)setAppConfigInfo:(NSDictionary *)info;
//用户信息赋值
- (void)setUserInfo:(NSDictionary *)info;

//
- (void)setIsReadyForSale:(BOOL)isReadyForSale;
@property (nonatomic, weak) id<MainFooterCollectionReusableViewDelegate> delegate;
@end
