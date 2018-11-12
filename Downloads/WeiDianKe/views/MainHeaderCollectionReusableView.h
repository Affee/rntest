//
//  MainHeaderCollectionReusableView.h
//  WeiDianKe
//
//  Created by flappybird on 16/11/10.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeaderCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIButton *statesBtn;
@property (strong, nonatomic) IBOutlet UIButton *login_out_btn;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImgView;
@property (strong, nonatomic) IBOutlet UIButton *bannerBtn;

@property (strong, nonatomic) id target;

-(void)setBannerImgViewWithUrl:(NSString*)url;

@end
