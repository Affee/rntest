//
//  MainHeaderCollectionReusableView.m
//  WeiDianKe
//
//  Created by flappybird on 16/11/10.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "MainHeaderCollectionReusableView.h"

@implementation MainHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.statesBtn addTarget:self.target action:@selector(startOrPauseFansing) forControlEvents:UIControlEventTouchUpInside];
    [self.login_out_btn addTarget:self.target action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.bannerBtn addTarget:self.target action:@selector(goBanner) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setBannerImgViewWithUrl:(NSString*)url{
//    NSArray * array = [url componentsSeparatedByString:@"80"];
    [self.bannerImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kPlaceHolderImg];
}

-(void)setBannerImgView:(UIImageView *)bannerImgView{
    if (_bannerImgView!=bannerImgView) {
        _bannerImgView = bannerImgView;
    }
}

@end
